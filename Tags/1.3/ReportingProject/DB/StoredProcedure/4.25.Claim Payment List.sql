
/****** Object:  StoredProcedure [dbo].[usp_ClaimPaymentList]    Script Date: 03/05/2012 22:37:33 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_ClaimPaymentList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_ClaimPaymentList]
GO

/****** Object:  StoredProcedure [dbo].[usp_ClaimPaymentList]    Script Date: 03/26/2012 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ClaimPaymentList] 
	@Reporting_from_date datetime,
	@Reporting_to_date datetime,
	@Payment_types varchar(8000),	
	@IsAll bit,
	@IsRIG bit
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
	
	CREATE TABLE #Temp_CLAIM_PAYMENT_RUN
	(
		Payment_no int,
		Cheque_no varchar(20),
		Payee_Name varchar(150),
		--Gross_Amount money
	)
	INSERT INTO #Temp_CLAIM_PAYMENT_RUN
	Select PR1.Payment_no, Cheque_no = MAX(Cheque_no), Payee_Name = MAX(Payee_Name)--, Gross_Amount = SUM(PR1.Gross)					
	from CLAIM_PAYMENT_RUN CPR1 join Payment_Recovery PR1 on CPR1.Payment_no = PR1.Payment_no
	where PR1.Transaction_date between @Reporting_from_date	and @Reporting_to_date and PR1.Reversed <> 1
	group by PR1.Payment_no
			
	
    SELECT Payment_Type = PR.Payment_Type, PR.Reversed,
		Claim_Number = CD.Claim_Number,		
		Claimant = ISNULL(CD.given_names,'') +' '+ ISNULL(CD.last_names,''),		
		Payment_Number = PR.Payment_no,
		Cheque_Number = CPR.Cheque_no,
		Payee = CPR.Payee_Name,
		Gross_Amount = PR.Gross,
		From_Date = case when dbo.[udf_IsWagePayment](PR.Payment_Type) = 1 then PR.Period_Start_Date else null end, 
		To_Date = case when dbo.[udf_IsWagePayment](PR.Payment_Type) = 1 then PR.Period_End_Date else null end,
		Service_Date = case when dbo.[udf_IsWagePayment](PR.Payment_Type) = 0 then PR.Date_of_Service else null end
    FROM #Temp_CLAIM_PAYMENT_RUN CPR JOIN Payment_Recovery PR ON CPR.Payment_no = PR.Payment_no 
		JOIN CLAIM_DETAIL CD ON PR.Claim_No = CD.Claim_Number
		JOIN CLAIM_ACTIVITY_DETAIL CAD ON CD.Claim_Number = CAD.Claim_no
		JOIN CLAIMS_OFFICERS CO ON CAD.Claims_Officer = CO.Alias	
	WHERE PR.Payment_Type in (select * from #Temp_Payment_Types)
			--AND PR.ID = (Select MAX(ID) From Payment_Recovery Where Payment_no = PR.Payment_no)
			AND (@IsAll = 1 OR ((@IsRIG = 0 AND grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND grp LIKE 'RIG%')))
			AND PR.Transaction_date between @Reporting_from_date and @Reporting_to_date
			AND PR.Reversed <> 1
	ORDER BY Payment_Type, Claim_Number
						
	
	DROP TABLE #Temp_Payment_Types
	DROP TABLE #Temp_CLAIM_PAYMENT_RUN	
END

GO

GRANT  EXECUTE  ON [dbo].[usp_ClaimPaymentList]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_ClaimPaymentList]  TO [emius]
GO

-- exec usp_ClaimPaymentList '07/01/2011', '07/31/2011', 'wpt003', 1, 0
