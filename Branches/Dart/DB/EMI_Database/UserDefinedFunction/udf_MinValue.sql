/****** Object:  UserDefinedFunction [dbo].[udf_MinValue]    Script Date: 05/27/2013 14:43:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_MinValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_MinValue]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_MinValue]    Script Date: 05/27/2013 14:43:37 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




CREATE FUNCTION [dbo].[udf_MinValue](@num1 FLOAT, @num2 FLOAT)  
RETURNS FLOAT As  
BEGIN
	return CASE WHEN  @num1 >= @num2 THEN @num2
				ELSE @num1
			END
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF

GO
GRANT  EXECUTE  ON [dbo].[udf_MinValue] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_MinValue] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_MinValue] TO [DART_Role]
GO
