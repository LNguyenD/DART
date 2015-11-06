
/****** Object:  StoredProcedure [dbo].[usp_OpenClaimsList]    Script Date: 03/05/2012 22:37:33 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_UndrawnPayments]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_UndrawnPayments]
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
-- exec usp_UndrawnPayments '1/1/2012', 1, 0
CREATE PROCEDURE [dbo].[usp_UndrawnPayments] 
	@Reporting_date datetime,	
	@IsAll bit,
	@IsRIG bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @Reporting_date = convert(datetime, convert(char,  @Reporting_date, 106)) + '23:59'
	
	
    SELECT [Group] = dbo.[udf_ExtractGroup](grp),  
		Team = CO.grp,
		Claims_Officer = (CO.First_Name + ' ' + CO.Last_Name),		
		Claim_Number = CAD.Claim_no,		
		Claimant = ISNULL(CD.given_names,'') + ' ' + ISNULL(CD.last_names,''),
		Payment_No = CPR.Payment_no,
		Entry_Date = PR.create_date,
		Owner = CPR.Owner
    FROM CLAIM_PAYMENT_RUN CPR  JOIN CLAIM_DETAIL CD ON CPR.Claim_number = CD.Claim_Number
		JOIN CLAIM_ACTIVITY_DETAIL CAD ON CD.Claim_Number = CAD.Claim_no
		LEFT OUTER JOIN CLAIMS_OFFICERS CO ON CAD.Claims_Officer = CO.Alias
		JOIN Payment_Recovery PR ON CPR.Payment_no = PR.Payment_no
	WHERE CD.is_Read_Only = 0 AND CD.Fund = 2 AND isnull(CAD.Claim_Closed_Flag, 'N') <> 'Y' 
		AND (ISNULL(cheque_status, 0) < 3  OR ISNULL(cheque_status,0) = 9)
		AND CPR.Drawn_date is null
		AND PR.ID = (select min(ID) From Payment_Recovery where Payment_Recovery.Payment_no = CPR.Payment_no) 
		AND PR.create_date <= @Reporting_date						
		AND (@IsAll = 1 OR ((@IsRIG = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND Grp LIKE 'RIG%')))	
	ORDER BY [Group], Team, Claims_Officer, Claim_Number	
	
END

GO

GRANT  EXECUTE  ON [dbo].[usp_UndrawnPayments]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_UndrawnPayments]  TO [emius]
GO

