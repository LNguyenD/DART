SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_HEM_RTW_Agency_Group_Rolling_Month_12
IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Agency_Group_Rolling_Month_12')
	DROP VIEW [dbo].[uv_HEM_RTW_Agency_Group_Rolling_Month_12]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Agency_Group_Rolling_Month_12] 
AS

SELECT    EmployerSize_Group = dbo.udf_HEM_GetGroupByTeam(Team)
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) 
          
          ,Measure_months = Measure 
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',dbo.udf_HEM_GetGroupByTeam(Team),NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',dbo.udf_HEM_GetGroupByTeam(Team),NULL,uv.Measure)
						
FROM      dbo.HEM_RTW uv 

WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
		  and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)

GROUP BY  dbo.udf_HEM_GetGroupByTeam(Team), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     EmployerSize_Group = rtrim(uv.Portfolio)
		   ,[Type] = 'portfolio' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio',uv.Portfolio,NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','portfolio',uv.Portfolio,NULL,uv.Measure)					 
FROM         dbo.HEM_RTW uv 
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
			and uv.Portfolio is not null
GROUP BY  uv.Portfolio, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Hotel summary--
UNION ALL

SELECT     EmployerSize_Group = 'Hotel'
		   ,[Type] = 'portfolio' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio','Hotel',NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','portfolio', 'Hotel',NULL,uv.Measure)					 
FROM         dbo.HEM_RTW uv 
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
			and uv.Portfolio is not null
			and uv.Portfolio in ('Accommodation','Pubs, Taverns and Bars')
GROUP BY  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     EmployerSize_Group = rtrim(uv.Account_Manager)
		   ,[Type] = 'account_manager' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',uv.Account_Manager,NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','account_manager',uv.Account_Manager,NULL,uv.Measure)					 
FROM         dbo.HEM_RTW uv 
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
			and rtrim(uv.Account_Manager) is not null
GROUP BY  uv.Account_Manager, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL
SELECT     EmployerSize_Group ='Hospitality'
			,[Type] = 'group'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months = Measure
			,LT= SUM(t.LT)
            ,WGT= SUM(t.WGT)
			,AVGDURN= SUM(LT) / SUM(WGT)			
			,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'target','group','Hospitality',NULL,t.Measure)
			,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'base','group','Hospitality',NULL,t.Measure)

FROM         HEM_RTW t
inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     EmployerSize_Group= 'Hospitality'
			,[Type] = 'portfolio'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			,Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months= Measure
			,LT = SUM(t.LT)  
            ,WGT =SUM(t.WGT)  
			,AVGDURN =SUM(LT) / SUM(WGT)  			
			,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'target','portfolio','Hospitality',NULL,t.Measure)
			,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'base','portfolio','Hospitality',NULL,t.Measure)
            
            
FROM         HEM_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     EmployerSize_Group= 'Hospitality'
			,[Type] = 'account_manager'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			,Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months= Measure
			,LT = SUM(t.LT)  
            ,WGT =SUM(t.WGT)  
			,AVGDURN =SUM(LT) / SUM(WGT)  			
			,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'target','account_manager','Hospitality',NULL,t.Measure)
			,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'base','account_manager','Hospitality',NULL,t.Measure)
            
            
FROM         HEM_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO