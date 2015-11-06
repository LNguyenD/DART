SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PORT_ClaimOfficer_Summary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PORT_ClaimOfficer_Summary]
GO

CREATE PROCEDURE [dbo].[usp_PORT_ClaimOfficer_Summary]
(
	@System VARCHAR(20)
	,@Type VARCHAR(20)
	,@Value NVARCHAR(256)
	,@SubValue NVARCHAR(256)
	,@Start_Date DATETIME
	,@End_Date DATETIME
	,@Claim_Liability_Indicator NVARCHAR(256)
	,@Psychological_Claims VARCHAR(10)
	,@Inactive_Claims VARCHAR(10)
	,@Medically_Discharged VARCHAR(10)
	,@Exempt_From_Reform VARCHAR(10)
	,@Reactivation VARCHAR(10)
)
AS
BEGIN
	IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total
	IF OBJECT_ID('tempdb..#claim_all') IS NOT NULL DROP TABLE #claim_all
	IF OBJECT_ID('tempdb..#claim_new_all') IS NOT NULL DROP TABLE #claim_new_all
	IF OBJECT_ID('tempdb..#claim_open_all') IS NOT NULL DROP TABLE #claim_open_all
	IF OBJECT_ID('tempdb..#claim_closure') IS NOT NULL DROP TABLE #claim_closure
	IF OBJECT_ID('tempdb..#claim_re_open') IS NOT NULL DROP TABLE #claim_re_open
	IF OBJECT_ID('tempdb..#claim_re_open_still_open') IS NOT NULL DROP TABLE #claim_re_open_still_open
	IF OBJECT_ID('tempdb..#claim_list') IS NOT NULL DROP TABLE #claim_list
	IF OBJECT_ID('tempdb..#pre_claim_list') IS NOT NULL DROP TABLE #pre_claim_list
	IF OBJECT_ID('tempdb..#reporting_date') IS NOT NULL DROP TABLE #reporting_date

	-- Determine the last month period
	DECLARE @LastMonth_Start_Date datetime = DATEADD(m, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0))
	DECLARE @LastMonth_End_Date datetime = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59'
	
	-- Determine last two weeks: Start = last two weeks from yesterday; End = yesterday
	DECLARE @Last2Weeks_Start_Date datetime = DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
	DECLARE @Last2Weeks_End_Date datetime = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	
	DECLARE @IsLastMonthRange bit = 0
	IF DATEDIFF(d, @LastMonth_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @LastMonth_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLastMonthRange = 1
	END
	
	DECLARE @IsLast2WeeksRange bit = 0
	IF DATEDIFF(d, @Last2Weeks_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @Last2Weeks_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLast2WeeksRange = 1
	END
	
	-- Determine period type
	DECLARE @Period_Type int
	IF @IsLastMonthRange = 1
	BEGIN
		SET @Period_Type = 1
	END
	ELSE IF @IsLast2WeeksRange = 1
	BEGIN
		SET @Period_Type = 0
	END
	ELSE IF @IsLastMonthRange = 0 AND @IsLast2WeeksRange = 0
	BEGIN
		SET @Period_Type = -1
	END
	
	-- Append time to @End_Date
	SET @End_Date = DATEADD(dd, DATEDIFF(dd, 0, @End_Date), 0) + '23:59'
	
	-- Prepare data before querying
	
	DECLARE @SQL varchar(MAX)
	
	CREATE TABLE #reporting_date
	(
		Reporting_Date datetime null,
		IsPre bit null
	)
	
	-- Determine filter conditions
	DECLARE @Is_Last_Month bit
	IF @Period_Type = -1
	BEGIN
		SET @Is_Last_Month = 0
		SET @SQL = 'SELECT top 1 Reporting_Date, 0 FROM ' + @System + '_Portfolio
			WHERE CONVERT(datetime, Reporting_Date, 101) 
				>= CONVERT(datetime, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''', 101) order by Reporting_Date'
		
		INSERT INTO #reporting_date
		EXEC(@SQL)
	END
	ELSE
	BEGIN
		SET @Is_Last_Month = @Period_Type
		SET @SQL = 'SELECT MAX(Reporting_Date), 0 FROM ' + @System + '_Portfolio'
				
		INSERT INTO #reporting_date
		EXEC(@SQL)
	END
	
	-- Determine current Reporting date
	DECLARE @Reporting_Date datetime
	SELECT TOP 1 @Reporting_Date = Reporting_Date FROM #reporting_date WHERE IsPre = 0
	
	CREATE TABLE #claim_list
	(
		[Value] [varchar](256) NULL,
		[SubValue] [varchar](256) NULL,
		[SubValue2] [varchar](256) NULL,
		[Claim_No] [varchar](19) NULL,
		[Date_Of_Injury] [datetime] NULL,
		[Claim_Liability_Indicator_Group] [varchar](256) NULL,
		[Is_Time_Lost] [bit] NULL,
		[Claim_Closed_Flag] [nchar](1) NULL,
		[Date_Claim_Entered] [datetime] NULL,
		[Date_Claim_Closed] [datetime] NULL,
		[Date_Claim_Received] [datetime] NULL,
		[Date_Claim_Reopened] [datetime] NULL,
		[Result_Of_Injury_Code] [int] NULL,
		[WPI] [float] NULL,
		[Common_Law] [bit] NULL,
		[Total_Recoveries] [float] NULL,
		[Med_Cert_Status] [varchar](20) NULL,
		[Is_Working] [bit] NULL,
		[Physio_Paid] [float] NULL,
		[Chiro_Paid] [float] NULL,
		[Massage_Paid] [float] NULL,
		[Osteopathy_Paid] [float] NULL,
		[Acupuncture_Paid] [float] NULL,
		[Is_Stress] [bit] NULL,
		[Is_Inactive_Claims] [bit] NULL,
		[Is_Medically_Discharged] [bit] NULL,
		[Is_Exempt] [bit] NULL,
		[Is_Reactive] [bit] NULL,
		[Is_Medical_Only] [bit] NULL,
		[Is_D_D] [bit] NULL,
		[NCMM_Actions_This_Week] [varchar](256) NULL,
		[NCMM_Actions_Next_Week] [varchar](256) NULL,
		[HoursPerWeek] [numeric](5, 2) NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Rehab_Paid] [float] NULL,
		[IsPreClosed] [bit] NULL,
		[IsPreOpened] [bit] NULL
	)
	
	SET @SQL = 'SELECT Value=' + case when UPPER(@System) = 'TMF'
										then
											case when @Type='agency'
													then + 'rtrim(isnull(sub.AgencyName,''Miscellaneous''))'
												else 'dbo.udf_TMF_GetGroupByTeam(Team)'
											end
									when UPPER(@System) = 'EML'
										then
											case when @Type='employer_size' 
													then '[EMPL_SIZE]' 
												when @Type='group' 
													then 'dbo.udf_EML_GetGroupByTeam(Team)' 
												else '[account_manager]' 
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type='account_manager' 
													then '[Account_Manager]' 
												when @Type = 'portfolio'
													then '[portfolio]' 
												else 'dbo.udf_HEM_GetGroupByTeam(Team)'
											end
								end	+
				',SubValue=' + case when UPPER(@System) = 'TMF'
										then
											case when @Type='agency'
													then 'rtrim(isnull(sub.Sub_Category,''Miscellaneous''))'
												else '[Team]'
											end
									when UPPER(@System) = 'EML'
										then
											case when @Type='group'
													then '[Team]'
												else '[EMPL_SIZE]'
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type='account_manager' or @Type = 'portfolio' 
													then '[EMPL_SIZE]' 
												else '[Team]' 
											end
								end	+
				',SubValue2=[Claims_Officer_Name]
				,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
				,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
				,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
				,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
				,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
				,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
				,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[IsPreClosed],[IsPreOpened]' +
					case when UPPER(@System) = 'TMF'
							then ' FROM TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No'
						when UPPER(@System) = 'EML'
							then ' FROM EML_Portfolio'
						when UPPER(@System) = 'HEM'
							then ' FROM HEM_Portfolio'
					end +
				' WHERE ISNULL(Is_Last_Month, 0)=' + CONVERT(VARCHAR, @Is_Last_Month) +
					' AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date, 120) + ''''
	
	INSERT INTO #claim_list
	EXEC(@SQL)
	
	CREATE TABLE #pre_claim_list
	(
		[Claim_No] [varchar](19) NULL,
		[Claim_Closed_Flag] [nchar](1) NULL
	)
	
	DECLARE @Reporting_Date_pre datetime
	
	IF @IsLast2WeeksRange <> 1 and @IsLastMonthRange <> 1
	BEGIN
		SET @SQL = 'SELECT top 1 Reporting_Date, 1 FROM ' + @System + '_Portfolio
					WHERE CONVERT(datetime, Reporting_Date, 101)
						>= CONVERT(datetime, DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''') + ''23:59'', 101) order by Reporting_Date'
				
		INSERT INTO #reporting_date
		EXEC(@SQL)
		
		-- Determine previous Reporting date
		SELECT TOP 1 @Reporting_Date_pre = Reporting_Date FROM #reporting_date WHERE IsPre = 1
		
		SET @SQL = 'SELECT Claim_No, Claim_Closed_Flag
					FROM ' + @System + '_Portfolio
					WHERE ISNULL(Is_Last_Month,0) = 0
						AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date_pre, 120) + ''''
						
		INSERT INTO #pre_claim_list
		EXEC(@SQL)
	END
	
	-- Drop temp table
	IF OBJECT_ID('tempdb..#reporting_date') IS NOT NULL DROP TABLE #reporting_date

	-- NEW CLAIMS
	SELECT *, weeks_since_injury = 0
	INTO #claim_new_all 
	FROM #claim_list
	WHERE ISNULL(Date_Claim_Entered,Date_Claim_Received) between @Start_Date and @End_Date
		  and (case when @Claim_Liability_Indicator <> 'all' then Claim_Liability_Indicator_Group	else '1' end)
				= (case when @Claim_Liability_Indicator <> 'all' then @Claim_Liability_Indicator else '1' end)
				
	-- OPEN CLAIMS
	SELECT *, weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0 
	INTO #claim_open_all
	FROM #claim_list
	WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date) 
			and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
			
			and (case when @Psychological_Claims <> 'all' then Is_Stress else '1' end)
				= (case when @Psychological_Claims <> 'all'	then @Psychological_Claims	else '1' end)

			and (case when @Inactive_Claims <> 'all' then Is_Inactive_Claims else '1' end)
				= (case when @Inactive_Claims <> 'all'	then  @Inactive_Claims	else '1' end)

			and (case when @Medically_Discharged <> 'all' then Is_Medically_Discharged	else '1' end)
				= (case when @Medically_Discharged <> 'all' then @Medically_Discharged else '1'	end)

			and (case when @Exempt_From_Reform <> 'all'	then Is_Exempt	else '1' end)
				= (case when @Exempt_From_Reform <> 'all' then @Exempt_From_Reform	else '1' end)

			and (case when @Reactivation <> 'all' then Is_Reactive	else '1' end)
				= (case when @Reactivation <> 'all'	then @Reactivation	else '1' end)
	
	-- CLAIM CLOSURES
	-- @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 => use IsPreOpened = 1 condition else => bypass this condition
	SELECT *, weeks_since_injury = 0
	INTO #claim_closure
	FROM #claim_list cpr
	WHERE Date_Claim_Closed between @Start_Date and @End_Date
		and Claim_Closed_Flag = 'Y'
		and (case when @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 then IsPreOpened else 1 end) = 1
		and (@IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 
			or exists (SELECT [Claim_No] FROM #pre_claim_list cpr_pre
							WHERE cpr_pre.Claim_No = cpr.Claim_No AND cpr_pre.Claim_Closed_Flag = 'N')
			or ISNULL(cpr.Date_Claim_Entered, cpr.date_claim_received) >= @Start_Date)
	
	-- REOPEN CLAIMS
	SELECT *, weeks_since_injury = 0
	INTO #claim_re_open 
	FROM #claim_list
	WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS: STILL OPEN
	-- @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 => use IsPreClosed = 1 condition else => bypass this condition
	SELECT *, weeks_since_injury = 0
	INTO #claim_re_open_still_open
	FROM #claim_list cpr
	WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		and Claim_Closed_Flag <> 'Y'
		and (case when @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 then IsPreClosed else 1 end) = 1
		and (@IsLastMonthRange = 1 or @IsLast2WeeksRange = 1
			or exists (SELECT [Claim_No] FROM #pre_claim_list cpr_pre
							WHERE cpr_pre.Claim_No = cpr.Claim_No AND cpr_pre.Claim_Closed_Flag = 'Y'))
							
	-- Drop temp table
	IF OBJECT_ID('tempdb..#pre_claim_list') IS NOT NULL DROP TABLE #pre_claim_list
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
				union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
				union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
				union all select *,claim_type='claim_open_all' from #claim_open_all
				union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
				union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
				union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
				union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
				union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
				union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
				union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
				union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
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
				union all select *,claim_type='claim_closure' from #claim_closure
				union all select *,claim_type='claim_re_open' from #claim_re_open
				union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   ) as tmp
			   
	-- Drop temp tables
	IF OBJECT_ID('tempdb..#claim_new_all') IS NOT NULL DROP TABLE #claim_new_all
	IF OBJECT_ID('tempdb..#claim_open_all') IS NOT NULL DROP TABLE #claim_open_all
	IF OBJECT_ID('tempdb..#claim_closure') IS NOT NULL DROP TABLE #claim_closure
	IF OBJECT_ID('tempdb..#claim_re_open') IS NOT NULL DROP TABLE #claim_re_open
	IF OBJECT_ID('tempdb..#claim_re_open_still_open') IS NOT NULL DROP TABLE #claim_re_open_still_open
			
	SELECT  tmp.Value,Claim_type, tmp.iClaim_Type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value)
						
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and  Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
		
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and  Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
						
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all	where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and  Med_Cert_Status = 'SID' and Is_Working = 0)
		
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and  Med_Cert_Status = 'PID')
		
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and  Med_Cert_Status = 'TU')
		
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value 
						and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))
		
		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and Is_D_D = 1)
		
		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and Is_Medical_Only = 1)
		
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value
						and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
		
				
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and NCMM_Actions_This_Week <> '')
		
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and NCMM_Actions_Next_Week <> '') 
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct SubValue2 as Value from #claim_list
					where Value=@Value and SubValue=@SubValue and SubValue2 <> '' and Claim_Closed_Flag <> 'Y'
					group by SubValue2
					having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- Drop temp tables
	IF OBJECT_ID('tempdb..#claim_all') IS NOT NULL DROP TABLE #claim_all
	IF OBJECT_ID('tempdb..#claim_list') IS NOT NULL DROP TABLE #claim_list
	
	-- Total
	INSERT INTO #total
	SELECT Value = @SubValue + '_total', Claim_Type, iClaim_Type, SUM(overall) as overall, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(totally_unfit) as totally_unfit, SUM(therapy_treat) as therapy_treat, SUM(d_d) as d_d, SUM(med_only) as med_only, SUM(lum_sum_in) as lum_sum_in, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	GROUP BY Claim_Type, iClaim_Type
	
	-- Transform returning table structure and get results
	SET @SQL = 'SELECT Value,
						Claim_Type, 
						[Type] = tmp_port_type.PORT_Type,
						[Sum] = (select (case when tmp_port_type.PORT_Type = ''overall''
												then tmp_total_2.overall
											when tmp_port_type.PORT_Type = ''ffsd_at_work_15_less''
												then tmp_total_2.ffsd_at_work_15_less
											when tmp_port_type.PORT_Type = ''ffsd_at_work_15_more''
												then tmp_total_2.ffsd_at_work_15_more
											when tmp_port_type.PORT_Type = ''ffsd_not_at_work''
												then tmp_total_2.ffsd_not_at_work
											when tmp_port_type.PORT_Type = ''pid''
												then tmp_total_2.pid
											when tmp_port_type.PORT_Type = ''totally_unfit''
												then tmp_total_2.totally_unfit
											when tmp_port_type.PORT_Type = ''therapy_treat''
												then tmp_total_2.therapy_treat
											when tmp_port_type.PORT_Type = ''d_d''
												then tmp_total_2.d_d
											when tmp_port_type.PORT_Type = ''med_only''
												then tmp_total_2.med_only
											when tmp_port_type.PORT_Type = ''lum_sum_in''
												then tmp_total_2.lum_sum_in
											when tmp_port_type.PORT_Type = ''ncmm_this_week''
												then tmp_total_2.ncmm_this_week
											when tmp_port_type.PORT_Type = ''ncmm_next_week''
												then tmp_total_2.ncmm_next_week
										end)
									from #total tmp_total_2
									where tmp_total_2.[Value] = tmp_total.[Value]
										and tmp_total_2.Claim_Type = tmp_total.Claim_Type)
				FROM #total tmp_total
				CROSS JOIN (SELECT * from dbo.uv_PORT_Get_All_PORT_Type) tmp_port_type
				ORDER BY Value, iClaim_Type, tmp_port_type.iPORT_Type'
	
	-- Get final results
	EXEC(@SQL)
	
	-- Drop temp table
	IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO