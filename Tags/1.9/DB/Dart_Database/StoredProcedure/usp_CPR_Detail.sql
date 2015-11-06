SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CPR_Detail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CPR_Detail]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Detail]
(
	@System VARCHAR(10)
	,@Type VARCHAR(20)
	,@Value NVARCHAR(256)
	,@SubValue NVARCHAR(256)
	,@SubSubValue NVARCHAR(256)
	,@Start_Date DATETIME
	,@End_Date DATETIME
	,@Claim_Liability_Indicator NVARCHAR(256)
	,@Psychological_Claims VARCHAR(10)
	,@Inactive_Claims VARCHAR(10)
	,@Medically_Discharged VARCHAR(10)
	,@Exempt_From_Reform VARCHAR(10)
	,@Reactivation VARCHAR(10)
	,@View_Type VARCHAR(20)
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
		SET @Period_Type = -1
	END
	
	/* Append time to @End_Date */
	SET @End_Date = DATEADD(dd, DATEDIFF(dd, 0, @End_Date), 0) + '23:59'
	
	/* Prepare data before querying */
	
	DECLARE @SQL varchar(MAX)
	
	CREATE TABLE #reporting_date
	(
		Reporting_Date datetime null,
		IsPre bit null
	)
	
	/* Determine filter conditions */
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
	
	/* Determine current Reporting date */
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
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[HoursPerWeek] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Rehab_Paid] [float] NULL,
		[IsPreClosed] [bit] NULL,
		[IsPreOpened] [bit] NULL,
		[ClaimStatus] varchar(1) NULL,
		[Date_Status_Changed] [datetime] NULL
	)
	
	DECLARE @WHERE_CONS VARCHAR(MAX) = 
		/* Append the filter condition based on @Value */
		case when @Value <> 'all'
				then 
					case when UPPER(@System) = 'TMF'
							then
								case when @Type = 'agency' 
										then
											case when @Value = 'health@@@other' 
													then ' and rtrim(isnull(sub.AgencyName,''Miscellaneous'')) in (''health'',''other'')'
												when @Value = 'police@@@emergency services'
													then ' and rtrim(isnull(sub.AgencyName,''Miscellaneous'')) in (''police'',''fire'',''rfs'')'
												when @Value like '%_total' 
													then ' '
												else ' and rtrim(isnull(sub.AgencyName,''Miscellaneous'')) = ''' + @Value + ''' '
											end														
									when @Type = 'group'
										then
											case when @Value like '%_total'
													then ' '
												else ' and dbo.udf_TMF_GetGroupByTeam(Team) = ''' + @Value +''''
											end
									else ''
								end
						when UPPER(@System) = 'EML'
							then
								case when @Type = 'employer_size' 
										then
											case when @Value like '%_total'
													then ' '
												else ' and [EMPL_SIZE] = ''' + @Value + ''''
											end
									when @Type = 'group'
										then
											case when @Value like '%_total' 
													then ' '
												else ' and dbo.udf_EML_GetGroupByTeam(Team) = ''' + @Value + ''''
											end
									when @Type = 'account_manager'
										then 
											case when @Value like '%_total'
													then ' '
												else ' and [Account_Manager] = ''' + @Value + ''''
											end
									when @Type = 'broker'
										then 
											case when @Value like '%_total'
													then ' '
												else ' and [Broker_Name] = ''' + @Value + ''''
											end
									else ''
								end
						when UPPER(@System) = 'HEM'
							then
								case when @Type = 'account_manager'
										then
											case when @Value like '%_total'
													then ' '
												else ' and [Account_Manager] = ''' + @Value + ''''
											end
									when @Type = 'portfolio' 
										then
											case when @Value = 'hotel'
													then ' and ([portfolio] = ''Accommodation'' or [portfolio] = ''Pubs, Taverns and Bars'')'
												when @Value like '%_total'
													then ' '
												else ' and [Portfolio] = ''' + @Value + ''''
											end
									when @Type = 'group' 
										then
											case when @Value like '%_total'
													then ' '
												else ' and dbo.udf_HEM_GetGroupByTeam(Team) = ''' + @Value + ''''
											end
									when @Type = 'broker'
										then
											case when @Value like '%_total'
													then ' '
												else ' and [Broker_Name] = ''' + @Value + ''''
											end
									else ''
								end
						when UPPER(@System) = 'WOW'
							then
								case when @Type = 'group'
										then
											case when @Value like '%_total' 
													then ' '
												else ' and [Group] = ''' + @Value + ''''
											end
									when @Type = 'division'
										then
											case when @Value like '%_total'
													then ''
												else ' and [Division] = ''' + @Value + ''''
											end
									when @Type = 'state'
										then
											case when @Value like '%_total'
													then ''
												else ' and [State] = ''' + @Value + ''''
											end
									else ''
								end
					end
		end +
		
		/* Append the filter condition based on @SubValue */
		case when @SubValue <> 'all' 
				then
					case when @SubValue like '%_total' 
							then
								case when UPPER(@System) = 'TMF'
									then
										case when @Type = 'agency'
												then ' and rtrim(isnull(sub.AgencyName,''Miscellaneous'')) = ''' + @Value + ''''
											when @Type = 'group' 
												then ' and dbo.udf_TMF_GetGroupByTeam(Team) = ''' + @Value + ''''
											else ''
										end
									when UPPER(@System) = 'EML'
										then
											case when @Type = 'group' 
													then ' and dbo.udf_EML_GetGroupByTeam(Team) = ''' + @Value + ''''
												when @Type = 'employer_size'
													then ' and [EMPL_SIZE] = ''' + @Value + ''''
												when @Type = 'account_manager'
													then ' and [Account_Manager] = ''' + @Value + ''''
												when @Type = 'broker'
													then ' and [Broker_Name] = ''' + @Value + ''''
												else ''
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type = 'account_manager'
													then ' and [Account_Manager] = ''' + @Value + ''''
												when @Type = 'portfolio' 
													then ' and [Portfolio] = ''' + @Value + ''''
												when @Type = 'group'
													then ' and dbo.udf_HEM_GetGroupByTeam(Team) = ''' + @Value + ''''
												when @Type = 'broker'
													then ' and [Broker_Name] = ''' + @Value + ''''
												else ''
											end
									
									/* WOW system */
									when UPPER(@System) = 'WOW'
										then
											case when @Type = 'group'
													then ' and [Group] = ''' + @Value + ''''
												when @Type = 'state'
													then ' and [State] = ''' + @Value + ''''
												when @Type = 'division'
													then ' and [Division] = ''' + @Value + ''''
												else ''
											end
								end
						else
							case when UPPER(@System) = 'TMF'
									then
										case when @Type = 'agency' 
												then ' and rtrim(isnull(sub.Sub_Category,''Miscellaneous'')) = ''' + @SubValue + ''''
											when @Type = 'group' 
												then ' and [Team] = ''' + @SubValue + ''''
											else ''
										end
								when UPPER(@System) = 'EML'
									then
										case when @Type = 'group'
												then ' and [Team] = ''' + @SubValue + ''''
											when @Type = 'employer_size' or @Type = 'account_manager'
												then ' and [EMPL_SIZE] = ''' + @SubValue + ''''
											else ''
										end
								when UPPER(@System) = 'HEM'
									then
										case when @Type = 'account_manager' or @Type = 'portfolio'
												then ' and [EMPL_SIZE] = ''' + @SubValue + ''''
											when @Type = 'group'
												then ' and [Team] = ''' + @SubValue + ''''
											else ''
										end
								
								/* WOW system */
								when UPPER(@System) = 'WOW'
									then
										case when @Type = 'group' 
												then ' and [Team] = ''' + @SubValue + ''''
											when @Type = 'state' 
												then ' and [Division] = ''' + @SubValue + ''''
											when @Type = 'division'
												then ' and [State] = ''' + @SubValue + ''''
											else ''
										end
							end
					end
			else ''
		end +
		
		/* Append the filter condition based on @SubSubValue */
		case when @SubSubValue <> 'all' 
				then
					case when @SubSubValue like '%_total' 
							then
								case when UPPER(@System) = 'TMF'
									then
										case when @Type = 'agency' 
												then ' and rtrim(isnull(sub.Sub_Category,''Miscellaneous'')) = ''' + @SubValue + ''''
											when @Type = 'group' 
												then ' and [Team] = ''' + @SubValue + ''''
											else ''
										end
									when UPPER(@System) = 'EML'
										then
											case when @Type = 'group' 
													then ' and [Team] = ''' + @SubValue + ''''
												when @Type = 'employer_size' or @Type = 'account_manager'
													then ' and [EMPL_SIZE] = ''' + @SubValue + ''''
												else ''
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type = 'account_manager' or @Type = 'portfolio' 
													then ' and [EMPL_SIZE] = ''' + @SubValue + '''' 
												when @Type = 'group' 
													then ' and [Team] = ''' + @SubValue + ''''
												else ''
											end
									
									/* WOW system */
									when UPPER(@System) = 'WOW'
										then
											case when @Type = 'group'
													then ' and [Team] = ''' + @SubValue + ''''
												when @Type = 'state'
													then ' and [Division] = ''' + @SubValue + ''''
												when @Type = 'division'
													then ' and [State] = ''' + @SubValue + ''''
												else ''
											end
								end
						else ' and [Claims_Officer_Name] = ''' + @SubSubValue + ''''
					end
			else ''
		end
	
	SET @SQL = 'SELECT Value = ' + case when UPPER(@System) = 'TMF'
										then
											case when @Type = 'agency'
													then + 'rtrim(isnull(sub.AgencyName,''Miscellaneous''))'
												when @Type = 'group'
													then 'dbo.udf_TMF_GetGroupByTeam(Team)'
												else ''''''
											end
									when UPPER(@System) = 'EML'
										then
											case when @Type = 'employer_size' 
													then '[EMPL_SIZE]' 
												when @Type = 'group'
													then 'dbo.udf_EML_GetGroupByTeam(Team)' 
												when @Type = 'account_manager'
													then '[Account_Manager]'
												when @Type = 'broker'
													then '[Broker_Name]'
												else ''''''
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type = 'account_manager' 
													then '[Account_Manager]' 
												when @Type = 'portfolio'
													then '[Portfolio]'
												when @Type = 'group'
													then 'dbo.udf_HEM_GetGroupByTeam(Team)'
												when @Type = 'broker'
													then '[Broker_Name]'
												else ''''''
											end
									
									/* WOW system */
									when UPPER(@System) = 'WOW'
										then
											case when @Type = 'group'
													then '[Group]'
												when @Type = 'state'
													then '[State]'
												when @Type = 'division'
													then '[Division]'
												else ''''''
											end
								end	+
				',SubValue = ' + case when UPPER(@System) = 'TMF'
										then
											case when @Type = 'agency'
													then 'rtrim(isnull(sub.Sub_Category,''Miscellaneous''))'
												when @Type = 'group'
													then '[Team]'
												else ''''''
											end
									when UPPER(@System) = 'EML'
										then
											case when @Type = 'group'
													then '[Team]'
												when @Type = 'employer_size' or @Type = 'account_manager'
													then '[EMPL_SIZE]'
												else ''''''
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type = 'account_manager' or @Type = 'portfolio' 
													then '[EMPL_SIZE]' 
												when @Type = 'group'
													then '[Team]'
												else ''''''
											end
									
									/* WOW system */
									when UPPER(@System) = 'WOW'
										then
											case when @Type = 'group'
													then '[Team]'
												when @Type = 'state'
													then '[Division]'
												when @Type = 'division'
													then '[State]'
												else ''''''
											end
								end	+
				',SubValue2 = [Claims_Officer_Name]
				,[Claim_No],[Date_Of_Injury],[Date_Of_Notification],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
				,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
				,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
				,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
				,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
				,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week],[NCMM_Complete_Action_Due],[NCMM_Prepare_Action_Due]
				,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[IsPreClosed],[IsPreOpened]' +
					case when UPPER(@System) = 'TMF'
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
				' WHERE ISNULL(Is_Last_Month, 0) = ' + CONVERT(VARCHAR, @Is_Last_Month) +	@WHERE_CONS	+
					' AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date, 120) + ''''
					
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
		
		/* Determine previous Reporting date */
		SELECT TOP 1 @Reporting_Date_pre = Reporting_Date FROM #reporting_date WHERE IsPre = 1
		
		SET @SQL = 'SELECT Claim_No, Claim_Closed_Flag, ClaimStatus = ' + case when UPPER(@System) = 'WOW' then 'ClaimStatus' else '''''' end
					+
					case when UPPER(@System) = 'TMF'
							then 
								case when @Type = 'agency'
										then ' FROM TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No'
									else ' FROM TMF_Portfolio'
								end
						when UPPER(@System) = 'EML'
							then ' FROM EML_Portfolio'
						when UPPER(@System) = 'HEM'
							then ' FROM HEM_Portfolio'
						when UPPER(@System) = 'WOW'
							then ' FROM WOW_Portfolio'
					end +
					' WHERE ISNULL(Is_Last_Month,0) = 0 ' +
						' AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date_pre, 120) + ''''
						
		INSERT INTO #pre_claim_list
		EXEC(@SQL)
	END		
	
	/* Drop temp table */
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
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[HoursPerWeek] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Rehab_Paid] [float] NULL,
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
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[HoursPerWeek] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Rehab_Paid] [float] NULL,
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
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[HoursPerWeek] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Rehab_Paid] [float] NULL,
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
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[HoursPerWeek] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Rehab_Paid] [float] NULL,
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
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[HoursPerWeek] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Rehab_Paid] [float] NULL,
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
							
	/* Drop temp table */
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
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[HoursPerWeek] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Rehab_Paid] [float] NULL,
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
	
	/* Create #brokers10 table to store Top 10 brokers by largest Open claims (ONLY FOR EML/HEM) */
	CREATE TABLE #brokers10
	(
		[Broker_Name] [varchar](256) NULL
	)
	
	IF UPPER(@System) IN ('EML', 'HEM') AND @Type = 'broker' AND @Value like '%_total'
	BEGIN
		/* Retrieve Top 10 brokers by largest Open claims */
		INSERT INTO #brokers10
		SELECT TOP 10 Value
			FROM #claim_open_all
			GROUP BY [Value]
			HAVING [Value] <> ''
			ORDER BY COUNT(DISTINCT Claim_No) DESC
			
		/* Clean data that not belong to Top 10 brokers by largest Open claims */
		DELETE FROM #claim_all WHERE Value NOT IN (SELECT [Broker_Name] FROM #brokers10) OR Value IS NULL
	END
			
	/* Drop temp tables */
	IF OBJECT_ID('tempdb..#claim_new_all') IS NOT NULL DROP TABLE #claim_new_all
	IF OBJECT_ID('tempdb..#claim_open_all') IS NOT NULL DROP TABLE #claim_open_all
	IF OBJECT_ID('tempdb..#claim_closure') IS NOT NULL DROP TABLE #claim_closure
	IF OBJECT_ID('tempdb..#claim_re_open') IS NOT NULL DROP TABLE #claim_re_open
	IF OBJECT_ID('tempdb..#claim_re_open_still_open') IS NOT NULL DROP TABLE #claim_re_open_still_open
	IF OBJECT_ID('tempdb..#brokers10') IS NOT NULL DROP TABLE #brokers10
		
	CREATE TABLE #total
	(
		Value nvarchar(150) NULL				
		,Claim_type nvarchar(150) NULL
		,iClaim_Type [float] NULL		
		,ffsd_at_work_15_less [float] NULL
		,ffsd_at_work_15_more [float] NULL
		,ffsd_not_at_work [float] NULL
		,pid [float] NULL
		,totally_unfit [float] NULL
		,therapy_treat [float] NULL
		,d_d [float] NULL
		,med_only [float] NULL
		,lum_sum_in [float] NULL
		,ncmm_this_week [float] NULL
		,ncmm_next_week [float] NULL
		,overall [float] NULL
	)				

	SET @SQL = 'SELECT tmp.Value, Claim_type, tmp.iClaim_Type
					,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type
						and  Med_Cert_Status = ''' + case when UPPER(@System) = 'WOW' then 'Partial' else 'SID' end + ''' and Is_Working = 1 and HoursPerWeek <= 15)
						
					,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type
						and  Med_Cert_Status = ''' + case when UPPER(@System) = 'WOW' then 'Partial' else 'SID' end + ''' and Is_Working = 1 and HoursPerWeek > 15)
						
					,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type
						and  Med_Cert_Status = ''' + case when UPPER(@System) = 'WOW' then 'Partial' else 'SID' end + ''' and Is_Working = 0)
						
					,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type
						and  Med_Cert_Status = ''' + case when UPPER(@System) = 'WOW' then 'Pre-injury duties' else 'PID' end + ''')
						
					,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type
						and  Med_Cert_Status = ''' + case when UPPER(@System) = 'WOW' then 'Totally unfit' else 'TU' end + ''')
						
					,therapy_treat=(select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type
						and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0)) 
					
					,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type
						and Is_D_D = 1) 
					
					,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type
						and Is_Medical_Only = 1) 
					
					,lum_sum_in = (select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type
						and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1)) 
					
					,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type
						and NCMM_Actions_This_Week <> '''' and NCMM_Complete_Action_Due > ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')
					
					,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type
						and NCMM_Actions_Next_Week <> ''''
						and NCMM_Prepare_Action_Due BETWEEN ''' + CONVERT(VARCHAR, DATEADD(week, 1, @End_Date), 120) + ''' AND ''' + CONVERT(VARCHAR, DATEADD(week, 3, @End_Date), 120) + ''')
					
					,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type COLLATE Latin1_General_CI_AS = tmp.Claim_Type)
					FROM
					(
						select * from dbo.uv_PORT_Get_All_Claim_Type
						cross join (select ''' +
										case when @SubSubValue <> 'all' 
												then @SubSubValue
											else 
												case when @SubValue <> 'all'
														then @SubValue
													else @Value
												end
										end + ''' as Value) as tmp_value
					) as tmp'
	
	INSERT INTO #total
	EXEC(@SQL)	

	/* Drop temp tables */
	IF OBJECT_ID('tempdb..#claim_all') IS NOT NULL DROP TABLE #claim_all
	IF OBJECT_ID('tempdb..#claim_list') IS NOT NULL DROP TABLE #claim_list
	
	/* Transform returning table structure and get results */
	SET @SQL = 'SELECT Value,
						Claim_Type,
						[Type] = tmp_port_type.PORT_Type,
						[Sum] = (select (case when tmp_port_type.PORT_Type = ''ffsd_at_work_15_less''
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
											when tmp_port_type.PORT_Type = ''overall''
												then tmp_total_2.overall
										end)
								from #total tmp_total_2
								where tmp_total_2.[Value] = tmp_total.[Value]
									and tmp_total_2.Claim_Type = tmp_total.Claim_Type)
				FROM #total tmp_total
				CROSS JOIN (SELECT * from dbo.uv_PORT_Get_All_PORT_Type) tmp_port_type
				ORDER BY Value, iClaim_Type, tmp_port_type.iPORT_Type'
				
	/* Get final results */
	EXEC(@SQL)
	
	/* Drop temp table */
	IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO