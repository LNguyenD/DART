SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_AWC_Weekly_Open_5_Plus')
	DROP VIEW [dbo].[uv_HEM_AWC_Weekly_Open_5_Plus]
GO
CREATE VIEW [dbo].[uv_HEM_AWC_Weekly_Open_5_Plus] 
AS 
--HEM--
SELECT  [Type] = 'HEM'
		, Unit = 'HEM'
		, [Primary] ='HEM'
		, WeeklyType = '5-plus'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, 
                      Time_Id), 2) 
        , Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
										AND HEM_AWC.Time_ID 
							AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4 
							AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
					)
		, Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'hem' 								
								AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
								AND month(Time_Id)= month(HEM_AWC.Time_Id)
						)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('hem','5-plus')   HEM_AWC

--Portfolio Hotel Summay--
UNION ALL
SELECT  [Type] = 'portfolio'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '5-plus'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, 
                      Time_Id), 2) 
        , Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   RTRIM(Portfolio) = RTRIM(HEM_AWC.Unit) 
							AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
										AND HEM_AWC.Time_ID 
							AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4 
							AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
					)
		, Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'portfolio' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
								AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
								AND month(Time_Id)= month(HEM_AWC.Time_Id)
						)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('portfolio','5-plus')   HEM_AWC

--Portfolio Hotel Summay--
UNION ALL
SELECT  [Type] = 'portfolio'
		, Unit = 'Hotel'
		, [Primary] = 'Hotel'
		, WeeklyType = '5-plus'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, 
                      Time_Id), 2) 
        , Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   RTRIM(Portfolio) in ('Accommodation','Pubs, Taverns and Bars')
							AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
										AND HEM_AWC.Time_ID 
							AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4
							AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
					)
		, Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'portfolio' 
								AND RTRIM(Unit_Name) in ('Accommodation','Pubs, Taverns and Bars')
								AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
								AND month(Time_Id)= month(HEM_AWC.Time_Id)
						)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('portfolio','5-plus')   HEM_AWC
WHERE     RTRIM(Unit) = 'Accommodation'
--end Portfolio Hotel Summay--

UNION ALL
SELECT  [Type] = 'group'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '5-plus'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =(SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   RTRIM([Group]) = RTRIM(HEM_AWC.Unit) 
							AND NOT EXISTS
								(SELECT 1
								 FROM   HEM_AWC HEM_AWC2
								 WHERE  HEM_AWC2.claim_no = HEM_AWC1.claim_no 
										AND HEM_AWC2.time_id =
													(SELECT max(time_Id)
													  FROM  HEM_AWC HEM_AWC3
													  WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
															AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
															AND HEM_AWC.Time_ID
													) 
										AND HEM_AWC2.[group] <> HEM_AWC1.[group]
								) 
							AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,HEM_AWC.Time_ID) 
                            AND HEM_AWC.Time_ID AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4
                            AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC) 
                    )
		,Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'group' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
								AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
								AND month(Time_Id)= month(HEM_AWC.Time_Id)
					)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('group','5-plus')   HEM_AWC

UNION ALL
SELECT  [Type] = 'account_manager'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '5-plus'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =(SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   RTRIM([Account_Manager]) = RTRIM(HEM_AWC.Unit) 
							AND NOT EXISTS
								(SELECT 1
								 FROM   HEM_AWC HEM_AWC2
								 WHERE  HEM_AWC2.claim_no = HEM_AWC1.claim_no 
										AND HEM_AWC2.time_id =
													(SELECT max(time_Id)
													  FROM  HEM_AWC HEM_AWC3
													  WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
															AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
															AND HEM_AWC.Time_ID
													) 
										AND HEM_AWC2.[Account_Manager] <> HEM_AWC1.[Account_Manager]
								) 
							AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,HEM_AWC.Time_ID) 
                            AND HEM_AWC.Time_ID AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4 
                            AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
                    )
		,Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'account_manager' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
								AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
								AND month(Time_Id)= month(HEM_AWC.Time_Id)
					)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('account_manager','5-plus')   HEM_AWC

