SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Team_Sub_Summary')
	DROP VIEW [dbo].[uv_EML_AWC_Team_Sub_Summary]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Team_Sub_Summary] 
AS

SELECT  top 1000000   
		   [Type] ='group'
		   ,EmployerSize_Group = RTRIM([Group])
		   ,Team_Sub = rtrim(Team)
		   ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_EML_AWC_Whole_EML
                    WHERE      (UnitType = 'team') AND (Unit = dbo.EML_AWC.Team) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_EML_AWC_Whole_EML
                    WHERE      (UnitType = 'team') AND (Unit = dbo.EML_AWC.Team) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'team') AND (Unit = dbo.EML_AWC.Team) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
GROUP BY [Group], Team
ORDER BY Team

union all

SELECT  top 1000000   
		   [Type] ='account_manager'
		   ,EmployerSize_Group = RTRIM([Account_Manager])
		   ,Team_Sub = rtrim(EMPL_SIZE)
		   ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_EML_AWC_Whole_EML
                    WHERE      (UnitType = 'am_empl_size') AND (Unit = dbo.EML_AWC.Empl_Size) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_EML_AWC_Whole_EML
                    WHERE      (UnitType = 'am_empl_size') AND (Unit = dbo.EML_AWC.Empl_Size) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'am_empl_size') AND (Unit = dbo.EML_AWC.Empl_Size) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
           and RTRIM([Account_Manager]) is not null
GROUP BY [Account_Manager], Empl_Size
ORDER BY Empl_Size

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
