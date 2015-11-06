/****** Object:  StoredProcedure [dbo].[usp_BrokerIntermediaryPortfolioLevelReporting]    Script Date: 04/05/2012 15:22:42 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_BrokerIntermediaryPortfolioLevelReporting]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_BrokerIntermediaryPortfolioLevelReporting]
GO

/****** Object:  StoredProcedure [dbo].[usp_BrokerIntermediaryPortfolioLevelReporting]    Script Date: 04/05/2012 15:22:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usp_BrokerIntermediaryPortfolioLevelReporting 2009, 2010, 0, '', ''
CREATE PROCEDURE [dbo].[usp_BrokerIntermediaryPortfolioLevelReporting]
	@Start_year smallint,
	@End_year smallint,
	@Is_Broker bit,
	@Broker varchar(8),
	@Policies varchar(8000)
AS
BEGIN
	SET NOCOUNT ON;
	
	CREATE TABLE #INSURANCE_YEAR
	(
		[year] CHAR(10),  
		[start_date] datetime, 
		end_date datetime
	)
	
	CREATE TABLE #PAYMENT
	(
		Claim_no varchar(30),
		PAYMENT_TYPE VARCHAR(15),
		Gross money,
		ITC MONEY,
		DAM MONEY,
		Transaction_date datetime
	)
	
	CREATE TABLE #TEMP
	(
		Insurance_Years char(10), CLAIM_NO VARCHAR(30),
		IS_OPEN tinyint,
		IS_CLOSED tinyint,
		IS_NEW tinyint,--Date_Claim_Received DATETIME,[START_DATE] DATETIME, END_DATE DATETIME,
		IS_REOPEN tinyint,
		Reserve money, 
		Payments money,   
		Incurred money
	)
	
	-- GET ALL WEEKLY & MEDICAL PAYMENTS
	INSERT INTO #PAYMENT
	SELECT PR.Claim_no ,
		PR.PAYMENT_TYPE,
		PR.Gross,
		PR.ITC,
		PR.DAM,
		PR.Transaction_date
	FROM Payment_Recovery PR JOIN CLAIM_DETAIL CD ON CD.CLAIM_NUMBER = PR.CLAIM_NO
	WHERE ([dbo].[udf_IsWeeklyOrWagePayment](payment_type) = 1
			OR [dbo].[udf_IsMedicalPayment](payment_type) = 1
			OR EXISTS (SELECT 1 FROM ESTIMATE_DETAILS ED
						WHERE ED.CLAIM_NO = PR.CLAIM_NO
							AND (ED.TYPE = 50 or ED.type = '55')))
		AND (@Is_Broker = 1 
			OR (@Is_Broker <> 1 AND CD.POLICY_NO COLLATE Latin1_General_CI_AS IN (SELECT * FROM dbo.udf_Split(@Policies, ',')))
		)
		
	INSERT INTO #INSURANCE_YEAR
	SELECT * FROM [dbo].[udf_InsuranceYear](@Start_year, @End_year)
	
	INSERT INTO #TEMP
	SELECT 
		Insurance_Years = IY.[YEAR],
		CADA.CLAIM_NO,
		IS_OPEN = CASE WHEN ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') <> 'Y' THEN 1 ELSE 0 END,
		IS_CLOSED = CASE WHEN ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') = 'Y' THEN 1 ELSE 0 END,
		
		IS_NEW = CASE WHEN CAD.Date_Claim_Received BETWEEN IY.[START_DATE] AND IY.END_DATE THEN 1 ELSE 0 END,
		--CAD.Date_Claim_Received,IY.[START_DATE],IY.END_DATE,
		IS_REOPEN = case when CADA.Date_Claim_reopened BETWEEN IY.[START_DATE] AND IY.END_DATE THEN 1 ELSE 0 END,
		Reserve = null, 
		Payments = isnull((SELECT Sum(Gross)   
							FROM  #PAYMENT P 
							WHERE P.Claim_No = CADA.CLAIM_NO
								AND ([dbo].[udf_IsWeeklyOrWagePayment](P.payment_type) = 1
									OR [dbo].[udf_IsMedicalPayment](P.payment_type) = 1)
								AND P.Transaction_Date BETWEEN IY.[START_DATE] AND IY.END_DATE), 0),
		Incurred = isnull((SELECT Sum(ISNULL(ED.Amount, 0)) + Sum(ISNULL(ED.itc, 0)) --+ Sum(ISNULL(ED.dam, 0))
						 FROM  ESTIMATE_DETAILS ED 
						 WHERE ED.Transaction_Date BETWEEN IY.[START_DATE] AND IY.END_DATE
							AND CADA.CLAIM_NO = ED.Claim_No 
							AND (ED.TYPE = 50 or ED.type = '55')),0)
	FROM CAD_AUDIT CADA FULL JOIN CLAIM_ACTIVITY_DETAIL CAD ON CAD.CLAIM_NO = CADA.CLAIM_NO
		JOIN CLAIM_DETAIL CD ON CD.CLAIM_NUMBER = CADA.CLAIM_NO
		LEFT JOIN POLICY_TERM_DETAIL PTD ON PTD.POLICY_NO = CD.POLICY_NO
		, #INSURANCE_YEAR IY
	WHERE CADA.ID = (SELECT MAX(ID)
					FROM CAD_Audit CADA1
					WHERE CADA1.Claim_no = CADA.Claim_No
						AND CADA1.TRANSACTION_DATE <= IY.END_DATE)
		-- ONLY WEEKLY & MEDIAL CLAIMS
		AND CADA.CLAIM_NO COLLATE Latin1_General_CI_AS IN (SELECT DISTINCT CLAIM_NO FROM #PAYMENT)
		-- IF IT IS ONE OF NEW, OPEN, CLOSED, REOPEN CLAIM
		AND 
		(
			(CAD.Date_Claim_Received BETWEEN IY.[START_DATE] AND IY.END_DATE)
			OR	(ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') <> 'Y')
			OR	(CADA.Date_Claim_Closed BETWEEN IY.[START_DATE] AND IY.END_DATE)
			OR 	(CADA.Date_Claim_Reopened BETWEEN IY.[START_DATE] AND IY.END_DATE)
		)
		AND 
		(
			(-- CASE WHEN @broker IS NOT INPUTED THEN FILTER BY POLICY
				@Is_Broker = 0
				AND CD.POLICY_NO COLLATE Latin1_General_CI_AS IN (SELECT * FROM dbo.udf_Split(@Policies, ','))
			)
			OR
			(-- CASE WHEN @broker IS INPUTED THEN FILTER BY BROKER 
				@Is_Broker = 1
				AND PTD.BROKER_NO = @Broker
			)
		)
		--AND CADA.CLAIM_NO = '11472181           '
	GROUP BY 
		CADA.CLAIM_NO, IY.[YEAR],
		 IY.[START_DATE], IY.END_DATE, CADA.CLAIM_CLOSED_FLAG, 
		 CAD.Date_Claim_Received, CADA.Date_Claim_reopened
	ORDER BY IY.[YEAR], CADA.CLAIM_NO
	
	UPDATE #TEMP
	SET Reserve = Incurred - Payments
		 
	SELECT Insurance_Years,
		Estimate = SUM(Reserve) ,
		Total_Paid = SUM(Payments),
		Total_Incurred_Cost = SUM(Incurred),
		Average_Cost = CASE WHEN SUM(IS_OPEN) > 0 THEN SUM(Incurred)/SUM(IS_OPEN) END,
		Number_of_New_Claims = SUM(IS_NEW),
		Number_of_Open_Claims = SUM(IS_OPEN),
		Number_of_Claims_Closed = SUM(IS_CLOSED),
		Number_of_Claims_Reopened = SUM(IS_REOPEN)
	FROM #TEMP
	GROUP BY Insurance_Years
	ORDER BY Insurance_Years
	
	--SELECT * FROM #TEMP
	--select * from #PAYMENT
	
	DROP TABLE #TEMP
	DROP TABLE #INSURANCE_YEAR
	DROP TABLE #PAYMENT
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_BrokerIntermediaryPortfolioLevelReporting]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_BrokerIntermediaryPortfolioLevelReporting]  TO [emius]
GO


