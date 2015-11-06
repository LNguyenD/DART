SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_HEM_CPR_Raw]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_HEM_CPR_Raw]
GO

CREATE PROCEDURE [dbo].[usp_HEM_CPR_Raw]
(
	@ClaimType VARCHAR(256)
	,@Start_Date DATETIME
	,@End_Date DATETIME
)
AS
BEGIN
	-- Determine the last month period
	DECLARE @LastMonth_Start_Date datetime = DATEADD(m, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0))
	DECLARE @LastMonth_End_Date datetime = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59'
	
	-- Determine last two weeks: Start = last two weeks from yesterday; End = yesterday
	DECLARE @Last2Weeks_Start_Date datetime = DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
	DECLARE @Last2Weeks_End_Date datetime = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	
	DECLARE @IsLastMonthRange bit = 0
	IF DATEDIFF(d, @LastMonth_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @LastMonth_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLastMonthRange = 1
	END
	
	DECLARE @IsLast2WeeksRange bit = 0
	IF DATEDIFF(d, @Last2Weeks_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @Last2Weeks_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLast2WeeksRange = 1
	END
	
	-- Determine period type
	DECLARE @Period_Type int
	IF @IsLastMonthRange = 1
	BEGIN
		SET @Period_Type = 1
	END
	ELSE IF @IsLast2WeeksRange = 1
	BEGIN
		SET @Period_Type = 0
	END
	ELSE IF @IsLastMonthRange = 0 AND @IsLast2WeeksRange = 0
	BEGIN
		SET @Period_Type = -1
	END
	
	-- Determine filter conditions
	DECLARE @Is_Last_Month bit
	DECLARE @Reporting_Date datetime
	IF @Period_Type = -1
	BEGIN
		SET @Is_Last_Month = 0
		SELECT top 1 @Reporting_Date = Reporting_Date FROM HEM_Portfolio
			WHERE CONVERT(datetime, Reporting_Date, 101) 
				>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date
	END
	ELSE
	BEGIN
		SET @Is_Last_Month = @Period_Type
		SELECT @Reporting_Date = MAX(Reporting_Date) FROM HEM_Portfolio
	END
	
	DECLARE @Reporting_Date_pre datetime
	
	IF @ClaimType like 'claim_closure%'
	BEGIN
		-- For claim closure
		
		IF @IsLastMonthRange = 1 OR @IsLast2WeeksRange = 1
		BEGIN
			-- Return data
			SELECT * FROM [dbo].[uv_PORT] WHERE [System] = 'HEM'
				AND ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = @Reporting_Date
				AND IsPreOpened = 1
		END
		ELSE
		BEGIN
			-- Determine Previous Reporting date
			SELECT top 1 @Reporting_Date_pre = Reporting_Date FROM HEM_Portfolio
				WHERE CONVERT(datetime, Reporting_Date, 101) 
					>= CONVERT(datetime, DATEADD(DAY, -1, @Start_Date) + '23:59', 101) order by Reporting_Date
			
			-- Create temp table for previous Reporting date
			SELECT [Claim_No]
				INTO #cpr_preopen
				FROM [dbo].[uv_PORT]
				WHERE [System] = 'HEM'
					AND ISNULL(Is_Last_Month, 0) = 0
					AND Reporting_Date = @Reporting_Date_pre
					AND Claim_Closed_Flag = 'N'
					
			-- Return data
			SELECT * FROM [dbo].[uv_PORT] cpr WHERE [System] = 'HEM'
				AND ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = @Reporting_Date
				AND (EXISTS (SELECT [Claim_No] FROM #cpr_preopen cpr_pre WHERE cpr_pre.Claim_No = cpr.Claim_No)
					OR ISNULL(Date_Claim_Entered, date_claim_received) >= @Start_Date)
		END
	END
	ELSE IF @ClaimType like 'claim_still_open%'
	BEGIN
		-- For claim reopened - still open
		
		IF @IsLastMonthRange = 1 OR @IsLast2WeeksRange = 1
		BEGIN
			-- Return data
			SELECT * FROM [dbo].[uv_PORT] WHERE [System] = 'HEM'
				AND ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = @Reporting_Date
				AND IsPreClosed = 1
		END
		ELSE
		BEGIN
			-- Determine Previous Reporting date
			SELECT top 1 @Reporting_Date_pre = Reporting_Date FROM HEM_Portfolio
				WHERE CONVERT(datetime, Reporting_Date, 101) 
					>= CONVERT(datetime, DATEADD(DAY, -1, @Start_Date) + '23:59', 101) order by Reporting_Date
					
			-- Create temp table for previous Reporting date
			SELECT [Claim_No]
				INTO #cpr_preclose
				FROM [dbo].[uv_PORT]
				WHERE [System] = 'HEM'
					AND ISNULL(Is_Last_Month, 0) = 0
					AND Reporting_Date = @Reporting_Date_pre
					AND Claim_Closed_Flag = 'Y'
					
			-- Return data
			SELECT * FROM [dbo].[uv_PORT] cpr WHERE [System] = 'HEM'
				AND ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = @Reporting_Date
				AND EXISTS (SELECT [Claim_No] FROM #cpr_preclose cpr_pre WHERE cpr_pre.Claim_No = cpr.Claim_No)
		END
	END
	ELSE
	BEGIN
		-- For other claim types: return data by Reporting date only
		
		SELECT * FROM [dbo].[uv_PORT] WHERE [System] = 'HEM'
			AND ISNULL(Is_Last_Month, 0) = @Is_Last_Month
			AND Reporting_Date = @Reporting_Date
	END
	
	/* Drop all temp tables */
	IF OBJECT_ID('tempdb..#cpr_preopen') IS NOT NULL DROP table #cpr_preopen
	IF OBJECT_ID('tempdb..#cpr_preclose') IS NOT NULL DROP table #cpr_preclose
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO