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
	-- Setup cut-off date in generating data for Portfolio
	DECLARE @AsAt datetime = null
	
	-- First date of current month
	-- Just run RTW from day 10th of month
	DECLARE @firstDateOfMonth datetime = DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)	
	
	IF UPPER(@System) = 'TMF'
		BEGIN
			-- Just run RTW from day 10th of month
			IF DATEDIFF(DD,@firstDateOfMonth,GETDATE()) >= 9
			BEGIN				
				EXEC usp_Dashboard_RTW_GenerateData 'TMF'
				EXEC [Dart].[dbo].[usp_Dashboard_TMF_RTW_AddTargetAndBase_GenerateData]
			END			
			
			EXEC usp_Dashboard_AWC_GenerateData 'TMF'
		END
	ELSE IF UPPER(@System) = 'EML' 
		BEGIN
			-- Just run RTW from day 10th of month
			IF DATEDIFF(DD,@firstDateOfMonth,GETDATE()) >= 9
			BEGIN				
				EXEC usp_Dashboard_RTW_GenerateData 'EML'
				EXEC [Dart].[dbo].[usp_Dashboard_EML_RTW_AddTargetAndBase_GenerateData]
			END			
			
			EXEC usp_Dashboard_AWC_GenerateData 'EML'
		END
	ELSE
		BEGIN
			-- Just run RTW from day 10th of month
			IF DATEDIFF(DD,@firstDateOfMonth,GETDATE()) >= 9
			BEGIN				
				EXEC usp_Dashboard_RTW_GenerateData 'HEM'
				EXEC [Dart].[dbo].[usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData]
			END			
			
			EXEC usp_Dashboard_AWC_GenerateData 'HEM'
		END	
	
	EXEC usp_Dashboard_Portfolio_GenerateData @System,@AsAt
	EXEC usp_CPR_GenerateData_Last3Month @System
	EXEC usp_CPR_GenerateData_Last3Year @System
	
	-- Default: generate EMICS CPR data
	EXEC [Dart].[dbo].[usp_CPR_Monthly_GenerateData] 'TMF'
	EXEC [Dart].[dbo].[usp_CPR_Monthly_GenerateData] 'EML'
	EXEC [Dart].[dbo].[usp_CPR_Monthly_GenerateData] 'HEM'
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