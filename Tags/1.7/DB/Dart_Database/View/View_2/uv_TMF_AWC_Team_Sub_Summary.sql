SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Team_Sub_Summary')
	DROP VIEW [dbo].[uv_TMF_AWC_Team_Sub_Summary]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Team_Sub_Summary] 
AS

SELECT   top 1000000  
		   [Type] ='agency'
		   ,Agency_Group = RTRIM(ISNULL(AgencyName, 'Miscellaneous'))
		   ,Team_Sub = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))
           ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
						FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
						WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous')), RTRIM(ISNULL(AgencyName, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))

--Agency Police & Fire--
UNION ALL
SELECT   top 1000000  
		   [Type] ='agency'
		   ,Agency_Group = 'POLICE & EMERGENCY SERVICES'
		   ,Team_Sub = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))
           ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
						FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
						WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
           AND RTRIM(AgencyName) in ('Police','Fire', 'RFS')	
GROUP BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous')), RTRIM(AgencyName)
ORDER BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))

--Agency Health & Other--
UNION ALL
SELECT   top 1000000  
		   [Type] ='agency'
		   ,Agency_Group = 'Health & Other'
		   ,Team_Sub = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))
           ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
						FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
						WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
           AND RTRIM(AgencyName) in ('Health','Other')	
GROUP BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous')), RTRIM(AgencyName)
ORDER BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))

UNION ALL
SELECT  top 1000000   
		   [Type] ='group'
		   ,Agency_Group = dbo.udf_TMF_GetGroupByTeam(Team)
		   ,Team_Sub = RTRIM(ISNULL(Team, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims =
					(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Team, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
					100*(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Team, 'Miscellaneous'))) AND (Type = 'Actual'))
					/NULLIF((SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Team, 'Miscellaneous'))) AND (Type = 'Projection')),0) 
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY dbo.udf_TMF_GetGroupByTeam(Team), RTRIM(ISNULL(Team, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Team, 'Miscellaneous'))
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO