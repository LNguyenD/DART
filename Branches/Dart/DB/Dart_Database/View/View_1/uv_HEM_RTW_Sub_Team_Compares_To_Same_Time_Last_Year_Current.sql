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
	WITH temp AS 
	(
		select * 
		from
			(select 0 as month_period
			union all
			select 2 as month_period
			union all
			select 5 as month_period
			union all
			select 11 as month_period) as month_period
			cross join
			(select 13 as Measure_months
			union all
			select 26 as Measure_months
			union all
			select 52 as Measure_months
			union all
			select 78 as Measure_months
			union all
			select 104 as Measure_months) as measure_months		
			cross join
			(
			select distinct rtrim(Portfolio) as EmployerSize_Group, rtrim(EMPL_SIZE) as Team_Sub, [Type]='portfolio'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				and rtrim(Portfolio) IS NOT NULL
				
			union
			select distinct dbo.udf_HEM_GetGroupByTeam(Team) as EmployerSize_Group,rtrim(Team) as Team_Sub, [Type]='group'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				
			union
			select distinct rtrim([Account_Manager]) as EmployerSize_Group, rtrim(EMPL_SIZE) as Team_Sub, [Type]='account_manager'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				and rtrim([Account_Manager]) is not null
				
			union
			select distinct 'Hotel' as EmployerSize_Group ,rtrim(EMPL_SIZE) as Team_Sub, [Type]='portfolio'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				and rtrim(Portfolio) IS NOT NULL
				and rtrim([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')	
				
			) as temp_value
	)
	
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
			,dbo.udf_HEM_GetGroupByTeam(Team) as EmployerSize_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',dbo.udf_HEM_GetGroupByTeam(Team),rtrim(Team),Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by dbo.udf_HEM_GetGroupByTeam(Team),Team,Measure,Remuneration_Start, Remuneration_End
	
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
	
	--add missing measure months
	union all
	select Month_period=case when month_period = 0
							then 1
						 when month_period = 2
							then 3
						 when month_period = 5
							then 6
						 when month_period = 11
							then 12
					end
		  ,[Type]
		  ,EmployerSize_Group
		  ,Team_Sub
		  ,Measure_months
		  ,LT = 0
		  ,WGT = 0
		  ,AVGDURN = 0
		  ,[Target] = 0
	from temp as tmp
	where Measure_months not in (select distinct Measure from HEM_RTW uv
							where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
							and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) = tmp.month_period
							and case when [Type] = 'group' then dbo.udf_HEM_GetGroupByTeam(rtrim(uv.Team))
									 when [Type] = 'portfolio' then (case when EmployerSize_Group = 'hotel' and uv.Portfolio in ('Accommodation','Pubs, Taverns and Bars') then 'hotel'
																					   else rtrim(uv.Portfolio)
																				  end
																			     ) 
									 when [Type] = 'account_manager' then rtrim(uv.Account_Manager)
								end
									 = EmployerSize_Group
							and case when [Type] = 'group' then rtrim(uv.Team)
									 when [Type] = 'portfolio' then rtrim(uv.EMPL_SIZE) 
									 when [Type] = 'account_manager' then rtrim(uv.EMPL_SIZE)
								end
									 = Team_Sub)
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO