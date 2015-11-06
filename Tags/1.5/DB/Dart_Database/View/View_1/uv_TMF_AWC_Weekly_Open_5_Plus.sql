SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Weekly_Open_5_Plus')
	DROP VIEW [dbo].[uv_TMF_AWC_Weekly_Open_5_Plus]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Weekly_Open_5_Plus] 
AS 
SELECT  [Type] = 'TMF'
		,Unit = 'TMF'
		,[Primary] = 'TMF'
		,WeeklyType = '5-plus'
		,Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2)
		,Actual = 
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM         TMF_AWC tmf_awc1
                            WHERE       tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
                                                   )
		,Projection =  (SELECT ISNULL(sum(Projection), 0)
							FROM	dbo.TMF_AWC_Projections
							WHERE   [Type] = '5-plus' AND Unit_Type = 'TMF' 										 
									AND year(Time_Id) = Year(tmf_awc.Time_Id) 
									AND month(Time_Id)= month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('tmf','5-plus') TMF_AWC
	
UNION ALL
--Agency--
SELECT     [Type] = 'agency', Unit = RTRIM(Unit), [Primary] = RTRIM([Primary]), WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4  
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	                                                  
                                                        )
                        , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) = RTRIM(tmf_awc.[Primary]) AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','5-plus') TMF_AWC

--Agency Police & Fire--
UNION ALL 
SELECT     [Type] = 'agency', Unit = 'Police & Fire', [Primary] = 'Police & Fire', WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      RTRIM(AgencyName) in ('Police','Fire') AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4    
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	                                                
                                            )
                        , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) in ('Police','Fire') AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','5-plus') TMF_AWC
WHERE   RTRIM([Primary]) = 'Police'
		
--Agency Health & Other--
UNION ALL 
SELECT     [Type] = 'agency', Unit = 'Health & Other', [Primary] = 'Health & Other', WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      RTRIM(AgencyName) in ('Health','Other') AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4  
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	                                                  
                                             )
                        , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) in ('Health','Other') AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','5-plus') TMF_AWC
WHERE   RTRIM([Primary]) = 'Health'

UNION ALL
SELECT     [Type] = 'group', Unit = RTRIM(Unit), [Primary] = RTRIM([Primary]), WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2) 
                      AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      RTRIM([Group]) = RTRIM(tmf_awc.Unit) AND NOT EXISTS
                                                       (SELECT     1
                                                         FROM          tmf_awc tmf_awc2
                                                         WHERE      tmf_awc2.claim_no = tmf_awc1.claim_no AND tmf_awc2.time_id =
                                                                                    (SELECT     max(time_Id)
                                                                                      FROM          tmf_awc tmf_awc3
                                                                                      WHERE      tmf_awc3.claim_no = tmf_awc1.claim_no AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND 
                                                                                                             tmf_awc.Time_ID) AND tmf_awc2.[group] <> tmf_awc1.[group]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
                                                   tmf_awc.Time_ID) AND tmf_awc.Time_ID AND Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4 
                                                  AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	 
                                                )
                                , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'group' AND RTRIM(Unit_Name) = RTRIM(tmf_awc.Unit) AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('group','5-plus') TMF_AWC

UNION ALL
SELECT     [Type] = 'sub_category', Unit = Unit, [Primary] = RTRIM([Primary]), WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) 
                      + '- ' + RIGHT(datename(year, Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      Sub_Category = tmf_awc.Unit AND RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
                                                   tmf_awc.Time_ID) AND tmf_awc.Time_ID AND Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4 
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
                                                    )
                                    , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'sub_category' AND Unit_Name = tmf_awc.Unit AND year(Time_Id) = Year(tmf_awc.Time_Id) AND 
                                                   month(Time_Id) = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('sub_category','5-plus') TMF_AWC

UNION ALL
SELECT     [Type] = 'team', Unit = Unit, [Primary] = RTRIM([Primary]), WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2) 
                      AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE       Team = TMF_AWC.Unit 
										AND [Group] = TMF_AWC.[Primary]
										AND NOT EXISTS
                                                       (SELECT     1
                                                         FROM          tmf_awc tmf_awc2
                                                         WHERE      tmf_awc2.claim_no = tmf_awc1.claim_no AND tmf_awc2.time_id =
                                                                                    (SELECT     max(time_Id)
                                                                                      FROM          tmf_awc tmf_awc3
                                                                                      WHERE      tmf_awc3.claim_no = tmf_awc1.claim_no AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND 
                                                                                                             tmf_awc.Time_ID) AND tmf_awc2.[group] <> tmf_awc1.[group]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
                                                   tmf_awc.Time_ID) AND tmf_awc.Time_ID AND Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4 
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
                                                 )
                                                , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'team' AND Unit_Name = tmf_awc.Unit AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('team','5-plus') TMF_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO