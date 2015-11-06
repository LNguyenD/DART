SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Whole_TMF')
	DROP VIEW [dbo].[uv_TMF_AWC_Whole_TMF]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Whole_TMF] 
AS
	-----TMF------	
	SELECT  [UnitType] = 'TMF'
			,Unit = 'TMF'
			,[Primary] = 'TMF'
			,Transaction_Year = year(tmf_awc.Transaction_Date)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
				  FROM         TMF_AWC tmf_awc1
				  WHERE     tmf_awc1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  tmf_awc)) 
							AND year(Date_of_Injury) = year(tmf_awc.Transaction_Date))
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('tmf') TMF_AWC

	UNION ALL ----Projection----	
	SELECT  [UnitType] = 'TMF'
			,Unit = 'TMF'
			,[Primary] = 'TMF'
			,Transaction_Year = Year(tmf_awc.Transaction_Date)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
										isnull(
											(SELECT TOP 1 Projection
												FROM   dbo.TMF_AWC_Projections
												WHERE  [Type] = 'Whole-TMF' AND Unit_Type = 'TMF' 
														AND RTRIM(Unit_Name) = 'TMF'
														AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 
												ORDER BY time_id DESC	
											 )
										, 0)
	FROM  dbo.udf_Whole_TMF_Generate_Years('tmf') TMF_AWC
	-----End TMF------
	
	-----Agency------
	UNION ALL
	SELECT  [UnitType] = 'agency'
			,Unit = tmf_awc.Unit
			,[Primary] = tmf_awc.[Primary]
			,Transaction_Year = Year(tmf_awc.Transaction_Date)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
				  FROM         TMF_AWC tmf_awc1
				  WHERE     RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) 
							AND tmf_awc1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  tmf_awc)) 
							AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC
	
	UNION ALL ----Projection----
	SELECT  [UnitType] = 'agency'
			,Unit = Unit
			,[Primary] = [Primary]
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
				isnull(
					(SELECT top 1 Projection
						FROM   dbo.TMF_AWC_Projections
						WHERE [Type] = 'Whole-TMF' AND Unit_Type = 'agency' 
							AND RTRIM(Unit_Name) = RTRIM(tmf_awc.[Primary])							
							AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 
						ORDER BY time_id DESC							
					)
				, 0)
	FROM   dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC	
	
	--Agency Police & Fire--
	UNION ALL
	SELECT  [UnitType] = 'agency'
			,Unit = 'Police & Fire'
			,[Primary] = 'Police & Fire'
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
				  FROM         TMF_AWC tmf_awc1
				  WHERE     RTRIM(AgencyName) in ('Police','Fire')
							AND tmf_awc1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  tmf_awc)) 
							AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC
	WHERE	RTRIM([Primary]) = 'Police'

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'agency'
			,Unit = 'Police & Fire'
			,[Primary] = 'Police & Fire'
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
				isnull(
					(SELECT top 1 Projection
						FROM   dbo.TMF_AWC_Projections
						WHERE [Type] = 'Whole-TMF' AND Unit_Type = 'agency' 
							AND RTRIM(Unit_Name) in ('Police', 'Fire')							
							AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 
						ORDER BY time_id DESC							
					)
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC
	WHERE	RTRIM([Primary])  = 'Police'
	
	--Agency Health & Other--
	UNION ALL
	SELECT  [UnitType] = 'agency'
			,Unit = 'Health & Other'
			,[Primary] = 'Health & Other'
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
				  FROM         TMF_AWC tmf_awc1
				  WHERE     RTRIM(AgencyName) in ('Health','Other')
							AND tmf_awc1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  tmf_awc)) 
							AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC
	WHERE	RTRIM([Primary]) = 'Health'

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'agency'
			,Unit = 'Health & Other'
			,[Primary] = 'Health & Other'
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
				isnull(
					(SELECT top 1 Projection
						FROM   dbo.TMF_AWC_Projections
						WHERE [Type] = 'Whole-TMF' AND Unit_Type = 'agency' 
							AND RTRIM(Unit_Name) in ('Health','Other')						
							AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 	
						ORDER BY time_id DESC							
					)
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC
	WHERE	RTRIM([Primary]) = 'Health'
	-----End Agency------

	-----Group------
	UNION ALL
	SELECT	[UnitType] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT tmf_awc1.claim_no)
					  FROM  TMF_AWC tmf_awc1
					  WHERE RTRIM([Group]) = RTRIM(tmf_awc.[Primary]) 
							AND tmf_awc1.time_id >= dateadd(mm, - 2,
								(SELECT     max(time_id) FROM tmf_awc)) 
							AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
					, 0)
	FROM     dbo.udf_Whole_TMF_Generate_Years('group')   TMF_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Date) 
			,[Type] = 'Projection' 
			,No_of_Active_Weekly_Claims = isnull(
					(SELECT     top 1 Projection
						FROM    dbo.TMF_AWC_Projections
						WHERE   [Type] = 'Whole-TMF' AND Unit_Type = 'group' 
								AND RTRIM(Unit_Name) = RTRIM(tmf_awc.Unit)								
								AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 
						ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_TMF_Generate_Years('group') TMF_AWC
	-----End Group------
	
	-----Sub Category------
	UNION ALL
	SELECT  [UnitType] = 'sub_category'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Date)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
					(SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
					  FROM         TMF_AWC tmf_awc1
					  WHERE     RTRIM(Sub_Category) = RTRIM(tmf_awc.Unit)
								AND RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) 
								AND tmf_awc1.time_id >= dateadd(mm, - 2,
									(SELECT max(time_id) FROM tmf_awc)) 
								AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
					, 0)
	FROM     dbo.udf_Whole_TMF_Generate_Years('sub_category') TMF_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'sub_category'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Year(Transaction_Date) AS Transaction_Year
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.TMF_AWC_Projections
					  WHERE [Type] = 'Whole-TMF' AND Unit_Type = 'sub_category' 
							AND RTRIM(Unit_Name) = RTRIM(tmf_awc.Unit)							
							AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 
					  ORDER BY time_id DESC	
					)
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('sub_category') TMF_AWC
	---End Sub category---
	
	---Team---
	UNION ALL
	SELECT  [UnitType] = 'team'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT tmf_awc1.claim_no)
					  FROM  TMF_AWC tmf_awc1
					  WHERE RTRIM(Team) = RTRIM(TMF_AWC.Unit) 
							AND RTRIM([Group]) = RTRIM(TMF_AWC.[Primary])
							AND tmf_awc1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM tmf_awc)) 
							AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
					, 0)
	FROM     dbo.udf_Whole_TMF_Generate_Years('team') TMF_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'team'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Date)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.TMF_AWC_Projections
					  WHERE [Type] = 'Whole-TMF' AND Unit_Type = 'team' 
								AND RTRIM(Unit_Name) = RTRIM(tmf_awc.Unit)								
								AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 
					  ORDER BY time_id DESC	
					)
				 , 0)
	FROM     dbo.udf_Whole_TMF_Generate_Years('team') TMF_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO