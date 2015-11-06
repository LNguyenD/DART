/****** Object:  StoredProcedure [dbo].[usp_GetAllPolicies]    Script Date: 03/12/2012 16:44:34 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_GetAllPolicies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetAllPolicies]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllPolicies]    Script Date: 03/12/2012 16:44:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetAllPolicies]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT PolicyNo = policy_no,
		LegalName = legal_name,
		TradingName = TRADING_NAME,
		ABN,
		ACN = ACN_ARBN,
		StartYear = START_YEAR,
		PolicyStatus = POLICY_STATUS
	FROM policy_term_detail
	ORDER BY PolicyNo
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetAllPolicies]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetAllPolicies]  TO [emius]
GO




