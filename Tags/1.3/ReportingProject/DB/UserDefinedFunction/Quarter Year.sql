/****** Object:  UserDefinedFunction [dbo].[udf_ListQuarterYear]    Script Date: 05/09/2012 21:50:47 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_ListQuarterYear]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_ListQuarterYear]
GO


/****** Object:  UserDefinedFunction [dbo].[udf_ListQuarterYear]    Script Date: 05/09/2012 21:50:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[udf_ListQuarterYear]
(
@start_year smallint, @start_quarter smallint, @end_year smallint, @end_quarter smallint
)
RETURNS @tbl TABLE ([year] smallint, [quarter] smallint, [start_date] datetime, end_date datetime)
AS
BEGIN
	DECLARE @NoOfQuarter smallint
	SET @NoOfQuarter = (@end_year - @start_year) * 4 + (@end_quarter - @start_quarter)
	WHILE @NoOfQuarter >= 0 BEGIN
		INSERT INTO @tbl VALUES (@start_year, @start_quarter, [dbo].[udf_GetFirstDateByQuarter](@start_year, @start_quarter), [dbo].[udf_GetLastDateByQuarter](@start_year, @start_quarter))
		IF @start_quarter = 4 BEGIN
			SELECT @start_quarter = 1,
				@start_year = @start_year + 1
		END ELSE BEGIN
			SELECT @start_quarter = @start_quarter + 1
		END
		SELECT @NoOfQuarter = @NoOfQuarter - 1
	END
	RETURN 
END

GO

GRANT  CONTROL ON [dbo].[udf_ListQuarterYear]  TO [EMICS]
GO
 
GRANT  CONTROL ON [dbo].[udf_ListQuarterYear]  TO [emius]
GO


