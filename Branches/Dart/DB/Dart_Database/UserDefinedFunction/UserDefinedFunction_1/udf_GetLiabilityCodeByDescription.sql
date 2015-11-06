IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetLiabilityCodeByDescription') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetLiabilityCodeByDescription
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetLiabilityCodeByDescription    Script Date: 10/05/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
CREATE function [dbo].udf_GetLiabilityCodeByDescription(@System varchar(10), @Description varchar(256))
	RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @LiabilityCode varchar(10)
	SELECT @LiabilityCode = (case when @System <> 'WOW'
									then convert(varchar,Liability_Id)
								else Liability_Code
							end)
	FROM dbo.Dashboard_Claim_Liability_Indicator
	WHERE [System] = @System AND [Description] = @Description
	
	RETURN @LiabilityCode
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO