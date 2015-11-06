SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_EML_CPR_Dashboard_Sub_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_EML_CPR_Dashboard_Sub_Team]
GO

CREATE PROCEDURE [dbo].[usp_EML_CPR_Dashboard_Sub_Team]
(
	@Start_Date datetime
	,@End_Date datetime
	,@Is_Last_Month bit
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING
	
	-- NEW CLAIMS
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury =  0
	INTO #claim_new_all 
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE ISNULL(Date_Claim_Entered,Date_Claim_Received) between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE ISNULL(Date_Claim_Entered,Date_Claim_Received) between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE ISNULL(Date_Claim_Entered,Date_Claim_Received) between @Start_Date and @End_Date
	
	-- CLAIM CLOSURES
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury = 0
	INTO #claim_closure 
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury = 0
	INTO #claim_re_open 
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		
	-- REOPEN CLAIMS: STILL OPEN
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury = 0
	INTO #claim_re_open_still_open 
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	
	-- OPEN CLAIMS
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
	INTO #claim_open_all
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
	
	-- drop temp tables
	DROP TABLE #claim_new_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
	DROP TABLE #claim_open_all
	
	SELECT  tmp.[SubValue] as [Unit], tmp.[Value] as [Primary], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType])

		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Is_Medical_Only = 1)

		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Is_D_D = 1)
			
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType]
			and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
			
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'TU')
			
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
			
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
							
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 0)
			
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'PID')
			
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType]
			and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and NCMM_Actions_This_Week <> '')
			
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and NCMM_Actions_Next_Week <> '')
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, SubValue, [UnitType] = 'employer_size'
							from [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0
					union all
					select distinct Value, SubValue, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0
					union all
					select distinct Value, SubValue, [UnitType] = 'account_manager'
							from [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- add an overall column for employer sizes, groups and account managers
	SELECT  tmp.[SubValue] + '_total' as [Unit], tmp.[Value] as [Primary], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [Value]=tmp.[SubValue] and [UnitType]=tmp.[UnitType])

		,med_only = 0
		,d_d = 0
		,lum_sum_in = 0
		,totally_unfit = 0
		,ffsd_at_work_15_less = 0
		,ffsd_at_work_15_more = 0
		,ffsd_not_at_work = 0
		,pid = 0
		,therapy_treat = 0
		,ncmm_this_week = 0
		,ncmm_next_week = 0
	INTO #total2
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, [SubValue] = Value, [UnitType] = 'employer_size'
							from [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
							where Value <> '' and Claim_Closed_Flag <> 'Y'
							group by Value
							having COUNT(*) > 0
					union all
					select distinct Value, [SubValue] = Value, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
							where Value <> '' and Claim_Closed_Flag <> 'Y'
							group by Value
							having COUNT(*) > 0
					union all
					select distinct Value, [SubValue] = Value, [UnitType] = 'account_manager'
							from [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
							where Value <> '' and Claim_Closed_Flag <> 'Y'
							group by Value
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- drop temp table
	DROP TABLE #claim_all
	
	-- GET RESULTS
	SELECT * FROM #total
	UNION ALL
	SELECT * FROM #total2
		
	--drop temp table
	DROP table #total
	DROP table #total2
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO