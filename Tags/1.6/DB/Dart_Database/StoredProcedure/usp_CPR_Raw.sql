SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Raw]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Raw]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Raw]
(
	@System VARCHAR(3)
	,@ClaimType VARCHAR(256)
	,@Start_Date DATETIME
	,@End_Date DATETIME
)
AS
BEGIN
	IF UPPER(@System) = 'EML'
	BEGIN
		EXEC [dbo].[usp_EML_CPR_Raw] @ClaimType, @Start_Date, @End_Date
	END
	ELSE
	BEGIN
		IF UPPER(@System) = 'TMF'
		BEGIN
			EXEC [dbo].[usp_TMF_CPR_Raw] @ClaimType, @Start_Date, @End_Date
		END
		ELSE
		BEGIN
			EXEC [dbo].[usp_HEM_CPR_Raw] @ClaimType, @Start_Date, @End_Date
		END
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO