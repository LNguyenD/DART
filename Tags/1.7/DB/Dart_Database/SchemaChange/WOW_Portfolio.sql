IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WOW_Portfolio]') AND type in (N'U'))	
BEGIN
	CREATE TABLE [dbo].[WOW_Portfolio](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Case_Manager] [varchar](81) NULL,
		[Reporting_Date] [datetime] NOT NULL,
		[Claim_No] [varchar](19) NULL,
		[Company_Name] [varchar](256) NULL,
		[Worker_Name] [varchar](256) NULL,
		[Employee_Number] [varchar](256) NULL,
		[Worker_Phone_Number] [varchar](256) NULL,
		[Date_Of_Birth] [datetime] NULL,
		[Date_Of_Injury] [datetime] NULL,
		[Total_Paid] [money] NULL,
		[Date_Claim_Closed] [datetime] NULL,
		[Date_Claim_Received] [datetime] NULL,
		[Date_Claim_Reopened] [datetime] NULL,
		[Result_Of_Injury_Code] [int] NULL,
		[Create_Date] [datetime] NULL,
		[NCMM_Actions_This_Week] [varchar](256) NULL,
		[NCMM_Actions_Next_Week] [varchar](256) NULL,
		[Action_Required] [nchar](1) NULL,
		[Weeks_In] [int] NULL,
		[Weeks_Band] [varchar](256) NULL,
		[Hindsight] [varchar](256) NULL,
		[Is_Last_Month] [bit] NULL,
	 CONSTRAINT [PK_WOW_Portfolio] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO