/****** Object:  StoredProcedure [dbo].[usp_Dashboard_Portfolio_GenerateData]    Script Date: 23/04/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_Portfolio_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_Portfolio_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_Portfolio_GenerateData]
	@System varchar(20),
	@AsAt datetime = null
AS
BEGIN
	IF OBJECT_ID('tempdb..#month_periods') IS NOT NULL DROP TABLE #month_periods
	-- Use Year flag is 3
	DECLARE @year_flag int = 3
	
	-- Determine last {@year_flag} years
	DECLARE @DataFromYear datetime = CAST(YEAR(GETDATE()) - @year_flag as varchar(5)) + '-01-01'
	
	-- Keep previous 1 month from {@DataFromYear}
	SET @DataFromYear = DATEADD(M, DATEDIFF(m, 0, @DataFromYear), -1) + '23:59'
	
	-- Use Month flag is 3
	DECLARE @month_flag int = 3
	
	-- Determine last {@month_flag} months
	DECLARE @DataFromMonth datetime = DATEADD(M, -3,DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1)) + '23:59'
	
	-- Determine the month periods between {@DataFromYear} and {@DataFromMonth}
	;WITH month_periods AS
	(
		SELECT	DATEADD(m, DATEDIFF(m, 0, @DataFromYear), 0) AS bMonth
				,DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @DataFromYear) + 1, 0)) + '23:59' AS eMonth
		UNION ALL
		SELECT	DATEADD(m, 1, bMonth)
				,DATEADD(dd, -1, DATEADD(m, 2, bMonth)) + '23:59'
		FROM month_periods WHERE eMonth < @DataFromMonth
	)
	SELECT eMonth INTO #month_periods FROM month_periods
	
	IF @AsAt is null		
		SET @AsAt = DATEADD(dd, DATEDIFF(dd, 0, GETDATE()), -1) + '23:59'
	ELSE		
		SET @AsAt = DATEADD(dd, DATEDIFF(dd, 0, @AsAt), -1) + '23:59'
	
	IF UPPER(@System) = 'TMF'
	BEGIN		
		DELETE [Dart].[dbo].[TMF_Portfolio]	WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @AsAt), 0)
		INSERT INTO [Dart].[dbo].[TMF_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 1
		INSERT INTO [Dart].[dbo].[TMF_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 0
		
		-- Cleaning up data: delete the monthly data before the latest Reporting_Date
		DELETE FROM [Dart].[dbo].[TMF_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 1
			AND Reporting_Date <> (select MAX(Reporting_Date) from [Dart].[dbo].[TMF_Portfolio])
			
		/* Cleaning up data:
		- Delete the daily data that generated before {@DataFromMonth}
		- But keep daily data for days that meet conditions:
			+ Is the end of each month.
			+ In month periods from {@DataFromYear} to {@DataFromMonth} 
		For other days, delete them */
		DELETE FROM [Dart].[dbo].[TMF_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 0
			AND Reporting_Date <= @DataFromMonth
			AND Reporting_Date NOT IN (SELECT eMonth FROM #month_periods)
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		DELETE [Dart].[dbo].[EML_Portfolio]	WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @AsAt), 0)
		INSERT INTO [Dart].[dbo].[EML_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 1		
		INSERT INTO [Dart].[dbo].[EML_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 0
		
		-- Cleaning up data: delete the monthly data before the latest Reporting_Date
		DELETE FROM [Dart].[dbo].[EML_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 1
			AND Reporting_Date <> (select MAX(Reporting_Date) from [Dart].[dbo].[EML_Portfolio])
			
		/* Cleaning up data:
		- Delete the daily data that generated before {@DataFromMonth}
		- But keep daily data for days that meet conditions:
			+ Is the end of each month.
			+ In month periods from {@DataFromYear} to {@DataFromMonth} 
		For other days, delete them */
		DELETE FROM [Dart].[dbo].[EML_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 0
			AND Reporting_Date <= @DataFromMonth
			AND Reporting_Date NOT IN (SELECT eMonth FROM #month_periods)
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		DELETE [Dart].[dbo].[HEM_Portfolio]	WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @AsAt), 0)
		INSERT INTO [Dart].[dbo].[HEM_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 1	
		INSERT INTO [Dart].[dbo].[HEM_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 0
		
		-- Cleaning up data: delete the monthly data before the latest Reporting_Date
		DELETE FROM [Dart].[dbo].[HEM_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 1
			AND Reporting_Date <> (select MAX(Reporting_Date) from [Dart].[dbo].[HEM_Portfolio])
			
		/* Cleaning up data:
		- Delete the daily data that generated before {@DataFromMonth}
		- But keep daily data for days that meet conditions:
			+ Is the end of each month.
			+ In month periods from {@DataFromYear} to {@DataFromMonth} 
		For other days, delete them */
		DELETE FROM [Dart].[dbo].[HEM_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 0
			AND Reporting_Date <= @DataFromMonth
			AND Reporting_Date NOT IN (SELECT eMonth FROM #month_periods)
	END
	
	-- Delete temp tables
	IF OBJECT_ID('tempdb..#month_periods') IS NOT NULL DROP TABLE #month_periods
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio_GenerateData] TO [DART_Role]
GO