--exec usp_Dashboard_Portfolio_GenerateData 'EML','2014-03-31 23:59'
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_Portfolio]    Script Date: 27/03/2014 14:31:45 ******/
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
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL
	IF OBJECT_ID('tempdb..#_incap_date') IS NOT NULL DROP table #_incap_date
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL_2') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL_2
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT') IS NOT NULL DROP table #_WEEKLY_PAYMENT
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP table #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP table #summary
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP table #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP table #rtw_raworig_2
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL DROP table #measures
	
	DECLARE @Reporting_Date datetime
	SET @Reporting_Date = convert(datetime, convert(char, @AsAt, 106)) + '23:59'
	
	SET @AsAt = convert(datetime, convert(char, @AsAt, 106)) + '23:59'
	
	-- determine if this is generating data process for last month or not
	IF @Is_Last_Month = 1
		SET @AsAt = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59' -- get the end of last month as input parameter
	
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
	
	-- next week from @AsAt
	DECLARE @AsAt_Next_Week datetime
	SET @AsAt_Next_Week = DATEADD(WEEK, 1, @AsAt)
	
	-- end day of next week from @AsAt
	DECLARE @AsAt_Next_Week_End datetime
	SET @AsAt_Next_Week_End = DATEADD(wk, 1, DATEADD(dd, 7-(DATEPART(dw, @AsAt)), @AsAt))	
	
	DECLARE @DataFrom datetime
	SET @DataFrom = CAST(YEAR(GETDATE())-1 as varchar(5)) + '-01-01'
	
	DECLARE @_curr_fiscal_yr datetime
	SET @_curr_fiscal_yr = case when MONTH(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) <= 6 
									then CAST(YEAR(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) AS varchar(5)) + '-06-30'
								else CAST(YEAR(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) +1 AS varchar(5)) + '-06-30'	  
							end	
	
	-- FOR EXTRACTING RTW_IMPACTING & CALCULATING ENTITLEMENT WEEKS
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
	
	IF OBJECT_ID('tempdb..#claim') IS NULL
	BEGIN
		/* create #claim table to store claim detail info */
		CREATE TABLE #claim
		(
			claim CHAR(19)
			,hrswrkwk numeric(5,2)
			,Claim_Closed_Flag char(1)
			,Fund tinyint
			,Agency_id char(10)
			,is_exempt bit
			,date_of_injury datetime
			,date_claim_received datetime
			,date_claim_reopened datetime
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
					,ade.is_exempt
					,cd.Date_of_Injury
					,date_claim_received = case when cada.date_claim_received is null 
													then cada.Date_Claim_Entered 
												else cada.date_claim_received
											end
					,cada.Date_Claim_reopened
			FROM dbo.CLAIM_DETAIL cd LEFT JOIN amendment_exemptions ade on cd.Claim_Number = ade.claim_no 
				LEFT JOIN ptd_audit ptda ON cd.Policy_No = ptda.Policy_No
				INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
				INNER JOIN CAD_AUDIT cada on cada.claim_no = cd.Claim_Number
				AND isnull(cd.Claim_Number,'') <> ''
				AND cd.is_Null = 0
				AND cd.Fund <> 98
				AND cda.id = (select max(id)
								from cd_audit cda1 
								where cda1.claim_no = cd.claim_number
									and cda1.create_date < @remuneration_end)
				AND cada.id = (select MAX(id)
									from CAD_AUDIT cada1
									where cada1.Claim_no = cada.Claim_no
										AND cada1.Transaction_Date <= @AsAt						
										)
				AND ptda.id = (SELECT MAX(ptda2.id) 
									FROM ptd_audit ptda2
									WHERE ptda2.policy_no = ptda.policy_no
										  AND ptda2.create_date <= @transaction_lag_remuneration_end
								)
END
	
	IF OBJECT_ID('tempdb..#WCA_EFFECTIVE') IS NULL
	BEGIN
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
					,date_claim_received
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
	
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NULL
	BEGIN
		CREATE TABLE #_WEEKLY_PAYMENT_ALL
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

		/* create index for #_WEEKLY_PAYMENT_ALL table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_ALL_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #_WEEKLY_PAYMENT_ALL(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #_WEEKLY_PAYMENT_ALL
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
			FROM #_WEEKLY_PAYMENT_ALL
			WHERE date_claim_received >= '2012-10-01'
			GROUP BY claim
			
		/* Get incapacity date for old calculations */
		INSERT INTO #_incap_date
		SELECT	claim, incapacity_date = MIN(ppstart)
			FROM #_WEEKLY_PAYMENT_ALL
			WHERE wc_payment_type in ('WPT005','WPT006','WPT007','WPP005','WPP006','WPP007','WPP008')
				AND payamt > 0
				AND ppstart >= effective_date
				AND date_claim_received < '2012-10-01'
			GROUP BY claim
	END
	
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL_2') IS NULL
	BEGIN
		CREATE TABLE #_WEEKLY_PAYMENT_ALL_2
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

		/* create index for #_WEEKLY_PAYMENT_ALL_2 table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_ALL_2_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #_WEEKLY_PAYMENT_ALL_2(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		/* For new calculations */
		INSERT INTO #_WEEKLY_PAYMENT_ALL_2
		SELECT	wpa.claim
				,payment_no
				,trans_date = (SELECT MAX(trans_date)
									FROM #_WEEKLY_PAYMENT_ALL wpa1
									WHERE	wpa1.claim = wpa.claim
											and wpa1.ppstart = wpa.ppstart
											and wpa1.ppend = wpa.ppend)
				,ppstart
				,ppend
				,payamt = (SELECT SUM(ISNULL(payamt,0))
								FROM #_WEEKLY_PAYMENT_ALL wpa1
								WHERE	wpa1.claim = wpa.claim
										and wpa1.ppstart = wpa.ppstart
										and wpa1.ppend = wpa.ppend)
				,wc_Hours = (SELECT SUM(ISNULL(wc_Hours,0))
								FROM #_WEEKLY_PAYMENT_ALL wpa1
								WHERE	wpa1.claim = wpa.claim
										and wpa1.ppstart = wpa.ppstart
										and wpa1.ppend = wpa.ppend)
				,wc_Minutes = (SELECT SUM(ISNULL(wc_Minutes,0))
									FROM #_WEEKLY_PAYMENT_ALL wpa1
									WHERE	wpa1.claim = wpa.claim
											and wpa1.ppstart = wpa.ppstart
											and wpa1.ppend = wpa.ppend)
				,hours_per_week
				,wc_payment_type = (SELECT TOP 1 wc_payment_type
										FROM #_WEEKLY_PAYMENT_ALL wpa1
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
			FROM #_WEEKLY_PAYMENT_ALL wpa LEFT JOIN #_incap_date incap ON incap.claim = wpa.claim
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
		DELETE FROM #_WEEKLY_PAYMENT_ALL_2 WHERE payamt = 0 or wc_Hours = 0
		
		/* For old calculations */
		INSERT INTO #_WEEKLY_PAYMENT_ALL_2
		SELECT wpa.*, incap.incapacity_date
			FROM #_WEEKLY_PAYMENT_ALL wpa LEFT JOIN #_incap_date incap ON incap.claim = wpa.claim
			WHERE date_claim_received < '2012-10-01'
			
		/* Drop unused temp tables: #_WEEKLY_PAYMENT_ALL, #_incap_date */
		IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL
		IF OBJECT_ID('tempdb..#_incap_date') IS NOT NULL DROP table #_incap_date
			
		UPDATE #_WEEKLY_PAYMENT_ALL_2
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
		
		UPDATE #_WEEKLY_PAYMENT_ALL_2 SET weeks_paid_old = ISNULL((ISNULL(wc_Hours, 0) + ISNULL(wc_Minutes, 0)/60)
										/ (case when hours_per_week < 1
													then 37.5
												else hours_per_week
											end), 0)
			WHERE calc_method = 'OLD'
		
		/* NEW FORMULA */
		
		/* align payments into incapacity weeks */
		UPDATE #_WEEKLY_PAYMENT_ALL_2
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
		UPDATE #_WEEKLY_PAYMENT_ALL_2
			SET incap_week_start_new = incap_week_start + 7 * dbo.udf_GetIncapWeekForEntitlement(incap_week_start, incap_week_end)
				,incap_week_end_new = incap_week_start + 7 * dbo.udf_GetIncapWeekForEntitlement(incap_week_start, incap_week_end) + 6
			WHERE calc_method = 'NEW'
				AND dbo.udf_GetIncapWeekForEntitlement(incap_week_start, incap_week_end) <> -1
			
		/* determine the payment date before the latest payment date */
		UPDATE #_WEEKLY_PAYMENT_ALL_2
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
	
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT') IS NULL
	BEGIN
		CREATE TABLE #_WEEKLY_PAYMENT
		(
			 claim varchar(19)
			 ,payment_no int
			 ,incapacity_start datetime
			 ,incapacity_end datetime
			 ,weeks_paid_old float
			 ,weeks_paid_new float
		)

		/* create index for #_WEEKLY_PAYMENT table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #_WEEKLY_PAYMENT(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #_WEEKLY_PAYMENT
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
		FROM #_WEEKLY_PAYMENT_ALL_2
		WHERE calc_method = 'OLD'
			
			/* Data Cleansing 2: remove negative adjustments */
			OR (calc_method = 'NEW' AND trans_amount_prop > 1)
	END
	
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
	
		SELECT distinct claim, ppstart, ppend, paytype, DET_weekly = max(DET_weekly) 
			INTO #summary
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
	
	/* create #measures table that */
	CREATE TABLE #measures
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
	
	INSERT INTO #measures
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
	
	/* Drop unused temp tables: #claim, #rtw_raworig_2 */
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL DROP table #claim
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP table #rtw_raworig_2
	
	/* delete small transactions */

	/* small transactions with $2 per day for S40 and WC payments */
	DELETE FROM #measures WHERE (CASE WHEN paytype in ('S40') AND days_for_TI <> 0 
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
	DELETE FROM #measures WHERE (CASE WHEN  paytype in ('S38','TI','NOWORKCAP') 
										    and (LT_TI + LT_S38 + LT_NWC) <> 0 
										    and (1.0 * payamt / nullif((LT_TI + LT_S38 + LT_NWC),0)) < 20 
										  THEN 1
									  ELSE 0
								 END = 1)
	/* end delete small transactions */
	
	SELECT	'Group' = CASE WHEN UPPER(@System) = 'TMF'
								THEN dbo.udf_TMF_GetGroupByTeam(co.Grp)
							WHEN UPPER(@System) = 'EML'
								THEN
									CASE WHEN (rtrim(isnull(co.Grp,''))='')
										OR NOT EXISTS (select distinct grp 
														from claims_officers 
														where active = 1 and len(rtrim(ltrim(grp))) > 0 
															  and grp like co.Grp+'%')										
										OR (co.Grp NOT LIKE 'wcnsw%' or PATINDEX('WCNSW', RTRIM(co.Grp))>0)
											THEN 'Miscellaneous'
										WHEN PATINDEX('WCNSW%', co.Grp) = 0
											THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
										WHEN rtrim(co.Grp) = 'WCNSW' 
											THEN 'WCNSW(Group)'
										ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
											CASE WHEN PATINDEX('%[A-Z]%', 
														SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) > 0 
												THEN (PATINDEX('%[A-Z]%', 
														SUBSTRING(rtrim(co.Grp), 6, LEN(rtrim(co.Grp)) - 5)) + 4) 
												ELSE LEN(rtrim(co.Grp)) 
											END)
									END
							WHEN UPPER(@System) = 'HEM'
								THEN
									CASE WHEN (rtrim(isnull(co.Grp,'')) = '')
										OR NOT EXISTS (select distinct grp
															from claims_officers 
															where active = 1 and LEN(RTRIM(LTRIM(grp))) > 0 
																  and grp like co.Grp + '%')
										OR co.Grp NOT LIKE 'hosp%'
											THEN 'Miscellaneous'
										WHEN PATINDEX('HEM%', co.Grp) = 0 THEN RTRIM(co.Grp)
										ELSE SUBSTRING(rtrim(co.Grp), 1, 
												CASE WHEN PATINDEX('%[A-Z]%',
															SUBSTRING(RTRIM(co.Grp), 4, LEN(RTRIM(co.Grp)) - 3)) > 0 
													THEN (PATINDEX('%[A-Z]%', 
															SUBSTRING(RTRIM(co.Grp), 4, LEN(RTRIM(co.Grp)) - 3)) + 2) 
													ELSE LEN(rtrim(co.Grp))
												END)
									END
						END
			
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END			
			,Case_Manager = ISNULL(UPPER(co.First_Name + ' ' + co.Last_Name), 'Miscellaneous')
			,Agency_Name = dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no)
			,Agency_Id = UPPER(ptda.Agency_id)
			,Policy_No = cd.policy_no
			,Sub_Category = RTRIM(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,EMPL_SIZE = (CASE WHEN pd.BTP IS NULL OR pd.Process_Flags IS NULL OR pd.WAGES0 IS NULL then 'A - Small'
							  WHEN pd.WAGES0 <= 300000 then 'A - Small'
							  WHEN pd.WAGES0 > 300000 AND pd.WAGES0 <= 1000000 AND pd.Process_Flags = 1 then 'A - Small'
							  WHEN pd.WAGES0 > 300000 AND pd.WAGES0 <= 1000000 AND pd.Process_Flags <> 1 then 'B - Small-Medium'
							  WHEN pd.WAGES0 > 1000000 AND pd.WAGES0 <= 5000000 then 'C - Medium'
							  WHEN pd.WAGES0 > 5000000 AND pd.WAGES0 <= 15000000 AND pd.BTP <= 100000 then 'C - Medium'
							  WHEN pd.WAGES0 > 15000000 then 'D - Large'
							  WHEN pd.WAGES0 > 5000000 AND pd.BTP > 100000 then 'D - Large'
							  ELSE 'A - Small'
						  END)
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
			,Claim_No = cd.Claim_Number
			,WIC_Code = cd.Tariff_No
			,Company_Name = ISNULL((select LEGAL_NAME from POLICY_TERM_DETAIL ptd where ptd.POLICY_NO = pd.POLICY_NO),cd.policy_no)
			,Worker_Name = cd.Given_Names + ', ' + cd.Last_Names
			,Employee_Number = cd.Employee_no
			,Worker_Phone_Number = cd.Phone_no
			,Claims_Officer_Name = co.First_Name + ' ' + co.Last_Name
			,Date_of_Birth = cd.Date_of_Birth
			,Date_of_Injury = cd.Date_of_Injury
			,Date_Of_Notification = cd.Date_Notice_Given
			,Notification_Lag = case when cd.Date_of_Injury IS NULL then -1
									 else
										(case when ISNULL(DATEDIFF(day,cd.Date_of_Injury, cd.Date_Notice_Given), 0) < 0
												then 0
											else ISNULL(DATEDIFF(day,cd.Date_of_Injury, cd.Date_Notice_Given), 0)
										end)
								end
			,Entered_Lag = DATEDIFF(day,cada.date_claim_received, cada.date_claim_entered)
			,Claim_Liability_Indicator_Group = dbo.udf_GetLiabilityStatusById(cada.Claim_Liability_Indicator)
			,Investigation_Incurred = (select SUM(ed.Amount)
											from ESTIMATE_DETAILS ed 
											where ed.[Type] = '62' and ed.Claim_No = cada.Claim_no)
			,Total_Paid = (select ISNULL(SUM(pr.Trans_Amount),0) -
									ISNULL(SUM(pr.itc),0) -
									ISNULL(SUM(pr.dam),0) +
									ISNULL(SUM(pr.gst),0)
									from Payment_Recovery pr
									where pr.Claim_No = cada.Claim_no
										and Transaction_Date <= @AsAt)
			,Is_Time_Lost = cdba.is_Time_Lost
			,Claim_Closed_Flag = cada.Claim_Closed_Flag
			,Date_Claim_Entered = cada.Date_Claim_Entered
			,Date_Claim_Closed = cada.Date_Claim_Closed
			,Date_Claim_Received = cada.date_claim_received
			,Date_Claim_Reopened = cada.Date_Claim_reopened
			,Result_Of_Injury_Code = cdau.Result_of_Injury_Code
			,WPI = cada.WPI
			,Common_Law = case when (select SUM(ed1.Amount) 
										from ESTIMATE_DETAILS ed1 
										where cada.Claim_no = ed1.Claim_No and ed1.[Type] = '57') > 0 
									then 1
							   else 0
						  end
			,Total_Recoveries = (select ISNULL(SUM(pr.Trans_Amount),0) 
									from Payment_Recovery pr 
									where pr.Claim_No = cada.Claim_no and pr.Estimate_type = '76') +
										(select ISNULL(SUM(pr.Trans_Amount),0) 
											from Payment_Recovery pr 
											where pr.Claim_No = cada.Claim_no 
												and pr.Estimate_type in ('70','71','72','73','74','75','77'))			
			,Is_Working = 	case when cada.Work_Status_Code in (1,2,3,4,14) then 1
								 when cada.Work_Status_Code in (5,6,7,8,9) then 0
							end
			,Physio_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
								where claim_no=CADA.Claim_no
									and (payment_type='05' or payment_type like 'pta%' or payment_type like 'ptx%')
									and estimate_type='55'
									and pr.Transaction_Date < @AsAt
							)
			,Chiro_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
								where claim_no=CADA.Claim_no
									and (payment_type='06' or payment_type like 'cha%' or payment_type like 'chx%')
									and estimate_type='55'
									and pr.Transaction_Date < @AsAt
							)
			,Massage_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
								where claim_no=CADA.Claim_no
									and (payment_type like 'rma%' or payment_type like 'rmx%')
									and estimate_type='55'
									and pr.Transaction_Date < @AsAt
								)	
			,Osteopathy_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
									where claim_no=CADA.Claim_no
										and (payment_type like 'osa%' or payment_type like 'osx%')
										and estimate_type='55'
										and pr.Transaction_Date < @AsAt
								)
			,Acupuncture_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
									where claim_no=CADA.Claim_no
										and (payment_type like 'ott001')
										and estimate_type='55'
										and pr.Transaction_Date < @AsAt
								)
			,Create_Date = getdate()
			,Is_Stress = case when cd.Mechanism_of_Injury in (81,82,84,85,86,87,88)
								OR cd.Nature_of_Injury in (910,702,703,704,705,706,707,718,719)
								then 1
							else 0
						  end
			,Is_Inactive_Claims = case when
									(select ISNULL(SUM(pr.Trans_Amount),0) -
										ISNULL(SUM(pr.itc),0) -
										ISNULL(SUM(pr.dam),0)
										from Payment_Recovery pr
										where pr.Claim_No = cada.Claim_no
											and Transaction_Date <= @AsAt
											and Transaction_Date >= DATEADD(MM, -3, @AsAt)) = 0
											then 1
										else 0
									end
			,Is_Medically_Discharged = case when cd.Employment_Terminated_Reason = 2 then 1
											else 0
									   end
			,Is_Exempt = ade.is_exempt
			,Is_Reactive = case when exists (select distinct claim
												from #_WEEKLY_PAYMENT_ALL_2 wp
												where wp.claim = cada.Claim_no
													and trans_date >= @paystartdt
													and latest_paydate_prev is not null
													and DATEDIFF(MONTH, latest_paydate_prev, latest_paydate) > 3)
									then 1
								else 0
							end
			,Is_Medical_Only = cd.Is_Medical_Only
			,Is_D_D = case when cd.Employment_Terminated_Reason = 2
									then 1
								else 0
							end
			,NCMM_Actions_This_Week = (case when cada.Claim_Closed_Flag = 'Y'
												then ''
											else
												(case when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 2
														then 'First Response Protocol- ensure RTW Plan has been developed'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 3
														then 'Complete 3 week Strategic Plan'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 4
														then 'Treatment Provider Engagement'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 6
														then 'Complete 6 week Strategic Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 10
														then 'Complete 10 Week First Response Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 16
														then 'Complete 16 Week Internal Panel Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 20
														then 'Complete 20 Week Tactical Strategy Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 26
														then 'Complete 26 week Employment Direction Pathyway Review (Internal Panel)'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 40
														then 'Complete 40 Week Tactical Strategy Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 52
														then 'Complete 52 week  Employment Direction Determination (Internal Panel)'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 65
														then 'Complete 65 Week Tactical Strategy Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 76
														then 'Complete 78 week Review in preparation for 78 week panel/handover ( Book Internal Panel)-panel in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 78
														then 'Complete 78 week Internal Panel Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 90
														then 'Complete 90 Week Work Capacity Review (Internal Panel)'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 100
														then 'Complete 100 week Work Capacity Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 114
														then 'Complete 114 week Work Capacity Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 132
														then 'Complete 132 week Internal Panel'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) % 13 = 0
															and CEILING((DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 = 0
														then 'Recovering Independence Internal Panel Review'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) % 13 = 0
															and CEILING((DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 <> 0
														then 'Recovering Independence Quarterly Review'
													else ''
												end)
										end)
			,NCMM_Actions_Next_Week = (case when cada.Claim_Closed_Flag = 'Y'
												then ''
											else
												(case when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 2
														then 'Prepare for 3 week Strategic Plan- due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 5
														then 'Prepare for 6 week Strategic Review (book Internal panel)- panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 9
														then 'Prepare for 10 week First Response Review- review due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 14
														then 'Prepare for 16 Week Internal Panel Review ( book Internal Panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 15
														then 'Prepare for 16 Week Internal Panel Review- panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 18
														then 'Prepare 20 Week Tactical Strategy Review -review due  in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 19
														then 'Prepare 20 Week Tactical Strategy Review-  review due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 24
														then 'Prepare 26 Week Employment Direction Pathway Review ( book internal panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 25
														then 'Prepare 26 Week Employment Direction Pathway Review-panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 38
														then 'Prepare 40 Week Tactical Strategy Review-review due in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 39
														then 'Prepare 40 Week Tactical Strategy Review- review due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 50
														then 'Prepare Employment Direction Determination Review ( book Internal Panel)-panel  in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 51
														then 'Prepare Employment Direction Determination Review-panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 63
														then 'Prepare 65 Week Tactical Strategy Review- review due in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 64
														then 'Prepare 65 Week Tactical Strategy Review- review due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 75
														then 'Start preparing  78 week  Work Capacity Review - review to be completed  in week 76 as preparation for handover'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 77
														then 'Prepare Review for 78 week panel- Panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 88
														then 'Prepare 90 Week Work Capacity Review (book internal panel)-panel  in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 89
														then 'Prepare 90 Week Work Capacity Review -panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 98
														then 'Prepare 100 week Work Capacity Review- review due in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 99
														then 'Prepare 100 week Work Capacity Review- review due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 112
														then 'Prepare 114 week Work Capacity Review-review due in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 113
														then 'Prepare 114 week Work Capacity Review- review due next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 130
														then 'Prepare 132 week Internal Panel (Book Internal panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 = 131
														then 'Prepare 132 week Internal Panel- panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) % 13 = 11
															and CEILING((DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 = 0
														then 'Prepare review for  Internal Panel (Book Internal panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) % 13 = 12
															and CEILING((DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 = 0
														then 'Prepare review  for Internal Panel- panel next week'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) % 13 = 11
															and CEILING((DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 <> 0
														then 'Prepare Recovering Independence Quarterly Review-review due in 2 weeks'
													when DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) % 13 = 12
															and CEILING((DATEDIFF(DAY, cd.Date_of_Injury, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 <> 0
														then 'Prepare Recovering Independence Quarterly Review- review due next week'
													else ''
												end)
										end)
			,HoursPerWeek = ISNULL(tld.Deemed_HoursPerWeek, 0)
			,Is_Industrial_Deafness = case when cd.Nature_of_Injury in (152,250,312,389,771)
												then 1
											else 0
										end
			,Rehab_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
									where claim_no=CADA.Claim_no
										and (payment_type like 'or%' or payment_type = '04')
										and Transaction_Date <= @AsAt
										and Transaction_Date >= DATEADD(MM, -3, @AsAt)
							)
			,Action_Required = case when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) in (2,3,4,5,6,9,10,14,15,16,18,19,20,
																					 24,25,26,38,39,40,50,51,52,63,64,65,
																					 75,77,76,78,88,89,90,98,99,100,112,113,
																					 114,130,131,132) 
									  OR (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) -132) % 13 = 0
										  AND CEILING((DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) -132) % 13 = 0
										  AND CEILING((DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0)
									  OR (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) -132) % 13 = 11
										  AND CEILING((DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) -132) % 13 = 12
										  AND CEILING((DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) -132) % 13 = 11
										  AND CEILING((DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0)
									  OR (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) -132) % 13 = 12
										  AND CEILING((DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0) then 'Y'
									else 'N'
							   end
			,RTW_Impacting = case when measure.LT > 5 and cd.Date_of_Injury between @RTW_start_date and @AsAt
									then 'Y'
								else 'N'
							end
			,Weeks_In = DATEDIFF(week,cd.Date_of_Injury,@AsAt_Next_Week_End)
			,Weeks_Band = case when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 0 and 12 then 'A.0-12 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 13 and 18 then 'B.13-18 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 19 and 22 then 'C.19-22 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 23 and 26 then 'D.23-26 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 27 and 34 then 'E.27-34 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 35 and 48 then 'F.35-48 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 48 and 52 then 'G.48-52 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 53 and 60 then 'H.53-60 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 61 and 76 then 'I.61-76 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 77 and 90 then 'J.77-90 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 91 and 100 then 'K.91-100 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 101 and 117 then 'L.101-117 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) between 118 and 130 then 'M.118-130 WK'
							   when DATEDIFF(week,cd.Date_of_Injury, @AsAt_Next_Week_End) > 130 then 'N.130+ WK'
						  end
			,Hindsight = case when cd.Date_of_Injury > DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-36,@_curr_fiscal_yr)) + 1, 0))
								 and  cd.Date_of_Injury <= DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-24,@_curr_fiscal_yr)) + 1, 0)) 
								 then '3 years'
							  when cd.Date_of_Injury > DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-60,@_curr_fiscal_yr)) + 1, 0))
								 and  cd.Date_of_Injury <= DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-48,@_curr_fiscal_yr)) + 1, 0)) 
								 then '5 years'
							  else ''
						 end
			,Active_Weekly = case when (Select ISNULL(SUM(pr.Trans_Amount),0) -
													ISNULL(SUM(pr.itc),0) -
													ISNULL(SUM(pr.dam),0)as amount
													from Payment_Recovery pr
													where pr.Claim_No = cada.Claim_no
														and Transaction_Date <= @AsAt
														and Transaction_Date >= DATEADD(MM, -3, @AsAt)
														and pr.Estimate_type = '50') <> 0 
										then 'Y'
								  else 'N'
							 end
			,Active_Medical = case when (Select ISNULL(SUM(pr.Trans_Amount),0) -
													ISNULL(SUM(pr.itc),0) -
													ISNULL(SUM(pr.dam),0)as amount
													from Payment_Recovery pr
													where pr.Claim_No = cada.Claim_no
														and Transaction_Date <= @AsAt
														and Transaction_Date >= DATEADD(MM, -3, @AsAt)
														and pr.Estimate_type = '55') <> 0 
										then 'Y'
								  else 'N'
							 end					  
			,Cost_Code = cd.Cost_Code
			,Cost_Code2 = cd.Cost_Code2
			,CC_Injury = (select top 1 Name from cost_code where policy_no =cd.Policy_No and short_name =cd.cost_code)
			,CC_Current = case when (select top 1 Name from cost_code where policy_no =cd.Policy_No and short_name =cd.cost_code2) is null 
									then (select top 1 Name from cost_code where policy_no =cd.Policy_No and short_name =cd.cost_code)
							   else (select top 1 Name from cost_code where policy_no =cd.Policy_No and short_name =cd.cost_code2)
						  end
			,Med_Cert_Status_This_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cada.Claim_no))
			,Med_Cert_Status_Next_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Next_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cada.Claim_no))
			,Capacity = (select case when temp.RTW_Goal = 2 then 'Partial Capacity'
									when temp.RTW_Goal = 3 then 'Full Capacity'
									else 'No Capacity'
							   end
						from (select RTW_Goal from TIME_LOST_DETAIL 
							  where ID = (select MAX(ID) from TIME_LOST_DETAIL 
									      where Claim_no = cd.Claim_Number)) as temp)
			,Entitlement_Weeks = (select SUM(weeks_paid_old + weeks_paid_new)
									from #_WEEKLY_PAYMENT
									where claim = cd.Claim_Number
									group by claim)
			,Med_Cert_Status_Prev_1_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Prev_1_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cada.Claim_no))
			,Med_Cert_Status_Prev_2_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Prev_2_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cada.Claim_no))
			,Med_Cert_Status_Prev_3_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Prev_3_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cada.Claim_no))
			,Med_Cert_Status_Prev_4_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Prev_4_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cada.Claim_no))
			,Is_Last_Month = @Is_Last_Month
	FROM	CAD_AUDIT cada
			INNER JOIN CLAIM_DETAIL cd on cada.claim_no = cd.Claim_Number
			LEFT JOIN (SELECT rtrim(claim) as Claim_no,
							round(SUM(LT_TI + LT_S38 + LT_S40 + LT_NWC + LT_WC),10) as LT
						FROM #measures
						GROUP BY claim
					) as measure on cd.Claim_Number = measure.Claim_no
			LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE
			LEFT JOIN amendment_exemptions ade on cd.Claim_Number = ade.claim_no
			
			-- for retrieving Agency_Id
			LEFT JOIN ptd_audit ptda ON cd.Policy_No = ptda.Policy_No
			
			INNER JOIN cd_bit_audit cdba on cdba.Claim_Number = cd.Claim_Number
			INNER JOIN cd_audit cdau on cdau.claim_no = cd.Claim_Number
			
			-- for retrieving Group, Team, Case_Manager
			LEFT JOIN CLAIMS_OFFICERS co ON cada.Claims_Officer = co.Alias
			
			-- for retrieving EMPL_SIZE
          	LEFT JOIN PREMIUM_DETAIL pd on pd.POLICY_NO = cd.policy_no and pd.RENEWAL_NO = cd.renewal_no 
          	LEFT JOIN ACTIVITY_DETAIL_AUDIT ada
				ON pd.POLICY_NO = ada.Policy_No and pd.RENEWAL_NO = ada.Renewal_No	
          	
          	-- for retrieving Account_Manager
          	LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number 
          					FROM CLAIM_DETAIL cld 
          						LEFT JOIN POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
								LEFT JOIN Broker Br on PTD.Broker_No = Br.Broker_no 
								LEFT JOIN UnderWriters U on BR.emi_Contact = U.Alias 
							WHERE U.is_Active = 1 AND U.is_EMLContact = 1 ) as acm 
				ON acm.claim_number = cd.Claim_Number
			
			-- for retrieving Deemed Hours Per Week
			LEFT JOIN TIME_LOST_DETAIL tld on cd.Claim_Number = tld.claim_no
			
	WHERE   CADA.ID = (SELECT MAX(ID) FROM CAD_AUDIT CADA1
							WHERE CADA1.CLAIM_NO = CADA.CLAIM_NO
								AND CADA1.Transaction_Date <= @AsAt
							)
			AND cdba.id = (SELECT MAX(cdba2.id)
							  FROM cd_bit_audit cdba2
							  WHERE cdba2.Claim_Number = cdba.Claim_Number
								AND cdba2.Create_date <= @AsAt
							)
			AND cdau.id = (SELECT MAX(cdau2.id)
							  FROM cd_audit cdau2
							  WHERE cdau2.claim_no = cdau.claim_no
								AND cdau2.Create_date <= @AsAt
							)
			AND ptda.id = (SELECT MAX(ptda2.id)
								FROM ptd_audit ptda2
								WHERE ptda2.policy_no = ptda.policy_no
									  AND ptda2.create_date <= @transaction_lag_remuneration_end
							)
			AND cada.Claim_Liability_Indicator <> '6'
			AND cdba.is_Null = 0
			AND cdau.fund not in (1, 3, 98, 99)
			AND ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2 
												WHERE anz2.CODE = anz.CODE),1)
			AND ISNULL(ada.ID, 1) =
						ISNULL((SELECT TOP 1 ID
									FROM ACTIVITY_DETAIL_AUDIT ada2
									WHERE ada.Policy_No = ada2.Policy_No
										AND ada.Renewal_No = ada2.Renewal_No
									ORDER BY Policy_No, Renewal_No, CREATE_DATE desc, ID desc), 1)
			AND (cada.Date_Claim_Closed >=@DataFrom or cada.Date_Claim_Closed is null or cada.Date_Claim_Closed <= cada.Date_Claim_reopened)
			AND ISNULL(tld.id, 1) = ISNULL((SELECT MAX(tld2.id)
											  FROM TIME_LOST_DETAIL tld2
											  WHERE tld2.claim_no = tld.claim_no), 1)
											  
	/* Drop remaining temp tables */
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL_2') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL_2
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT') IS NOT NULL DROP table #_WEEKLY_PAYMENT
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL DROP table #measures
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