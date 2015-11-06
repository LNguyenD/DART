/****** Object:  StoredProcedure [dbo].[usp_Section66Claims]    Script Date: 04/09/2012 10:55:57 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_Section66Claims]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_Section66Claims]
GO

/****** Object:  StoredProcedure [dbo].[usp_Section66Claims]    Script Date: 04/09/2012 10:55:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usp_Section66Claims '1/1/2009', '1/1/2012', 1, 0

CREATE PROCEDURE [dbo].[usp_Section66Claims]
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
		Employer = PTD.legal_name,
		Date_S66_Received = S66.date_claim_received,
		Date_Acknowledgement_Letter_Sent = S66.date_claim_ack,
		Medical_Appointment_Date = S66.date_medical,
		DORP_Date_Of_Relevant_Particulars = S66.DORP,
		Action_Date = S66.action_date,
		Action_Type = S66.action_type
	FROM CLAIM_DETAIL CD
		JOIN s66_audit S66 ON S66.CLAIM_NO = CD.CLAIM_NUMBER
		JOIN CLAIM_ACTIVITY_DETAIL CAD ON CAD.CLAIM_NO = CD.CLAIM_NUMBER
		LEFT JOIN POLICY_TERM_DETAIL PTD ON PTD.POLICY_NO = CD.POLICY_NO
		LEFT JOIN CLAIMS_OFFICERS CO ON CO.ALIAS = CAD.CLAIMS_OFFICER
	WHERE S66.date_claim_received BETWEEN @Start_Date AND @End_Date
		AND (@IsAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%')))
		AND S66.ID = (SELECT MAX(S661.ID)
				FROM S66_AUDIT S661
				WHERE S661.CLAIM_NO = S66.CLAIM_NO
					AND S661.date_claim_received <= @End_Date)
	ORDER BY PTD.legal_name, S66.date_claim_received, S66.DORP
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_Section66Claims]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_Section66Claims]  TO [emius]
GO

