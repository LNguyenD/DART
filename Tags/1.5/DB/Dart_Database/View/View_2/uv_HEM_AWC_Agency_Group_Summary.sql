SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_AWC_Agency_Group_Summary')
	DROP VIEW [dbo].[uv_HEM_AWC_Agency_Group_Summary]
GO
CREATE VIEW [dbo].[uv_HEM_AWC_Agency_Group_Summary] 
AS
SELECT	top 1	EmployerSize_Group ='Hospitality'
				,[Type]='portfolio'
				,No_Of_Active_Weekly_Claims=                
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'group')  AND (Type = 'Actual'))
                ,Projection =       
						 100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'group')  AND (Type = 'Actual'))
						 /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'group') AND (Type = 'Projection')),0) 
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))

UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM(ISNULL(Portfolio, 'Miscellaneous'))
				,[Type]='portfolio'
				,No_Of_Active_Weekly_Claims =
						(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'portfolio') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Portfolio, 'Miscellaneous'))) AND (Type = 'Actual'))
                ,Projection =
						100*(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'portfolio') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Portfolio, 'Miscellaneous'))) AND (Type = 'Actual'))
                        /NULLIF((SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
							FROM   dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
							WHERE      (UnitType = 'portfolio') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Portfolio, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
GROUP BY RTRIM(ISNULL(Portfolio, 'Miscellaneous')) 
ORDER BY RTRIM(ISNULL(Portfolio, 'Miscellaneous'))

--Portfolio Hotel summary--
UNION ALL

SELECT top 1 EmployerSize_Group = 'Hotel'
				,[Type]='portfolio'
				,No_Of_Active_Weekly_Claims =
						(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'portfolio') AND (Unit in ('Accommodation','Pubs, Taverns and Bars')) AND (Type = 'Actual'))
                ,Projection =
						100*(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'portfolio') AND (Unit in ('Accommodation','Pubs, Taverns and Bars')) AND (Type = 'Actual'))
                        /NULLIF((SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
							FROM   dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
							WHERE      (UnitType = 'portfolio') AND (Unit in ('Accommodation','Pubs, Taverns and Bars')) AND (Type = 'Projection')),0)		
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))     

UNION ALL
SELECT top 1000 EmployerSize_Group = RTRIM(ISNULL([Group], 'Miscellaneous'))
				,[Type]='group'
				,No_Of_Active_Weekly_Claims =
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Actual'))
                ,Projection = 
						  100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Actual'))
                          /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
GROUP BY RTRIM(ISNULL([Group], 'Miscellaneous'))
ORDER BY RTRIM(ISNULL([Group], 'Miscellaneous'))

UNION ALL
SELECT top 1000 EmployerSize_Group = RTRIM([Account_Manager])
				,[Type]='account_manager'
				,No_Of_Active_Weekly_Claims =
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'account_manager') AND (Unit = RTRIM(dbo.HEM_AWC.[Account_Manager])) AND (Type = 'Actual'))
                ,Projection = 
						  100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'account_manager') AND (Unit = RTRIM(dbo.HEM_AWC.[Account_Manager])) AND (Type = 'Actual'))
                          /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'account_manager') AND (Unit = RTRIM(dbo.HEM_AWC.[Account_Manager])) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
           and [Account_Manager] is not null
GROUP BY [Account_Manager]
ORDER BY [Account_Manager]

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO