
/****** Object:  StoredProcedure [dbo].[usp_4.19.ClaimPaymentList]    Script Date: 03/05/2012 22:37:33 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_4_19_ClaimPaymentList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_4_19_ClaimPaymentList]
GO

/****** Object:  StoredProcedure [dbo].[usp_4_19_ClaimPaymentList]    Script Date: 03/26/2012 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usp_4_19_ClaimPaymentList '10/01/2011','10/31/2011','44880eml','50,55,62,63','wpp002','','', 1, 0
CREATE PROCEDURE [dbo].[usp_4_19_ClaimPaymentList] 
	@Reporting_from_date datetime,
	@Reporting_to_date datetime,
	@ClaimNumber varchar(30),
	@Estimate_types varchar(8000),	
	@Payment_types varchar(8000),
	@Creditor_numbers varchar(8000),
	@Provider_numbers varchar(8000),	
	@IsAll bit,
	@IsRig bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @Reporting_from_date = convert(datetime, convert(char,  @Reporting_from_date, 106))
	SET @Reporting_to_date = convert(datetime, convert(char,  @Reporting_to_date, 106)) + '23:59'
		
		
	CREATE TABLE #Temp_Payment_Types
	(
		Payment_Type varchar(15)
	)
	INSERT INTO #Temp_Payment_Types
	select * from dbo.udf_Split(@Payment_types, ',')
	
	CREATE TABLE #Temp_Estimate_Types
	(
		Estimate_type char(2)
	)
	INSERT INTO #Temp_Estimate_Types
	select * from dbo.udf_Split(@Estimate_types, ',')
	
	CREATE TABLE #Temp_Creditors
	(
		Creditor_number int
	)
	INSERT INTO #Temp_Creditors
	select * from dbo.udf_Split(@Creditor_numbers, ',')
	
	CREATE TABLE #Temp_Provider_Numbers
	(
		Provider_number varchar(20)
	)
	INSERT INTO #Temp_Provider_Numbers
	select * from dbo.udf_Split(@Provider_numbers, ',')
	
	CREATE TABLE #Temp_CLAIM_PAYMENT_RUN
	(
		Payment_no int,
		Cheque_Account_no int,
		Cheque_no varchar(20),
		Payee_Name varchar(150),
		Drawn_date smalldatetime
	)
	INSERT INTO #Temp_CLAIM_PAYMENT_RUN
	Select CPR1.Payment_no, Cheque_Account_no = max(Cheque_Account_no), Cheque_no = max(Cheque_no), Payee_Name = max(Payee_Name), Drawn_date=max(Drawn_date)
	from CLAIM_PAYMENT_RUN CPR1 join Payment_Recovery PR1 on CPR1.Payment_no = PR1.Payment_no
	where PR1.Transaction_date between @Reporting_from_date and @Reporting_to_date
	group by CPR1.Payment_no
	
		
    SELECT [Group] = dbo.[udf_ExtractGroup](grp),  
		Team = CO.grp,
		Claims_Officer = (CO.First_Name + ' ' + CO.Last_Name),		
		Claim_Number = CD.Claim_Number,
		Employer = isnull(PTD.LEGAL_NAME, ''),
		Employee = isnull(CD.given_names, '') + ' ' + isnull(CD.last_names, ''),	
		Estimate_Type = PR.Estimate_type,
		Payment_Number = PR.Payment_no,
		Account_Number = CPR.Cheque_Account_no,
		Cheque_Number = CPR.Cheque_no,
		Payee = CPR.Payee_Name,
		Drawn_Date = CPR.Drawn_date,
		Payment_Type = PR.Payment_Type,
		From_Date = PR.Period_Start_Date,
		To_Date = PR.Period_End_Date,
		Weeks = case when PR.Payment_Type in ('WPP001','WPP002','WPP003','WPP004','WPT001','WPT002','WPT003','WPT004') then PR.Weeks_Paid else null end,
		Days = case when PR.Payment_Type in ('WPP001','WPP002','WPP003','WPP004','WPT001','WPT002','WPT003','WPT004') then PR.Days_Paid else null end,
		Hours = case when PR.Payment_Type in ('WPP001','WPP002','WPP003','WPP004','WPT001','WPT002','WPT003','WPT004') then PR.Hours_Paid else null end,
		Rate = case when PR.Payment_Type in ('WPP001','WPP002','WPP003','WPP004','WPT001','WPT002','WPT003','WPT004') then PR.Rate else null end,				
		Tax = case when PR.Payment_Type in ('WPP001','WPP002','WPP003','WPP004','WPT001','WPT002','WPT003','WPT004') then PR.Tax_Amt else null end,		
		Net = case when PR.Payment_Type in ('WPP001','WPP002','WPP003','WPP004','WPT001','WPT002','WPT003','WPT004') then PR.Net_amt else null end,
		Gross = PR.Gross,
		GST = case when PR.Payment_Type not in ('WPP001','WPP002','WPP003','WPP004','WPT001','WPT002','WPT003','WPT004') then PR.gst else null end,
		Service_Date = PR.Date_of_Service,
		Provider_Number = case when PR.Payment_Type not in ('WPP001','WPP002','WPP003','WPP004','WPT001','WPT002','WPT003','WPT004') then PR.Service_Provider_Id else null end,
		Creditor_Number = case when PR.Payment_Type not in ('WPP001','WPP002','WPP003','WPP004','WPT001','WPT002','WPT003','WPT004') then PR.cid else null end,
		Number_of_Treatments = case when PR.Payment_Type not in ('WPP001','WPP002','WPP003','WPP004','WPT001','WPT002','WPT003','WPT004') then PR.no_of_Treatments else null end
		
		
    FROM #Temp_CLAIM_PAYMENT_RUN CPR JOIN Payment_Recovery PR ON CPR.Payment_no = PR.Payment_no
		JOIN CLAIM_DETAIL CD ON PR.Claim_No = CD.Claim_Number
		JOIN POLICY_TERM_DETAIL PTD ON CD.Policy_No = PTD.POLICY_NO
		JOIN CLAIM_ACTIVITY_DETAIL CAD ON CD.Claim_Number = CAD.Claim_no
		JOIN CLAIMS_OFFICERS CO ON CAD.Claims_Officer = CO.Alias
	WHERE (PR.Estimate_type in (select * from #Temp_Estimate_Types) 
				OR (select TOP 1 Estimate_type from #Temp_Estimate_Types) = '' )
			AND (PR.Payment_Type COLLATE Latin1_General_CI_AS in (select * from #Temp_Payment_Types)
					 OR (select TOP 1 Payment_Type from #Temp_Payment_Types) = '')
			AND (PR.cid in (select * from #Temp_Creditors) 
					OR (select TOP 1 Creditor_number from #Temp_Creditors) = '')
			AND (PR.Service_Provider_Id COLLATE Latin1_General_CI_AS in (select * from #Temp_Provider_Numbers)	
					OR (select TOP 1 Provider_number from #Temp_Provider_Numbers) = '')
			AND (@ClaimNumber is null or @ClaimNumber = '' OR CD.Claim_Number = @ClaimNumber)
			--AND	PR.Reversed <> 1
			--AND PR.ID = (SELECT MAX(ID)
			--				FROM Payment_Recovery 
			--				WHERE Payment_Recovery.Payment_no = PR.Payment_no)
			AND (@isAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%')))
			AND PR.Transaction_date between @Reporting_from_date and @Reporting_to_date
	ORDER BY Estimate_Type, Payment_Type, Creditor_Number
	
	DROP TABLE #Temp_Estimate_Types
	DROP TABLE #Temp_Payment_Types
	DROP TABLE #Temp_Creditors
	DROP TABLE #Temp_Provider_Numbers
	DROP TABLE #Temp_CLAIM_PAYMENT_RUN
	
END

GO

GRANT  EXECUTE  ON [dbo].[usp_4_19_ClaimPaymentList]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_4_19_ClaimPaymentList]  TO [emius]
GO
