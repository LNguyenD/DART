SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Weekly_Open_3_5')
	DROP VIEW [dbo].[uv_EML_AWC_Weekly_Open_3_5]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Weekly_Open_3_5] 
AS	
--EML--
SELECT  [Type] = 'EML'
		, Unit = 'EML'
		, [Primary] = 'EML'
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year,Time_Id), 2) 
        , Actual =
				  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
                    FROM    EML_AWC EML_AWC1
                    WHERE   EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID 
							AND Year(EML_AWC1.Date_of_injury) BETWEEN Year(eml_awc.Time_ID) - 4 AND Year(eml_awc.Time_ID) - 2
							AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
                   )
        , Projection =
                  (SELECT ISNULL(sum(Projection), 0)
                    FROM	dbo.EML_AWC_Projections
                    WHERE   [Type] = '3-5' AND Unit_Type = 'eml' 							
							AND year(Time_Id) = Year(EML_AWC.Time_Id) 
							AND month(Time_Id) = month(EML_AWC.Time_Id)
                    )
FROM    dbo.udf_EML_AWC_Generate_Time_ID('eml','3-5') EML_AWC

UNION ALL
--Employer size--
SELECT  [Type] = 'employer_size'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year,Time_Id), 2) 
        , Actual =
				  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
                    FROM    EML_AWC EML_AWC1
                    WHERE   RTRIM(Empl_Size) = RTRIM(EML_AWC.[Primary]) 
							AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID 
							AND Year(EML_AWC1.Date_of_injury) BETWEEN Year(eml_awc.Time_ID) - 4 AND Year(eml_awc.Time_ID) - 2
							AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
                   )
        , Projection =
                  (SELECT ISNULL(sum(Projection), 0)
                    FROM	dbo.EML_AWC_Projections
                    WHERE   [Type] = '3-5' AND Unit_Type = 'employer_size' 
							AND RTRIM(Unit_Name) = RTRIM(EML_AWC.[Primary]) 
							AND year(Time_Id) = Year(EML_AWC.Time_Id) 
							AND month(Time_Id) = month(EML_AWC.Time_Id)
                    )
FROM    dbo.udf_EML_AWC_Generate_Time_ID('employer_size','3-5') eml_awc

UNION ALL
SELECT  [Type] = 'group'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year =LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        , Actual =
                  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
                    FROM    EML_AWC EML_AWC1
                    WHERE   dbo.udf_EML_GetGroupByTeam(Team) = RTRIM(EML_AWC.Unit) 
							AND NOT EXISTS (SELECT     1
											FROM    EML_AWC EML_AWC2
											WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
													AND EML_AWC2.time_id =
                                                        (SELECT max(time_Id)
                                                          FROM  EML_AWC EML_AWC3
                                                          WHERE EML_AWC3.claim_no = EML_AWC1.claim_no 
																	AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) 
																	AND EML_AWC.Time_ID
														) 
													AND dbo.udf_EML_GetGroupByTeam(EML_AWC2.Team) <> dbo.udf_EML_GetGroupByTeam(EML_AWC1.Team)
											) 
                            AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) 
                            AND EML_AWC.Time_ID AND Year(EML_AWC1.Date_of_injury) BETWEEN Year(eml_awc.Time_ID) - 4 AND Year(eml_awc.Time_ID) - 2
                            AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
                    )
        , Projection =
                          (SELECT   ISNULL(sum(Projection), 0)
                            FROM    dbo.EML_AWC_Projections
                            WHERE   [Type] = '3-5' AND Unit_Type = 'group' 
									AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit) 
									AND year(Time_Id) = Year(EML_AWC.Time_Id) 
									AND month(Time_Id)= month(EML_AWC.Time_Id)
							)
FROM    dbo.udf_EML_AWC_Generate_Time_ID('group','3-5') eml_awc

