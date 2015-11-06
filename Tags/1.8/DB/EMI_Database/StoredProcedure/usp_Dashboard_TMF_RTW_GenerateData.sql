SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
 
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_TMF_RTW_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_TMF_RTW_GenerateData]
GO
-- For example
-- exec [usp_Dashboard_TMF_RTW_GenerateData] 2012, 1
-- this will return all result from 2011/01/01 till now
CREATE PROCEDURE [dbo].[usp_Dashboard_TMF_RTW_GenerateData]
	@start_period_year int = 2010,
	@start_period_month int = 9
AS
BEGIN
	
	SET NOCOUNT ON;
	declare @transaction_Start datetime
	declare @remuneration_Start datetime
	declare @remuneration_End datetime
	declare @Transaction_lag int
	declare @SQL varchar(500)
	set @Transaction_lag = 3 --for only TMF	
	
	-----delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[TMF_RTW] 
			WHERE remuneration_end in (select distinct top '+@transaction_lag+' remuneration_end 
			from [DART].[dbo].[TMF_RTW] order by remuneration_end desc)')
	-----end delete--	
	
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) 
											+ '/' + CAST(@start_period_month as varchar) 
											+ '/01' as datetime)
	
	declare @end_period datetime = getdate()
	declare @loop_time int = datediff(month, @start_period, @end_period)
	declare @i int = @loop_time
	declare @yy int
	declare @mm int
	declare @temp datetime
	
	--Check temp table existing then drop
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery_Temp') IS NOT NULL DROP TABLE #uv_TMF_RTW_Payment_Recovery_Temp
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery') IS NOT NULL DROP TABLE #uv_TMF_RTW_Payment_Recovery
	--Check temp table existing then drop
	
	--create temp table 
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
	--end create temp table 
		
	WHILE (@i) >= 0
	BEGIN	
		set @temp = dateadd(mm, @i, @start_period)
		set @yy = year(@temp)
		set @mm = MONTH(@temp)			
		
		If NOT EXISTS(select 1 from [DART].[dbo].[TMF_RTW] 
							where Year(remuneration_end) = @yy and
							Month(remuneration_end ) = @mm)
			
			AND cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN	
			print cast(@yy as varchar) + ' and ' + cast(@mm as varchar)				
			print '--------------------delete first'
			
			--DELETE FROM  dbo.TMF_RTW 
			--	   WHERE Year(Remuneration_End) = @yy 
			--			 and Month(Remuneration_End) = @mm
			
			--delete data of temp table 		
			DELETE FROM #uv_TMF_RTW_Payment_Recovery_Temp
			DELETE FROM #uv_TMF_RTW_Payment_Recovery
			
			set @remuneration_End = DATEADD(mm
											, -@Transaction_lag + 1
											, CAST(CAST(@yy as varchar) 
														+ '/' 
														+  CAST(@mm as varchar) 
														+ '/01' as datetime))
			set @remuneration_Start = DATEADD(mm,-12, @remuneration_End)
			set @transaction_Start = DATEADD(YY, -3, @remuneration_Start) -- 2 years plus month lag is enough but 3 years for sure
						
			-- Insert into temptable filter S38, S40, TI
			INSERT	INTO #uv_TMF_RTW_Payment_Recovery_Temp
			SELECT  dbo.Payment_Recovery.Claim_No
					,submitted_trans_date=(CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte IS NOT NULL THEN						   
											   CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte <= CONVERT(datetime, CAST(dbo.Payment_Recovery.wc_Tape_Month AS varchar), 120) 
														THEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte 
													 ELSE dbo.Payment_Recovery.Transaction_date 
												END 
										  ELSE 
												CASE WHEN dbo.claim_payment_run.Paid_Date IS NOT NULL
														 THEN dbo.claim_payment_run.Paid_Date 
													 ELSE dbo.Payment_Recovery.Transaction_date 
												END 
										  END)
					,dbo.Payment_Recovery.Payment_Type
					,RTW_Payment_Type = (CASE WHEN payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003'
															,'WPT004', 'WPT005', 'WPT006', 'WPT007') 
												  THEN 'TI' 
											  WHEN payment_type IN ('16', 'WPP002', 'WPP004', 'WPP005'
															,'WPP006', 'WPP007', 'WPP008') 
												  THEN 'S40' 
											  WHEN payment_type IN ('13', 'WPP001','WPP003') 
												  THEN 'S38' 
										 END)
				   , dbo.Payment_Recovery.Trans_Amount
				   , dbo.Payment_Recovery.Payment_no
				   , dbo.Payment_Recovery.Period_Start_Date
				   , dbo.Payment_Recovery.Period_End_Date
				   , hours_per_week = ISNULL(dbo.Payment_Recovery.hours_per_week, 0) 
				   ,HOURS_WC = (CASE  WHEN Trans_Amount < 0 AND ( (isnull(WC_MINUTES, 0) / 60.0) 
																 + isnull(WC_HOURS, 0) 
																 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
																) > 0 
										 THEN - ((isnull(WC_MINUTES, 0) / 60.0) 
													+ isnull(WC_HOURS, 0) 
													+ isnull(WC_WEEKS * HOURS_PER_WEEK, 0)) 
									  ELSE  ((isnull(WC_MINUTES, 0) / 60.0) 
											 + isnull(WC_HOURS, 0) 
											 + isnull(WC_WEEKS * HOURS_PER_WEEK,0))
								END)
			FROM         dbo.Payment_Recovery 
							INNER JOIN  dbo.CLAIM_PAYMENT_RUN 
								ON dbo.Payment_Recovery.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
								 AND (dbo.Payment_Recovery.wc_Tape_Month IS NOT NULL 
									  AND LEFT(dbo.Payment_Recovery.wc_Tape_Month, 4) <= @yy) 
								 AND (dbo.Payment_Recovery.Transaction_date >= @transaction_Start) 
								 AND (dbo.Payment_Recovery.Payment_Type IN ('14', '15', 'WPT001', 'WPT002'
																			,'WPT003', 'WPT004', 'WPT005'
																			, 'WPT006', 'WPT007', '16'
																			, 'WPP002', 'WPP004','WPP005'
																			, 'WPP006', 'WPP007', 'WPP008'
																			, '13', 'WPP001', 'WPP003'))
			-- End Insert into temptable filter S38, S40, TI
			
			--Insert into temp table after combine transaction--
			INSERT INTO #uv_TMF_RTW_Payment_Recovery
			SELECT  claim_no
					, submitted_trans_date
					, RTW_Payment_Type
					, Period_Start_Date
					, Period_End_Date
					, hours_per_week
					, HOURS_WC = (SELECT SUM(hours_WC) 
									FROM   #uv_TMF_RTW_Payment_Recovery_Temp cla1 
									WHERE  cla1.Claim_No = cla.Claim_No 
										   and cla1.RTW_Payment_Type = cla.RTW_Payment_Type 
										   and cla1.Period_End_Date = cla.Period_End_Date 
										   and cla1.Period_Start_Date = cla.Period_Start_Date  
										   and Period_Start_Date <= @remuneration_End)
					, trans_amount = (SELECT SUM(trans_amount) 
										FROM #uv_TMF_RTW_Payment_Recovery_Temp cla1 
										WHERE cla1.Claim_No = cla.Claim_No 
										and cla1.RTW_Payment_Type = cla.RTW_Payment_Type 
										and cla1.Period_End_Date = cla.Period_End_Date 
										and cla1.Period_Start_Date = cla.Period_Start_Date
										and Period_Start_Date <= @remuneration_End)
			FROM #uv_TMF_RTW_Payment_Recovery_Temp cla 
			WHERE submitted_trans_date = (SELECT   min(cla1.submitted_trans_date) 
											FROM   #uv_TMF_RTW_Payment_Recovery_Temp cla1 
											WHERE  cla1.Claim_No = cla.Claim_No 
												   and cla1.RTW_Payment_Type = cla.RTW_Payment_Type 
												   and cla1.Period_End_Date = cla.Period_End_Date 
												   and cla1.Period_Start_Date = cla.Period_Start_Date 
												   and Period_Start_Date <= @remuneration_End)
			GROUP BY claim_no, submitted_trans_date, RTW_Payment_Type, Period_Start_Date, Period_End_Date, hours_per_week
			--End Insert into temp table after combine transaction--		
			--
			
			print '--------------------then insert'
			
			--INSERT INTO [TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 12
			--INSERT INTO [TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 6
			--INSERT INTO [TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 3
			--INSERT INTO [TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 1	
			
			INSERT INTO [Dart].[dbo].[TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 12
			INSERT INTO [Dart].[dbo].[TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 6
			INSERT INTO [Dart].[dbo].[TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 3
			INSERT INTO [Dart].[dbo].[TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 1			
			
			END
			SET @i = @i - 1 	   
		END	
	
	--drop all temp table 
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery') IS NOT NULL drop table #uv_TMF_RTW_Payment_Recovery
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery_Temp') IS NOT NULL drop table #uv_TMF_RTW_Payment_Recovery_Temp
	
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW_GenerateData] TO [DART_Role]
GO