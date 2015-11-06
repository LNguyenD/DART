SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_AWC_Whole_HEM')
	DROP VIEW [dbo].[uv_HEM_AWC_Whole_HEM]
GO
CREATE VIEW [dbo].[uv_HEM_AWC_Whole_HEM] 
AS
	-----HEM------
	SELECT  [UnitType] = 'HEM'
			,Unit = 'HEM'
			,[Primary] = 'HEM'
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = 
				isnull(
						(SELECT     COUNT(DISTINCT HEM_AWC1.claim_no)
							FROM    HEM_AWC HEM_AWC1
							WHERE   HEM_AWC1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM  HEM_AWC))						
									AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
					, 0)
	FROM      dbo.udf_Whole_HEM_Generate_Years('hem')HEM_AWC
	GROUP BY  Year(Transaction_Year)

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'HEM'
			,Unit = 'HEM'
			,[Primary] = 'HEM'
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
					isnull(
						(SELECT top 1 Projection
							FROM   dbo.HEM_AWC_Projections
							WHERE  [Type] = 'Whole-HEM' AND Unit_Type = 'HEM' 
									AND RTRIM(Unit_Name) = 'HEM'
									AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
							ORDER BY time_id DESC									
						)
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('hem')  HEM_AWC	
	-----End HEM------
	
	-----Portfolio------
	UNION ALL
	SELECT  [UnitType] = 'portfolio'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT HEM_AWC1.claim_no)
				  FROM         HEM_AWC HEM_AWC1
				  WHERE     RTRIM(portfolio) = RTRIM(HEM_AWC.[Primary]) 
							AND HEM_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
				, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('portfolio') HEM_AWC

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'portfolio'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT top 1 Projection
				  FROM   dbo.HEM_AWC_Projections
				  WHERE [Type] = 'Whole-HEM' AND Unit_Type = 'portfolio' 
						AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
						AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
				  ORDER BY time_id DESC	
				)
				, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('portfolio') HEM_AWC	
		
	--Portfolio Hotel Summary--
	UNION ALL
	SELECT  [UnitType] = 'portfolio'
			,Unit = 'Hotel'
			,[Primary] = 'Hotel'
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT HEM_AWC1.claim_no)
				  FROM         HEM_AWC HEM_AWC1
				  WHERE     RTRIM(portfolio) in ('Accommodation','Pubs, Taverns and Bars')
							AND HEM_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
				, 0)
	FROM    dbo.udf_Whole_HEM_Generate_Years('portfolio')  HEM_AWC
	WHERE	RTRIM([Primary]) = 'Accommodation'

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'portfolio'
			,Unit = 'Hotel'
			,[Primary] = 'Hotel'
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT top 1 Projection
				  FROM   dbo.HEM_AWC_Projections
				  WHERE [Type] = 'Whole-HEM' AND Unit_Type = 'portfolio' 
						AND RTRIM(Unit_Name) in ('Accommodation','Pubs, Taverns and Bars')
						AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
				  ORDER BY time_id DESC	
				)
				, 0)
	FROM       dbo.udf_Whole_HEM_Generate_Years('portfolio')  HEM_AWC
	WHERE RTRIM([Primary]) = 'Accommodation'
	-----End Portfolio------
	
	-----Group------
	UNION ALL
	SELECT	[UnitType] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
					  FROM  HEM_AWC HEM_AWC1
					  WHERE RTRIM([Group]) = RTRIM(HEM_AWC.[Primary]) 
							AND HEM_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT     max(time_id) FROM HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('group')  HEM_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year) 
			,[Type] = 'Projection' 
			,No_of_Active_Weekly_Claims = isnull(
					(SELECT     top 1 Projection
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = 'Whole-HEM' AND Unit_Type = 'group' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
								AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
						ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('group')  HEM_AWC	
	-----End Group------	
	
	-----Account manager------
	UNION ALL
	SELECT	[UnitType] = 'account_manager'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
					  FROM  HEM_AWC HEM_AWC1
					  WHERE RTRIM([Account_Manager]) = RTRIM(HEM_AWC.[Primary]) 
							AND HEM_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT     max(time_id) FROM HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
					, 0)
	FROM      dbo.udf_Whole_HEM_Generate_Years('account_manager') HEM_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'account_manager'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year) 
			,[Type] = 'Projection' 
			,No_of_Active_Weekly_Claims = isnull(
					(SELECT     top 1 Projection
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = 'Whole-HEM' AND Unit_Type = 'account_manager' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
								AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
						ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('account_manager') HEM_AWC
	-----End Account manager------	
	
	---Team---
	UNION ALL
	SELECT  [UnitType] = 'team'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
					  FROM  HEM_AWC HEM_AWC1
					  WHERE RTRIM([Group]) = RTRIM(HEM_AWC.[Primary]) AND RTRIM(Team) = RTRIM(HEM_AWC.Unit) 
					  AND HEM_AWC1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('team') HEM_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'team'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.HEM_AWC_Projections
					  WHERE [Type] = 'Whole-HEM' AND Unit_Type = 'team' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit)
								AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
					  ORDER BY time_id DESC	
					)
					, 0)
	FROM  dbo.udf_Whole_HEM_Generate_Years('team')  HEM_AWC
	
	---AM_EMPL_SIZE---
	UNION ALL
	SELECT  [UnitType] = 'am_empl_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
					  FROM  HEM_AWC HEM_AWC1
					  WHERE RTRIM([Account_Manager]) = RTRIM(HEM_AWC.[Primary]) AND RTRIM(Empl_Size) = RTRIM(HEM_AWC.Unit) 
					  AND HEM_AWC1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
					, 0)
	FROM   dbo.udf_Whole_HEM_Generate_Years('am_empl_size') HEM_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'am_empl_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.HEM_AWC_Projections
					  WHERE [Type] = 'Whole-HEM' AND Unit_Type = 'am_empl_size' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit)
								AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
					  ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('am_empl_size') HEM_AWC
	
	---Portfolio_EMPL_SIZE---
	UNION ALL
	SELECT  [UnitType] = 'portfolio_empl_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
					  FROM  HEM_AWC HEM_AWC1
					  WHERE RTRIM([Portfolio]) = RTRIM(HEM_AWC.[Primary]) AND RTRIM(Empl_Size) = RTRIM(HEM_AWC.Unit) 
					  AND HEM_AWC1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('portfolio_empl_size')    HEM_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'portfolio_empl_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.HEM_AWC_Projections
					  WHERE [Type] = 'Whole-HEM' AND Unit_Type = 'portfolio_empl_size' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit)
								AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
					  ORDER BY time_id DESC	
					)
					, 0)
	FROM   dbo.udf_Whole_HEM_Generate_Years('portfolio_empl_size') HEM_AWC
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO