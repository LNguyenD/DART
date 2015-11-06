/****** Object:  StoredProcedure [dbo].[usp_IndividualClaimEnquiryClientReviewNote]    Script Date: 03/06/2012 15:22:37 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_IndividualClaimEnquiryClientReviewNote]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_IndividualClaimEnquiryClientReviewNote]
GO

/****** Object:  StoredProcedure [dbo].[usp_IndividualClaimEnquiryClientReviewNote]    Script Date: 03/06/2012 15:22:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usp_IndividualClaimEnquiryClientReviewNote '1/1/2012', '', 1, 0
 
CREATE PROCEDURE [dbo].[usp_IndividualClaimEnquiryClientReviewNote]
	@Reporting_date datetime,
	@Policies varchar(8000),
	@IsAll bit,
	@IsRig bit
AS
BEGIN
	SET NOCOUNT ON;
	
	SET @Reporting_date = convert(datetime, convert(char,  @Reporting_date, 106)) + '23:59'
	
	CREATE TABLE #TEMP
	(
		Employer_Name VARCHAR(100),
		Policy_Number VARCHAR(30),
		Claim_Number VARCHAR(30),
		Claimant VARCHAR(100),
		[Address] VARCHAR(100),
		Date_Of_Birth DATETIME,
		Age INT,
		Date_Of_Injury DATETIME,
		Injury_Description VARCHAR(200),
		Weekly_Hours DECIMAL,
		Weekly_Rate DECIMAL,
		Incurred MONEY,
		Payments MONEY ,  
		Client_Review_Note VARCHAR(2000)
	)
	
	INSERT INTO #TEMP
	SELECT
		Employer_Name = PTD.legal_name,
		Policy_Number = CD.policy_no,
		Claim_Number = CD.Claim_number,
		Claimant = ISNULL(CD.given_names,'') +' '+ ISNULL(CD.last_names,''),
		[Address] = cd.Street_Address + ' ' + cd.Locality + ' ' + cd.State + ' ' + CONVERT(CHAR,cd.Postcode),
		Date_Of_Birth = CD.Date_of_birth,
		Age = CONVERT(INT, dbo.udf_CalculateAge(CD.date_of_birth, GETDATE())),
		Date_Of_Injury = CD.Date_of_Injury,
		Injury_Description = CD.Injury_comment,
		Weekly_Hours = CD.Work_Hours,
		Weekly_Rate = CD.Weekly_wage,
		Incurred = isnull((SELECT Sum(Amount)   
						 FROM  ESTIMATE_DETAILS   
						 WHERE ESTIMATE_DETAILS.Transaction_Date <= @Reporting_date
							AND CD.Claim_number = ESTIMATE_DETAILS.Claim_No ),0) 
					+ isnull((SELECT Sum(itc)  -- ICT 
					 FROM  ESTIMATE_DETAILS   
					 WHERE ESTIMATE_DETAILS.Transaction_Date <= @Reporting_date
						AND CD.Claim_number = ESTIMATE_DETAILS.Claim_No ),0)
					+ isnull((SELECT Sum(dam) -- DAM
					 FROM  ESTIMATE_DETAILS   
					 WHERE ESTIMATE_DETAILS.Transaction_Date <= @Reporting_date
						AND CD.Claim_number = ESTIMATE_DETAILS.Claim_No ),0),
		Payments = isnull((SELECT Sum(Trans_amount)   
					 FROM  PAYMENT_RECOVERY   
					 WHERE PAYMENT_RECOVERY.Transaction_Date <= @Reporting_date
						AND PAYMENT_RECOVERY.Claim_No = CD.Claim_number ),0) ,  
		Client_Review_Note = dbo.udf_GetClientReviewNote(CADA.Claim_no)
	FROM CLAIM_DETAIL CD JOIN POLICY_TERM_DETAIL PTD ON CD.Policy_no = PTD.Policy_no
		JOIN CAD_AUDIT CADA ON CD.Claim_number = CADA.Claim_no
		JOIN CLAIMS_OFFICERS CO ON CO.Alias = CADA.Claims_Officer
	WHERE 
		CD.policy_no in (SELECT * FROM dbo.udf_Split(@Policies, ','))
		-- include all OPEN CLAIM AS AT REPORTING DATE
		AND CADA.ID = (SELECT MAX(CADA1.ID)
				FROM CAD_Audit CADA1
				WHERE CADA1.Claim_no = CADA.Claim_no
					AND CADA1.Transaction_date <= @Reporting_date)
		AND ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') <> 'Y'
		AND (@IsAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%'))) 
		
	SELECT *,
		[Reserve] = Incurred - Payments
	FROM #TEMP
	ORDER BY Employer_Name, Policy_Number, Claim_Number
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_IndividualClaimEnquiryClientReviewNote]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_IndividualClaimEnquiryClientReviewNote]  TO [emius]
GO



