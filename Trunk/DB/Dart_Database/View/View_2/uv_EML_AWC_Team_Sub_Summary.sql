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
		   ,EmployerSize_Group = dbo.udf_EML_GetGroupByTeam(Team)
		   ,Team_Sub = RTRIM(ISNULL(Team, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_EML_AWC_Whole_EML
                    WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Team, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_EML_AWC_Whole_EML
                    WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Team, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Team, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
GROUP BY dbo.udf_EML_GetGroupByTeam(Team), RTRIM(ISNULL(Team, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Team, 'Miscellaneous'))

union all

SELECT  top 1000000   
		   [Type] ='account_manager'
		   ,EmployerSize_Group = RTRIM([Account_Manager])
		   ,Team_Sub = RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_EML_AWC_Whole_EML
                    WHERE      (UnitType = 'am_empl_size') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_EML_AWC_Whole_EML
                    WHERE      (UnitType = 'am_empl_size') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'am_empl_size') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
           and RTRIM([Account_Manager]) is not null
GROUP BY RTRIM([Account_Manager]), RTRIM(ISNULL(Empl_Size, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Empl_Size, 'Miscellaneous'))

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO