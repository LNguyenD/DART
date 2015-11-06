
/****** Object:  StoredProcedure [dbo].[usp_FinancialPerformanceWeeklyBenefitPaymentsBreakdown]    Script Date: 01/04/2012 14:49:48 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_FinancialPerformanceWeeklyBenefitPaymentsBreakdown]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_FinancialPerformanceWeeklyBenefitPaymentsBreakdown]
GO


/****** Object:  StoredProcedure [dbo].[usp_FinancialPerformanceWeeklyBenefitPaymentsBreakdown]    Script Date: 01/04/2012 14:49:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- exec usp_FinancialPerformanceWeeklyBenefitPaymentsBreakdown '2009', '1', '2012', '4', '00002950163' 
create proc [dbo].[usp_FinancialPerformanceWeeklyBenefitPaymentsBreakdown]
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
	set @end_date = dbo.udf_GetLastDateByQuarter(@To_Quarter_Year,@To_Quarter_Quarter) + '23:59'	-- last day of quarter
	
	declare @PerfWklyBbfPmntsBd varchar(2024)
	
	--SELECT @PerfWklyBbfPmntsBd = Value FROM CONTROL 
	--				WHERE Type = 'PTypeList' AND 
	--				Item = 'PerfWklyBbfPmntsBd'
			
	create table #Payments
	(
		transaction_date datetime,
		payment_type varchar(16),
		Trans_amount money
	)		
	create table #tmpTotalPayments
	(
		[Quarter] int,
		[Year] int,
		--Financial_Year char(10),
		payment_type varchar(25),
		--Total_Paid money
		Trans_amount money
	)	

	insert into #Payments
	select pr.transaction_date,
		payment_type = case when pr.payment_type in ('WPT001', 'WPT003') then 'Section 36'
							when pr.payment_type in ('WPT002', 'WPT004') then 'Section 37'
							when pr.payment_type in ('WPP001', 'WPP003') then 'Section 38'
							when pr.payment_type in ('WPP002', 'WPP004') then 'Section 40' end,
		Trans_amount
	from payment_recovery pr join CLAIM_DETAIL cd on pr.Claim_no = cd.Claim_Number
	where cd.policy_no in (select * from dbo.udf_Split(@policies, ','))
		and pr.transaction_date between @start_date and @end_date
		and pr.trans_amount <> 0
		and pr.payment_type in ('WPT001', 'WPT003', 'WPT002', 'WPT004', 'WPP001', 'WPP003', 'WPP002', 'WPP004')
		
		
	insert into #tmpTotalPayments
	select
		[Quarter] = datepart(quarter, transaction_date),
		[Year] = year(transaction_date),	
		payment_type,
		Trans_amount
	from #Payments

	create table #TotalPayments
	(
		[Quarter] varchar(8),
		[Year] char(4),
		Financial_Year char(10),
		payment_type varchar(25),
		Total_Paid money
	)
	
	insert into #TotalPayments
	select [Quarter] = convert(varchar(4),[Year]) + ' Q' +  convert(varchar(1),[Quarter]),
		[Year],
		Financial_Year = case when [Quarter] = 1 or [Quarter] = 2 
									then convert(varchar(4),[Year] - 1) + '/' + convert(varchar(4),[Year])
									else convert(varchar(4),[Year]) + '/' + convert(varchar(4),[Year] + 1) end,
		payment_type,
		Total_Paid = SUM(Trans_amount)
	from #tmpTotalPayments
	group by [Year], [Quarter], payment_type	
		
	
	insert into #TotalPayments
	select [Quarter], [Year], [Financial_Year], payment_type = 'Weekly Benefits', Total_Paid = Sum(Total_Paid)
	from #TotalPayments
	group by [Quarter], [Year], [Financial_Year]
	
	insert into #TotalPayments
	select [Quarter], [Year], [Financial_Year], payment_type = 'Total Incapacity', Total_Paid = Sum(Total_Paid)
	from #TotalPayments
	where payment_type in ('Section 36', 'Section 37')
	group by [Quarter], [Year], [Financial_Year]
	
	insert into #TotalPayments
	select [Quarter], [Year], [Financial_Year], payment_type = 'Partial Incapacity', Total_Paid = Sum(Total_Paid)
	from #TotalPayments
	where payment_type in ('Section 38', 'Section 40')
	group by [Quarter], [Year], [Financial_Year]
	
	select * from #TotalPayments
	order by [Quarter]
	
	drop table #Payments
	drop table #tmpTotalPayments
	drop table #TotalPayments
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_FinancialPerformanceWeeklyBenefitPaymentsBreakdown]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_FinancialPerformanceWeeklyBenefitPaymentsBreakdown]  TO [emius]
GO
