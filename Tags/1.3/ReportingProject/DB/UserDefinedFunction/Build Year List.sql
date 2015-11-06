/****** Object:  UserDefinedFunction [dbo].[udf_BuildYearList]    Script Date: 03/26/2012 10:33:45 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_BuildYearList]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_BuildYearList]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_BuildYearList]    Script Date: 03/26/2012 10:33:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[udf_BuildYearList]
(
	@Start_year smallint,
	@End_year smallint
)
RETURNS 
@Years TABLE 
(
	[Year] smallint
)
AS
BEGIN
	DECLARE @current_date datetime
	SELECT @current_date = dt from get_date
		
	IF @End_year IS NULL OR @End_year < @Start_year BEGIN
		SET @End_year = CONVERT(varchar(4), @current_date, 120)
	END
	WHILE @Start_year <= @End_year BEGIN
		INSERT INTO @Years VALUES (@Start_year)
		SET @Start_year = @Start_year + 1
	END
	
	RETURN 
END
GO

GRANT  CONTROL  ON [dbo].[udf_BuildYearList]  TO [EMICS]
GO

GRANT  CONTROL  ON [dbo].[udf_BuildYearList]  TO [EMIUS]
GO