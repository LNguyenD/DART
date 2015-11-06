IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetCPR_Last2WeeksDate') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetCPR_Last2WeeksDate
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetCPR_Last2WeeksDate    Script Date: 09/07/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetCPR_Last2WeeksDate(
	@DateFrom DATETIME
	,@IsEndDate BIT
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @last2WeeksDate datetime
	
	IF @IsEndDate = 0
	BEGIN
		/* Start of last 2 weeks */
		SET @last2WeeksDate = DATEADD(d, -14, CONVERT(datetime, CONVERT(char, @DateFrom, 106)))
	END
	ELSE
	BEGIN
		/* End of last 2 weeks */
		SET @last2WeeksDate = CONVERT(datetime, CONVERT(char, @DateFrom, 106)) + '23:59'
	END
	
	RETURN @last2WeeksDate
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO