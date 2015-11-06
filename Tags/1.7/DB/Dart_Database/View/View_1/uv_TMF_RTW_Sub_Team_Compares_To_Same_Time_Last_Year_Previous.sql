SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous')
	DROP VIEW [dbo].[uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous] 
AS
	--Agency---		
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,rtrim(isnull(sub.AgencyName,'Miscellaneous')) as Agency_Group
			,rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by rtrim(isnull(sub.AgencyName,'Miscellaneous')),rtrim(isnull(sub.Sub_Category,'Miscellaneous')),Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)		
		
	--Agency Police & Fire--
	Union All
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,'POLICE & EMERGENCY SERVICES' as Agency_Group
			,rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire', 'RFS') 

	group by rtrim(isnull(sub.Sub_Category,'Miscellaneous')),Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)		
	
	--Agency Health & Other--
	Union All
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,'Health & Other' as Agency_Group
			,rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other') 

	group by rtrim(isnull(sub.Sub_Category,'Miscellaneous')),Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	
		
	---Group---
	union all 
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='group'
			,rtrim(isnull(sub.[Group],'Miscellaneous')) as Agency_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by rtrim(isnull(sub.[Group],'Miscellaneous')),Team,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO