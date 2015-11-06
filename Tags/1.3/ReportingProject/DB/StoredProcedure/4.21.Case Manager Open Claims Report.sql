
/****** Object:  StoredProcedure [dbo].[usp_CaseManagerOpenClaimsReport]    Script Date: 03/05/2012 22:37:33 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_CaseManagerOpenClaimsReport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_CaseManagerOpenClaimsReport]
GO
--exec [usp_CaseManagerOpenClaimsReport] '12/31/2011' ,'RM4', 1, 1, 0
/****** Object:  StoredProcedure [dbo].[usp_CaseManagerOpenClaimsReport]    Script Date: 03/14/2012 22:37:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_CaseManagerOpenClaimsReport] 
	@Reporting_date datetime,
	@UserName varchar(20),
	@IsAll bit,
	@IsTeamLeader bit,
	@IsRig bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @Reporting_date = convert(datetime, convert(char,  @Reporting_date, 106)) + '23:59'
	DECLARE @CvtDateStr varchar(30)
	SET @CvtDateStr = convert(varchar(20),@Reporting_date, 113)
		
	
    SELECT [Group] = dbo.[udf_ExtractGroup](grp),  
		Team = CO.grp,
		Claims_Officer = (CO.First_Name + ' ' + CO.Last_Name),		
		Claim_Number = CADA.Claim_no,		
		Worker_Name = ISNULL(CD.given_names,'') + ' ' + ISNULL(CD.last_names,''),
		Employer = PTD.LEGAL_NAME,
		Date_Of_Injury = CD.Date_of_Injury,
		Payments = isnull((SELECT Sum(Trans_amount)   
					 FROM  PAYMENT_RECOVERY   
					 WHERE PAYMENT_RECOVERY.Transaction_Date <= @CvtDateStr
						AND PAYMENT_RECOVERY.Claim_No = CADA.Claim_No ),0) ,  
		Estimates = isnull((SELECT Sum(Amount)   
							 FROM  ESTIMATE_DETAILS   
							 WHERE ESTIMATE_DETAILS.Transaction_Date <= @CvtDateStr
								AND CADA.Claim_No = ESTIMATE_DETAILS.Claim_No ),0),
					--+ isnull((SELECT Sum(itc)   
					--		 FROM  ESTIMATE_DETAILS   
					--		 WHERE ESTIMATE_DETAILS.Transaction_Date <= @CvtDateStr
					--			AND CADA.Claim_No = ESTIMATE_DETAILS.Claim_No ),0) 
					--+ isnull((SELECT Sum(dam)   
					--		 FROM  ESTIMATE_DETAILS   
					--		 WHERE ESTIMATE_DETAILS.Transaction_Date <= @CvtDateStr 
					--			AND CADA.Claim_No = ESTIMATE_DETAILS.Claim_No ),0) ,		
		Broker_Name = BR.NAME,
		Work_Status_Code = CADA.Work_Status_Code,
		Liability_Status_Indicator = CADA.Claim_Liability_Indicator
		
    FROM CAD_AUDIT CADA 
		LEFT JOIN CLAIMS_OFFICERS CO ON CADA.Claims_Officer = CO.Alias
		LEFT JOIN CLAIM_DETAIL CD ON CD.Claim_Number = CADA.Claim_no
		LEFT JOIN POLICY_TERM_DETAIL PTD ON PTD.POLICY_NO = CD.Policy_No
		LEFT JOIN  BROKER BR  ON PTD.BROKER_NO = BR.BROKER_NO 		
		
	WHERE (@IsTeamLeader = 1 OR (@IsTeamLeader = 0 AND CO.Alias = @UserName))
			AND  CADA.ID = (SELECT MAX(CADA1.ID)
					FROM CAD_AUDIT CADA1
					WHERE CADA1.Claim_no = CADA.Claim_no
						AND CADA1.Transaction_date <= @Reporting_date)
			AND isnull(CADA.CLAIM_CLOSED_FLAG,'N') <> 'Y'
			AND (@isAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%')))	
	ORDER BY [Group], Team, Claims_Officer, Claim_Number	
	
END

GO

GRANT  EXECUTE  ON [dbo].[usp_CaseManagerOpenClaimsReport]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_CaseManagerOpenClaimsReport]  TO [emius]
GO

