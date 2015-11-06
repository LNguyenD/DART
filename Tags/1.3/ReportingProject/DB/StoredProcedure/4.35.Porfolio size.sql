/****** Object:  StoredProcedure [dbo].[usp_PortfolioSize]    Script Date: 03/14/2012 13:16:45 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_PortfolioSize]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_PortfolioSize]
GO


/****** Object:  StoredProcedure [dbo].[usp_PortfolioSize]    Script Date: 03/14/2012 13:16:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON

GO
/****** Object:  StoredProcedure [dbo].[usp_PortfolioSize]    Script Date: 03/26/2012 15:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--execute [usp_PortfolioSize] '2009','1','2012','1','10125181'

CREATE proc [dbo].[usp_PortfolioSize]
	@from_quarter_year varchar(4),
	@from_quarter_quarter varchar(1),
	@to_quarter_year varchar(4),
	@to_quarter_quarter varchar(1),
	@policies varchar(8000)
as
begin
	declare @start_date datetime
	declare @end_date datetime
	set @start_date =   [dbo].[udf_GetFirstDateByQuarter](@from_quarter_year,@from_quarter_quarter) -- first day of quarter
	set @end_date = dbo.udf_GetLastDateByQuarter(@to_quarter_year,@to_quarter_quarter) + '23:59'	-- last day of quarter
		
	CREATE TABLE #POLICY
	(
		value varchar(200)
	)		
	create table #Payments
	(
		claim_number char(30),
		transaction_date datetime	
	)		
	create table #TotalPayments
	(
		[Quarter] varchar(8),
		[Year] char(4),
		Financial_Year char(10),
		FirstDate_Quarter datetime,
		LastDate_Quarter datetime,
	 )
	INSERT INTO #POLICY
	SELECT * from dbo.udf_Split(@policies, ',')	
 
	insert into #Payments
	
	select CADA.Claim_no,CADA.Transaction_Date			
	from CAD_AUDIT  CADA Left join CLAIM_DETAIL cd on CADA.Claim_no = cd.Claim_Number
	where cd.policy_no in (select * from #POLICY)
		and CADA.Transaction_Date between @start_date and @end_date		
		
	insert into #TotalPayments
	select distinct
		[Quarter] = convert(varchar(4), year(transaction_date)) + ' Q' + convert(varchar(4), datepart(quarter, transaction_date))
		,[Year] = year(transaction_date)
		
		,Financial_Year = case when datepart(quarter, transaction_date) = 1 or datepart(quarter, transaction_date) = 2 
									then convert(varchar(4),year(transaction_date) - 1) + '/' + convert(varchar(4),year(transaction_date))
									else convert(varchar(4),year(transaction_date)) + '/' + convert(varchar(4),year(transaction_date) + 1) end
		,dbo.udf_GetFirstDateOfQuarter(transaction_date)
		,dbo.udf_GetLastDateOfQuarter(transaction_date) + '23:59'
	from #Payments	
	
	select TP.*
			,Number_of_Open_claims=isnull((select COUNT(distinct CADA.Claim_no)
									from CAD_AUDIT CADA left join CLAIM_DETAIL CD on CADA.Claim_no = CD.Claim_Number
									where CADA.ID = (select MAX(id) from CAD_AUDIT CADA_2 where CADA_2.Claim_no = CADA.Claim_no
									and Transaction_Date  between FirstDate_Quarter and LastDate_Quarter)
									and isnull(Claim_Closed_Flag,'N') <> 'Y' and CD.Policy_No in (select * from #POLICY)),0)
			,Number_of_Closed_claims=ISNULL((SELECT COUNT(DISTINCT Claim_no) FROM CAD_AUDIT
                              LEFT JOIN claim_detail cd ON cad_audit.claim_no = cd.claim_number
                              WHERE cd.policy_no IN (SELECT * FROM #POLICY)
                              AND cad_audit.id = (SELECT MAX(c2.id) FROM CAD_AUDIT c2
								WHERE c2.claim_no = cad_audit.Claim_no)
                              AND ISNULL(Claim_Closed_Flag,'N') = 'Y' and Transaction_Date BETWEEN FirstDate_Quarter
                              AND LastDate_Quarter)
                              ,0)
			,Number_of_Notification =ISNULL((SELECT COUNT(DISTINCT Claim_no) FROM CAD_AUDIT
                              LEFT JOIN claim_detail cd ON cad_audit.claim_no = cd.claim_number
                              WHERE cd.policy_no IN (SELECT * FROM #POLICY)
                              AND cad_audit.id = (SELECT MAX(c2.id) FROM CAD_AUDIT c2
								WHERE c2.claim_no = cad_audit.Claim_no)
                              AND date_claim_received BETWEEN FirstDate_Quarter
                              AND LastDate_Quarter)
                              ,0)
			,Number_of_Reopened_claims=isnull((select count(distinct Claim_no) from CAD_AUDIT
								Left join CLAIM_DETAIL CD on CAD_AUDIT.Claim_no = CD.Claim_Number
								where CD.Policy_No in (select * from #POLICY) 
								and Date_Claim_reopened between FirstDate_Quarter and  LastDate_Quarter)
								,0)
	 from #TotalPayments TP
	order by [Quarter]
	
	drop table #Payments
	drop table #TotalPayments
end
 
GRANT  EXECUTE  ON [dbo].usp_PortfolioSize  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].usp_PortfolioSize  TO [emius]
GO
