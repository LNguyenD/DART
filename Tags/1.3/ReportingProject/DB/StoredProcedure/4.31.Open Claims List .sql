
/****** Object:  StoredProcedure [dbo].[usp_OpenClaimsList]    Script Date: 03/05/2012 22:37:33 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_OpenClaimsList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_OpenClaimsList]
GO

/****** Object:  StoredProcedure [dbo].[usp_OpenClaimsList]    Script Date: 03/05/2012 22:37:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usp_OpenClaimsList '1/1/2012', 1, 0

CREATE PROCEDURE [dbo].[usp_OpenClaimsList] 
	@Reporting_date datetime,
	@IsAll bit,
	@IsRig bit
AS
BEGIN
	SET NOCOUNT ON;
	SET @Reporting_date = convert(datetime, convert(char,  @Reporting_date, 106)) + ' 23:59'
	SELECT [Group] = dbo.[udf_ExtractGroup](grp),  
		Team = CO.grp,
		Claims_Officer = (CO.First_Name + ' ' + CO.Last_Name),
		Policy_Number = CD.Policy_No,
		Claim_Number = CADA.Claim_no,
		Cost_Centre = CD.Cost_Centre,
		Claimant = ISNULL(CD.given_names,'') +' '+ ISNULL(CD.last_names,''),
		Date_Of_Injury = CD.Date_of_Injury,
		Age = dbo.udf_CalculateAge(CD.date_of_birth, GETDATE()),
		Employers_Mutual_Received_Date = CADA.Date_Claim_received,
		Nature_Of_Injury = CD.Nature_of_Injury,
		Weeks_Duration = (SELECT SUM(Weeks_paid) FROM PAYMENT_RECOVERY PR WHERE
			PR.Claim_no = CADA.Claim_no
			AND PR.Payment_type in ('WPT001', 'PT002', 'PT003', 'PT004','WPP001', 'WPP002', 'WPP003', 'WPP004')
			AND PR.transaction_date <= @Reporting_date) ,
		Partial_Incapacity_Claim_Flag = case when CD.Result_of_Injury_code = 3 THEN 1 ELSE '' END,
		Claim_Pass_12Weeks = CASE WHEN DATEDIFF(WEEK, CD.date_of_injury, @Reporting_date ) > 12 THEN 1 END
    FROM CLAIM_DETAIL CD JOIN CAD_AUDIT CADA ON CD.Claim_Number = CADA.Claim_no
		LEFT JOIN CLAIMS_OFFICERS CO ON CADA.Claims_Officer = CO.Alias
	WHERE CADA.ID = (SELECT MAX(CADA1.ID)
					FROM CAD_Audit CADA1
					WHERE CADA1.Claim_no = CADA.Claim_no
						AND CADA1.Transaction_date <= @Reporting_date)
		AND ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') <> 'Y'
		AND (@IsAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%'))) 
	ORDER BY [Group], Team, Claims_Officer, Claim_Number					
		
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[usp_OpenClaimsList]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_OpenClaimsList]  TO [emius]
GO



