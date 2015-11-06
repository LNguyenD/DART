
/****** Object:  StoredProcedure [dbo].[usp_EmployerPolicyPaymentReport]    Script Date: 03/05/2012 22:37:33 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_EmployerPolicyPaymentReport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_EmployerPolicyPaymentReport]
GO

/****** Object:  StoredProcedure [dbo].[usp_EmployerPolicyPaymentReport]    Script Date: 03/26/2012 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_EmployerPolicyPaymentReport] 
	@Reporting_from_date datetime,
	@Reporting_to_date datetime,
	@Payment_groups varchar(8000),
	@Policies varchar(8000),
	@IsAll bit,
	@IsRig bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @Reporting_from_date = convert(datetime, convert(char,  @Reporting_from_date, 106))
	SET @Reporting_to_date = convert(datetime, convert(char,  @Reporting_to_date, 106)) + '23:59'
	
	declare @payment_group varchar(8000)
	set @payment_group = dbo.udf_ExtractPaymentGroupFromNames(@Payment_groups)		
	
	CREATE TABLE #Temp_Payment_Groups
	(
		Payment_Group varchar(10)
	)
	INSERT INTO #Temp_Payment_Groups	
	select * from dbo.udf_Split(@payment_group, ',')
	
	CREATE TABLE #Temp_Policies
	(
		policy char(19)
	)
	INSERT INTO #Temp_Policies
	select * from dbo.udf_Split(@Policies, ',')
		
		
	create table #TempPaymentRecovery
	(
		ID int,
		Claim_No char(19),
		Payment_no int,
		Transaction_date smalldatetime,
		Payment_Type varchar(15),
		Estimate_type char(2),
		Period_Start_Date smalldatetime,
		Period_End_Date smalldatetime,
		Gross money,		
		Tax_Amt money,
		Net_amt money
	)
	insert into #TempPaymentRecovery
	select ID, Claim_No, Payment_no, Transaction_date, Payment_Type, Estimate_type, Period_Start_Date, Period_End_Date, Gross, Tax_Amt, Net_amt
	from Payment_Recovery 
	where Reversed <> 1 AND Transaction_date between @Reporting_from_date and @Reporting_to_date
		
    SELECT  Employer_Name = PTD.LEGAL_NAME,
		Policy_Number = CD.Policy_No,
		Claim_Number = CD.Claim_Number,		
		MIN(PR.ID),
		Broker = BR.BROKER_NO,
		Claimant = ISNULL(CD.given_names,'') +' '+ ISNULL(CD.last_names,''),	
		Payment_Type_Group = case when left(pr.payment_type, 3) in ('WPT', 'WPP') then 'Weekly Benefits'								
								when left(pr.payment_type, 2) = 'IN' or pr.payment_type = 'INS600' then 'Legal - Insurer'
								when left(pr.payment_type, 2) = 'WK' then 'Legal - Worker'
								when left(pr.payment_type, 3) = 'WRK' then 'Legal - Common law - Worker'
								when left(pr.payment_type, 4) = 'INS7' then 'Legal - Common law - Insurer'
								when pr.payment_type in ('IIN101', 'IIN104', 'IIN105') then 'Investigation - Medical'
								when pr.payment_type = 'IIN102' then 'Investigation - Factual / Surveillance'
								when pr.payment_type = 'IIN103' then 'Investigation - S40 assessment'
								when left(pr.payment_type, 2) = 'OR' then 'Rehab'
								when left(pr.payment_type, 3) = 'DOA' then 'Domestic Assistance'
								when pr.payment_type = 'PCA001' then 'Carers'
								when pr.payment_type = 'TRA002' then 'Worker Travel'
								when pr.payment_type = 'COM001' then 'Commutation'
								when pr.Estimate_type = '51' then 'Permanent Impairment'
								when pr.Estimate_type = '55' then 'Medical'
								when pr.Estimate_type = '57' then 'Common Law'
								else 'Others' end,	
		Payment_Type = PR.Payment_Type,
		Payee = CPR.Payee_Name,
		From_Date = (SELECT MIN(Period_Start_Date)
						FROM #TempPaymentRecovery
						WHERE Claim_No = PR.Claim_No AND Payment_Type = PR.Payment_Type),
		To_Date = (SELECT MAX(Period_End_Date)
						FROM #TempPaymentRecovery
						WHERE Claim_No = PR.Claim_No AND Payment_Type = PR.Payment_Type),
		Gross = (SELECT SUM(Gross) 
					FROM #TempPaymentRecovery 
					WHERE Claim_No = PR.Claim_No AND Payment_Type = PR.Payment_Type),		
		Tax = (SELECT SUM(Tax_Amt) 
					FROM #TempPaymentRecovery 
					WHERE Claim_No = PR.Claim_No AND Payment_Type = PR.Payment_Type),
		Net = (SELECT SUM(Net_amt) 
					FROM #TempPaymentRecovery 
					WHERE Claim_No = PR.Claim_No AND Payment_Type = PR.Payment_Type)
    FROM CLAIM_PAYMENT_RUN CPR JOIN #TempPaymentRecovery PR ON CPR.Payment_no = PR.Payment_no
		JOIN CLAIM_DETAIL CD ON PR.Claim_No = CD.Claim_Number
		JOIN CLAIM_ACTIVITY_DETAIL CAD ON CD.Claim_Number = CAD.Claim_no
		LEFT JOIN CLAIMS_OFFICERS CO ON CAD.Claims_Officer = CO.Alias
		LEFT JOIN POLICY_TERM_DETAIL PTD ON CD.Policy_No = PTD.POLICY_NO
		JOIN BROKER BR ON PTD.BROKER_NO = BR.BROKER_NO
		JOIN PAYMENT_TYPES PT ON PT.Payment_Type = PR.Payment_Type			
		
	WHERE (PT.Payment_Group  in (select * from #Temp_Payment_Groups)
				OR PR.Estimate_type in (select * from #Temp_Payment_Groups)
				OR PR.Payment_Type in (select * from #Temp_Payment_Groups)
				OR (select TOP 1 Payment_Group from #Temp_Payment_Groups) = ''
				OR (select COUNT(*) from #Temp_Payment_Groups) = 0)
			AND (CD.Policy_No  in (select * from #Temp_Policies) OR (select TOP 1 policy from #Temp_Policies) = '')			
			--AND PR.ID = (SELECT MIN(ID) FROM Payment_Recovery WHERE Payment_Recovery.Payment_no = PR.Payment_no)			
			AND (@IsAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%')))		
	GROUP BY PTD.LEGAL_NAME, CD.Policy_No, CD.Claim_Number, BR.BROKER_NO, ISNULL(CD.given_names,'') +' '+ ISNULL(CD.last_names,''),	
				PR.Payment_Type, CPR.Payee_Name, PR.Estimate_type, PR.Claim_No			
	ORDER BY Employer_Name, Policy_Number, Claim_Number
	
	
	DROP TABLE #Temp_Payment_Groups
	DROP TABLE #Temp_Policies	
	
END

GO

GRANT  EXECUTE  ON [dbo].[usp_EmployerPolicyPaymentReport]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_EmployerPolicyPaymentReport]  TO [emius]
GO

--exec usp_EmployerPolicyPaymentReport '12/01/2011', '12/31/2011', 'Weekly Benefits', '10125181', 0, 0

