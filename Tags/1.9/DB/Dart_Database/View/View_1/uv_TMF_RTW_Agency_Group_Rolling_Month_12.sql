SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_TMF_RTW_Agency_Group_Rolling_Month_12
IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Agency_Group_Rolling_Month_12')
	DROP VIEW [dbo].[uv_TMF_RTW_Agency_Group_Rolling_Month_12]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Agency_Group_Rolling_Month_12] 
AS

SELECT    Agency_Group = rtrim(isnull(sub.[Group],'Miscellaneous'))
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) 
          
          ,Measure_months = Measure 
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',rtrim(isnull(sub.[Group],'Miscellaneous')),NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',rtrim(isnull(sub.[Group],'Miscellaneous')),NULL,uv.Measure)
						
FROM      dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO

WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
		  and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)

GROUP BY  rtrim(isnull(sub.[Group],'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     Agency_Group = rtrim(isnull(sub.AgencyName,'Miscellaneous'))
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),NULL,uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY  rtrim(isnull(sub.AgencyName,'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Police & Fire & RFS--
UNION ALL

SELECT     Agency_Group = 'POLICE & EMERGENCY SERVICES'
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','POLICE & EMERGENCY SERVICES',NULL,uv.Measure)
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','POLICE & EMERGENCY SERVICES',NULL,uv.Measure)
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
			and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire','RFS')
GROUP BY  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Health & Other--
UNION ALL

SELECT     Agency_Group = 'HEALTH & OTHER'
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','Health & Other',NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','Health & Other',NULL,uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
			and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other')
GROUP BY  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL
SELECT     Agency_Group ='TMF'
			,[Type] = 'group'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months = Measure
			,LT= SUM(t.LT)
            ,WGT= SUM(t.WGT)
			,AVGDURN= SUM(LT) / nullif(SUM(WGT),0)
			,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(t.Remuneration_End,'target','group','TMF',NULL,t.Measure)
			,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(t.Remuneration_End,'base','group','TMF',NULL,t.Measure)

FROM         tmf_rtw t 
inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     Agency_Group= 'TMF'
			,[Type] = 'agency'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			,Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months= Measure
			,LT = SUM(t.LT)  
            ,WGT =SUM(t.WGT)  
			,AVGDURN =SUM(LT) / nullif(SUM(WGT),0) 			
			,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(t.Remuneration_End, 'target','agency','TMF',NULL,t.Measure)
			,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(t.Remuneration_End,'base','agency','TMF',NULL,t.Measure)

FROM         tmf_rtw t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO