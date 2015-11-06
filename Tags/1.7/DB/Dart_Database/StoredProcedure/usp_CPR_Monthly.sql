SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Monthly]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Monthly]
GO
CREATE PROCEDURE [dbo].[usp_CPR_Monthly]
	@System VARCHAR(10),
	@Start_Date DATETIME,
	@End_Date DATETIME
AS
BEGIN
	IF OBJECT_ID('tempdb..#claim_new_all') IS NOT NULL DROP TABLE #claim_new_all
	IF OBJECT_ID('tempdb..#claim_open_all') IS NOT NULL DROP TABLE #claim_open_all
	IF OBJECT_ID('tempdb..#claim_closure') IS NOT NULL DROP TABLE #claim_closure
	IF OBJECT_ID('tempdb..#claim_list') IS NOT NULL DROP TABLE #claim_list
	IF OBJECT_ID('tempdb..#pre_claim_list') IS NOT NULL DROP TABLE #pre_claim_list
	
	-- PREPARE DATA BEFORE QUERYING
	
	-- Determine the period type
	DECLARE @Period_Type INT = [dbo].udf_GetCPR_PeriodType(@Start_Date, @End_Date)
	
	-- Determine the current reporting date
	DECLARE @Reporting_Date datetime = [dbo].udf_GetCPR_ReportingDate(@System, @Period_Type, @End_Date)
	
	-- Determine the claim list
	SELECT *
	INTO #claim_list
	FROM [dbo].[udf_GetCPR_ClaimList](@System, @Period_Type, @Reporting_Date)
	
	DECLARE @Reporting_Date_pre datetime
	IF @Period_Type = -1
	BEGIN
		-- Determine the previous reporting date
		SET @Reporting_Date_pre = [dbo].udf_GetCPR_ReportingDate_Pre(@System, @Start_Date)
	END
	
	-- Determine the previous claim list
	SELECT *
	INTO #pre_claim_list
	FROM [dbo].[udf_GetCPR_PreClaimList](@System, @Period_Type, @Reporting_Date_pre)
	
	-- NEW CLAIMS
	SELECT [AgencyName],[Sub_Category],[Group],[Team],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claims_Officer_Name],[Claim_No]
	INTO #claim_new_all
	FROM #claim_list
	WHERE ISNULL(Date_Claim_Entered,Date_Claim_Received) between @Start_Date and @End_Date
				
	-- OPEN CLAIMS
	SELECT [AgencyName],[Sub_Category],[Group],[Team],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claims_Officer_Name],[Claim_No]
	INTO #claim_open_all
	FROM #claim_list
	WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date) 
			and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	-- CLAIM CLOSURES
	-- @IsLastMonthRange = 1 => use IsPreOpened = 1 condition else => bypass this condition
	SELECT [AgencyName],[Sub_Category],[Group],[Team],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claims_Officer_Name],[Claim_No]
	INTO #claim_closure 
	FROM #claim_list cpr
	WHERE Date_Claim_Closed between @Start_Date and @End_Date
		and Claim_Closed_Flag = 'Y'
		and (case when @Period_Type != -1 then IsPreOpened else 1 end) = 1
		and (@Period_Type != -1
			or exists (SELECT [Claim_No] FROM #pre_claim_list cpr_pre
							WHERE cpr_pre.Claim_No = cpr.Claim_No AND cpr_pre.Claim_Closed_Flag = 'N')
			or ISNULL(cpr.Date_Claim_Entered, cpr.date_claim_received) >= @Start_Date)
	
	IF UPPER(@System) = 'TMF'
	BEGIN
		--TMF--
		SELECT  [System] = 'TMF'
				,[Type] = 'TMF'
				,[Value] = 'TMF'
				,[Primary] = 'TMF'
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		--End TMF--
		
		UNION ALL
		
		--Agency--
		SELECT  [System] = 'TMF'
				,[Type] = 'agency'
				,[Value] = tmp_value.AgencyName
				,[Primary] = tmp_value.AgencyName
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	AgencyName = tmp_value.AgencyName)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	AgencyName = tmp_value.AgencyName)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	AgencyName = tmp_value.AgencyName)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join
		(
			SELECT DISTINCT AgencyName
				FROM #claim_list
				WHERE AgencyName <> ''
				GROUP BY AgencyName
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Agency--
		
		--UNION ALL
		
		----Agency Police & Fire--
		--SELECT  [System] = 'TMF'
		--		,[Type] = 'agency'
		--		,[Value] = 'Police & Fire'
		--		,[Primary] = 'Police & Fire'
		--		,uv_ClaimType.ClaimType
		--		,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
		--		,[Start_Date] = @Start_Date
		--		,[End_Date] = @End_Date
		--		,No_Of_Port_Claims =
		--				CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
		--						THEN
		--							(SELECT		COUNT(distinct Claim_No)
		--								FROM	#claim_new_all
		--								WHERE	AgencyName in ('Police','Fire'))
		--					WHEN uv_ClaimType.ClaimType = 'open_claims'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_open_all
		--								WHERE	AgencyName in ('Police','Fire'))
		--					WHEN uv_ClaimType.ClaimType = 'claim_closures'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_closure
		--								WHERE	AgencyName in ('Police','Fire'))
		--					ELSE 0
		--				END
		--FROM
		--(
		--	SELECT 'new_claims' as ClaimType
		--	UNION
		--	SELECT 'open_claims' as ClaimType
		--	UNION
		--	SELECT 'claim_closures' as ClaimType
		--) as uv_ClaimType
		----End Agency Police & Fire--
		
		--UNION ALL
		
		----Agency Health & Other--
		--SELECT  [System] = 'TMF'
		--		,[Type] = 'agency'
		--		,[Value] = 'Health & Other'
		--		,[Primary] = 'Health & Other'
		--		,uv_ClaimType.ClaimType
		--		,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
		--		,[Start_Date] = @Start_Date
		--		,[End_Date] = @End_Date
		--		,No_Of_Port_Claims =
		--				CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
		--						THEN
		--							(SELECT		COUNT(distinct Claim_No)
		--								FROM	#claim_new_all
		--								WHERE	AgencyName in ('Health','Other'))
		--					WHEN uv_ClaimType.ClaimType = 'open_claims'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_open_all
		--								WHERE	AgencyName in ('Health','Other'))
		--					WHEN uv_ClaimType.ClaimType = 'claim_closures'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_closure
		--								WHERE	AgencyName in ('Health','Other'))
		--					ELSE 0
		--				END
		--FROM
		--(
		--	SELECT 'new_claims' as ClaimType
		--	UNION
		--	SELECT 'open_claims' as ClaimType
		--	UNION
		--	SELECT 'claim_closures' as ClaimType
		--) as uv_ClaimType
		----End Agency Health & Other--
		
		UNION ALL
		
		--Group--
		SELECT  [System] = 'TMF'
				,[Type] = 'group'
				,[Value] = tmp_value.[Group]
				,[Primary] = tmp_value.[Group]
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	[Group] = tmp_value.[Group])
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	[Group] = tmp_value.[Group])
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	[Group] = tmp_value.[Group])
							ELSE 0
						END
		from
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join 
		(
			SELECT DISTINCT [Group]
				FROM #claim_list
				WHERE [Group] <> ''
				GROUP BY [Group]
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Group--
		
		--UNION ALL
		
		----Sub Category--
		--SELECT  [System] = 'TMF'
		--		,[Type] = 'sub_category'
		--		,[Value] = tmp_value.Sub_Category
		--		,[Primary] = tmp_value.AgencyName
		--		,uv_ClaimType.ClaimType
		--		,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
		--		,[Start_Date] = @Start_Date
		--		,[End_Date] = @End_Date
		--		,No_Of_Port_Claims =
		--				CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
		--						THEN
		--							(SELECT		COUNT(distinct Claim_No)
		--								FROM	#claim_new_all
		--								WHERE	AgencyName = tmp_value.AgencyName
		--										and Sub_Category = tmp_value.Sub_Category)
		--					WHEN uv_ClaimType.ClaimType = 'open_claims'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_open_all
		--								WHERE	AgencyName = tmp_value.AgencyName
		--										and Sub_Category = tmp_value.Sub_Category)
		--					WHEN uv_ClaimType.ClaimType = 'claim_closures'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_closure
		--								WHERE	AgencyName = tmp_value.AgencyName
		--										and Sub_Category = tmp_value.Sub_Category)
		--					ELSE 0
		--				END
		--FROM
		--(
		--	SELECT 'new_claims' as ClaimType
		--	UNION
		--	SELECT 'open_claims' as ClaimType
		--	UNION
		--	SELECT 'claim_closures' as ClaimType
		--) as uv_ClaimType
		--cross join 
		--(
		--	SELECT DISTINCT AgencyName, Sub_Category
		--		FROM #claim_list
		--		WHERE AgencyName <> '' and Sub_Category <> ''
		--		GROUP BY AgencyName, Sub_Category
		--		HAVING COUNT(*) > 0
		--) as tmp_value
		----End Sub Category--
		
		UNION ALL
		
		--Team--
		SELECT  [System] = 'TMF'
				,[Type] = 'team'
				,[Value] = tmp_value.Team
				,[Primary] = tmp_value.[Group]
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join
		(
			SELECT DISTINCT [Group], Team
				FROM #claim_list
				WHERE [Group] <> '' and Team <> ''
				GROUP BY [Group], Team
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Team--
		
		--UNION ALL
		
		----Claim Officer
		--SELECT  [System] = 'TMF'
		--		,[Type] = 'claim_officer'
		--		,[Value] = tmp_value.Claims_Officer_Name
		--		,[Primary] = tmp_value.Team
		--		,uv_ClaimType.ClaimType
		--		,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
		--		,[Start_Date] = @Start_Date
		--		,[End_Date] = @End_Date
		--		,No_Of_Port_Claims =
		--				CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
		--						THEN
		--							(SELECT		COUNT(distinct Claim_No)
		--								FROM	#claim_new_all
		--								WHERE	Team = tmp_value.Team
		--										and Claims_Officer_Name = tmp_value.Claims_Officer_Name)
		--					WHEN uv_ClaimType.ClaimType = 'open_claims'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_open_all
		--								WHERE	Team = tmp_value.Team
		--										and Claims_Officer_Name = tmp_value.Claims_Officer_Name)
		--					WHEN uv_ClaimType.ClaimType = 'claim_closures'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_closure
		--								WHERE	Team = tmp_value.Team
		--										and Claims_Officer_Name = tmp_value.Claims_Officer_Name)
		--					ELSE 0
		--				END
		--FROM
		--(
		--	SELECT 'new_claims' as ClaimType
		--	UNION
		--	SELECT 'open_claims' as ClaimType
		--	UNION
		--	SELECT 'claim_closures' as ClaimType
		--) as uv_ClaimType
		--cross join
		--(
		--	SELECT DISTINCT Team, Claims_Officer_Name
		--		FROM #claim_list
		--		WHERE Team <> '' and Claims_Officer_Name <> ''
		--		GROUP BY Team, Claims_Officer_Name
		--		HAVING COUNT(*) > 0
		--) as tmp_value
		----End Claim Officer
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		--EML--
		SELECT  [System] = 'EML'
				,[Type] = 'EML'
				,[Value] = 'EML'
				,[Primary] = 'EML'
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		--End EML--
		
		--UNION ALL
		
		----Employer size--
		--SELECT  [System] = 'EML'
		--		,[Type] = 'employer_size'
		--		,[Value] = tmp_value.EMPL_SIZE
		--		,[Primary] = tmp_value.EMPL_SIZE
		--		,uv_ClaimType.ClaimType
		--		,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
		--		,[Start_Date] = @Start_Date
		--		,[End_Date] = @End_Date
		--		,No_Of_Port_Claims =
		--				CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
		--						THEN
		--							(SELECT		COUNT(distinct Claim_No)
		--								FROM	#claim_new_all
		--								WHERE	EMPL_SIZE = tmp_value.EMPL_SIZE)
		--					WHEN uv_ClaimType.ClaimType = 'open_claims'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_open_all
		--								WHERE	EMPL_SIZE = tmp_value.EMPL_SIZE)
		--					WHEN uv_ClaimType.ClaimType = 'claim_closures'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_closure
		--								WHERE	EMPL_SIZE = tmp_value.EMPL_SIZE)
		--					ELSE 0
		--				END
		--FROM
		--(
		--	SELECT 'new_claims' as ClaimType
		--	UNION
		--	SELECT 'open_claims' as ClaimType
		--	UNION
		--	SELECT 'claim_closures' as ClaimType
		--) as uv_ClaimType
		--cross join 
		--(
		--	SELECT DISTINCT EMPL_SIZE
		--		FROM #claim_list
		--		WHERE EMPL_SIZE <> ''
		--		GROUP BY EMPL_SIZE
		--		HAVING COUNT(*) > 0
		--) as tmp_value
		----End Employer size--
		
		UNION ALL
		
		--Group--
		SELECT  [System] = 'EML'
				,[Type] = 'group'
				,[Value] = tmp_value.[Group]
				,[Primary] = tmp_value.[Group]
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	[Group] = tmp_value.[Group])
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	[Group] = tmp_value.[Group])
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	[Group] = tmp_value.[Group])
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join 
		(
			SELECT DISTINCT [Group]
				FROM #claim_list
				WHERE [Group] <> ''
				GROUP BY [Group]
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Group--
		
		UNION ALL
		
		--Account manager--
		SELECT  [System] = 'EML'
				,[Type] = 'account_manager'
				,[Value] = tmp_value.Account_Manager
				,[Primary] = tmp_value.Account_Manager
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	Account_Manager = tmp_value.Account_Manager)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	Account_Manager = tmp_value.Account_Manager)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	Account_Manager = tmp_value.Account_Manager)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join
		(
			SELECT DISTINCT Account_Manager
				FROM #claim_list
				WHERE Account_Manager <> ''
				GROUP BY Account_Manager
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Account manager--
		
		UNION ALL
		
		--Team--
		SELECT  [System] = 'EML'
				,[Type] = 'team'
				,[Value] = tmp_value.Team
				,[Primary] = tmp_value.[Group]
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join
		(
			SELECT DISTINCT [Group], Team
				FROM #claim_list
				WHERE [Group] <> '' and Team <> ''
				GROUP BY [Group], Team
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Team--
		
		--UNION ALL
		
		----AM_EMPL_SIZE--
		--SELECT  [System] = 'EML'
		--		,[Type] = 'am_empl_size'
		--		,[Value] = tmp_value.EMPL_SIZE
		--		,[Primary] = tmp_value.Account_Manager
		--		,uv_ClaimType.ClaimType
		--		,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
		--		,[Start_Date] = @Start_Date
		--		,[End_Date] = @End_Date
		--		,No_Of_Port_Claims =
		--				CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
		--						THEN
		--							(SELECT		COUNT(distinct Claim_No)
		--								FROM	#claim_new_all
		--								WHERE	Account_Manager = tmp_value.Account_Manager
		--										and EMPL_SIZE = tmp_value.EMPL_SIZE)
		--					WHEN uv_ClaimType.ClaimType = 'open_claims'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_open_all
		--								WHERE	Account_Manager = tmp_value.Account_Manager
		--										and EMPL_SIZE = tmp_value.EMPL_SIZE)
		--					WHEN uv_ClaimType.ClaimType = 'claim_closures'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_closure
		--								WHERE	Account_Manager = tmp_value.Account_Manager
		--										and EMPL_SIZE = tmp_value.EMPL_SIZE)
		--					ELSE 0
		--				END
		--FROM
		--(
		--	SELECT 'new_claims' as ClaimType
		--	UNION
		--	SELECT 'open_claims' as ClaimType
		--	UNION
		--	SELECT 'claim_closures' as ClaimType
		--) as uv_ClaimType
		--cross join
		--(
		--	SELECT DISTINCT Account_Manager, EMPL_SIZE
		--		FROM #claim_list
		--		WHERE Account_Manager <> '' and EMPL_SIZE <> ''
		--		GROUP BY Account_Manager, EMPL_SIZE
		--		HAVING COUNT(*) > 0
		--) as tmp_value
		----End AM_EMPL_SIZE--
		
		--UNION ALL
		
		----Claim Officer
		--SELECT  [System] = 'EML'
		--		,[Type] = 'claim_officer'
		--		,[Value] = tmp_value.Claims_Officer_Name
		--		,[Primary] = tmp_value.Team
		--		,uv_ClaimType.ClaimType
		--		,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
		--		,[Start_Date] = @Start_Date
		--		,[End_Date] = @End_Date
		--		,No_Of_Port_Claims =
		--				CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
		--						THEN
		--							(SELECT		COUNT(distinct Claim_No)
		--								FROM	#claim_new_all
		--								WHERE	Team = tmp_value.Team
		--										and Claims_Officer_Name = tmp_value.Claims_Officer_Name)
		--					WHEN uv_ClaimType.ClaimType = 'open_claims'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_open_all
		--								WHERE	Team = tmp_value.Team
		--										and Claims_Officer_Name = tmp_value.Claims_Officer_Name)
		--					WHEN uv_ClaimType.ClaimType = 'claim_closures'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_closure
		--								WHERE	Team = tmp_value.Team
		--										and Claims_Officer_Name = tmp_value.Claims_Officer_Name)
		--					ELSE 0
		--				END
		--FROM
		--(
		--	SELECT 'new_claims' as ClaimType
		--	UNION
		--	SELECT 'open_claims' as ClaimType
		--	UNION
		--	SELECT 'claim_closures' as ClaimType
		--) as uv_ClaimType
		--cross join
		--(
		--	SELECT DISTINCT Team, Claims_Officer_Name
		--		FROM #claim_list
		--		WHERE Team <> '' and Claims_Officer_Name <> ''
		--		GROUP BY Team, Claims_Officer_Name
		--		HAVING COUNT(*) > 0
		--) as tmp_value
		----End Claim Officer
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		--HEM--
		SELECT  [System] = 'HEM'
				,[Type] = 'HEM'
				,[Value] = 'HEM'
				,[Primary] = 'HEM'
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		--End HEM
		
		UNION ALL
		
		--Portfolio--
		SELECT  [System] = 'HEM'
				,[Type] = 'portfolio'
				,[Value] = tmp_value.Portfolio
				,[Primary] = tmp_value.Portfolio
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	Portfolio = tmp_value.Portfolio)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	Portfolio = tmp_value.Portfolio)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	Portfolio = tmp_value.Portfolio)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join 
		(
			SELECT DISTINCT Portfolio
				FROM #claim_list
				WHERE Portfolio <> ''
				GROUP BY Portfolio
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Portfolio--
		
		--UNION ALL
			
		----Portfolio Hotel--
		--SELECT  [System] = 'HEM'
		--		,[Type] = 'portfolio'
		--		,[Value] = 'Hotel'
		--		,[Primary] = 'Hotel'
		--		,uv_ClaimType.ClaimType
		--		,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
		--		,[Start_Date] = @Start_Date
		--		,[End_Date] = @End_Date
		--		,No_Of_Port_Claims =
		--				CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
		--						THEN
		--							(SELECT		COUNT(distinct Claim_No)
		--								FROM	#claim_new_all
		--								WHERE	Portfolio in ('Accommodation','Pubs, Taverns and Bars'))
		--					WHEN uv_ClaimType.ClaimType = 'open_claims'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_open_all
		--								WHERE	Portfolio in ('Accommodation','Pubs, Taverns and Bars'))
		--					WHEN uv_ClaimType.ClaimType = 'claim_closures'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_closure
		--								WHERE	Portfolio in ('Accommodation','Pubs, Taverns and Bars'))
		--					ELSE 0
		--				END
		--FROM
		--(
		--	SELECT 'new_claims' as ClaimType
		--	UNION
		--	SELECT 'open_claims' as ClaimType
		--	UNION
		--	SELECT 'claim_closures' as ClaimType
		--) as uv_ClaimType
		----End Portfolio Hotel--
		
		UNION ALL
		
		--Group--
		SELECT  [System] = 'HEM'
				,[Type] = 'group'
				,[Value] = tmp_value.[Group]
				,[Primary] = tmp_value.[Group]
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	[Group] = tmp_value.[Group])
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	[Group] = tmp_value.[Group])
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	[Group] = tmp_value.[Group])
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join 
		(
			SELECT DISTINCT [Group]
				FROM #claim_list
				WHERE [Group] <> ''
				GROUP BY [Group]
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Group--
		
		--UNION ALL
		
		----Account manager--
		--SELECT  [System] = 'HEM'
		--		,[Type] = 'account_manager'
		--		,[Value] = tmp_value.Account_Manager
		--		,[Primary] = tmp_value.Account_Manager
		--		,uv_ClaimType.ClaimType
		--		,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
		--		,[Start_Date] = @Start_Date
		--		,[End_Date] = @End_Date
		--		,No_Of_Port_Claims =
		--				CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
		--						THEN
		--							(SELECT		COUNT(distinct Claim_No)
		--								FROM	#claim_new_all
		--								WHERE	Account_Manager = tmp_value.Account_Manager)
		--					WHEN uv_ClaimType.ClaimType = 'open_claims'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_open_all
		--								WHERE	Account_Manager = tmp_value.Account_Manager)
		--					WHEN uv_ClaimType.ClaimType = 'claim_closures'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_closure
		--								WHERE	Account_Manager = tmp_value.Account_Manager)
		--					ELSE 0
		--				END
		--FROM
		--(
		--	SELECT 'new_claims' as ClaimType
		--	UNION
		--	SELECT 'open_claims' as ClaimType
		--	UNION
		--	SELECT 'claim_closures' as ClaimType
		--) as uv_ClaimType
		--cross join
		--(
		--	SELECT DISTINCT Account_Manager
		--		FROM #claim_list
		--		WHERE Account_Manager <> ''
		--		GROUP BY Account_Manager
		--		HAVING COUNT(*) > 0
		--) as tmp_value
		----End Account manager--
		
		UNION ALL
		
		--Team--
		SELECT  [System] = 'HEM'
				,[Type] = 'team'
				,[Value] = tmp_value.Team
				,[Primary] = tmp_value.[Group]
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join
		(
			SELECT DISTINCT [Group], Team
				FROM #claim_list
				WHERE [Group] <> '' and Team <> ''
				GROUP BY [Group], Team
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Team--
		
		--UNION ALL
		
		----AM_EMPL_SIZE--
		--SELECT  [System] = 'HEM'
		--		,[Type] = 'am_empl_size'
		--		,[Value] = tmp_value.EMPL_SIZE
		--		,[Primary] = tmp_value.Account_Manager
		--		,uv_ClaimType.ClaimType
		--		,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
		--		,[Start_Date] = @Start_Date
		--		,[End_Date] = @End_Date
		--		,No_Of_Port_Claims =
		--				CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
		--						THEN
		--							(SELECT		COUNT(distinct Claim_No)
		--								FROM	#claim_new_all
		--								WHERE	Account_Manager = tmp_value.Account_Manager
		--										and EMPL_SIZE = tmp_value.EMPL_SIZE)
		--					WHEN uv_ClaimType.ClaimType = 'open_claims'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_open_all
		--								WHERE	Account_Manager = tmp_value.Account_Manager
		--										and EMPL_SIZE = tmp_value.EMPL_SIZE)
		--					WHEN uv_ClaimType.ClaimType = 'claim_closures'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_closure
		--								WHERE	Account_Manager = tmp_value.Account_Manager
		--										and EMPL_SIZE = tmp_value.EMPL_SIZE)
		--					ELSE 0
		--				END
		--FROM
		--(
		--	SELECT 'new_claims' as ClaimType
		--	UNION
		--	SELECT 'open_claims' as ClaimType
		--	UNION
		--	SELECT 'claim_closures' as ClaimType
		--) as uv_ClaimType
		--cross join
		--(
		--	SELECT DISTINCT Account_Manager, EMPL_SIZE
		--		FROM #claim_list
		--		WHERE Account_Manager <> '' and EMPL_SIZE <> ''
		--		GROUP BY Account_Manager, EMPL_SIZE
		--		HAVING COUNT(*) > 0
		--) as tmp_value
		----End AM_EMPL_SIZE--
		
		--UNION ALL
		
		----Portfolio_EMPL_SIZE--
		--SELECT  [System] = 'HEM'
		--		,[Type] = 'portfolio_empl_size'
		--		,[Value] = tmp_value.EMPL_SIZE
		--		,[Primary] = tmp_value.Portfolio
		--		,uv_ClaimType.ClaimType
		--		,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
		--		,[Start_Date] = @Start_Date
		--		,[End_Date] = @End_Date
		--		,No_Of_Port_Claims =
		--				CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
		--						THEN
		--							(SELECT		COUNT(distinct Claim_No)
		--								FROM	#claim_new_all
		--								WHERE	Portfolio = tmp_value.Portfolio
		--										and EMPL_SIZE = tmp_value.EMPL_SIZE)
		--					WHEN uv_ClaimType.ClaimType = 'open_claims'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_open_all
		--								WHERE	Portfolio = tmp_value.Portfolio
		--										and EMPL_SIZE = tmp_value.EMPL_SIZE)
		--					WHEN uv_ClaimType.ClaimType = 'claim_closures'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_closure
		--								WHERE	Portfolio = tmp_value.Portfolio
		--										and EMPL_SIZE = tmp_value.EMPL_SIZE)
		--					ELSE 0
		--				END
		--FROM
		--(
		--	SELECT 'new_claims' as ClaimType
		--	UNION
		--	SELECT 'open_claims' as ClaimType
		--	UNION
		--	SELECT 'claim_closures' as ClaimType
		--) as uv_ClaimType
		--cross join
		--(
		--	SELECT DISTINCT Portfolio, EMPL_SIZE
		--		FROM #claim_list
		--		WHERE Portfolio <> '' and EMPL_SIZE <> ''
		--		GROUP BY Portfolio, EMPL_SIZE
		--		HAVING COUNT(*) > 0
		--) as tmp_value
		----End Portfolio_EMPL_SIZE--
		
		--UNION ALL
		
		----Claim Officer
		--SELECT  [System] = 'HEM'
		--		,[Type] = 'claim_officer'
		--		,[Value] = tmp_value.Claims_Officer_Name
		--		,[Primary] = tmp_value.Team
		--		,uv_ClaimType.ClaimType
		--		,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
		--		,[Start_Date] = @Start_Date
		--		,[End_Date] = @End_Date
		--		,No_Of_Port_Claims =
		--				CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
		--						THEN
		--							(SELECT		COUNT(distinct Claim_No)
		--								FROM	#claim_new_all
		--								WHERE	Team = tmp_value.Team
		--										and Claims_Officer_Name = tmp_value.Claims_Officer_Name)
		--					WHEN uv_ClaimType.ClaimType = 'open_claims'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_open_all
		--								WHERE	Team = tmp_value.Team
		--										and Claims_Officer_Name = tmp_value.Claims_Officer_Name)
		--					WHEN uv_ClaimType.ClaimType = 'claim_closures'
		--						THEN
		--							(SELECT     COUNT(distinct Claim_No)
		--								FROM    #claim_closure
		--								WHERE	Team = tmp_value.Team
		--										and Claims_Officer_Name = tmp_value.Claims_Officer_Name)
		--					ELSE 0
		--				END
		--FROM
		--(
		--	SELECT 'new_claims' as ClaimType
		--	UNION
		--	SELECT 'open_claims' as ClaimType
		--	UNION
		--	SELECT 'claim_closures' as ClaimType
		--) as uv_ClaimType
		--cross join
		--(
		--	SELECT DISTINCT Team, Claims_Officer_Name
		--		FROM #claim_list
		--		WHERE Team <> '' and Claims_Officer_Name <> ''
		--		GROUP BY Team, Claims_Officer_Name
		--		HAVING COUNT(*) > 0
		--) as tmp_value
		----End Claim Officer
	END
			
	-- Drop temp tables
	IF OBJECT_ID('tempdb..#claim_new_all') IS NOT NULL DROP TABLE #claim_new_all
	IF OBJECT_ID('tempdb..#claim_open_all') IS NOT NULL DROP TABLE #claim_open_all
	IF OBJECT_ID('tempdb..#claim_closure') IS NOT NULL DROP TABLE #claim_closure
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO