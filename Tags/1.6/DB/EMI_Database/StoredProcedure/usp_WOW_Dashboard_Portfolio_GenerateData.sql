SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_WOW_Dashboard_Portfolio_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_WOW_Dashboard_Portfolio_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_WOW_Dashboard_Portfolio_GenerateData]
	@AsAt datetime = null
AS
BEGIN
	SET NOCOUNT ON
	if @AsAt is null
		SET @AsAt = GETDATE()
		
	BEGIN		
		DELETE [Dart].[dbo].[WOW_Portfolio]	WHERE convert(datetime, convert(char, Reporting_Date, 106)) = convert(datetime, convert(char, GETDATE(), 106))
		INSERT INTO [Dart].[dbo].[WOW_Portfolio] EXEC [dbo].[usp_WOW_Dashboard_Portfolio] @AsAt, 1
		INSERT INTO [Dart].[dbo].[WOW_Portfolio] EXEC [dbo].[usp_WOW_Dashboard_Portfolio] @AsAt, 0
	END	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO