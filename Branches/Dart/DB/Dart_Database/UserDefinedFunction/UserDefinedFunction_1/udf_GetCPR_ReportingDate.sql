IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetCPR_ReportingDate') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetCPR_ReportingDate
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetCPR_ReportingDate    Script Date: 04/14/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetCPR_ReportingDate(
	@System VARCHAR(10)
	,@Period_Type INT
	,@End_Date DATETIME
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @Reporting_Date datetime
	
	IF UPPER(@System) = 'TMF'
	BEGIN
		SET @Reporting_Date = case when @Period_Type = -1
										then (SELECT top 1 Reporting_Date FROM TMF_Portfolio
												WHERE CONVERT(datetime, Reporting_Date, 101)
													>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
									else (select MAX(Reporting_Date) from TMF_Portfolio)
								end
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		SET @Reporting_Date = case when @Period_Type = -1
										then (SELECT top 1 Reporting_Date FROM EML_Portfolio
												WHERE CONVERT(datetime, Reporting_Date, 101)
													>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
									else (select MAX(Reporting_Date) from EML_Portfolio)
								end
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		SET @Reporting_Date = case when @Period_Type = -1
										then (SELECT top 1 Reporting_Date FROM HEM_Portfolio
												WHERE CONVERT(datetime, Reporting_Date, 101)
													>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
									else (select MAX(Reporting_Date) from HEM_Portfolio)
								end
	END
	ELSE IF UPPER(@System) = 'WOW'
	BEGIN
		SET @Reporting_Date = case when @Period_Type = -1
										then (SELECT top 1 Reporting_Date FROM WOW_Portfolio
												WHERE CONVERT(datetime, Reporting_Date, 101)
													>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
									else (select MAX(Reporting_Date) from WOW_Portfolio)
								end
	END
	
	RETURN @Reporting_Date
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO