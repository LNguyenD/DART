IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetCPR_PeriodType') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetCPR_PeriodType
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetCPR_PeriodType    Script Date: 04/14/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetCPR_PeriodType(
	@Start_Date DATETIME
	,@End_Date DATETIME
)
RETURNS INT
AS
BEGIN
	-- Determine the last month period
	DECLARE @LastMonth_Start_Date datetime = DATEADD(m, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0))
	DECLARE @LastMonth_End_Date datetime = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59'
	
	-- Determine last two weeks: Start = last two weeks from yesterday; End = yesterday
	DECLARE @Last2Weeks_Start_Date datetime = DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
	DECLARE @Last2Weeks_End_Date datetime = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	
	DECLARE @IsLastMonthRange bit = 0
	IF DATEDIFF(d, @LastMonth_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @LastMonth_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLastMonthRange = 1
	END
	
	DECLARE @IsLast2WeeksRange bit = 0
	IF DATEDIFF(d, @Last2Weeks_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @Last2Weeks_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLast2WeeksRange = 1
	END
	
	-- Determine period type
	DECLARE @Period_Type int
	IF @IsLastMonthRange = 1
	BEGIN
		SET @Period_Type = 1
	END
	ELSE IF @IsLast2WeeksRange = 1
	BEGIN
		SET @Period_Type = 0
	END
	ELSE IF @IsLastMonthRange = 0 AND @IsLast2WeeksRange = 0
	BEGIN
		SET @Period_Type = -1
	END
	
	RETURN @Period_Type
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO