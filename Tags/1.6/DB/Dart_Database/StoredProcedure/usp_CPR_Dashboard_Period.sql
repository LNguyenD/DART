SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Dashboard_Period]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Dashboard_Period]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Dashboard_Period]
(
	@System VARCHAR(10)			-- TMF, EML, HEM
	,@ViewType VARCHAR(20)		-- Agency_Group, Sub_Team, ClaimOfficer
	,@PeriodType VARCHAR(20)	-- last_two_weeks, last_month
)
AS
BEGIN
	DECLARE @Start_Date datetime
	DECLARE @End_Date datetime
	DECLARE @Is_Last_Month bit = 0

	IF LOWER(RTRIM(@PeriodType)) = 'last_month'
	BEGIN
		-- Last month
		SET @Start_Date = DATEADD(m, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0))
		SET @End_Date = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59'
		SET @Is_Last_Month = 1
	END
	ELSE
	BEGIN
		-- default period: Last two weeks: Start = last two weeks from yesterday; End = yesterday
		SET @Start_Date = DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
		SET @End_Date = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	END

	IF UPPER(RTRIM(@ViewType)) = 'AGENCY_GROUP'
	BEGIN
		EXEC('EXEC usp_' + @System + '_CPR_Dashboard_Agency_Group ''' + @Start_Date + ''',''' + @End_Date + ''',' + @Is_Last_Month + '')
	END
	ELSE IF UPPER(RTRIM(@ViewType)) = 'SUB_TEAM'
	BEGIN
		EXEC('EXEC usp_' + @System + '_CPR_Dashboard_Sub_Team ''' + @Start_Date + ''',''' + @End_Date + ''',' + @Is_Last_Month + '')
	END
	ELSE IF UPPER(RTRIM(@ViewType)) = 'CLAIMOFFICER'
	BEGIN
		EXEC('EXEC usp_' + @System + '_CPR_Dashboard_ClaimOfficer ''' + @Start_Date + ''',''' + @End_Date + ''',' + @Is_Last_Month + '')
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO