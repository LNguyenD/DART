IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetCPR_ClaimList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_GetCPR_ClaimList]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetCPR_ClaimList]    Script Date: 04/14/2015 11:30:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_GetCPR_ClaimList](
	@System VARCHAR(20)
	,@Period_Type INT
	,@Reporting_Date DATETIME
)
RETURNS @port_overall TABLE(
	[AgencyName] [varchar](20) NULL,
	[Sub_Category] [varchar](256) NULL,
	[Group] [varchar](20) NULL,
	[Team] [varchar](20) NULL,
	[EMPL_SIZE] [varchar](256) NULL,
	[Account_Manager] [varchar](256) NULL,
	[Portfolio] [varchar](256) NULL,
	[Claims_Officer_Name] [varchar](256) NULL,
	[Claim_No] [varchar](19) NULL,
	[Claim_Closed_Flag] [nchar](1) NULL,
	[Date_Claim_Entered] [datetime] NULL,
	[Date_Claim_Closed] [datetime] NULL,
	[Date_Claim_Received] [datetime] NULL,
	[Date_Claim_Reopened] [datetime] NULL,
	[Date_Status_Changed] [datetime] NULL,
	[IsPreOpened] [bit] NULL,
	[Division] [varchar](20) NULL,
	[State] [varchar](20) NULL,
	[ClaimStatus] [varchar](1))
AS
BEGIN
	-- Determine the last month flag
	DECLARE @Is_Last_Month bit
	IF @Period_Type = -1
	BEGIN
		SET @Is_Last_Month = 0
	END
	ELSE
	BEGIN
		SET @Is_Last_Month = @Period_Type
	END
	
	IF UPPER(@System) = 'TMF'
	BEGIN
		INSERT	@port_overall
		SELECT	AgencyName = rtrim(isnull(sub.AgencyName,'Miscellaneous'))
				,Sub_Category = rtrim(isnull(sub.Sub_Category,'Miscellaneous'))
				,[Group] = dbo.udf_TMF_GetGroupByTeam(Team)
				,Team, EMPL_SIZE, Account_Manager, Portfolio, Claims_Officer_Name
				,[Claim_No],[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed]
				,[Date_Claim_Received],[Date_Claim_Reopened]
				,[Date_Status_Changed] = null
				,[IsPreOpened]
				,[Division] = ''
				,[State] = ''
				,[ClaimStatus] = ''
			FROM TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No
			WHERE ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = @Reporting_Date
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		INSERT @port_overall
		SELECT	AgencyName = ''
				,Sub_Category = ''
				,[Group] = dbo.udf_EML_GetGroupByTeam(Team)
				,Team, EMPL_SIZE, Account_Manager, Portfolio, Claims_Officer_Name
				,[Claim_No],[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed]
				,[Date_Claim_Received],[Date_Claim_Reopened]
				,[Date_Status_Changed] = null
				,[IsPreOpened]
				,[Division] = ''
				,[State] = ''
				,[ClaimStatus] = ''
			FROM EML_Portfolio
			WHERE ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = @Reporting_Date
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		INSERT @port_overall
		SELECT	AgencyName = ''
				,Sub_Category = ''
				,[Group] = dbo.udf_HEM_GetGroupByTeam(Team)
				,Team, EMPL_SIZE, Account_Manager, Portfolio, Claims_Officer_Name
				,[Claim_No],[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed]
				,[Date_Claim_Received],[Date_Claim_Reopened]
				,[Date_Status_Changed] = null
				,[IsPreOpened]
				,[Division] = ''
				,[State] = ''
				,[ClaimStatus] = ''
			FROM HEM_Portfolio
			WHERE ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = @Reporting_Date
	END
	ELSE IF UPPER(@System) = 'WOW'
	BEGIN
		INSERT @port_overall
		SELECT	AgencyName = ''
				,Sub_Category = ''
				,[Group] = [Group]
				,Team
				,EMPL_SIZE = ''
				,Account_Manager = ''
				,Portfolio = ''
				,Claims_Officer_Name
				,[Claim_No],[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed]
				,[Date_Claim_Received],[Date_Claim_Reopened],[Date_Status_Changed]
				,[IsPreOpened]
				,[Division] = Division
				,[State] = [State]
				,[ClaimStatus]
			FROM WOW_Portfolio
			WHERE ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = @Reporting_Date
	END
	RETURN;
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO