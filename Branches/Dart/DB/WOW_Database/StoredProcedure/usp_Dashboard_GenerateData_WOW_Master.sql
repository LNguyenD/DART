/****** Object:  StoredProcedure [dbo].[usp_Dashboard_GenerateData_WOW_Master]    Script Date: 14/07/2015 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Dustin (DART)
-- CREATE date: 14/07/2015 14:31:45
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_GenerateData_WOW_Master]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_GenerateData_WOW_Master]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_GenerateData_WOW_Master]
AS
BEGIN
	EXEC usp_Dashboard_Portfolio_WOW_GenerateData
	EXEC usp_CPR_GenerateData_WOW_Last3Month
	EXEC usp_CPR_GenerateData_WOW_Last3Year
	
	-- Default: generate data from last year
	EXEC [Dart].[dbo].[usp_CPR_Monthly_WOW_GenerateData]
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO