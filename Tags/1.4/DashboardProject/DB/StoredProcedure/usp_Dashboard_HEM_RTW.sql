/****** Object:  StoredProcedure [dbo].[usp_Dashboard_HEM_RTW]    Script Date: 12/26/2013 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--  exec [usp_Dashboard_HEM_RTW] 2013, 6, 12
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_HEM_RTW]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_HEM_RTW]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_HEM_RTW]
	@yy int,
	@mm int,
	@RollingMonth int, -- 1, 3, 6, 12
	@AsAt datetime
AS
BEGIN
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL DROP TABLE #measures
	
	declare @SQL varchar(500)
	
	declare @measure_month_13 int
	declare @measure_month_26 int
	declare @measure_month_52 int
	declare @measure_month_78 int
	declare @measure_month_104 int
	
	declare @remuneration_start datetime
	declare @remuneration_end datetime
	
	declare @transaction_lag_remuneration_start datetime
	declare @transaction_lag_remuneration_end datetime
	
	declare @paystartdt datetime
	
	declare @transaction_lag int	
	
	set @measure_month_13 = 3	-- 13weeks = 3
	set @measure_month_26 = 6	-- 26weeks = 6
	set @measure_month_52 = 12  -- 52weeks = 12
	set @measure_month_78 = 18  -- 78weeks = 18
	set @measure_month_104 = 24 -- 104weeks = 24
	
	set @transaction_lag = 3 -- for HEM
	
	set @remuneration_end = cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
	set @remuneration_start = DATEADD(mm,-@RollingMonth, @remuneration_end)
	
	set @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'
	
	set @transaction_lag_remuneration_start = DATEADD(mm, @transaction_lag, @remuneration_start)
	set @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
	
	set @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_Start))
	
	IF OBJECT_ID('tempdb..#claim') IS NULL
	BEGIN
		/* create #claim table to store claim detail info */
		CREATE TABLE #claim
		(
			claim CHAR(19)
			,policyno CHAR(19)
			,renewal_no INT
			,anzsic varchar(255)
			,hrswrkwk numeric(5,2)
			,injdate datetime
			,_13WEEKS_ DATETIME
			,_26WEEKS_ DATETIME
			,_52WEEKS_ DATETIME
			,_78WEEKS_ DATETIME
			,_104WEEKS_ DATETIME
			,DAYS13 int
			,DAYS26 int
			,DAYS52 int
			,DAYS78 int
			,DAYS104 int
			,DAYS13_PRD int
			,DAYS26_PRD int
			,DAYS52_PRD int
			,DAYS78_PRD int
			,DAYS104_PRD int
		)	

		/* create index for #claim table */
		SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(claim, policyno, injdate)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #claim
			SELECT	cd.Claim_Number
					, cda.Policy_No
					, Renewal_No
					, anz.DESCRIPTION
					, cd.Work_Hours
					, cd.Date_of_Injury
					
					-- calculate 13 weeks from date of injury
					, _13WEEKS_ = dateadd(mm, @measure_month_13, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 26 weeks from date of injury
					, _26WEEKS_ = dateadd(mm, @measure_month_26, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 52 weeks from date of injury
					, _52WEEKS_ = dateadd(mm, @measure_month_52, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 78 weeks from date of injury
					, _78WEEKS_ = dateadd(mm, @measure_month_78, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 104 weeks from date of injury
					, _104WEEKS_ = dateadd(mm, @measure_month_104, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					, DAYS13 = 0
					, DAYS26 = 0
					, DAYS52 = 0
					, DAYS78 = 0
					, DAYS104 = 0
					
					,DAYS13_PRD = 0
					,DAYS26_PRD = 0
					,DAYS52_PRD = 0
					,DAYS78_PRD = 0
					,DAYS104_PRD = 0
			FROM dbo.CLAIM_DETAIL cd INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
				AND isnull(cd.Claim_Number,'') <> ''
				AND cd.Date_of_Injury >= @paystartdt
				AND cda.id = (select max(id) 
								from cd_audit cda1 
								where cda1.claim_no = cd.claim_number 
									and cda1.create_date < @remuneration_end)
				LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE
			/* exclude Serious Claims */
			WHERE cd.claim_number not in (select Claim_no from HEM_SIW)
					AND ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2 
														WHERE anz2.CODE = anz.CODE), 1)
	END
		
	UPDATE #claim
		-- calculate days off work between 13 weeks and date of injury
		SET	DAYS13 = dbo.udf_NoOfDaysWithoutWeekend(injdate, _13WEEKS_) 
				+ (case when datepart(dw,injdate) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 26 weeks and date of injury
		,DAYS26 = dbo.udf_NoOfDaysWithoutWeekend(injdate, _26WEEKS_) 
				+ (case when datepart(dw,injdate) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 52 weeks and date of injury
		,DAYS52 = dbo.udf_NoOfDaysWithoutWeekend(_26WEEKS_, _52WEEKS_) 
				+ (case when datepart(dw,_26WEEKS_) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 78 weeks and date of injury
		,DAYS78 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _78WEEKS_) 
				+ (case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 104 weeks and date of injury
		,DAYS104 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _104WEEKS_) 
				+ (case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end)
		
		/* calculate days off work between MAX(date of injury, remuneration start) 
			and MIN(13 weeks, remuneration end) */
		,DAYS13_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(injdate,
															@remuneration_start,'1900/01/01')
															,dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_)
																	,@remuneration_end
																	,'2222/01/01'
																	)
													)
						+ (case when datepart(dw, dbo.udf_MaxDay(injdate,
															@remuneration_start,'1900/01/01')) not IN(1,7) 																		 
								then 1 
								else 0
						   end)
		
		/* calculate days off work between MAX(date of injury, remuneration start) 
			and MIN(26 weeks, remuneration end) */
		,DAYS26_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(injdate, 
															@remuneration_start,'1900/01/01')
															,dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), 
																	@remuneration_end,'2222/01/01')
													)
					+ (case when datepart(dw, dbo.udf_MaxDay(injdate, 
														@remuneration_start, '1900/01/01')) not IN(1,7) 
						    then 1 
						    else 0 
					   end)
		
		/* calculate days off work between MAX(date of injury, remuneration start) 
			and MIN(52 weeks, remuneration end) */
		,DAYS52_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_26WEEKS_, 
															@remuneration_start,'1900/01/01')
															,dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), 
																	@remuneration_end,'2222/01/01')
													 )
					 + (case when datepart(dw, dbo.udf_MaxDay(_26WEEKS_, 
													@remuneration_start, '1900/01/01')) not IN(1,7) 
							then 1 
							else 0
					   end)
		
		/* calculate days off work between MAX(date of injury, remuneration start) 
			and MIN(78 weeks, remuneration end) */
		,DAYS78_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, 
															@remuneration_start,'1900/01/01')
															,dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), 
															@remuneration_end,'2222/01/01')
													 )
					 + (case when datepart(dw, dbo.udf_MaxDay(_52WEEKS_, 
														@remuneration_start, '1900/01/01')) not IN(1,7) 
							then 1 
							else 0 
					   end)
		
		/* calculate days off work between MAX(date of injury, remuneration start) 
			and MIN(104 weeks, remuneration end) */
		,DAYS104_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, 
															@remuneration_start,'1900/01/01')
															,dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), 
																	@remuneration_end,'2222/01/01')
													  )
					   + (case when datepart(dw, dbo.udf_MaxDay(_52WEEKS_, 
														@remuneration_start, '1900/01/01')) not IN(1,7) 
							   then 1 
							   else 0
						 end)
	
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NULL
	BEGIN
		/* create #rtw_raworig temp table to store transaction data */
		CREATE TABLE #rtw_raworig_temp
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)
			 ,adjflag varchar(1)
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
				,Adjust_Trans_Flag
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
				AND Transaction_date <= @AsAt
				AND wc_Tape_Month IS NOT NULL 
				AND LEFT(wc_Tape_Month, 4) <= @yy
				AND wc_Tape_Month <= CONVERT(int, 
										CONVERT(varchar(8), @transaction_lag_remuneration_end,112))
				AND wc_payment_type IN ('WPT001', 'WPT003', 'WPT002'
										 ,'WPT004', 'WPP001', 'WPP003'
										 ,'WPP002', 'WPP004','WPT005'
										 ,'WPT006', 'WPT007', 'WPP005'
										 ,'WPP006', 'WPP007', 'WPP008'
										 ,'13', '14', '15', '16')
										 
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
				,payamt = (SELECT SUM(payamt)
								FROM #rtw_raworig_temp rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(hrs_total)
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
				
		/*	
		Records with payment amount and hours paid for total incapacity are both zero are removed.
		*/
		DELETE FROM #rtw_raworig WHERE hrs_total = 0 and payamt = 0
		
		/*	
			Records with a negative payment amount, but positive hours paid for total incapacity
				have their hours paid changed to be negative.
		*/
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
		
		/* summarised trasactions by claim, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig_2
		SELECT  claim
				,paydate = (SELECT MIN(paydate) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim										
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,rtw_paytype
				,payamt = (SELECT SUM(payamt)
								FROM #rtw_raworig rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(hrs_total)
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
				
		/*	
		- Records with payment amount equal to zero are removed;
		- Records associated with payments of pre-reform benefits (s36, s37, s38, s40) with hours
		paid for partial incapacity and hours paid for total incapacity both equal to zero are
		removed;
		*/
		DELETE FROM #rtw_raworig_2 WHERE payamt = 0 or (hrs_total = 0 
			and rtw_paytype in ('TI', 'S38', 'S40'))
	END
	
	IF OBJECT_ID('tempdb..#policy') IS NULL
	BEGIN
		/* create #policy table to store policy info for claim */
		CREATE TABLE #policy
		(
			policyno CHAR(19)
			,renewal_no INT
			,bastarif MONEY
			,wages MONEY
			,const_flag_final int
		)
		
		/* create index for #policy table */
		SET @SQL = 'CREATE INDEX pk_policy_'+CONVERT(VARCHAR, @@SPID)+' ON #policy(policyno, renewal_no)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #policy
			SELECT	POLICY_NO
					, RENEWAL_NO
					, BTP					
					, WAGES0
					, Process_Flags					
				FROM dbo.PREMIUM_DETAIL pd
				WHERE EXISTS (SELECT 1 FROM #claim cd where cd.policyno = pd.POLICY_NO)
				ORDER BY POLICY_NO,RENEWAL_NO
	END
	
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NULL
	BEGIN
		/* create #activity_detail_audit table to store policy info for claim */
		CREATE TABLE #activity_detail_audit
		(
			policyno CHAR(19)
			,renewal_no INT
			,tariff INT
			,wages_shifts MONEY
		)
		
		/* create index for #activity_detail_audit table */
		SET @SQL = 'CREATE INDEX pk_activity_detail_audit_'+CONVERT(VARCHAR, @@SPID)
			+' ON #activity_detail_audit(policyno, renewal_no, tariff)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
				
		INSERT INTO #activity_detail_audit
			SELECT Policy_No, Renewal_No, Tariff, SUM(ISNULL(Wages_Shifts, 0))
				FROM ACTIVITY_DETAIL_AUDIT ada
				GROUP BY Policy_No, Renewal_No, Tariff
				HAVING EXISTS (SELECT 1 FROM #claim cd where cd.policyno = ada.Policy_No)
	END
	
	/* create #measures table that contains all of necessary columns 
		for calculating RTW measures */
	CREATE TABLE #measures
	(
		claim CHAR(19)
		,policyno CHAR(19)
		,portfolio varchar(256)
		,injdate datetime
		,paytype varchar(9)
		,ppstart datetime
		,ppend datetime
		,payamt money
		,hrs_per_week_adjusted numeric(5,2)
		,weeks_paid_adjusted float
		,hrs_total numeric(14,3)
		,DET_weekly money
		,days_for_TI int
		,LT_TI float
		,LT_S38 float
		,LT_S40 float
		,LT_NWC float
		,LT_WC float
		,empl_size varchar(256)
		,CAP_CUR_13 float	
		,CAP_PRE_13 float	
		,DAYS13_TRANS float
		,DAYS13_TRANS_PRIOR float
		,LT13_TRANS FLOAT
		,LT13_TRANS_PRIOR FLOAT
		,LT13 FLOAT
		,CAP_CUR_26 float	
		,CAP_PRE_26 float	
		,DAYS26_TRANS float
		,DAYS26_TRANS_PRIOR float
		,LT26_TRANS FLOAT
		,LT26_TRANS_PRIOR FLOAT
		,LT26 FLOAT
		,CAP_CUR_52 float
		,CAP_PRE_52 float
		,DAYS52_TRANS float	
		,DAYS52_TRANS_PRIOR float	
		,LT52_TRANS FLOAT	
		,LT52_TRANS_PRIOR FLOAT	
		,LT52 FLOAT
		,CAP_CUR_78 float
		,CAP_PRE_78 float
		,DAYS78_TRANS float	
		,DAYS78_TRANS_PRIOR float	
		,LT78_TRANS FLOAT	
		,LT78_TRANS_PRIOR FLOAT	
		,LT78 FLOAT
		,CAP_CUR_104 float
		,CAP_PRE_104 float
		,DAYS104_TRANS float	
		,DAYS104_TRANS_PRIOR float	
		,LT104_TRANS FLOAT	
		,LT104_TRANS_PRIOR FLOAT	
		,LT104 FLOAT
		,include_13 bit
		,include_26 bit
		,include_52 bit
		,include_78 bit
		,include_104 bit
		,include_13_trans bit
		,include_26_trans bit
		,include_52_trans bit
		,include_78_trans bit
		,include_104_trans bit
		,Total_LT FLOAT
		,_13WEEKS_ DATETIME
		,_26WEEKS_ DATETIME
		,_52WEEKS_ DATETIME
		,_78WEEKS_ DATETIME
		,_104WEEKS_ DATETIME
		,DAYS13_PRD_CALC int
		,DAYS26_PRD_CALC int
		,DAYS52_PRD_CALC int
		,DAYS78_PRD_CALC int
		,DAYS104_PRD_CALC int
		,DAYS13_CALC int
		,DAYS26_CALC int
		,DAYS52_CALC int
		,DAYS78_CALC int
		,DAYS104_CALC int
	)
	 
	/* create index for #measures table */
	SET @SQL = 'CREATE INDEX pk_measures_' + CONVERT(VARCHAR, @@SPID) + ' ON #measures(claim,policyno,injdate)'
	EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #measures
	SELECT DISTINCT 
			pr.Claim
			,cd.policyno
			,portfolio = case when isnull(cd.anzsic,'')<>''
								then
									case when UPPER(cd.anzsic) = 'ACCOMMODATION' 
											or UPPER(cd.anzsic) = 'PUBS, TAVERNS AND BARS' 
											or UPPER(cd.anzsic) = 'CLUBS (HOSPITALITY)' then cd.anzsic
										else 'Other'
									end
								else
									case when LEFT(ada.tariff, 1) = '1' and LEN(ada.tariff) = 7
											then 
												case when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '571000'
													then 'Accommodation'
												when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '572000'
													then 'Pubs, Taverns and Bars'
												when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '574000'
													then 'Clubs'
												else 'Other'
											end
										else 
											case when ada.tariff = 571000 then 'Accommodation'
												when ada.tariff = 572000 then 'Pubs, Taverns and Bars'
												when ada.tariff = 574000 then 'Clubs'
												else 'Other'
											end
									end
							end
			,injdate
			,pr.rtw_paytype
			,pr.ppstart
			,pr.ppend
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
			,weeks_paid_adjusted = 1.0 
									* pr.hrs_total 
									/ nullif(dbo.udf_MinValue(40 
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1 
																else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															end)
														),0)
			,pr.hrs_total
			,pr.DET_weekly
			
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
								 * (pr.hrs_total * 5 / 37.5)
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
								then 1.0
									 *(case when  rtw_paytype = 'TI' 
													and datepart(dw,pr.ppstart) IN(1,7) 
													and datepart(dw,pr.ppend) IN(1,7) 
													and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
												 then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
											  when pr.ppstart = pr.ppend 
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
								then 1.0
									 *(case	when rtw_paytype = 'TI' 
												 and datepart(dw,pr.ppstart) IN(1,7) 
												 and datepart(dw,pr.ppend) IN(1,7) 
												 and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
											  then DATEDIFF(day,pr.ppstart,pr.ppend) + 1
											when pr.ppstart = pr.ppend 
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
									  / 37.5
										
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
								then 1.0
									 *(case when  rtw_paytype = 'TI' 
												 and datepart(dw,pr.ppstart) IN(1,7) 
												 and datepart(dw,pr.ppend) IN(1,7) 
												 and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
											 then DATEDIFF(day,pr.ppstart,pr.ppend) + 1
										   when pr.ppstart = pr.ppend 
											 then 1 
										   else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									 end)
									 * 0.75
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
							when rtw_paytype = 'S40' 
								 and dbo.udf_MinValue(40
													 , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) end)
														) < 35
								then 1.0
									 *(case when		rtw_paytype = 'TI' 
													and datepart(dw,pr.ppstart) IN(1,7) 
													and datepart(dw,pr.ppend) IN(1,7) 
													and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
												then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
											when pr.ppstart = pr.ppend 
												then 1 
											else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									   end)
									   * 0.75 
									   * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									   * dbo.udf_MinValue(40
														  , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
																  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															 end)
															)
										/ 37.5
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
								then 1.0 * (pr.payamt* 5) / nullif(pr.DET_weekly,0)
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
									 * dbo.udf_MinValue(40
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
									  *5
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
						
			/*  determine employer size: Small, Smal-Medium, Medium or Large */
			
			-- set default to Small when missing policy data;
			,EMPL_SIZE = (CASE WHEN pd.bastarif IS NULL OR pd.const_flag_final IS NULL OR pd.wages IS NULL then 'A - Small'
							  WHEN pd.wages <= 300000 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final = 1 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final <> 1 then 'B - Small-Medium'
							  WHEN pd.wages > 1000000 AND pd.wages <= 5000000 then 'C - Medium'
							  WHEN pd.wages > 5000000 AND pd.wages <= 15000000 AND pd.bastarif <= 100000 then 'C - Medium'
							  WHEN pd.wages > 15000000 then 'D - Large'
							  WHEN pd.wages > 5000000 AND pd.bastarif > 100000 then 'D - Large'
							  ELSE 'A - Small'
						  END)
			/*  determine employer size: Small, Smal-Medium, Medium or Large */
						 
			/* 13 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate),
													dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End, '2222/01/01')
													) + case when DATEPART(dw,injdate) not in (1,7) 
																then 1 
															else 0 
														end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate),
													dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
													) +	case when DATEPART(dw,injdate) not in (1,7) 
																then 1 
															else 0 
														end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS13_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _13WEEKS_)
										and paydate <= @transaction_lag_remuneration_end 
									then case when dbo.udf_MinDay(@remuneration_End,
															DATEADD(dd, -1, _13WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _13WEEKS_), ppend))
																		) +	case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0 
																			end
										else dbo.udf_MaxValue(0, 
												dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
													dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), ppend))) 
									end
								else 0 
							end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS13_TRANS_PRIOR = case when ppstart < @remuneration_start
											and paydate < DATEADD(MM, @Transaction_lag, _13WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
										then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
															DATEADD(dd, -1, _13WEEKS_), ppend) >= ppstart 
													then dbo.udf_MaxValue(0, 
																dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																		dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																				DATEADD(dd, -1, _13WEEKS_), ppend))
																			) + case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					when rtw_paytype = 'TI' 
																						and DATEPART(dw,ppstart) in (1,7) 
																						and DATEPART(dw,ppend) in (1,7) 
																						and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0 
																				end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _13WEEKS_), ppend)
																					)
															) 
										end
									else 0 
								end
			,LT13_TRANS = 0
			,LT13_TRANS_PRIOR = 0
			,LT13 = 0
			
			/* 13 weeks */
			
			/* 26 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), 
															@remuneration_End, '2222/01/01')
														) + case when DATEPART(dw,injdate) not in (1,7) 
																	then 1 
																else 0 
															end)		
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
														dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), 
																DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
															) + case when DATEPART(dw,injdate) not in (1,7) 
																		then 1 
																	else 0 
																end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS26_TRANS = case when ppstart <= @remuneration_end 
									and paydate < DATEADD(MM, @Transaction_lag, _26WEEKS_)
									and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
														DATEADD(dd, -1, _26WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _26WEEKS_), ppend)
																				)
																		) + case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					 then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0 
																			end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(@remuneration_End, 
																	DATEADD(dd, -1, _26WEEKS_), ppend))) 
										end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS26_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _26WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _26WEEKS_), ppend) >= ppstart 
															then dbo.udf_MaxValue(0, 
																		dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																				dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																						DATEADD(dd, -1, _26WEEKS_), ppend)
																										)
																				) + case when DATEPART(dw,ppstart) not in (1,7) 
																							then 1
																						 when rtw_paytype = 'TI' 
																							and DATEPART(dw,ppstart) in (1,7) 
																							and DATEPART(dw,ppend) in (1,7) 
																							and DATEDIFF(DD,ppstart, ppend) <= 1
																							then 1 + DATEDIFF(DD,ppstart, ppend) 
																						else 0 
																					end
									
											else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _26WEEKS_), ppend)
																					)
																)
										end
									else 0 
								end
			,LT26_TRANS = 0
			,LT26_TRANS_PRIOR = 0
			,LT26 = 0
			
			/* 26 weeks */
			
			/* 52 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS52_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _52WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _52WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _52WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0
												end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(@remuneration_End, 
																	DATEADD(dd, -1, _52WEEKS_), ppend))) 
									end
								else 0 
							end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS52_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _52WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
										then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
															DATEADD(dd, -1, _52WEEKS_), ppend) >= ppstart 
													then dbo.udf_MaxValue(0, 
																dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																		dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																				DATEADD(dd, -1, _52WEEKS_), ppend)
																								)
																		) + case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				 when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0
																			end
												else dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																			DATEADD(dd, -1, _52WEEKS_), ppend)
																							)
																	) 
											end
										else 0
									end
			,LT52_TRANS = 0	
			,LT52_TRANS_PRIOR = 0	
			,LT52 = 0
			
			/* 52 weeks */
			
			/* 78 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS78_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _78WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _78WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _78WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0 
																		end
											else dbo.udf_MaxValue(0, 
														dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																dbo.udf_MinDay(@remuneration_End, 
																		DATEADD(dd, -1, _78WEEKS_), ppend))) 
											end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS78_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _78WEEKS_)
											and paydate <= @transaction_lag_remuneration_start								
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _78WEEKS_), ppend) >= ppstart 
														then dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, 
																					@remuneration_Start), 
																					DATEADD(dd, -1, _78WEEKS_), ppend)
																							)
																			) + case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					 when rtw_paytype = 'TI' 
																							and DATEPART(dw,ppstart) in (1,7) 
																							and DATEPART(dw,ppend) in (1,7) 
																							and DATEDIFF(DD,ppstart, ppend) <= 1
																						then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0 
																				end
														else dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																					DATEADD(dd, -1, _78WEEKS_), ppend)
																									)
																			) 
													end
											else 0 
									end
			,LT78_TRANS = 0	
			,LT78_TRANS_PRIOR = 0
			,LT78 = 0
			
			/* 78 weeks */
			
			/* 104 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS104_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _104WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _104WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _104WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0
																		end
												else dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _104WEEKS_), ppend))) 
										end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS104_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _104WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _104WEEKS_), ppend) >= ppstart 
														then dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, 
																					@remuneration_Start), 
																					DATEADD(dd, -1, _104WEEKS_), ppend)
																									)
																			) +	case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					 when rtw_paytype = 'TI' and DATEPART(dw,ppstart) in (1,7) 
																						and DATEPART(dw,ppend) in (1,7) 
																						and DATEDIFF(DD,ppstart, ppend) <= 1
																						then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0
																				end
											else dbo.udf_MaxValue(0, 
														dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																dbo.udf_MinDay(DATEADD(dd, -1, 
																		@remuneration_Start), 
																		DATEADD(dd, -1, _104WEEKS_), ppend)
																					)
																)
											end
									else 0
								end
			,LT104_TRANS = 0
			,LT104_TRANS_PRIOR = 0
			,LT104 = 0
			
			/* 104 weeks */
			
			/* flags determine transaction's incapacity periods is lied within 13, 26, 52, 78, 104 weeks injury or not */
			,include_13 = (case when (injdate between @remuneration_Start and @remuneration_End) 
									or (_13WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  injdate and _13WEEKS_) 
									or (@remuneration_End between  injdate and _13WEEKS_) 
									then 1 
								else 0 
						  end)
			,include_26 = (case when (injdate between @remuneration_Start and @remuneration_End) 
									or (_26WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  injdate and _26WEEKS_) 
									or (@remuneration_End between  injdate and _26WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_52 = (case when (_26WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _26WEEKS_ and _52WEEKS_) 
									or (@remuneration_End between  _26WEEKS_ and _52WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_78 = (case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_78WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _52WEEKS_ and _78WEEKS_) 
									or (@remuneration_End between  _52WEEKS_ and _78WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_104 = (case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_104WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _52WEEKS_ and _104WEEKS_) 
									or (@remuneration_End between  _52WEEKS_ and _104WEEKS_) 
									then 1 
								 else 0 
							end)
			
			/* flags determine transaction is included in the 13, 26, 52, 78, 104 week measures or not */
			,include_13_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _13WEEKS_) 
											   and pr.paydate <= @transaction_lag_remuneration_end 	
											   then 1 
										  else 0 
									end)
			,include_26_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _26WEEKS_) 
										   and pr.paydate <= @transaction_lag_remuneration_end	
										  then 1 
									  else 0 
								end)
			,include_52_trans = (case when  pr.paydate <  DATEADD(MM, @Transaction_lag, _52WEEKS_) 
											and pr.paydate <= @transaction_lag_remuneration_end 	
										  then 1 
									  else 0 
								end)
			,include_78_trans = (case when  pr.paydate <  DATEADD(MM, @Transaction_lag, _78WEEKS_) 
												and pr.paydate <= @transaction_lag_remuneration_end 	
											  then 1 
										   else 0 
									 end)
			,include_104_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _104WEEKS_) 
											and pr.paydate <= @transaction_lag_remuneration_end 	
											then 1 
										else 0 
								  end)
			
			,Total_LT = 0
			,_13WEEKS_
			,_26WEEKS_
			,_52WEEKS_
			,_78WEEKS_
			,_104WEEKS_
			
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(13 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS13_PRD_CALC = DAYS13_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(26 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS26_PRD_CALC = DAYS26_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(52 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS52_PRD_CALC = DAYS52_PRD 
											
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(78 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS78_PRD_CALC = DAYS78_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(104 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS104_PRD_CALC = DAYS104_PRD 
											  
			/* recalculate days off work between 13 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS13_CALC = DAYS13 
									 
			/* recalculate days off work between 26 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS26_CALC = DAYS26 
									 
			/* recalculate days off work between 52 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS52_CALC = DAYS52 
									 
			/* recalculate days off work between 78 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS78_CALC = DAYS78 
									 
			/* recalculate days off work between 104 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS104_CALC = DAYS104
	FROM #claim cd INNER JOIN #rtw_raworig_2 pr ON cd.Claim = pr.Claim
				   LEFT JOIN  #policy pd ON pd.policyno = cd.policyno
											AND pd.renewal_no = cd.renewal_no
											AND PR.ppstart <= @remuneration_end
					LEFT JOIN #activity_detail_audit ada
							ON ada.policyno = cd.policyno AND ada.renewal_no = cd.renewal_no
	WHERE ada.wages_shifts = (SELECT MAX(ada2.wages_shifts) 
									FROM #activity_detail_audit ada2
									WHERE ada2.policyno = ada.policyno
										AND ada2.renewal_no = ada.renewal_no)

	/* update LT_TRANS and LT_TRANS_PRIOR */
	UPDATE #measures
		SET LT13_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS13_TRANS / nullif(days_for_TI,0)
					    end)
			,LT13_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									else 1.0 
										 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
										 * DAYS13_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT26_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0 
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS26_TRANS / nullif(days_for_TI,0)
							end)
			,LT26_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS26_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT52_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS52_TRANS / nullif(days_for_TI,0)
						   end)
			,LT52_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS52_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT78_TRANS = (case when days_for_TI = 0 then 0 
								else 1.0 
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC)
									 * DAYS78_TRANS / nullif(days_for_TI,0)
						   end)
			,LT78_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
										    * DAYS78_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT104_TRANS = (case when days_for_TI = 0 
									then 0 
								 else 1.0
									  * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									  * DAYS104_TRANS / nullif(days_for_TI,0)
							end)
			,LT104_TRANS_PRIOR = (case when days_for_TI = 0 
											then 0 
									   else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS104_TRANS_PRIOR / nullif(days_for_TI,0)
								 end)
			,Total_LT = (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC)
						* (case when ppend <= @remuneration_end or days_for_TI = 0 
									 then 1
								when ppstart > @remuneration_end 
									 then 0
								else 1.0 
									 * dbo.udf_NoOfDaysWithoutWeekend(ppstart, @remuneration_end) 
									 / nullif(days_for_TI,0)
						  end)

	/* end of updating LT_TRANS and LT_TRANS_PRIOR */
	
	/* delete small transactions */

	/* small transactions with $2 per day for S40 and WC payments */
	DELETE FROM #measures WHERE (CASE WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted >= 35 
											AND (1.0 * payamt / nullif(days_for_TI,0)) < 2 
										THEN 1
									 WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted < 35 
											AND (1.0 * payamt / ((days_for_TI*hrs_per_week_adjusted)/37.5)) < 2 
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
	
	/* Extract claims 13 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @measure_month_13
			
			-- retrieve group info like 'HEM*'
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')	
								OR co.Grp NOT LIKE 'hosp%'
								THEN 'Miscellaneous'
							WHEN PATINDEX('HEM%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) + 2) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
							
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL(UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')
			,Group_ = dbo.udf_GetGroupByPolicyNo(cd.policyno)
			,Team_ = CASE WHEN rtrim(isnull(co.Grp,''))= '' 
							then 'Miscellaneous' 
						else rtrim(UPPER(co.Grp)) 
					end
			,Case_manager_ = ISNULL ( UPPER(co.First_Name + ' ' + co.Last_Name), 'Miscellaneous')
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 13
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
				
	FROM (
			SELECT rtrim(cla.claim) as Claim_no
					,cla.injdate
					,cla.policyno
					,cla.portfolio
					,round(dbo.udf_MinValue(sum(cla.LT13_TRANS), 
									avg(CAP_CUR_13)) - dbo.udf_MinValue(sum(cla.LT13_TRANS_PRIOR), 
																AVG(CAP_PRE_13)), 10) as LT					
					, case when DAYS13_PRD_CALC < 0 
								then 0 
							else round(dbo.udf_MinValue(1, 1.0 * DAYS13_PRD_CALC / nullif(DAYS13_CALC,0)), 10) 
						end as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_13WEEKS_
			FROM #measures cla 
			WHERE cla.include_13 = 1 and cla.include_13_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_13WEEKS_,
					DAYS13_PRD_CALC, 
					DAYS13_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 
					and round(sum(LT13_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias 
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT [id],item,value 
					FROM control_audit ctra1 
					WHERE type = 'GroupLevel') ctra1 
							ON (CHARINDEX('*' + coa1.grp + '*',ctra1.value)) <> 0 
								AND ctra1.id = ISNULL((SELECT MAX(ctra2.id) FROM control_audit ctra2
													WHERE ctra2.type = 'GroupLevel'
														AND ((cada1.Claim_Closed_Flag ='Y' 
														AND ctra2.create_date <= dbo.udf_MinDay(
																						ISNULL(cada1.Date_Claim_Closed, 
																							cd._13WEEKS_), 
																							@remuneration_end, 
																							cd._13WEEKS_)
															)
														OR (cada1.Claim_Closed_Flag ='N' 
															AND ctra2.create_date <= dbo.udf_MinDay(
																							cd._13WEEKS_, 
																							@remuneration_end, 
																							@remuneration_end)
															)
															)
					AND ctra2.item = ctra1.item ), '' )
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
				  left join Broker Br on PTD.Broker_No = Br.Broker_no 
				  left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
		
	WHERE cada1.id = (SELECT MAX(cada2.id)
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._13WEEKS_,
						  @remuneration_end, cd._13WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._13WEEKS_,
						  @remuneration_end, cd._13WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id) 
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
		
	UNION ALL
	
	/* Extract claims 26 weeks from #measures table and some additional tables */
	--select  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_26
			
			-- retrieve group info like 'HEM*'
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')	
								OR co.Grp NOT LIKE 'hosp%'
								THEN 'Miscellaneous'
							WHEN PATINDEX('HEM%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) + 2) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
							
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL ( UPPER(coa1.First_Name+' '+ coa1.Last_Name), 'Miscellaneous')
			,Group_ = dbo.udf_GetGroupByPolicyNo(cd.policyno)
			,Team_ = CASE WHEN rtrim(isnull(co.Grp,''))='' 
							then 'Miscellaneous' 
						else rtrim(UPPER(co.Grp)) 
					end
			,Case_manager_ = ISNULL ( UPPER(co.First_Name + ' ' + co.Last_Name), 'Miscellaneous')
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 26
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag

	FROM (
			SELECT rtrim(cla.claim) as Claim_no
				,cla.injdate
				,cla.policyno
				,cla.portfolio
				,round(dbo.udf_MinValue(sum(cla.LT26_TRANS), 
								avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), 
															AVG(CAP_PRE_26)), 10) as LT				
				, case when DAYS26_PRD_CALC < 0 
							then 0 
						else round(dbo.udf_MinValue(1, 1.0 * DAYS26_PRD_CALC / nullif(DAYS26_CALC,0)), 10)
					end as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_26WEEKS_
			FROM #measures cla 
			where cla.include_26 = 1 and cla.include_26_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_26WEEKS_,
					DAYS26_PRD_CALC,
					DAYS26_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 
						and round(sum(LT26_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_no = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT [id],item,value 
					FROM control_audit ctra1 
					WHERE type = 'GroupLevel') ctra1 
						ON (CHARINDEX('*'+coa1.grp+'*',ctra1.value)) <> 0 
							AND ctra1.id = ISNULL((SELECT MAX(ctra2.id) 
													FROM control_audit ctra2
													WHERE ctra2.type = 'GroupLevel'
														AND ((cada1.Claim_Closed_Flag ='Y' 
															AND ctra2.create_date <= dbo.udf_MinDay(
																				ISNULL(cada1.Date_Claim_Closed, cd._26WEEKS_), 
																					@remuneration_end, 
																					cd._26WEEKS_))
														OR (cada1.Claim_Closed_Flag ='N' 
														AND ctra2.create_date <= dbo.udf_MinDay(cd._26WEEKS_, 
																						@remuneration_end, 
																						@remuneration_end)
															)
															)
					AND ctra2.item = ctra1.item ), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
      			
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2
						WHERE cada2.claim_no = cada1.claim_no
							and cada2.transaction_date <= dbo.udf_MinDay(cd._26WEEKS_,
						  @remuneration_end, cd._26WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._26WEEKS_,
						  @remuneration_end, cd._26WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id)
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no
							and ptda2.create_date <= @remuneration_end)
		
	UNION ALL
	
	/* Extract claims 52 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_52
			
			-- retrieve group info like 'HEM*'
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')	
								OR co.Grp NOT LIKE 'hosp%'
								THEN 'Miscellaneous'
							WHEN PATINDEX('HEM%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) + 2) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
							
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL ( UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')
			,Group_ = dbo.udf_GetGroupByPolicyNo(cd.policyno)
			,Team_ = CASE WHEN rtrim(isnull(co.Grp,'')) = '' 
							then 'Miscellaneous' 
						else rtrim(UPPER(co.Grp)) 
					end
			,Case_manager_ = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 52
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no	
					,cla.injdate	
					,cla.policyno
					,cla.portfolio
					,	(round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
										avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																AVG(CAP_PRE_52)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT26_TRANS), 
										avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), 
																AVG(CAP_PRE_26)), 10))
					) as LT						
					, case when DAYS52_PRD_CALC < 0 
								then 0 
							else round(dbo.udf_MinValue(1, 1.0 * DAYS52_PRD_CALC / nullif(DAYS52_CALC,0)), 10) 
						end as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_52WEEKS_
			FROM #measures cla
			WHERE cla.include_52 = 1 and cla.include_52_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_52WEEKS_,
					DAYS52_PRD_CALC, 
					DAYS52_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT52_TRANS),10) > 5	
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT [id],item,value 
					FROM control_audit ctra1 
					WHERE type = 'GroupLevel') ctra1 
						ON (CHARINDEX('*' + coa1.grp + '*',ctra1.value)) <> 0 
							AND ctra1.id = ISNULL((SELECT MAX(ctra2.id) 
													FROM control_audit ctra2
													WHERE ctra2.type = 'GroupLevel'
														AND ((cada1.Claim_Closed_Flag ='Y' 
														AND ctra2.create_date <= dbo.udf_MinDay(
																				ISNULL(cada1.Date_Claim_Closed, cd._52WEEKS_), 
																						@remuneration_end, 
																						cd._52WEEKS_)
																)
														OR (cada1.Claim_Closed_Flag ='N' 
														AND ctra2.create_date <= dbo.udf_MinDay(cd._52WEEKS_, 
																						@remuneration_end, 
																						@remuneration_end)
															)
															)
					AND ctra2.item = ctra1.item ), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
		
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._52WEEKS_,
						  @remuneration_end, cd._52WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._52WEEKS_,
						  @remuneration_end, cd._52WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id) 
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
		
	UNION ALL
	
	/* Extract claims 78 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_78
			
			-- retrieve group info like 'HEM*'
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')	
								OR co.Grp NOT LIKE 'hosp%'
								THEN 'Miscellaneous'
							WHEN PATINDEX('HEM%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) + 2) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
							
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END
			,Case_manager = ISNULL ( UPPER(coa1.First_Name+' '+ coa1.Last_Name), 'Miscellaneous')
			,Group_ = dbo.udf_GetGroupByPolicyNo(cd.policyno)
			,Team_ = CASE WHEN rtrim(isnull(co.Grp,'')) = '' 
							then 'Miscellaneous' 
						else rtrim(UPPER(co.Grp)) 
					end
			,Case_manager_ = ISNULL ( UPPER(co.First_Name + ' ' + co.Last_Name), 'Miscellaneous')
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 78
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no
					,cla.injdate	
					,cla.policyno	
					,cla.portfolio
					,	(round(dbo.udf_MinValue(sum(cla.LT78_TRANS), 
													avg(CAP_CUR_78)) - dbo.udf_MinValue(sum(cla.LT78_TRANS_PRIOR), 
																							AVG(CAP_PRE_78)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
													avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																							AVG(CAP_PRE_52)), 10))
					) as LT
					, case when DAYS78_PRD_CALC < 0
								then 0 
							else round(dbo.udf_MinValue(1, 1.0 * DAYS78_PRD_CALC / nullif(DAYS78_CALC,0)), 10) 
						end as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_78WEEKS_
			FROM #measures cla
			WHERE cla.include_78 = 1 and cla.include_78_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_78WEEKS_, 
					DAYS78_PRD_CALC, 
					DAYS78_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT78_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT [id],item,value 
					FROM control_audit ctra1 
					WHERE type = 'GroupLevel') ctra1 
							ON (CHARINDEX('*'+coa1.grp+'*',ctra1.value)) <> 0 
								AND ctra1.id = ISNULL((SELECT MAX(ctra2.id) 
														FROM control_audit ctra2
														WHERE ctra2.type = 'GroupLevel'
															AND ((cada1.Claim_Closed_Flag ='Y' 
															AND ctra2.create_date <= dbo.udf_MinDay(
																			ISNULL(cada1.Date_Claim_Closed, cd._78WEEKS_), 
																					@remuneration_end, 
																					cd._78WEEKS_)
																)
															OR (cada1.Claim_Closed_Flag ='N' 
															AND ctra2.create_date <= dbo.udf_MinDay(cd._78WEEKS_, 
																					@remuneration_end, 
																					@remuneration_end)
																)
																)
					AND ctra2.item = ctra1.item ), '' )
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no			
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
	
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._78WEEKS_,
						  @remuneration_end, cd._78WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._78WEEKS_,
						  @remuneration_end, cd._78WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id)
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
					
	UNION ALL
	
	/* Extract claims 104 weeks from #measures table and some additional tables */
	--SELECT  Remuneration_Start = dateadd(mm, 1, @remuneration_start)
	--		,Remuneration_End = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_104
			
			-- retrieve group info like 'HEM*'
			,'Group' = CASE WHEN (rtrim(isnull(co.Grp,''))='') 
								OR NOT EXISTS (select distinct grp 
												from claims_officers 
												where active = 1 and len(rtrim(ltrim(grp))) > 0 
													  and grp like co.Grp+'%')
								OR co.Grp NOT LIKE 'hosp%'	
								THEN 'Miscellaneous'
							WHEN PATINDEX('HEM%', co.Grp) = 0 THEN Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1)
							ELSE SUBSTRING(Left(UPPER(rtrim(co.Grp)), 1) + Right(LOWER(rtrim(co.Grp)), len(rtrim(co.Grp))-1), 1, 
									CASE WHEN PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) > 0 
										THEN (PATINDEX('%[A-Z]%', 
												SUBSTRING(rtrim(co.Grp), 4, LEN(rtrim(co.Grp)) - 3)) + 2) 
										ELSE LEN(rtrim(co.Grp)) 
									END)
							END
							
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END		
			,Case_manager = ISNULL(UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')
			,Group_ = dbo.udf_GetGroupByPolicyNo(cd.policyno)
			,Team_ = CASE WHEN rtrim(isnull(co.Grp,'')) = '' 
							then 'Miscellaneous' 
						else rtrim(UPPER(co.Grp)) 
					end
			,Case_manager_ = ISNULL(UPPER(co.First_Name + ' ' + co.Last_Name), 'Miscellaneous')
			,Agency_id = ''
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,AgencyName = ''
			,Sub_category = ''
			,Measure = 104
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To	
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no
				,cla.injdate	
				,cla.policyno	
				,cla.portfolio
				,	(round(dbo.udf_MinValue(sum(cla.LT104_TRANS), 
									avg(CAP_CUR_104)) - dbo.udf_MinValue(sum(cla.LT104_TRANS_PRIOR), 
																AVG(CAP_PRE_104)), 10)
					- round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
									avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																AVG(CAP_PRE_52)), 10)
				) as LT					
				, case when DAYS104_PRD_CALC < 0 
							then 0 
						else round(dbo.udf_MinValue(1, 1.0 * DAYS104_PRD_CALC / nullif(DAYS104_CALC,0)), 10) 
					end as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_104WEEKS_
			FROM #measures cla 
			WHERE cla.include_104 = 1 and cla.include_104_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_104WEEKS_, 
					DAYS104_PRD_CALC, 
					DAYS104_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT104_TRANS),10) > 5		
		) as cd 
		
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.policyno = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT [id],item,value 
					FROM control_audit ctra1 
					WHERE type = 'GroupLevel') ctra1 
							ON (CHARINDEX('*'+coa1.grp+'*',ctra1.value)) <> 0 
								AND ctra1.id = ISNULL((SELECT MAX(ctra2.id) 
														FROM control_audit ctra2
														WHERE ctra2.type = 'GroupLevel'
															AND ((cada1.Claim_Closed_Flag ='Y' 
															AND ctra2.create_date <= dbo.udf_MinDay(
																	ISNULL(cada1.Date_Claim_Closed, cd._104WEEKS_), 
																			@remuneration_end, 
																			cd._104WEEKS_)
																)
															OR (cada1.Claim_Closed_Flag ='N' 
															AND ctra2.create_date <= dbo.udf_MinDay(cd._104WEEKS_, 
																			@remuneration_end, 
																			@remuneration_end)
																)
																)
					AND ctra2.item = ctra1.item ), '' )	
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no		
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
	
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._104WEEKS_,
						  @remuneration_end, cd._104WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._104WEEKS_,
						  @remuneration_end, cd._104WEEKS_))
		AND ptda.id = (SELECT MAX(ptda2.id) 
						FROM ptd_audit ptda2
						WHERE ptda2.policy_no = ptda.policy_no 
							and ptda2.create_date <= @remuneration_end)
		
	/* drop all temp table */
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL drop table #measures	
	/* end drop all temp table */
END--------------------------------  
-- END of D:\Projects\DbReleaseTool\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Projects\DbReleaseTool\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW_AddTargetAndBase.sql  
--------------------------------  
SET ANSI_NULLS OFF

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW] TO [DART_Role]
GO