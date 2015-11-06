IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_HEMPoliciesReport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_HEMPoliciesReport]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- exec usp_HEMPoliciesReport '1/1/2012' 
CREATE PROCEDURE usp_HEMPoliciesReport 
	@Reporting_date datetime
AS
BEGIN

	SET NOCOUNT ON;
	
	SET @Reporting_date = CONVERT(datetime, CONVERT(char,  @Reporting_date, 106)) + '23:59'
	declare @Start_date smalldatetime
	set @Start_date = DATEADD(YEAR, -1, @Reporting_date)
	
	SELECT 
		Policy_Number = PTD.Policy_no,
		Policy_Status = PTD.Policy_Status,
		Insured_Legal_Name = PTD.Legal_Name,
		Insured_Trading_Name = PTD.Trading_Name,
		ABN = PTD.ABN,
		AHA_NSW_Membership_Number = PTD.Association_Membership_No,
		Date_Policy_Commenced = PTD.INCEPTION_DATE,
		Current_Period_Commencement_Renewal_Date = PREMIUM_DETAIL.PERIOD_START,
		Current_Period_Expiry_Date = PREMIUM_DETAIL.PERIOD_EXPIRY,
		Wage_0 = PREMIUM_DETAIL.WAGES0,
		Wage_1 = PREMIUM_DETAIL.WAGES1,
		Wage_2 = PREMIUM_DETAIL.WAGES2,
		Claim_Cost_0 = PREMIUM_DETAIL.CLMSCOST_0,
		Claim_Cost_1 = PREMIUM_DETAIL.CLMSCOST_1,
		Claim_Cost_2 = PREMIUM_DETAIL.CLMSCOST_2,
		-- number of claims previous year
		Number_Of_Claims_0 = (SELECT Count(claim_number) from claim_detail 
								where YEAR(claim_detail.Date_of_Injury) = PREMIUM_DETAIL.POLICY_YEAR
								AND claim_detail.Policy_No = PTD.POLICY_NO),
		Number_Of_Claims_1 = (SELECT Count(claim_number) from claim_detail 
								where YEAR(claim_detail.Date_of_Injury) = PREMIUM_DETAIL.POLICY_YEAR -1
								AND claim_detail.Policy_No = PTD.POLICY_NO),
		Number_Of_Claims_2 = (SELECT Count(claim_number) from claim_detail 
								where YEAR(claim_detail.Date_of_Injury) = PREMIUM_DETAIL.POLICY_YEAR - 2
								AND claim_detail.Policy_No = PTD.POLICY_NO),
		PREMIUM_DETAIL.BTP,
		PREMIUM_DETAIL.EP,
		PREMIUM_DETAIL.PC_EP,
		PREMIUM_DETAIL.XAF,
		PREMIUM_DETAIL.BTPA,
		PREMIUM_DETAIL.EPA,
		PREMIUM_DETAIL.Prem_Discount_Rate,
		PREMIUM_DETAIL.Prem_Discount_Amount,
		PREMIUM_DETAIL.ICCR_WG * 100 as ICCR_WG,
		PREMIUM_DETAIL.ICCR_PC,
		PREMIUM_DETAIL.ECCR_WG * 100 as ECCR_WG,
		PREMIUM_DETAIL.ECCR_PC,
		PREMIUM_DETAIL.XS,
		PREMIUM_DETAIL.DDL,
		PREMIUM_DETAIL.ITC_Adjustment * -1 as ITD_Adjustment,
		PREMIUM_DETAIL.AIS_Amount,
		PREMIUM_DETAIL.PP,
		PREMIUM_DETAIL.GST,
		PREMIUM_DETAIL.Installment_Amt,
		PREMIUM_DETAIL.Installment_Amt * 3 as [Alternate Installment],
		-- end premium data
		Street_Address = PTD.ADDRESS_STREET,
		Postal_Address = PTD.POSTAL_STREET
	FROM POLICY_TERM_DETAIL PTD JOIN dbo.PREMIUM_DETAIL on PTD.POLICY_NO = PREMIUM_DETAIL.POLICY_NO
	WHERE PREMIUM_DETAIL.RENEWAL_NO = (SELECT MAX(PD1.RENEWAL_NO) FROM PREMIUM_DETAIL PD1
										WHERE PD1.POLICY_NO = PREMIUM_DETAIL.POLICY_NO)
		AND PTD.CANCELLED_DATETIME IS NULL
		AND PREMIUM_DETAIL.PERIOD_START > @Start_date AND PREMIUM_DETAIL.PERIOD_START <= @Reporting_date
	ORDER BY PTD.POLICY_NO
END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_HEMPoliciesReport]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_HEMPoliciesReport]  TO [emius]
GO

-- exec usp_HEMPoliciesReport '20120331'

