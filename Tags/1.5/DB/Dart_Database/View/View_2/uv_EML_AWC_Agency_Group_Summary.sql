SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Agency_Group_Summary')
	DROP VIEW [dbo].[uv_EML_AWC_Agency_Group_Summary]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Agency_Group_Summary] 
AS
SELECT	top 1	EmployerSize_Group ='WCNSW'
				,[Type]='employer_size'
				,No_Of_Active_Weekly_Claims=                
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'group')  AND (Type = 'Actual'))
                ,Projection =       
						 100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'group')  AND (Type = 'Actual'))
						 /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'group') AND (Type = 'Projection')),0) 
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))

UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM(ISNULL(Empl_Size, 'Miscellaneous')) 
				,[Type]='employer_size'
				,No_Of_Active_Weekly_Claims =
						(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'employer_size') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
                ,Projection =
						100*(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'employer_size') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
                        /NULLIF((SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
							FROM   dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
							WHERE      (UnitType = 'employer_size') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
GROUP BY RTRIM(ISNULL(Empl_Size, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Empl_Size, 'Miscellaneous'))


UNION ALL
SELECT top 1000 EmployerSize_Group = RTRIM(ISNULL([Group], 'Miscellaneous'))
				,[Type]='group'
				,No_Of_Active_Weekly_Claims =
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Actual'))
                ,Projection = 
						  100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Actual'))
                          /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
GROUP BY RTRIM(ISNULL([Group], 'Miscellaneous'))
ORDER BY RTRIM(ISNULL([Group], 'Miscellaneous'))

UNION ALL
SELECT top 1000 EmployerSize_Group = RTRIM([Account_Manager])
				,[Type]='account_manager'
				,No_Of_Active_Weekly_Claims =
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'account_manager') AND (Unit = RTRIM(dbo.EML_AWC.[Account_Manager])) AND (Type = 'Actual'))
                ,Projection = 
						  100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'account_manager') AND (Unit = RTRIM(dbo.EML_AWC.[Account_Manager])) AND (Type = 'Actual'))
                          /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'account_manager') AND (Unit = RTRIM(dbo.EML_AWC.[Account_Manager])) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
           and [Account_Manager] is not null
GROUP BY [Account_Manager]
ORDER BY [Account_Manager]

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO