

/****** Object:  StoredProcedure [dbo].[usp_EmployerPerformance LevelReport_MarketResearch]    Script Date: 03/14/2012 13:16:45 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_EmployerPerformance LevelReport_MarketResearch]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_EmployerPerformance LevelReport_MarketResearch]
GO


/****** Object:  StoredProcedure [dbo].[usp_EmployerPerformance LevelReport_MarketResearch]    Script Date: 03/14/2012 13:16:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [dbo].[usp_EmployerPerformance LevelReport_MarketResearch]  '2005/2006','2010/2011','10125181'
CREATE PROCEDURE [dbo].[usp_EmployerPerformance LevelReport_MarketResearch]
	@Financial_Years_From char(9),
	@Financial_Years_To char(9),	
	@policies varchar(8000)
AS
BEGIN

	SET NOCOUNT ON;	
	CREATE TABLE #POLICY
	(
		value nvarchar(4000)
	)	
		
	INSERT INTO #POLICY
	SELECT * FROM dbo.udf_Split(@Policies, ',')	
		
	CREATE TABLE #MAIN
	(
		Financial_Years varchar(9),		
		Remuneration bigint,
		Premium_Paid money,
		Total_Cost_Paid  money,
		Claims_Estimates money,
		Total_Incurred_Costs  money,
		Days_Comp_Paid  int,
		Standard_Claims  int,
		Total_Claims  int,
		Premium_Rate float,
		Industry_Rate float		
	)
	
	CREATE TABLE #TEMP
	(
		Financial_Years varchar(9),
		Year_From varchar(4),
		Year_To varchar(4)
	)	
	
	declare @curr_year smallint
	declare @interval smallint
	
	set @curr_year = (select convert(smallint,substring(@Financial_Years_To,CHARINDEX('/',@Financial_Years_To)+1,len(@Financial_Years_To)))+1)
	set @interval = (select (convert(smallint,SUBSTRING ( @Financial_Years_To ,CHARINDEX('/', @Financial_Years_To) + 1 , LEN(@Financial_Years_To) ))
					- convert(smallint,SUBSTRING ( @Financial_Years_From ,CHARINDEX('/', @Financial_Years_From) + 1 , LEN(@Financial_Years_From) ))) + 1)
	INSERT INTO #TEMP
	select  Financial_Years = Year_Period
			,Year_From = CONVERT(smallint,substring(Year_Period,0,CHARINDEX('/',Year_Period)))
			,Year_To = CONVERT(smallint,substring(Year_Period,CHARINDEX('/',Year_Period)+1,len(Year_Period)))
	from udf_BuildFinancialList(@curr_year,@interval)
	order by Year_Period
	
	INSERT INTO #MAIN
	select  Financial_Years 			
			,Remuneration =  ISNULL((SELECT SUM(WAGES0) FROM PREMIUM_DETAIL WHERE policy_no IN (SELECT * from #POLICY) AND POLICY_YEAR=Year_To),0)
			,Premium_Paid =  ISNULL((SELECT SUM(PP) FROM PREMIUM_DETAIL WHERE policy_no IN (select * from #POLICY) AND POLICY_YEAR=Year_To),0)
			,Total_Cost_Paid  = ISNULL((SELECT SUM(net_amt) FROM Payment_Recovery P JOIN claim_detail CD ON p.claim_no = cd.claim_number
                              WHERE cd.Policy_No IN (select * from #POLICY)
                              AND (SELECT MAX(paid_date) FROM Claim_Payment_run CPR WHERE CPR.Payment_No=P.Payment_No
                                          AND CPR.claim_number = cd.claim_number)
                              BETWEEN CONVERT(DATETIME, ('7/1/' + Year_From)) AND CONVERT(DATETIME, ('6/30/' + Year_To + ' 23:59'))),0)
						
			,Claims_Estimates = ISNULL((select SUM(ED.Amount) from ESTIMATE_DETAILS ED
								WHERE ED.Claim_no  in (select * from #POLICY) and ED.Transaction_date 
								between CONVERT(datetime, ('7/1/' + Year_From)) and CONVERT(datetime, ('6/30/' + Year_To + ' 23:59'))),0)
								- 
								ISNULL((SELECT SUM(Trans_amount - ISNULL(DAM,0) - ISNULL(ITC,0))  
									FROM Payment_Recovery P 
									WHERE P.Claim_no in (select * from #POLICY) and P.Transaction_date
									between CONVERT(datetime, ('7/1/' + Year_From)) and CONVERT(datetime, ('6/30/' + Year_To + ' 23:59'))),0)	
									
			,Total_Incurred_Costs =ISNULL((select SUM(ED.Amount) from ESTIMATE_DETAILS ED
								WHERE ED.Claim_no  in (select * from #POLICY) and ED.Transaction_date
								between CONVERT(datetime, ('7/1/' + Year_From)) and CONVERT(datetime, ('6/30/' + Year_To + ' 23:59'))),0)
								- 
								ISNULL((SELECT SUM(ISNULL(DAM,0) - ISNULL(ITC,0))  
									FROM Payment_Recovery P 
									WHERE P.Claim_no  in (select * from #POLICY) and P.Transaction_date
									between CONVERT(datetime, ('7/1/' + Year_From)) and CONVERT(datetime, ('6/30/' + Year_To + ' 23:59'))),0)
			,Days_Comp_Paid = ISNULL((SELECT SUM(ISNULL(weeks_paid,0)*
							  (ISNULL((CONVERT(INT, SUBSTRING(p.work_days, 1, 1)) +
							  CONVERT(INT, SUBSTRING(p.work_days, 2, 1)) +
							  CONVERT(INT, SUBSTRING(p.work_days, 3, 1)) +
						CONVERT(INT, SUBSTRING(p.work_days, 4, 1)) +
							  CONVERT(INT, SUBSTRING(p.work_days, 5, 1)) +
							  CONVERT(INT, SUBSTRING(p.work_days, 6, 1)) +
							  CONVERT(INT, SUBSTRING(p.work_days, 7, 1))),0)) + ISNULL(days_paid,0))
						FROM payment_recovery p
						JOIN claim_detail CD ON p.claim_no = cd.claim_number
						WHERE reversed = 0
						AND payment_type IN ('WPT001', 'WPT002', 'WPT003', 'WPT004', 'WPP001', 'WPP002', 'WPP003', 'WPP004')
						AND cd.Policy_No IN (SELECT * FROM #POLICY)
						AND (SELECT MAX(paid_date) FROM Claim_Payment_run CPR WHERE CPR.Payment_No=P.Payment_No
						AND CPR.claim_number = cd.claim_number)  
						BETWEEN CONVERT(datetime, ('7/1/' + Year_From)) AND CONVERT(datetime, ('6/30/' + Year_To + ' 23:59'))),0)
			,Standard_Claims = isnull((select count(distinct Claim_No) from payment_recovery PR
								where PR.Claim_no  in (select * from #POLICY) and payment_type in ('WPT001', 'WPT002', 'WPT003', 'WPT004', 'WPP001', 'WPP002', 'WPP003', 'WPP004')
								and PR.Transaction_date between CONVERT(datetime, ('7/1/' + Year_From)) and CONVERT(datetime, ('6/30/' + Year_To + ' 23:59'))),0)
			,Total_Claims = ISNULL((SELECT COUNT(*) FROM claim_detail CD
                              WHERE cd.Policy_No IN (SELECT * FROM #POLICY)
                              AND date_created BETWEEN CONVERT(DATETIME, ('7/1/' + Year_From))
                              AND CONVERT(DATETIME, ('6/30/' + Year_To + ' 23:59'))), 0)
			,Premium_Rate = ISNULL((SELECT DISTINCT (ICCR_WG*100) FROM claim_detail CD
                              JOIN Premium_Detail PD ON CD.Policy_no = PD.Policy_No AND CD.Renewal_no = PD.Renewal_no
                              WHERE CD.Policy_no IN (SELECT * FROM #POLICY)
                              AND PD.policy_year = Year_To),0)
			,Industry_Rate = isnull((SELECT SUM(gy.rate) / COUNT(gy.rate)
						FROM ACTIVITY_DETAIL ad
						JOIN gazette_years gy ON ad.tariff = gy.tariff
						JOIN premium_detail pd ON pd.policy_no = ad.policy_no
						AND pd.renewal_no = ad.renewal_no
						AND gy.fin_year = pd.policy_year
						JOIN policy_term_detail ptd ON ptd.policy_no = pd.policy_no
						AND ptd.Current_Renewal = ad.renewal_no
						WHERE ad.policy_no IN (SELECT * FROM #POLICY)),0)													
	from #TEMP
	order by Financial_Years
	 
	select top 6 *
			,Performance_Rating = case when Industry_Rate <> 0 then Premium_Rate/Industry_Rate else 0 end			 
			,Average_Claim_Cost=case when Total_Claims<>0 then Total_Incurred_Costs/Total_Claims else 0.00 end
			,Percent_Premium_Paid=case when Remuneration <> 0 then Premium_Paid/Remuneration*100 else 0.00 end
			,Duration_Rate = case when Standard_Claims <> 0 then Days_Comp_Paid / Standard_Claims else Days_Comp_Paid end	
			,Percent_Rate_Change_From_Last_Year	= 
				case when Industry_Rate <> 0
				then (Premium_Rate/Industry_Rate - (select top 1 Premium_Rate/Industry_Rate from #MAIN where Financial_Years < TMP1.Financial_Years order by Financial_Years desc) ) * 100
				else 0.00 end
	 from #MAIN TMP1 where Financial_Years > (select top 1 Financial_Years from #MAIN order by Financial_Years)
	 	 
	DROP TABLE #TEMP
	DROP TABLE #POLICY	
    DROP TABLE #MAIN
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_EmployerPerformance LevelReport_MarketResearch]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_EmployerPerformance LevelReport_MarketResearch]  TO [emius]
GO

