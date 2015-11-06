/****** Object:  StoredProcedure [dbo].[usp_DurationReport]    Script Date: 04/06/2012 14:22:33 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_DurationReport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_DurationReport]
GO

/****** Object:  StoredProcedure [dbo].[usp_DurationReport]    Script Date: 04/06/2012 14:22:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usp_DurationReport '1/1/2009', '1/1/2012', 1, 0

CREATE PROCEDURE [dbo].[usp_DurationReport]
	@Start_Date datetime,
	@End_Date datetime,
	@IsAll bit,
	@IsRig bit
AS
BEGIN
	SET NOCOUNT ON;
	set @Start_Date = convert(datetime, convert(char,  @Start_Date, 106))
	set @End_Date = convert(datetime, convert(char,  @End_Date, 106)) + '23:59'
	
	SELECT 
		Claim_Number = CD.CLAIM_NUMBER,
		Claimant = ISNULL(CD.given_names,'') +' '+ ISNULL(CD.last_names,''),
		Employer_Name = PTD.legal_name,
		Number_Of_Week_Paid = ISNULL((	SELECT SUM(ISNULL(WEEKS_PAID, 0)) + 
													SUM(ISNULL(DAYS_PAID, 0))/
														(convert(tinyint,substring(ISNULL(cd.work_days, '1111100'),1,1)) + convert(tinyint,substring(ISNULL(cd.work_days, '1111100'),2,1)) +
														convert(tinyint,substring(ISNULL(cd.work_days, '1111100'),3,1)) + convert(tinyint,substring(ISNULL(cd.work_days, '1111100'),4,1)) +
														convert(tinyint,substring(ISNULL(cd.work_days, '1111100'),5,1)) + convert(tinyint,substring(ISNULL(cd.work_days, '1111100'),6,1)) +
														convert(tinyint,substring(ISNULL(cd.work_days, '1111100'),7,1)))
										
										FROM PAYMENT_RECOVERY PR
										WHERE PR.CLAIM_NO = CD.CLAIM_NUMBER), 0),
		Week_Duration = DATEDIFF(WEEK, ISNULL(CAD.Liability_Start, 0), CAD.Liability_End),
		Duration_Due_Date = CAD.Liability_End,
		Location_Of_Injury = CD.Location_Of_Injury,
		Nature_Of_Injury = CD.Nature_of_Injury
	FROM CLAIM_DETAIL CD 
		JOIN CLAIM_ACTIVITY_DETAIL CAD ON CAD.Claim_no = CD.CLAIM_NUMBER
		LEFT JOIN CLAIMS_OFFICERS CO ON CO.ALIAS = CAD.Claims_Officer
		LEFT JOIN POLICY_TERM_DETAIL PTD ON PTD.POLICY_NO = CD.POLICY_NO
	WHERE ISNULL(CAD.Claim_Closed_Flag, 'N') <> 'Y'
		AND CAD.Liability_End BETWEEN @Start_Date AND @End_Date
		AND (@IsAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%')))
	ORDER BY CD.CLAIM_NUMBER, ISNULL(CD.given_names,'') +' '+ ISNULL(CD.last_names,''), 
		CD.Location_Of_Injury, CD.Nature_of_Injury, CAD.Liability_End
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_DurationReport]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_DurationReport]  TO [emius]
GO

