IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetAWC_MaxTimeID') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetAWC_MaxTimeID
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetAWC_MaxTimeID    Script Date: 10/14/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetAWC_MaxTimeID(
	@System VARCHAR(10)
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @Time_ID datetime
	
	IF UPPER(@System) = 'TMF'
	BEGIN
		SET @Time_ID = (SELECT MAX(Time_ID) FROM [DART].[dbo].[TMF_AWC])
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		SET @Time_ID = (SELECT MAX(Time_ID) FROM [DART].[dbo].[EML_AWC])
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		SET @Time_ID = (SELECT MAX(Time_ID) FROM [DART].[dbo].[HEM_AWC])
	END
	
	RETURN @Time_ID
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
GRANT  EXECUTE  ON [dbo].udf_GetAWC_MaxTimeID TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_GetAWC_MaxTimeID TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_GetAWC_MaxTimeID TO [DART_Role]
GO