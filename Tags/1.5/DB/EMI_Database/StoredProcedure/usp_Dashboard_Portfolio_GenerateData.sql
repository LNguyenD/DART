/****** Object:  StoredProcedure [dbo].[usp_Dashboard_Portfolio_GenerateData]    Script Date: 23/04/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_Portfolio_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_Portfolio_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_Portfolio_GenerateData]
	@System varchar(20),
	@AsAt datetime = null
AS
BEGIN
	SET NOCOUNT ON
	if @AsAt is null
		SET @AsAt = GETDATE()
	
	IF UPPER(@System) = 'TMF'
	BEGIN		
		DELETE [Dart].[dbo].[TMF_Portfolio]	WHERE convert(datetime, convert(char, Reporting_Date, 106)) = convert(datetime, convert(char, @AsAt, 106))
		INSERT INTO [Dart].[dbo].[TMF_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 1
		INSERT INTO [Dart].[dbo].[TMF_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 0
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		DELETE [Dart].[dbo].[EML_Portfolio]	WHERE convert(datetime, convert(char, Reporting_Date, 106)) = convert(datetime, convert(char, @AsAt, 106))
		INSERT INTO [Dart].[dbo].[EML_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 1		
		INSERT INTO [Dart].[dbo].[EML_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 0
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		DELETE [Dart].[dbo].[HEM_Portfolio]	WHERE convert(datetime, convert(char, Reporting_Date, 106)) = convert(datetime, convert(char, @AsAt, 106))
		INSERT INTO [Dart].[dbo].[HEM_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 1	
		INSERT INTO [Dart].[dbo].[HEM_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 0
	END
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio_GenerateData] TO [DART_Role]
GO