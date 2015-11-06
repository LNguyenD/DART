SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Monthly_WOW]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Monthly_WOW]
GO
CREATE PROCEDURE [dbo].[usp_CPR_Monthly_WOW]
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
	DECLARE @Period_Type INT = [dbo].udf_GetCPR_PeriodType('WOW', @Start_Date, @End_Date)
	
	/* Determine the current reporting date */
	DECLARE @Reporting_Date datetime = [dbo].udf_GetCPR_ReportingDate('WOW', @Period_Type, @End_Date)
	
	/* Determine the claim list */
	SELECT *
	INTO #claim_list
	FROM [dbo].[udf_GetCPR_ClaimList]('WOW', @Period_Type, @Reporting_Date)
	
	DECLARE @Reporting_Date_pre datetime
	IF @Period_Type = -1
	BEGIN
		/* Determine the previous reporting date */
		SET @Reporting_Date_pre = [dbo].udf_GetCPR_ReportingDate_Pre('WOW', @Start_Date)
	END
	
	/* Determine the previous claim list */
	SELECT *
	INTO #pre_claim_list
	FROM [dbo].[udf_GetCPR_PreClaimList]('WOW', @Period_Type, @Reporting_Date_pre)
	
	/* NEW CLAIMS */
	SELECT [AgencyName],[Sub_Category],[Group],[Team],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claims_Officer_Name],[Claim_No],[Division],[State]
	INTO #claim_new_all
	FROM #claim_list
	WHERE Date_Claim_Entered between @Start_Date and @End_Date
				
	/* OPEN CLAIMS */
	SELECT [AgencyName],[Sub_Category],[Group],[Team],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claims_Officer_Name],[Claim_No],[Division],[State]
	INTO #claim_open_all
	FROM #claim_list
	WHERE [Date_Status_Changed] <= @End_Date
		and [Claim_Closed_Flag] = 'N'
		and [ClaimStatus] <> 'N'
	
	/* CLAIM CLOSURES */
	SELECT [AgencyName],[Sub_Category],[Group],[Team],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claims_Officer_Name],[Claim_No],[Division],[State]
	INTO #claim_closure 
	FROM #claim_list cpr
	WHERE [Date_Status_Changed] between @Start_Date and @End_Date
		and [Claim_Closed_Flag] = 'Y'
		and (case when @Period_Type != -1 then IsPreOpened else 1 end) = 1
		and (@Period_Type != -1
			or exists (SELECT [Claim_No] FROM #pre_claim_list cpr_pre
							WHERE cpr_pre.Claim_No = cpr.Claim_No AND cpr_pre.Claim_Closed_Flag = 'N'))
	
	--WOW--
	SELECT  [System] = 'WOW'
			,[Type] = 'WOW'
			,[Value] = 'WOW'
			,[Primary] = 'WOW'
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
	--End WOW--
	
	UNION ALL
	
	--Division--
	SELECT  [System] = 'WOW'
			,[Type] = 'division'
			,[Value] = tmp_value.division
			,[Primary] = tmp_value.division
			,uv_ClaimType.ClaimType
			,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
			,[Start_Date] = @Start_Date
			,[End_Date] = @End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT		COUNT(distinct Claim_No)
									FROM	#claim_new_all
									WHERE	division = tmp_value.division)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    #claim_open_all
									WHERE	division = tmp_value.division)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    #claim_closure
									WHERE	division = tmp_value.division)
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
		SELECT DISTINCT division
			FROM #claim_list
			WHERE division <> ''
			GROUP BY division
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Division--
	
	UNION ALL
	
	--State--
	SELECT  [System] = 'WOW'
			,[Type] = 'state'
			,[Value] = tmp_value.[State]
			,[Primary] = tmp_value.[State]
			,uv_ClaimType.ClaimType
			,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
			,[Start_Date] = @Start_Date
			,[End_Date] = @End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT		COUNT(distinct Claim_No)
									FROM	#claim_new_all
									WHERE	[State] = tmp_value.[State])
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    #claim_open_all
									WHERE	[State] = tmp_value.[State])
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    #claim_closure
									WHERE	[State] = tmp_value.[State])
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
		SELECT DISTINCT [State]
			FROM #claim_list
			WHERE [State] <> ''
			GROUP BY [State]
			HAVING COUNT(*) > 0
	) as tmp_value
	--End State--
	
	UNION ALL
	
	--Group--
	SELECT  [System] = 'WOW'
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
	SELECT  [System] = 'WOW'
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