SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous')
	DROP VIEW [dbo].[uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous] 
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
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
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
			,rtrim(AgencyName) as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by AgencyName,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	
	
	--Agency Police & Fire--
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
			,'POLICE & FIRE' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM(AgencyName) in ('Police','Fire')
	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	--Agency Health & Other--
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
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM(AgencyName) in ('Health','Other')
	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
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
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
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
			,rtrim([Group]) as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO