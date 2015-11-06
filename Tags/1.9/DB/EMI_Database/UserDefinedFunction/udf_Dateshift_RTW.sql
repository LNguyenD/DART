IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_Dateshift_RTW') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_Dateshift_RTW
GO

/****** Object:  UserDefinedFunction [dbo].udf_Dateshift_RTW    Script Date: 06/05/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
CREATE function [dbo].udf_Dateshift_RTW(@shiftdate datetime, @mths int)
	RETURNS DATETIME
AS
BEGIN
	RETURN DATEADD(d
		,dbo.udf_MinValue(DAY(@shiftdate) - 1
						,DAY(DATEADD(m, DATEDIFF(m, 0, DATEADD(m, @mths + 1, @shiftdate)), -1)))
		,DATEADD(m, DATEDIFF(m, 0, DATEADD(m, @mths, @shiftdate)), -1))
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].udf_Dateshift_RTW TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_Dateshift_RTW TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_Dateshift_RTW TO [DART_Role]
GO