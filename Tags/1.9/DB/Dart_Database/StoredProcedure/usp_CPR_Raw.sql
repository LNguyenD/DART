SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CPR_Raw]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CPR_Raw]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Raw]
(
	@System nvarchar(20)
	,@Type nvarchar(100)
	,@Value nvarchar(100)
	,@SubValue nvarchar(100)
	,@SubSubValue nvarchar(100)
	,@ClaimType nvarchar(100)
	,@Start_Date datetime
	,@End_Date datetime
	,@Claim_Liability_Indicator nvarchar(100)
	,@Psychological_Claims nvarchar(100)
	,@Inactive_Claims nvarchar(10)
	,@Medically_Discharged nvarchar(10)
	,@Exempt_From_Reform nvarchar(100)
	,@Reactivation nvarchar(100)
	,@Claim_No varchar(19) = NULL
	,@View_Type varchar(20) = NULL
)
AS
BEGIN
	IF OBJECT_ID('tempdb..#cpr_preopen') IS NOT NULL DROP TABLE #cpr_preopen
	IF OBJECT_ID('tempdb..#cpr_preclose') IS NOT NULL DROP TABLE #cpr_preclose
	IF OBJECT_ID('tempdb..#reporting_date') IS NOT NULL DROP TABLE #reporting_date
	IF OBJECT_ID('tempdb..#brokers10') IS NOT NULL DROP TABLE #brokers10
	
	/* Get the latest cut-off date from CONTROL table */
	DECLARE @cut_off_date_dte datetime = [dbo].udf_GetCPR_CutOffDate(@System)
		
	/* Determine the last month period */
	DECLARE @LastMonth_Start_Date datetime = [dbo].udf_GetCPR_LastMonthDate(@cut_off_date_dte, 0)
	DECLARE @LastMonth_End_Date datetime = [dbo].udf_GetCPR_LastMonthDate(@cut_off_date_dte, 1)
	
	/* Determine last two weeks period */
	DECLARE @Last2Weeks_Start_Date datetime = [dbo].udf_GetCPR_Last2WeeksDate(@cut_off_date_dte, 0)
	DECLARE @Last2Weeks_End_Date datetime = [dbo].udf_GetCPR_Last2WeeksDate(@cut_off_date_dte, 1)
	
	DECLARE @IsLastMonthRange bit = 0
	IF @View_Type = 'last_month' OR (DATEDIFF(d, @LastMonth_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @LastMonth_End_Date, @End_Date) = 0)
	BEGIN
		SET @IsLastMonthRange = 1
		SET @Start_Date = @LastMonth_Start_Date
		SET @End_Date = @LastMonth_End_Date
	END
	
	DECLARE @IsLast2WeeksRange bit = 0
	IF @View_Type = 'last_two_weeks' OR (DATEDIFF(d, @Last2Weeks_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @Last2Weeks_End_Date, @End_Date) = 0)
	BEGIN
		SET @IsLast2WeeksRange = 1
		SET @Start_Date = @Last2Weeks_Start_Date
		SET @End_Date = @Last2Weeks_End_Date
	END
	
	/* Determine period type */
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
		IF @Claim_No is not null and @Claim_No <> ''
			SET @Period_Type = -2
		ELSE
			SET @Period_Type = -1
	END
	
	/* Prepare data before querying */
	
	DECLARE @SQL varchar(MAX)
	DECLARE @SQL_select varchar(MAX)
	DECLARE @SQL_broker varchar(MAX)
	DECLARE @SQL_tmp varchar(MAX)
	
	CREATE TABLE #reporting_date
	(
		Reporting_Date datetime null,
		IsPre bit null
	)
	
	/* Determine filter conditions */
	DECLARE @Is_Last_Month bit
	DECLARE @Reporting_Date datetime
	
	IF @Period_Type = -1
	BEGIN
		SET @Is_Last_Month = 0
		SET @SQL_tmp = 'SELECT top 1 Reporting_Date, 0 FROM ' + @System + '_Portfolio
						WHERE CONVERT(datetime, Reporting_Date, 101)
							>= CONVERT(datetime, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''', 101) order by Reporting_Date'
				
		INSERT INTO #reporting_date
		EXEC(@SQL_tmp)
	END
	ELSE IF @Period_Type = -2
	BEGIN
		SET @Is_Last_Month = 0
		SET @SQL_tmp = 'SELECT top 1 Reporting_Date, 0 FROM ' + @System + '_Portfolio
						WHERE Claim_No = ''' + @Claim_No + ''' ORDER BY Reporting_Date DESC'
				
		INSERT INTO #reporting_date
		EXEC(@SQL_tmp)
	END
	ELSE
	BEGIN
		SET @Is_Last_Month = @Period_Type
		SET @SQL_tmp = 'SELECT MAX(Reporting_Date), 0 FROM ' + @System + '_Portfolio'
		
		INSERT INTO #reporting_date
		EXEC(@SQL_tmp)
	END
	
	SELECT TOP 1 @Reporting_Date = Reporting_Date FROM #reporting_date WHERE IsPre = 0
	DECLARE @Reporting_Date_pre datetime
	
	/* Create #brokers10 table to store Top 10 brokers by largest Open claims (ONLY FOR EML/HEM) */
	CREATE TABLE #brokers10
	(
		[Broker_Name] [varchar](256) NULL
	)
	
	SET @SQL_select = 'SELECT * '
	SET @SQL = 'FROM [dbo].[uv_PORT] cpr
				WHERE [System] = ''' + @System + ''' ' +
				
				/* Append the filter condition based on specified @Claim_No */
				(case when @Claim_No is not null and @Claim_No <> '' then ' and Claim_No = ''' + @Claim_No + ''' '
						else ''
				end)
				+

				/* Append the filter condition based on @Value */
				(case when UPPER(@System) = 'EML'
						then case when @value <> 'all' and @Type = 'employer_size' then ' and [EMPL_SIZE] = ''' +  @Value + ''''
									when @value <> 'all' and @Type = 'group' then ' and [Group] = ''' +  @Value + ''''
									when @value <> 'all' and @Type = 'account_manager' then ' and [Account_Manager] = ''' +  @Value + ''''
									when @value <> 'all' and @Type = 'broker' then ' and [Broker_Name] = ''' +  @Value + ''''
									when @Value = 'all' then ''
									else ''
							end
						else ''
				end)
				+							 
				(case when UPPER(@System) = 'TMF'
						then case when @Value <> 'all' and @Value <> 'health@@@other' and @Value <> 'police@@@emergency services' and @Type = 'agency' then ' and [Agency_Name] = ''' + @Value + ''''
								when @Value <> 'all' and @Type = 'group' then ' and [Group] = ''' + @Value	+ ''''
								when @Value = 'health@@@other' then ' and [Agency_Name] in (''health'',''other'')'
								when @Value = 'police@@@emergency services' then ' and [Agency_Name] in (''police'',''fire'',''rfs'')'
								when @Value = 'all' then ''
								else ''
							end
					else ''
				end)
				+
				(case when UPPER(@System) = 'HEM' 
						then case when @Value <> 'all' and @Value <> 'hotel' and @Type = 'portfolio' then ' and [Portfolio] = ''' + @Value + ''''
								 when @Value <> 'all' and @Type = 'group' then ' and [Group] = ''' + @Value	 + ''''
								 when @value <> 'all' and @Type = 'broker' then ' and [Broker_Name] = ''' +  @Value + ''''
								 when @Value = 'hotel' then ' and [Portfolio] in (''Accommodation'',''Pubs, Taverns and Bars'') '
								 when @Value = 'all' then ''
								else ''
							end
					else ''
				end)
				+
				(case when UPPER(@System) = 'WOW'
						then case	when @value <> 'all' and @Type = 'group' then ' and [Group] = ''' +  @value + ''''
									when @value <> 'all' and @Type = 'state' then ' and [State] = ''' +  @value + ''''
									when @value <> 'all' and @Type = 'division' then ' and [Division] = ''' +  @value + ''''																																									
									when @Value = 'all' then ''
									else ''
							end
						else ''
				end)
				+
				
				/* Append the filter condition based on @SubValue */
				(case when @SubValue <> 'all' and @Type = 'group' then ' and [Team] = ''' + @SubValue + ''''
					  when @SubValue <> 'all' and @Type = 'account_manager' then ' and [EMPL_SIZE] = ''' + @SubValue + ''''	
					  when @SubValue <> 'all' and @Type = 'portfolio' then ' and [EMPL_SIZE] = ''' + @SubValue + ''''
					  when @SubValue <> 'all' and @Type = 'group' then ' and [Team] = ''' + @SubValue		+ ''''	
					  when @SubValue <> 'all' and @Type = 'agency' then ' and [Sub_Category] = ''' + @SubValue + ''''
					  when @SubValue <> 'all' and @Type = 'division' then ' and [State] = ''' + @SubValue + ''''
					  when @SubValue <> 'all' and @Type = 'State' then ' and [Division] = ''' + @SubValue + ''''
					  when @SubValue = 'all' then ''					 						 
					 else ''
				end) 
				 +
				 
				 /* Append the filter condition based on @SubSubValue */
				(case when @SubSubValue <> 'all' then ' and [Claims_Officer_Name] = ''' + @SubSubValue + ''''
					else ''
				end)

	/* Append the filter condition based on @ClaimType */
	
	SET @SQL = @SQL + (case when @ClaimType like '%med_only'
								then ' and [Is_Medical_Only] = 1'
							when @ClaimType like '%d_d' 
								then ' and [Is_D_D] = 1'
							when @ClaimType like '%lum_sum_in'
								then ' and ([Total_Recoveries] <> 0 or [Common_Law] = 1 or [Result_Of_Injury_Code] = 3 or [Result_Of_Injury_Code] = 1 or ([WPI] >= 0 and [WPI] is not null) or [Is_Industrial_Deafness] = 1)'												
							when @ClaimType like '%totally_unfit'
								then ' and [Med_Cert_Status] = ''' + case when UPPER(@System) = 'WOW' then 'Totally unfit' else 'TU' end + ''''
							when @ClaimType like '%ffsd_at_work_15_less'
								then ' and [Med_Cert_Status] = ''' + case when UPPER(@System) = 'WOW' then 'Partial' else 'SID' end + ''' and Is_Working = 1 and HoursPerWeek <= 15'
							when @ClaimType like '%ffsd_at_work_15_more'
								then ' and [Med_Cert_Status] = ''' + case when UPPER(@System) = 'WOW' then 'Partial' else 'SID' end + ''' And Is_Working = 1 and HoursPerWeek > 15'
							when @ClaimType like '%ffsd_not_at_work'
								then ' and [Med_Cert_Status] = ''' + case when UPPER(@System) = 'WOW' then 'Partial' else 'SID' end + ''' And Is_Working = 0'
							when @ClaimType like '%pid'
								then ' and [Med_Cert_Status] = ''' + case when UPPER(@System) = 'WOW' then 'Pre-injury duties' else 'PID' end + ''''
							when @ClaimType like '%therapy_treat'
								then ' and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Acupuncture_Paid > 0 or Osteopathy_Paid > 0 or Rehab_Paid > 0) '													
							when @ClaimType like '%ncmm_this_week'
								 then ' and [NCMM_Actions_This_Week] <> '''' and [NCMM_Complete_Action_Due] > ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
							when @ClaimType like '%ncmm_next_week'
								then ' and [NCMM_Actions_Next_Week] <> ''''
									and [NCMM_Prepare_Action_Due] BETWEEN ''' + CONVERT(VARCHAR, DATEADD(week, 1, @End_Date), 120) + ''' AND ''' + CONVERT(VARCHAR, DATEADD(week, 3, @End_Date), 120) + ''''
							else '' 
						end)
	
	/* Apply the user input filters */
	SET @SQL = @SQL + case when @Claim_Liability_Indicator <> 'all'
								then ' and dbo.udf_GetLiabilityCodeByDescription(''' + UPPER(@System) + ''',[Claim_Liability_Indicator_Group]) in (''' + REPLACE(@Claim_Liability_Indicator,'|',''',''') + ''')' 
							else ''
						end
	SET @SQL = @SQL + case when @Psychological_Claims <> 'all' then ' and [Is_Stress] = ''' + @Psychological_Claims + '''' else '' end
	SET @SQL = @SQL + case when @Inactive_Claims <> 'all' then ' and [Is_Inactive_Claims] = ''' + @Inactive_Claims + '''' else '' end
	SET @SQL = @SQL + case when @Medically_Discharged <> 'all' then ' and [Is_Medically_Discharged] = ''' + @Medically_Discharged + '''' else '' end
	SET @SQL = @SQL + case when @Exempt_From_Reform <> 'all' then ' and [Is_Exempt] = ''' + @Exempt_From_Reform + '''' else '' end
	SET @SQL = @SQL + case when @Reactivation <> 'all' then ' and [Is_Reactive] = ''' + @Reactivation + '''' else '' end
	
	/* In case EML/HEM with broker type at total column of top level */
	IF UPPER(@System) IN ('EML', 'HEM') AND @Type = 'broker' AND @Value = 'all'
	BEGIN
		SET @SQL_broker = 'SELECT TOP 10 Broker_Name ' + @SQL + '
								AND (Date_Claim_Closed is null or Date_Claim_Closed < ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')
										and (Date_Claim_Reopened is null or Date_Claim_Reopened < ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')
										and Claim_Closed_Flag <> ''Y''' + '
								AND ISNULL(Is_Last_Month, 0) = ' + CONVERT(VARCHAR, @Is_Last_Month) + '
								AND Reporting_Date = ''' + CONVERT(VARCHAR, ISNULL(@Reporting_Date,''), 120) + '''
								GROUP BY Broker_Name 
								HAVING Broker_Name <> ''''
								ORDER BY COUNT(DISTINCT Claim_No) DESC'
								
		INSERT INTO #brokers10
		EXEC(@SQL_broker)
	END
	
	/* Build up main SQL query */
	SET @SQL = @SQL_select + @SQL
						  
	/* Append more filter condition based on @ClaimType */
											  
	IF @ClaimType like 'claim_new%'
	BEGIN
		SET @SQL = @SQL + ' and ISNULL(Date_Claim_Entered,Date_Claim_Received)
								between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
		
		SET @SQL = @SQL + case when @ClaimType like 'claim_new_nlt%' then ' and[Is_Time_Lost] = 0'
								when @ClaimType like 'claim_new_lt%' then ' and [Is_Time_Lost] = 1' 
								else ''
							end
	END
	ELSE IF @ClaimType like 'claim_open%'
	BEGIN
		SET @SQL = @SQL + case when UPPER(@System) = 'WOW'
									then ' and Date_Status_Changed <= ''' + CONVERT(VARCHAR, @End_Date, 120) + ''' and Claim_Closed_Flag <> ''Y'' and [ClaimStatus] <> ''N'''
								else ' and (Date_Claim_Closed is null or Date_Claim_Closed < ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')
										and (Date_Claim_Reopened is null or Date_Claim_Reopened < ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')
										and Claim_Closed_Flag <> ''Y'''
							end
							+ 
							case when @ClaimType like 'claim_open_0_13%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 0 and 
											DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 <= 13'
								when @ClaimType like 'claim_open_13_26%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 13 and 
											DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 <= 26'
								when @ClaimType like 'claim_open_26_52%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 26 and 
											DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 <= 52'
								when @ClaimType like 'claim_open_52_78%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 52 and 
											DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 <= 78'
								when @ClaimType like 'claim_open_0_78%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 0 and 
											DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 <= 78'
								when @ClaimType like 'claim_open_78_130%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 78 and 
											DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 <= 130'
								when @ClaimType like 'claim_open_gt_130%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 130'
								when @ClaimType like 'claim_open_lt_05%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_Of_Notification], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 < 5'
								when @ClaimType like 'claim_open_lt_013%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_Of_Notification], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 < 13'
								when @ClaimType like 'claim_open_lt_26%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_Of_Notification], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 < 26'
								when @ClaimType like 'claim_open_lt_52%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_Of_Notification], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 < 52'
								when @ClaimType like 'claim_open_lt_78%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_Of_Notification], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 < 78'
								when @ClaimType like 'claim_open_lt_104%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_Of_Notification], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 < 104'
								when @ClaimType like 'claim_open_lt_130%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_Of_Notification], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 < 130'
								when @ClaimType like 'claim_open_ge_130%'
									then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_Of_Notification], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 >= 130'
								when @ClaimType like 'claim_open_ncmm_this_week%'
									then ' and [NCMM_Actions_This_Week] <> '''' and NCMM_Complete_Action_Due > ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
								when @ClaimType like 'claim_open_ncmm_next_week%'
									then ' and [NCMM_Actions_Next_Week] <> ''''
										and [NCMM_Prepare_Action_Due] BETWEEN ''' + CONVERT(VARCHAR, DATEADD(week, 1, @End_Date), 120) + ''' AND ''' + CONVERT(VARCHAR, DATEADD(week, 3, @End_Date), 120) + ''''
								when @ClaimType like 'claim_open_nlt%' then ' and  [Is_Time_Lost] = 0'
								when @ClaimType like 'claim_open_acupuncture%' then ' and Acupuncture_Paid > 0'
								when @ClaimType like 'claim_open_chiro%' then ' and [Chiro_Paid] > 1000'
								when @ClaimType like 'claim_open_massage%' then ' and [Massage_Paid] > 0'
								when @ClaimType like 'claim_open_ost%' then ' and [Osteopathy_Paid] > 0'										
								when @ClaimType like 'claim_open_physio%' then ' and [Physio_Paid] > 2000'
								when @ClaimType like 'claim_open_rehab%' then ' and [Rehab_Paid] > 0'
								when @ClaimType like 'claim_open_industrial_deafness%' then ' and Is_Industrial_Deafness = 1'																	
								when @ClaimType like 'claim_open_wpi_all%' then ' and [WPI] > 0 and [WPI] is not null'
								when @ClaimType like 'claim_open_wpi_0_10%' then ' and [WPI] > 0 and [WPI] <= 10 and [WPI] is not null'
								when @ClaimType like 'claim_open_wpi_11_14%' then ' and [WPI] >= 11 and [WPI]<= 14'
								when @ClaimType like 'claim_open_wpi_15_20%' then ' and [WPI] >= 15 and [WPI] <= 20'
								when @ClaimType like 'claim_open_wpi_21_30%' then ' and [WPI] >= 21 and [WPI] <= 30'
								when @ClaimType like 'claim_open_wpi_31_more%' then ' and [WPI] >= 31'
								when @ClaimType like 'claim_open_wid%' then ' and Common_Law = 1'
								when @ClaimType like 'claim_open_death_%' then
																			case when UPPER(@System) <> 'WOW'
																					then ' and Result_Of_Injury_Code = 1'
																				else ' and Result_Of_Injury_Code = 3'
																			end
								when @ClaimType like 'claim_open_ppd_%' then
																			case when UPPER(@System) <> 'WOW'
																					then ' and Result_Of_Injury_Code = 3'
																				else ' and Result_Of_Injury_Code = 1'
																			end
								when @ClaimType like 'claim_open_recovery_%' then ' and Total_Recoveries <> 0'
								else ''
							end
	END
	ELSE IF @ClaimType like 'claim_re_open%'
	BEGIN
		SET @SQL = @SQL + case when UPPER(@System) = 'WOW'
									then ' and Date_Status_Changed between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + '''
											and [ClaimStatus] = ''E'''
								else ' and Date_Claim_Reopened between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
							end
	END
	ELSE IF @ClaimType like 'claim_closure%'
	BEGIN
		SET @SQL = @SQL + case when UPPER(@System) = 'WOW'
									then ' and Date_Status_Changed between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + '''
											and Claim_Closed_Flag = ''Y'''
								else ' and Date_Claim_Closed between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + '''
										and Claim_Closed_Flag = ''Y'''
							end
	END
	ELSE IF @ClaimType like 'claim_still_open%'
	BEGIN
		SET @SQL = @SQL + case when UPPER(@System) = 'WOW'
									then ' and Date_Status_Changed between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + '''
											and Claim_Closed_Flag <> ''Y'''
								else ' and Date_Claim_Reopened between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + '''
										and Claim_Closed_Flag <> ''Y'''
							end
	END	
		
	IF @ClaimType like 'claim_closure%'
	BEGIN		
		/* For claim closure */
		
		IF @IsLastMonthRange = 1 OR @IsLast2WeeksRange = 1
		BEGIN
			SET @SQL = @SQL + '
				AND ISNULL(Is_Last_Month, 0) =' + CONVERT(VARCHAR, @Is_Last_Month) + '
				AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date, 120) + '''
				AND IsPreOpened = 1'
		END
		ELSE
		BEGIN
			/* Determine Previous Reporting date */
			SET @SQL_tmp = 'SELECT top 1 Reporting_Date, 1 FROM ' + @System + '_Portfolio
							WHERE CONVERT(datetime, Reporting_Date, 101)
								>= CONVERT(datetime, DATEADD(DAY, -1,''' + CONVERT(VARCHAR, @Start_Date, 120) + ''') + ''23:59'', 101)
							ORDER BY Reporting_Date'
			
			INSERT INTO #reporting_date
			EXEC(@SQL_tmp)						
			
			SELECT TOP 1 @Reporting_Date_pre = Reporting_Date FROM #reporting_date WHERE IsPre = 1
			
			CREATE TABLE #cpr_preopen
			(
				[Claim_No] [varchar](19) NULL
			)
			
			SET @SQL_tmp = 'SELECT [Claim_No] FROM [dbo].[uv_PORT]
							WHERE [System] = ''' + UPPER(@System) + '''
								AND ISNULL(Is_Last_Month, 0) = 0
								AND Reporting_Date = ''' + CONVERT(VARCHAR, ISNULL(@Reporting_Date_pre,''), 120) + '''
								AND Claim_Closed_Flag = ''N'''
								
			INSERT INTO #cpr_preopen
			EXEC(@SQL_tmp)
					
			SET @SQL = @SQL + '
				AND ISNULL(Is_Last_Month, 0) = ' + CONVERT(VARCHAR, @Is_Last_Month) + '
				AND Reporting_Date = ''' + CONVERT(VARCHAR, ISNULL(@Reporting_Date,''), 120) + ''''
				+ case when UPPER(@System) = 'WOW'
							then ' AND EXISTS (SELECT [Claim_No] FROM #cpr_preopen cpr_pre WHERE cpr_pre.Claim_No COLLATE Latin1_General_CI_AS = cpr.Claim_No)'
						else ' AND (EXISTS (SELECT [Claim_No] FROM #cpr_preopen cpr_pre WHERE cpr_pre.Claim_No COLLATE Latin1_General_CI_AS = cpr.Claim_No)
									OR ISNULL(Date_Claim_Entered, date_claim_received) >= ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''')'
					end
		END
	END
	ELSE IF @ClaimType like 'claim_still_open%'
	BEGIN
		/* For claim reopened - still open */
		
		IF @IsLastMonthRange = 1 OR @IsLast2WeeksRange = 1
		BEGIN
			SET @SQL = @SQL + '
				AND ISNULL(Is_Last_Month, 0) = ' + CONVERT(VARCHAR, @Is_Last_Month) + '
				AND Reporting_Date = ''' + CONVERT(VARCHAR, ISNULL(@Reporting_Date,''), 120) + '''
				AND IsPreClosed = 1'
		END
		ELSE
		BEGIN
			/* Determine Previous Reporting date */								
			SET @SQL_tmp = 'SELECT top 1 Reporting_Date, 1 FROM ' + @System + '_Portfolio
							WHERE CONVERT(datetime, Reporting_Date, 101)
								>= CONVERT(datetime, DATEADD(DAY, -1,''' + CONVERT(VARCHAR, @Start_Date, 120) + ''') + ''23:59'', 101)
							ORDER BY Reporting_Date'
			
			INSERT INTO #reporting_date
			EXEC(@SQL_tmp)
		
			SELECT TOP 1 @Reporting_Date_pre = Reporting_Date FROM #reporting_date WHERE IsPre = 1
			
			CREATE TABLE #cpr_preclose
			(
				[Claim_No] [varchar](19) NULL
			)
			
			SET @SQL_tmp = 'SELECT [Claim_No] FROM [dbo].[uv_PORT]
							WHERE [System] = ''' + UPPER(@System) + '''
								AND ISNULL(Is_Last_Month, 0) = 0
								AND Reporting_Date = ''' + CONVERT(VARCHAR, ISNULL(@Reporting_Date_pre,''), 120) + '''
								AND Claim_Closed_Flag = ''Y'''
								
			INSERT INTO #cpr_preclose
			EXEC(@SQL_tmp)
					
			SET @SQL = @SQL + '
				AND ISNULL(Is_Last_Month, 0) = ' + CONVERT(VARCHAR, @Is_Last_Month) + '
				AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date, 120) + '''
				AND EXISTS (SELECT [Claim_No] FROM #cpr_preclose cpr_pre WHERE cpr_pre.Claim_No COLLATE Latin1_General_CI_AS = cpr.Claim_No)'
		END
	END
	ELSE
	BEGIN
		/* For other claim types: return data by Reporting date only */
	
		SET @SQL = @SQL + ' AND ISNULL(Is_Last_Month, 0) = ''' + CONVERT(VARCHAR, @Is_Last_Month) + '''
			AND Reporting_Date = ''' + CONVERT(VARCHAR, isnull(@Reporting_Date,''), 120) + ''''
	END
	
	/* In case EML/HEM with broker type at total column of top level */
	IF UPPER(@System) IN ('EML', 'HEM') AND @Type = 'broker' AND @Value = 'all'
	BEGIN
		SET @SQL = @SQL + ' AND Broker_Name COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT Broker_Name FROM #brokers10)'
	END
		
	/* Get final results */
	EXEC(@SQL)
		
	/* Drop all temp tables */
	IF OBJECT_ID('tempdb..#cpr_preopen') IS NOT NULL DROP table #cpr_preopen
	IF OBJECT_ID('tempdb..#cpr_preclose') IS NOT NULL DROP table #cpr_preclose
	IF OBJECT_ID('tempdb..#brokers10') IS NOT NULL DROP TABLE #brokers10
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO