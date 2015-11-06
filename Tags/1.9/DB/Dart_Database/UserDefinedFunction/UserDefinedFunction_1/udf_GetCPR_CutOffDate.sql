IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetCPR_CutOffDate') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetCPR_CutOffDate
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetCPR_CutOffDate    Script Date: 09/07/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetCPR_CutOffDate(
	@System VARCHAR(10)
)
RETURNS DATETIME
AS
BEGIN
	/* Get the latest cut-off date from CONTROL table */
	DECLARE @cut_off_date_dte datetime
	
	SELECT TOP 1 @cut_off_date_dte = CAST(SUBSTRING([VALUE], 7, 4) + '-'
										+ SUBSTRING([VALUE], 4, 2) + '-'
										+ LEFT([VALUE], 2) AS datetime) + '23:59'
	FROM [CONTROL] WHERE ITEM like '%heart%' AND [TYPE] = UPPER(@System)
	
	IF @cut_off_date_dte IS NULL
	BEGIN
		SET @cut_off_date_dte = GETDATE()
	END
	
	RETURN @cut_off_date_dte
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO