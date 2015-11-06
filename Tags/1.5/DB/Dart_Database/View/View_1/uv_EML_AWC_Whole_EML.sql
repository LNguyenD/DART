SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Whole_EML')
	DROP VIEW [dbo].[uv_EML_AWC_Whole_EML]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Whole_EML] 
AS
	-----EML------
	SELECT  [UnitType] = 'EML'
			,Unit = 'EML'
			,[Primary] = 'EML'
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = 
				isnull(
						(SELECT     COUNT(DISTINCT EML_AWC1.claim_no)
							FROM    EML_AWC EML_AWC1
							WHERE   EML_AWC1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM  EML_AWC))						
									AND year(Date_of_Injury) = Year(EML_AWC.Transaction_Year))
					, 0)
	FROM      dbo.udf_Whole_EML_Generate_Years('eml')  EML_AWC

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'EML'
			,Unit = 'EML'
			,[Primary] = 'EML'
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
					isnull(
						(SELECT top 1 Projection
							FROM   dbo.EML_AWC_Projections
							WHERE  [Type] = 'Whole-EML' AND Unit_Type = 'EML' 
									AND RTRIM(Unit_Name) = 'EML'
									AND Time_Id = DATEADD(month,- 1,EML_AWC.Transaction_Year) 
							ORDER BY time_id DESC									
						)
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('eml') EML_AWC
	-----End EML------
	
	-----Employer size------
	UNION ALL
	SELECT  [UnitType] = 'employer_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT EML_AWC1.claim_no)
				  FROM         EML_AWC EML_AWC1
				  WHERE     RTRIM(Empl_Size) = RTRIM(EML_AWC.[Primary]) 
							AND EML_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  EML_AWC)) 
							AND year(Date_of_Injury) = Year(EML_AWC.Transaction_Year))
				, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('employer_size')   EML_AWC

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'employer_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT top 1 Projection
				  FROM   dbo.EML_AWC_Projections
				  WHERE [Type] = 'Whole-EML' AND Unit_Type = 'employer_size' 
						AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit) 
						AND Time_Id = DATEADD(month,- 1,EML_AWC.Transaction_Year) 
				  ORDER BY time_id DESC	
				)
				, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('employer_size')  EML_AWC	
	-----End Employer size------

	-----Group------
	UNION ALL
	SELECT	[UnitType] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
					  FROM  EML_AWC EML_AWC1
					  WHERE RTRIM([Group]) = RTRIM(EML_AWC.[Primary]) 
							AND EML_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT     max(time_id) FROM EML_AWC)) 
							AND year(Date_of_Injury) = Year(EML_AWC.Transaction_Year))
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('group') EML_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year) 
			,[Type] = 'Projection' 
			,No_of_Active_Weekly_Claims = isnull(
					(SELECT     top 1 Projection
						FROM    dbo.EML_AWC_Projections
						WHERE   [Type] = 'Whole-EML' AND Unit_Type = 'group' 
								AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit) 
								AND Time_Id = DATEADD(month,- 1,EML_AWC.Transaction_Year) 
						ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('group') EML_AWC	
	-----End Group------	
	
	-----Account manager------
	UNION ALL
	SELECT	[UnitType] = 'account_manager'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
					  FROM  EML_AWC EML_AWC1
					  WHERE RTRIM([Account_Manager]) = RTRIM(EML_AWC.[Primary]) 
							AND EML_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT     max(time_id) FROM EML_AWC)) 
							AND year(Date_of_Injury) = Year(EML_AWC.Transaction_Year))
					, 0)
	FROM      dbo.udf_Whole_EML_Generate_Years('account_manager')  EML_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'account_manager'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year) 
			,[Type] = 'Projection' 
			,No_of_Active_Weekly_Claims = isnull(
					(SELECT     top 1 Projection
						FROM    dbo.EML_AWC_Projections
						WHERE   [Type] = 'Whole-EML' AND Unit_Type = 'account_manager' 
								AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit) 
								AND Time_Id = DATEADD(month,- 1,EML_AWC.Transaction_Year) 
						ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('account_manager') EML_AWC
	-----End Account manager------	
	
	---Team---
	UNION ALL
	SELECT  [UnitType] = 'team'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
					  FROM  EML_AWC EML_AWC1
					  WHERE RTRIM([Group]) = RTRIM(EML_AWC.[Primary]) AND RTRIM(Team) = RTRIM(EML_AWC.Unit)
					   AND EML_AWC1.time_id >= dateadd(mm, - 2,	(SELECT max(time_id) FROM EML_AWC)) 
							AND year(Date_of_Injury) = Year(EML_AWC.Transaction_Year))
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('team') EML_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'team'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.EML_AWC_Projections
					  WHERE [Type] = 'Whole-EML' AND Unit_Type = 'team' 
								AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit)
								AND Time_Id = DATEADD(month,- 1,EML_AWC.Transaction_Year) 
					  ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('team') EML_AWC
	
	---AM_EMPL_SIZE---
	UNION ALL
	SELECT  [UnitType] = 'am_empl_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
					  FROM  EML_AWC EML_AWC1
					  WHERE RTRIM(Account_Manager) = RTRIM(EML_AWC.[Primary]) 
					  AND RTRIM(Empl_Size) = RTRIM(EML_AWC.Unit) 
					  AND EML_AWC1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM EML_AWC)) 
							AND year(Date_of_Injury) = Year(EML_AWC.Transaction_Year))
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('am_empl_size')  EML_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'am_empl_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.EML_AWC_Projections
					  WHERE [Type] = 'Whole-EML' AND Unit_Type = 'am_empl_size' 
								AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit)
								AND Time_Id = DATEADD(month,- 1,EML_AWC.Transaction_Year) 
					  ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('am_empl_size') EML_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO