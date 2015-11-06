SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CPR_Summary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CPR_Summary]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Summary]
(
	@System VARCHAR(10)
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
	,@View_Type varchar(20)
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
		[Date_Of_Notification] [datetime] NULL,
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
		[Physio_Paid] [float] NULL,
		[Chiro_Paid] [float] NULL,
		[Massage_Paid] [float] NULL,
		[Osteopathy_Paid] [float] NULL,
		[Acupuncture_Paid] [float] NULL,
		[Rehab_Paid] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Is_Stress] [bit] NULL,
		[Is_Inactive_Claims] [bit] NULL,
		[Is_Medically_Discharged] [bit] NULL,
		[Is_Exempt] [bit] NULL,
		[Is_Reactive] [bit] NULL,
		[NCMM_Actions_This_Week] [varchar](256) NULL,
		[NCMM_Actions_Next_Week] [varchar](256) NULL,
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[IsPreClosed] [bit] NULL,
		[IsPreOpened] [bit] NULL,
		[ClaimStatus] varchar(1) NULL,
		[Date_Status_Changed] [datetime] NULL
	)
	
	SET @SQL = 'SELECT Value=' + case when UPPER(@System) = 'TMF'
										then
											case when @Type='agency'
													then + 'rtrim(isnull(sub.AgencyName,''Miscellaneous''))'
												when @Type='group'
													then 'dbo.udf_TMF_GetGroupByTeam(Team)'
												else ''''''
											end
									when UPPER(@System) = 'EML'
										then
											case when @Type='employer_size' 
													then '[EMPL_SIZE]' 
												when @Type='group' 
													then 'dbo.udf_EML_GetGroupByTeam(Team)' 
												when @Type='account_manager'
													then '[account_manager]' 
												else ''''''
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type='account_manager' 
													then '[Account_Manager]' 
												when @Type = 'portfolio'
													then '[portfolio]' 
												when @Type='group'
													then 'dbo.udf_HEM_GetGroupByTeam(Team)'
												else ''''''
											end
									
									/* WOW system */
									when UPPER(@System) = 'WOW'
										then
											case when @Type = 'group'
													then '[Group]'
												 --for other views such as Division, State
												 when @Type = 'division'
													then '[Division]'
												 when @Type = 'state'
													then '[State]'
												 else ''''''
											end
								end	+
				',SubValue=' + case when UPPER(@System) = 'TMF'
										then
											case when @Type='agency'
													then 'rtrim(isnull(sub.Sub_Category,''Miscellaneous''))'
												when @Type='group'
													then '[Team]'
												else ''''''
											end
									when UPPER(@System) = 'EML'
										then
											case when @Type='group'
													then '[Team]'
												when @Type='employer_size' or @Type = 'account_manager'
													then '[EMPL_SIZE]'
												else ''''''
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type='account_manager' or @Type = 'portfolio' 
													then '[EMPL_SIZE]' 
												when @Type='group' 
													then '[Team]' 
												else ''''''
											end
									
									/* WOW system */
									when UPPER(@System) = 'WOW'
										then
											case when @Type = 'group'
													then '[Team]'
												 --for other views such as Division, State
												 when @Type = 'state'
													then '[Division]'
												 when @Type = 'division'
													then '[State]'
												 else ''''''												 
											end
								end	+
				',SubValue2=[Claims_Officer_Name]
				,[Claim_No],[Date_Of_Injury],[Date_Of_Notification],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
				,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
				,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
				,[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid],[Acupuncture_Paid],[Rehab_Paid]
				,[Is_Industrial_Deafness],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
				,[Is_Reactive],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week],[NCMM_Complete_Action_Due],[NCMM_Prepare_Action_Due]
				,[IsPreClosed],[IsPreOpened]'
					+ case when UPPER(@System) = 'TMF'
								then
									case when @Type = 'agency'
										then ',[ClaimStatus] = '''',[Date_Status_Changed] = null FROM TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No'
										else ',[ClaimStatus] = '''',[Date_Status_Changed] = null FROM TMF_Portfolio'
									end
							when UPPER(@System) = 'EML'
								then ',[ClaimStatus] = '''',[Date_Status_Changed] = null FROM EML_Portfolio'
							when UPPER(@System) = 'HEM'
								then ',[ClaimStatus] = '''',[Date_Status_Changed] = null FROM HEM_Portfolio'
							when UPPER(@System) = 'WOW'
								then ',[ClaimStatus],[Date_Status_Changed] FROM WOW_Portfolio'
						end +
				' WHERE ISNULL(Is_Last_Month, 0) = ' + CONVERT(VARCHAR, @Is_Last_Month) +
					' AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date, 120) + ''''
					
	-- Apply the user input filters
	SET @SQL = @SQL + case when @Claim_Liability_Indicator <> 'all' then ' and [Claim_Liability_Indicator_Group] = ''' + @Claim_Liability_Indicator + '''' else '' end
	SET @SQL = @SQL + case when @Psychological_Claims <> 'all' then ' and [Is_Stress] = ''' + @Psychological_Claims + '''' else '' end
	SET @SQL = @SQL + case when @Inactive_Claims <> 'all' then ' and [Is_Inactive_Claims] = ''' + @Inactive_Claims + '''' else '' end
	SET @SQL = @SQL + case when @Medically_Discharged <> 'all' then ' and [Is_Medically_Discharged] = ''' + @Medically_Discharged + '''' else '' end
	SET @SQL = @SQL + case when @Exempt_From_Reform <> 'all' then ' and [Is_Exempt] = ''' + @Exempt_From_Reform + '''' else '' end
	SET @SQL = @SQL + case when @Reactivation <> 'all' then ' and [Is_Reactive] = ''' + @Reactivation + '''' else '' end
		
	INSERT INTO #claim_list
	EXEC(@SQL)
	
	CREATE TABLE #pre_claim_list
	(
		[Claim_No] [varchar](19) NULL,
		[Claim_Closed_Flag] [nchar](1) NULL,
		[ClaimStatus] [varchar](1) NULL
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
		
		SET @SQL = 'SELECT Claim_No, Claim_Closed_Flag, ClaimStatus = ' + case when UPPER(@System) = 'WOW' then 'ClaimStatus' else '''''' end +
					' FROM ' + @System + '_Portfolio
					WHERE ISNULL(Is_Last_Month,0) = 0
						AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date_pre, 120) + ''''
						
		INSERT INTO #pre_claim_list
		EXEC(@SQL)
	END
	
	-- Drop temp table
	IF OBJECT_ID('tempdb..#reporting_date') IS NOT NULL DROP TABLE #reporting_date
	
	/* NEW CLAIMS */
	
	CREATE TABLE #claim_new_all
	(
		[Value] [varchar](256) NULL,
		[SubValue] [varchar](256) NULL,
		[SubValue2] [varchar](256) NULL,
		[Claim_No] [varchar](19) NULL,
		[Date_Of_Injury] [datetime] NULL,
		[Date_Of_Notification] [datetime] NULL,
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
		[Physio_Paid] [float] NULL,
		[Chiro_Paid] [float] NULL,
		[Massage_Paid] [float] NULL,
		[Osteopathy_Paid] [float] NULL,
		[Acupuncture_Paid] [float] NULL,
		[Rehab_Paid] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Is_Stress] [bit] NULL,
		[Is_Inactive_Claims] [bit] NULL,
		[Is_Medically_Discharged] [bit] NULL,
		[Is_Exempt] [bit] NULL,
		[Is_Reactive] [bit] NULL,
		[NCMM_Actions_This_Week] [varchar](256) NULL,
		[NCMM_Actions_Next_Week] [varchar](256) NULL,
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[IsPreClosed] [bit] NULL,
		[IsPreOpened] [bit] NULL,
		[ClaimStatus] varchar(1) NULL,
		[Date_Status_Changed] [datetime] NULL,
		[Age_of_claim] [float] NULL
	)
	
	SET @SQL = 'SELECT *, Age_of_claim = 0
					FROM #claim_list
					WHERE ISNULL(Date_Claim_Entered,Date_Claim_Received)
						between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
						
	INSERT INTO	#claim_new_all
	EXEC(@SQL)
	
	/* OPEN CLAIMS */
	
	CREATE TABLE #claim_open_all
	(
		[Value] [varchar](256) NULL,
		[SubValue] [varchar](256) NULL,
		[SubValue2] [varchar](256) NULL,
		[Claim_No] [varchar](19) NULL,
		[Date_Of_Injury] [datetime] NULL,
		[Date_Of_Notification] [datetime] NULL,
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
		[Physio_Paid] [float] NULL,
		[Chiro_Paid] [float] NULL,
		[Massage_Paid] [float] NULL,
		[Osteopathy_Paid] [float] NULL,
		[Acupuncture_Paid] [float] NULL,
		[Rehab_Paid] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Is_Stress] [bit] NULL,
		[Is_Inactive_Claims] [bit] NULL,
		[Is_Medically_Discharged] [bit] NULL,
		[Is_Exempt] [bit] NULL,
		[Is_Reactive] [bit] NULL,
		[NCMM_Actions_This_Week] [varchar](256) NULL,
		[NCMM_Actions_Next_Week] [varchar](256) NULL,
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[IsPreClosed] [bit] NULL,
		[IsPreOpened] [bit] NULL,
		[ClaimStatus] varchar(1) NULL,
		[Date_Status_Changed] [datetime] NULL,
		[Age_of_claim] [float] NULL
	)
	
	SET @SQL = 'SELECT *, Age_of_claim = DATEDIFF(DAY, ' + case when UPPER(@System) = 'WOW'
																	then 'Date_Of_Notification'
																else 'Date_of_Injury'
															end + ', DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0
					FROM #claim_list
					WHERE Claim_Closed_Flag <> ''Y'''
					+ 
					case when UPPER(@System) = 'WOW'
							then ' and Date_Status_Changed <= ''' + CONVERT(VARCHAR, @End_Date, 120) + ''' and [ClaimStatus] <> ''N'''
						else ' and (Date_Claim_Closed is null or Date_Claim_Closed < ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')
								and (Date_Claim_Reopened is null or Date_Claim_Reopened < ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')'
					end
	
	INSERT INTO	#claim_open_all
	EXEC(@SQL)
	
	/* CLAIM CLOSURES */
	
	CREATE TABLE #claim_closure
	(
		[Value] [varchar](256) NULL,
		[SubValue] [varchar](256) NULL,
		[SubValue2] [varchar](256) NULL,
		[Claim_No] [varchar](19) NULL,
		[Date_Of_Injury] [datetime] NULL,
		[Date_Of_Notification] [datetime] NULL,
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
		[Physio_Paid] [float] NULL,
		[Chiro_Paid] [float] NULL,
		[Massage_Paid] [float] NULL,
		[Osteopathy_Paid] [float] NULL,
		[Acupuncture_Paid] [float] NULL,
		[Rehab_Paid] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Is_Stress] [bit] NULL,
		[Is_Inactive_Claims] [bit] NULL,
		[Is_Medically_Discharged] [bit] NULL,
		[Is_Exempt] [bit] NULL,
		[Is_Reactive] [bit] NULL,
		[NCMM_Actions_This_Week] [varchar](256) NULL,
		[NCMM_Actions_Next_Week] [varchar](256) NULL,
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[IsPreClosed] [bit] NULL,
		[IsPreOpened] [bit] NULL,
		[ClaimStatus] varchar(1) NULL,
		[Date_Status_Changed] [datetime] NULL,
		[Age_of_claim] [float] NULL
	)
	
	SET @SQL = 'SELECT *, Age_of_claim = 0
					FROM #claim_list cpr
					WHERE Claim_Closed_Flag = ''Y'''
					+ 
					case when UPPER(@System) = 'WOW'
							then ' and Date_Status_Changed between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
									+
									case when @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1
											then ' and IsPreOpened = 1'
										else ' and exists (SELECT [Claim_No] FROM #pre_claim_list cpr_pre
														WHERE cpr_pre.Claim_No = cpr.Claim_No AND cpr_pre.Claim_Closed_Flag = ''N'')'
									end
						else ' and Date_Claim_Closed between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
								+
								case when @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1
										then ' and IsPreOpened = 1'
									else ' and (exists (SELECT [Claim_No] FROM #pre_claim_list cpr_pre
													WHERE cpr_pre.Claim_No = cpr.Claim_No AND cpr_pre.Claim_Closed_Flag = ''N'')
												or ISNULL(cpr.Date_Claim_Entered, cpr.date_claim_received) >= ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''')'
								end
					end
	
	INSERT INTO	#claim_closure
	EXEC(@SQL)
	
	/* REOPEN CLAIMS */
	
	CREATE TABLE #claim_re_open
	(
		[Value] [varchar](256) NULL,
		[SubValue] [varchar](256) NULL,
		[SubValue2] [varchar](256) NULL,
		[Claim_No] [varchar](19) NULL,
		[Date_Of_Injury] [datetime] NULL,
		[Date_Of_Notification] [datetime] NULL,
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
		[Physio_Paid] [float] NULL,
		[Chiro_Paid] [float] NULL,
		[Massage_Paid] [float] NULL,
		[Osteopathy_Paid] [float] NULL,
		[Acupuncture_Paid] [float] NULL,
		[Rehab_Paid] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Is_Stress] [bit] NULL,
		[Is_Inactive_Claims] [bit] NULL,
		[Is_Medically_Discharged] [bit] NULL,
		[Is_Exempt] [bit] NULL,
		[Is_Reactive] [bit] NULL,
		[NCMM_Actions_This_Week] [varchar](256) NULL,
		[NCMM_Actions_Next_Week] [varchar](256) NULL,
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[IsPreClosed] [bit] NULL,
		[IsPreOpened] [bit] NULL,
		[ClaimStatus] varchar(1) NULL,
		[Date_Status_Changed] [datetime] NULL,
		[Age_of_claim] [float] NULL
	)
	
	SET @SQL = 'SELECT *, Age_of_claim = 0
					FROM #claim_list
					WHERE'
					+
					case when UPPER(@System) = 'WOW'
							then ' Date_Status_Changed between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + '''
									and [ClaimStatus] = ''E'''
						else ' Date_Claim_Reopened between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
					end
	
	INSERT INTO	#claim_re_open
	EXEC(@SQL)
	
	/* REOPEN CLAIMS: STILL OPEN */
	
	CREATE TABLE #claim_re_open_still_open
	(
		[Value] [varchar](256) NULL,
		[SubValue] [varchar](256) NULL,
		[SubValue2] [varchar](256) NULL,
		[Claim_No] [varchar](19) NULL,
		[Date_Of_Injury] [datetime] NULL,
		[Date_Of_Notification] [datetime] NULL,
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
		[Physio_Paid] [float] NULL,
		[Chiro_Paid] [float] NULL,
		[Massage_Paid] [float] NULL,
		[Osteopathy_Paid] [float] NULL,
		[Acupuncture_Paid] [float] NULL,
		[Rehab_Paid] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Is_Stress] [bit] NULL,
		[Is_Inactive_Claims] [bit] NULL,
		[Is_Medically_Discharged] [bit] NULL,
		[Is_Exempt] [bit] NULL,
		[Is_Reactive] [bit] NULL,
		[NCMM_Actions_This_Week] [varchar](256) NULL,
		[NCMM_Actions_Next_Week] [varchar](256) NULL,
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[IsPreClosed] [bit] NULL,
		[IsPreOpened] [bit] NULL,
		[ClaimStatus] varchar(1) NULL,
		[Date_Status_Changed] [datetime] NULL,
		[Age_of_claim] [float] NULL
	)
	
	SET @SQL = 'SELECT *, Age_of_claim = 0
					FROM #claim_list cpr
					WHERE Claim_Closed_Flag <> ''Y'''
					+ 
					case when UPPER(@System) = 'WOW'
							then ' and Date_Status_Changed between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
						else ' and Date_Claim_Reopened between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
					end
					+
					case when @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1
							then ' and IsPreClosed = 1'
						else ' and exists (SELECT [Claim_No] FROM #pre_claim_list cpr_pre
												WHERE cpr_pre.Claim_No = cpr.Claim_No AND cpr_pre.Claim_Closed_Flag = ''Y'')'
					end
	
	INSERT INTO	#claim_re_open_still_open
	EXEC(@SQL)
									
	-- Drop temp table
	IF OBJECT_ID('tempdb..#pre_claim_list') IS NOT NULL DROP TABLE #pre_claim_list
	
	/* CLAIM ALL */
	
	CREATE TABLE #claim_all
	(
		[Value] [varchar](256) NULL,
		[SubValue] [varchar](256) NULL,
		[SubValue2] [varchar](256) NULL,
		[Claim_No] [varchar](19) NULL,
		[Date_Of_Injury] [datetime] NULL,
		[Date_Of_Notification] [datetime] NULL,
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
		[Physio_Paid] [float] NULL,
		[Chiro_Paid] [float] NULL,
		[Massage_Paid] [float] NULL,
		[Osteopathy_Paid] [float] NULL,
		[Acupuncture_Paid] [float] NULL,
		[Rehab_Paid] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Is_Stress] [bit] NULL,
		[Is_Inactive_Claims] [bit] NULL,
		[Is_Medically_Discharged] [bit] NULL,
		[Is_Exempt] [bit] NULL,
		[Is_Reactive] [bit] NULL,
		[NCMM_Actions_This_Week] [varchar](256) NULL,
		[NCMM_Actions_Next_Week] [varchar](256) NULL,
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[IsPreClosed] [bit] NULL,
		[IsPreOpened] [bit] NULL,
		[ClaimStatus] varchar(1) NULL,
		[Date_Status_Changed] [datetime] NULL,
		[Age_of_claim] [float] NULL,
		[claim_type] [varchar](30) NULL
	)
	
	SET @SQL = 'SELECT *
				FROM (select *,claim_type=''claim_new_all'' from #claim_new_all
							union all select *,claim_type=''claim_new_lt'' from #claim_new_all where is_Time_Lost = 1
							union all select *,claim_type=''claim_new_nlt'' from #claim_new_all where is_Time_Lost = 0
							union all select *,claim_type=''claim_open_all'' from #claim_open_all'
							+
							case when UPPER(@System) <> 'WOW'
									then
										' union all select *,claim_type=''claim_open_0_13'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim > 0 and Age_of_claim <= 13
										union all select *,claim_type=''claim_open_13_26'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim > 13 and Age_of_claim <= 26
										union all select *,claim_type=''claim_open_26_52'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim > 26 and Age_of_claim <= 52
										union all select *,claim_type=''claim_open_52_78'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim > 52 and Age_of_claim <= 78
										union all select *,claim_type=''claim_open_0_78'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim > 0 and Age_of_claim <= 78
										union all select *,claim_type=''claim_open_78_130'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim > 78 and Age_of_claim <= 130
										union all select *,claim_type=''claim_open_gt_130'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim > 130'
								else
									' union all select *,claim_type=''claim_open_lt_05'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim < 5
									union all select *,claim_type=''claim_open_lt_013'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim < 13
									union all select *,claim_type=''claim_open_lt_26'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim < 26
									union all select *,claim_type=''claim_open_lt_52'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim < 52
									union all select *,claim_type=''claim_open_lt_78'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim < 78
									union all select *,claim_type=''claim_open_lt_104'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim < 104
									union all select *,claim_type=''claim_open_lt_130'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim < 130
									union all select *,claim_type=''claim_open_ge_130'' from #claim_open_all where Is_Time_Lost = 1 and Age_of_claim >= 130'
							end
							+
							' union all select *,claim_type=''claim_open_nlt'' from #claim_open_all where is_Time_Lost = 0'
							+
							case when UPPER(@System) <> 'WOW'
									then
										' union all select *,claim_type=''claim_open_ncmm_this_week'' from #claim_open_all where NCMM_Actions_This_Week <> '''' AND NCMM_Complete_Action_Due > ''' + CONVERT(VARCHAR, @End_Date, 120) + '''
										union all select *,claim_type=''claim_open_ncmm_next_week'' from #claim_open_all where NCMM_Actions_Next_Week <> ''''
											AND NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''') AND DATEADD(week, 3, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')'
								else ''
							end
							+
							' union all select *,claim_type=''claim_open_acupuncture'' from #claim_open_all where Acupuncture_Paid > 0
							union all select *,claim_type=''claim_open_chiro'' from #claim_open_all where Chiro_Paid > 1000
							union all select *,claim_type=''claim_open_massage'' from #claim_open_all where Massage_Paid > 0
							union all select *,claim_type=''claim_open_osteo'' from #claim_open_all where Osteopathy_Paid > 0
							union all select *,claim_type=''claim_open_physio'' from #claim_open_all where Physio_Paid > 2000
							union all select *,claim_type=''claim_open_rehab'' from #claim_open_all where Rehab_Paid > 0
							union all select *,claim_type=''claim_open_death'' from #claim_open_all where Result_Of_Injury_Code = ' + case when UPPER(@System) = 'WOW' then '3' else '1' end + '
							union all select *,claim_type=''claim_open_industrial_deafness'' from #claim_open_all where Is_Industrial_Deafness = 1
							union all select *,claim_type=''claim_open_ppd'' from #claim_open_all where Result_Of_Injury_Code = ' + case when UPPER(@System) = 'WOW' then '1' else '3' end + '
							union all select *,claim_type=''claim_open_recovery'' from #claim_open_all where Total_Recoveries <> 0
							union all select *,claim_type=''claim_open_wpi_all'' from #claim_open_all where WPI > 0
							union all select *,claim_type=''claim_open_wpi_0_10'' from #claim_open_all where WPI > 0 AND WPI <= 10
							union all select *,claim_type=''claim_open_wpi_11_14'' from #claim_open_all where WPI >= 11 AND WPI <= 14
							union all select *,claim_type=''claim_open_wpi_15_20'' from #claim_open_all where WPI >= 15 AND WPI <= 20
							union all select *,claim_type=''claim_open_wpi_21_30'' from #claim_open_all where WPI >= 21 AND WPI <= 30
							union all select *,claim_type=''claim_open_wpi_31_more'' from #claim_open_all where WPI >= 31
							union all select *,claim_type=''claim_open_wid'' from #claim_open_all where Common_Law = 1
							union all select *,claim_type=''claim_closure'' from #claim_closure
							union all select *,claim_type=''claim_re_open'' from #claim_re_open
							union all select *,claim_type=''claim_still_open'' from #claim_re_open_still_open
						   ) as tmp'
			   
	INSERT INTO	#claim_all
	EXEC(@SQL)
			
	-- Drop temp tables
	IF OBJECT_ID('tempdb..#claim_new_all') IS NOT NULL DROP TABLE #claim_new_all
	IF OBJECT_ID('tempdb..#claim_open_all') IS NOT NULL DROP TABLE #claim_open_all
	IF OBJECT_ID('tempdb..#claim_closure') IS NOT NULL DROP TABLE #claim_closure
	IF OBJECT_ID('tempdb..#claim_re_open') IS NOT NULL DROP TABLE #claim_re_open
	IF OBJECT_ID('tempdb..#claim_re_open_still_open') IS NOT NULL DROP TABLE #claim_re_open_still_open
	
	CREATE TABLE #total
	(
		[Value] [varchar](256) NULL,
		[Claim_type] [varchar](30) NULL,
		[iClaim_Type] [int] NULL,
		[overall] [int] NULL
	)
	
	SET @SQL = 'SELECT  tmp.Value,Claim_type, tmp.iClaim_Type
					,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type' +
					case when @Value = 'all'
							then ' and [Value]=tmp.Value)'
						else (case when @SubValue = 'all'
									then ' and [Value]=''' + @Value + ''' and [SubValue]=tmp.Value)'
								else ' and [Value]=''' + @Value + ''' and [SubValue]=''' + @SubValue + ''' and [SubValue2]=tmp.Value)'
							end)
					end + '
				FROM
				(
					select * from dbo.uv_PORT_Get_All_Claim_Type
					cross join (select distinct' +
									case when @Value = 'all' 
											then ' Value'
										else (case when @SubValue = 'all'
													then ' SubValue as Value'
												else ' SubValue2 as Value'
											end)
									end + '
									from #claim_list
									where' +
									case when @Value = 'all' 
											then ' Value <> '''''
										else (case when @SubValue = 'all'
													then ' Value=''' + @Value + ''' and SubValue <> '''''
												else ' Value=''' + @Value + ''' and SubValue=''' + @SubValue + ''' and SubValue2 <> '''''
											end)
									end + '
									group by' + case when @Value = 'all' 
														then ' Value'
													else (case when @SubValue = 'all'
																then ' SubValue'
															else ' SubValue2'
														end)
												end + '
									having COUNT(*) > 0
									union
									select ''Miscellaneous'') as tmp_value
				) as tmp'
	
	INSERT INTO #total
	EXEC(@SQL)
	
	/* Clean data with zero value for all claim types */
	DELETE FROM #total WHERE Value not in (SELECT Value FROM #total
												GROUP BY Value
												HAVING SUM(overall) > 0)
	
	-- Drop temp tables
	IF OBJECT_ID('tempdb..#claim_all') IS NOT NULL DROP TABLE #claim_all
	IF OBJECT_ID('tempdb..#claim_list') IS NOT NULL DROP TABLE #claim_list
	
	IF @Value = 'all'
	BEGIN
		-- Append Total & Grouping values
	
		IF UPPER(@System) = 'TMF'
		BEGIN
			-- TMF
			INSERT INTO #total
			SELECT Value = 'TMF_total', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			GROUP BY Claim_Type, iClaim_Type
			
			-- Grouping Value: Health & Other	
			INSERT INTO #total
			SELECT Value = 'HEALTH & OTHER', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			WHERE Value = 'Health' or Value = 'Other'
			GROUP BY Claim_Type, iClaim_Type
			
			-- Grouping Value: Police & Emergency Services
			INSERT INTO #total
			SELECT Value = 'POLICE & EMERGENCY SERVICES', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			WHERE Value = 'Police' or Value = 'Fire' or Value = 'RFS'
			GROUP BY Claim_Type, iClaim_Type
		END
		ELSE IF UPPER(@System) = 'EML'
		BEGIN
			-- WCNSW	
			INSERT INTO #total
			SELECT Value = 'WCNSW_total', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			GROUP BY Claim_Type, iClaim_Type
		END
		ELSE IF UPPER(@System) = 'HEM'
		BEGIN
			-- Hospitality	
			INSERT INTO #total
			SELECT Value = 'Hospitality_total', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			GROUP BY Claim_Type, iClaim_Type
			
			-- Grouping Value: Hotel	
			INSERT INTO #total
			SELECT Value = 'Hotel', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			WHERE Value = 'Accommodation' or Value = 'Pubs, Taverns and Bars'
			GROUP BY Claim_Type, iClaim_Type
		END
		ELSE IF UPPER(@System) = 'WOW'
		BEGIN
			-- WOW
			INSERT INTO #total
			SELECT Value = 'WOW_total', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			GROUP BY Claim_Type, iClaim_Type
		END
	END
	ELSE
	BEGIN
		IF @SubValue = 'all'
		BEGIN
			-- Total
			INSERT INTO #total
			SELECT Value = @Value + '_total', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			GROUP BY Claim_Type, iClaim_Type
		END
		ELSE
		BEGIN
			-- Total
			INSERT INTO #total
			SELECT Value = @SubValue + '_total', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			GROUP BY Claim_Type, iClaim_Type
		END
	END
	
	-- Transform returning table structure and get results
	IF (UPPER(@System) = 'WOW' OR UPPER(@System) = 'HEM' OR UPPER(@System) = 'TMF')
	BEGIN
		SET @SQL = 'SELECT Value,
						Claim_Type,
						[Sum] = (select tmp_total_2.overall
									from #total tmp_total_2
									where tmp_total_2.[Value] = tmp_total.[Value]
										and tmp_total_2.Claim_Type = tmp_total.Claim_Type)
					FROM #total tmp_total
					ORDER BY
					CASE 
					-- BEGIN WOW
						 WHEN Value = ''NSW'' THEN 1
						 WHEN Value = ''VIC'' THEN 2
						 WHEN Value = ''TAS'' THEN 3
						 WHEN Value = ''SA'' THEN 4
						 WHEN Value = ''NT'' THEN 5
						 WHEN Value = ''QLD'' THEN 6
						 WHEN Value = ''WA'' THEN 7
						 WHEN Value = ''Group - NSW'' THEN 8
						 WHEN Value = ''Group - VIC'' THEN 9
						 WHEN Value = ''Group - TAS'' THEN 10
						 WHEN Value = ''Group - SA'' THEN 11
						 WHEN Value = ''Group - NT'' THEN 12
						 WHEN Value = ''Group - QLD'' THEN 13
						 WHEN Value = ''Group - WA'' THEN 14
						 WHEN Value = ''Supermarkets'' THEN 15
						 WHEN Value = ''Logistics'' THEN 16
						 WHEN Value = ''BIG W'' THEN 17
						 WHEN Value = ''Dick Smith'' THEN 18
						 WHEN Value = ''Petrol'' THEN 19
						 WHEN Value = ''BWS'' THEN 20
						 WHEN Value = ''Dan M'' THEN 21
						 WHEN Value = ''Corporate'' THEN 22
					-- END WOW
					-- BEGIN HEM
						 WHEN Value = ''Clubs (Hospitality)'' THEN 31
						 WHEN Value = ''Accommodation'' THEN 32
						 WHEN Value = ''Pubs, Taverns and Bars'' THEN 33
						 WHEN Value = ''Hotel'' THEN 34
						 WHEN Value = ''HEALTH'' THEN 50				-- TMF
						 WHEN Value = ''Other'' THEN 51					-- TMF and HEM 
					-- END HEM
					-- BEGIN TMF
						 WHEN Value = ''HEALTH & OTHER'' THEN 52
						 WHEN Value = ''POLICE'' THEN 53
						 WHEN Value = ''FIRE'' THEN 54
						 WHEN Value = ''RFS'' THEN 55
						 WHEN Value like ''%POLICE & EMERGENCY SERVICES'' THEN 56
					-- END TMF
						 WHEN Value = ''Miscellaneous'' THEN 998
						 WHEN Value like ''%total'' THEN 999
					END, Value, iClaim_Type'
	END
	ELSE
	BEGIN
		SET @SQL = 'SELECT Value,
							Claim_Type,
							[Sum] = (select tmp_total_2.overall
										from #total tmp_total_2
										where tmp_total_2.[Value] = tmp_total.[Value]
											and tmp_total_2.Claim_Type = tmp_total.Claim_Type)
					FROM #total tmp_total
					ORDER BY
					CASE 
						 WHEN Value = ''Miscellaneous'' THEN 998
						 WHEN Value like ''%total'' THEN 999
					END, Value, iClaim_Type'
	END
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