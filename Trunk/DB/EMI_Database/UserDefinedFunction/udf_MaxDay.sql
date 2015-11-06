/****** Object:  UserDefinedFunction [dbo].[udf_MaxDay]    Script Date: 02/21/2013 11:11:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_MaxDay]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_MaxDay]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_MaxDay]    Script Date: 02/21/2013 11:11:26 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


create function [dbo].[udf_MaxDay](@day1 DATETIME, @day2 DATETIME, @day3 DATETIME)
	returns DATETIME
as
begin
	return CASE WHEN @day1 >= @day2 and @day1 >= @day3 then @day1
				WHEN @day2 >= @day1 and @day2 >= @day3 then @day2
				WHEN @day3 >= @day1 and @day3 >= @day2 then @day3
			END
end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_MaxDay] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_MaxDay] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_MaxDay] TO [DART_Role]
GO

