SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_TMF_RTW_Team_Sub_Rolling_Month_1
IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Team_Sub_Rolling_Month_1')
	DROP VIEW [dbo].[uv_TMF_RTW_Team_Sub_Rolling_Month_1]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Team_Sub_Rolling_Month_1] 
AS

SELECT     rtrim(uv.Team) as Team_Sub
			, rtrim(isnull(sub.[Group],'Miscellaneous')) as Agency_Group
			,[Type] = 'group'
			,uv.Remuneration_Start
			,uv.Remuneration_End
			,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
			,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
			,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',rtrim(isnull(sub.[Group],'Miscellaneous')),uv.Team,uv.Measure)									
			, Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',rtrim(isnull(sub.[Group],'Miscellaneous')),uv.Team,uv.Measure)
						
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY uv.Team, rtrim(isnull(sub.[Group],'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT    rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
		  , rtrim(isnull(sub.AgencyName,'Miscellaneous')) as  Agency_Group
		  ,[Type] = 'agency' 
		  ,uv.Remuneration_Start
		  , uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY rtrim(isnull(sub.Sub_Category,'Miscellaneous')), rtrim(isnull(sub.AgencyName,'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Police & Fire & RFS--
UNION ALL

SELECT    rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
		  , 'POLICE & EMERGENCY SERVICES' as Agency_Group
		  ,[Type] = 'agency' 
		  ,uv.Remuneration_Start
		  , uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','POLICE & EMERGENCY SERVICES',rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','POLICE & EMERGENCY SERVICES',rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	  and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire','RFS')
GROUP BY rtrim(isnull(sub.Sub_Category,'Miscellaneous')),  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Health & Other--
UNION ALL

SELECT    rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
		  , 'Health & Other' as Agency_Group
		  ,[Type] = 'agency' 
		  ,uv.Remuneration_Start
		  , uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','Health & Other',rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','Health & Other',rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	  and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other') 
GROUP BY rtrim(isnull(sub.Sub_Category,'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO