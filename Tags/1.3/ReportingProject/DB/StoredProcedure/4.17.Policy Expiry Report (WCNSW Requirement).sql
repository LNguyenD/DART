
/****** Object:  StoredProcedure [dbo].[usp_PolicyExpiryReport]    Script Date: 03/21/2012 22:37:33 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_PolicyExpiryReport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_PolicyExpiryReport]
GO

/****** Object:  StoredProcedure [dbo].[usp_PolicyExpiryReport]    Script Date: 03/14/2012 22:37:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usp_PolicyExpiryReport '1/1/2009', '1/1/2012', 1, 0
CREATE PROCEDURE [dbo].[usp_PolicyExpiryReport] 
	@Reporting_from_date datetime,
	@Reporting_to_date datetime,	
	@IsAll bit,
	@IsRig bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @Reporting_from_date = convert(datetime, convert(char,  @Reporting_from_date, 106))
	SET @Reporting_to_date = convert(datetime, convert(char,  @Reporting_to_date, 106)) + '23:59'
	
	
    SELECT [Group] = dbo.[udf_ExtractGroup](grp),  
		Team = CO.grp,
		Claims_Officer = (CO.First_Name + ' ' + CO.Last_Name),		
		Policy_Number = PD.Policy_No,
		Policy_Expiry_Date = PD.PERIOD_EXPIRY,
		Claim_Number = CAD.Claim_no				
		
    FROM PREMIUM_DETAIL PD JOIN CLAIM_DETAIL CD ON PD.POLICY_NO = CD.Policy_No
		JOIN CLAIM_ACTIVITY_DETAIL CAD ON CD.Claim_Number = CAD.Claim_no
		JOIN CLAIMS_OFFICERS CO ON CAD.Claims_Officer = CO.Alias
	WHERE PD.PERIOD_EXPIRY between @Reporting_from_date and @Reporting_to_date
		AND (@IsAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%')))				
	
	ORDER BY [Group], Team, Claims_Officer, Policy_Number	
	
END

GO

GRANT  EXECUTE  ON [dbo].[usp_PolicyExpiryReport]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_PolicyExpiryReport]  TO [emius]
GO

