
/****** Object:  StoredProcedure [dbo].[usp_EmployerPerformanceLevelReport]    Script Date: 01/04/2012 14:49:48 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_EmployerPerformanceLevelReport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].usp_EmployerPerformanceLevelReport 
GO


/****** Object:  StoredProcedure [dbo].[usp_EmployerPerformanceLevelReport]    Script Date: 01/04/2012 14:49:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- execute [usp_EmployerPerformanceLevelReport]  '2010','3','2011','4',1,0
create proc [dbo].usp_EmployerPerformanceLevelReport
	@from_quarter_year varchar(4),
	@from_quarter_quarter varchar(1),
	@to_quarter_year varchar(4),
	@to_quarter_quarter varchar(1),	
	@IsAll bit,
	@IsRIG bit
as
begin
	declare @start_date datetime
	declare @end_date datetime
	set @start_date =   DATEADD(dd, 1, dbo.udf_GetLastDateByQuarter(@from_quarter_year,@from_quarter_quarter)) -- first day of quarter
	set @end_date = dbo.udf_GetLastDateByQuarter(@to_quarter_year,@to_quarter_quarter) + '23:59'	-- last day of quarter
					
	create table #TotalPayments
	(
		[Quarter] varchar(8)
		,[Year]  char(4)		
		,Total_Payment money		
		,Total_Claims_Count	bigint
	 )	
		
	INSERT INTO #TotalPayments
	SELECT  [QUARTER],[YEAR],
		Total_Payment=SUM(Trans_Amount)		
		,Total_Claims_Count = COUNT(DISTINCT CLAIM_NO)	
	FROM (
		SELECT 
			CADA.CLAIM_NO
			,[YEAR] = YEAR(CADA.TRANSACTION_DATE)
			,[QUARTER] = DATEPART(QUARTER, CADA.TRANSACTION_DATE)			
			,PR.Trans_amount			
		FROM CAD_AUDIT CADA JOIN PAYMENT_RECOVERY PR ON CADA.CLAIM_NO = PR.CLAIM_NO
		LEFT OUTER JOIN CLAIM_ACTIVITY_DETAIL CAD on PR.Claim_No = CAD.Claim_no
		LEFT OUTER JOIN CLAIMS_OFFICERS CO on CAD.Claims_Officer=CO.Alias
		WHERE CADA.ID = (SELECT MAX(ID) FROM CAD_AUDIT CADA1
						WHERE CADA1.CLAIM_NO = CADA.CLAIM_NO
							AND CADA1.TRANSACTION_DATE <= dbo.udf_GetLastDateOfQuarter(CADA.TRANSACTION_DATE) + ' 23:59')
			AND isnull(CADA.CLAIM_CLOSED_FLAG,'N') <> 'Y'
			AND CADA.Transaction_Date BETWEEN  @start_date AND @end_date
			AND PR.TRANSACTION_DATE BETWEEN  @start_date AND  @end_date
			AND (@IsAll = 1 OR ((@IsRIG = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND Grp LIKE 'RIG%')))	
			) AS TBL
	GROUP BY [YEAR], [QUARTER]
	
	
	select [Quarter]=CONVERT(varchar(4), TP.YEAR) + ' Q'+CONVERT(varchar(4), TP.Quarter)
			,[Year]=TP.Year 
			,TP.Total_Payment
			,TP.Total_Claims_Count			
			,Open_Partial_Incapacity_Count = (select count(*) FROM CAD_AUDIT CADA JOIN PAYMENT_RECOVERY PR ON CADA.CLAIM_NO = PR.CLAIM_NO
								  WHERE CADA.ID = (SELECT MAX(ID) FROM CAD_AUDIT CADA1
									  WHERE CADA1.CLAIM_NO = CADA.CLAIM_NO
									   AND CADA1.TRANSACTION_DATE <= dbo.udf_GetLastDateOfQuarter(CADA.TRANSACTION_DATE) + ' 23:59')
								   AND isnull(CADA.CLAIM_CLOSED_FLAG,'N') <> 'Y'
								   AND CADA.Transaction_Date BETWEEN dbo.udf_GetFirstDateByQuarter(TP.Year,TP.Quarter) AND dbo.udf_GetLastDateByQuarter(TP.Year,TP.Quarter)
								   AND PR.TRANSACTION_DATE BETWEEN dbo.udf_GetFirstDateByQuarter(TP.Year,TP.Quarter) AND dbo.udf_GetLastDateByQuarter(TP.Year,TP.Quarter)
								   AND PR.PAYMENT_TYPE IN ('WPP001', 'WPP002', 'WPP003', 'WPP004'))
			,Wages =isnull((SELECT  COUNT(*)
								 FROM       payment_recovery pr 
								 INNER JOIN payment_types pt 
								 ON        (pt.payment_type  = pr.payment_type)
								 WHERE     (pt.screen_method = 1)								 
								 AND   pr.Transaction_Date >=dbo.udf_GetFirstDateByQuarter(TP.Year,TP.Quarter)
								 AND  pr.Transaction_Date <=dbo.udf_GetLastDateByQuarter(TP.Year,TP.Quarter)+ '23:59'
						),0)
			, Incurred = isnull((Select ISNULL((sum(ESTIMATE_DETAILS.Amount + ESTIMATE_DETAILS.itc + ESTIMATE_DETAILS.dam)),0)
						 From ESTIMATE_DETAILS Where ESTIMATE_DETAILS.Transaction_date>=dbo.udf_GetFirstDateByQuarter(TP.Year,TP.Quarter) and ESTIMATE_DETAILS.Transaction_date<=dbo.udf_GetLastDateByQuarter(TP.Year,TP.Quarter)+'23:59'),0)
			,Total_Days_Lost = isnull((select sum(CONVERT(NUMERIC(9,0), isnull(Date_Resumed_Work,Date_Deemed_Fit) - Date_Ceased_Work)) 
										from TIME_LOST_DETAIL where create_date > = dbo.udf_GetFirstDateByQuarter(TP.Year,TP.Quarter)
										and create_date <= dbo.udf_GetLastDateByQuarter(TP.Year,TP.Quarter)+'23:59')
										,0)	
			,Total_Claim_Count_More_12_Week = isnull((select COUNT(*) from CAD_AUDIT  left join CLAIM_DETAIL CD on CAD_AUDIT.Claim_no = CD.Claim_Number
										where Claim_Closed_Flag <> 'Y' and 
										CD.Date_of_Injury >DATEADD(dd, 84, dbo.udf_GetLastDateByQuarter(TP.Year,TP.Quarter)))
										,0)			
						 
	 from #TotalPayments TP
	order by [Quarter]	
	
	drop table #TotalPayments
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].usp_EmployerPerformanceLevelReport  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].usp_EmployerPerformanceLevelReport  TO [emius]
GO
