IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetWeeksIn') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].udf_GetWeeksIn
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetWeeksIn    Script Date: 07/28/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetWeeksIn(@DON DATETIME, @AsAt DATETIME)
	RETURNS INT
AS
BEGIN
	RETURN CEILING(DATEDIFF(D, @DON, DATEADD(D, 1, @AsAt)) / 7.0)
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO