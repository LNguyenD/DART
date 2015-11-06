
/****** Object:  StoredProcedure [dbo].[usp_ProvisionalLiabilityAcceptanceComplianceRequirement]    Script Date: 03/28/2012 15:44:47 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_HEMProvisionalLiabilityAcceptanceComplianceRequirement]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_HEMProvisionalLiabilityAcceptanceComplianceRequirement]
GO
/****** Object:  StoredProcedure [dbo].[usp_HEMProvisionalLiabilityAcceptanceComplianceRequirement]    Script Date: 03/28/2012 15:44:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usp_HEMProvisionalLiabilityAcceptanceComplianceRequirement '2012', '1'
CREATE PROCEDURE [dbo].[usp_HEMProvisionalLiabilityAcceptanceComplianceRequirement] 
	@Year char(4),
	@Month	varchar(2)
AS
BEGIN
	SET NOCOUNT ON;
	
	CREATE TABLE #TEMP
	(
		Reporting_Month datetime,
		Claim_Number varchar(30),   
		Claims_Officer varchar(60),   
		Team varchar(15),
		Employer varchar(200),
		Liability_Status_From tinyint,
		Liability_Status_To tinyint,
		Date_Significant_Injury datetime,
		Date_Of_Liability_Updated datetime
	)
	
	declare @start datetime, @end datetime
	select @start = @Month + '/01/' + @Year
	select @end = DATEADD(MONTH, 1, @start)
	
	DECLARE @ExcludeDateClaimClose varchar(50)
	SET @ExcludeDateClaimClose = (SELECT [CONTROL].VALUE FROM [CONTROL] WHERE TYPE='constants' and ITEM = 'DateClaimClosed')
		
	INSERT INTO #TEMP
	SELECT 
		Reporting_Month = '' + convert(varchar(10),@start, 101) + '',
		Claim_Number = CD.Claim_number,   
		Claims_Officer = CO.First_Name + ' ' + CO.Last_Name,   
		Team = CO.grp,
		Employer = PTD.LEGAL_NAME,
		Liability_Status_From = 1,
		Liability_Status_To = CADA.Claim_Liability_Indicator,
		Date_Significant_Injury = CD.Date_Significant,
		Date_Of_Liability_Updated = CASE WHEN CAD.Claim_Liability_Indicator <> 1 THEN CADA.Date_of_liability ELSE NULL END
	FROM CAD_AUDIT CADA JOIN CLAIM_DETAIL CD ON CD.CLAIM_NUMBER = CADA.CLAIM_NO
			JOIN CLAIM_ACTIVITY_DETAIL CAD ON CAD.CLAIM_NO = CD.CLAIM_NUMBER
			LEFT JOIN CLAIMS_OFFICERS CO ON CO.Alias = CAD.CLAIMS_OFFICER
			LEFT JOIN POLICY_TERM_DETAIL PTD ON PTD.POLICY_NO = CD.POLICY_NO
	WHERE CD.Date_Significant >= @start
		AND CD.Date_Significant < @end
		AND CD.Is_rehab = 1
		AND
		(
			(
				-- "CAD.Claim_Liability_Indicator = 1" LIKE not being changed so far
				CAD.Claim_Liability_Indicator = 1
				AND CADA.ID = (SELECT TOP 1 CADA1.ID FROM CAD_AUDIT CADA1
							WHERE CADA1.CLAIM_NO = CADA.CLAIM_NO)
			)
			OR
			(
				-- select the first-updated record
				CAD.Claim_Liability_Indicator <> 1
				AND CADA.ID = (SELECT TOP 1 CADA1.ID FROM CAD_AUDIT CADA1
							WHERE CADA1.CLAIM_NO = CADA.CLAIM_NO
								AND CADA1.Claim_Liability_Indicator in (2,7,8,9,11)
							ORDER BY CADA1.ID)
			)
		)
		-- EXCLUDE null claim
		AND CD.Is_null <> 1
		-- EXCLUDE claims with liability status 12 no action after notification
		AND CAD.Claim_Liability_Indicator <> 12
		-- EXCLUDE Claims which are closed before October 2010
		AND ISNULL((SELECT TOP 1 CADA1.Claim_Closed_Flag
					FROM CAD_AUDIT CADA1
					WHERE CADA1.CLAIM_NO = CD.CLAIM_NUMBER
						AND ISNULL(CADA1.TRANSACTION_DATE,GETDATE()) <= CONVERT(Datetime, @ExcludeDateClaimClose )
					ORDER BY CADA1.TRANSACTION_DATE desc), 'N') = 'N'
	ORDER BY CADA.CLAIM_NO
	
	
	SELECT *,
		
		Calendar_Days = DATEDIFF(DAY, Date_Significant_Injury, Date_Of_Liability_Updated),
		Pass_Count = CASE WHEN DATEDIFF(DAY, Date_Significant_Injury, Date_Of_Liability_Updated) <= 7
			AND DATEDIFF(DAY, Date_Significant_Injury, Date_Of_Liability_Updated) >= 0 THEN 1 ELSE 0 END,
		Failure_Count = CASE WHEN DATEDIFF(DAY, Date_Significant_Injury, Date_Of_Liability_Updated) > 7
			OR DATEDIFF(DAY, Date_Significant_Injury, Date_Of_Liability_Updated) < 0
								OR Date_Of_Liability_Updated IS NULL THEN 1 ELSE 0 END,
		Total_Number_Of_Claim = 1
	FROM #TEMP
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_HEMProvisionalLiabilityAcceptanceComplianceRequirement]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_HEMProvisionalLiabilityAcceptanceComplianceRequirement]  TO [emius]
GO


