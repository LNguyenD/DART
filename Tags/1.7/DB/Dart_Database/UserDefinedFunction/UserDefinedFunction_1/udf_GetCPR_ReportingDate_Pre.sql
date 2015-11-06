IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetCPR_ReportingDate_Pre') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetCPR_ReportingDate_Pre
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetCPR_ReportingDate_Pre    Script Date: 04/14/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetCPR_ReportingDate_Pre(
	@System VARCHAR(10)
	,@Start_Date DATETIME
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @Reporting_Date_Pre datetime
	
	IF UPPER(@System) = 'TMF'
	BEGIN
		SET @Reporting_Date_Pre = (SELECT top 1 Reporting_Date FROM TMF_Portfolio
										WHERE CONVERT(datetime, Reporting_Date, 101)
											>= CONVERT(datetime, DATEADD(DAY, -1, @Start_Date) + '23:59', 101) order by Reporting_Date)
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		SET @Reporting_Date_Pre = (SELECT top 1 Reporting_Date FROM EML_Portfolio
										WHERE CONVERT(datetime, Reporting_Date, 101)
											>= CONVERT(datetime, DATEADD(DAY, -1, @Start_Date) + '23:59', 101) order by Reporting_Date)
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		SET @Reporting_Date_Pre = (SELECT top 1 Reporting_Date FROM HEM_Portfolio
										WHERE CONVERT(datetime, Reporting_Date, 101)
											>= CONVERT(datetime, DATEADD(DAY, -1, @Start_Date) + '23:59', 101) order by Reporting_Date)
	END
	
	RETURN @Reporting_Date_Pre
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO