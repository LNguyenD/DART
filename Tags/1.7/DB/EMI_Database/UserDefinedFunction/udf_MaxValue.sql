/****** Object:  UserDefinedFunction [dbo].[udf_MaxValue]    Script Date: 05/27/2013 14:42:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_MaxValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_MaxValue]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_MaxValue]    Script Date: 05/27/2013 14:42:39 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




CREATE FUNCTION [dbo].[udf_MaxValue](@num1 FLOAT, @num2 FLOAT)  
RETURNS FLOAT As  
BEGIN
	return CASE WHEN  @num1 >= @num2 THEN @num1
				ELSE @num2
			END
END  


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF

GO
GRANT  EXECUTE  ON [dbo].[udf_MaxValue] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_MaxValue] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_MaxValue] TO [DART_Role]
GO


