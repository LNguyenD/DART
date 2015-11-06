

/****** Object:  StoredProcedure [dbo].[usp_FinancialPerformanceTotalClaimsCosts]    Script Date: 01/04/2012 14:41:09 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_FinancialPerformanceTotalClaimsCosts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_FinancialPerformanceTotalClaimsCosts]
GO

/****** Object:  StoredProcedure [dbo].[usp_FinancialPerformanceTotalClaimsCosts]    Script Date: 01/04/2012 14:41:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- exec usp_FinancialPerformanceTotalClaimsCosts '2009', '1', '2012', '4', '00002950163'

create proc [dbo].[usp_FinancialPerformanceTotalClaimsCosts]
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
	
	declare @PerfTotalClmsCosts varchar(2024)
	
	--SELECT @PerfTotalClmsCosts = Value FROM CONTROL 
	--				WHERE Type = 'PTypeList' AND 
	--				Item = 'PerfTotalClmsCosts'
					
	create table #Temp
	(
		transaction_date datetime,
		Payment_Group varchar(60),
		Trans_amount money,
		[Quarter] varchar(10),
		[Year] varchar(10),
		Financial_Year varchar(10)
	)

	insert into #Temp
	select 
		pr.transaction_date,
		[Payment_Group] = case when left(pr.payment_type, 3) = 'WPT' then 'Weekly benefits - total incapacity'
								when left(pr.payment_type, 3) = 'WPP' then 'Weekly benefits - partial incapacity'
								when left(pr.payment_type, 3) in ('WPI', 'PAS') then 'Permanent impairment , pain & sufferin'
								when left(pr.payment_type, 3) = 'CLP' then 'Common Law'
								when left(pr.payment_type, 3) = 'WCO' then 'Medical / NTD services'
								when left(pr.payment_type, 3) in ('PTA', 'PTX') then 'Physiotherapy'
								when left(pr.payment_type, 3) in ('CHA', 'CHX', 'DEN', 'EPA', 'OSA', 'OSX', 'RMA', 'OPT', 'OTT', 'OAS') then 'Other allied health / treatment'
								when left(pr.payment_type, 3) = 'DOA' or pr.payment_type in ('NUR001', 'PCA001') then 'Domestic assistance'
								when left(pr.payment_type, 3) = 'HVM' or pr.payment_type in ('MOB001', 'OAD001') then 'Aids and equipment'
								when pr.payment_type = 'AID001' then 'Industrial hearing loss'
								when left(pr.payment_type, 2) = 'OR' or left(pr.payment_type, 3) in ('VWT', 'VRE') or pr.payment_type in ('VEQ001', 'VJC001') then 'Occupation rehabilitation'
								when left(pr.payment_type, 3) = 'TRA' then 'Travel'
								when pr.payment_type = 'INT001' then 'Interpreting services'
								when left(pr.payment_type, 3) in ('WIG', 'WIS', 'WIE') then 'Worker investigations'
								when left(pr.payment_type, 3) in ('IMG', 'IMS') or pr.payment_type in ('IIN101', 'IIN104', 'IIN105') then 'Insurer investigations (medical)'
								when pr.payment_type in ('IIN102', 'IIN106', 'IIN107') then 'Insurer investigations (non-medical)'
								when left(pr.payment_type, 3) in ('PUH', 'PBI', 'PSI', 'PHR', 'PTH') then 'Hospital'
								when left(pr.payment_type, 3) in ('RFD', 'SCP') then 'Shared claim payments'
								when left(pr.payment_type, 3) in ('RES','RSC') or pr.payment_type in ('RCL001', 'ROP001') then 'Recoveries' 
								else 'Other Pay Types' end,
		Trans_amount,
		[Quarter] = convert(varchar(4), year(transaction_date)) + ' Q' + convert(varchar(4), datepart(quarter, transaction_date)),
		[Year] = year(transaction_date),
		
		Financial_Year = case when datepart(quarter, transaction_date) = 1 or datepart(quarter, transaction_date) = 2 
									then convert(varchar(4),year(transaction_date) - 1) + '/' + convert(varchar(4),year(transaction_date))
									else convert(varchar(4),year(transaction_date)) + '/' + convert(varchar(4),year(transaction_date) + 1) end
	from payment_recovery pr join CLAIM_DETAIL cd on pr.Claim_no = cd.Claim_Number
	where cd.policy_no in (select value from udf_Split(@policies, ','))
		and pr.transaction_date between @start_date and @end_date
		and pr.trans_amount <> 0
	--group by pr.transaction_date, pr.payment_type, pr.Trans_amount
	
	select
		[Quarter],
		[Year],
		Financial_Year,
		Payment_Group,
		Total_Paid = SUM(Trans_amount)
	from #Temp
	group by
		[Year],
		[Quarter],
		Payment_Group,
		Financial_Year
	order by [Quarter]
	drop table #Temp
end
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_FinancialPerformanceTotalClaimsCosts]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_FinancialPerformanceTotalClaimsCosts]  TO [emius]
GO