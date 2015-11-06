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
	
	/* PREPARE DATA BEFORE QUERYING */
	
	/* Determine the period type */
	DECLARE @Period_Type INT = [dbo].udf_GetCPR_PeriodType(@System, @Start_Date, @End_Date)
	
	/* Determine the current reporting date */
	DECLARE @Reporting_Date datetime = [dbo].udf_GetCPR_ReportingDate(@System, @Period_Type, @End_Date)
	
	/* Determine the claim list */
	SELECT *
	INTO #claim_list
	FROM [dbo].[udf_GetCPR_ClaimList](@System, @Period_Type, @Reporting_Date)
	
	DECLARE @Reporting_Date_pre datetime
	IF @Period_Type = -1
	BEGIN
		/* Determine the previous reporting date */
		SET @Reporting_Date_pre = [dbo].udf_GetCPR_ReportingDate_Pre(@System, @Start_Date)
	END
	
	/* Determine the previous claim list */
	SELECT *
	INTO #pre_claim_list
	FROM [dbo].[udf_GetCPR_PreClaimList](@System, @Period_Type, @Reporting_Date_pre)
	
	/* NEW CLAIMS */
	SELECT [AgencyName],[Sub_Category],[Group],[Team],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claims_Officer_Name],[Claim_No],[Division],[State]
	INTO #claim_new_all
	FROM #claim_list
	WHERE ISNULL(Date_Claim_Entered,Date_Claim_Received) between @Start_Date and @End_Date
				
	/* OPEN CLAIMS */
	SELECT [AgencyName],[Sub_Category],[Group],[Team],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claims_Officer_Name],[Claim_No],[Division],[State]
	INTO #claim_open_all
	FROM #claim_list
	WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date) 
			and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	/* CLAIM CLOSURES */
	SELECT [AgencyName],[Sub_Category],[Group],[Team],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claims_Officer_Name],[Claim_No],[Division],[State]
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