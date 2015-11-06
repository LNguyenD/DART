/****** Object:  UserDefinedFunction [dbo].[udf_BuildYearList]    Script Date: 03/26/2012 10:33:45 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_BuildMonthList]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_BuildMonthList]
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
CREATE FUNCTION [dbo].[udf_BuildMonthList]
(
)
RETURNS 
@Months TABLE 
(
	[Month] smallint
)
AS
BEGIN
	DECLARE @Start_month tinyint
	SET @Start_month = 1
	WHILE @Start_month <= 12 BEGIN
		INSERT INTO @Months VALUES (@Start_month)
		SET @Start_month = @Start_month + 1
	END
	RETURN 
END

GO

GRANT  CONTROL  ON [dbo].[udf_BuildMonthList]  TO [EMICS]
GO

GRANT  CONTROL  ON [dbo].[udf_BuildMonthList]  TO [EMIUS]
GO
