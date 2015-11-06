/****** Object:  StoredProcedure [dbo].[usp_CPR_GenerateData_WOW_Last3Month]    Script Date: 14/07/2015 14:14:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dustin (DART)
-- CREATE date: 14/07/2015 14:31:45
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_GenerateData_WOW_Last3Month]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_GenerateData_WOW_Last3Month]
GO

CREATE PROCEDURE [dbo].[usp_CPR_GenerateData_WOW_Last3Month]
AS
BEGIN
	/* check the cut-off date in EMICS database */
	DECLARE @Last3Month_Start datetime, @VarDate datetime
		
	/* default cut-off date: Yesterday */
	DECLARE @cut_off_date_emic_dte datetime = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	DECLARE @cut_off_date_emic varchar(1024) = CONVERT(varchar, DAY(@cut_off_date_emic_dte)) + '/'
												+ CONVERT(varchar, MONTH(@cut_off_date_emic_dte))
												+ '/' + CONVERT(varchar, YEAR(@cut_off_date_emic_dte)) + ' 23:59:00.000'
	
	/* last {@month_flag} months from @cut_off_date_emic_dte */
	SET @Last3Month_Start = DATEADD(mm,-3, CONVERT(datetime, CONVERT(char, @cut_off_date_emic_dte, 106))) + '23:59'
	
	SET @VarDate = @Last3Month_Start
			
	/* loop days in last {@month_flag} months */
	WHILE @VarDate <= @cut_off_date_emic_dte
	BEGIN
		IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[WOW_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))			
			INSERT INTO [Dart].[dbo].[WOW_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio_WOW] @VarDate, 0
				
		SET @VarDate = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 1) + '23:59'
	END
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO