SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current')
	DROP VIEW [dbo].[uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current] 
AS
	---Group---			
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,rtrim([Group]) as EmployerSize_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',rtrim([Group]),rtrim(Team),Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Team,Measure,Remuneration_Start, Remuneration_End
	
	--Account Manager--
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
			,[Type]='account_manager'
			,rtrim([Account_Manager]) as EmployerSize_Group
			,rtrim(EMPL_SIZE) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',rtrim([Account_Manager]),rtrim(EMPL_SIZE),Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Account_Manager])is not null

	group by [Account_Manager],EMPL_SIZE,Measure,Remuneration_Start, Remuneration_End
	
	--Portfolio--
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
			,[Type]='portfolio'
			,rtrim([Portfolio]) as EmployerSize_Group
			,rtrim(EMPL_SIZE) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio',rtrim([Portfolio]),rtrim(EMPL_SIZE),Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Portfolio])is not null

	group by [Portfolio],EMPL_SIZE,Measure, Remuneration_Start, Remuneration_End
	
	--Portfolio Hotel Summary--
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
			,[Type]='portfolio'
			,'Hotel' as EmployerSize_Group
			,rtrim(EMPL_SIZE) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio','Hotel',rtrim(EMPL_SIZE),Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Portfolio])is not null
		   and rtrim([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')

	group by EMPL_SIZE,Measure, Remuneration_Start, Remuneration_End
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO