/****** Object:  StoredProcedure [dbo].[usp_Dashboard_RTW_GenerateData]    Script Date: 06/19/2015 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Dustin (DART)
-- CREATE date: 06/19/2015 14:31:45
-- Description:	SQL store procedure to generate data for RTW Dashboard
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_RTW_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_RTW_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_RTW_GenerateData]
	@system varchar(20),
	@prd_year_start int = 2012,
	@prd_month_start int = 9,
	@as_at datetime = null
AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF
	
	/*** Begin: Cleaning up ***/
	
	IF OBJECT_ID('tempdb..#data_clm') IS NOT NULL DROP TABLE #data_clm
	IF OBJECT_ID('tempdb..#data_policy') IS NOT NULL DROP table #data_policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL DROP table #activity_detail_audit
	IF OBJECT_ID('tempdb..#notadj') IS NOT NULL DROP table #notadj
	IF OBJECT_ID('tempdb..#adj') IS NOT NULL DROP table #adj
	IF OBJECT_ID('tempdb..#adj2') IS NOT NULL DROP table #adj2
	IF OBJECT_ID('tempdb..#adj3') IS NOT NULL DROP table #adj3
	IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP TABLE #summary
	IF OBJECT_ID('tempdb..#to_adjust') IS NOT NULL DROP TABLE #to_adjust
	IF OBJECT_ID('tempdb..#the_rest') IS NOT NULL DROP TABLE #the_rest
	IF OBJECT_ID('tempdb..#adjust_list') IS NOT NULL DROP TABLE #adjust_list
	IF OBJECT_ID('tempdb..#correct_records_excl_det') IS NOT NULL DROP TABLE #correct_records_excl_det
	IF OBJECT_ID('tempdb..#correct_records') IS NOT NULL DROP TABLE #correct_records
	IF OBJECT_ID('tempdb..#rtw_raw') IS NOT NULL DROP TABLE #rtw_raw
	IF OBJECT_ID('tempdb..#rtw_clean') IS NOT NULL DROP TABLE #rtw_clean
	IF OBJECT_ID('tempdb..#rolling_months') IS NOT NULL DROP TABLE #rolling_months
	IF OBJECT_ID('tempdb..#measure_types') IS NOT NULL DROP TABLE #measure_types
	IF OBJECT_ID('tempdb..#check') IS NOT NULL DROP TABLE #check
										
	/*** End: Cleaning up ***/
	
	/*** Begin: Commmon variables ***/
	
	DECLARE @SQL varchar(MAX)
	DECLARE @current_date datetime = GETDATE()

	/* get As_At date*/
	IF @as_at is null
		/* default: end of last month */
		SET @as_at = DATEADD(m, DATEDIFF(m, 0, @current_date), -1) + '23:59'
	ELSE		
		SET @as_at = DATEADD(dd, DATEDIFF(dd, 0, @as_at), 0) + '23:59'
		
	DECLARE @measure_month_13 int = 3	-- 13weeks = 3
	DECLARE @measure_month_26 int = 6	-- 26weeks = 6
	DECLARE @measure_month_52 int = 12  -- 52weeks = 12
	DECLARE @measure_month_78 int = 18  -- 78weeks = 18
	DECLARE @measure_month_104 int = 24 -- 104weeks = 24
		
	/* filter for payments made within the past 5 years only; */
	DECLARE @paystartdt datetime = '2008-12-31'
	DECLARE @lag int = 3
	
	DECLARE @as_at8dig int = CONVERT(int, CONVERT(varchar(8), @as_at, 112))
	
	DECLARE @overall_prd_start datetime = CAST(CAST(@prd_year_start as varchar) 
											+ '/' + CAST(@prd_month_start as varchar) 
											+ '/01' as datetime)
	
	DECLARE @overall_prd_end datetime = @current_date
	DECLARE @loops int = DATEDIFF(m, @overall_prd_start, @overall_prd_end)
	DECLARE @i int = @loops
	DECLARE @yy int
	DECLARE @mm int
	DECLARE @prd_start_temp datetime
	
	/* create #rolling_months table to store rolling months */
	DECLARE @R int
	CREATE TABLE #rolling_months
	(
		R int null
	)
	
	/* create #measure_types table to store measure types */
	DECLARE @M_months int
	DECLARE @M_weeks int
	CREATE TABLE #measure_types
	(
		M_months int null,
		M_weeks int null
	)
	
	CREATE TABLE #check
	(
		Id int null
	)
	
	/*** End: Commmon variables ***/
	
	/* delete last transaction lag number months in DART db */
	SET @SQL = 'DELETE FROM [DART].[dbo].[' + UPPER(@system) + '_RTW]
				WHERE Remuneration_End in (SELECT distinct top ' + CONVERT(varchar, @lag) + ' Remuneration_End
										FROM [DART].[dbo].[' + UPPER(@system) + '_RTW]
											ORDER BY Remuneration_End desc)'
	EXEC(@SQL)
	
	/*** Begin: Process the claim data ***/
	
	/* create #data_clm table to store claim detail info */
	CREATE TABLE #data_clm
	(
		claim varchar(19)
		,deis datetime
		,policyno char(19)
		,renewal_no int
		,hrswrkwk numeric(8,2)
		,injdate datetime
		,MECHANISM_OF_INJURY tinyint
		,nature_of_injury smallint
		,cost_code char(16)
		,cost_code2 char(16)
		,anzsic varchar(255)
		
		/* Calculated fields */
		,date13 datetime
		,date13_2 datetime
		,date13_3 datetime
		,date26 datetime
		,date26_2 datetime
		,date26_3 datetime
		,date52 datetime
		,date52_2 datetime
		,date52_3 datetime
		,date78 datetime
		,date78_2 datetime
		,date78_3 datetime
		,date104 datetime
		,date104_2 datetime
		,date104_3 datetime
		
		,denominator13 int
		,denominator26 int
		,denominator52 int
		,denominator78 int
		,denominator104 int
		
		,numerator13 int
		,numerator26 int
		,numerator52 int
		,numerator78 int
		,numerator104 int
		
		,numerator13_R12 int
		,numerator26_R12 int
		,numerator52_R12 int
		,numerator78_R12 int
		,numerator104_R12 int
		
		,WGT13 float
		,WGT26 float
		,WGT52 float
		,WGT78 float
		,WGT104 float
		
		,WGT13_R12 float
		,WGT26_R12 float
		,WGT52_R12 float
		,WGT78_R12 float
		,WGT104_R12 float
		
		,include13 bit
		,include26 bit
		,include52 bit
		,include78 bit
		,include104 bit
	)

	/* create index for #data_clm table */
	SET @SQL = 'CREATE INDEX pk_data_clm_' + CONVERT(VARCHAR, @@SPID) + ' ON #data_clm(claim, policyno, injdate)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	SET @SQL = 'SELECT	cd.Claim_Number'
						+
						case when UPPER(@system) <> 'TMF'
								then ',cada.Date_Claim_Entered'
							else ',deis = null'
						end
						+
						',cd.Policy_No
						,cd.Renewal_No
						
						/* adjust hours worked per week to be a minimum of 1 and a maximum of 40 */
						,hrswrkwk = (case when dbo.udf_MinValue(dbo.udf_MaxValue(ISNULL(cda.Work_Hours, 1), 1), 40) = 1
												then 37.5
											else
												dbo.udf_MinValue(dbo.udf_MaxValue(ISNULL(cda.Work_Hours, 1), 1), 40)
									end)
						
						,cda.Date_of_Injury
						,cd.MECHANISM_OF_INJURY
						,cd.nature_of_injury
						,cd.cost_code
						,cd.cost_code2'
						+
						case when UPPER(@system) = 'HEM'
								then ',anz.DESCRIPTION'
							else ',anzsic = '''''
						end
						+
						
						'/* Shift 13 weeks from date of injury */
						,date13 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_13) + ')
						
						/* Shift 13 weeks from date of injury + 3 month lag */
						,date13_2 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_13 + @lag) + ')
						
						/* Shift 0 weeks from date of injury */
						,date13_3 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, 0)
						
						/* Shift 26 weeks from date of injury; */
						,date26 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_26) + ')
						
						/* Shift 26 weeks from date of injury + 3 month lag */
						,date26_2 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_26 + @lag) + ')
						
						/* Shift 0 weeks from date of injury */
						,date26_3 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, 0)
						
						/* Shift 52 weeks from date of injury */
						,date52 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_52) + ')
						
						/* Shift 52 weeks from date of injury + 3 month lag */
						,date52_2 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_52 + @lag) + ')
						
						/* Shift 26 weeks from date of injury */
						,date52_3 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_26) + ')
						
						/* Shift 78 weeks from date of injury */
						,date78 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_78) + ')
						
						/* Shift 78 weeks from date of injury + 3 month lag */
						,date78_2 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_78 + @lag) + ')
						
						/* Shift 52 weeks from date of injury */
						,date78_3 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_52) + ')
						
						/* Shift 104 weeks from date of injury */
						,date104 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_104) + ')
						
						/* Shift 104 weeks from date of injury + 3 month lag */
						,date104_2 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_104 + @lag) + ')
						
						/* Shift 52 weeks from date of injury */
						,date104_3 = dbo.udf_Dateshift_RTW(cd.Date_of_Injury, ' + CONVERT(VARCHAR, @measure_month_52) + ')
						
						,denominator13 = 0
						,denominator26 = 0
						,denominator52 = 0
						,denominator78 = 0
						,denominator104 = 0
						
						,numerator13 = 0
						,numerator26 = 0
						,numerator52 = 0
						,numerator78 = 0
						,numerator104 = 0
						
						,numerator13_R12 = 0
						,numerator26_R12 = 0
						,numerator52_R12 = 0
						,numerator78_R12 = 0
						,numerator104_R12 = 0
						
						,WGT13 = 0
						,WGT26 = 0
						,WGT52 = 0
						,WGT78 = 0
						,WGT104 = 0
						
						,WGT13_R12 = 0
						,WGT26_R12 = 0
						,WGT52_R12 = 0
						,WGT78_R12 = 0
						,WGT104_R12 = 0
						
						,include13 = 0
						,include26 = 0
						,include52 = 0
						,include78 = 0
						,include104 = 0
				FROM	dbo.CLAIM_DETAIL cd LEFT JOIN cd_audit cda on cda.claim_no = cd.Claim_Number
							AND cda.id = (SELECT MAX(id) FROM cd_audit cda1
											WHERE cda1.claim_no = cd.Claim_Number and cda1.create_date <= ''' + CONVERT(VARCHAR, @as_at, 120) + ''')'
						+
						case when UPPER(@system) <> 'TMF'
								then 'LEFT JOIN CAD_AUDIT cada on cada.Claim_no = cd.Claim_Number
										AND cada.id = (SELECT MAX(id) FROM CAD_AUDIT cada1
															WHERE cada1.Claim_no = cd.Claim_Number and cada1.Transaction_Date <= ''' + CONVERT(VARCHAR, @as_at, 120) + ''')'
							else ''
						end
						+
						case when UPPER(@system) = 'HEM'
								then 'LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE'
							else ''
						end
						+
				' WHERE
						/* Exclude date of injury outside the measure */
						cd.Date_of_Injury <= ''' + CONVERT(VARCHAR, @overall_prd_end, 120) + '''
						AND cd.Date_of_Injury >= ''' + CONVERT(VARCHAR, DATEADD(m, -36, @overall_prd_start), 120) + ''''
						+
						case when UPPER(@system) = 'EML'
								then ' AND cd.Claim_Number COLLATE Latin1_General_CI_AS not in (select Claim_no from [Dart].[dbo].[EML_SIW])'
							else ''
						end
						+
						case when UPPER(@system) = 'HEM'
								then ' AND ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2
																			WHERE anz2.CODE = anz.CODE), 1)'
							else ''
						end
				
	INSERT INTO #data_clm
	EXEC(@SQL)
	
	/* Calc Denominators */
	UPDATE	#data_clm
		SET	denominator13 = dbo.udf_NoOfDaysWithoutWeekend(date13_3, date13)							
			,denominator26 = dbo.udf_NoOfDaysWithoutWeekend(date26_3, date26)
			,denominator52 = dbo.udf_NoOfDaysWithoutWeekend(date52_3, date52)
			,denominator78 = dbo.udf_NoOfDaysWithoutWeekend(date78_3, date78)
			,denominator104 = dbo.udf_NoOfDaysWithoutWeekend(date104_3, date104)
	
	/*** End: Process the claim data ***/
	
	/*** Begin: Process the policy data ***/
	
	/* create #data_policy table to store policy info for claim */
	CREATE TABLE #data_policy
	(
		policyno char(19)
		,renewalno int
		,wages money
		,bastarif money
		,const_flag_final int
	)
	
	INSERT INTO #data_policy
		SELECT	POLICY_NO
				,RENEWAL_NO
				,WAGES0
				,BTP
				,Process_Flags
			FROM PREMIUM_DETAIL
			
	/* create #activity_detail_audit table to store policy info for claim */
	CREATE TABLE #activity_detail_audit
	(
		policyno CHAR(19)
		,renewal_no INT
		,tariff INT
		,wages_shifts MONEY
	)
	
	/* create index for #activity_detail_audit table */
	SET @SQL = 'CREATE INDEX pk_activity_detail_audit_' + CONVERT(VARCHAR, @@SPID)
				+ ' ON #activity_detail_audit(policyno, renewal_no, tariff)'
	EXEC(@SQL)

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	IF UPPER(@system) = 'HEM'
	BEGIN
		INSERT INTO #activity_detail_audit
			SELECT Policy_No, Renewal_No, Tariff, SUM(ISNULL(Wages_Shifts, 0))
				FROM ACTIVITY_DETAIL_AUDIT ada
				GROUP BY Policy_No, Renewal_No, Tariff
				HAVING EXISTS (SELECT 1 FROM #data_clm cd where cd.policyno = ada.Policy_No)
	END
	
	/*** End: Process the policy data ***/
	
	/*** Begin: Process the payment data ***/
				
	/*	get max submission date */
	DECLARE @max_date int = (SELECT MAX(wc_Tape_Month) FROM Payment_Recovery)
	
	DECLARE @SQL_Select varchar(MAX) = 'SELECT	pr.Claim_No
												,cl.deis
												,paycode = (case when WC_Payment_Type in (''WPT001'', ''WPT003'') then 14
																when WC_Payment_Type in (''WPT002'', ''WPT004'') then 15
																when WC_Payment_Type in (''WPP001'', ''WPP003'') then 13
																when WC_Payment_Type in (''WPP002'', ''WPP004'') then 16
																when WC_Payment_Type in (''WPT005'') then 80
																when WC_Payment_Type in (''WPT006'') then 81
																when WC_Payment_Type in (''WPT007'') then 82
																when WC_Payment_Type in (''WPP005'') then 83
																when WC_Payment_Type in (''WPP006'') then 84
																when WC_Payment_Type in (''WPP007'') then 85
																when WC_Payment_Type in (''WPP008'') then 86
															end)
												,Trans_Amount
												,Period_Start_Date
												,Period_End_Date
												,CONVERT(varchar(10), pr.Transaction_date, 120)
												,wc_Tape_Month
												,cl.hrswrkwk
												,hours_paid = round(ISNULL(pr.wc_Hours, 0) + ISNULL(pr.wc_Minutes, 0)/60.0,2)
												,ISNULL(Rate, 0)'
				
	DECLARE @SQL_From varchar(MAX) = ' FROM dbo.Payment_Recovery pr INNER JOIN #data_clm cl ON pr.Claim_No = cl.claim'
	
	DECLARE @SQL_Where varchar(MAX) = ' WHERE WC_Payment_Type IN (''WPT001'', ''WPT003'', ''WPT002'', ''WPT004'', ''WPP001'', ''WPP003'', ''WPP002'', ''WPP004'',
																	''WPT005'', ''WPT006'', ''WPT007'', ''WPP005'', ''WPP006'', ''WPP007'', ''WPP008'',
																	''13'', ''14'', ''15'', ''16'')
											AND Transaction_date <= ''' + CONVERT(varchar, @as_at, 120) + '''
											AND Transaction_date > ''' + CONVERT(varchar, @paystartdt, 120) + ''''
											+
											case when @max_date >= @as_at8dig then ' AND wc_Tape_Month > 0'
													else ''
											end
											+
											' AND (Period_Start_Date is not null OR Period_End_Date is not null)'
	
	/* The next step separates data into those with adjustments
		and a value in the incapacity start/end dates and other transactions; */
	
	/* create #notadj temp table to store non-adjustment transactions */
	CREATE TABLE #notadj
	(
		 claim varchar(19)
		 ,deis datetime
		 ,paycode int
		 ,payamt money
		 ,ppstart datetime
		 ,ppend datetime
		 ,paydate datetime
		 ,teed int
		 ,hrswrkwk numeric(8,2)
		 ,hours_paid numeric(8,2)
		 ,det_weekly money
	)
	
	SET @SQL =	@SQL_Select
				+ @SQL_From
				+ @SQL_Where
				+ ' AND Adjust_Trans_Flag = ''N'''
	
	INSERT INTO #notadj
	EXEC(@SQL)
	
	/* create #adj temp table to store adjustment transactions */
	CREATE TABLE #adj
	(
		 claim varchar(19)
		 ,deis datetime
		 ,paycode int
		 ,payamt money
		 ,ppstart datetime
		 ,ppend datetime
		 ,paydate datetime
		 ,teed int
		 ,hrswrkwk numeric(8,2)
		 ,hours_paid numeric(8,2)
		 ,det_weekly money
	)
	
	SET @SQL =	@SQL_Select
				+ @SQL_From
				+ @SQL_Where
				+ ' AND Adjust_Trans_Flag = ''Y'''
	
	INSERT INTO #adj
	EXEC(@SQL)
	
	/*	Find max pay date.
		For instances where there are multiple adjustments for a transaction and inconsistent DET_weekly rates between these adjustments, we want to keep the
		the DET_weekly rate from the more recent adjustment. */
	SELECT	claim, ppstart, ppend, paycode, det_weekly,
			max_paydate = (select MAX(paydate)
								from #adj adj2
								where adj2.claim = adj.claim
									and adj2.ppstart = adj.ppstart
									and adj2.ppend = adj.ppend
									and adj2.paycode = adj.paycode)
	INTO	#adj2
	FROM	#adj adj
	
	/*	Find max det weekly.
		In cases where paydate is the same, we will keep the higher det_weekly rate (conservative approach); */
	SELECT	claim, ppstart, ppend, paycode, adj2.max_paydate,
			max_det_weekly = (select MAX(det_weekly)
									from #adj2 _adj2
									where adj2.claim = _adj2.claim
										and adj2.ppstart = _adj2.ppstart
										and adj2.ppend = _adj2.ppend
										and adj2.paycode = _adj2.paycode
										and adj2.max_paydate = _adj2.max_paydate)
	INTO	#adj3
	FROM	#adj2 adj2
	
	/* Drop unused temp table */
	IF OBJECT_ID('tempdb..#adj2') IS NOT NULL DROP table #adj2
	
	/* Apply max det weekly to the other adjustment */
	UPDATE	#adj SET det_weekly = _adj3.max_det_weekly
	FROM	#adj3 _adj3
	WHERE	#adj.claim = _adj3.claim
			AND #adj.ppstart = _adj3.ppstart
			AND #adj.ppend = _adj3.ppend
			AND #adj.paycode = _adj3.paycode
			
	/* Drop unused temp table */
	IF OBJECT_ID('tempdb..#adj3') IS NOT NULL DROP table #adj3
	
	/* Summarise data to combine duplicate adjustments so we can merge later */
	SELECT	distinct claim, ppstart, ppend, paycode, det_weekly
	INTO	#summary
	FROM	#adj
	
	/* Output those that need to adjust in original transactions */
	SELECT	s.claim, notadj.deis, s.ppstart, s.ppend, s.paycode
			,notadj.payamt, notadj.paydate, notadj.teed, notadj.hours_paid, notadj.hrswrkwk
			
			/* Drop DET_weekly from to_adjust dataset, to keep the Determined Weekly Wage Rate applicable to the adjusted payment */
			,det_weekly = NULL
	INTO	#to_adjust
	FROM	#summary s INNER JOIN #notadj notadj
		ON s.claim = notadj.claim
			AND s.ppstart = notadj.ppstart
			AND s.ppend = notadj.ppend
			AND s.paycode = notadj.paycode
			
	/* Output those that no need to adjust in original transactions */
	SELECT	claim, deis, ppstart, ppend, paycode
			,payamt, paydate, teed, hours_paid, hrswrkwk, det_weekly
	INTO	#the_rest
	FROM	#notadj notadj
	WHERE   NOT EXISTS (SELECT * FROM #summary s 
							WHERE s.claim = notadj.claim
								AND s.ppstart = notadj.ppstart
								AND s.ppend = notadj.ppend
								AND s.paycode = notadj.paycode)
								
	/* Drop unused temp table */
	IF OBJECT_ID('tempdb..#notadj') IS NOT NULL DROP table #notadj
								
	/* Create a list that includes the adjustment records (including duplicates)
		and the records to be adjusted */
	SELECT	claim, deis, ppstart, ppend, paycode
			,payamt
			
			/* Drop teed and paydate so that the payment date after adjustment is that of the original transaction, not the adjustment */
			,paydate = NULL, teed = NULL
			
			,hours_paid, hrswrkwk, det_weekly
			
			/* Ensure that the adjflag for these is 'N' */
			,adjflag = 'N'
	INTO	#adjust_list
	FROM	#adj
	UNION ALL
	SELECT	claim, deis, ppstart, ppend, paycode
			,payamt, paydate, teed, hours_paid, hrswrkwk, det_weekly
			
			/* Ensure that the adjflag for these is 'N' */
			,adjflag = 'N'
	FROM	#to_adjust
	
	/* Drop unused temp tables */
	IF OBJECT_ID('tempdb..#adj') IS NOT NULL DROP table #adj
	IF OBJECT_ID('tempdb..#to_adjust') IS NOT NULL DROP table #to_adjust
	
	/* Correct records which are reversal records, where a payment is reversed but not hours_paid */
	UPDATE	#adjust_list SET hours_paid = -hours_paid
	WHERE	payamt < 0 AND hours_paid > 0
	
	/* Now add the adjustment and records to be adjusted together */
	SELECT  claim
			,deis
			,paycode
			
			/* largest paydate is used for transactions with same claim, ppstart, ppend, paycode */
			,paydate = (SELECT MAX(paydate)
							FROM	#adjust_list adj1
							WHERE	adj1.claim = adj.claim
									and adj1.ppstart = adj.ppstart
									and adj1.ppend = adj.ppend
									and adj1.paycode = adj.paycode)
			
			/* largest teed is used for transactions with same claim, ppstart, ppend, paycode */
			,teed = (SELECT MAX(teed)
						FROM	#adjust_list adj1
						WHERE	adj1.claim = adj.claim
								and adj1.ppstart = adj.ppstart
								and adj1.ppend = adj.ppend
								and adj1.paycode = adj.paycode)
			
			,payamt = (SELECT SUM(payamt)
							FROM	#adjust_list adj1 
							WHERE	adj1.claim = adj.claim
									and adj1.ppstart = adj.ppstart
									and adj1.ppend = adj.ppend
									and adj1.paycode = adj.paycode)
			,ppstart
			,ppend
			,hrswrkwk
			,hours_paid = (SELECT SUM(hours_paid)
								FROM	#adjust_list adj1
								WHERE	adj1.claim = adj.claim
									and adj1.ppstart = adj.ppstart
									and adj1.ppend = adj.ppend
									and adj1.paycode = adj.paycode)
	INTO	#correct_records_excl_det
	FROM	#adjust_list adj
	GROUP BY claim,
			deis,
			ppstart,
			ppend,
			paycode,
			hrswrkwk
	
	/* Drop unused temp table */
	IF OBJECT_ID('tempdb..#adjust_list') IS NOT NULL DROP table #adjust_list
			
	SELECT	rec.claim, rec.deis, rec.ppstart, rec.ppend, rec.paycode, payamt, paydate, teed
			,hours_paid, hrswrkwk, det_weekly = s.det_weekly
			,flag = null
			
			/* Calc number of working days between start and end dates */
			,ppdays = dbo.udf_NoOfDaysWithoutWeekend(rec.ppstart, rec.ppend)
			
			,days_hrs = 0
			,wage_day = 0
	INTO	#correct_records
	FROM	#correct_records_excl_det rec LEFT JOIN #summary s
			ON rec.claim = s.claim
				AND rec.ppstart = s.ppstart
				AND rec.ppend = s.ppend
				AND rec.paycode = s.paycode
	WHERE	paydate is not null
	
	/* Drop unused temp table */
	IF OBJECT_ID('tempdb..#correct_records_excl_det') IS NOT NULL DROP table #correct_records_excl_det
	
	/* create #rtw_raw table to store transactions data after cleansing step #1 */
	CREATE TABLE #rtw_raw
	(
		 claim varchar(19)
		 ,deis datetime
		 ,ppstart datetime
		 ,ppend datetime
		 ,paycode int
		 ,payamt money
		 ,paydate datetime
		 ,teed int
		 ,hours_paid numeric(8,2)
		 ,hrswrkwk numeric(8,2)
		 ,det_weekly money
	)
	
	/* create index for #rtw_clean table */
	SET @SQL = 'CREATE INDEX pk_rtw_raw_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raw(claim, paycode, paydate)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* Correct new dataset with the original correct data and the new corrected data */
	INSERT INTO #rtw_raw
	SELECT	claim, deis, ppstart, ppend, paycode, payamt, paydate, teed, hours_paid, hrswrkwk, det_weekly
	FROM	#correct_records
	UNION ALL
	SELECT	claim, deis, ppstart, ppend, paycode, payamt, paydate, teed, hours_paid, hrswrkwk, det_weekly
	FROM	#the_rest
	
	/* Drop unused temp tables */
	IF OBJECT_ID('tempdb..#correct_records') IS NOT NULL DROP table #correct_records
	IF OBJECT_ID('tempdb..#the_rest') IS NOT NULL DROP table #the_rest
	
	/* create #rtw_clean table to store transactions data after cleansing step #2 */
	CREATE TABLE #rtw_clean
	(
		 claim varchar(19)
		 ,deis datetime
		 ,ppstart datetime
		 ,ppend datetime
		 ,paycode int
		 ,payamt money
		 ,paydate datetime
		 ,teed int
		 ,hours_paid numeric(8,2)
		 ,hrswrkwk numeric(8,2)
		 ,det_weekly money
		 ,flag bit
		 ,ppdays int
		 ,days_hrs numeric(8,2)
		 ,wage_day float
	)
	
	/* create index for #rtw_clean table */
	SET @SQL = 'CREATE INDEX pk_rtw_clean_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_clean(claim, paycode, paydate)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* Correct new dataset with the original correct data and the new corrected data */
	INSERT INTO #rtw_clean
	SELECT	claim, deis, ppstart, ppend, paycode
			,payamt = (SELECT SUM(payamt)
							FROM	#rtw_raw rtw1 
							WHERE	rtw1.claim = rtw.claim
									and rtw1.ppstart = rtw.ppstart
									and rtw1.ppend = rtw.ppend
									and rtw1.paycode = rtw.paycode
									and rtw1.paydate = rtw.paydate
									and rtw1.teed = rtw.teed
									and rtw1.hrswrkwk = rtw.hrswrkwk
									and rtw1.det_weekly = rtw.det_weekly)
			,paydate, teed
			,hours_paid = (SELECT SUM(hours_paid)
								FROM	#rtw_raw rtw1 
								WHERE	rtw1.claim = rtw.claim
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend
										and rtw1.paycode = rtw.paycode
										and rtw1.paydate = rtw.paydate
										and rtw1.teed = rtw.teed
										and rtw1.hrswrkwk = rtw.hrswrkwk
										and rtw1.det_weekly = rtw.det_weekly)
			,hrswrkwk, det_weekly
			,flag = null
			
			/* Calc number of working days between start and end dates */
			,ppdays = dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend)
			
			,days_hrs = 0
			,wage_day = 0
	FROM	#rtw_raw rtw
	GROUP BY claim,
			deis,
			ppstart,
			ppend,
			paycode,
			paydate,
			teed,
			hrswrkwk,
			det_weekly
	
	/* Drop unused temp table */
	IF OBJECT_ID('tempdb..#rtw_raw') IS NOT NULL DROP table #rtw_raw
			
	/* Records with payment amount and hours paid are both zero are removed. */
	DELETE FROM #rtw_clean WHERE payamt = 0 and hours_paid = 0
	
	IF UPPER(@system) <> 'TMF'
	BEGIN
		/* Remove records with zero payments. Decision made that regardless of whether non-zero
			hours or weeks they do not contribute to the measure*/
		DELETE FROM #rtw_clean WHERE payamt = 0
		
		/* Records with non-zero payments and zero hours and weeks also deleted. They have
		no time off work so dont include. If didnt remove here it would count as 
		negative time off work for partial incapacity payments

		For claims with date entered into system on or after 1/10/2012, we need to investigate for
		claims being removed for this same reason if they have valid det_weekly and payamt values
		and hence should not be removed */
		DELETE FROM #rtw_clean WHERE deis < '2012-10-01' and hours_paid = 0
	END
			
	/* Records with a negative payment amount, but positive hours paid for total incapacity
		have their hours paid changed to be negative */
	UPDATE #rtw_clean SET hours_paid = -1 * hours_paid WHERE payamt < 0 and hours_paid > 0
	
	/* calc days_hrs */
	UPDATE #rtw_clean
		SET days_hrs = case when hours_paid <> 0
								then ROUND(1.0 * hours_paid / (hrswrkwk / 5.0), 2)
							else 0
						end
						
	/*** Make sure these recovs get allowed for but use lower pay amount. 21*ppdays will ensure if gets kept ***/
	
	UPDATE #rtw_clean SET flag = 1 WHERE payamt <= 0 or hours_paid < 0
	
	/** for codes 13, 16, 83, 84, 85, 86 **/
	
	/* adjust payment amount */
	UPDATE #rtw_clean 
		SET payamt = dbo.udf_MinValue(payamt, -21 * ppdays)
		WHERE paycode in (13, 16, 83, 84, 85, 86) and flag = 1
		
	/* calc wage_day */
	UPDATE #rtw_clean 
		SET wage_day = case when ppdays > 0
								then 1.0 * payamt / ppdays
							else payamt
						end
		WHERE paycode in (13, 16, 83, 84, 85, 86)
	
	/** for codes 14, 15, 80, 81, 82 **/
			
	/* adjust payment amount */
	UPDATE #rtw_clean 
		SET payamt = case when days_hrs > 0
								then dbo.udf_MinValue(payamt, -21 * days_hrs)
							when ppdays > 0
								then dbo.udf_MinValue(payamt, -21 * ppdays)
							else payamt
					end
		WHERE paycode in (14, 15, 80, 81, 82) and flag = 1
		
	/* calc wage_day */
	UPDATE #rtw_clean
		SET wage_day = case when days_hrs > 0
								then 1.0 * payamt / days_hrs
							when ppdays > 0
								then 1.0 * payamt / ppdays
							else payamt
						end
		WHERE paycode in (14, 15, 80, 81, 82)
		
	/* Dont adjust the flagged records */
	UPDATE #rtw_clean SET wage_day = wage_day * 37.5 / hrswrkwk
		WHERE (flag is null or flag = 0) and hrswrkwk < 35
		
	/*** further data cleaning to remove small transactions ***/
	
	DELETE FROM #rtw_clean
		WHERE paycode in (13, 14, 15, 80, 81, 82) AND ABS(wage_day) < 20
		
	DELETE FROM #rtw_clean
		WHERE paycode in (16, 83, 84, 85, 86) AND ABS(wage_day) < 2
		
	/* Negative payments turn to positive */
	UPDATE #rtw_clean SET hours_paid = -1 * ABS(hours_paid) WHERE payamt <= 0
	
	/*** End: Process the payment data ***/
	
	/*** Begin: Output data ***/
	
	WHILE (@i) >= 0
	BEGIN
		SET @prd_start_temp = DATEADD(mm, @i, @overall_prd_start)
		SET @yy = YEAR(@prd_start_temp)
		SET @mm = MONTH(@prd_start_temp)
		
		SET @SQL = 'SELECT TOP 1 Id FROM [DART].[dbo].[' + UPPER(@system) + '_RTW]
						WHERE YEAR(Remuneration_End) = ' + CONVERT(varchar, @yy) + ' AND MONTH(Remuneration_End) = ' + CONVERT(varchar, @mm)
		
		INSERT INTO #check
		EXEC(@SQL)
		
		IF NOT EXISTS(SELECT * FROM #check)
			AND
			CAST(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
				< CAST(CAST(YEAR(@current_date) as varchar) + '/' +  CAST(MONTH(@current_date) as varchar) + '/01' as datetime)
		BEGIN
			/* init rolling months table data */
			INSERT INTO #rolling_months
			SELECT 1
			UNION SELECT 3 
			UNION SELECT 6 
			UNION SELECT 12
			
			WHILE EXISTS (SELECT R FROM #rolling_months)
			BEGIN
				SELECT TOP 1 @R = R FROM #rolling_months
				
				IF OBJECT_ID('tempdb..#data_clm_filtered') IS NOT NULL DROP TABLE #data_clm_filtered
				IF OBJECT_ID('tempdb..#rtw_clean_filtered') IS NOT NULL DROP TABLE #rtw_clean_filtered
				IF OBJECT_ID('tempdb..#claim_summary') IS NOT NULL DROP TABLE #claim_summary
				IF OBJECT_ID('tempdb..#total_claim_summary') IS NOT NULL DROP TABLE #total_claim_summary
				
				DECLARE @prd_end datetime
				DECLARE @prd_start datetime
				
				SET @prd_end = DATEADD(mm, 1, cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime))
				SET @prd_start = DATEADD(mm,-@R, @prd_end)
				SET @prd_end = DATEADD(dd, -1, @prd_end) + '23:59'
				
				DECLARE @data_asat int = CONVERT(int, CONVERT(varchar(8), DATEADD(m, DATEDIFF(m, 0, DATEADD(m, 4, @prd_end)), -1), 112))
				
				/* Display action message to console window */
				PRINT 'Start inserting ' + CAST(@prd_end as varchar) + ' - R' + CAST(@R as varchar)
				
				CREATE TABLE #data_clm_filtered
				(
					claim varchar(19)
					,deis datetime
					,policyno char(19)
					,renewal_no int
					,hrswrkwk numeric(8,2)
					,injdate datetime
					,MECHANISM_OF_INJURY tinyint
					,nature_of_injury smallint
					,cost_code char(16)
					,cost_code2 char(16)
					,anzsic varchar(255)
					
					/* Calculated fields */
					,date13 datetime
					,date13_2 datetime
					,date13_3 datetime
					,date26 datetime
					,date26_2 datetime
					,date26_3 datetime
					,date52 datetime
					,date52_2 datetime
					,date52_3 datetime
					,date78 datetime
					,date78_2 datetime
					,date78_3 datetime
					,date104 datetime
					,date104_2 datetime
					,date104_3 datetime
					
					,denominator13 int
					,denominator26 int
					,denominator52 int
					,denominator78 int
					,denominator104 int
					
					,numerator13 int
					,numerator26 int
					,numerator52 int
					,numerator78 int
					,numerator104 int
					
					,numerator13_R12 int
					,numerator26_R12 int
					,numerator52_R12 int
					,numerator78_R12 int
					,numerator104_R12 int
					
					,WGT13 float
					,WGT26 float
					,WGT52 float
					,WGT78 float
					,WGT104 float
					
					,WGT13_R12 float
					,WGT26_R12 float
					,WGT52_R12 float
					,WGT78_R12 float
					,WGT104_R12 float
					
					,include13 bit
					,include26 bit
					,include52 bit
					,include78 bit
					,include104 bit
				)
				
				/* create index for #data_clm_filtered table */
				SET @SQL = 'CREATE INDEX pk_data_clm_filtered_' + CONVERT(VARCHAR, @@SPID) + ' ON #data_clm_filtered(claim, policyno, injdate)'
				EXEC(@SQL)
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRAN
					RETURN
				END
				
				/* create the claim dataset by retrieving the data from the common claim collection */
		
				SET @SQL = 'SELECT * FROM #data_clm
							WHERE
								/* Exclude date of injury outside the measure */
								injdate <= ''' + CONVERT(VARCHAR, @prd_end, 120) + '''
								AND injdate >= ''' + CONVERT(VARCHAR, DATEADD(m, -24, @prd_start), 120) + ''''
							
				INSERT INTO #data_clm_filtered
				EXEC(@SQL)
				
				/* Calc Numerators */
				UPDATE	#data_clm_filtered
					SET	numerator13 = dbo.udf_NoOfDaysWithoutWeekend(
											date13_3
											,dbo.udf_MinDay(date13, @prd_end,'2222/01/01'))
						,numerator26 = dbo.udf_NoOfDaysWithoutWeekend(
											date26_3
											,dbo.udf_MinDay(date26, @prd_end,'2222/01/01'))
						,numerator52 = dbo.udf_NoOfDaysWithoutWeekend(
											date52_3
											,dbo.udf_MinDay(date52, @prd_end,'2222/01/01'))
						,numerator78 = dbo.udf_NoOfDaysWithoutWeekend(
											date78_3
											,dbo.udf_MinDay(date78, @prd_end,'2222/01/01'))
						,numerator104 = dbo.udf_NoOfDaysWithoutWeekend(
											date104_3
											,dbo.udf_MinDay(date104, @prd_end,'2222/01/01'))
											
						,numerator13_R12 = dbo.udf_NoOfDaysWithoutWeekend(
												dbo.udf_MaxDay(date13_3, @prd_start,'1900/01/01')
												,dbo.udf_MinDay(date13, @prd_end,'2222/01/01'))
						,numerator26_R12 = dbo.udf_NoOfDaysWithoutWeekend(
												dbo.udf_MaxDay(date26_3, @prd_start,'1900/01/01')
												,dbo.udf_MinDay(date26, @prd_end,'2222/01/01'))
						,numerator52_R12 = dbo.udf_NoOfDaysWithoutWeekend(
												dbo.udf_MaxDay(date52_3, @prd_start,'1900/01/01')
												,dbo.udf_MinDay(date52, @prd_end,'2222/01/01'))
						,numerator78_R12 = dbo.udf_NoOfDaysWithoutWeekend(
												dbo.udf_MaxDay(date78_3, @prd_start,'1900/01/01')
												,dbo.udf_MinDay(date78, @prd_end,'2222/01/01'))
						,numerator104_R12 = dbo.udf_NoOfDaysWithoutWeekend(
												dbo.udf_MaxDay(date104_3, @prd_start,'1900/01/01')
												,dbo.udf_MinDay(date104, @prd_end,'2222/01/01'))
							
				/* Calc Claim Weights */
				UPDATE #data_clm_filtered
					SET	WGT13 = dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator13/denominator13))
						,WGT26 = dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator26/denominator26))
						,WGT52 = dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator52/denominator52))
						,WGT78 = dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator78/denominator78))
						,WGT104 = dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator104/denominator104))
						
						,WGT13_R12 = dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator13_R12/denominator13))
						,WGT26_R12 = dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator26_R12/denominator26))
						,WGT52_R12 = dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator52_R12/denominator52))
						,WGT78_R12 = dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator78_R12/denominator78))
						,WGT104_R12 = dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator104_R12/denominator104))
						
						,include13 = case when dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator13_R12/denominator13)) > 0 then 1 else 0 end
						,include26 = case when dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator26_R12/denominator26)) > 0 then 1 else 0 end
						,include52 = case when dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator52_R12/denominator52)) > 0 then 1 else 0 end
						,include78 = case when dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator78_R12/denominator78)) > 0 then 1 else 0 end
						,include104 = case when dbo.udf_MaxValue(0, dbo.udf_MinValue(1, 1.0 * numerator104_R12/denominator104)) > 0 then 1 else 0 end
						
				/* create #rtw_clean_filtered table to store transactions data after cleaning step #1 */
				CREATE TABLE #rtw_clean_filtered
				(
					 claim varchar(19)
					 ,deis datetime
					 ,ppstart datetime
					 ,ppend datetime
					 ,paycode int
					 ,payamt money
					 ,paydate datetime
					 ,teed int
					 ,hours_paid numeric(8,2)
					 ,hrswrkwk numeric(8,2)
					 ,det_weekly money
					 ,flag bit
					 ,ppdays int
					 ,days_hrs numeric(8,2)
					 ,wage_day float
				)	
				
				/* create index for #rtw_clean_filtered table */
				SET @SQL = 'CREATE INDEX pk_rtw_clean_filtered_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_clean_filtered(claim, paycode, paydate)'
				EXEC(@SQL)
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRAN
					RETURN
				END
				
				/* create the payment dataset by retrieving the data from the common payment collection */
		
				SET @SQL  = 'SELECT * FROM #rtw_clean
								WHERE teed <= ' + CONVERT(varchar, @data_asat)
								
				INSERT INTO #rtw_clean_filtered
				EXEC(@SQL)
				
				/* create #claim_summary table that contains all of necessary columns for calculating RTW claim_summary */
				CREATE TABLE #claim_summary
				(
					claim CHAR(19)
					,policyno CHAR(19)
					,portfolio varchar(256)
					,injdate datetime
					,paycode int
					,ppstart datetime
					,ppend datetime
					,paydate datetime
					,teed int
					
					,date13 datetime
					,date13_2 datetime
					,date26 datetime
					,date26_2 datetime
					,date52 datetime
					,date52_2 datetime
					,date78 datetime
					,date78_2 datetime
					,date104 datetime
					,date104_2 datetime
					
					,WGT13 float
					,WGT26 float
					,WGT52 float
					,WGT78 float
					,WGT104 float
					
					,WGT13_R12 float
					,WGT26_R12 float
					,WGT52_R12 float
					,WGT78_R12 float
					,WGT104_R12 float
					
					,include13 bit
					,include26 bit
					,include52 bit
					,include78 bit
					,include104 bit
					
					,payamt money
					,hrswrkwk numeric(5,2)
					,weeks_paid_adjusted float
					,empl_size varchar(256)
					,LT float
					
					/* Calculated fields */
					,LT13_total float
					,LT26_total float
					,LT52_total float
					,LT78_total float
					,LT104_total float
					
					,LT13_prior float
					,LT26_prior float
					,LT52_prior float
					,LT78_prior float
					,LT104_prior float
					
					,CAP_pre_13 float
					,CAP_pre_26 float
					,CAP_pre_52 float
					,CAP_pre_78 float
					,CAP_pre_104 float
					
					,CAP_cur_13 float
					,CAP_cur_26 float
					,CAP_cur_52 float
					,CAP_cur_78 float
					,CAP_cur_104 float
				)
				 
				/* create index for #claim_summary table */
				SET @SQL = 'CREATE INDEX pk_claim_summary_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim_summary(claim,policyno,injdate)'
				EXEC(@SQL)
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRAN
					RETURN
				END
					
				SET @SQL = 'SELECT	DISTINCT
									pr.Claim
									,cd.policyno'
									+
									case when UPPER(@system) = 'HEM'
											then ',portfolio = case when isnull(cd.anzsic,'''') <> ''''
																		then
																			case when UPPER(cd.anzsic) = ''ACCOMMODATION'' 
																					or UPPER(cd.anzsic) = ''PUBS, TAVERNS AND BARS'' 
																					or UPPER(cd.anzsic) = ''CLUBS (HOSPITALITY)'' then cd.anzsic
																				else ''Other''
																			end
																	else
																		case when LEFT(ada.tariff, 1) = ''1'' and LEN(ada.tariff) = 7
																				then 
																					case when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = ''571000''
																						then ''Accommodation''
																					when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = ''572000''
																						then ''Pubs, Taverns and Bars''
																					when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = ''574000''
																						then ''Clubs''
																					else ''Other''
																				end
																			else 
																				case when ada.tariff = 571000 then ''Accommodation''
																					when ada.tariff = 572000 then ''Pubs, Taverns and Bars''
																					when ada.tariff = 574000 then ''Clubs''
																					else ''Other''
																				end
																		end
																end'
										else ',portfolio = '''''
									end
									+
									',injdate
									,pr.paycode
									,pr.ppstart
									,pr.ppend
									,pr.paydate
									,pr.teed
									
									,cd.date13
									,cd.date13_2
									,cd.date26
									,cd.date26_2
									,cd.date52
									,cd.date52_2
									,cd.date78
									,cd.date78_2
									,cd.date104
									,cd.date104_2
									
									,cd.WGT13
									,cd.WGT26
									,cd.WGT52
									,cd.WGT78
									,cd.WGT104
									
									,cd.WGT13_R12
									,cd.WGT26_R12
									,cd.WGT52_R12
									,cd.WGT78_R12
									,cd.WGT104_R12
									
									,cd.include13
									,cd.include26
									,cd.include52
									,cd.include78
									,cd.include104
									
									,pr.payamt
									,cd.hrswrkwk
									
									/* Adjust weeks paid */
									,weeks_paid_adjusted = 1.0 * pr.hours_paid / cd.hrswrkwk
									
									/* Determine Employer size: Small, Small-Medium, Medium or Large.
										Set default to Small when missing policy data; */
									,empl_size = (case when pd.bastarif IS NULL OR pd.const_flag_final IS NULL OR pd.wages IS NULL 
															then ''A - Small''
														when pd.wages <= 300000 
															then ''A - Small''
														when pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final = 1 
															then ''A - Small''
														when pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final <> 1 
															then ''B - Small-Medium''
														when pd.wages > 1000000 AND pd.wages <= 5000000 
															then ''C - Medium''
														when pd.wages > 5000000 AND pd.wages <= 15000000 AND pd.bastarif <= 100000 
															then ''C - Medium''
														when pd.wages > 15000000 
															then ''D - Large''
														when pd.wages > 5000000 AND pd.bastarif > 100000 
															then ''D - Large''
													  else ''A - Small''
												 end)
													
									/* Calc Lost Time */
									,LT = '
									+
									case when UPPER(@system) = 'TMF' 
											then '(case when pr.paycode in (16, 83, 84, 85, 86)
															then sign(pr.payamt) * pr.ppdays * 0.75
														when pr.paycode in (13)
															then sign(pr.payamt) * pr.ppdays
														when pr.paycode in (14, 15, 80, 81, 82)
															then 5.0 * pr.hours_paid / cd.hrswrkwk
														else 5.0 * pr.payamt / pr.DET_weekly
													end)'
										else '(case when pr.paycode in (16)
													then sign(pr.payamt) * pr.ppdays * 0.75
												when pr.paycode in (13)
													then sign(pr.payamt) * pr.ppdays
												when pr.paycode in (14, 15)
													then 5.0 * pr.hours_paid / cd.hrswrkwk
												else 5.0 * pr.payamt / pr.DET_weekly
											end)'
									end
									+
									',LT13_total = 0
									,LT26_total = 0
									,LT52_total = 0
									,LT78_total = 0
									,LT104_total = 0
									
									,LT13_prior = 0
									,LT26_prior = 0
									,LT52_prior = 0
									,LT78_prior = 0
									,LT104_prior = 0
									
									/* Cap lost time before rem period */
									,CAP_pre_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(injdate,
											dbo.udf_MinDay(DATEADD(dd, -1, ''' + CONVERT(VARCHAR, @prd_start, 120) + '''), date13, ''2222/01/01'')))
									,CAP_pre_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(injdate,
											dbo.udf_MinDay(DATEADD(dd, -1, ''' + CONVERT(VARCHAR, @prd_start, 120) + '''), date26, ''2222/01/01'')))
									,CAP_pre_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(injdate,
											dbo.udf_MinDay(DATEADD(dd, -1, ''' + CONVERT(VARCHAR, @prd_start, 120) + '''), date52, ''2222/01/01'')))
									,CAP_pre_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(injdate,
											dbo.udf_MinDay(DATEADD(dd, -1, ''' + CONVERT(VARCHAR, @prd_start, 120) + '''), date78, ''2222/01/01'')))
									,CAP_pre_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(injdate,
											dbo.udf_MinDay(DATEADD(dd, -1, ''' + CONVERT(VARCHAR, @prd_start, 120) + '''), date104, ''2222/01/01'')))
									
									/* Cap lost time current rem period */
									,CAP_cur_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(injdate,
											dbo.udf_MinDay(''' + CONVERT(VARCHAR, @prd_end, 120) + ''', date13, ''2222/01/01'')))
									,CAP_cur_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(injdate,
											dbo.udf_MinDay(''' + CONVERT(VARCHAR, @prd_end, 120) + ''', date26, ''2222/01/01'')))
									,CAP_cur_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(injdate,
											dbo.udf_MinDay(''' + CONVERT(VARCHAR, @prd_end, 120) + ''', date52, ''2222/01/01'')))												
									,CAP_cur_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(injdate,
											dbo.udf_MinDay(''' + CONVERT(VARCHAR, @prd_end, 120) + ''', date78, ''2222/01/01'')))
									,CAP_cur_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(injdate,
											dbo.udf_MinDay(''' + CONVERT(VARCHAR, @prd_end, 120) + ''', date104, ''2222/01/01'')))
									
							FROM	#data_clm_filtered cd
									INNER JOIN #rtw_clean_filtered pr ON cd.claim = pr.claim
									LEFT JOIN  #data_policy pd ON pd.policyno = cd.policyno
										AND pd.renewalno = cd.renewal_no
										AND pr.ppstart <= ''' + CONVERT(VARCHAR, @as_at, 120) + ''''
									+ 
									case when UPPER(@system) = 'HEM'
											then 'LEFT JOIN #activity_detail_audit ada
													ON ada.policyno = cd.policyno AND ada.renewal_no = cd.renewal_no
												WHERE ada.wages_shifts = (SELECT MAX(ada2.wages_shifts)
																			FROM #activity_detail_audit ada2
																			WHERE ada2.policyno = ada.policyno
																				AND ada2.renewal_no = ada.renewal_no)'
										else ''
									end
											
				INSERT INTO #claim_summary
				EXEC(@SQL)
											
				/* Drop unused temp table */
				IF OBJECT_ID('tempdb..#rtw_clean_filtered') IS NOT NULL DROP TABLE #rtw_clean_filtered
				
				/* re-weight part-timer to full-timer */
				UPDATE #claim_summary SET LT = 1.0 * LT * (hrswrkwk / 37.5) WHERE hrswrkwk < 35
														
				/* Calc cumulative days lost till end of current remuneration period */	
				UPDATE #claim_summary
					SET	LT13_total = case when paydate <= date13_2
											then
												case when dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend)) <> 0
														then 1.0 * LT * dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, dbo.udf_MinDay(date13, @prd_end, ppend)))
																/ dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend))
													else
														case when UPPER(@system) = 'TMF' then 1 else LT * 1 end
												end
										else 0 
									end
						,LT26_total = case when paydate <= date26_2
											then
												case when dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend)) <> 0
														then 1.0 * LT * dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, dbo.udf_MinDay(date26, @prd_end, ppend)))
																/ dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend))
													else
														case when UPPER(@system) = 'TMF' then 1 else LT * 1 end
												end
										else 0 
									end
						,LT52_total = case when paydate <= date52_2
											then
												case when dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend)) <> 0
														then 1.0 * LT * dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, dbo.udf_MinDay(date52, @prd_end, ppend)))
																/ dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend))
													else
														case when UPPER(@system) = 'TMF' then 1 else LT * 1 end
												end
										else 0
									end
						,LT78_total = case when paydate <= date78_2
											then
												case when dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend)) <> 0
														then 1.0 * LT * dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, dbo.udf_MinDay(date78, @prd_end, ppend)))
																/ dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend))
													else
														case when UPPER(@system) = 'TMF' then 1 else LT * 1 end
												end
										else 0 
									end
						,LT104_total = case when paydate <= date104_2
												then
													case when dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend)) <> 0
															then 1.0 * LT * dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, dbo.udf_MinDay(date104, @prd_end, ppend)))
																	/ dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend))
														else
															case when UPPER(@system) = 'TMF' then 1 else LT * 1 end
													end
											else 0 
										end
						
				/* Calc cumulative days lost before the start of the current remuneration period */
				UPDATE #claim_summary
					SET	LT13_prior = case when paydate <= DATEADD(d, -1, DATEADD(m, 3, @prd_start))
												and teed <= CONVERT(int, CONVERT(varchar(8), DATEADD(d, -1, DATEADD(m, 3, @prd_start)), 112))
												and paydate <= date13_2
											then
												case when dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend)) <> 0
														then 1.0 * LT * dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, dbo.udf_MinDay(date13, DATEADD(dd, -1, @prd_start), ppend)))
																/ dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend))
													else
														case when UPPER(@system) = 'TMF' then 1 else LT * 1 end
												end
										else 0 
									end
						,LT26_prior =  case when paydate <= DATEADD(d, -1, DATEADD(m, 3, @prd_start))
													and teed <= CONVERT(int, CONVERT(varchar(8), DATEADD(d, -1, DATEADD(m, 3, @prd_start)), 112))
													and paydate <= date26_2
												then
													case when dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend)) <> 0
															then 1.0 * LT * dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, dbo.udf_MinDay(date26, DATEADD(dd, -1, @prd_start), ppend)))
																	/ dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend))
														else
															case when UPPER(@system) = 'TMF' then 1 else LT * 1 end
													end
											else 0 
										end
						,LT52_prior = case when paydate <= DATEADD(d, -1, DATEADD(m, 3, @prd_start))
													and teed <= CONVERT(int, CONVERT(varchar(8), DATEADD(d, -1, DATEADD(m, 3, @prd_start)), 112))
													and paydate <= date52_2
												then
													case when dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend)) <> 0
															then 1.0 * LT * dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, dbo.udf_MinDay(date52, DATEADD(dd, -1, @prd_start), ppend)))
																	/ dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend))
														else
															case when UPPER(@system) = 'TMF' then 1 else LT * 1 end
													end
											else 0
										end
						,LT78_prior = case when paydate <= DATEADD(d, -1, DATEADD(m, 3, @prd_start))
													and teed <= CONVERT(int, CONVERT(varchar(8), DATEADD(d, -1, DATEADD(m, 3, @prd_start)), 112))
													and paydate <= date78_2
												then
													case when dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend)) <> 0
															then 1.0 * LT * dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, dbo.udf_MinDay(date78, DATEADD(dd, -1, @prd_start), ppend)))
																	/ dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend))
														else
															case when UPPER(@system) = 'TMF' then 1 else LT * 1 end
													end
											else 0
										end
						,LT104_prior = case when paydate <= DATEADD(d, -1, DATEADD(m, 3, @prd_start))
													and teed <= CONVERT(int, CONVERT(varchar(8), DATEADD(d, -1, DATEADD(m, 3, @prd_start)), 112))
													and paydate <= date104_2
												then
													case when dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend)) <> 0
															then 1.0 * LT * dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, dbo.udf_MinDay(date104, DATEADD(dd, -1, @prd_start), ppend)))
																	/ dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(ppstart, ppend))
														else
															case when UPPER(@system) = 'TMF' then 1 else LT * 1 end
													end
											else 0
										end
				
				/* create #total_claim_summary table that contains the claim summary data after grouping */
				CREATE TABLE #total_claim_summary
				(
					claim_no CHAR(19)
					,measure int
					,injdate datetime
					,policyno CHAR(19)
					,portfolio varchar(256)
					,LT float
					,WGT float
					,empl_size varchar(256)
					,Weeks_Paid float
				)
				 
				/* create index for #total_claim_summary table */
				SET @SQL = 'CREATE INDEX pk_total_claim_summary_' + CONVERT(VARCHAR, @@SPID) + ' ON #total_claim_summary(claim_no,measure)'
				EXEC(@SQL)
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRAN
					RETURN
				END
				
				INSERT INTO #total_claim_summary
				
				/* 13 weeks */
				SELECT	RTRIM(claim) as claim_no
						,measure = 13
						,injdate
						,policyno
						,portfolio
						,case when include13 = 1
								then
									ROUND(
										/* LT13_TOTAL */
										(case when SUM(LT13_total) <= 5
												then 0 
											else dbo.udf_MinValue(SUM(LT13_total),CAP_CUR_13)
										end)
										-
										/* LT13_PRIOR */
										(case when SUM(LT13_prior) <= 5
												then 0
											else dbo.udf_MinValue(SUM(LT13_prior),CAP_PRE_13)
										end)
									, 10) 
								else 0
						end as LT
						,ROUND(
							(case when @R <> 12
									then
										/* pick up previous weight if claim is dropped out in prior calculation because of the 5 days cutoff */
										case when SUM(LT13_total) > 5 AND SUM(LT13_prior) <= 5
												then WGT13
											else 
												case when SUM(LT13_total) <= 5
														then 0
													else WGT13_R12
												end
										end
								else
									case when SUM(LT13_total) <= 5
											then 0
										else WGT13_R12
									end
							end)
						, 10) as WGT
						,empl_size
						,SUM(Weeks_Paid_adjusted) as Weeks_Paid
				FROM #claim_summary cla
				GROUP BY claim,
						injdate,
						policyno,
						portfolio,
						empl_size,
						date13,
						CAP_CUR_13,
						CAP_PRE_13,
						WGT13,
						WGT13_R12,
						include13
						
				UNION ALL
				
				/* 26 weeks */
				SELECT	RTRIM(claim) as claim_no
						,measure = 26
						,injdate
						,policyno
						,portfolio
						,case when include26 = 1
								then
									ROUND(
										/* LT26_TOTAL */
										(case when SUM(LT26_total) <= 5
												then 0 
											else dbo.udf_MinValue(SUM(LT26_total),CAP_CUR_26)
										end)
										-
										/* LT26_PRIOR */
										(case when SUM(LT26_prior) <= 5
												then 0
											else dbo.udf_MinValue(SUM(LT26_prior),CAP_PRE_26)
										end)
									, 10)
								else 0
						end as LT
						,ROUND(
							(case when @R <> 12
									then
										/* pick up previous weight if claim is dropped out in prior calculation because of the 5 days cutoff */
										case when SUM(LT26_total) > 5 AND SUM(LT26_prior) <= 5
												then WGT26
											else 
												case when SUM(LT26_total) <= 5
														then 0
													else WGT26_R12
												end
										end
								else
									case when SUM(LT26_total) <= 5
											then 0
										else WGT26_R12
									end
							end)
						, 10) as WGT
						,empl_size
						,SUM(Weeks_Paid_adjusted) as Weeks_Paid
				FROM #claim_summary cla
				GROUP BY claim,
						injdate,
						policyno,
						portfolio,
						empl_size,
						date26,
						CAP_CUR_26,
						CAP_PRE_26,
						WGT26,
						WGT26_R12,
						include26
						
				UNION ALL
				
				/* 52 weeks */
				SELECT	RTRIM(claim) as claim_no
						,measure = 52
						,injdate
						,policyno
						,portfolio
						,case when include52 = 1
								then
									ROUND(
										/* LT52_TOTAL */
										(case when SUM(LT52_total) <= 5
												then 0 
											else dbo.udf_MinValue(SUM(LT52_total),CAP_CUR_52)
										end)
										-
										/* LT52_PRIOR */
										(case when SUM(LT52_prior) <= 5
												then 0
											else dbo.udf_MinValue(SUM(LT52_prior),CAP_PRE_52)
										end)
										-
										(
											/* LT26_TOTAL */
											(case when SUM(LT26_total) <= 5
													then 0 
												else dbo.udf_MinValue(SUM(LT26_total),CAP_CUR_26)
											end)
											-
											/* LT26_PRIOR */
											(case when SUM(LT26_prior) <= 5
													then 0
												else dbo.udf_MinValue(SUM(LT26_prior),CAP_PRE_26)
											end)
										)
									, 10)
								else 0
						end as LT
						,ROUND(
							(case when @R <> 12
									then
										/* pick up previous weight if claim is dropped out in prior calculation because of the 5 days cutoff */
										case when SUM(LT52_total) > 5 AND SUM(LT52_prior) <= 5
												then WGT52
											else 
												case when SUM(LT52_total) <= 5
														then 0
													else WGT52_R12
												end
										end
								else
									case when SUM(LT52_total) <= 5
											then 0
										else WGT52_R12
									end
							end)
						, 10) as WGT
						,empl_size
						,SUM(Weeks_Paid_adjusted) as Weeks_Paid
				FROM #claim_summary cla
				GROUP BY claim,
						injdate,
						policyno,
						portfolio,
						empl_size,
						date52,
						CAP_CUR_26,
						CAP_PRE_26,
						CAP_CUR_52,
						CAP_PRE_52,
						WGT52,
						WGT52_R12,
						include52
						
				UNION ALL
				
				/* 78 weeks */
				SELECT	RTRIM(claim) as claim_no
						,measure = 78
						,injdate
						,policyno
						,portfolio
						,case when include78 = 1
								then
									ROUND(
										/* LT78_TOTAL */
										(case when SUM(LT78_total) <= 5
												then 0 
											else dbo.udf_MinValue(SUM(LT78_total),CAP_CUR_78)
										end)
										-
										/* LT78_PRIOR */
										(case when SUM(LT78_prior) <= 5
												then 0
											else dbo.udf_MinValue(SUM(LT78_prior),CAP_PRE_78)
										end)
										-
										(
											/* LT52_TOTAL */
											(case when SUM(LT52_total) <= 5
													then 0 
												else dbo.udf_MinValue(SUM(LT52_total),CAP_CUR_52)
											end)
											-
											/* LT52_PRIOR */
											(case when SUM(LT52_prior) <= 5
													then 0
												else dbo.udf_MinValue(SUM(LT52_prior),CAP_PRE_52)
											end)
										)
									, 10)
								else 0
						end as LT
						,ROUND(
							(case when @R <> 12
									then
										/* pick up previous weight if claim is dropped out in prior calculation because of the 5 days cutoff */
										case when SUM(LT78_total) > 5 AND SUM(LT78_prior) <= 5
												then WGT78
											else 
												case when SUM(LT78_total) <= 5
														then 0
													else WGT78_R12
												end
										end
								else
									case when SUM(LT78_total) <= 5
											then 0
										else WGT78_R12
									end
							end)
						, 10) as WGT
						,empl_size
						,SUM(Weeks_Paid_adjusted) as Weeks_Paid
				FROM #claim_summary
				GROUP BY claim,
						injdate,
						policyno,
						portfolio,
						empl_size,
						date78,
						CAP_CUR_52,
						CAP_PRE_52,
						CAP_CUR_78,
						CAP_PRE_78,
						WGT78,
						WGT78_R12,
						include78
						
				UNION ALL
				
				/* 104 weeks */
				SELECT	RTRIM(claim) as claim_no
						,measure = 104
						,injdate
						,policyno
						,portfolio
						,case when include104 = 1
								then
									ROUND(
										/* LT104_TOTAL */
										(case when SUM(LT104_total) <= 5
												then 0 
											else dbo.udf_MinValue(SUM(LT104_total),CAP_CUR_104)
										end)
										-
										/* LT104_PRIOR */
										(case when SUM(LT104_prior) <= 5
												then 0
											else dbo.udf_MinValue(SUM(LT104_prior),CAP_PRE_104)
										end)
										-
										(
											/* LT52_TOTAL */
											(case when SUM(LT52_total) <= 5
													then 0 
												else dbo.udf_MinValue(SUM(LT52_total),CAP_CUR_52)
											end)
											-
											/* LT52_PRIOR */
											(case when SUM(LT52_prior) <= 5
													then 0
												else dbo.udf_MinValue(SUM(LT52_prior),CAP_PRE_52)
											end)
										)
									, 10)
								else 0
						end as LT
						,ROUND(
							(case when @R <> 12
									then
										/* pick up previous weight if claim is dropped out in prior calculation because of the 5 days cutoff */
										case when SUM(LT104_total) > 5 AND SUM(LT104_prior) <= 5
												then WGT104
											else 
												case when SUM(LT104_total) <= 5
														then 0
													else WGT104_R12
												end
										end
								else
									case when SUM(LT104_total) <= 5
											then 0
										else WGT104_R12
									end
							end)
						, 10) as WGT
						,empl_size
						,SUM(Weeks_Paid_adjusted) as Weeks_Paid
				FROM #claim_summary cla
				GROUP BY claim,
						injdate,
						policyno,
						portfolio,
						empl_size,
						date104,
						CAP_CUR_52,
						CAP_PRE_52,
						CAP_CUR_104,
						CAP_PRE_104,
						WGT104,
						WGT104_R12,
						include104
					
				/* Drop unused temp table */
				IF OBJECT_ID('tempdb..#claim_summary') IS NOT NULL DROP TABLE #claim_summary
				
				/* init measure types table data */
				INSERT INTO #measure_types
				SELECT M_months = 3, M_weeks = 13
				UNION SELECT M_months = 6, M_weeks = 26
				UNION SELECT M_months = 12, M_weeks = 52
				UNION SELECT M_months = 18, M_weeks = 78
				UNION SELECT M_months = 24, M_weeks = 104
				
				WHILE EXISTS (SELECT M_months FROM #measure_types)
				BEGIN
					SELECT TOP 1 @M_months = M_months, @M_weeks = M_weeks FROM #measure_types
					
					SET @SQL = 'INSERT INTO [Dart].[dbo].[' + UPPER(@system) + '_RTW]
								SELECT  ''Remuneration_Start'' = ''' + CONVERT(varchar, @prd_start, 120) + '''
										,''Remuneration_End'' = ''' + CONVERT(varchar, @prd_end, 120) + '''
										,Measure_months = ' + CONVERT(varchar, @M_months) + '
										,Team = case when RTRIM(ISNULL(co.Grp, '''')) = ''''
														OR NOT EXISTS (select distinct grp
																			from claims_officers
																			where active = 1 and len(rtrim(ltrim(grp))) > 0
																				and grp like co.Grp + ''%'')
														then ''Miscellaneous''
													else RTRIM(UPPER(co.Grp))
												end
										,Case_manager = ISNULL(UPPER(co.First_Name + '' '' + co.Last_Name), ''Miscellaneous'')
										,cd.claim_no
										,cd.injdate
										,cd.policyno
										
										/* force LT to 0 if WGT = 0 */
										,LT = case when cd.WGT = 0 then 0 else cd.LT end
										
										,cd.WGT
										,cd.EMPL_SIZE
										,cd.Weeks_Paid
										,create_date = GETDATE()
										,Measure = ' + CONVERT(varchar, @M_weeks) + '
										,Cert_Type = case when mc.TYPE = ''P'' then ''No Time Lost''
														  when mc.TYPE = ''T'' then ''Totally Unfit''
														  when mc.TYPE = ''S'' then ''Suitable Duties''
														  when mc.TYPE = ''I'' then ''Pre-Injury Duties''
														  when mc.TYPE = ''M'' then ''Permanently Modified Duties''
														  else ''Invalid type''
													end
										,Med_cert_From = mc.Date_From
										,Med_cert_To = mc.Date_To
										,Account_Manager = isnull(acm.account_manager,''Miscellaneous'')'
										+ 
										case when UPPER(@system) = 'HEM'
												then ',cno.CELL_NO as Cell_no'
											else ',Cell_no = null'
										end
										+
										',Portfolio = cd.portfolio
										,Stress = case when cdd.MECHANISM_OF_INJURY in (81,82,84,85,86,87,88)
															or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then ''Y'' 
														else ''N''
													end
										,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
										,cost_code = (select top 1 name from cost_code where policy_no = cd.policyno and short_name = cdd.cost_code)
										,cost_code2=(select top 1 name from cost_code where policy_no = cd.policyno and short_name = cdd.cost_code2)
										,Claim_Closed_flag = cad.Claim_Closed_flag
								FROM #total_claim_summary cd
									INNER JOIN CLAIM_ACTIVITY_DETAIL cad ON cad.Claim_No = cd.claim_no
									INNER JOIN #data_clm_filtered cdd ON cad.Claim_No = cdd.claim
									LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
									LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
													FROM Medical_Cert) mc ON  mc.Claim_no = cd.claim_no
														AND mc.id = ISNULL((SELECT MAX(mc1.id)
																				FROM	Medical_Cert mc1
																				WHERE	mc1.Claim_no = mc.Claim_no
																						AND mc1.cancelled_date is null 
																						AND mc1.cancelled_by is null), '''')
									LEFT JOIN (SELECT U.First_Name + '' '' + U.SurName as account_manager, claim_number
													FROM CLAIM_DETAIL cld LEFT JOIN POLICY_TERM_DETAIL PTD ON cld.Policy_No = ptd.POLICY_NO
														LEFT JOIN Broker Br ON PTD.Broker_No = Br.Broker_no
														LEFT JOIN UnderWriters U ON  BR.emi_Contact = U.Alias
													WHERE U.is_Active =1 AND U.is_EMLContact = 1 ) as acm 
										ON acm.claim_number = cd.claim_no'
									+
									case when UPPER(@system) = 'HEM'
											then ' LEFT JOIN (SELECT CELL_NO, claim_number
																FROM CLAIM_DETAIL cld INNER JOIN POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
														ON cno.Claim_Number = cd.claim_no'
										else ''
									end
									+
								' WHERE cd.measure = ' + CONVERT(varchar, @M_weeks)
										
					EXEC(@SQL)
					
					DELETE FROM #measure_types WHERE M_months = @M_months
				END
						
				/* Drop unused temp tables */
				IF OBJECT_ID('tempdb..#data_clm_filtered') IS NOT NULL DROP TABLE #data_clm_filtered
				IF OBJECT_ID('tempdb..#total_claim_summary') IS NOT NULL DROP TABLE #total_claim_summary
				
				DELETE FROM #rolling_months WHERE R = @R
			END
		END
		
		DELETE FROM #check
		
		SET @i = @i - 1
	END
	
	/*** End: Output data ***/
	
	/*** Begin: Cleaning up ***/
	
	IF OBJECT_ID('tempdb..#data_clm') IS NOT NULL DROP TABLE #data_clm
	IF OBJECT_ID('tempdb..#data_policy') IS NOT NULL DROP table #data_policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL DROP table #activity_detail_audit
	IF OBJECT_ID('tempdb..#rtw_clean') IS NOT NULL DROP TABLE #rtw_clean
	IF OBJECT_ID('tempdb..#rolling_months') IS NOT NULL DROP TABLE #rolling_months
	IF OBJECT_ID('tempdb..#measure_types') IS NOT NULL DROP TABLE #measure_types
	IF OBJECT_ID('tempdb..#check') IS NOT NULL DROP TABLE #check
	
	/*** End: Cleaning up ***/
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_RTW_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_RTW_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_RTW_GenerateData] TO [DART_Role]
GO