/****** Object:  StoredProcedure [dbo].[usp_Dashboard_GenerateData_Master]    Script Date: 23/04/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_GenerateData_Master]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_GenerateData_Master]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_GenerateData_Master]
	@System varchar(20)
AS
BEGIN
	-- Setup period in generating data for RTW and AWC
	DECLARE @start_period_year int = 2010
	DECLARE @start_period_month int = 9
	
	-- Setup cut-off date in generating data for Portfolio
	DECLARE @AsAt datetime = null
	
	-- First date of current month
	-- Just run RTW from day 10th of month
	DECLARE @firstDateOfMonth datetime = DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
	
	IF EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_Payment_Recovery_RTW') 
		DROP INDEX idx_Payment_Recovery_RTW ON Payment_Recovery ; 
	
	CREATE NONCLUSTERED INDEX [idx_Payment_Recovery_RTW] ON [dbo].[Payment_Recovery]([Transaction_date],[wc_Tape_Month],[Payment_Type]) 
	INCLUDE ([Claim_No],[Payment_no],[Trans_Amount],[hours_per_week],[Period_Start_Date],[Period_End_Date],[wc_Hours],[wc_Minutes],[wc_Weeks])	
	
	IF UPPER(@System) = 'TMF'
		BEGIN
			-- Just run RTW from day 10th of month
			IF DATEDIFF(DD,@firstDateOfMonth,GETDATE()) >= 9
			BEGIN
				EXEC usp_Dashboard_TMF_RTW_GenerateData @start_period_year , @start_period_month
				EXEC [Dart].[dbo].[usp_Dashboard_TMF_RTW_AddTargetAndBase_GenerateData]
			END
			
			EXEC usp_Dashboard_TMF_AWC_GenerateData @start_period_year , @start_period_month
			EXEC usp_Dashboard_Portfolio_GenerateData 'TMF',@AsAt
		END
	ELSE IF UPPER(@System) = 'EML' 
		BEGIN
			-- Just run RTW from day 10th of month
			IF DATEDIFF(DD,@firstDateOfMonth,GETDATE()) >= 9
			BEGIN
				EXEC usp_Dashboard_EML_RTW_GenerateData @start_period_year , @start_period_month
				EXEC [Dart].[dbo].[usp_Dashboard_EML_RTW_AddTargetAndBase_GenerateData]
			END
			
			EXEC usp_Dashboard_EML_AWC_GenerateData @start_period_year , @start_period_month
			EXEC usp_Dashboard_Portfolio_GenerateData 'EML',@AsAt
		END
	ELSE
		BEGIN
			-- Just run RTW from day 10th of month
			IF DATEDIFF(DD,@firstDateOfMonth,GETDATE()) >= 9
			BEGIN
				EXEC usp_Dashboard_HEM_RTW_GenerateData @start_period_year , @start_period_month
				EXEC [Dart].[dbo].[usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData]
			END
			
			EXEC usp_Dashboard_HEM_AWC_GenerateData @start_period_year , @start_period_month
			EXEC usp_Dashboard_Portfolio_GenerateData 'HEM',@AsAt
		END	
	---Set index for Dart to improve performance for refresh cache ds---
	EXEC [DART].[dbo].[usp_DART_Index]
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_GenerateData_Master] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_GenerateData_Master] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_GenerateData_Master] TO [DART_Role]
GO