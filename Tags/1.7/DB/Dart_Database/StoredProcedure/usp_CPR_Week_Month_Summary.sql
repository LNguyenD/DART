SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Week_Month_Summary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Week_Month_Summary]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Week_Month_Summary]
(
	@System VARCHAR(10)			-- TMF, EML, HEM
	,@Type VARCHAR(20)
	,@PeriodType VARCHAR(20)	-- last_two_weeks, last_month
)
AS
BEGIN
	DECLARE @Start_Date datetime
	DECLARE @End_Date datetime

	IF LOWER(RTRIM(@PeriodType)) = 'last_month'
	BEGIN
		-- Last month
		SET @Start_Date = DATEADD(m, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0))
		SET @End_Date = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59'
	END
	ELSE
	BEGIN
		-- default period: Last two weeks: Start = last two weeks from yesterday; End = yesterday
		SET @Start_Date = DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
		SET @End_Date = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	END

	EXEC usp_CPR_Summary @System ,@Type,'all','all',@Start_Date,@End_Date,'all','all','all','all','all','all'
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO