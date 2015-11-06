/****** Object:  StoredProcedure [dbo].[usp_Dashboard_HEM_RTW_GenerateData]    Script Date: 12/26/2013 14:40:33 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_HEM_RTW_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_HEM_RTW_GenerateData]
GO

-- For example
-- exec [usp_Dashboard_HEM_RTW_GenerateData] 2013, 6
CREATE PROCEDURE [dbo].[usp_Dashboard_HEM_RTW_GenerateData]
	@start_period_year int = 2010,
	@start_period_month int = 11	
AS
BEGIN
	SET NOCOUNT ON;
	declare @SQL varchar(500)
	
	declare @measure_month_13 int
	declare @measure_month_26 int
	declare @measure_month_52 int
	declare @measure_month_78 int
	declare @measure_month_104 int
	
	declare @AsAt datetime
	declare @remuneration_start datetime
	declare @remuneration_end datetime
	
	declare @transaction_lag_remuneration_end datetime
	
	declare @paystartdt datetime
	declare @transaction_lag int	
	
	set @measure_month_13 = 3	-- 13weeks = 3
	set @measure_month_26 = 6	-- 26weeks = 6
	set @measure_month_52 = 12  -- 52weeks = 12
	set @measure_month_78 = 18  -- 78weeks = 18
	set @measure_month_104 = 24 -- 104weeks = 24	
	
	set @transaction_lag = 3 -- for HEM
	
	---delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[HEM_RTW] 
			WHERE remuneration_end in (select distinct top '+@transaction_lag+' remuneration_end 
			from [DART].[dbo].[HEM_RTW] order by remuneration_end desc)')
	---end delete--
	
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) + '/' 
										+ CAST(@start_period_month as varchar) + '/01' as datetime)
	declare @end_period datetime = DATEADD(MM, 0, getdate())
	
	declare @loop_time int = datediff(month, @start_period, @end_period)
	declare @i int = @loop_time
	declare @yy int
	declare @mm int
	declare @temp datetime
	
	-- Check temp table existing then drop
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL drop table #claim
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP TABLE #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP TABLE #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP TABLE #rtw_raworig_2
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL drop table #policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL DROP table #activity_detail_audit
	-- Check temp table existing then drop
	
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
	SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID)
		+ ' ON #claim(claim, policyno, injdate)'
	EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
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
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_temp_' + CONVERT(VARCHAR, @@SPID) 
		+ ' ON #rtw_raworig_temp(claim, payment_no)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
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
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_' + CONVERT(VARCHAR, @@SPID) 
		+ ' ON #rtw_raworig(claim, rtw_paytype, paydate)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
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
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_2_' + CONVERT(VARCHAR, @@SPID)
		+ ' ON #rtw_raworig_2(claim, rtw_paytype, paydate)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
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
	SET @SQL = 'CREATE INDEX pk_policy_' + CONVERT(VARCHAR, @@SPID)
		+ ' ON #policy(policyno, renewal_no)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
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
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	WHILE (@i) >= 0
	BEGIN	
		set @temp = dateadd(mm, @i, @start_period)
		set @yy = year(@temp)
		set @mm = month(@temp)
		
		/* delete all data in the temp tables */
		delete from #claim
		delete from #rtw_raworig_temp
		delete from #rtw_raworig
		delete from #rtw_raworig_2
		delete from #policy
		delete from #activity_detail_audit
		IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP TABLE #summary
		
		set @remuneration_end = cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
		set @remuneration_start = DATEADD(mm,-12, @remuneration_end) -- get max rolling month = 12
		--set @AsAt = DATEADD(dd, -1, DATEADD(mm, 1, @remuneration_end)) + '23:59'
		
		set @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'		
		set @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
		
		-- use transaction flag = 3
		set @AsAt = @transaction_lag_remuneration_end
		
		set @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_Start))
		
		
		If NOT EXISTS(select 1 from [DART].[dbo].[HEM_RTW] 
							where YEAR(remuneration_end) = YEAR(@remuneration_end) and
							MONTH(remuneration_end) = MONTH(@remuneration_end))
			AND cast(CAST(year(@remuneration_end) as varchar) + '/' +  CAST(month(@remuneration_end) as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN		
			print cast(YEAR(@remuneration_end) as varchar) + ' and ' + cast(MONTH(@remuneration_end) as varchar)
			print 'Start to delete data in HEM_RTW table first...'
			--delete from dbo.HEM_RTW
			--	   where year(Remuneration_End) = YEAR(@remuneration_end) 
			--			 and MONTH(Remuneration_End) = MONTH(@remuneration_end)
			
			/* retrieve claim detail info */
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
			
			/* retrieve transactions data */
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
			
			/* summarised transactions by claim, paydate, paytype, ppstart, ppend */
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
				
			/* retrieve claim policy info */
			INSERT INTO #policy
				SELECT	POLICY_NO
						, RENEWAL_NO
						, BTP					
						, WAGES0
						, Process_Flags					
					FROM dbo.PREMIUM_DETAIL pd
					WHERE EXISTS (SELECT 1 FROM #claim cd where cd.policyno = pd.POLICY_NO)
					ORDER BY POLICY_NO,RENEWAL_NO
				
			/* retrieve activity detail audit info */
			INSERT INTO #activity_detail_audit
				SELECT Policy_No, Renewal_No, Tariff, SUM(ISNULL(Wages_Shifts, 0))
					FROM ACTIVITY_DETAIL_AUDIT ada
					GROUP BY Policy_No, Renewal_No, Tariff
					HAVING EXISTS (SELECT 1 FROM #claim cd where cd.policyno = ada.Policy_No)
			
			print 'Start to insert data to HEM_RTW table...'
			
			--INSERT INTO dbo.HEM_RTW EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 12, @AsAt
			--INSERT INTO dbo.HEM_RTW EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 6, @AsAt
			--INSERT INTO dbo.HEM_RTW EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 3, @AsAt
			--INSERT INTO dbo.HEM_RTW EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 1, @AsAt
			
			INSERT INTO [Dart].[dbo].[HEM_RTW] EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 12, @AsAt
			INSERT INTO [Dart].[dbo].[HEM_RTW] EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 6, @AsAt
			INSERT INTO [Dart].[dbo].[HEM_RTW] EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 3, @AsAt
			INSERT INTO [Dart].[dbo].[HEM_RTW] EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 1, @AsAt			
			
		END
		SET @i = @i - 1
	END	
	
	-- drop all temp tables
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL drop table #claim
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP TABLE #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP TABLE #summary
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP TABLE #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP TABLE #rtw_raworig_2
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL drop table #policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL drop table #activity_detail_audit
	
END

SET ANSI_NULLS OFF

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW_GenerateData] TO [DART_Role]
GO