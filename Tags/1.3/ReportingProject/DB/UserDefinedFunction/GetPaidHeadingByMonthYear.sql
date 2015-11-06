/****** Object:  UserDefinedFunction [dbo].[udf_GetPrefixHeadingCombinMonthYear]    Script Date: 12/29/2011 09:31:00 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_GetPrefixHeadingCombinMonthYear]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_GetPrefixHeadingCombinMonthYear]
GO


/****** Object:  UserDefinedFunction [dbo].[udf_GetPrefixHeadingCombinMonthYear]    Script Date: 12/29/2011 09:31:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[udf_GetPrefixHeadingCombinMonthYear](@prefix varchar(400),@month int,@year int)
	returns varchar(500)
as
begin
	declare @returnVal varchar(500)
	set @returnVal = @prefix + ' '
	return CASE WHEN @month =1 THEN (@returnVal + 'Jan' + '-' + right(convert(varchar,@year),2))
			WHEN @month =2 THEN (@returnVal + 'Feb' + '-' + right(convert(varchar,@year),2))
			WHEN @month =3 THEN (@returnVal + 'Mar' + '-' + right(convert(varchar,@year),2))
			WHEN @month =4 THEN (@returnVal + 'Apr' + '-' + right(convert(varchar,@year),2))
			WHEN @month =5 THEN (@returnVal + 'May' + '-' + right(convert(varchar,@year),2))
			WHEN @month =6 THEN (@returnVal + 'Jun' + '-' + right(convert(varchar,@year),2))
			WHEN @month =7 THEN (@returnVal + 'Jul' + '-' + right(convert(varchar,@year),2))
			WHEN @month =8 THEN (@returnVal + 'Aug' + '-' + right(convert(varchar,@year),2))
			WHEN @month =9 THEN (@returnVal + 'Sep' + '-' + right(convert(varchar,@year),2))
			WHEN @month =10 THEN (@returnVal + 'Oct' + '-' + right(convert(varchar,@year),2))
			WHEN @month =11 THEN (@returnVal + 'Nov' + '-' + right(convert(varchar,@year),2))
			WHEN @month =12 THEN (@returnVal + 'Dec' + '-' + right(convert(varchar,@year),2))
		END	
end
GO



SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetPrefixHeadingCombinMonthYear]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetPrefixHeadingCombinMonthYear]  TO [emius]
GO