
/****** Object:  StoredProcedure [dbo].[usp_OpenClaimsList]    Script Date: 03/05/2012 22:37:33 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_WeeklyBenefitsReport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_WeeklyBenefitsReport]
GO

/****** Object:  StoredProcedure [dbo].[usp_UndrawnPayments]    Script Date: 03/14/2012 22:37:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_WeeklyBenefitsReport] 
	@Reporting_from_date datetime,
	@Reporting_to_date datetime,	
	@IsAll bit, 
	@IsRIG bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @Reporting_from_date = convert(datetime, convert(char,  @Reporting_from_date, 106))
	SET @Reporting_to_date = convert(datetime, convert(char,  @Reporting_to_date, 106)) + '23:59'
	
	
    SELECT Claim_Number = CD.Claim_Number,
		Claimant = ISNULL(CD.Given_Names,'') + ' ' + ISNULL(CD.Last_Names,''),
		Employer = PTD.LEGAL_NAME,
		Payment_Type = PR.Payment_Type,
		Number_of_Weeks_Paid = (CONVERT(decimal(10,2), (SUM(ISNULL(PR.WEEKS_PAID, 0)) * 5 + SUM(ISNULL(PR.DAYS_PAID, 0))))) / 5,
		Last_Date_Paid = (SELECT MAX(PR1.Transaction_date)
							FROM Payment_Recovery PR1
							WHERE PR1.Claim_No = CD.Claim_Number
									AND PR1.Payment_Type = PR.Payment_Type
									AND PR1.Transaction_date between @Reporting_from_date and @Reporting_to_date				
									AND	PR1.Reversed <> 1)
    FROM Payment_Recovery PR JOIN CLAIM_DETAIL CD ON PR.Claim_No = CD.Claim_Number		
		LEFT JOIN POLICY_TERM_DETAIL PTD ON CD.Policy_No = PTD.POLICY_NO
		JOIN CLAIM_ACTIVITY_DETAIL CAD ON CD.Claim_Number = CAD.Claim_no
		LEFT JOIN CLAIMS_OFFICERS CO ON CAD.Claims_Officer = CO.Alias		
	WHERE dbo.[udf_IsWagePayment](PR.Payment_Type) = 1
			AND PR.Transaction_date between @Reporting_from_date and @Reporting_to_date				
			AND	PR.Reversed <> 1
			AND (@IsAll = 1 OR ((@IsRIG = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND Grp LIKE 'RIG%')))
			--AND PR.ID = (SELECT MIN(ID) FROM Payment_Recovery WHERE Payment_Recovery.Claim_No = CD.Claim_Number)
	GROUP BY CD.Claim_Number, ISNULL(CD.Given_Names,'') + ' ' + ISNULL(CD.Last_Names,''), PTD.LEGAL_NAME,
				PR.Payment_Type
	ORDER BY Payment_Type, Employer	
	
END

GO

GRANT  EXECUTE  ON [dbo].[usp_WeeklyBenefitsReport]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_WeeklyBenefitsReport]  TO [emius]
GO

--exec usp_WeeklyBenefitsReport '20101001', '20121031', 0, 0