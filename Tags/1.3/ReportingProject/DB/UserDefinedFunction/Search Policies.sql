IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_SearchPolicies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SearchPolicies]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_SearchPolicies]
	@Employer nvarchar (200),
	@PolicyNo nvarchar(19),
	@ABN float,
	@ACN int
AS
BEGIN
	SELECT PolicyNo = policy_no,
		LegalName = legal_name,
		TradingName = TRADING_NAME,
		ABN,
		ACN = ACN_ARBN,
		StartYear = START_YEAR,
		PolicyStatus = POLICY_STATUS
	FROM policy_term_detail
	WHERE policy_no like ('' + @PolicyNo + '%')
	OR legal_name like ('%' + @Employer + '%')
	OR ABN = @ABN
	OR ACN_ARBN = @ACN
	ORDER BY PolicyNo
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_SearchPolicies]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_SearchPolicies]  TO [emius]
GO




