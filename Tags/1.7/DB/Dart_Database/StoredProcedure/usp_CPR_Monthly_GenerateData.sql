SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Monthly_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Monthly_GenerateData]
GO
CREATE PROCEDURE [dbo].[usp_CPR_Monthly_GenerateData]
	@Start_Period_Year int = NULL,
	@Start_Period_Month int = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Truncate table first
	TRUNCATE TABLE [dbo].[CPR_Monthly]
	
	IF @Start_Period_Year = NULL OR @Start_Period_Month = NULL
	BEGIN
		-- Default: generate data from last year
		
		SET @Start_Period_Year = YEAR(DATEADD(m, -12, GETDATE()))
		SET @Start_Period_Month = MONTH(GETDATE())
	END
	
	-- Determine period for generating data
	DECLARE @Generate_From datetime = CAST(CAST(@Start_Period_Year as varchar) 
											+ '/' + CAST(@Start_Period_Month as varchar)
											+ '/01' as datetime)
	DECLARE @Generate_To datetime = GETDATE()
	
	DECLARE @iMonths int = DATEDIFF(month, @Generate_From, @Generate_To)
	DECLARE @i int = @iMonths
	
	DECLARE @Start_Date_temp datetime = DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0)
	DECLARE @End_Date_temp datetime = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()) + 1, 0)) + '23:59'
	
	WHILE (@i >= 1)
	BEGIN
		SET @Start_Date_temp = DATEADD(m, -1, @Start_Date_temp)
		SET @End_Date_temp = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @Start_Date_temp) + 1, 0)) + '23:59'
	
		-- INSERT DATA FOR TMF --
		INSERT INTO [dbo].[CPR_Monthly] EXEC [dbo].[usp_CPR_Monthly] 'TMF', @Start_Date_temp, @End_Date_temp
		
		-- INSERT DATA FOR EML --
		INSERT INTO [dbo].[CPR_Monthly] EXEC [dbo].[usp_CPR_Monthly] 'EML', @Start_Date_temp, @End_Date_temp
		
		-- INSERT DATA FOR HEM --
		INSERT INTO [dbo].[CPR_Monthly] EXEC [dbo].[usp_CPR_Monthly] 'HEM', @Start_Date_temp, @End_Date_temp
		
		SET @i = @i - 1
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO