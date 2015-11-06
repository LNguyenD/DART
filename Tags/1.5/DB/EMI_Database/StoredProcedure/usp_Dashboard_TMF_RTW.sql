SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--  exec [usp_Dashboard_TMF_RTW] 2013, 3, 12 -- 2011M12
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_TMF_RTW]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_TMF_RTW]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_TMF_RTW]
	@yy int,
	@mm int,
	@RollingMonth int -- 1, 3, 6, 12
AS
BEGIN
	SET NOCOUNT ON;	
	IF OBJECT_ID('tempdb..#Tem_ClaimDetail') IS NOT NULL DROP TABLE #Tem_ClaimDetail
	IF OBJECT_ID('tempdb..#TEMP_MEASURES') IS NOT NULL DROP TABLE #TEMP_MEASURES		
	IF OBJECT_ID('tempdb..#TEMP_PREMIUM_DETAIL') IS NOT NULL DROP table #TEMP_PREMIUM_DETAIL
	
	declare @Measure_month_13 int
	declare @Measure_month_26 int
	declare @Measure_month_52 int
	declare @Measure_month_78 int
	declare @Measure_month_104 int
	declare @transaction_Start datetime
	declare @date_of_injury_Start datetime
	declare @remuneration_Start datetime
	declare @remuneration_End datetime
	declare @Transaction_lag int
	declare @Transaction_lag_Remuneration_End datetime
	declare @Transaction_lag_Remuneration_Start datetime

	set @Measure_month_13 =3  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Measure_month_26 =6  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Measure_month_52 =12  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Measure_month_78 =18  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Measure_month_104 =24  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Transaction_lag = 3 --for only TMF	

	set @remuneration_End = DATEADD(mm, -@Transaction_lag + 1, cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime))
	set @remuneration_Start = DATEADD(mm,-@RollingMonth, @remuneration_End)
	set @remuneration_End = DATEADD(dd, -1, @remuneration_End) + '23:59'
	set @Transaction_lag_Remuneration_End = DATEADD(MM, @Transaction_lag, @remuneration_End)
	set @Transaction_lag_Remuneration_Start =DATEADD(MM, @Transaction_lag, @remuneration_Start)
	
	
	set @transaction_Start = DATEADD(YY, -3, @remuneration_Start) -- 2 years plus month lag is enough but 3 years for sure

	print 'remuneration Start = ' + cast(@remuneration_Start as varchar)
	print 'remuneration End = ' + cast(@remuneration_End as varchar)
	print 'Transaction_lag = ' + cast(@Transaction_lag as varchar)
	declare @SQL varchar(500)
	
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery_Temp') IS NULL
	BEGIN
		CREATE TABLE #uv_TMF_RTW_Payment_Recovery_Temp
		(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,Payment_Type varchar(15)
		 ,RTW_Payment_Type varchar(3)
		 ,Trans_Amount money
		 ,Payment_no int
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,hours_per_week numeric(5,2)
		 ,HOURS_WC numeric(14,3)
		)

		SET @SQL = 'CREATE INDEX pk_uv_TMF_RTW_Payment_Recovery_Temp_'+CONVERT(VARCHAR, @@SPID)+' ON #uv_TMF_RTW_Payment_Recovery_Temp(Claim_No, Payment_no)'
			EXEC(@SQL)
		IF @@ERROR <>0
			BEGIN
				ROLLBACK TRAN
				RETURN
			END
				
		-- Insert into temptable filter S38, S40, TI
		insert into #uv_TMF_RTW_Payment_Recovery_Temp
		SELECT     dbo.Payment_Recovery.Claim_No, CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte IS NOT NULL 
							  THEN CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte <= CONVERT(datetime, CAST(dbo.Payment_Recovery.wc_Tape_Month AS varchar), 120) 
							  THEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte ELSE dbo.Payment_Recovery.Transaction_date END ELSE CASE WHEN dbo.claim_payment_run.Paid_Date IS NOT NULL
							   THEN dbo.claim_payment_run.Paid_Date ELSE dbo.Payment_Recovery.Transaction_date END END AS submitted_trans_date, 
							  dbo.Payment_Recovery.Payment_Type, CASE WHEN payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004', 'WPT005', 'WPT006', 'WPT007') 
							  THEN 'TI' WHEN payment_type IN ('16', 'WPP002', 'WPP004', 'WPP005', 'WPP006', 'WPP007', 'WPP008') THEN 'S40' WHEN payment_type IN ('13', 'WPP001', 
							  'WPP003') THEN 'S38' END AS RTW_Payment_Type, dbo.Payment_Recovery.Trans_Amount, dbo.Payment_Recovery.Payment_no, dbo.Payment_Recovery.Period_Start_Date, 
							  dbo.Payment_Recovery.Period_End_Date, ISNULL(dbo.Payment_Recovery.hours_per_week, 0) AS hours_per_week, 
							  CASE WHEN Trans_Amount < 0 AND ((isnull(WC_MINUTES, 0) / 60.0) + isnull(WC_HOURS, 0) 
							  + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)) > 0 THEN - (((isnull(WC_MINUTES, 0) / 60.0) + isnull(WC_HOURS, 0) 
							  + isnull(WC_WEEKS * HOURS_PER_WEEK, 0))) ELSE ((isnull(WC_MINUTES, 0) / 60.0) + isnull(WC_HOURS, 0) + isnull(WC_WEEKS * HOURS_PER_WEEK, 
							  0)) END AS HOURS_WC
		FROM         dbo.Payment_Recovery INNER JOIN
							  dbo.CLAIM_PAYMENT_RUN ON dbo.Payment_Recovery.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
							  and
			 (dbo.Payment_Recovery.wc_Tape_Month IS NOT NULL and LEFT(dbo.Payment_Recovery.wc_Tape_Month, 4) <= @yy) AND (dbo.Payment_Recovery.Transaction_date >= @transaction_Start) AND 
							  (dbo.Payment_Recovery.Payment_Type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004', 'WPT005', 'WPT006', 'WPT007', '16', 'WPP002', 'WPP004', 
							  'WPP005', 'WPP006', 'WPP007', 'WPP008', '13', 'WPP001', 'WPP003'))
		-- End Insert into temptable filter S38, S40, TI
	END
	
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery') IS NULL
	BEGIN
		CREATE TABLE #uv_TMF_RTW_Payment_Recovery
		(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,RTW_Payment_Type varchar(3)
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,hours_per_week numeric(5,2)
		 ,HOURS_WC numeric(14,3)
		 ,Trans_Amount money 
		)

		SET @SQL = 'CREATE INDEX pk_uv_TMF_RTW_Payment_Recovery_'+CONVERT(VARCHAR, @@SPID)+' ON #uv_TMF_RTW_Payment_Recovery(Claim_no, RTW_Payment_Type, submitted_trans_date)'
			EXEC(@SQL)
		IF @@ERROR <>0
			BEGIN
				ROLLBACK TRAN
				RETURN
			END	
		--Insert into temp table after combine transaction--
		insert into #uv_TMF_RTW_Payment_Recovery
		select claim_no, submitted_trans_date, RTW_Payment_Type, Period_Start_Date, Period_End_Date, hours_per_week
				,HOURS_WC = (select SUM(hours_WC) from #uv_TMF_RTW_Payment_Recovery_Temp cla1 where cla1.Claim_No = cla.Claim_No and cla1.RTW_Payment_Type = cla.RTW_Payment_Type and cla1.Period_End_Date = cla.Period_End_Date and cla1.Period_Start_Date = cla.Period_Start_Date  and Period_Start_Date <= @remuneration_End)
				,trans_amount = (select SUM(trans_amount) from #uv_TMF_RTW_Payment_Recovery_Temp cla1 where cla1.Claim_No = cla.Claim_No and cla1.RTW_Payment_Type = cla.RTW_Payment_Type and cla1.Period_End_Date = cla.Period_End_Date and cla1.Period_Start_Date = cla.Period_Start_Date and Period_Start_Date <= @remuneration_End)
		from #uv_TMF_RTW_Payment_Recovery_Temp cla 
		where submitted_trans_date = (select min(cla1.submitted_trans_date) 
					from #uv_TMF_RTW_Payment_Recovery_Temp cla1 
					where cla1.Claim_No = cla.Claim_No 
					and cla1.RTW_Payment_Type = cla.RTW_Payment_Type 
					and cla1.Period_End_Date = cla.Period_End_Date 
					and cla1.Period_Start_Date = cla.Period_Start_Date 
					and Period_Start_Date <= @remuneration_End)
		group by claim_no, submitted_trans_date, RTW_Payment_Type, Period_Start_Date, Period_End_Date, hours_per_week
		--End Insert into temp table after combine transaction--
	END
	
	--Delete reversed transactions--
	delete from #uv_TMF_RTW_Payment_Recovery where (HOURS_WC = 0 and RTW_Payment_Type = 'TI') or Trans_amount = 0
	--End Delete reversed transactions--

	CREATE TABLE #Tem_ClaimDetail
	(
	   Claim_Number CHAR(19)
	   ,Policy_No CHAR(19)
	   ,Renewal_No INT
	   ,Date_of_Injury DATETIME
	   ,Work_Hours NUMERIC(5,2) 
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

	SET @SQL = 'CREATE INDEX pk_Tem_ClaimDetail_Temp_'+CONVERT(VARCHAR, @@SPID)+' ON #Tem_ClaimDetail(Claim_Number, Policy_No, Date_of_Injury)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		 
		INSERT INTO #Tem_ClaimDetail
		SELECT cd.Claim_Number,cda.Policy_No, Renewal_No,cd.Date_of_Injury,cd.Work_Hours		
				, _13WEEKS_ = dateadd(mm, @Measure_month_13, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))	
				, _26WEEKS_ = dateadd(mm, @Measure_month_26, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))			
				, _52WEEKS_ = dateadd(mm, @Measure_month_52, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))			
				, _78WEEKS_ = dateadd(mm, @Measure_month_78, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))			
				, _104WEEKS_ = dateadd(mm, @Measure_month_104, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))			
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
			AND cda.Fund <> 98
			AND isnull(cd.Claim_Number,'') <> ''
			AND cd.Date_of_Injury >= @transaction_Start
			AND cda.id = (select max(id) from cd_audit cda1 where cda1.claim_no = cd.claim_number and cda1.create_date < @Transaction_lag_Remuneration_End)
	update #Tem_ClaimDetail set DAYS13 = dbo.udf_NoOfDaysWithoutWeekend(Date_of_Injury, _13WEEKS_) + case when datepart(dw,Date_of_Injury) not IN(1,7) then 1 else 0 end
							,   DAYS26 = dbo.udf_NoOfDaysWithoutWeekend(Date_of_Injury, _26WEEKS_) + case when datepart(dw,Date_of_Injury) not IN(1,7) then 1 else 0 end
							,   DAYS52 = dbo.udf_NoOfDaysWithoutWeekend(_26WEEKS_, _52WEEKS_) + case when datepart(dw,_26WEEKS_) not IN(1,7) then 1 else 0 end
							,   DAYS78 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _78WEEKS_) + case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end
							,   DAYS104 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _104WEEKS_) + case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end
							,	DAYS13_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(Date_of_Injury, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(Date_of_Injury, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
							,	DAYS26_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(Date_of_Injury, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(Date_of_Injury, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
							,	DAYS52_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
							,	DAYS78_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
							,	DAYS104_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end

	CREATE TABLE #TEMP_PREMIUM_DETAIL
		(
		POLICY_NO CHAR(19),
		WAGES0 MONEY,
		BTP MONEY,
		RENEWAL_NO INT
		)
		
		
		SET @SQL = 'CREATE INDEX pk_TEMP_PREMIUM_DETAIL_Temp_'+CONVERT(VARCHAR, @@SPID)+' ON #TEMP_PREMIUM_DETAIL(POLICY_NO, RENEWAL_NO)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
	INSERT INTO #TEMP_PREMIUM_DETAIL
		SELECT POLICY_NO,WAGES0,BTP,RENEWAL_NO
				FROM PREMIUM_DETAIL pd
				WHERE EXISTS (SELECT 1 FROM #Tem_ClaimDetail cd where cd.policy_no = pd.POLICY_NO)
				ORDER BY POLICY_NO,RENEWAL_NO


	create table #TEMP_MEASURES
	 (
		Claim_No CHAR(19)	
		,Policy_No VARCHAR(19)	
		,Date_of_Injury DATETIME
		,Period_Start_Date DATETIME
		,Period_End_Date DATETIME
		,PaymentType varchar(3)
		,LT_S38 FLOAT
		,LT_S40 FLOAT
		,LT_TI FLOAT
		,Trans_Amount MONEY
		,hours_per_week_adjusted float	
		,Weeks_Paid_adjusted float	
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
		,[DAYS] int
		,_13WEEKS_ DATETIME
		,_26WEEKS_ DATETIME
		,_52WEEKS_ DATETIME
		,_78WEEKS_ DATETIME
		,_104WEEKS_ DATETIME
		,EMPL_SIZE varchar(256)
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
	 SET @SQL = 'CREATE INDEX pk_TEMP_MEASURES_'+CONVERT(VARCHAR, @@SPID)+' ON #TEMP_MEASURES(Claim_no,Policy_No, Date_of_Injury)'
		EXEC(@SQL)
	IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
			
	insert into #TEMP_MEASURES
	SELECT distinct pr.Claim_No, cd.Policy_No,Date_of_Injury
			,pr.Period_Start_Date
			,pr.Period_End_Date
			,RTW_Payment_Type
			,LT_S38 = case when RTW_Payment_Type = 'S38' and (case when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end) = 0 then 0
								when RTW_Payment_Type = 'S38' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) >= 35 
									then 1.0*case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end * dbo.udf_CheckPositiveOrNegative(Trans_Amount) 
								when RTW_Payment_Type = 'S38' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) < 35  and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) > 0 
									then 1.0*case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end * dbo.udf_CheckPositiveOrNegative(Trans_Amount) * (dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end))/37.5)
								else 0 END
			,LT_S40 = case when RTW_Payment_Type = 'S40' and 
			
			(case when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
									end) = 0 then 0
								when RTW_Payment_Type = 'S40' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) >= 35 
									then 1.0*case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end * 0.75 * dbo.udf_CheckPositiveOrNegative(Trans_Amount) 
								when RTW_Payment_Type = 'S40' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) < 35
									then 1.0*case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end* 0.75 * dbo.udf_CheckPositiveOrNegative(Trans_Amount) * (dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end))/37.5)
								else 0 END
			,LT_TI =  case when RTW_Payment_Type = 'TI' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) >= 35 
									then 1.0 * (pr.HOURS_WC* 5 ) / nullif(dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)),0) * dbo.udf_CheckPositiveOrNegative(Trans_Amount)
								 when RTW_Payment_Type = 'TI' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) < 35 
									then 1.0 * (pr.HOURS_WC * 5 / 37.5)* dbo.udf_CheckPositiveOrNegative(Trans_Amount)	
								else 0 END 
			,Trans_Amount
			,hours_per_week_adjusted = dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end))		
			,Weeks_Paid_adjusted = 1.0 * pr.HOURS_WC / nullif(dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)),0)
			------13 weeks-------
			,CAP_CUR_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)		
			,CAP_PRE_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			
			,DAYS13_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _13WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), Period_End_Date))) end
									
									else 0 end		
			,DAYS13_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _13WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _13WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _13WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _13WEEKS_), Period_End_Date))) end
									
									else 0 end		
			,LT13_TRANS = 0
			,LT13_TRANS_PRIOR = 0
			,LT13 = 0
			------26 weeks-------
			,CAP_CUR_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)		
			,CAP_PRE_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			
			,DAYS26_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _26WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _26WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _26WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _26WEEKS_), Period_End_Date))) end
									
									else 0 end		
			,DAYS26_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _26WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _26WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _26WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _26WEEKS_), Period_End_Date))) end
									
									else 0 end		
			,LT26_TRANS = 0
			,LT26_TRANS_PRIOR = 0
			,LT26 = 0
			------52 weeks-------
			,CAP_CUR_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,CAP_PRE_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,DAYS52_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _52WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _52WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _52WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _52WEEKS_), Period_End_Date))) end
									
									else 0 end
			,DAYS52_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _52WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _52WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _52WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _52WEEKS_), Period_End_Date))) end
									
									else 0 end
			,LT52_TRANS = 0
			,LT52_TRANS_PRIOR = 0
			,LT52 = 0
			------ 78 weeks-------
			,CAP_CUR_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,CAP_PRE_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,DAYS78_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _78WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _78WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _78WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _78WEEKS_), Period_End_Date))) end
									
									else 0 end
			,DAYS78_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _78WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _78WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _78WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _78WEEKS_), Period_End_Date))) end
									
									else 0 end
			,LT78_TRANS = 0
			,LT78_TRANS_PRIOR = 0
			,LT78 = 0
			------ 104 weeks-------
			,CAP_CUR_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,CAP_PRE_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,DAYS104_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _104WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _104WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _104WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _104WEEKS_), Period_End_Date))) end
									
									else 0 end
			,DAYS104_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _104WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _104WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _104WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _104WEEKS_), Period_End_Date))) end
									
									else 0 end
			,LT104_TRANS = 0
			,LT104_TRANS_PRIOR = 0
			,LT104 = 0
			,include_13_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _13WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_26_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _26WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_52_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _52WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_78_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _78WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_104_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _104WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_13 = case when (Date_of_Injury between @remuneration_Start and @remuneration_End) or (_13WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  Date_of_Injury and _13WEEKS_) or (@remuneration_End between  Date_of_Injury and _13WEEKS_) then 1 else 0 end
			,include_26 = case when (Date_of_Injury between @remuneration_Start and @remuneration_End) or (_26WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  Date_of_Injury and _26WEEKS_) or (@remuneration_End between  Date_of_Injury and _26WEEKS_) then 1 else 0 end
			,include_52 = case when (_26WEEKS_ between @remuneration_Start and @remuneration_End) or (_52WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  _26WEEKS_ and _52WEEKS_) or (@remuneration_End between  _26WEEKS_ and _52WEEKS_) then 1 else 0 end
			,include_78 = case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) or (_78WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  _52WEEKS_ and _78WEEKS_) or (@remuneration_End between  _52WEEKS_ and _78WEEKS_) then 1 else 0 end
			,include_104 = case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) or (_104WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  _52WEEKS_ and _104WEEKS_) or (@remuneration_End between  _52WEEKS_ and _104WEEKS_) then 1 else 0 end		
			,Total_LT = 0			
			,[DAYS] = case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end
			,_13WEEKS_
			,_26WEEKS_ 
			,_52WEEKS_ 
			,_78WEEKS_ 
			,_104WEEKS_
			,EMPL_SIZE = CASE WHEN pd.BTP > 500000 then 'L' 
							 WHEN pd.BTP < 10000 or pd.WAGES0 < 300000 THEN 'S' 
							 ELSE 'M' end 								 
			,DAYS13_PRD_CALC = DAYS13_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_13WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS26_PRD_CALC = DAYS26_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_26WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS52_PRD_CALC = DAYS52_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_52WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS78_PRD_CALC = DAYS78_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_78WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS104_PRD_CALC = DAYS104_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_104WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS13_CALC = DAYS13 + case when  DATEPART(dw,_13WEEKS_) not in (1, 7)  then -1 else 0 end
			,DAYS26_CALC = DAYS26 + case when  DATEPART(dw,_26WEEKS_) not in (1, 7)  then -1 else 0 end
			,DAYS52_CALC = DAYS52 + case when  DATEPART(dw,_52WEEKS_) not in (1, 7)  then -1 else 0 end
			,DAYS78_CALC = DAYS78 + case when  DATEPART(dw,_78WEEKS_) not in (1, 7)  then -1 else 0 end
			,DAYS104_CALC = DAYS104 + case when  DATEPART(dw,_104WEEKS_) not in (1, 7)  then -1 else 0 end		

		  FROM #Tem_ClaimDetail cd INNER JOIN #uv_TMF_RTW_Payment_Recovery pr ON cd.Claim_Number = pr.Claim_No		
				LEFT JOIN #TEMP_PREMIUM_DETAIL pd ON pd.POLICY_NO = cd.Policy_No AND pd.RENEWAL_NO = cd.Renewal_No
			AND PR.Period_Start_Date <= @remuneration_End						

	-- Update LT_TRANS and LT_TRANS_PRIOR
	update #TEMP_MEASURES set LT13_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS13_TRANS / nullif([DAYS],0)
											end
							,LT13_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS13_TRANS_PRIOR / nullif([DAYS],0)
											end 
							,LT26_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS26_TRANS / nullif([DAYS],0)
											end
							,LT26_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS26_TRANS_PRIOR / nullif([DAYS],0)
											end
							,LT52_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS52_TRANS / nullif([DAYS],0)
											end
							,LT52_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS52_TRANS_PRIOR / nullif([DAYS],0)
											end
							,LT78_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS78_TRANS / nullif([DAYS],0)
											end
							,LT78_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS78_TRANS_PRIOR / nullif([DAYS],0)
											end
							,LT104_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS104_TRANS / nullif([DAYS],0)
											end
							,LT104_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS104_TRANS_PRIOR / nullif([DAYS],0)
											end
							,Total_LT = (LT_S38 + LT_S40 + LT_TI) 
										* case when Period_End_Date <= @remuneration_End or [DAYS]=0 then 1 
												when Period_Start_Date > @remuneration_End then 0
											else 1.0 * dbo.udf_NoOfDaysWithoutWeekend(Period_Start_Date, @remuneration_End) / nullif([DAYS],0)
											end						

	-- End update LT_TRANS and LT_TRANS_PRIOR

	--Delete small transactions
	DELETE FROM #TEMP_MEASURES WHERE (
		CASE WHEN PaymentType in ('S40') and [DAYS] <> 0 AND hours_per_week_adjusted >=35 and (1.0 * Trans_Amount / nullif([DAYS],0)) < 2 then 1
			 WHEN PaymentType in ('S40') and [DAYS] <> 0 AND hours_per_week_adjusted < 35 and (1.0 * Trans_Amount / nullif((([DAYS]*hours_per_week_adjusted) / 37.5),0)) < 2   then 1 
			 WHEN PaymentType in ('S40') and [DAYS] = 0 AND LT_S40 <> 0 and (1.0 * Trans_Amount / nullif(LT_S40,0)) < 2 then 1
		ELSE 0
		END = 1)
		
	DELETE FROM #TEMP_MEASURES WHERE (
		CASE WHEN PaymentType in ('S38','TI') and (LT_TI + LT_S38) <> 0 and (1.0 * Trans_Amount / nullif((LT_TI + LT_S38),0)) < 20 then 1
		ELSE 0
		END = 1)
	--End Delete small transactions


	SET @SQL = 'CREATE NONCLUSTERED INDEX Pk_TEMP_MEASURES
				ON [dbo].[#TEMP_MEASURES] ([include_104],[include_104_trans])
				INCLUDE ([Claim_No],[Policy_No],[Date_of_Injury],[CAP_CUR_52],[CAP_PRE_52],[LT52_TRANS],[LT52_TRANS_PRIOR],[CAP_CUR_104],[CAP_PRE_104],[LT104_TRANS],[LT104_TRANS_PRIOR],[Total_LT],[_52WEEKS_],[_104WEEKS_],[EMPL_SIZE],[DAYS104_PRD_CALC],[DAYS104_CALC], [Weeks_Paid_adjusted])'
		EXEC(@SQL)
	IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
	
	-------List Claims 13 weeks----
	select  'Remuneration_Start' = @Transaction_lag_Remuneration_Start
			,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_13
			,'Group' = dbo.udf_GetGroupByPolicyNo(cd.Policy_no)
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')			
			,Agency_id = UPPER(ptda.Agency_id)
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no) AS AgencyName
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Measure = 13
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
			
	from (
			SELECT rtrim(cla.claim_no) as Claim_no
					,cla.Date_of_Injury
					,cla.Policy_No	
					,round(dbo.udf_MinValue(sum(cla.LT13_TRANS), avg(CAP_CUR_13)) - dbo.udf_MinValue(sum(cla.LT13_TRANS_PRIOR), AVG(CAP_PRE_13)), 10) as LT										
					,round(dbo.udf_MinValue(1, 1.0 * DAYS13_PRD_CALC / nullif(DAYS13_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_13WEEKS_
			FROM #TEMP_MEASURES cla where cla.include_13 = 1 and cla.include_13_trans = 1
			GROUP BY cla.claim_no,Policy_No,cla.Date_of_Injury,_13WEEKS_,DAYS13_PRD_CALC, DAYS13_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT13_TRANS),2) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias 
		INNER JOIN ptd_audit ptda ON cd.POLICY_NO = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		
		
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
		AND ptda.id = (SELECT MAX(ptda2.id) FROM ptd_audit ptda2
				WHERE ptda2.policy_no = ptda.policy_no and ptda2.create_date <= @Transaction_lag_Remuneration_End)
					
	union all
	--List Claims 26 weeks--
	select  'Remuneration_Start' = @Transaction_lag_Remuneration_Start
			,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_26
			,'Group' = dbo.udf_GetGroupByPolicyNo(cd.Policy_no)
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')			
			,Agency_id = UPPER(ptda.Agency_id)
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no) AS AgencyName
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Measure = 26
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
			
	from (
			SELECT rtrim(cla.claim_no) as Claim_no
				,cla.Date_of_Injury
				,cla.Policy_No
				,round(dbo.udf_MinValue(sum(cla.LT26_TRANS), avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), AVG(CAP_PRE_26)), 10) as LT								
				,round(dbo.udf_MinValue(1, 1.0 * DAYS26_PRD_CALC / nullif(DAYS26_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_26WEEKS_
			FROM #TEMP_MEASURES cla where cla.include_26 = 1 and cla.include_26_trans = 1
			GROUP BY cla.claim_no,Policy_No,cla.Date_of_Injury,_26WEEKS_,DAYS26_PRD_CALC, DAYS26_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT26_TRANS),2) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.POLICY_NO = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null ), '')		
		
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
		AND ptda.id = (SELECT MAX(ptda2.id) FROM ptd_audit ptda2
				WHERE ptda2.policy_no = ptda.policy_no and ptda2.create_date <= @Transaction_lag_Remuneration_End)
		
	union all
	---List Claims 52 weeks----
	select  'Remuneration_Start' = @Transaction_lag_Remuneration_Start
			,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_52
			,'Group' = dbo.udf_GetGroupByPolicyNo(cd.Policy_no)
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')			
			,Agency_id = UPPER(ptda.Agency_id)
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no) AS AgencyName
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Measure = 52
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
			
	from (
			SELECT	rtrim(cla.claim_no) as Claim_no	
					,cla.Date_of_Injury	
					,cla.Policy_No	
					,	(round(dbo.udf_MinValue(sum(cla.LT52_TRANS), avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), AVG(CAP_PRE_52)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT26_TRANS), avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), AVG(CAP_PRE_26)), 10))
					) as LT											
					,round(dbo.udf_MinValue(1, 1.0 * DAYS52_PRD_CALC / nullif(DAYS52_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_52WEEKS_
			FROM #TEMP_MEASURES cla 
			WHERE cla.include_52 = 1 and cla.include_52_trans = 1
			GROUP BY cla.claim_no,cla.Policy_No,cla.Date_of_Injury,_52WEEKS_,DAYS52_PRD_CALC, DAYS52_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT52_TRANS),2) > 5	
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no		
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.POLICY_NO = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')		
		
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
		AND ptda.id = (SELECT MAX(ptda2.id) FROM ptd_audit ptda2
				WHERE ptda2.policy_no = ptda.policy_no and ptda2.create_date <= @Transaction_lag_Remuneration_End)		

	union all
	---List Claims 78 weeks----
	select  'Remuneration_Start' = @Transaction_lag_Remuneration_Start
			,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_78
			,'Group' = dbo.udf_GetGroupByPolicyNo(cd.Policy_no)
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')			
			,Agency_id = UPPER(ptda.Agency_id)
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no) AS AgencyName
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Measure = 78
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
			
	from (
			SELECT	rtrim(cla.claim_no) as Claim_no	
					,cla.Date_of_Injury	
					,cla.Policy_No	
					,	(round(dbo.udf_MinValue(sum(cla.LT78_TRANS), avg(CAP_CUR_78)) - dbo.udf_MinValue(sum(cla.LT78_TRANS_PRIOR), AVG(CAP_PRE_78)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT52_TRANS), avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), AVG(CAP_PRE_52)), 10))
					) as LT												
					,round(dbo.udf_MinValue(1, 1.0 * DAYS78_PRD_CALC / nullif(DAYS78_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_78WEEKS_
			FROM #TEMP_MEASURES cla 
			WHERE cla.include_78 = 1 and cla.include_78_trans = 1
			GROUP BY cla.claim_no,cla.Policy_No,cla.Date_of_Injury,_78WEEKS_, DAYS78_PRD_CALC, DAYS78_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT78_TRANS),2) > 5	
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no		
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.POLICY_NO = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')		
		
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
		AND ptda.id = (SELECT MAX(ptda2.id) FROM ptd_audit ptda2
				WHERE ptda2.policy_no = ptda.policy_no and ptda2.create_date <= @Transaction_lag_Remuneration_End)		
		
	union all
	---List Claims 104 weeks----
	select  Remuneration_Start = @Transaction_lag_Remuneration_Start
			,Remuneration_End = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_104
			,'Group' = dbo.udf_GetGroupByPolicyNo(cd.Policy_no)
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')			
			,Agency_id = UPPER(ptda.Agency_id)
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,dbo.udf_GetAgencyNameByPolicyNo(cd.Policy_no) AS AgencyName
			,Sub_category = rtrim(dbo.udf_GetSubCategoryByPolicyNo(cd.Policy_no))
			,Measure = 104
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
					
	from (
			SELECT	rtrim(cla.claim_no) as Claim_no	
				,cla.Date_of_Injury	
				,cla.Policy_No	
				,	(round(dbo.udf_MinValue(sum(cla.LT104_TRANS), avg(CAP_CUR_104)) - dbo.udf_MinValue(sum(cla.LT104_TRANS_PRIOR), AVG(CAP_PRE_104)), 10)
					- round(dbo.udf_MinValue(sum(cla.LT52_TRANS), avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), AVG(CAP_PRE_52)), 10)
				) as LT
				,round(dbo.udf_MinValue(1, 1.0 * DAYS104_PRD_CALC / nullif(DAYS104_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_104WEEKS_
			FROM #TEMP_MEASURES cla 
			WHERE cla.include_104 = 1 and cla.include_104_trans = 1
			GROUP BY cla.claim_no,cla.Policy_No,cla.Date_of_Injury,_104WEEKS_, DAYS104_PRD_CALC, DAYS104_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT104_TRANS),2) > 5		
		) as cd 
		
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no		
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		INNER JOIN ptd_audit ptda ON cd.POLICY_NO = ptda.Policy_No
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
		AND ptda.id = (SELECT MAX(ptda2.id) FROM ptd_audit ptda2
				WHERE ptda2.policy_no = ptda.policy_no and ptda2.create_date <= @Transaction_lag_Remuneration_End)		
		

	--Drop all temp table--
	/*
	drop table #uv_TMF_RTW_Payment_Recovery
	drop table #uv_TMF_RTW_Payment_Recovery_Temp
	*/
	IF OBJECT_ID('tempdb..#Tem_ClaimDetail') IS NOT NULL drop table #Tem_ClaimDetail
	IF OBJECT_ID('tempdb..#TEMP_PREMIUM_DETAIL') IS NOT NULL drop table #TEMP_PREMIUM_DETAIL
	IF OBJECT_ID('tempdb..#TEMP_MEASURES') IS NOT NULL drop table #TEMP_MEASURES	
	--End Drop all temp table--

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW] TO [DART_Role]
GO