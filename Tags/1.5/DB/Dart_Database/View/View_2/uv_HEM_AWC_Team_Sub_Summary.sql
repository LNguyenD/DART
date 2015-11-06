SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_AWC_Team_Sub_Summary')
	DROP VIEW [dbo].[uv_HEM_AWC_Team_Sub_Summary]
GO
CREATE VIEW [dbo].[uv_HEM_AWC_Team_Sub_Summary] 
AS

SELECT  top 1000000   
		   [Type] ='group'
		   ,EmployerSize_Group = RTRIM(ISNULL([Group], 'Miscellaneous'))
		   ,Team_Sub = RTRIM(ISNULL(Team, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Team, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Team, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Team, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
GROUP BY RTRIM(ISNULL([Group], 'Miscellaneous')), RTRIM(ISNULL(Team, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Team, 'Miscellaneous'))

union all

SELECT  top 1000000   
		   [Type] ='account_manager'
		   ,EmployerSize_Group = RTRIM([Account_Manager])
		   ,Team_Sub = RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims = 
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'am_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'am_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'am_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
           and RTRIM([Account_Manager]) is not null
GROUP BY RTRIM([Account_Manager]), RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))

union all

SELECT  top 1000000   
		   [Type] ='portfolio'
		   ,EmployerSize_Group = RTRIM([Portfolio])
		   ,Team_Sub = RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'portfolio_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'portfolio_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'portfolio_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
           and RTRIM([portfolio]) is not null
GROUP BY RTRIM([portfolio]), RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))

--Portfolio Hotel Summay--
union all

SELECT  top 1000000   
		   [Type] ='portfolio'
		   ,EmployerSize_Group = 'Hotel'
		   ,Team_Sub = RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'portfolio_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'portfolio_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'portfolio_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
           and RTRIM([portfolio]) is not null
           and RTRIM([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')
GROUP BY RTRIM([portfolio]), RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO