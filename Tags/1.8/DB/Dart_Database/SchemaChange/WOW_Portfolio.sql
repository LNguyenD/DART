IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WOW_Portfolio]') AND type in (N'U'))	
	DROP TABLE [dbo].[WOW_Portfolio]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WOW_Portfolio]') AND type in (N'U'))	
BEGIN
	CREATE TABLE [dbo].[WOW_Portfolio](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Group] [varchar](20) NULL,
		[Team] [varchar](20) NULL,
		[Division] [varchar](20) NULL,
		[State] [varchar](20) NULL,
		[Case_Manager] [varchar](81) NULL,
		[Policy_No] [char](19) NULL,
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
		[Date_Status_Changed] [datetime] NULL,
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
		[Create_Date] [datetime] DEFAULT GETDATE(),
		[Is_Stress] [bit] NULL,
		[Is_Inactive_Claims] [bit] NULL,
		[Is_Medically_Discharged] [bit] NULL,
		[Is_Exempt] [bit] NULL,
		[Is_Reactive] [bit] NULL,
		[Is_Medical_Only] [bit] NULL,
		[Is_D_D] [bit] NULL,
		[NCMM_Actions_This_Week] [varchar](256) NULL,
		[NCMM_Actions_Next_Week] [varchar](256) NULL,
		[HoursPerWeek] [numeric](6, 2) NULL,
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
		[Capacity] [varchar] (256) NULL,
		[Entitlement_Weeks] [numeric](5, 1) NULL,
		[Med_Cert_Status_Prev_1_Week] [varchar](20) NULL,
		[Med_Cert_Status_Prev_2_Week] [varchar](20) NULL,
		[Med_Cert_Status_Prev_3_Week] [varchar](20) NULL,
		[Med_Cert_Status_Prev_4_Week] [varchar](20) NULL,
		[Is_Last_Month] [bit] NULL,
		[IsPreClosed] [bit] NULL,
		[IsPreOpened] [bit] NULL,
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Complete_Remaining_Days] [int] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Remaining_Days] [int] NULL,
		[ClaimStatus] [varchar] (1) NULL,
		[Cost_Code4] [char] (16) NULL,
		[Cost_Code5] [char] (16) NULL,
		[Weeks_Since_DON] [int] NULL,
		[Injury_Type] [varchar] (855) NULL,
		[Mechanism_Of_Injury] [varchar] (855) NULL,
	CONSTRAINT [PK_WOW_Portfolio_ID] PRIMARY KEY CLUSTERED
	(
		[Id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
ELSE
BEGIN
	IF COL_LENGTH('WOW_Portfolio','Cost_Code4') IS NULL
	BEGIN
		ALTER TABLE [dbo].[WOW_Portfolio]
		ADD Cost_Code4 char(16) null
	END
	IF COL_LENGTH('WOW_Portfolio','Cost_Code5') IS NULL
	BEGIN
		ALTER TABLE [dbo].[WOW_Portfolio]
		ADD Cost_Code5 char(16) null
	END
	IF COL_LENGTH('WOW_Portfolio','Weeks_Since_DON') IS NULL
	BEGIN
		ALTER TABLE [dbo].[WOW_Portfolio]
		ADD Weeks_Since_DON int null
	END
	IF COL_LENGTH('WOW_Portfolio','Injury_Type') IS NULL
	BEGIN
		ALTER TABLE [dbo].[WOW_Portfolio]
		ADD Injury_Type varchar(855) null
	END
	IF COL_LENGTH('WOW_Portfolio','Mechanism_Of_Injury') IS NULL
	BEGIN
		ALTER TABLE [dbo].[WOW_Portfolio]
		ADD Mechanism_Of_Injury varchar(855) null
	END
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO