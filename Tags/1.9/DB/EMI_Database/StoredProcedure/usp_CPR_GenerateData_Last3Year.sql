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
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_GenerateData_Last3Year]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_GenerateData_Last3Year]
GO

CREATE PROCEDURE [dbo].[usp_CPR_GenerateData_Last3Year]
	@System varchar(20)
AS
BEGIN
	/* check the cut-off date in EMICS database */
	DECLARE @cut_off_date_emic_dte datetime = '2222/01/01', @Last3Month_Start datetime, @Last3Year_Start datetime, @VarDate datetime
		
	IF EXISTS (SELECT [VALUE] FROM [CONTROL] WHERE ITEM like '%heart%')
	BEGIN
		DECLARE @cut_off_date_emic varchar(1024)
		SELECT top 1 @cut_off_date_emic = [VALUE] FROM [CONTROL] where ITEM like '%heart%'
		
		SET @cut_off_date_emic_dte = CAST(SUBSTRING(@cut_off_date_emic, 7, 4) + '-'
											+ SUBSTRING(@cut_off_date_emic, 4, 2) + '-'
											+ LEFT(@cut_off_date_emic, 2) AS datetime) + '23:59'
	END	
	
	/* last {@month_flag} months from @cut_off_date_emic_dte */
	SET @Last3Month_Start = DATEADD(mm,-3, CONVERT(datetime, CONVERT(char, @cut_off_date_emic_dte, 106))) + '23:59'	
	
	/* last {@year_flag} years from @cut_off_date_emic_dte */
	SET @Last3Year_Start = DATEADD(yy,-3, CONVERT(datetime, CONVERT(char, @cut_off_date_emic_dte, 106))) + '23:59'
	
	/* keep previous 1 month from {@Last3Year_Start} */
	SET @VarDate = DATEADD(m, DATEDIFF(m, 0, @Last3Year_Start), -1) + '23:59'
	
	WHILE @VarDate < @Last3Month_Start
	BEGIN
		IF UPPER(@System) = 'TMF'
		BEGIN
			IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[TMF_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))									
				INSERT INTO [Dart].[dbo].[TMF_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @VarDate, 0				
		END
		ELSE IF UPPER(@System) = 'HEM'
		BEGIN
			IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[HEM_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))														
				INSERT INTO [Dart].[dbo].[HEM_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @VarDate, 0	
		END
		ELSE IF UPPER(@System) = 'EML'
		BEGIN
			IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[EML_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))										
				INSERT INTO [Dart].[dbo].[EML_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @VarDate, 0
		END	
		SET @VarDate = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, DATEADD(dd,10,@VarDate)) + 1, 0)) + '23:59'		
	END
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_CPR_GenerateData_Last3Year] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_CPR_GenerateData_Last3Year] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_CPR_GenerateData_Last3Year] TO [DART_Role]
GO