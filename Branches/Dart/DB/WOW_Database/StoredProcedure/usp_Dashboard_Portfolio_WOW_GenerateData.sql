/****** Object:  StoredProcedure [dbo].[usp_Dashboard_Portfolio_WOW_GenerateData]    Script Date: 14/07/2015 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Dustin (DART)
-- CREATE date: 14/07/2015 14:31:45
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_Portfolio_WOW_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_Portfolio_WOW_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_Portfolio_WOW_GenerateData]
	@AsAt datetime = null
AS
BEGIN
	IF OBJECT_ID('tempdb..#Last3Year_Month_End') IS NOT NULL DROP TABLE #Last3Year_Month_End
	
	DECLARE @Last3Month_Start datetime, @Last3Year_Start datetime
	
	/* default cut-off date: Yesterday */
	DECLARE @cut_off_date_emic_dte datetime = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	DECLARE @cut_off_date_emic varchar(1024) = CONVERT(varchar, @cut_off_date_emic_dte, 103)
										
	/* Update the cut-off date to CONTROL table in DART */
	IF NOT EXISTS (SELECT [VALUE] FROM [Dart].[dbo].[CONTROL] WHERE TYPE = 'WOW' AND ITEM like '%heart%')
	BEGIN
		/* insert new */
		INSERT INTO [Dart].[dbo].[CONTROL] VALUES('WOW', 'HeartBeat', @cut_off_date_emic, NULL)
	END
	ELSE
	BEGIN
		/* update existing value */
		UPDATE [Dart].[dbo].[CONTROL] SET [VALUE] = @cut_off_date_emic WHERE TYPE = 'WOW' AND ITEM like '%heart%'
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
		DELETE [Dart].[dbo].[WOW_Portfolio]	WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @AsAt), 0)
		INSERT INTO [Dart].[dbo].[WOW_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio_WOW] @AsAt, 1	
		INSERT INTO [Dart].[dbo].[WOW_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio_WOW] @AsAt, 0
		
		-- Cleaning up data: delete the monthly data before the latest Reporting_Date
		DELETE FROM [Dart].[dbo].[WOW_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 1
			AND Reporting_Date <> (select MAX(Reporting_Date) from [Dart].[dbo].[WOW_Portfolio])
			
		/* Cleaning up data:
		- Delete the daily data that generated before {@DataFromMonth}
		- But keep daily data for days that meet conditions:
			+ Is the end of each month.
			+ In month periods from {@DataFromYear} to {@DataFromMonth} 
		For other days, delete them */
		DELETE FROM [Dart].[dbo].[WOW_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 0
			AND Reporting_Date < @Last3Month_Start
			AND Reporting_Date NOT IN (SELECT eMonth FROM #Last3Year_Month_End)
	END
	
	-- Delete temp tables
	IF OBJECT_ID('tempdb..#month_periods') IS NOT NULL DROP TABLE #month_periods
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO