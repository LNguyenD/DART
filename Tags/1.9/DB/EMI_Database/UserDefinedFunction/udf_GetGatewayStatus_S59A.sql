IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetGatewayStatus_S59A') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetGatewayStatus_S59A
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetGatewayStatus_S59A    Script Date: 04/14/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetGatewayStatus_S59A(
	@Last_Weekly_Date DATETIME
	,@Date_of_Injury DATETIME
	,@Date_Claim_Received DATETIME
	,@WPI NUMERIC(5,2)
	,@AsAt DATETIME
)
RETURNS VARCHAR(256)
AS
BEGIN
	-- Determine the weekly month lag
	DECLARE @Weekly_Month_Lag int = (case when @Last_Weekly_Date = '1960-01-01'
											then DATEDIFF(MONTH, @Date_Claim_Received, @AsAt)
										else DATEDIFF(MONTH, @Last_Weekly_Date, @AsAt)
									end)
	
	-- Determine the past 12 months from @AsAt (get the end day of month)
	DECLARE @AsAt_Last12Months_End datetime
	SET @AsAt_Last12Months_End = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, DATEADD(m, -12, @AsAt)) + 1, 0))
	
	RETURN (case when @Last_Weekly_Date is not null and @Weekly_Month_Lag >= 13
					then 'S59A_CAP_PASSED'
				when @Last_Weekly_Date is not null and @Weekly_Month_Lag >= 12
					then '1_MTHS_TO_S59A_CAP'
				when @Last_Weekly_Date is not null and @Weekly_Month_Lag >= 11 
					then '2_MTHS_TO_S59A_CAP'
				when @Last_Weekly_Date is not null and @Weekly_Month_Lag >= 10
					then '3_MTHS_TO_S59A_CAP'
				when @Last_Weekly_Date is not null and @Weekly_Month_Lag >= 8
					then '4-5_MTHS_TO_S59A_CAP'
				when @Last_Weekly_Date is null and @Date_of_Injury > @AsAt_Last12Months_End and @WPI <= 20 
					then 'MEO_LT_12_MTHS_0-20_WPI'
				when @Last_Weekly_Date is null AND @Date_of_Injury > @AsAt_Last12Months_End and @WPI > 20 
					then 'MEO_LT_12_MTHS_GT21_WPI'
				when @Last_Weekly_Date is null AND @Date_of_Injury <= @AsAt_Last12Months_End and @WPI <= 20 
					then 'MEO_GT_12_MTHS_0-20_WPI'
				when @Last_Weekly_Date is null AND @Date_of_Injury <= @AsAt_Last12Months_End and @WPI > 20 
					then 'MEO_GT_12_MTHS_GT21_WPI'
				else '1-7MTHS_SINCE_LAST_WEEKLY'
			end)
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].udf_GetGatewayStatus_S59A TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_GetGatewayStatus_S59A TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_GetGatewayStatus_S59A TO [DART_Role]
GO