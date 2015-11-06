SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_EML_RTW_Team_Sub_Rolling_Month_12
IF EXISTS(select * FROM sys.views where name = 'uv_EML_RTW_Team_Sub_Rolling_Month_12')
	DROP VIEW [dbo].[uv_EML_RTW_Team_Sub_Rolling_Month_12]
GO
CREATE VIEW [dbo].[uv_EML_RTW_Team_Sub_Rolling_Month_12] 
AS
SELECT     rtrim(uv.Team) as Team_Sub
		  ,rtrim(uv.[Group]) as  EmployerSize_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration        
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],uv.Team,uv.Measure)									
		  , Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],uv.Team,uv.Measure)
						
FROM         dbo.EML_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
GROUP BY uv.Team, uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

union all

SELECT     rtrim(uv.EMPL_SIZE) as Team_Sub
		  ,rtrim(uv.Account_Manager) as  EmployerSize_Group
		  ,[Type] = 'account_manager'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration        
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',uv.[Account_Manager],uv.EMPL_SIZE,uv.Measure)									
		  , Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','account_manager',uv.[Account_Manager],uv.EMPL_SIZE,uv.Measure)
						
FROM         dbo.EML_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
	  and rtrim(uv.Account_Manager) is not null
GROUP BY uv.EMPL_SIZE, uv.[Account_Manager], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO