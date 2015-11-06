IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetCPR_PreClaimList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_GetCPR_PreClaimList]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetCPR_PreClaimList]    Script Date: 04/14/2015 11:30:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_GetCPR_PreClaimList](
	@System VARCHAR(20)
	,@Period_Type INT
	,@Reporting_Date_Pre DATETIME
)
RETURNS @port_overall TABLE(
	[Claim_No] [varchar](19) NULL,
	[Claim_Closed_Flag] [nchar](1) NULL)
AS
BEGIN
	IF @Period_Type = -1
	BEGIN
		IF UPPER(@System) = 'TMF'
		BEGIN
			INSERT	@port_overall
			SELECT	Claim_No, Claim_Closed_Flag
				FROM TMF_Portfolio
				WHERE ISNULL(Is_Last_Month,0) = 0
					AND Reporting_Date = @Reporting_Date_Pre
		END
		ELSE IF UPPER(@System) = 'EML'
		BEGIN
			INSERT	@port_overall
			SELECT	Claim_No, Claim_Closed_Flag
				FROM EML_Portfolio
				WHERE ISNULL(Is_Last_Month,0) = 0
					AND Reporting_Date = @Reporting_Date_Pre
		END
		ELSE IF UPPER(@System) = 'HEM'
		BEGIN
			INSERT	@port_overall
			SELECT	Claim_No, Claim_Closed_Flag
				FROM HEM_Portfolio
				WHERE ISNULL(Is_Last_Month,0) = 0
					AND Reporting_Date = @Reporting_Date_Pre
		END
	END
	
	RETURN;
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO