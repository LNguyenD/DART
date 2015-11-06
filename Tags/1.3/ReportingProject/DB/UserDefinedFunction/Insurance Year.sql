/****** Object:  UserDefinedFunction [dbo].[udf_InsuranceYear]    Script Date: 04/05/2012 14:55:33 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_InsuranceYear]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_InsuranceYear]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_InsuranceYear]    Script Date: 04/05/2012 14:55:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[udf_InsuranceYear](@start_year smallint, @end_year smallint)
RETURNS @tbl TABLE ([year] char(10), start_date datetime, end_date datetime)
AS
BEGIN
	DECLARE @copy_start smallint
	SET @copy_start = @start_year
	WHILE @start_year < @end_year BEGIN
		INSERT INTO @tbl VALUES (CONVERT(VARCHAR,@start_year) + '/' + CONVERT(VARCHAR,@start_year + 1), [dbo].[udf_GetFirstDateByQuarter](@start_year, 3), [dbo].[udf_GetLastDateByQuarter](@start_year + 1, 2) + '23:59')
		set @start_year = @start_year + 1
	END
	RETURN 
END

GO

GRANT  CONTROL ON [dbo].[udf_InsuranceYear]  TO [EMICS]
GO
 
GRANT  CONTROL ON [dbo].[udf_InsuranceYear]  TO [emius]
GO