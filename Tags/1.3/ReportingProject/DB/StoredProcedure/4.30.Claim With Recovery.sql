
/****** Object:  StoredProcedure [dbo].[usp_ClaimsWithRecovery]    Script Date: 03/05/2012 11:39:49 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_ClaimsWithRecovery]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_ClaimsWithRecovery]
GO

/****** Object:  StoredProcedure [dbo].[usp_ClaimsWithRecovery]    Script Date: 03/05/2012 11:39:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usp_ClaimsWithRecovery '1/1/2012', 1, 0

CREATE PROCEDURE [dbo].[usp_ClaimsWithRecovery]
	@Reporting_date datetime,
	@IsAll bit,
	@IsRig bit
AS
BEGIN
	SET NOCOUNT ON;
	
	SET @Reporting_date = convert(datetime, convert(char,  @Reporting_date, 106)) + '23:59'
	SELECT 
		Claim_Number = CD.CLAIM_NUMBER,
		Claimant = ISNULL(CD.given_names,'') +' '+ ISNULL(CD.last_names,''),
		Employer_Name = PTD.legal_name,
		Recovery_Commencement_Date  = CAD.Recovery_commenced_date,
		Date_Recovery_Payments_Received = ( SELECT MIN(PAID_DATE) 
											FROM (	SELECT PR.CLAIM_NO, PR.PAYMENT_NO, PAID_DATE = MIN(Paid_Date)
													FROM CLAIM_PAYMENT_RUN CPR JOIN Payment_Recovery PR ON CPR.CLAIM_NUMBER = PR.CLAIM_NO AND CPR.PAYMENT_NO = PR.PAYMENT_NO
													WHERE Claim_number = CAD.CLAIM_NO
													GROUP BY PR.PAYMENT_NO, PR.CLAIM_NO
													HAVING SUM(PR.GROSS) < 0) AS TBL) ,
		Date_Recovery_Closed = CAD.Date_Recovery_Closed,
		Claim_Closed_Flag = (Select top 1 CADA.Claim_Closed_Flag
							From CAD_AUDIT CADA
							where CADA.Claim_no = CAD.Claim_no
								And CADA.Transaction_Date <= @Reporting_date
							Order by CADA.ID desc) 
	FROM CLAIM_DETAIL CD JOIN CLAIM_ACTIVITY_DETAIL CAD ON CD.CLAIM_NUMBER = CAD.CLAIM_NO
			LEFT JOIN POLICY_TERM_DETAIL PTD ON CD.Policy_No = PTD.Policy_No
			LEFT JOIN CLAIMS_OFFICERS CO ON CAD.Claims_Officer = CO.Alias
	WHERE CD.IS_CTP_RECOVERY = 1
		AND CAD.Recovery_commenced_date <= @Reporting_date
		AND (@IsAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%')))
	ORDER BY CAD.Recovery_commenced_date, CD.CLAIM_NUMBER

END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_ClaimsWithRecovery]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_ClaimsWithRecovery]  TO [emius]
GO



