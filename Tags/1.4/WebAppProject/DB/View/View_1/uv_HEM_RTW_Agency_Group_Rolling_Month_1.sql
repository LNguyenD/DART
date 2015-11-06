SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_HEM_RTW_Agency_Group_Rolling_Month_1
IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Agency_Group_Rolling_Month_1')
	DROP VIEW [dbo].[uv_HEM_RTW_Agency_Group_Rolling_Month_1]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Agency_Group_Rolling_Month_1] 
AS

SELECT     rtrim(uv.[Group]) as EmployerSize_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],NULL,uv.Measure)
						
FROM         dbo.HEM_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
GROUP BY  uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     rtrim(uv.Portfolio) as EmployerSize_Group
		   ,[Type] = 'portfolio' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio',uv.Portfolio,NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','portfolio',uv.Portfolio,NULL,uv.Measure)					 
FROM         dbo.HEM_RTW uv 
			where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
GROUP BY  uv.Portfolio, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Portfolio Hotel Summary--
UNION ALL

SELECT     'Hotel' as EmployerSize_Group
		   ,[Type] = 'portfolio' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio','Hotel',NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','portfolio','Hotel',NULL,uv.Measure)					 
FROM         dbo.HEM_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		and RTRIM([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')
GROUP BY  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     rtrim(uv.Account_Manager) as EmployerSize_Group
		   ,[Type] = 'account_manager' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',uv.Account_Manager,NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','account_manager',uv.Account_Manager,NULL,uv.Measure)					 
FROM         dbo.HEM_RTW uv 
			where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
			and rtrim(uv.Account_Manager) is not null
GROUP BY  uv.Account_Manager, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL
SELECT     'Hospitality' AS EmployerSize_Group
			, [Type] = 'group'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			, Measure AS Measure_months
			, SUM(t.LT) AS LT
            , SUM(t.WGT) AS WGT
			, SUM(LT) / SUM(WGT) AS AVGDURN
			
			, [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'target','group','Hospitality',NULL,t.Measure)
			, Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'base','group','Hospitality',NULL,t.Measure)
			
FROM         HEM_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 0
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     'Hospitality' AS EmployerSize_Group
			, [Type] = 'portfolio'
			,t.Remuneration_Start
			,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			, Measure AS Measure_months
			, SUM(t.LT) AS LT
            , SUM(t.WGT) AS WGT
			, SUM(LT) / SUM(WGT) AS AVGDURN
			
			, [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'target','portfolio','Hospitality',NULL,t.Measure)
			, Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'base','portfolio','Hospitality',NULL,t.Measure)

FROM         HEM_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 0
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     'Hospitality' AS EmployerSize_Group
			, [Type] = 'account_manager'
			,t.Remuneration_Start
			,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			, Measure AS Measure_months
			, SUM(t.LT) AS LT
            , SUM(t.WGT) AS WGT
			, SUM(LT) / SUM(WGT) AS AVGDURN
			
			, [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'target','account_manager','Hospitality',NULL,t.Measure)
			, Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'base','account_manager','Hospitality',NULL,t.Measure)
            
            
FROM         HEM_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 0
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO