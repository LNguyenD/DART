SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current')
	DROP VIEW [dbo].[uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current] 
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
			,rtrim(AgencyName) as Agency_Group
			,rtrim(Sub_Category) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency',rtrim(AgencyName),rtrim(Sub_Category),Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by AgencyName,Sub_Category,Measure,Remuneration_Start, Remuneration_End
	
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
			,'Police & Fire' as Agency_Group
			,rtrim(Sub_Category) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency','Police & Fire',rtrim(Sub_Category),Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM(AgencyName) in ('Police','Fire')
	group by Sub_Category,Measure,Remuneration_Start, Remuneration_End
	
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
			,'Health & Other' as Agency_Group
			,rtrim(Sub_Category) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency','Health & Other',rtrim(Sub_Category),Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM(AgencyName) in ('Health','Other')
	group by Sub_Category,Measure,Remuneration_Start, Remuneration_End
	
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
			,rtrim([Group]) as Agency_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','group',rtrim([Group]),rtrim(Team),Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Team,Measure,Remuneration_Start, Remuneration_End

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO