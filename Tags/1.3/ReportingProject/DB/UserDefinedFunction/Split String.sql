
/****** Object:  UserDefinedFunction [dbo].[udf_Split]    Script Date: 12/29/2011 09:29:39 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_Split]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_Split]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_Split]    Script Date: 12/29/2011 09:29:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[udf_Split](@String NVARCHAR(4000), @Delimiter NVARCHAR(40))
	returns @tbl_values table (value nvarchar(4000))
as
begin
	DECLARE @NextString NVARCHAR(40)
	DECLARE @Pos INT
	DECLARE @NextPos INT
	SET @String = @String + @Delimiter
	SET @Pos = charindex(@Delimiter,@String)

	WHILE (@pos <> 0)
	BEGIN
	SET @NextString = substring(@String,1,@Pos - 1)
	insert into @tbl_values values (LTRIM(RTRIM(@NextString)))
	SET @String = substring(@String,@pos+1,len(@String))
	SET @pos = charindex(@Delimiter,@String)
	END 
	return
end

GO

 
GRANT  CONTROL  ON [dbo].[udf_Split]  TO [EMICS]
GO
 
GRANT  CONTROL  ON [dbo].[udf_Split]  TO [emius]
GO
