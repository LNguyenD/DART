IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_PORT_Overall]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_PORT_Overall]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_PORT_Overall]    Script Date: 08/01/2014 11:30:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Period_Type: 1 = last month, 0 = last 2 weeks, -1 = other range
CREATE FUNCTION [dbo].[udf_PORT_Overall](@System varchar(20), @Type VARCHAR(20), @End_Date Datetime, @Period_Type smallint)
RETURNS @port_overall TABLE(
	[Value] [varchar](256) NULL,
	[SubValue] [varchar](256) NULL,
	[SubValue2] [varchar](256) NULL,
	[Claim_No] [varchar](19) NULL,
	[Date_Of_Injury] [datetime] NULL,
	[Claim_Liability_Indicator_Group] [varchar](256) NULL,
	[Is_Time_Lost] [bit] NULL,
	[Claim_Closed_Flag] [nchar](1) NULL,
	[Date_Claim_Entered] [datetime] NULL,
	[Date_Claim_Closed] [datetime] NULL,
	[Date_Claim_Received] [datetime] NULL,
	[Date_Claim_Reopened] [datetime] NULL,
	[Result_Of_Injury_Code] [int] NULL,
	[WPI] [float] NULL,
	[Common_Law] [bit] NULL,
	[Total_Recoveries] [float] NULL,
	[Med_Cert_Status] [varchar](20) NULL,
	[Is_Working] [bit] NULL,
	[Physio_Paid] [float] NULL,
	[Chiro_Paid] [float] NULL,
	[Massage_Paid] [float] NULL,
	[Osteopathy_Paid] [float] NULL,
	[Acupuncture_Paid] [float] NULL,
	[Is_Stress] [bit] NULL,
	[Is_Inactive_Claims] [bit] NULL,
	[Is_Medically_Discharged] [bit] NULL,
	[Is_Exempt] [bit] NULL,
	[Is_Reactive] [bit] NULL,
	[Is_Medical_Only] [bit] NULL,
	[Is_D_D] [bit] NULL,
	[NCMM_Actions_This_Week] [varchar](256) NULL,
	[NCMM_Actions_Next_Week] [varchar](256) NULL,
	[HoursPerWeek] [numeric](5, 2) NULL,
	[Is_Industrial_Deafness] [bit] NULL,
	[Rehab_Paid] [float] NULL,
	[IsPreClosed] [bit] NULL,
	[IsPreOpened] [bit] NULL)
AS
BEGIN	
	IF UPPER(@System) = 'TMF'
	BEGIN
		INSERT @port_overall
		SELECT Value=(case when @Type='agency' then rtrim(isnull(sub.AgencyName,'Miscellaneous')) else dbo.udf_TMF_GetGroupByTeam(Team) end)
			,SubValue=(case when @Type='agency' then rtrim(isnull(sub.Sub_Category,'Miscellaneous')) else [Team] end)
			,SubValue2=[Claims_Officer_Name]
			,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
			,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
			,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
			,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
			,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
			,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
			,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[IsPreClosed],[IsPreOpened]
			FROM TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No
			WHERE	
					(
						CASE WHEN @Period_Type = -1
								THEN
									0
								ELSE
									@Period_Type
						END
					) = ISNULL(Is_Last_Month, 0)
					AND
					(
						CASE WHEN @Period_Type = -1
								THEN
									(select top 1 Reporting_Date from TMF_Portfolio
										where CONVERT(datetime, Reporting_Date, 101) 
											>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
								ELSE
									(select MAX(Reporting_Date) from TMF_Portfolio)
						END
					) = Reporting_Date
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		INSERT @port_overall
		SELECT Value=(case when @Type='employer_size' then [EMPL_SIZE] when @Type='group' then dbo.udf_EML_GetGroupByTeam(Team) else [account_manager] end)
			,SubValue=(case when @Type='group' then [Team] else [EMPL_SIZE] end)
			,SubValue2=[Claims_Officer_Name]
			,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
			,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
			,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
			,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
			,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
			,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
			,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[IsPreClosed],[IsPreOpened]
			FROM EML_Portfolio
			WHERE	
					(
						CASE WHEN @Period_Type = -1
								THEN
									0
								ELSE
									@Period_Type
						END
					) = ISNULL(Is_Last_Month, 0)
					AND
					(
						CASE WHEN @Period_Type = -1
								THEN
									(select top 1 Reporting_Date from EML_Portfolio
										where CONVERT(datetime, Reporting_Date, 101) 
											>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
								ELSE
									(select MAX(Reporting_Date) from EML_Portfolio)
						END
					) = Reporting_Date
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		INSERT @port_overall
		SELECT Value=(case when @Type='account_manager' then [Account_Manager] when @Type = 'portfolio' then [portfolio] else dbo.udf_HEM_GetGroupByTeam(Team) end)
			,SubValue=(case when @Type='account_manager' or @Type = 'portfolio' then [EMPL_SIZE] else [Team] end)
			,SubValue2=[Claims_Officer_Name]
			,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
			,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
			,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
			,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
			,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
			,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
			,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[IsPreClosed],[IsPreOpened]
			FROM HEM_Portfolio
			WHERE	
					(
						CASE WHEN @Period_Type = -1
								THEN
									0
								ELSE
									@Period_Type
						END
					) = ISNULL(Is_Last_Month, 0)
					AND
					(
						CASE WHEN @Period_Type = -1
								THEN
									(select top 1 Reporting_Date from HEM_Portfolio
										where CONVERT(datetime, Reporting_Date, 101) 
											>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
								ELSE
									(select MAX(Reporting_Date) from HEM_Portfolio)
						END
					) = Reporting_Date
	END
	RETURN;
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO