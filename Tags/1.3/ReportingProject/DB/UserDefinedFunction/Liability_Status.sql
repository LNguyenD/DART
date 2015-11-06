IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_ExtractLiabilityStatus]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_ExtractLiabilityStatus]
GO

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[udf_ExtractLiabilityStatus]
(
	@claim_liability_indicator tinyint
)
	returns varchar(20)
as
begin
	return (CASE WHEN @claim_liability_indicator = 5 THEN 1
			WHEN @claim_liability_indicator = 11 THEN 8
			WHEN @claim_liability_indicator = 12 THEN 6 ELSE ISNULL(@Claim_Liability_Indicator,0) END)
end
GO



GRANT  CONTROL ON [dbo].[udf_ExtractLiabilityStatus]  TO [EMICS]
GO
 
GRANT  CONTROL ON [dbo].[udf_ExtractLiabilityStatus]  TO [emius]
GO