UNION ALL
SELECT  [Type] = 'account_manager'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year =LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        , Actual =
                  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
                    FROM    EML_AWC EML_AWC1
                    WHERE   RTRIM([Account_Manager]) = RTRIM(EML_AWC.[Primary]) 
							AND NOT EXISTS (SELECT     1
											FROM    EML_AWC EML_AWC2
											WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
													AND EML_AWC2.time_id =
                                                        (SELECT max(time_Id)
                                                          FROM  EML_AWC EML_AWC3
                                                          WHERE EML_AWC3.claim_no = EML_AWC1.claim_no 
																	AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) 
																	AND EML_AWC.Time_ID
														) 
													AND EML_AWC2.[Account_Manager] <> EML_AWC1.[Account_Manager]
											) 
                            AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) 
                            AND EML_AWC.Time_ID AND Year(EML_AWC1.Date_of_injury) BETWEEN Year(eml_awc.Time_ID) - 4 AND Year(eml_awc.Time_ID) - 2
                            AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
                    )
        , Projection =
                          (SELECT   ISNULL(sum(Projection), 0)
                            FROM    dbo.EML_AWC_Projections
                            WHERE   [Type] = '3-5' AND Unit_Type = 'account_manager' 
									AND RTRIM(Unit_Name) = RTRIM(EML_AWC.[Primary]) 
									AND year(Time_Id) = Year(EML_AWC.Time_Id) 
									AND month(Time_Id)= month(EML_AWC.Time_Id)
							)
FROM    dbo.udf_EML_AWC_Generate_Time_ID('account_manager','3-5') eml_awc

UNION ALL
SELECT  [Type] = 'team'
		,Unit = Unit
		,[Primary] = RTRIM([Primary])
		,WeeklyType = '3-5'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =
                  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
						FROM	EML_AWC EML_AWC1
						WHERE   Team = EML_AWC.Unit 
								AND dbo.udf_EML_GetGroupByTeam(Team) = EML_AWC.[Primary]
								AND NOT EXISTS  (SELECT  1
                                                 FROM   EML_AWC EML_AWC2
                                                 WHERE  EML_AWC2.claim_no = EML_AWC1.claim_no 
														AND EML_AWC2.time_id =(SELECT	max(time_Id)
																				FROM    EML_AWC EML_AWC3
																				WHERE   EML_AWC3.claim_no = EML_AWC1.claim_no 
																						AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID
																				) 
														AND dbo.udf_EML_GetGroupByTeam(EML_AWC2.Team) <> dbo.udf_EML_GetGroupByTeam(EML_AWC1.Team)
												) 
								AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,EML_AWC.Time_ID) AND EML_AWC.Time_ID 
                                AND Year(EML_AWC1.Date_of_injury) BETWEEN Year(eml_awc.Time_ID) - 4 AND Year(eml_awc.Time_ID) - 2
                                AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc) 
                    )
        ,Projection =
                  (SELECT   ISNULL(sum(Projection), 0)
					FROM    dbo.EML_AWC_Projections
					WHERE   [Type] = '3-5' AND Unit_Type = 'team' 
							AND Unit_Name = EML_AWC.Unit 
							AND year(Time_Id)  = Year(EML_AWC.Time_Id) 
							AND month(Time_Id) = month(EML_AWC.Time_Id)
					)
FROM    dbo.udf_EML_AWC_Generate_Time_ID('team','3-5') EML_AWC

UNION ALL
SELECT  [Type] = 'am_empl_size'
		,Unit = Unit
		,[Primary] = RTRIM([Primary])
		,WeeklyType = '3-5'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =
                  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
						FROM	EML_AWC EML_AWC1
						WHERE   Empl_Size = EML_AWC.Unit
								AND [Account_Manager] = EML_AWC.[Primary]
								AND NOT EXISTS  (SELECT  1
                                                 FROM   EML_AWC EML_AWC2
                                                 WHERE  EML_AWC2.claim_no = EML_AWC1.claim_no 
														AND EML_AWC2.time_id =(SELECT	max(time_Id)
																				FROM    EML_AWC EML_AWC3
																				WHERE   EML_AWC3.claim_no = EML_AWC1.claim_no 
																						AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID
																				) 
														AND EML_AWC2.[Account_Manager] <> EML_AWC1.[Account_Manager]
												) 
								AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,EML_AWC.Time_ID) AND EML_AWC.Time_ID 
                                AND Year(EML_AWC1.Date_of_injury) BETWEEN Year(eml_awc.Time_ID) - 4 AND Year(eml_awc.Time_ID) - 2
                                AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)                                
                    )
        ,Projection =
                  (SELECT   ISNULL(sum(Projection), 0)
					FROM    dbo.EML_AWC_Projections
					WHERE   [Type] = '3-5' AND Unit_Type = 'am_empl_size' 
							AND Unit_Name = EML_AWC.Unit 
							--AND [Account_Manager] = EML_AWC.[Account_Manager]
							AND year(Time_Id)  = Year(EML_AWC.Time_Id) 
							AND month(Time_Id) = month(EML_AWC.Time_Id)
					)
FROM    dbo.udf_EML_AWC_Generate_Time_ID('am_empl_size','3-5') EML_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO