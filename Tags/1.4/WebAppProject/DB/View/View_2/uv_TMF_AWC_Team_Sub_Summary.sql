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
		   ,Agency_Group = RTRIM(AgencyName)
		   ,Team_Sub = rtrim(Sub_Category)
           ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = dbo.TMF_AWC.Sub_Category) AND (Type = 'Actual'))
           ,Projection =
				100*
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = dbo.TMF_AWC.Sub_Category) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
						FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
						WHERE      (UnitType = 'sub_category') AND (Unit = dbo.TMF_AWC.Sub_Category) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY Sub_Category, AgencyName
ORDER BY Sub_Category

--Agency Police & Fire--
UNION ALL
SELECT   top 1000000  
		   [Type] ='agency'
		   ,Agency_Group = 'Police & Fire'
		   ,Team_Sub = rtrim(Sub_Category)
           ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = dbo.TMF_AWC.Sub_Category) AND (Type = 'Actual'))
           ,Projection =
				100*
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = dbo.TMF_AWC.Sub_Category) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
						FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
						WHERE      (UnitType = 'sub_category') AND (Unit = dbo.TMF_AWC.Sub_Category) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
           AND RTRIM(AgencyName) in ('Police','Fire')	
GROUP BY Sub_Category, AgencyName
ORDER BY Sub_Category
--Agency Health & Other--
UNION ALL
SELECT   top 1000000  
		   [Type] ='agency'
		   ,Agency_Group = 'Health & Other'
		   ,Team_Sub = rtrim(Sub_Category)
           ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = dbo.TMF_AWC.Sub_Category) AND (Type = 'Actual'))
           ,Projection =
				100*
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = dbo.TMF_AWC.Sub_Category) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
						FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
						WHERE      (UnitType = 'sub_category') AND (Unit = dbo.TMF_AWC.Sub_Category) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
           AND RTRIM(AgencyName) in ('Health','Other')	
GROUP BY Sub_Category, AgencyName
ORDER BY Sub_Category


UNION ALL
SELECT  top 1000000   
		   [Type] ='group'
		   ,Agency_Group = RTRIM([Group])
		   ,Team_Sub = rtrim(Team)
		   ,No_Of_Active_Weekly_Claims =
					(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'team') AND (Unit = dbo.TMF_AWC.Team) AND (Type = 'Actual'))
           ,Projection =
					100*(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'team') AND (Unit = dbo.TMF_AWC.Team) AND (Type = 'Actual'))
					/NULLIF((SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'team') AND (Unit = dbo.TMF_AWC.Team) AND (Type = 'Projection')),0) 
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY [Group], Team
ORDER BY Team
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO