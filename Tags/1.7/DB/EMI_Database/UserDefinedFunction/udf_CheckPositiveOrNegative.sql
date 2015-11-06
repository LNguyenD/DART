/****** Object:  UserDefinedFunction [dbo].[udf_CheckPositiveOrNegative]    Script Date: 02/21/2013 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_CheckPositiveOrNegative]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_CheckPositiveOrNegative]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_CheckPositiveOrNegative]    Script Date: 02/21/2013 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[udf_CheckPositiveOrNegative](@Is_negative money)
	returns INTEGER
as
BEGIN
	return CASE WHEN  @Is_negative < 0 THEN -1
				ELSE 1
			END

end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_CheckPositiveOrNegative] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_CheckPositiveOrNegative] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_CheckPositiveOrNegative] TO [DART_Role]
GO
