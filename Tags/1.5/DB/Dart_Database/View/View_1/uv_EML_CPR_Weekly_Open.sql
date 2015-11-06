SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_CPR_Weekly_Open')
	DROP VIEW [dbo].[uv_EML_CPR_Weekly_Open]
GO
CREATE VIEW [dbo].[uv_EML_CPR_Weekly_Open]
AS
	WITH temp AS
	(
		-- For monthly in one year
		SELECT	DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0) AS Start_Date
				,DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()) + 1, 0)) + '23:59' AS End_Date
				,13 AS iMonth
		UNION ALL
		SELECT DATEADD(m, -1, Start_Date), DATEADD(d, -1, Start_Date) + '23:59', iMonth - 1
		FROM temp WHERE End_Date > DATEADD(m, -11, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
	)
	
	--EML--
	select  [UnitType] = 'WCNSW'
			,Unit = 'WCNSW'
			,[Primary] = 'WCNSW'
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'employer_size', 1)
									WHERE	ISNULL(Date_Claim_Entered,Date_Claim_Received) between temp.Start_Date	and temp.End_Date)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'employer_size', 1)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y')
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'employer_size', 1)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	--End EML--
	
	UNION ALL
	
	--Employer size--
	select  [UnitType] = 'employer_size'
			,Unit = tmp_value.Value
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'employer_size', 1)
									WHERE	ISNULL(Date_Claim_Entered,Date_Claim_Received) between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'employer_size', 1)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'employer_size', 1)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join 
	(
		SELECT DISTINCT Value
			FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', 1)
			WHERE Value <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Employer size--
	
	UNION ALL
	
	--Group--
	select  [UnitType] = 'group'
			,Unit = tmp_value.Value
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'group', 1)
									WHERE	ISNULL(Date_Claim_Entered,Date_Claim_Received) between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 1)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 1)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join 
	(
		SELECT DISTINCT Value
			FROM [dbo].[udf_CPR_Overall]('EML', 'group', 1)
			WHERE Value <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Group--
	
	UNION ALL
	
	--Account manager--
	select  [UnitType] = 'account_manager'
			,Unit = tmp_value.Value
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'account_manager', 1)
									WHERE	ISNULL(Date_Claim_Entered,Date_Claim_Received) between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 1)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 1)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join 
	(
		SELECT DISTINCT Value
			FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', 1)
			WHERE Value <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Account manager--
	
	UNION ALL
	
	--Team--
	select  [UnitType] = 'team'
			,Unit = tmp_value.SubValue
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'group', 1)
									WHERE	ISNULL(Date_Claim_Entered,Date_Claim_Received) between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 1)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 1)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join
	(
		SELECT DISTINCT SubValue, Value
			FROM [dbo].[udf_CPR_Overall]('EML', 'group', 1)
			WHERE Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue, Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Team--
	
	UNION ALL
	
	--AM_EMPL_SIZE--
	select  [UnitType] = 'am_empl_size'
			,Unit = tmp_value.SubValue
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'account_manager', 1)
									WHERE	ISNULL(Date_Claim_Entered,Date_Claim_Received) between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 1)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 1)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join
	(
		SELECT DISTINCT SubValue, Value
			FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', 1)
			WHERE Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue, Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End AM_EMPL_SIZE--
	
	UNION ALL
	
	--Claim Officer
	select  [UnitType] = 'claim_officer'
			,Unit = tmp_value.SubValue2
			,[Primary] = tmp_value.SubValue
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'group', 1)
									WHERE	ISNULL(Date_Claim_Entered,Date_Claim_Received) between temp.Start_Date	and temp.End_Date
											and SubValue = tmp_value.SubValue
											and SubValue2 = tmp_value.SubValue2)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 1)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and SubValue = tmp_value.SubValue
											and SubValue2 = tmp_value.SubValue2)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 1)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and SubValue = tmp_value.SubValue
											and SubValue2 = tmp_value.SubValue2)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join
	(
		SELECT DISTINCT SubValue2, SubValue
			FROM [dbo].[udf_CPR_Overall]('EML', 'group', 1)
			WHERE SubValue <> '' and SubValue2 <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue2, SubValue
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Claim Officer
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO