--exec usp_Dashboard_Portfolio_GenerateData 'EML','2014-03-31 23:59'
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_Portfolio]    Script Date: 10/07/2015 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_Portfolio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_Portfolio]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_Portfolio]
	@System varchar(20),
	@AsAt datetime,
	@Is_Last_Month bit
AS
BEGIN
	SET NOCOUNT ON
	
	/* Drop all temp tables first */
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL DROP table #claim
	IF OBJECT_ID('tempdb..#WCA_EFFECTIVE') IS NOT NULL DROP table #WCA_EFFECTIVE
	IF OBJECT_ID('tempdb..#WEEKLY_PAYMENT_ALL') IS NOT NULL DROP table #WEEKLY_PAYMENT_ALL
	IF OBJECT_ID('tempdb..#_incap_date') IS NOT NULL DROP table #_incap_date
	IF OBJECT_ID('tempdb..#WEEKLY_PAYMENT_ALL_2') IS NOT NULL DROP table #WEEKLY_PAYMENT_ALL_2
	IF OBJECT_ID('tempdb..#WEEKLY_PAYMENT') IS NOT NULL DROP table #WEEKLY_PAYMENT
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP table #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP table #summary
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP table #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP table #rtw_raworig_2
	IF OBJECT_ID('tempdb..#CLAIM_DETAIL_PAY') IS NOT NULL DROP table #CLAIM_DETAIL_PAY
	IF OBJECT_ID('tempdb..#payment') IS NOT NULL DROP table #payment
	IF OBJECT_ID('tempdb..#estimate_details') IS NOT NULL DROP table #estimate_details
	
	DECLARE @Start_Date datetime
	DECLARE @Reporting_Date datetime
	SET @Reporting_Date = DATEADD(d, DATEDIFF(d, 0, @AsAt), 0) + '23:59'
	
	-- determine if this is generating data process for last month or not
	IF @Is_Last_Month = 1
	BEGIN
		SET @AsAt = DATEADD(m, DATEDIFF(m, 0, @AsAt), -1) + '23:59' -- get the end of last month as input parameter	
		SET @Start_Date = DATEADD(mm, DATEDIFF(mm,0,@AsAt), 0)
	END
	ELSE
	BEGIN
		SET @AsAt = DATEADD(d, DATEDIFF(d, 0, @AsAt), 0) + '23:59'
		SET @Start_Date = DATEADD(week,-2,DATEADD(d, DATEDIFF(d, 0, @AsAt), 0))
	END
	
	-- previous 1 week from @AsAt
	DECLARE @AsAt_Prev_1_Week datetime
	SET @AsAt_Prev_1_Week = DATEADD(WEEK, -1, @AsAt)
	
	-- previous 2 weeks from @AsAt
	DECLARE @AsAt_Prev_2_Week datetime
	SET @AsAt_Prev_2_Week = DATEADD(WEEK, -2, @AsAt)
	
	-- previous 3 weeks from @AsAt
	DECLARE @AsAt_Prev_3_Week datetime
	SET @AsAt_Prev_3_Week = DATEADD(WEEK, -3, @AsAt)
	
	-- previous 4 weeks from @AsAt
	DECLARE @AsAt_Prev_4_Week datetime
	SET @AsAt_Prev_4_Week = DATEADD(WEEK, -4, @AsAt)
	
	DECLARE @_curr_fiscal_yr datetime
	SET @_curr_fiscal_yr = case when MONTH(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) <= 6 
									then CAST(YEAR(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) AS varchar(5)) + '-06-30'
								else CAST(YEAR(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) +1 AS varchar(5)) + '-06-30'	  
							end
	
	DECLARE @SQL varchar(500)
	
	DECLARE @remuneration_start datetime
	DECLARE @remuneration_end datetime
	
	DECLARE @transaction_lag_remuneration_end datetime
	DECLARE @paystartdt datetime
	
	DECLARE @transaction_lag int
	SET @transaction_lag = 3
	
	DECLARE @RTW_start_date datetime
	SET @RTW_start_date = DATEADD(YY, -3, @AsAt)
	
	SET @remuneration_end = cast(CAST(YEAR(@AsAt) as varchar) + '/' +  CAST(MONTH(@AsAt) as varchar) + '/01' as datetime)
	SET @remuneration_start = DATEADD(mm,-3, @remuneration_end)
	SET @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'
	
	SET @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
	
	SET @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_start))
	
	/* THE ORIGINAL CLAIM LIST */
	
	IF OBJECT_ID('tempdb..#claim') IS NULL
	BEGIN
		/* The original claim list for output result. Make sure all of the calculations base on this claim list */
		CREATE TABLE #claim
		(
			claim CHAR(19)
			,hrswrkwk numeric(5,2)
			,Claim_Closed_Flag char(1)
			,Fund tinyint
			,Agency_id char(10)
			,Claims_Officer varchar(10)
			,is_exempt bit
			,ANZSIC varchar(4)
			,Policy_No char(19)
			,Renewal_No tinyint
			,Cost_Code char(16)
			,Cost_Code2 char(16)
			,Tariff_No int
			,Given_Names varchar(40)
			,Last_Names varchar(40)
			,Employee_no varchar(19)
			,Phone_no varchar(20)
			,Date_of_Birth datetime
			,Date_Notice_Given smalldatetime
			,Mechanism_of_Injury tinyint
			,Nature_of_Injury smallint
			,Employment_Terminated_Reason tinyint
			,Is_Medical_Only bit
			,date_of_injury datetime
			,Claim_Liability_Indicator tinyint
			,WPI numeric(5,2)
			,Work_Status_Code tinyint
			,Result_of_Injury_Code tinyint
			,date_claim_received datetime
			,date_claim_entered datetime
			,date_claim_closed datetime
			,date_claim_reopened datetime
			--,last_weekly_date datetime
		)	

		/* create index for #claim table */
		SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(claim)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #claim
			SELECT	cd.Claim_Number
					,cd.Work_Hours
					,cada.Claim_Closed_Flag
					,cd.Fund
					,ptda.Agency_id
					,cada.Claims_Officer
					,ade.is_exempt
					,cd.ANZSIC
					,cd.Policy_No
					,cd.Renewal_No
					,cd.Cost_Code
					,cd.Cost_Code2
					,cd.Tariff_No
					,cd.Given_Names
					,cd.Last_Names
					,cd.Employee_no
					,cd.Phone_no
					,cd.Date_of_Birth
					,cd.Date_Notice_Given
					,cd.Mechanism_of_Injury
					,cd.Nature_of_Injury
					,cd.Employment_Terminated_Reason
					,cd.Is_Medical_Only
					,cd.Date_of_Injury
					,cada.Claim_Liability_Indicator
					,cada.WPI
					,cada.Work_Status_Code
					,cda.Result_of_Injury_Code
					,cada.date_claim_received
					,cada.Date_Claim_Entered
					,cada.Date_Claim_Closed
					,cada.Date_Claim_reopened					
			FROM dbo.CLAIM_DETAIL cd
				LEFT JOIN amendment_exemptions ade on cd.Claim_Number = ade.claim_no
				LEFT JOIN ptd_audit ptda ON cd.Policy_No = ptda.Policy_No
					AND ptda.id = (SELECT MAX(ptda2.id)
									FROM ptd_audit ptda2
									WHERE ptda2.policy_no = ptda.policy_no
										AND ptda2.create_date <= @transaction_lag_remuneration_end)
				INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
					AND cda.id = (SELECT max(id)
									FROM cd_audit cda1 
									WHERE cda1.claim_no = cd.claim_number
										and cda1.create_date <= @AsAt)
					AND cda.fund not in (98, 99)
				INNER JOIN CAD_AUDIT cada on cada.claim_no = cd.Claim_Number
					AND cada.id = (SELECT MAX(id)
									FROM CAD_AUDIT cada1
									WHERE cada1.Claim_no = cada.Claim_no
										AND cada1.Transaction_Date <= @AsAt)
			WHERE	CD.is_Null = 0
					AND cada.Claim_Liability_Indicator <> 6
					AND ISNULL(cd.Claim_Number,'') <> ''
					AND (cada.Claim_Closed_Flag <> 'Y' OR cd.Last_Secure_Date >= DATEADD(YY, -1, DATEADD(d, DATEDIFF(d, 0, @AsAt), 0)))
	END
	
	/* BEGIN SECTION: WEEKLY_PAYMENT CALCULATION */
	
	IF OBJECT_ID('tempdb..#WCA_EFFECTIVE') IS NULL
	BEGIN
		/* Extract a partial claim list from the original claim list to determine Entitlement Weeks */
		CREATE TABLE #WCA_EFFECTIVE
		(
			claim varchar(19)
			,hrswrkwk numeric(5,2)
			,date_claim_received datetime
			,effective_date datetime
			,Agency_id char(10)
			,is_exempt bit
		)
		
		/* create index for #WCA_EFFECTIVE table */
		SET @SQL = 'CREATE INDEX pk_WCA_EFFECTIVE_' + CONVERT(VARCHAR, @@SPID) + ' ON #WCA_EFFECTIVE(claim)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		/* Find transition date to new calculation */
		INSERT INTO #WCA_EFFECTIVE
			SELECT cd.claim
					,cd.hrswrkwk
					,date_claim_received = case when cd.date_claim_received is null
													then cd.Date_Claim_Entered 
												else cd.date_claim_received
											end
											
					/* First effective date for transition to new calculation for accruing entitlement weeks */
					,effective_date = (SELECT MIN(EFFECTIVE_DATE)
											FROM WORK_CAPACITY_ASSESSMENT
											WHERE CLAIM_NO = cd.claim
												AND EFFECTIVE_DATE is not null)
					,cd.Agency_id
					,cd.is_exempt
				FROM #claim cd
				WHERE cd.Claim_Closed_Flag = 'N'	/* open claims only */
					AND cd.Fund in (2, 4)			/* post 1987 claims only */
	END
	
	IF OBJECT_ID('tempdb..#WEEKLY_PAYMENT_ALL') IS NULL
	BEGIN
		CREATE TABLE #WEEKLY_PAYMENT_ALL
		(
			 claim varchar(19)
			 ,payment_no int
			 ,trans_date datetime
			 ,ppstart datetime
			 ,ppend datetime
			 ,payamt money
			 ,wc_Hours smallint
			 ,wc_Minutes smallint
			 ,hours_per_week numeric(4,2)
			 ,wc_payment_type varchar(15)
			 ,date_claim_received datetime
			 ,Agency_id char(10)
			 ,is_exempt bit
			 ,effective_date datetime
			 ,weeks_paid_old float
			 ,incap_week_start datetime
			 ,incap_week_end datetime
			 ,incap_week_start_new datetime
			 ,incap_week_end_new datetime
			 ,trans_amount_prop money
			 ,calc_method char(3)
			 ,latest_paydate datetime
			 ,latest_paydate_prev datetime
		)

		/* create index for #WEEKLY_PAYMENT_ALL table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_ALL_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #WEEKLY_PAYMENT_ALL(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #WEEKLY_PAYMENT_ALL
		SELECT  pr.Claim_No
				,pr.Payment_no
				,Transaction_date
				,ppstart = case when wca_effect.effective_date > Period_Start_Date and effective_date <= Period_End_Date
									then wca_effect.effective_date
								else Period_Start_Date
							end
				,Period_End_Date
				,payamt = case when (Period_Start_Date is not null OR Period_End_Date is not null)
									AND wca_effect.effective_date > Period_Start_Date and effective_date <= Period_End_Date
									then (Trans_Amount * (DATEDIFF(DAY, wca_effect.effective_date, Period_End_Date) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
										+ (Trans_Amount * (DATEDIFF(DAY, Period_Start_Date, DATEADD(dd, -1, wca_effect.effective_date)) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
								else Trans_Amount
							end
				,wc_Hours = case when (Period_Start_Date is not null OR Period_End_Date is not null)
									AND wca_effect.effective_date > Period_Start_Date and effective_date <= Period_End_Date
									then (wc_Hours * (DATEDIFF(DAY, wca_effect.effective_date, Period_End_Date) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
										+ (wc_Hours * (DATEDIFF(DAY, Period_Start_Date, DATEADD(dd, -1, wca_effect.effective_date)) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
								else wc_Hours
							end
				,wc_Minutes = case when (Period_Start_Date is not null OR Period_End_Date is not null)
									AND wca_effect.effective_date > Period_Start_Date and effective_date <= Period_End_Date
									then (wc_Minutes * (DATEDIFF(DAY, wca_effect.effective_date, Period_End_Date) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
										+ (wc_Minutes * (DATEDIFF(DAY, Period_Start_Date, DATEADD(dd, -1, wca_effect.effective_date)) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
								else wc_Minutes
							end
				,hours_per_week = case when pr.hours_per_week < 1
											then wca_effect.hrswrkwk
										else pr.hours_per_week
									end
				,pr.WC_Payment_Type
				,wca_effect.date_claim_received
				,wca_effect.Agency_id
				,wca_effect.is_exempt
				,wca_effect.effective_date
				,weeks_paid_old = null
											
				/* NEW FORMULA */
				,incap_week_start = null
				,incap_week_end = null
				,incap_week_start_new = null
				,incap_week_end_new = null
				,trans_amount_prop = null
				,calc_method = null
				,latest_paydate = (SELECT MAX(Transaction_date)
										FROM dbo.Payment_Recovery pr1
										WHERE pr1.Claim_No = pr.Claim_No
											AND pr1.Transaction_date <= @AsAt
											AND wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
															,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
															,'13','14','15','16'))
				,latest_paydate_prev = null
		FROM dbo.Payment_Recovery pr
				INNER JOIN #WCA_EFFECTIVE wca_effect on pr.Claim_No = wca_effect.claim
		WHERE	Transaction_date <= @AsAt
				AND wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
								,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
								,'13','14','15','16')
				
				/* Data Cleansing 1: remove reversed claims */
				AND ABS(Trans_Amount) > 1
	END
	
	/* Drop unused temp table: #WCA_EFFECTIVE */
	IF OBJECT_ID('tempdb..#WCA_EFFECTIVE') IS NOT NULL DROP table #WCA_EFFECTIVE
	
	IF OBJECT_ID('tempdb..#_incap_date') IS NULL
	BEGIN
		CREATE TABLE #_incap_date
		(
			claim varchar(19),
			incapacity_date datetime
		)
		
		/* create index for #_incap_date table */
		SET @SQL = 'CREATE INDEX pk_incap_date_' + CONVERT(VARCHAR, @@SPID)
			+ ' ON #_incap_date(claim)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		/* Get incapacity date for new calculations */
		INSERT INTO #_incap_date
		SELECT	claim, incapacity_date = MIN(ppstart)
			FROM #WEEKLY_PAYMENT_ALL
			WHERE date_claim_received >= '2012-10-01'
			GROUP BY claim
			
		/* Get incapacity date for old calculations */
		INSERT INTO #_incap_date
		SELECT	claim, incapacity_date = MIN(ppstart)
			FROM #WEEKLY_PAYMENT_ALL
			WHERE wc_payment_type in ('WPT005','WPT006','WPT007','WPP005','WPP006','WPP007','WPP008')
				AND payamt > 0
				AND ppstart >= effective_date
				AND date_claim_received < '2012-10-01'
			GROUP BY claim
	END
	
	IF OBJECT_ID('tempdb..#WEEKLY_PAYMENT_ALL_2') IS NULL
	BEGIN
		CREATE TABLE #WEEKLY_PAYMENT_ALL_2
		(
			 claim varchar(19)
			 ,payment_no int
			 ,trans_date datetime
			 ,ppstart datetime
			 ,ppend datetime
			 ,payamt money
			 ,wc_Hours smallint
			 ,wc_Minutes smallint
			 ,hours_per_week numeric(4,2)
			 ,wc_payment_type varchar(15)
			 ,date_claim_received datetime
			 ,Agency_id char(10)
			 ,is_exempt bit
			 ,effective_date datetime
			 ,weeks_paid_old float
			 ,incap_week_start datetime
			 ,incap_week_end datetime
			 ,incap_week_start_new datetime
			 ,incap_week_end_new datetime
			 ,trans_amount_prop money
			 ,calc_method char(3)
			 ,latest_paydate datetime
			 ,latest_paydate_prev datetime
			 ,incapacity_date datetime
		)

		/* create index for #WEEKLY_PAYMENT_ALL_2 table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_ALL_2_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #WEEKLY_PAYMENT_ALL_2(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		/* For new calculations */
		INSERT INTO #WEEKLY_PAYMENT_ALL_2
		SELECT	wpa.claim
				,payment_no
				,trans_date = (SELECT MAX(trans_date)
									FROM #WEEKLY_PAYMENT_ALL wpa1
									WHERE	wpa1.claim = wpa.claim
											and wpa1.ppstart = wpa.ppstart
											and wpa1.ppend = wpa.ppend)
				,ppstart
				,ppend
				,payamt = (SELECT SUM(ISNULL(payamt,0))
								FROM #WEEKLY_PAYMENT_ALL wpa1
								WHERE	wpa1.claim = wpa.claim
										and wpa1.ppstart = wpa.ppstart
										and wpa1.ppend = wpa.ppend)
				,wc_Hours = (SELECT SUM(ISNULL(wc_Hours,0))
								FROM #WEEKLY_PAYMENT_ALL wpa1
								WHERE	wpa1.claim = wpa.claim
										and wpa1.ppstart = wpa.ppstart
										and wpa1.ppend = wpa.ppend)
				,wc_Minutes = (SELECT SUM(ISNULL(wc_Minutes,0))
									FROM #WEEKLY_PAYMENT_ALL wpa1
									WHERE	wpa1.claim = wpa.claim
											and wpa1.ppstart = wpa.ppstart
											and wpa1.ppend = wpa.ppend)
				,hours_per_week
				,wc_payment_type = (SELECT TOP 1 wc_payment_type
										FROM #WEEKLY_PAYMENT_ALL wpa1
										WHERE	wpa1.claim = wpa.claim
												and wpa1.ppstart = wpa.ppstart
												and wpa1.ppend = wpa.ppend)
				,date_claim_received
				,Agency_id
				,is_exempt
				,effective_date
				,weeks_paid_old
				,incap_week_start
				,incap_week_end
				,incap_week_start_new
				,incap_week_end_new
				,trans_amount_prop
				,calc_method
				,latest_paydate
				,latest_paydate_prev
				,incap.incapacity_date
			FROM #WEEKLY_PAYMENT_ALL wpa LEFT JOIN #_incap_date incap ON incap.claim = wpa.claim
			WHERE date_claim_received >= '2012-10-01'
			GROUP BY wpa.claim
					,payment_no
					,ppstart 
					,ppend
					,hours_per_week
					,date_claim_received
					,Agency_id
					,is_exempt
					,effective_date
					,weeks_paid_old
					,incap_week_start
					,incap_week_end
					,incap_week_start_new
					,incap_week_end_new
					,trans_amount_prop
					,calc_method
					,latest_paydate
					,latest_paydate_prev
					,incap.incapacity_date
		
		/* Records belong to new calculations with payment amount or hours paid equal to zero are removed */
		DELETE FROM #WEEKLY_PAYMENT_ALL_2 WHERE payamt = 0 or wc_Hours = 0
		
		/* For old calculations */
		INSERT INTO #WEEKLY_PAYMENT_ALL_2
		SELECT wpa.*, incap.incapacity_date
			FROM #WEEKLY_PAYMENT_ALL wpa LEFT JOIN #_incap_date incap ON incap.claim = wpa.claim
			WHERE date_claim_received < '2012-10-01'
			
		/* Drop unused temp tables: #WEEKLY_PAYMENT_ALL, #_incap_date */
		IF OBJECT_ID('tempdb..#WEEKLY_PAYMENT_ALL') IS NOT NULL DROP table #WEEKLY_PAYMENT_ALL
		IF OBJECT_ID('tempdb..#_incap_date') IS NOT NULL DROP table #_incap_date
			
		UPDATE #WEEKLY_PAYMENT_ALL_2
			SET calc_method =
					/* for exempted emergency services claims, old method is used */
					case when UPPER(@System) = 'TMF' and Agency_id in ('10250', '10255', '10355', '10405') and is_exempt = 1
							then 'OLD'
						/* for new claims, new method is applied from the first period start date of a correct positive new payment */
						when date_claim_received >= '2012-10-01'
							then
								case when ppstart >= incapacity_date
										then 'NEW'
									else 'OLD'
								end
						else 
							/* for existing recepients, new method is applied from the latter of effective date and first correct new code */
							case when effective_date is null
									then 'OLD'
								when ppstart >= incapacity_date
									then 'NEW'
								else 'OLD'
							end
					end
			
		/* OLD FORMULA */
		
		UPDATE #WEEKLY_PAYMENT_ALL_2 SET weeks_paid_old = ISNULL((ISNULL(wc_Hours, 0) + ISNULL(wc_Minutes, 0)/60)
										/ (case when hours_per_week < 1
													then 37.5
												else hours_per_week
											end), 0)
			WHERE calc_method = 'OLD'
		
		/* NEW FORMULA */
		
		/* align payments into incapacity weeks */
		UPDATE #WEEKLY_PAYMENT_ALL_2
			SET incap_week_start = case when ppstart is not null
											then
												case when datepart(dw,incapacity_date) > datepart(dw,ppstart)
													then dateadd(wk, -1, dateadd(dd, -(datepart(dw, ppstart)-1), ppstart))
															+ datepart(dw,incapacity_date) - 1
													else dateadd(dd, -(datepart(dw, ppstart)-1), ppstart)
															+ datepart(dw,incapacity_date) - 1
												end
										else null
									end
				,incap_week_end = case when ppend is not null
											then
												case when datepart(dw,incapacity_date) > datepart(dw,ppend)
														then dateadd(dd, -(datepart(dw, ppend)-1), ppend)
																+ datepart(dw,incapacity_date) - 2
													else dateadd(wk, 1, dateadd(dd, -(datepart(dw, ppend)-1), ppend)) 
															+ datepart(dw,incapacity_date) - 2
												end
										else null
									end
			WHERE calc_method = 'NEW'
				AND incapacity_date is not null
				AND wc_payment_type in ('WPT005','WPT006','WPT007','WPP005','WPP006','WPP007','WPP008')
		
		/* break down payments into incapacity weeks */
		UPDATE #WEEKLY_PAYMENT_ALL_2
			SET incap_week_start_new = incap_week_start + 7 * dbo.udf_GetIncapWeekForEntitlement(incap_week_start, incap_week_end)
				,incap_week_end_new = incap_week_start + 7 * dbo.udf_GetIncapWeekForEntitlement(incap_week_start, incap_week_end) + 6
			WHERE calc_method = 'NEW'
				AND dbo.udf_GetIncapWeekForEntitlement(incap_week_start, incap_week_end) <> -1
			
		/* determine the payment date before the latest payment date */
		UPDATE #WEEKLY_PAYMENT_ALL_2
			SET latest_paydate_prev = (SELECT MAX(Transaction_date)
											FROM dbo.Payment_Recovery pr1
											WHERE pr1.Claim_No = claim
												AND pr1.Transaction_date < latest_paydate
												AND wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
																,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
																,'13','14','15','16'))
				,trans_amount_prop = (DATEDIFF(DAY, dbo.udf_MaxDay(ppstart,incap_week_start_new,'1900/01/01'), 
					dbo.udf_MinDay(ppend, incap_week_end_new, '2222/01/01')) + 1)/((DATEDIFF(DAY, ppstart, ppend) + 1) * 1.0) * payamt
			WHERE calc_method = 'NEW'
	END
	
	IF OBJECT_ID('tempdb..#WEEKLY_PAYMENT') IS NULL
	BEGIN
		CREATE TABLE #WEEKLY_PAYMENT
		(
			 claim varchar(19)
			 ,payment_no int
			 ,incapacity_start datetime
			 ,incapacity_end datetime
			 ,weeks_paid_old float
			 ,weeks_paid_new float
		)

		/* create index for #WEEKLY_PAYMENT table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #WEEKLY_PAYMENT(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #WEEKLY_PAYMENT
		SELECT  claim
				,payment_no
				,case when calc_method = 'OLD'
						then ppstart
					else incap_week_start_new
				end
				,case when calc_method = 'OLD'
						then ppend
					else incap_week_end_new
				end
				,case when calc_method = 'OLD'
						then weeks_paid_old
					else 0
				end
				,case when calc_method = 'NEW'
						then 1
					else 0
				end
		FROM #WEEKLY_PAYMENT_ALL_2
		WHERE calc_method = 'OLD'
			
			/* Data Cleansing 2: remove negative adjustments */
			OR (calc_method = 'NEW' AND trans_amount_prop > 1)
	END
	
	/* END SECTION: WEEKLY_PAYMENT CALCULATION */
	
	/* BEGIN SECTION: CLAIM_DETAIL_PAY CALCULATION */
	
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NULL
	BEGIN
		/* create #rtw_raworig temp table to store transaction data */
		CREATE TABLE #rtw_raworig_temp
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)			 
			 ,payamt money
			 ,payment_no int
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)

		/* create index for #rtw_raworig_temp table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_temp_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_temp(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #rtw_raworig_temp
		SELECT  pr.Claim_No
				, CONVERT(varchar(10), pr.Transaction_date, 120)
				,pr.WC_Payment_Type
				,rtw_paytype=  (CASE WHEN wc_payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004') 
										THEN 'TI'
									 WHEN wc_payment_type IN ('13', 'WPP001', 'WPP003') 
										THEN 'S38'
									 WHEN wc_payment_type IN ('16', 'WPP002', 'WPP004') 
										THEN 'S40'
									 WHEN wc_payment_type IN ('WPT005', 'WPT006', 'WPT007') 
										THEN 'NOWORKCAP'
									 WHEN wc_payment_type IN ('WPP005', 'WPP006', 'WPP007', 'WPP008') 
										THEN 'WORKCAP' 
								END)
				,Trans_Amount
				,pr.Payment_no
				,Period_Start_Date
				,Period_End_Date
				,pr.hours_per_week
				,hrs_total = (isnull(WC_MINUTES, 0) / 60.0)
								 + isnull(WC_HOURS, 0)
								 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
				,isnull(Rate, 0)
		FROM dbo.Payment_Recovery pr
				INNER JOIN dbo.CLAIM_PAYMENT_RUN
						   ON pr.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
				INNER JOIN #claim cl on pr.Claim_No = cl.claim
		WHERE	Transaction_date >= @paystartdt
				AND cl.Date_of_Injury >= @paystartdt
				AND Transaction_date <= @AsAt
				AND Adjust_Trans_Flag = 'N'
				AND wc_Tape_Month IS NOT NULL
				AND LEFT(wc_Tape_Month, 4) <= YEAR(@AsAt)
				AND wc_Tape_Month <= CONVERT(int, CONVERT(varchar(8), @transaction_lag_remuneration_end,112))
				AND wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
										,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
										,'13','14','15','16')
										 
		/* Adjust DET weekly field */
		IF OBJECT_ID('tempdb..#summary') IS NULL
		BEGIN
			CREATE TABLE #summary
			(
				 claim varchar(19)
				 ,ppstart datetime
				 ,ppend datetime			 
				 ,paytype varchar(15)			 		 
				 ,DET_weekly money
			)
		END
		
		INSERT INTO #summary
		SELECT distinct claim, ppstart, ppend, paytype, DET_weekly = max(DET_weekly)
			FROM #rtw_raworig_temp
		GROUP BY claim,
				ppstart,
				ppend,
				paytype

		UPDATE #rtw_raworig_temp 
			SET DET_weekly = su.DET_weekly
			FROM #summary su
			WHERE	#rtw_raworig_temp.claim = su.claim
					AND #rtw_raworig_temp.ppstart = su.ppstart
					AND #rtw_raworig_temp.ppend = su.ppend
					AND #rtw_raworig_temp.paytype = su.paytype
		
		/* end of adjusting DET weekly field */
		
		/* Drop unused temp table: #summary */
		IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP table #summary
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NULL
	BEGIN
		/* create #rtw_raworig table to store transaction data after summarizing step #1 */
		CREATE TABLE #rtw_raworig
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised trasactions by claim, paydate, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig
		SELECT  claim
				,paydate
				,paytype
				,rtw_paytype
				,payamt = (SELECT SUM(ISNULL(payamt,0))
								FROM #rtw_raworig_temp rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(ISNULL(hrs_total,0))
								FROM #rtw_raworig_temp rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig_temp rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig_temp rtw
		GROUP BY claim,
				paydate,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
		
		/* Drop unused temp table: #rtw_raworig_temp */
		IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP table #rtw_raworig_temp
				
		/* Records with payment amount and hours paid for total incapacity are both zero are removed */
		DELETE FROM #rtw_raworig WHERE hrs_total = 0 and payamt = 0
		
		/* Records with a negative payment amount, but positive hours paid for total incapacity
				have their hours paid changed to be negative. */
		UPDATE #rtw_raworig SET hrs_total = -hrs_total
			WHERE hrs_total > 0 AND payamt < 0
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NULL
	BEGIN
		/* create #rtw_raworig_2 table to store transaction data after summarizing for step #2 */
		CREATE TABLE #rtw_raworig_2
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig_2 table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_2_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_2(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised transactions by claim, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig_2
		SELECT  claim
				,paydate = (SELECT MIN(paydate) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim										
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,rtw_paytype
				,payamt = (SELECT SUM(ISNULL(payamt,0))
								FROM #rtw_raworig rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(ISNULL(hrs_total,0))
								FROM #rtw_raworig rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig rtw
		GROUP BY claim,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
			
		/* Drop unused temp table: #rtw_raworig */
		IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP table #rtw_raworig
				
		/*
		- Records with payment amount equal to zero are removed;
		- Records associated with payments of pre-reform benefits (s36, s37, s38, s40) with hours
		paid for partial incapacity and hours paid for total incapacity both equal to zero are
		removed; */
		DELETE FROM #rtw_raworig_2 WHERE payamt = 0 or (hrs_total = 0 
			and rtw_paytype in ('TI', 'S38', 'S40'))
	END
	
	/* create #CLAIM_DETAIL_PAY table that */
	CREATE TABLE #CLAIM_DETAIL_PAY
	(
		claim CHAR(19)
		,paytype varchar(9)
		,payamt money
		,hrs_per_week_adjusted numeric(5,2)
		,days_for_TI int
		,LT_TI float
		,LT_S38 float
		,LT_S40 float
		,LT_NWC float
		,LT_WC float
	)
	
	INSERT INTO #CLAIM_DETAIL_PAY
	SELECT DISTINCT 
			pr.Claim
			,pr.rtw_paytype
			,pr.payamt
			
			-- adjust hours worked per week to be a minimum of 1 and a maximum of 40;
			,hrs_per_week_adjusted = dbo.udf_MinValue(40
											  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0
														then cd.hrswrkwk 
													 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
														then 1  
													 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
												end)
											  )
			
			-- calculate total incapacity days off work
			,days_for_TI = (case when rtw_paytype = 'TI'
										and datepart(dw,pr.ppstart) IN (1,7)
										and datepart(dw,pr.ppend) IN(1,7) 
										and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
									then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
								when pr.ppstart = pr.ppend 
									then 1 
								else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
							end)
						
			-- calculate days off work for pre-reform claims - Total incapacity payment
			,LT_TI = (CASE when	rtw_paytype = 'TI'
								and dbo.udf_MinValue(40 
												   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															 then cd.hrswrkwk 
														  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1
															 then 1 
														  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													 end
													 )
													) >= 35 
								then 1.0 
									 * (pr.hrs_total* 5)
									 / nullif(dbo.udf_MinValue(40
													   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ),0) 
									* dbo.udf_CheckPositiveOrNegative(pr.payamt)
						 when rtw_paytype = 'TI' 
							  and dbo.udf_MinValue(40 
												  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk
														when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1  
														else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													end)
												 ) < 35 
							then 1.0 
								 * (pr.hrs_total * 5 /37.5)
								 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
						else 0 
					END)
					
			-- calculate days off work for pre-reform claims - Section 38 payment
			,LT_S38 = (CASE when rtw_paytype = 'S38'
								 and (case when pr.ppstart = pr.ppend 
												then 1 
										   else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									 end) = 0 
								then 0
							when rtw_paytype = 'S38' 
								 and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													 ) >= 35 
								then 1.0 * (case when pr.ppstart = pr.ppend
													then 1
												else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
											end)
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
							when rtw_paytype = 'S38'
								 and dbo.udf_MinValue(40
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35  
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													) > 0 
								then 1.0 * (case when pr.ppstart = pr.ppend
													then 1
												else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
											end)
									  * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									  * dbo.udf_MinValue(40
												 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk 
														when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1
														else isnull(cd.hrswrkwk,pr.hrs_per_week)
													end)
												 )
									  /37.5
										
							else 0
					END)
					
			-- calculate days off work for pre-reform claims - Section 40 payment
			,LT_S40 = (CASE when rtw_paytype = 'S40'
								and (case when pr.ppstart = pr.ppend 
												then 1 
										  else
												dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									end) = 0 
								then 0
							when rtw_paytype = 'S40'
								 and dbo.udf_MinValue(40
													  , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
												      ) >= 35 
								then 1.0 * (case when pr.ppstart = pr.ppend
													then 1
												else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
											end)
									 * 0.75
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
							when rtw_paytype = 'S40' 
								 and dbo.udf_MinValue(40
											 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
														then cd.hrswrkwk 
													 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
														then 1  
													 else isnull(cd.hrswrkwk,pr.hrs_per_week) end)
												) < 35
								then 1.0 * (case when pr.ppstart = pr.ppend
													then 1
												else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
											end)
									   * 0.75 
									   * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									   * dbo.udf_MinValue(40
												  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk 
														  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1  
														  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													 end)
													)
										/37.5
								else 0
						END)
						
			-- calculate days off work for post reform claims - no current work capacity
			,LT_NWC = (CASE when rtw_paytype = 'NOWORKCAP' 
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													  end)
													  ) >= 35 
								then 1.0 * (pr.payamt* 5)/ nullif(pr.DET_weekly,0)
							when rtw_paytype = 'NOWORKCAP' 
								 and dbo.udf_MinValue(40 
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35 
								then 1.0 
									 * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									 * 5
									 *dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														  end)
														  )
								else 0 
						END)
						
			-- calculate days off work for post reform claims - current work capacity
			,LT_WC = (CASE when rtw_paytype = 'WORKCAP'
								  and dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1 
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														 end)
														) >= 35 
								 then 1.0 * (pr.payamt* 5) / nullif(pr.DET_weekly,0)
							  when rtw_paytype = 'WORKCAP' 
								  and dbo.udf_MinValue(40 
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ) < 35 
								 then 1.0 
									  * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									  * 5
									  *dbo.udf_MinValue(40
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
																else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															end)
														   )
							  else 0 
						END)
	FROM #claim cd INNER JOIN #rtw_raworig_2 pr ON cd.Claim = pr.Claim
	WHERE cd.Date_of_Injury >= @paystartdt
	
	/* Drop unused temp table: #rtw_raworig_2 */
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP table #rtw_raworig_2
	
	/* delete small transactions */

	/* small transactions with $2 per day for S40 and WC payments */
	DELETE FROM #CLAIM_DETAIL_PAY WHERE (CASE WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted >= 35 
											AND (1.0 * payamt / nullif(days_for_TI,0)) < 2 
										THEN 1
									 WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted < 35 
											AND (1.0 * payamt / nullif(((days_for_TI*hrs_per_week_adjusted)/37.5),0)) < 2 
										THEN 1 
									 WHEN paytype in ('S40') AND days_for_TI = 0 
											AND LT_S40 <> 0 AND (1.0 * payamt / nullif(LT_S40,0)) < 2  
										THEN 1
									 WHEN paytype in ('WORKCAP') AND LT_WC <> 0 AND (1.0 * payamt / nullif(LT_WC,0)) < 2 
										THEN 1
									 ELSE 0
								  END = 1)

	/* other small transactions with payment amount < $20 per day */
	DELETE FROM #CLAIM_DETAIL_PAY WHERE (CASE WHEN  paytype in ('S38','TI','NOWORKCAP') 
										    and (LT_TI + LT_S38 + LT_NWC) <> 0 
										    and (1.0 * payamt / nullif((LT_TI + LT_S38 + LT_NWC),0)) < 20 
										  THEN 1
									  ELSE 0
								 END = 1)
	/* end delete small transactions */
	
	/* END SECTION: CLAIM_DETAIL_PAY CALCULATION */
	
	IF OBJECT_ID('tempdb..#payment') IS NULL
	BEGIN
		CREATE TABLE #payment
		(
			claim char(19)
			,trans_amount float
			,transaction_dte datetime
			,total_paid float
			,payment_type varchar(15)
			,estimate_type char(2)
		)		

		INSERT INTO #payment
		SELECT	Claim_No
				,Trans_Amount
				,Transaction_date
				,total_paid = ISNULL(Trans_Amount,0) -
								ISNULL(itc,0) -
								ISNULL(dam,0)
				,Payment_Type
				,Estimate_type
		FROM	Payment_Recovery pr
				INNER JOIN #claim cd ON pr.Claim_No = cd.claim
		WHERE	Transaction_date <= @AsAt
	END
	
	IF OBJECT_ID('tempdb..#estimate_details') IS NULL
	BEGIN
		CREATE TABLE #estimate_details
		(
			claim char(19)
			,amount money
			,estimate_type char(2)
		)		

		INSERT INTO #estimate_details
		SELECT	Claim_No
				,Amount
				,[Type]
		FROM	ESTIMATE_DETAILS ed
				INNER JOIN #claim cd ON ed.Claim_No = cd.claim
	END
	
	/* Output data */
	SELECT	Team = case when RTRIM(ISNULL(co.Grp, '')) = '' then 'Miscellaneous' else RTRIM(UPPER(co.Grp)) end			
			,Case_Manager = ISNULL(UPPER(co.First_Name + ' ' + co.Last_Name), 'Miscellaneous')
			,Policy_No = cd.policy_no
			,EMPL_SIZE = (case when pd.BTP IS NULL OR pd.Process_Flags IS NULL OR pd.WAGES0 IS NULL then 'A - Small'
							  when pd.WAGES0 <= 300000 then 'A - Small'
							  when pd.WAGES0 > 300000 AND pd.WAGES0 <= 1000000 AND pd.Process_Flags = 1 then 'A - Small'
							  when pd.WAGES0 > 300000 AND pd.WAGES0 <= 1000000 AND pd.Process_Flags <> 1 then 'B - Small-Medium'
							  when pd.WAGES0 > 1000000 AND pd.WAGES0 <= 5000000 then 'C - Medium'
							  when pd.WAGES0 > 5000000 AND pd.WAGES0 <= 15000000 AND pd.BTP <= 100000 then 'C - Medium'
							  when pd.WAGES0 > 15000000 then 'D - Large'
							  when pd.WAGES0 > 5000000 AND pd.BTP > 100000 then 'D - Large'
							  else 'A - Small'
						  end)
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			
			-- retrieve portfolio info
			,Portfolio = case when ISNULL(anz.DESCRIPTION,'')<>''
								then
									case when UPPER(anz.DESCRIPTION) = 'ACCOMMODATION' 
											or UPPER(anz.DESCRIPTION) = 'PUBS, TAVERNS AND BARS'
											or UPPER(anz.DESCRIPTION) = 'CLUBS (HOSPITALITY)' then anz.DESCRIPTION
										else 'Other'
									end
								else
									case when LEFT(ada.Tariff, 1) = '1' and LEN(ada.Tariff) = 7
											then 
												case when SUBSTRING(CAST(ada.Tariff as CHAR(7)), 2, 6) = '571000'
													then 'Accommodation'
												when SUBSTRING(CAST(ada.Tariff as CHAR(7)), 2, 6) = '572000'
													then 'Pubs, Taverns and Bars'
												when SUBSTRING(CAST(ada.Tariff as CHAR(7)), 2, 6) = '574000'
													then 'Clubs (Hospitality)'
												else 'Other'
											end
										else 
											case when ada.Tariff = 571000 then 'Accommodation'
												when ada.Tariff = 572000 then 'Pubs, Taverns and Bars'
												when ada.Tariff = 574000 then 'Clubs (Hospitality)'
												else 'Other'
											end
									end
							end
			,Reporting_Date = @Reporting_Date
			,Claim_No = cd.claim
			,WIC_Code = cd.Tariff_No
			,Company_Name = ISNULL(ptd.LEGAL_NAME,cd.policy_no)
			,Worker_Name = cd.Given_Names + ', ' + cd.Last_Names
			,Employee_Number = cd.Employee_no
			,Worker_Phone_Number = cd.Phone_no
			,Claims_Officer_Name = co.First_Name + ' ' + co.Last_Name
			,Date_of_Birth = cd.Date_of_Birth
			,Date_of_Injury = cd.Date_of_Injury
			,Date_Of_Notification = ISNULL(cd.date_claim_received,cd.date_claim_entered)
			,Notification_Lag = case when cd.Date_of_Injury IS NULL then -1
									 else
										(case when ISNULL(DATEDIFF(day,cd.Date_of_Injury, cd.Date_Notice_Given), 0) < 0
												then 0
											else ISNULL(DATEDIFF(day,cd.Date_of_Injury, cd.Date_Notice_Given), 0)
										end)
								end
			,Entered_Lag = DATEDIFF(day,cd.date_claim_received, cd.date_claim_entered)
			,Claim_Liability_Indicator_Group = dbo.udf_GetLiabilityStatusById(cd.Claim_Liability_Indicator)
			,Investigation_Incurred = ISNULL(t13.invest_incurred,0)
			,Total_Paid = ISNULL(t1.total_paid,0)
			,Is_Time_Lost = cdba.is_Time_Lost
			,Claim_Closed_Flag = cd.Claim_Closed_Flag
			,Date_Claim_Entered = cd.Date_Claim_Entered
			,Date_Claim_Closed = cd.Date_Claim_Closed
			,Date_Claim_Received = cd.date_claim_received
			,Date_Claim_Reopened = cd.Date_Claim_reopened
			,Result_Of_Injury_Code = cd.Result_of_Injury_Code
			,WPI = cd.WPI
			,Common_Law = case when	ISNULL(t14.common_law,0) > 0
									then 1
								else 0
							end
			,Total_Recoveries = ISNULL(t2.total_recoveries_1,0) + ISNULL(t3.total_recoveries_2,0)
			,Is_Working = 	case when cd.Work_Status_Code in (1,2,3,4,14) then 1
								 when cd.Work_Status_Code in (5,6,7,8,9) then 0
							end
			,Physio_Paid = ISNULL(t4.physio_paid,0)
			,Chiro_Paid = ISNULL(t5.chiro_paid,0)			
			,Massage_Paid = ISNULL(t6.massage_paid,0)				
			,Osteopathy_Paid = ISNULL(t7.osteopathy_paid,0)
			,Acupuncture_Paid = ISNULL(t8.acupuncture_paid,0)
			,Create_Date = getdate()
			,Is_Stress = case when cd.Mechanism_of_Injury in (81,82,84,85,86,87,88)
								OR cd.Nature_of_Injury in (910,702,703,704,705,706,707,718,719)
								then 1
							else 0
						  end
			,Is_Inactive_Claims = case when	ISNULL(t9.total_paid_last_3m,0) = 0
											then 1
										else 0
									end
			,Is_Medically_Discharged = case when cd.Employment_Terminated_Reason = 2 then 1
											else 0
									   end
			,Is_Exempt = cd.is_exempt
			,Is_Reactive = case when t15.claim is not null
									then 1
								else 0
							end
			,Is_Medical_Only = cd.Is_Medical_Only
			,Is_D_D = case when cd.Employment_Terminated_Reason = 2
								then 1
							else 0
						end
			,NCMM_Actions_This_Week = dbo.udf_GetNCMMActionsThisWeek(dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt))
			,NCMM_Actions_Next_Week = dbo.udf_GetNCMMActionsNextWeek(dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt))
			,HoursPerWeek = ISNULL(tld.Deemed_HoursPerWeek, 0)
			,Is_Industrial_Deafness = case when cd.Nature_of_Injury in (152,250,312,389,771)
												then 1
											else 0
										end
			,Rehab_Paid = ISNULL(t10.rehab_paid,0)
			,Action_Required = case when dbo.udf_GetNCMMActionsThisWeek(dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt)) <> ''
										or dbo.udf_GetNCMMActionsNextWeek(dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt)) <> ''
										then 'Y'
									else 'N'
							   end
			,RTW_Impacting = case when measure.LT > 5 and cd.Date_of_Injury between @RTW_start_date and @AsAt
									then 'Y'
								else 'N'
							end
			,Weeks_In = dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt)
			,Weeks_Band = case when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 0 and 12 then 'A.0-12 WK'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 13 and 18 then 'B.13-18 WK'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 19 and 22 then 'C.19-22 WK'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 23 and 26 then 'D.23-26 WK'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 27 and 34 then 'E.27-34 WK'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 35 and 48 then 'F.35-48 WK'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 49 and 52 then 'G.48-52 WK'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 53 and 60 then 'H.53-60 WK'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 61 and 76 then 'I.61-76 WK'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 77 and 90 then 'J.77-90 WK'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 91 and 100 then 'K.91-100 WK'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 101 and 117 then 'L.101-117 WK'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) between 118 and 130 then 'M.117 - 130 WKS'
							   when dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt) > 130 then 'N.130+ WKS'
						  end
			,Hindsight = case when cd.Date_of_Injury > DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-36,@_curr_fiscal_yr)) + 1, 0))
								 and  cd.Date_of_Injury <= DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-24,@_curr_fiscal_yr)) + 1, 0)) 
								 then '3 years'
							  when cd.Date_of_Injury > DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-60,@_curr_fiscal_yr)) + 1, 0))
								 and  cd.Date_of_Injury <= DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-48,@_curr_fiscal_yr)) + 1, 0)) 
								 then '5 years'
							  else ''
						 end
			,Active_Weekly = case when ISNULL(t11.total_active_weekly,0) <> 0
										then 'Y'
								  else 'N'
							 end
			,Active_Medical = case when ISNULL(t12.total_active_medical,0) <> 0
										then 'Y'
								  else 'N'
							 end
			,Cost_Code = cd.Cost_Code
			,Cost_Code2 = cd.Cost_Code2
			,CC_Injury = t16.Name
			,CC_Current = ISNULL(t17.Name, t16.Name)
			,Med_Cert_Status_This_Week = dbo.udf_ExtractMedCertStatus_Code(mc_this_week.[Type])
			,Capacity = case when tld.RTW_Goal = 2 then 'Partial Capacity'
							when tld.RTW_Goal = 3 then 'Full Capacity'
							else 'No Capacity'
					   end
			,Entitlement_Weeks = ISNULL(t18.entitlement_weeks,0)
			,Med_Cert_Status_Prev_1_Week = dbo.udf_ExtractMedCertStatus_Code(mc_prev_1_week.[Type])
			,Med_Cert_Status_Prev_2_Week = dbo.udf_ExtractMedCertStatus_Code(mc_prev_2_week.[Type])
			,Med_Cert_Status_Prev_3_Week = dbo.udf_ExtractMedCertStatus_Code(mc_prev_3_week.[Type])
			,Med_Cert_Status_Prev_4_Week = dbo.udf_ExtractMedCertStatus_Code(mc_prev_4_week.[Type])
			,Is_Last_Month = @Is_Last_Month
			
			,IsPreClosed = (case when cada_preclosed.Claim_no is not null
									then 1
								else 0
							end)
			,IsPreOpened = (case when (cada_preopened.Claim_no is not null
										or ISNULL(cd.date_claim_entered, cd.date_claim_received) > @Start_Date)
									then 1
								else 0
							end)
			
			-- NCMM Actions
			,[NCMM_Complete_Action_Due] = DATEADD(week
											,dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt)
											,ISNULL(cd.date_claim_received,cd.date_claim_entered))
			,[NCMM_Complete_Remaining_Days] = dbo.udf_NoOfWorkingDaysV2(@Reporting_Date
																		,DATEADD(week
																			,dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt)
																			,ISNULL(cd.date_claim_received,cd.date_claim_entered))
																		)
			,[NCMM_Prepare_Action_Due] = dbo.udf_GetNCCMPrepareActionDueDate(
											dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt)
											,ISNULL(cd.date_claim_received,cd.date_claim_entered))
			,[NCMM_Prepare_Remaining_Days] = dbo.udf_NoOfWorkingDaysV2(@Reporting_Date
																		,dbo.udf_GetNCCMPrepareActionDueDate(
																			dbo.udf_GetNCMMWeeksIn(ISNULL(cd.date_claim_received,cd.date_claim_entered),@AsAt)
																			,ISNULL(cd.date_claim_received,cd.date_claim_entered)
																		))
			--,Gateway_Status = dbo.udf_GetGatewayStatus_S59A(cd.last_weekly_date, cd.Date_of_Injury, cd.Date_Claim_Received, cd.WPI, @AsAt)
			,Broker_Name = RTRIM(LTRIM(brk.Broker_Name))
			,Broker_No = brk.Broker_No
	FROM	#claim cd
			LEFT JOIN (SELECT rtrim(claim) as Claim_no,
								round(SUM(LT_TI + LT_S38 + LT_S40 + LT_NWC + LT_WC),10) as LT
							FROM #CLAIM_DETAIL_PAY
							GROUP BY claim) as measure ON cd.claim = measure.Claim_no
			LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE
			INNER JOIN cd_bit_audit cdba on cdba.Claim_Number = cd.claim
				AND cdba.id = (SELECT MAX(cdba2.id)
							  FROM cd_bit_audit cdba2
							  WHERE cdba2.Claim_Number = cdba.Claim_Number
								AND cdba2.Create_date <= @AsAt)
				AND cdba.is_Null = 0
			
			/* for retrieving Group, Team, Case_Manager */
			LEFT JOIN CLAIMS_OFFICERS co ON cd.Claims_Officer = co.Alias
			
			/* for retrieving EMPL_SIZE */
          	LEFT JOIN PREMIUM_DETAIL pd on pd.POLICY_NO = cd.policy_no and pd.RENEWAL_NO = cd.renewal_no 
          	LEFT JOIN ACTIVITY_DETAIL_AUDIT ada
				ON pd.POLICY_NO = ada.Policy_No and pd.RENEWAL_NO = ada.Renewal_No	
          	
          	/* for retrieving Account_Manager */
          	LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number 
          					FROM CLAIM_DETAIL cld 
          						LEFT JOIN POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
								LEFT JOIN Broker Br on PTD.Broker_No = Br.Broker_no 
								LEFT JOIN UnderWriters U on BR.emi_Contact = U.Alias 
							WHERE U.is_Active = 1 AND U.is_EMLContact = 1 ) as acm 
				ON acm.claim_number = cd.claim
			
			/* for retrieving Company_Name */	
			LEFT JOIN POLICY_TERM_DETAIL ptd ON ptd.POLICY_NO = pd.POLICY_NO
			
			/* for retrieving Deemed Hours Per Week */
			LEFT JOIN TIME_LOST_DETAIL tld ON cd.claim = tld.claim_no
			
			/* for retrieving Med_Cert_Status_{0} */
			LEFT JOIN Medical_Cert mc_this_week ON mc_this_week.Claim_no = cd.claim
				AND ISNULL(mc_this_week.ID, 1) = ISNULL((SELECT TOP 1 ID
															FROM Medical_Cert mc2
															WHERE mc2.Claim_no = mc_this_week.Claim_no
																	and mc2.is_deleted <> 1
																	and mc2.create_date < @AsAt
															ORDER BY mc2.Date_From desc, mc2.create_date desc, mc2.ID desc), 1)
			LEFT JOIN Medical_Cert mc_prev_1_week ON mc_prev_1_week.Claim_no = cd.claim
				AND ISNULL(mc_prev_1_week.ID, 1) = ISNULL((SELECT TOP 1 ID
																FROM Medical_Cert mc2
																WHERE mc2.Claim_no = mc_prev_1_week.Claim_no
																		and mc2.is_deleted <> 1
																		and mc2.create_date < @AsAt_Prev_1_Week
																ORDER BY mc2.Date_From desc, mc2.create_date desc, mc2.ID desc), 1)
			LEFT JOIN Medical_Cert mc_prev_2_week ON mc_prev_2_week.Claim_no = cd.claim
				AND ISNULL(mc_prev_2_week.ID, 1) = ISNULL((SELECT TOP 1 ID
																FROM Medical_Cert mc2
																WHERE mc2.Claim_no = mc_prev_2_week.Claim_no
																		and mc2.is_deleted <> 1
																		and mc2.create_date < @AsAt_Prev_2_Week
																ORDER BY mc2.Date_From desc, mc2.create_date desc, mc2.ID desc), 1)
			LEFT JOIN Medical_Cert mc_prev_3_week ON mc_prev_3_week.Claim_no = cd.claim
				AND ISNULL(mc_prev_3_week.ID, 1) = ISNULL((SELECT TOP 1 ID
																FROM Medical_Cert mc2
																WHERE mc2.Claim_no = mc_prev_3_week.Claim_no
																		and mc2.is_deleted <> 1
																		and mc2.create_date < @AsAt_Prev_3_Week
																ORDER BY mc2.Date_From desc, mc2.create_date desc, mc2.ID desc), 1)
			LEFT JOIN Medical_Cert mc_prev_4_week ON mc_prev_4_week.Claim_no = cd.claim
				AND ISNULL(mc_prev_4_week.ID, 1) = ISNULL((SELECT TOP 1 ID
																FROM Medical_Cert mc2
																WHERE mc2.Claim_no = mc_prev_4_week.Claim_no
																		and mc2.is_deleted <> 1
																		and mc2.create_date < @AsAt_Prev_4_Week
																ORDER BY mc2.Date_From desc, mc2.create_date desc, mc2.ID desc), 1)
			
			/* for retrieving IsPreClosed */
			LEFT JOIN CAD_AUDIT cada_preclosed ON cada_preclosed.Claim_no = cd.claim
				AND cada_preclosed.Claim_Closed_Flag = 'Y'
				AND ISNULL(cada_preclosed.ID, 1) = ISNULL((SELECT MAX(ID) FROM CAD_AUDIT cada2
																WHERE cada2.Claim_no = cada_preclosed.Claim_no
																	AND cada2.Transaction_Date <= @Start_Date), 1)
				
			/* for retrieving IsPreOpened */
			LEFT JOIN CAD_AUDIT cada_preopened ON cada_preopened.Claim_no = cd.claim
				AND cada_preopened.Claim_Closed_Flag = 'N'
				AND ISNULL(cada_preopened.ID, 1) = ISNULL((SELECT MAX(ID) FROM CAD_AUDIT cada2
																WHERE cada2.Claim_no = cada_preopened.Claim_no
																	AND cada2.Transaction_Date <= @Start_Date), 1)
			
			/* for retrieving Total_Paid */
			LEFT JOIN (SELECT claim, SUM(ISNULL(total_paid,0)) as total_paid
							FROM #payment
							GROUP BY claim) t1 ON t1.CLAIM = cd.claim
							
			/* for retrieving Total_Recoveries */
			LEFT JOIN (SELECT claim, SUM(ISNULL(trans_amount,0)) as total_recoveries_1 
							FROM #payment 
							WHERE estimate_type = '76' 
							GROUP BY claim) t2 ON t2.claim = cd.claim
			LEFT JOIN (SELECT claim, SUM(ISNULL(trans_amount,0)) as total_recoveries_2 
							FROM #payment 
							WHERE estimate_type in ('70','71','72','73','74','75','77')
							GROUP BY claim) t3 ON t3.claim = cd.claim
							
			/* for retrieving Physio_Paid */
			LEFT JOIN (SELECT claim, SUM(ISNULL(trans_amount,0)) as physio_paid
							FROM #payment 
							WHERE (payment_type = '05' OR payment_type like 'pta%' OR payment_type like 'ptx%')
								AND estimate_type = '55'
							GROUP BY claim) t4 ON t4.claim = cd.claim
							
			/* for retrieving Chiro_Paid */
			LEFT JOIN (SELECT claim, SUM(ISNULL(trans_amount,0)) as chiro_paid
							FROM #payment 
							WHERE (payment_type = '06' OR payment_type like 'cha%' OR payment_type like 'chx%')
								AND estimate_type = '55'
							GROUP BY claim) t5 ON t5.claim = cd.claim
							
			/* for retrieving Massage_Paid */
			LEFT JOIN (SELECT claim, SUM(ISNULL(trans_amount,0)) as massage_paid
							FROM #payment 
							WHERE (payment_type like 'rma%' OR payment_type like 'rmx%')
								AND estimate_type = '55'
							GROUP BY claim) t6 ON t6.claim = cd.claim
						
			/* for retrieving Osteopathy_Paid */
			LEFT JOIN (SELECT claim, SUM(ISNULL(trans_amount,0)) as osteopathy_paid
							FROM #payment 
							WHERE (payment_type like 'osa%' OR payment_type like 'osx%')
								AND estimate_type = '55'
							GROUP BY claim) t7 ON t7.claim = cd.claim
							
			/* for retrieving Acupuncture_Paid */
			LEFT JOIN (SELECT claim, SUM(ISNULL(trans_amount,0)) as acupuncture_paid
							FROM #payment 
							WHERE payment_type like 'ott001' AND estimate_type = '55'
							GROUP BY claim) t8 ON t8.claim = cd.claim
							
			/* for retrieving Is_Inactive_Claims */
			LEFT JOIN (SELECT claim, SUM(ISNULL(total_paid,0)) as total_paid_last_3m
							FROM #payment
							WHERE transaction_dte >= DATEADD(MM, -3, @AsAt)
							GROUP BY claim) t9 ON t9.claim = cd.claim
							
			/* for retrieving Rehab_Paid */
			LEFT JOIN (SELECT claim, SUM(ISNULL(trans_amount,0)) as rehab_paid
							FROM #payment 
							WHERE (payment_type = '04' OR payment_type like 'or%')
								AND estimate_type = '55'
								AND transaction_dte >= DATEADD(MM, -3, @AsAt)
							GROUP BY claim) t10 ON t10.claim = cd.claim
							
			/* for retrieving Active_Weekly */
			LEFT JOIN (SELECT claim, SUM(ISNULL(total_paid,0)) as total_active_weekly
							FROM #payment 
							WHERE transaction_dte >= DATEADD(MM, -3, @AsAt)
								AND estimate_type = '50'
							GROUP BY claim) t11 ON t11.claim = cd.claim
							
			/* for retrieving Active_Medical */
			LEFT JOIN (SELECT claim, SUM(ISNULL(total_paid,0)) as total_active_medical
							FROM #payment 
							WHERE transaction_dte >= DATEADD(MM, -3, @AsAt)
								AND estimate_type = '55'
							GROUP BY claim) t12 ON t12.claim = cd.claim
							
			/* for retrieving Investigation_Incurred */
			LEFT JOIN (SELECT claim, SUM(ISNULL(amount,0)) as invest_incurred
							FROM #estimate_details
							WHERE estimate_type = '62'
							GROUP BY claim) t13 ON t13.CLAIM = cd.claim
			
			/* for retrieving Common_Law */
			LEFT JOIN (SELECT claim, SUM(ISNULL(amount,0)) as common_law
							FROM #estimate_details
							WHERE estimate_type = '57'
							GROUP BY claim) t14 ON t14.CLAIM = cd.claim
				
			/* for retrieving Is_Reactive */
			LEFT JOIN (SELECT distinct claim
							FROM #WEEKLY_PAYMENT_ALL_2
							WHERE trans_date >= @paystartdt
								and latest_paydate_prev is not null
								and DATEDIFF(MONTH, latest_paydate_prev, latest_paydate) > 3) t15 ON t15.claim = cd.claim
					
			/* for retrieving CC_{0} */
			LEFT JOIN (SELECT Name, Policy_No, Short_Name FROM cost_code) t16
				ON t16.Policy_No = cd.Policy_No AND t16.Short_Name = cd.Cost_Code
			LEFT JOIN (SELECT Name, Policy_No, Short_Name FROM cost_code) t17
				ON t17.Policy_No = cd.Policy_No AND t17.Short_Name = cd.Cost_Code2
				
			/* for retrieving Entitlement_Weeks */
			LEFT JOIN (SELECT claim, SUM(weeks_paid_old + weeks_paid_new) as entitlement_weeks
							FROM #WEEKLY_PAYMENT
							GROUP BY claim) t18 ON t18.CLAIM = cd.claim
							
			/* for retrieving Broker*/
			LEFT JOIN (SELECT Br.NAME as Broker_Name, br.BROKER_NO as Broker_No, Claim_Number
          					FROM CLAIM_DETAIL cld 
          						LEFT JOIN POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
								LEFT JOIN Broker Br on PTD.Broker_No = Br.Broker_no) as brk
				ON brk.Claim_Number = cd.claim
	WHERE	ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2
											WHERE anz2.CODE = anz.CODE), 1)
			AND ISNULL(ada.ID, 1) = ISNULL((SELECT TOP 1 ID
												FROM ACTIVITY_DETAIL_AUDIT ada2
												WHERE ada.Policy_No = ada2.Policy_No
													AND ada.Renewal_No = ada2.Renewal_No
												ORDER BY Policy_No, Renewal_No, CREATE_DATE desc, ID desc), 1)
			AND ISNULL(tld.id, 1) = ISNULL((SELECT MAX(tld2.id)
												FROM TIME_LOST_DETAIL tld2
												WHERE tld2.claim_no = tld.claim_no), 1)
											  
	/* Drop remaining temp tables */
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL DROP table #claim
	IF OBJECT_ID('tempdb..#WEEKLY_PAYMENT_ALL_2') IS NOT NULL DROP table #WEEKLY_PAYMENT_ALL_2
	IF OBJECT_ID('tempdb..#WEEKLY_PAYMENT') IS NOT NULL DROP table #WEEKLY_PAYMENT
	IF OBJECT_ID('tempdb..#CLAIM_DETAIL_PAY') IS NOT NULL DROP table #CLAIM_DETAIL_PAY
	IF OBJECT_ID('tempdb..#payment') IS NOT NULL DROP table #payment
	IF OBJECT_ID('tempdb..#estimate_details') IS NOT NULL DROP table #estimate_details
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio] TO [DART_Role]
GO