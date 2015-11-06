SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current')
	DROP VIEW [dbo].[uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current] 
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
			,'TMF' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency','TMF',NULL,Measure),0)	
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
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
			,[type]='agency'
			,rtrim(isnull(sub.AgencyName,'Miscellaneous')) as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),NULL,Measure),0)
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   
	group by rtrim(isnull(sub.AgencyName,'Miscellaneous')),Measure, Remuneration_Start, Remuneration_End
	
	--Agency Police & Fire
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
			,[type]='agency'
			,'POLICE & EMERGENCY SERVICES' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency','POLICE & EMERGENCY SERVICES',NULL,Measure),0)
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire')

	group by Measure, Remuneration_Start, Remuneration_End
	
	--Agency Health & Other
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
			,[type]='agency'
			,'HEALTH & OTHER' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency','Health & Other',NULL,Measure),0)
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other')

	group by Measure, Remuneration_Start, Remuneration_End
	
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
			,'TMF' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','group','TMF',NULL,Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
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
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','group',rtrim(isnull(sub.[group],'Miscellaneous')),NULL,Measure),0)
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by rtrim(isnull(sub.[Group],'Miscellaneous')),Measure,Remuneration_Start, Remuneration_End	
	
	union all 
	select  Month_period
			,[type]
			,Agency_Group
			,Measure_months
			,LT
			,WGT
			,AVGDURN
			,[Target]
	from dbo.udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group()
	where Measure_months not in (select distinct Measure from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
							where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
							and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) = case when month_period = 1 then 0
																						   when month_period = 3 then 2
																						   when month_period = 6 then 5
																						   when month_period = 12 then 11
																					  end
							and CHARINDEX(case when RTRIM(Agency_Group) = 'TMF' then 'TMF' else RTRIM(sub.AgencyName) end, RTRIM(Agency_Group),0) > 0
							)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO