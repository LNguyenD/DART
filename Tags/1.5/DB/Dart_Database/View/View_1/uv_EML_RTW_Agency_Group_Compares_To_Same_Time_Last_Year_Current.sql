SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current')
	DROP VIEW [dbo].[uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current]
GO
CREATE VIEW [dbo].[uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current] 
AS
	--Employer size---	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='employer_size'
			,'WCNSW' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','','EML',NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
	union all
	select top 100000000 Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='employer_size'
			,rtrim(EMPL_SIZE) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','employer_size',rtrim(EMPL_SIZE),NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by EMPL_SIZE,Measure,Remuneration_Start, Remuneration_End
	order by EMPL_SIZE
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
			,[Type]='group'
			,'WCNSW' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','','EML',NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
	union all
	select top 100000000 Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
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
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','group',rtrim([Group]),NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Measure,Remuneration_Start, Remuneration_End	
	order by [Group]
	---Account manager---
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
			,'WCNSW' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','','EML',NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
	union all
	select top 100000000 Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
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
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','account_manager',rtrim([Account_Manager]),NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Account_Manager]) is not null

	group by [Account_Manager],Measure,Remuneration_Start, Remuneration_End
	order by [Account_Manager]
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO