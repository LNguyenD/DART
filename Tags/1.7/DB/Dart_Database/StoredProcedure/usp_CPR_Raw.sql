SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- exec usp_System_CPR_Raw 'EML','group','Wcnsw1','all','all','claim_open_all_overall','2012-10-01','2012-10-31','all','all','all','all','all','all'

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
)
AS
BEGIN
	IF OBJECT_ID('tempdb..#cpr_preopen') IS NOT NULL DROP TABLE #cpr_preopen
	IF OBJECT_ID('tempdb..#cpr_preclose') IS NOT NULL DROP TABLE #cpr_preclose
		
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
	
	-- Prepare data before querying
	
	DECLARE @SQL varchar(MAX)
	DECLARE @SQL1 varchar(MAX)
	
	CREATE TABLE #reporting_date
	(
		Reporting_Date datetime null,
		IsPre bit null
	)
	
	-- Determine filter conditions
	DECLARE @Is_Last_Month bit
	DECLARE @Reporting_Date datetime
	
	IF @Period_Type = -1
	BEGIN
		SET @Is_Last_Month = 0
		SET @SQL1 = 'SELECT top 1 Reporting_Date, 0 FROM ' + @System + '_Portfolio
						WHERE CONVERT(datetime, Reporting_Date, 101)
							>= CONVERT(datetime, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''', 101) order by Reporting_Date'
				
		INSERT INTO #reporting_date
		EXEC(@SQL1)
	END
	ELSE
	BEGIN
		SET @Is_Last_Month = @Period_Type
		SET @SQL1 = 'SELECT MAX(Reporting_Date), 0 FROM ' + @System + '_Portfolio'
		
		INSERT INTO #reporting_date
		EXEC(@SQL1)
	END
	
	SELECT TOP 1 @Reporting_Date = Reporting_Date FROM #reporting_date WHERE IsPre = 0
	DECLARE @Reporting_Date_pre datetime
	
	SET @SQL = 'SELECT *
				FROM [dbo].[uv_PORT] cpr 
				WHERE [System] = ''' + @System + ''' ' +
				/* Append the filter condition based on @Value */
				(case when UPPER(@System) = 'EML'
						then case when @value <> 'all' and @Type = 'employer_size' then ' and [EMPL_SIZE] = ''' +  @value + ''''
									when @value <> 'all' and @Type = 'group' then ' and [Group] = ''' +  @value + ''''
									when @value <> 'all' and @Type = 'account_manager' then ' and [Account_Manager] = ''' +  @value + ''''
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
								 when @Value = 'hotel' then ' and [Portfolio] in (''Accommodation'',''Pubs, Taverns and Bars'') '
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
								then ' and [Med_Cert_Status] = ''TU'''
							when @ClaimType like '%ffsd_at_work_15_less'
								then ' and [Med_Cert_Status] = ''SID'' and Is_Working = 1 and HoursPerWeek <= 15'
							when @ClaimType like '%ffsd_at_work_15_more'
								then ' and [Med_Cert_Status] = ''SID'' And Is_Working = 1 and HoursPerWeek > 15'
							when @ClaimType like '%ffsd_not_at_work'
								then ' and [Med_Cert_Status] = ''SID'' And Is_Working = 0'
							when @ClaimType like '%pid'
								then ' and [Med_Cert_Status] = ''PID'''														
							when @ClaimType like '%therapy_treat'
								then ' and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Acupuncture_Paid > 0 or Osteopathy_Paid > 0 or Rehab_Paid > 0) '													
							when @ClaimType like '%ncmm_this_week'
								 then ' and [NCMM_Actions_This_Week] <> '''' and [NCMM_Complete_Action_Due] > ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
							when @ClaimType like '%ncmm_next_week'
								then ' and [NCMM_Actions_Next_Week] <> '''' and [NCMM_Prepare_Action_Due] <= ''' + CONVERT(VARCHAR, DATEADD(week, 3, @End_Date), 120) + ''''
							else '' 
						end)
	
	-- Apply the user input filters
	SET @SQL = @SQL + case when @Claim_Liability_Indicator <> 'all' then ' and [Claim_Liability_Indicator_Group] = ''' + @Claim_Liability_Indicator + '''' else '' end
	SET @SQL = @SQL + case when @Psychological_Claims <> 'all' then ' and [Is_Stress] = ''' + @Psychological_Claims + '''' else '' end
	SET @SQL = @SQL + case when @Inactive_Claims <> 'all' then ' and [Is_Inactive_Claims] = ''' + @Inactive_Claims + '''' else '' end
	SET @SQL = @SQL + case when @Medically_Discharged <> 'all' then ' and [Is_Medically_Discharged] = ''' + @Medically_Discharged + '''' else '' end
	SET @SQL = @SQL + case when @Exempt_From_Reform <> 'all' then ' and [Is_Exempt] = ''' + @Exempt_From_Reform + '''' else '' end
	SET @SQL = @SQL + case when @Reactivation <> 'all' then ' and [Is_Reactive] = ''' + @Reactivation + '''' else '' end
						  
	/* Append more filter condition based on @ClaimType */
											  
	IF @ClaimType like 'claim_new%'
	BEGIN
		SET @SQL = @SQL + ' and ISNULL(Date_Claim_Entered,Date_Claim_Received) between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
		
		SET @SQL = @SQL + case when @ClaimType like 'claim_new_nlt%' then ' and[Is_Time_Lost] = 0' 
								when @ClaimType like 'claim_new_lt%' then ' and [Is_Time_Lost] = 1' 
								else ''	 	
							end
	END
	ELSE IF @ClaimType like 'claim_open%'
	BEGIN
		SET @SQL = @SQL + ' AND (Date_Claim_Closed is null or Date_Claim_Closed < '''+ CONVERT(VARCHAR, @End_Date, 120) + ''')
							AND (Date_Claim_Reopened is null or Date_Claim_Reopened < '''+ CONVERT(VARCHAR, @End_Date, 120) + ''') and Claim_Closed_Flag <> ''Y'' '
							+ case when @ClaimType like 'claim_open_0_13%'
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
										then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 130 '
									when @ClaimType like 'claim_open_ncmm_this_week%'
										then ' and [NCMM_Actions_This_Week] <> '''' and NCMM_Complete_Action_Due > ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
									when @ClaimType like 'claim_open_ncmm_next_week%'
										then ' and [NCMM_Actions_Next_Week] <> '''' and [NCMM_Prepare_Action_Due] <= ''' + CONVERT(VARCHAR, DATEADD(week, 3, @End_Date), 120) + ''''
									when @ClaimType like 'claim_open_nlt%' then ' and  [Is_Time_Lost] = 0'
									when @ClaimType like 'claim_open_acupuncture%' then ' and Acupuncture_Paid > 0'
									when @ClaimType like 'claim_open_chiro%' then ' and [Chiro_Paid] > 1000'
									when @ClaimType like 'claim_open_massage%' then ' and [Massage_Paid] > 0'
									when @ClaimType like 'claim_open_ost%' then ' and [Osteopathy_Paid] > 0'										
									when @ClaimType like 'claim_open_physio%' then ' and [Physio_Paid] > 2000'
									when @ClaimType like 'claim_open_rehab%' then ' and [Rehab_Paid] > 0'
									when @ClaimType like 'claim_open_industrial_deafness%' then ' and Is_Industrial_Deafness = 1'																	
									when @ClaimType like 'claim_open_wpi_all%' then ' and [WPI] > 0 and [WPI] is not null'
									when @ClaimType like 'claim_open_wpi_0_10%' then ' and [WPI] > 0 and [WPI] <= 10 and  [WPI] is not null'
								    when @ClaimType like 'claim_open_wpi_11_14%' then ' and [WPI] >= 11 and [WPI]<= 14'
								    when @ClaimType like 'claim_open_wpi_15_20%' then ' and [WPI] >= 15 and [WPI] <= 20'
								    when @ClaimType like 'claim_open_wpi_21_30%' then ' and [WPI] >= 21 and [WPI] <= 30'
								    when @ClaimType like 'claim_open_wpi_31_more%' then ' and [WPI] >= 31'
									when @ClaimType like 'claim_open_wid%' then ' and Common_Law = 1'
									when @ClaimType like 'claim_open_death_%' then ' and Result_Of_Injury_Code = 1'
									when @ClaimType like 'claim_open_ppd_%' then ' and Result_Of_Injury_Code = 3'
									when @ClaimType like 'claim_open_recovery_%' then ' and Total_Recoveries <> 0'
									else ''
								end
	END
	ELSE IF @ClaimType like 'claim_re_open%'
	BEGIN
		SET @SQL = @SQL + ' and Date_Claim_Reopened between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
	END
	ELSE IF @ClaimType like 'claim_closure%'
	BEGIN
		SET @SQL = @SQL + ' and Date_Claim_Closed between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + '''
							and Claim_Closed_Flag = ''Y'' '
	END
	ELSE IF @ClaimType like 'claim_still_open%'
	BEGIN
		SET @SQL = @SQL + ' and Date_Claim_Reopened between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + '''
			and Claim_Closed_Flag <> ''Y'' '
	END	
		
	IF @ClaimType like 'claim_closure%'
	BEGIN		
		-- For claim closure
		
		IF @IsLastMonthRange = 1 OR @IsLast2WeeksRange = 1
		BEGIN
			SET @SQL = @SQL + '
				AND ISNULL(Is_Last_Month, 0) =' + CONVERT(VARCHAR, @Is_Last_Month) + '
				AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date, 120) + '''
				AND IsPreOpened = 1 '
		END
		ELSE
		BEGIN
			-- Determine Previous Reporting date								
			SET @SQL1 = 'SELECT top 1 Reporting_Date, 1 FROM ' + @System + '_Portfolio
				WHERE CONVERT(datetime, Reporting_Date, 101)
					>=CONVERT(datetime, DATEADD(DAY, -1,''' + CONVERT(VARCHAR, @Start_Date, 120) + ''') + ''23:59'', 101) order by Reporting_Date'
			
			INSERT INTO #reporting_date
			EXEC(@SQL1)						
			
			SELECT TOP 1 @Reporting_Date_pre = Reporting_Date FROM #reporting_date WHERE IsPre = 1						
			
			-- Create temp table for previous Reporting date
			SELECT [Claim_No]
				INTO #cpr_preopen
				FROM [dbo].[uv_PORT]
				WHERE [System] = @System
					AND ISNULL(Is_Last_Month, 0) = 0
					AND Reporting_Date = CONVERT(VARCHAR, isnull(@Reporting_Date_pre,''), 120)
					AND Claim_Closed_Flag = 'N'
					
			SET @SQL = @SQL + '
				 AND ISNULL(Is_Last_Month, 0) = ' + CONVERT(VARCHAR, @Is_Last_Month) + '
				 AND Reporting_Date = ''' + CONVERT(VARCHAR, isnull(@Reporting_Date,''), 120) + '''
				 AND (EXISTS (SELECT [Claim_No] FROM #cpr_preopen cpr_pre WHERE cpr_pre.Claim_No = cpr.Claim_No)
					OR ISNULL(Date_Claim_Entered, date_claim_received) >= ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''') '
		END
	END
	ELSE IF @ClaimType like 'claim_still_open%'
	BEGIN
		-- For claim reopened - still open
		
		IF @IsLastMonthRange = 1 OR @IsLast2WeeksRange = 1
		BEGIN
			SET @SQL = @SQL + '
				AND ISNULL(Is_Last_Month, 0) = ' + CONVERT(VARCHAR, @Is_Last_Month) + '
				AND Reporting_Date = ''' + CONVERT(VARCHAR, isnull(@Reporting_Date,''), 120) + '''
				AND IsPreClosed = 1 '
		END
		ELSE
		BEGIN
			-- Determine Previous Reporting date								
			SET @SQL1 = 'SELECT top 1 Reporting_Date, 1 FROM ' + @System + '_Portfolio
				WHERE CONVERT(datetime, Reporting_Date, 101)
					>= CONVERT(datetime, DATEADD(DAY, -1,''' + CONVERT(VARCHAR, @Start_Date, 120) + ''') + ''23:59'', 101) order by Reporting_Date'
			
			INSERT INTO #reporting_date
			EXEC(@SQL1)
		
			SELECT TOP 1 @Reporting_Date_pre = Reporting_Date FROM #reporting_date WHERE IsPre = 1
					
			-- Create temp table for previous Reporting date
			SELECT [Claim_No]
				INTO #cpr_preclose
				FROM [dbo].[uv_PORT]
				WHERE [System] = @System
					AND ISNULL(Is_Last_Month, 0) = 0
					AND Reporting_Date = CONVERT(VARCHAR, isnull(@Reporting_Date_pre,''), 120)
					AND Claim_Closed_Flag = 'Y'
				
			SET @SQL = @SQL + '
				AND ISNULL(Is_Last_Month, 0) = ' + CONVERT(VARCHAR, @Is_Last_Month) + '
				AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date, 120) + '''
				AND EXISTS (SELECT [Claim_No] FROM #cpr_preclose cpr_pre WHERE cpr_pre.Claim_No = cpr.Claim_No) '
		END
	END
	ELSE
	BEGIN
		-- For other claim types: return data by Reporting date only
	
		SET @SQL = @SQL + ' AND ISNULL(Is_Last_Month, 0) = ''' + CONVERT(VARCHAR, @Is_Last_Month) + '''
			AND Reporting_Date = ''' + CONVERT(VARCHAR, isnull(@Reporting_Date,''), 120) + ''''
	END	
		
	-- Get final results
	EXEC(@SQL)
		
	/* Drop all temp tables */
	IF OBJECT_ID('tempdb..#cpr_preopen') IS NOT NULL DROP table #cpr_preopen
	IF OBJECT_ID('tempdb..#cpr_preclose') IS NOT NULL DROP table #cpr_preclose	
	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO