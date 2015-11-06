
/****** Object:  StoredProcedure [dbo].[usp_FinancialPerformanceMedicalPaymentsBreakdown]    Script Date: 01/04/2012 14:53:25 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_FinancialPerformanceMedicalPaymentsBreakdown]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_FinancialPerformanceMedicalPaymentsBreakdown]
GO


/****** Object:  StoredProcedure [dbo].[usp_FinancialPerformanceMedicalPaymentsBreakdown]    Script Date: 01/04/2012 14:53:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec usp_FinancialPerformanceMedicalPaymentsBreakdown '2009', '1', '2012', '4', '00002950163' 
CREATE proc [dbo].[usp_FinancialPerformanceMedicalPaymentsBreakdown]
	@From_Quarter_Year char(4),
	@From_Quarter_Quarter char(1),
	@To_Quarter_Year char(4),
	@To_Quarter_Quarter char(1),
	@policies varchar(8000)
as
begin
	declare @start_date datetime
	declare @end_date datetime
	set @start_date =   [dbo].[udf_GetFirstDateByQuarter](@From_Quarter_Year,@From_Quarter_Quarter) -- first day of quarter
	set @end_date = dbo.udf_GetLastDateByQuarter(@To_Quarter_Year,@To_Quarter_Quarter) 	-- last day of quarter

	declare @PerfMedicalPmntsBd varchar(2024)
	
	SELECT @PerfMedicalPmntsBd = Value FROM CONTROL 
					WHERE Type = 'PTypeList' AND 
					Item = 'PerfMedicalPmntsBd'
	create table #tmpTotalPayments
	(
		[Quarter] int,
		[Year] int,
		payment_type varchar(55),
		Trans_amount MONEY		
	)		
	insert into #tmpTotalPayments	
	select 
		[Quarter] = datepart(quarter, transaction_date),
		[Year] = year(transaction_date),
		--Financial_Year = case when datepart(quarter, transaction_date) = 1 or datepart(quarter, transaction_date) = 2 
		--							then convert(varchar(4),year(transaction_date) - 1) + '/' + convert(varchar(4),year(transaction_date))
		--							else convert(varchar(4),year(transaction_date)) + '/' + convert(varchar(4),year(transaction_date) + 1) end,
		payment_type = case	when left(pr.payment_type, 3) = 'WCO' then 'Total Medical / NTD services payments'
							when left(pr.payment_type, 3) in ('PTA', 'PTX') then 'Total Physiotherapy payments'
							when left(pr.payment_type, 3) in ('CHA', 'CHX', 'DEN', 'EPA', 'OSA', 'OSX', 'RMA', 'OPT', 'OTT', 'OAS' ) then 'Total Other allied health / treatment payments' 
							when left(pr.payment_type, 3) = 'DOA' or pr.payment_type in ('NUR001', 'PCA001') then 'Total Domestic assistance payments'
							when left(pr.payment_type, 3) = 'HVM' or pr.payment_type in ('OAD001', 'MOB001') then 'Total Aids and equipment payments'
							when left(pr.payment_type, 3) in ('PUH', 'PBI', 'PSI', 'PHR', 'PTH' ) then 'Total Hospital payments'
							end,
			
		Trans_amount
	from payment_recovery pr join CLAIM_DETAIL cd on pr.Claim_no = cd.Claim_Number
			join payment_types pt on pt.payment_type = pr.payment_type
	where cd.policy_no in (select * from dbo.udf_Split(@policies, ','))
		and pr.transaction_date between @start_date and @end_date
		and pr.trans_amount <> 0
		and(
				(CHARINDEX('*' + pr.Payment_Type + '*', @PerfMedicalPmntsBd) > 0) 
				OR
				(	NOT (CHARINDEX('*-' + pr.wc_payment_type + '*', @PerfMedicalPmntsBd) > 0) 
					AND CHARINDEX('*' + RTRIM(pt.Payment_Group) + '?*', @PerfMedicalPmntsBd) > 0
				)
			)
	
			
	select 
		[Quarter] = convert(varchar(4), [Year]) + ' Q' + convert(varchar(4), [Quarter]),
		[Year],
		Financial_Year = case when [Quarter] = 1 or [Quarter] = 2 
									then convert(varchar(4),[Year] - 1) + '/' + convert(varchar(4),[Year])
									else convert(varchar(4),[Year]) + '/' + convert(varchar(4),[Year] + 1) end,
		payment_type,
		Total_paid = sum(Trans_amount),
		Total = 
		CASE ROW_NUMBER() OVER (PARTITION BY [Quarter], [Year] ORDER BY [Year]) 
		WHEN 1 THEN 
		(Select SUM(gross) from payment_recovery pr	join claim_detail cd on cd.claim_number = pr.claim_no  WHERE 
		(DATEPART(quarter,transaction_date) =[Quarter] AND DATEPART(YEAR,Transaction_date) = 
		[Year]) and  policy_no = ''+@policies+'' and ESTIMATE_TYPE = '55')
		ELSE 0		
		END

	from #tmpTotalPayments
	group by payment_type, [Quarter], [Year]
	order by convert(varchar(4), [Year]) + ' Q' + convert(varchar(4), [Quarter])
	
	drop table #tmpTotalPayments
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_FinancialPerformanceMedicalPaymentsBreakdown]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_FinancialPerformanceMedicalPaymentsBreakdown]  TO [emius]
GO


