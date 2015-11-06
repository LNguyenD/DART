IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_CPR_Raw]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_CPR_Raw]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_CPR_Raw]    Script Date: 08/01/2014 11:30:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Period_Type: 1 = last month, 0 = last 2 weeks, -1 = other range
CREATE FUNCTION [dbo].[udf_CPR_Raw](@System varchar(20), @End_Date Datetime, @Period_Type smallint)

RETURNS @port_overall TABLE(
	[System] [nvarchar] (50) NULL,
	[Med_Cert_Status] [nvarchar] (50) NULL,	
	[Agency_Name] [nvarchar] (256) NULL,
	[Sub_Category] [nvarchar] (256) NULL,
	[Group] [nvarchar] (256) NULL,
	[Agency_Id] [nvarchar] (256) ,
	
	[Id] [int] NOT NULL,
	[Team] [varchar](20) NULL,
	[Case_Manager] [varchar](81) NULL,
	[Policy_No] [char](19) NULL,
	[EMPL_SIZE] [varchar](256) NULL,			
	[Account_Manager] [varchar](256) NULL,			
	[Portfolio] [varchar](256) NULL,
	
	[Reporting_Date] [datetime] NOT NULL,			
	[Claim_No] [varchar](19) NULL,			
	[WIC_Code] [varchar](50) NULL,
	[Company_Name] [varchar](256) NULL,
	[Worker_Name] [varchar](256) NULL,
	[Employee_Number] [varchar](256) NULL,
	[Worker_Phone_Number] [varchar](256) NULL,
	[Claims_Officer_Name] [varchar](256) NULL,
	[Date_Of_Birth] [datetime] NULL,
	[Date_Of_Injury] [datetime] NULL,
	[Date_Of_Notification] [datetime] NULL,
	[Notification_Lag] [int] NULL,
	[Entered_Lag] [int] NULL,
	[Claim_Liability_Indicator_Group] [varchar](256) NULL,
	[Investigation_Incurred] [money] NULL,
	[Total_Paid] [money] NULL,			
	
	[Is_Time_Lost] [bit] NULL,	
	[Claim_Closed_Flag] [nchar](1)  NULL,	
	[Date_Claim_Entered] [datetime] NULL,	
	[Date_Claim_Closed] [datetime] NULL,
	[Date_Claim_Received] [datetime] NULL,
	[Date_Claim_Reopened] [datetime] NULL,			
	[Result_Of_Injury_Code] [int] NULL,			
	[WPI] [float] NULL,			
	[Common_Law] [bit] NULL,
	[Total_Recoveries] [float] NULL,			
	[Is_Working] [bit] NULL, ---1-->At Work,0 -->Not At Work
	[Physio_Paid] [float] NULL,
	[Chiro_Paid] [float] NULL,
	[Massage_Paid] [float] NULL,
	[Osteopathy_Paid] [float] NULL,
	[Acupuncture_Paid] [float] NULL,
	[Create_Date] [datetime]  DEFAULT GETDATE(),
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
	
	[Action_Required] [nchar](1) NULL,
	[RTW_Impacting] [nchar](1) NULL,
	[Weeks_In] [int] NULL,
	[Weeks_Band] [varchar] (256) NULL,
	[Hindsight] [varchar] (256) NULL,
	[Active_Weekly] [nchar](1) NULL,
	[Active_Medical] [nchar](1) NULL,
	[Cost_Code] [char] (16) NULL,
	[Cost_Code2] [char] (16) NULL,
	[CC_Injury] [varchar] (256) NULL,
	[CC_Current] [varchar] (256) NULL,
	[Med_Cert_Status_This_Week] [varchar] (20) NULL,
	[Med_Cert_Status_Next_Week] [varchar] (20) NULL,
	[Capacity] [varchar] (256) NULL,
	[Entitlement_Weeks] [numeric](5, 1) NULL,
	[Med_Cert_Status_Prev_1_Week] [varchar](20) NULL,
	[Med_Cert_Status_Prev_2_Week] [varchar](20) NULL,
	[Med_Cert_Status_Prev_3_Week] [varchar](20) NULL,
	[Med_Cert_Status_Prev_4_Week] [varchar](20) NULL,
	[Is_Last_Month] [bit] NULL,
	IsPreClosed [bit] NULL,
	IsPreOpened [bit] NULL,
	[Grouping] [nvarchar] (256) NULL
)
AS
BEGIN	
	IF UPPER(@System) = 'TMF'
	BEGIN
		INSERT @port_overall
		SELECT * from [dbo].[uv_PORT] where [system] = 'TMF'
			and	
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
		SELECT * from [dbo].[uv_PORT] where [system] = 'EML'
			and	
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
		select * from [dbo].[uv_PORT] where [system] = 'HEM'
			and		
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