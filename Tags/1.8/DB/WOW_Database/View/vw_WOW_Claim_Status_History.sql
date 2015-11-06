SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Dustin (DART)
-- CREATE date: 07/03/2015 10:00:00
-- Description:	SQL View to retrieve the claim status history information
-- =============================================
IF EXISTS(SELECT * FROM sys.views WHERE name = 'vw_WOW_Claim_Status_History')
	DROP VIEW [dbo].[vw_WOW_Claim_Status_History]
GO
	CREATE VIEW [dbo].[vw_WOW_Claim_Status_History]
	AS
	SELECT	CSH.Id as ID
			,A.Claim AS CLAIM_NO
			,CSH.ClaimStatus AS CLAIM_STATUS
			,CSH.ChangedOn AS DTE_STATUS_CHANGED
	FROM	ClaimStatusHistory AS CSH
			INNER JOIN AccData AS A ON A.CLAIMID = CSH.CLAIMID
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO