/****** Object:  StoredProcedure [dbo].[usp_ClaimClosedWithin2WeeksFromLastPayment]    Script Date: 03/26/2012 10:00:28 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_HEMClaimClosedWithin2WeeksFromLastPayment]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_HEMClaimClosedWithin2WeeksFromLastPayment]
GO


/****** Object:  StoredProcedure [dbo].[usp_ClaimClosedWithin2WeeksFromLastPayment]    Script Date: 03/26/2012 10:00:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_HEMClaimClosedWithin2WeeksFromLastPayment]
	@Year CHAR(4),
	@Month CHAR(2)
AS
BEGIN
	SET NOCOUNT ON;

	CREATE TABLE #TEMP
	(
		Reporting_Year_Month CHAR(7),
		Claim_Number VARCHAR(30),
		Claim_Officer VARCHAR(60),
		Team VARCHAR(10),
		Date_Of_Last_Payment DATETIME,
		Date_Claim_Closed DATETIME
	)

	DECLARE @ExcludeDateClaimClose varchar(50)
	SET @ExcludeDateClaimClose = (SELECT [CONTROL].VALUE FROM [CONTROL] WHERE TYPE='constants' and ITEM = 'DateClaimClosed')
	DECLARE @Reporting_date DATETIME, @Reporting_start DATETIME
	SET @Reporting_start = @Month + '/01/' + @Year
	SET @Reporting_date = DATEADD(MONTH, 1, @Reporting_start)
	
	INSERT INTO #TEMP
	SELECT Reporting_Year_Month =  @Year + ' ' + @Month,
		Claim_Number = CAD.CLAIM_NO,
		Claim_Officer = CO.First_Name + ' ' + CO.Last_Name,
		Team = CO.GRP,
		Date_Of_Last_Payment = (SELECT MAX(PAID_DATE)
								FROM CLAIM_PAYMENT_RUN CPR
								WHERE CPR.Claim_number = CAD.CLAIM_NO
									AND CPR.PAID_DATE < @Reporting_date),
		Date_Claim_Closed = CAD.Date_Claim_Closed
		
	FROM CLAIM_ACTIVITY_DETAIL CAD LEFT JOIN MEDICAL_CERT MC ON MC.CLAIM_NO = CAD.CLAIM_NO
			LEFT JOIN CLAIMS_OFFICERS CO ON CO.ALIAS = CAD.CLAIMS_OFFICER
			left JOIN CLAIM_DETAIL CD ON CD.CLAIM_NUMBER = CAD.Claim_no
	WHERE MC.ID = (SELECT TOP 1 ID  
				from medical_cert mc2    
				where mc2.claim_no = mc.claim_no AND mc2.is_deleted = 0 
				order by mc2.Date_To desc)
		AND MC.TYPE IN ('I', 'M')
		-- exclude claims which closed before October 2010 
		AND ISNULL((SELECT TOP 1 CADA1.Claim_Closed_Flag
					FROM CAD_AUDIT CADA1
					WHERE CADA1.CLAIM_NO = CD.CLAIM_NUMBER
						AND ISNULL(CADA1.TRANSACTION_DATE,GETDATE()) <= CONVERT(Datetime, @ExcludeDateClaimClose )
					ORDER BY CADA1.TRANSACTION_DATE desc), 'N') = 'N'
		AND CD.Is_null <> 1
		--AND CAD.Claim_no = '11032181'
		AND EXISTS (SELECT 1 FROM Payment_Recovery PR 
					WHERE DATEDIFF(DAY, PR.Transaction_date, (SELECT MAX(PR2.Transaction_date)
														FROM Payment_Recovery PR2
														WHERE PR2.Claim_No = CAD.Claim_no)) = 0
						AND PR.Claim_No = CAD.Claim_no 
						AND Reversed <> 1)
												
	SELECT *,
		Compliance_Required_Close_Date = DATEADD(DAY, 14, Date_Of_Last_Payment),
		Pass_Count = CASE WHEN DATEADD(dd, DATEDIFF(dd, 0, Date_Claim_Closed), 0) <= DATEADD(dd, DATEDIFF(dd, 0, DATEADD(DAY, 14, Date_Of_Last_Payment)), 0) THEN 1 ELSE 0 END,
		Total_Number_Of_Claims = 1
	FROM #TEMP
	WHERE 
		-- the 'Compliance Required Close Date' is within the reporting month 
		DATEADD(DAY, 14, Date_Of_Last_Payment) >= @Reporting_start 
		AND DATEADD(DAY, 14, Date_Of_Last_Payment) < @Reporting_date
	ORDER BY CLAIM_NUMBER

	DROP TABLE #TEMP
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_HEMClaimClosedWithin2WeeksFromLastPayment]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_HEMClaimClosedWithin2WeeksFromLastPayment]  TO [emius]
GO

-- exec [usp_HEMClaimClosedWithin2WeeksFromLastPayment] '2012', '1'


