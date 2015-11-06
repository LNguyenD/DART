
/****** Object:  StoredProcedure [dbo].[usp_DeathBenefits]    Script Date: 03/05/2012 22:37:33 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_DeathBenefits]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_DeathBenefits]
GO

/****** Object:  StoredProcedure [dbo].[usp_DeathBenefits]    Script Date: 03/26/2012 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usp_DeathBenefits '1/1/2009', '1/1/2012', 1, 0

CREATE PROCEDURE [dbo].[usp_DeathBenefits] 
	@Reporting_from_date datetime,
	@Reporting_to_date datetime,		
	@IsAll bit,
	@IsRig bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @Reporting_from_date = convert(datetime, convert(char,  @Reporting_from_date, 106))
	SET @Reporting_to_date = convert(datetime, convert(char,  @Reporting_to_date, 106)) + '23:59'
	
		
	CREATE TABLE #Temp_CLAIM_PAYMENT_RUN
	(
		Payment_no int,		
		Payee_Name varchar(150)
	)
	INSERT INTO #Temp_CLAIM_PAYMENT_RUN
	Select CPR1.Payment_no, Payee_Name = MAX(Payee_Name)
	from CLAIM_PAYMENT_RUN CPR1 join Payment_Recovery PR1 on CPR1.Payment_no = PR1.Payment_no
	where PR1.Transaction_date between @Reporting_from_date	and @Reporting_to_date
	group by CPR1.Payment_no
	
	
    SELECT Payment_Type = PR.Payment_Type, 
		Claim_Number = CD.Claim_Number,		
		Claimant = ISNULL(CD.given_names,'') +' '+ ISNULL(CD.last_names,''),	
		Payee = CPR.Payee_Name,
		From_Date = PR.Period_Start_Date,
		To_Date = PR.Period_End_Date,
		Gross = PR.Gross,
		Tax = PR.Tax_Amt,
		Net = PR.Net_amt
    FROM #Temp_CLAIM_PAYMENT_RUN CPR JOIN Payment_Recovery PR ON CPR.Payment_no = PR.Payment_no
		JOIN CLAIM_DETAIL CD ON PR.Claim_No = CD.Claim_Number
		JOIN CLAIM_ACTIVITY_DETAIL CAD ON CD.Claim_Number = CAD.Claim_no
		JOIN CLAIMS_OFFICERS CO ON CAD.Claims_Officer = CO.Alias		
	WHERE left(PR.Payment_Type, 3) = 'DEC'
			AND PR.Reversed = 0			
			AND (@IsAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%')))
			AND PR.Transaction_date between @Reporting_from_date and @Reporting_to_date
	ORDER BY Claim_Number, Payment_Type
	
	DROP TABLE #Temp_CLAIM_PAYMENT_RUN
END

GO

GRANT  EXECUTE  ON [dbo].[usp_DeathBenefits]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_DeathBenefits]  TO [emius]
GO
