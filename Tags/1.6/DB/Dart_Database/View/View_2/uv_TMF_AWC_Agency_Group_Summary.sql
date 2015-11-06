SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Agency_Group_Summary')
	DROP VIEW [dbo].[uv_TMF_AWC_Agency_Group_Summary]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Agency_Group_Summary] 
AS
SELECT   top 1  Agency_Group= 'TMF'
				,[Type]='agency'
                ,No_Of_Active_Weekly_Claims =
                        (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'group')  AND (Type = 'Actual'))
                ,Projection =
						 100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'group')  AND (Type = 'Actual')) 
						/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'group') AND (Type = 'Projection')),0)                       
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
UNION ALL

SELECT  top 1000 Agency_Group = RTRIM(ISNULL(AgencyName, 'Miscellaneous'))
				,[Type]='agency'
                ,No_Of_Active_Weekly_Claims =				
					      (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit = RTRIM(ISNULL(AgencyName, 'Miscellaneous'))) AND (Type = 'Actual'))
                ,Projection = 
						100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit = RTRIM(ISNULL(AgencyName, 'Miscellaneous'))) AND (Type = 'Actual'))
						/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'agency') AND (Unit = RTRIM(ISNULL(AgencyName, 'Miscellaneous'))) AND (Type = 'Projection')),0)
                        
FROM         dbo.TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY RTRIM(ISNULL(AgencyName, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(AgencyName, 'Miscellaneous'))

UNION ALL

--Agency Police & Fire--
SELECT  top 1 Agency_Group = 'POLICE & FIRE' 
				,[Type]='agency'
                ,No_Of_Active_Weekly_Claims =				
					      (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit in ('Police','Fire')) AND (Type = 'Actual'))
                ,Projection = 
						100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit in ('Police','Fire')) AND (Type = 'Actual'))
						/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'agency') AND (Unit in ('Police','Fire')) AND (Type = 'Projection')),0)
                        
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))

UNION ALL
--Agency Health & Other--
SELECT  top 1 Agency_Group = 'HEALTH & OTHER'
				,[Type]='agency'
                ,No_Of_Active_Weekly_Claims =				
					      (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit in ('Health','Other')) AND (Type = 'Actual'))
                ,Projection = 
						100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit in ('Health','Other')) AND (Type = 'Actual'))
						/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'agency') AND (Unit in ('Health','Other')) AND (Type = 'Projection')),0)
                        
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))

UNION ALL
SELECT top 1000 Agency_Group = dbo.udf_TMF_GetGroupByTeam(Team)
				,[Type]='group'
                ,No_Of_Active_Weekly_Claims =
						(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'group') AND (Unit = dbo.udf_TMF_GetGroupByTeam(Team)) AND (Type = 'Actual'))
                ,Projection =                        
                        100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'group') AND (Unit = dbo.udf_TMF_GetGroupByTeam(Team)) AND (Type = 'Actual'))
                        /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'group') AND (Unit = dbo.udf_TMF_GetGroupByTeam(Team)) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY dbo.udf_TMF_GetGroupByTeam(Team)
ORDER BY CASE ISNUMERIC(dbo.udf_TMF_GetGroupByTeam(Team))
			WHEN 1 THEN REPLICATE('0', 100 - LEN(dbo.udf_TMF_GetGroupByTeam(Team))) + dbo.udf_TMF_GetGroupByTeam(Team)
			ELSE dbo.udf_TMF_GetGroupByTeam(Team)
		 END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO