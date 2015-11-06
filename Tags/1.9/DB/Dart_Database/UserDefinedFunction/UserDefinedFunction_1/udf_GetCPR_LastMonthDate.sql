IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetCPR_LastMonthDate') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetCPR_LastMonthDate
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetCPR_LastMonthDate    Script Date: 09/07/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetCPR_LastMonthDate(
	@DateFrom DATETIME
	,@IsEndDate BIT
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @lastMonthDate datetime
	
	IF @IsEndDate = 0
	BEGIN
		/* Start of last month */
		SET @lastMonthDate = DATEADD(m, -1, DATEADD(m, DATEDIFF(m, 0, @DateFrom), 0))
	END
	ELSE
	BEGIN
		/* End of last month */
		SET @lastMonthDate = DATEADD(m, DATEDIFF(m, 0, @DateFrom), -1) + '23:59'
	END
	
	RETURN @lastMonthDate
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO