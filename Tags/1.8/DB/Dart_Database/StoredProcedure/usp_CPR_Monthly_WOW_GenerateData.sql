SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Monthly_WOW_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Monthly_WOW_GenerateData]
GO
CREATE PROCEDURE [dbo].[usp_CPR_Monthly_WOW_GenerateData]
	@Start_Period_Year int = NULL,
	@Start_Period_Month int = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Delete data in table first
	DELETE FROM [dbo].[CPR_Monthly] WHERE [System] = 'WOW'
	
	/* Get the latest cut-off date from CONTROL table */
	DECLARE @cut_off_date_dte datetime = [dbo].udf_GetCPR_CutOffDate('WOW')
	
	IF @Start_Period_Year IS NULL OR @Start_Period_Month IS NULL
	BEGIN
		-- Default: generate data from last year
		
		SET @Start_Period_Year = YEAR(DATEADD(m, -12, @cut_off_date_dte))
		SET @Start_Period_Month = MONTH(@cut_off_date_dte)
	END
	
	-- Determine period for generating data
	DECLARE @Generate_From datetime = CAST(CAST(@Start_Period_Year as varchar) 
											+ '/' + CAST(@Start_Period_Month as varchar)
											+ '/01' as datetime)
	DECLARE @Generate_To datetime = @cut_off_date_dte
	
	DECLARE @iMonths int = DATEDIFF(month, @Generate_From, @Generate_To)
	DECLARE @i int = @iMonths
	
	DECLARE @Start_Date_temp datetime = DATEADD(m, DATEDIFF(m, 0, @cut_off_date_dte), 0)
	DECLARE @End_Date_temp datetime = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @cut_off_date_dte) + 1, 0)) + '23:59'
	
	WHILE (@i >= 1)
	BEGIN
		SET @Start_Date_temp = DATEADD(m, -1, @Start_Date_temp)
		SET @End_Date_temp = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @Start_Date_temp) + 1, 0)) + '23:59'
		
		-- INSERT DATA FOR WOW --
		INSERT INTO [dbo].[CPR_Monthly] EXEC [dbo].[usp_CPR_Monthly_WOW] @Start_Date_temp, @End_Date_temp
		
		SET @i = @i - 1
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO