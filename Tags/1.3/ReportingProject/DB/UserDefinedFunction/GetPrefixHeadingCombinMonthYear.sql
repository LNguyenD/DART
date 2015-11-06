/****** Object:  UserDefinedFunction [dbo].[udf_GetPrefixHeadingCombinMonthYear]    Script Date: 12/29/2011 09:31:00 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_GetPrefixHeadingCombinMonthYear]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_GetPrefixHeadingCombinMonthYear]
GO


/****** Object:  UserDefinedFunction [dbo].[udf_GetPrefixHeadingCombinMonthYear]    Script Date: 12/29/2011 09:31:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[udf_GetPrefixHeadingCombinMonthYear](@prefix varchar(100),@month int,@year int)
	returns varchar(100)
as
begin
	declare @returnVal varchar(100)
	set @returnVal = @prefix + ' '
	return CASE WHEN @month =1 THEN (@returnVal + 'Jan' + ' -' + convert(varchar,@year))
			WHEN @month =2 THEN (@returnVal + 'Feb' + ' -' + convert(varchar,@year))
			WHEN @month =3 THEN (@returnVal + 'Mar' + ' -' + convert(varchar,@year))
			WHEN @month =4 THEN (@returnVal + 'Apr' + ' -' + convert(varchar,@year))
			WHEN @month =5 THEN (@returnVal + 'May' + ' -' + convert(varchar,@year))
			WHEN @month =6 THEN (@returnVal + 'Jun' + ' -' + convert(varchar,@year))
			WHEN @month =7 THEN (@returnVal + 'Jul' + ' -' + convert(varchar,@year))
			WHEN @month =8 THEN (@returnVal + 'Aug' + ' -' + convert(varchar,@year))
			WHEN @month =9 THEN (@returnVal + 'Sep' + ' -' + convert(varchar,@year))
			WHEN @month =10 THEN (@returnVal + 'Oct' + ' -' + convert(varchar,@year))
			WHEN @month =11 THEN (@returnVal + 'Nov' + ' -' + convert(varchar,@year))
			WHEN @month =12 THEN (@returnVal + 'Dec' + ' -' + convert(varchar,@year))
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