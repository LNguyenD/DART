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
	IF OBJECT_ID('tempdb..#Last3Year_Month_End') IS NOT NULL DROP TABLE #Last3Year_Month_End
	
	/* Check the cut-off date in EMICS database */
	DECLARE @cut_off_date_emic_dte datetime = '2222/01/01', @Last3Month_Start datetime, @Last3Year_Start datetime
		
	IF EXISTS (SELECT [VALUE] FROM [CONTROL] WHERE ITEM like '%heart%')
	BEGIN
		DECLARE @cut_off_date_emic varchar(1024)
		SELECT top 1 @cut_off_date_emic = [VALUE] FROM [CONTROL] where ITEM like '%heart%'
		
		/* cut-off time */
		SET @cut_off_date_emic = SUBSTRING(@cut_off_date_emic, 1, 10)
		
		SET @cut_off_date_emic_dte = CAST(SUBSTRING(@cut_off_date_emic, 7, 4) + '-'
											+ SUBSTRING(@cut_off_date_emic, 4, 2) + '-'
											+ LEFT(@cut_off_date_emic, 2) AS datetime) + '23:59'
											
		/* Update the cut-off date to CONTROL table in DART */
		IF NOT EXISTS (SELECT [VALUE] FROM [Dart].[dbo].[CONTROL] WHERE TYPE = UPPER(@System) AND ITEM like '%heart%')
		BEGIN
			/* insert new */
			INSERT INTO [Dart].[dbo].[CONTROL] VALUES(UPPER(@System), 'HeartBeat', @cut_off_date_emic, NULL)
		END
		ELSE
		BEGIN
			/* update existing value */
			UPDATE [Dart].[dbo].[CONTROL] SET [VALUE] = @cut_off_date_emic WHERE TYPE = UPPER(@System) AND ITEM like '%heart%'
		END
	END	

	/* last {@month_flag} months from @cut_off_date_emic_dte */
	SET @Last3Month_Start  = DATEADD(mm,-3, CONVERT(datetime, CONVERT(char, @cut_off_date_emic_dte, 106))) + '23:59'
	
	/* last {@year_flag} years from @cut_off_date_emic_dte */
	SET @Last3Year_Start  = DATEADD(yy,-3, CONVERT(datetime, CONVERT(char, @cut_off_date_emic_dte, 106))) + '23:59'

	/* keep previous 1 month from {@DataFromYear} */
	SET @Last3Year_Start = DATEADD(m, DATEDIFF(m, 0, @Last3Year_Start), -1) + '23:59'
	
	-- Determine the month periods between {@DataFromYear} and {@DataFromMonth}
	;WITH Last3Year_Month_End AS
	(
		SELECT	DATEADD(m, DATEDIFF(m, 0, @Last3Year_Start), 0) AS bMonth
				,DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @Last3Year_Start) + 1, 0)) + '23:59' AS eMonth
		UNION ALL
		SELECT	DATEADD(m, 1, bMonth)
				,DATEADD(dd, -1, DATEADD(m, 2, bMonth)) + '23:59'
		FROM Last3Year_Month_End WHERE eMonth < DATEADD(m, DATEDIFF(m, 0, @Last3Month_Start), -1)
	)
	SELECT eMonth INTO #Last3Year_Month_End FROM Last3Year_Month_End
	
	IF @AsAt is null		
		SET @AsAt = @cut_off_date_emic_dte
	ELSE		
		SET @AsAt = DATEADD(dd, DATEDIFF(dd, 0, @AsAt), 0) + '23:59'
	
	/* make sure the cut-off date in EMICS database must greater than or equals As_At */
	IF @cut_off_date_emic_dte >= @AsAt
	BEGIN
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
				AND Reporting_Date < @Last3Month_Start
				AND Reporting_Date NOT IN (SELECT eMonth FROM #Last3Year_Month_End)
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
				AND Reporting_Date < @Last3Month_Start
				AND Reporting_Date NOT IN (SELECT eMonth FROM #Last3Year_Month_End)
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
				AND Reporting_Date < @Last3Month_Start
				AND Reporting_Date NOT IN (SELECT eMonth FROM #Last3Year_Month_End)
		END
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