UNION ALL
SELECT     [Type] = 'team'
, Unit = Unit
, [Primary] = RTRIM([Primary])
, WeeklyType = '5-plus'
, Time_Id
, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
, Actual =(SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
            FROM    HEM_AWC HEM_AWC1
            WHERE   Team = HEM_AWC.Unit 
					AND [Group] = HEM_AWC.[Primary]
					AND NOT EXISTS (SELECT  1
                                    FROM    HEM_AWC HEM_AWC2
                                    WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
											AND HEM_AWC2.time_id =(SELECT   max(time_Id)
                                                                      FROM  HEM_AWC HEM_AWC3
                                                                      WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																			AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID
																	) 
                                            AND HEM_AWC2.[group] <> HEM_AWC1.[group]
                                    ) 
                    AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
                    AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4
                    AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
            )
, Projection =  (SELECT ISNULL(sum(Projection), 0)
					FROM	dbo.HEM_AWC_Projections
                    WHERE   [Type] = '5-plus' AND Unit_Type = 'team' AND Unit_Name = HEM_AWC.Unit
							 AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
							 AND month(Time_Id)= month(HEM_AWC.Time_Id)
                )
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('team','5-plus') HEM_AWC

UNION ALL
SELECT     [Type] = 'am_empl_size'
, Unit = Unit
, [Primary] = RTRIM([Primary])
, WeeklyType = '5-plus'
, Time_Id
, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
, Actual =(SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
            FROM    HEM_AWC HEM_AWC1
            WHERE   Empl_Size = HEM_AWC.Unit
					AND [Account_Manager] = HEM_AWC.[Primary]
					AND NOT EXISTS (SELECT  1
                                    FROM    HEM_AWC HEM_AWC2
                                    WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
											AND HEM_AWC2.time_id =(SELECT   max(time_Id)
                                                                      FROM  HEM_AWC HEM_AWC3
                                                                      WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																			AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID
																	) 
                                            AND HEM_AWC2.[Account_Manager] <> HEM_AWC1.[Account_Manager]
                                    ) 
                    AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
                    AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4
                    AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
            )
, Projection =  (SELECT ISNULL(sum(Projection), 0)
					FROM	dbo.HEM_AWC_Projections
                    WHERE   [Type] = '5-plus' AND Unit_Type = 'am_empl_size' AND Unit_Name = HEM_AWC.Unit
							 AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
							 AND month(Time_Id)= month(HEM_AWC.Time_Id)
                )
FROM     dbo.udf_HEM_AWC_Generate_Time_ID('am_empl_size','5-plus')    HEM_AWC

UNION ALL
SELECT     [Type] = 'portfolio_empl_size'
, Unit = Unit
, [Primary] = RTRIM([Primary])
, WeeklyType = '5-plus'
, Time_Id
, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
, Actual =(SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
            FROM    HEM_AWC HEM_AWC1
            WHERE   Empl_Size = HEM_AWC.Unit
					AND [Portfolio] = HEM_AWC.[Primary]
					AND NOT EXISTS (SELECT  1
                                    FROM    HEM_AWC HEM_AWC2
                                    WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
											AND HEM_AWC2.time_id =(SELECT   max(time_Id)
                                                                      FROM  HEM_AWC HEM_AWC3
                                                                      WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																			AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID
																	) 
                                            AND HEM_AWC2.[portfolio] <> HEM_AWC1.[portfolio]
                                    ) 
                    AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
                    AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4
                    AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
            )
, Projection =  (SELECT ISNULL(sum(Projection), 0)
					FROM	dbo.HEM_AWC_Projections
                    WHERE   [Type] = '5-plus' AND Unit_Type = 'portfolio_empl_size' AND Unit_Name = HEM_AWC.Unit
							 AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
							 AND month(Time_Id)= month(HEM_AWC.Time_Id)
                )
FROM    dbo.udf_HEM_AWC_Generate_Time_ID('portfolio_empl_size','5-plus') HEM_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO