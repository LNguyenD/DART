---------------------------------------------------------- 
------------------- SchemaChange 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dart_SchemaChange.sql  
--------------------------------  
---Update old data with mapping given by harry for agency, sub, policy_no---
--update TMF_RTW set AgencyName=tmfwebrep.dbo.udf_GetAgencyNameByPolicyNo(POLICY_NO)
--,Sub_Category=tmfwebrep.dbo.udf_GetSubCategoryByPolicyNo(POLICY_NO)--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dart_SchemaChange.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_Favours.sql  
--------------------------------  
/****** Object:  Table [dbo].[Dashboard_Favours]    Script Date: 09/23/2013 11:45:13 ******/
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dashboard_Favours]') AND type in (N'U'))
	CREATE TABLE [dbo].[Dashboard_Favours](
		[FavourId] [int] IDENTITY(1,1) NOT NULL,
		[Name] [nvarchar](256) NOT NULL,
		[Url] [nvarchar](300) NOT NULL,
		[UserId] [int] NOT NULL,
		[Status] [smallint] NULL,
		[Create_Date] [datetime] NULL,
		[Owner] [int] NULL,
		[UpdatedBy] [int] NULL,
	 CONSTRAINT [PK_Dashboard_Favour] PRIMARY KEY CLUSTERED 
	(
		[FavourId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
ELSE
	-- Update Users table schema
	IF COL_LENGTH('Dashboard_Favours','Is_Landing_Page') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[Dashboard_Favours]
		ADD Is_Landing_Page bit NULL	
	END	
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_Favours.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_Graph_Description.sql  
--------------------------------  
/****** Object:  Table [dbo].[Dashboard_Graph_Description]    Script Date: 09/23/2013 11:49:29 ******/
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dashboard_Graph_Description]') AND type in (N'U'))
	CREATE TABLE [dbo].[Dashboard_Graph_Description](
		[DescriptionId] [int] IDENTITY(1,1) NOT NULL,
		[SystemId] [int] NOT NULL,
		[Type] [varchar](50) NOT NULL,
		[Description] [nvarchar](4000) NOT NULL,
		[Status] [smallint] NULL,
		[Create_Date] [datetime] NULL,
		[Owner] [int] NULL,
		[UpdatedBy] [int] NULL,
	 CONSTRAINT [PK_Dashboard_Graph_Description] PRIMARY KEY CLUSTERED 
	(
		[DescriptionId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	GO

SET ANSI_PADDING OFF
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_Graph_Description.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_TimeAccess.sql  
--------------------------------  
/****** Object:  Table [dbo].[Dashboard_TimeAccess]    Script Date: 09/23/2013 11:50:02 ******/
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dashboard_TimeAccess]') AND type in (N'U'))
	CREATE TABLE [dbo].[Dashboard_TimeAccess](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[DashboardId] [int] NOT NULL,
		[DashboardLevelId] [int] NOT NULL,
		[UserId] [int] NOT NULL,
		[StartTime] [datetime] NOT NULL,
		[EndTime] [datetime] NOT NULL,
		[Status] [smallint] NULL,
		[Create_Date] [datetime] NULL,
		[Owner] [int] NULL,
		[UpdatedBy] [int] NULL,
	 CONSTRAINT [PK_TimeAccessCalculator] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
ELSE
	BEGIN
		DELETE FROM [dbo].[Dashboard_TimeAccess]
		
		IF COL_LENGTH('Dashboard_TimeAccess','DashboardId') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[Dashboard_TimeAccess]
			DROP COLUMN DashboardId
		END
		IF COL_LENGTH('Dashboard_TimeAccess','DashboardLevelId') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[Dashboard_TimeAccess]
			DROP COLUMN DashboardLevelId
		END
		IF COL_LENGTH('Dashboard_TimeAccess','Url') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[Dashboard_TimeAccess]
			ADD Url varchar (256) null
		END
	END
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_TimeAccess.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_Traffic_Light_Rules.sql  
--------------------------------  
/****** Object:  Table [dbo].[Dashboard_Traffic_Light_Rules]    Script Date: 11/04/2013 14:59:51 ******/
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dashboard_Traffic_Light_Rules]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[Dashboard_Traffic_Light_Rules](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[SystemId] [int] NOT NULL,
			[DashboardType] [varchar](50) NULL,
			[Type] [varchar](20) NULL,
			[Value] [varchar](20) NULL,
			[Sub_Value] [varchar](256) NULL,
			[Measure] [int] NULL,
			[Name] [varchar](50) NULL,
			[Color] [varchar](50) NOT NULL,
			[Description] [varchar](256) NULL,
			[ImageUrl] [varchar](256) NULL,
			[FromValue] [float] NULL,
			[ToValue] [float] NULL,
			[Status] [smallint] NULL,
			[Create_Date] [datetime] NULL,
			[Owner] [int] NULL,
			[UpdatedBy] [int] NULL,
		 CONSTRAINT [PK_Dashboard_Traffic_Light_Rules] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END
GO

SET ANSI_PADDING OFF
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_Traffic_Light_Rules.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_AWC.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EML_AWC]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[EML_AWC](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Time_ID] [datetime] NOT NULL,
			[Claim_no] [varchar](19) NULL,
			[Group] [char](20) NULL,
			[Team] [varchar](20) NULL,
			[Case_manager] [varchar](81) NULL,			
			[AgencyName] [char](20) NULL,
			[Date_of_Injury] [datetime] NULL,
			[create_date] [datetime]  DEFAULT GETDATE(),		
			[POLICY_NO] [char](19) NULL,
			[Agency_Id] [varchar](20) NULL,
			[Sub_Category] [varchar](256) NULL,
			[EMPL_SIZE] [varchar](256) NULL,
			[Cert_Type] [varchar](256) NULL,
			[Med_cert_From] [datetime] NULL,
			[Med_cert_To] [datetime] NULL,
			[Account_Manager] [varchar](256) NULL,
			[Cell_no] [tinyint] NULL,
			[Portfolio] [varchar](256) NULL
		 CONSTRAINT [PK_EML_AWC_ID] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]		
	END
ELSE
	BEGIN	
		IF COL_LENGTH('EML_AWC','EMPL_SIZE') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			ADD EMPL_SIZE nchar(2) null
		END
		IF COL_LENGTH('EML_AWC','Cert_Type') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			ADD Cert_Type varchar(256) null
		END	
		IF COL_LENGTH('EML_AWC','Med_cert_From') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			ADD Med_cert_From datetime null
		END	
		IF COL_LENGTH('EML_AWC','Med_cert_To') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			ADD Med_cert_To datetime null
		END	
		IF COL_LENGTH('EML_AWC','Account_Manager') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			ADD Account_Manager varchar(256) null
		END	
		IF COL_LENGTH('EML_AWC','Cell_no') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			ADD Cell_no tinyint null
		END
		IF COL_LENGTH('EML_AWC','Portfolio') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			ADD Portfolio varchar(256) null
		END
		IF COL_LENGTH('EML_AWC','Group_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			DROP COLUMN Group_
		END
		IF COL_LENGTH('EML_AWC','Team_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			DROP COLUMN Team_
		END
		IF COL_LENGTH('EML_AWC','Case_manager_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			DROP COLUMN Case_manager_
		END
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_AWC.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_AWC_Projections.sql  
--------------------------------  
/****** Object:  Table [dbo].[EML_AWC_Projections]    Script Date: 07/08/2013 08:24:30 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EML_AWC_Projections]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[EML_AWC_Projections](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Unit_Type] [varchar](20) NOT NULL,
			[Unit_Name] [varchar](256) NOT NULL,
			[Type] [varchar](20) NOT NULL,
			[Time_Id] [datetime] NOT NULL,
			[Projection] [float] NOT NULL,
		 CONSTRAINT [PK_EML_AWC_Projections] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_AWC_Projections.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_Portfolio.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EML_Portfolio]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[EML_Portfolio](				
			[Id] [int] IDENTITY(1,1) NOT NULL,			
			[Group] [char](20) NULL,
			[Team] [varchar](20) NULL,
			[Case_Manager] [varchar](81) NULL,			
			[Agency_Name] [char](20) NULL,			
			[Agency_Id] [varchar](20) NULL,					
			[Policy_No] [char](19) NULL,			
			[Sub_Category] [varchar](256) NULL,
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
			[Is_Last_Month] [bit] NULL
		 CONSTRAINT [PK_EML_Portfolio_ID] PRIMARY KEY CLUSTERED
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
		
	END
ELSE
	-- Update Users table schema
	IF COL_LENGTH('EML_Portfolio','Is_Last_Month') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[EML_Portfolio]
		ADD Is_Last_Month bit NULL	
	END	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_Portfolio.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_RTW.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EML_RTW]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[EML_RTW](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Remuneration_Start] [datetime] NULL,
			[Remuneration_End] [datetime] NULL,
			[Measure_months] [bigint] NULL,
			[Group] [varchar](20) NULL,
			[Team] [varchar](20) NULL,
			[Case_manager] [varchar](81) NULL,			
			[Agency_Id] [varchar](20) NULL,
			[Claim_no] [varchar](20) NULL,
			[DTE_OF_INJURY] [datetime] NULL,
			[POLICY_NO] [char](19) NULL,
			[LT] [float] NULL,
			[WGT] [float] NULL,
			[EMPL_SIZE] [varchar](256) NULL,
			[Weeks_paid][float] NULL,
			[create_date] [datetime]  DEFAULT GETDATE(),
			[AgencyName] [char](20) NULL,
			[Sub_Category] [varchar](256) NULL,
			[Measure] [int] NULL,
			[Cert_Type] [varchar](256) NULL,
			[Med_cert_From] [datetime] NULL,
			[Med_cert_To] [datetime] NULL,
			[Account_Manager] [varchar](256) NULL,
			[Cell_no] [tinyint] NULL,
			[Portfolio] [varchar](256) NULL,
			[Stress] [varchar](256) NULL,
			[Liability_Status] [varchar](256) NULL,
			[cost_code] [varchar](256) NULL,
			[cost_code2] [varchar](256) NULL,
			[Claim_Closed_flag] [varchar] (256) NULL
		 CONSTRAINT [PK_EML_RTW_MEASURE] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]		
	END
ELSE
	BEGIN
		IF COL_LENGTH('EML_RTW','Cert_Type') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			ADD Cert_Type varchar(256) null
		END	
		IF COL_LENGTH('EML_RTW','Med_cert_From') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			ADD Med_cert_From datetime null
		END	
		IF COL_LENGTH('EML_RTW','Med_cert_To') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			ADD Med_cert_To datetime null
		END	
		IF COL_LENGTH('EML_RTW','Account_Manager') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			ADD Account_Manager varchar(256) null
		END	
		IF COL_LENGTH('EML_RTW','Cell_no') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			ADD Cell_no tinyint null
		END
		IF COL_LENGTH('EML_RTW','Portfolio') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			ADD Portfolio varchar(256) null
		END
		
		IF COL_LENGTH('EML_RTW','Stress') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			ADD Stress varchar(256) null
		END	
		IF COL_LENGTH('EML_RTW','Liability_Status') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			ADD Liability_Status varchar(256) null
		END	
		IF COL_LENGTH('EML_RTW','cost_code') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			ADD cost_code varchar(256) null
		END	
		IF COL_LENGTH('EML_RTW','cost_code2') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			ADD cost_code2 varchar(256) null
		END	
		IF COL_LENGTH('EML_RTW','Claim_Closed_flag') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			ADD Claim_Closed_flag varchar(256) null
		END	
		IF COL_LENGTH('EML_RTW','Group_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			DROP COLUMN Group_
		END
		IF COL_LENGTH('EML_RTW','Team_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			DROP COLUMN Team_
		END
		IF COL_LENGTH('EML_RTW','Case_manager_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			DROP COLUMN Case_manager_
		END
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
	--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_RTW_Target_Base.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EML_RTW_Target_Base]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[EML_RTW_Target_Base](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Type] [varchar](20) NOT NULL,
			[Value] [varchar](256) NULL,
			[Sub_Value] [varchar](256) NULL,
			[Measure] [int] NULL,
			[Target] [float] NULL,
			[Base] [float] NULL,
			[UpdatedBy] [int] NULL,
			[Create_Date] [datetime] NULL,
			[Status] [smallint] NULL,
			[Remuneration] varchar(20) NULL
		 CONSTRAINT [PK_EML_RTW_Target_Base] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END
ELSE
	BEGIN	
		IF COL_LENGTH('EML_RTW_Target_Base','Remuneration') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW_Target_Base]
			ADD Remuneration nvarchar(20) null
		END		
	END	

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_RTW_Target_Base.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_AWC.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEM_AWC]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[HEM_AWC](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Time_ID] [datetime] NOT NULL,
			[Claim_no] [varchar](19) NULL,
			[Group] [char](20) NULL,
			[Team] [varchar](20) NULL,
			[Case_manager] [varchar](81) NULL,			
			[AgencyName] [char](20) NULL,
			[Date_of_Injury] [datetime] NULL,
			[create_date] [datetime]  DEFAULT GETDATE(),		
			[POLICY_NO] [char](19) NULL,
			[Agency_Id] [varchar](20) NULL,
			[Sub_Category] [varchar](256) NULL,
			[EMPL_SIZE] [varchar](256) NULL,
			[Cert_Type] [varchar](256) NULL,
			[Med_cert_From] [datetime] NULL,
			[Med_cert_To] [datetime] NULL,
			[Account_Manager] [varchar](256) NULL,
			[Cell_no] [tinyint] NULL,
			[Portfolio] [varchar](256) NULL
		 CONSTRAINT [PK_HEM_AWC_ID] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]	
		
	END
ELSE
	BEGIN	
		IF COL_LENGTH('HEM_AWC','EMPL_SIZE') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			ADD EMPL_SIZE nchar(2) null
		END
		IF COL_LENGTH('HEM_AWC','Cert_Type') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			ADD Cert_Type varchar(256) null
		END	
		IF COL_LENGTH('HEM_AWC','Med_cert_From') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			ADD Med_cert_From datetime null
		END	
		IF COL_LENGTH('HEM_AWC','Med_cert_To') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			ADD Med_cert_To datetime null
		END	
		IF COL_LENGTH('HEM_AWC','Account_Manager') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			ADD Account_Manager varchar(256) null
		END
		IF COL_LENGTH('HEM_AWC','Cell_no') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			ADD Cell_no tinyint null
		END
		IF COL_LENGTH('HEM_AWC','Portfolio') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			ADD Portfolio varchar(256) null
		END
		IF COL_LENGTH('HEM_AWC','Group_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			DROP COLUMN Group_
		END
		IF COL_LENGTH('HEM_AWC','Team_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			DROP COLUMN Team_
		END
		IF COL_LENGTH('HEM_AWC','Case_manager_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			DROP COLUMN Case_manager_
		END
	END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_AWC.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_AWC_Projections.sql  
--------------------------------  
/****** Object:  Table [dbo].[HEM_AWC_Projections]    Script Date: 07/08/2013 08:24:30 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEM_AWC_Projections]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[HEM_AWC_Projections](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Unit_Type] [varchar](20) NOT NULL,
			[Unit_Name] [varchar](256) NOT NULL,
			[Type] [varchar](20) NOT NULL,
			[Time_Id] [datetime] NOT NULL,
			[Projection] [float] NOT NULL,
		 CONSTRAINT [PK_HEM_AWC_Projections] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_AWC_Projections.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_Portfolio.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEM_Portfolio]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[HEM_Portfolio](				
			[Id] [int] IDENTITY(1,1) NOT NULL,			
			[Group] [char](20) NULL,
			[Team] [varchar](20) NULL,
			[Case_Manager] [varchar](81) NULL,			
			[Agency_Name] [char](20) NULL,			
			[Agency_Id] [varchar](20) NULL,					
			[Policy_No] [char](19) NULL,			
			[Sub_Category] [varchar](256) NULL,
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
			[Is_Last_Month] [bit] NULL
		 CONSTRAINT [PK_HEM_Portfolio_ID] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
		
	END
ELSE
	-- Update Users table schema
	IF COL_LENGTH('HEM_Portfolio','Is_Last_Month') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[HEM_Portfolio]
		ADD Is_Last_Month bit NULL	
	END	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_Portfolio.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_RTW.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEM_RTW]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[HEM_RTW](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Remuneration_Start] [datetime] NULL,
			[Remuneration_End] [datetime] NULL,
			[Measure_months] [bigint] NULL,
			[Group] [varchar](20) NULL,
			[Team] [varchar](20) NULL,
			[Case_manager] [varchar](81) NULL,			
			[Agency_Id] [varchar](20) NULL,
			[Claim_no] [varchar](20) NULL,
			[DTE_OF_INJURY] [datetime] NULL,
			[POLICY_NO] [char](19) NULL,
			[LT] [float] NULL,
			[WGT] [float] NULL,
			[EMPL_SIZE] [varchar](256) NULL,
			[Weeks_paid][float] NULL,
			[create_date] [datetime]  DEFAULT GETDATE(),
			[AgencyName] [char](20) NULL,
			[Sub_Category] [varchar](256) NULL,
			[Measure] [int] NULL,
			[Cert_Type] [varchar](256) NULL,
			[Med_cert_From] [datetime] NULL,
			[Med_cert_To] [datetime] NULL,
			[Account_Manager] [varchar](256) NULL,
			[Cell_no] [tinyint] NULL,
			[Portfolio] [varchar](256) NULL,
			[Stress] [varchar](256) NULL,
			[Liability_Status] [varchar](256) NULL,
			[cost_code] [varchar](256) NULL,
			[cost_code2] [varchar](256) NULL,
			[Claim_Closed_flag] [varchar] (256) NULL
		 CONSTRAINT [PK_HEM_RTW_MEASURE] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]	
		
	END
ELSE
	BEGIN
		IF COL_LENGTH('HEM_RTW','Cert_Type') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			ADD Cert_Type varchar(256) null
		END	
		IF COL_LENGTH('HEM_RTW','Med_cert_From') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			ADD Med_cert_From datetime null
		END	
		IF COL_LENGTH('HEM_RTW','Med_cert_To') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			ADD Med_cert_To datetime null
		END	
		IF COL_LENGTH('HEM_RTW','Account_Manager') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			ADD Account_Manager varchar(256) null
		END	
		IF COL_LENGTH('HEM_RTW','Cell_no') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			ADD Cell_no tinyint null
		END
		IF COL_LENGTH('HEM_RTW','Portfolio') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			ADD Portfolio varchar(256) null
		END
		
		IF COL_LENGTH('HEM_RTW','Stress') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			ADD Stress varchar(256) null
		END	
		IF COL_LENGTH('HEM_RTW','Liability_Status') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			ADD Liability_Status varchar(256) null
		END	
		IF COL_LENGTH('HEM_RTW','cost_code') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			ADD cost_code varchar(256) null
		END	
		IF COL_LENGTH('HEM_RTW','cost_code2') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			ADD cost_code2 varchar(256) null
		END	
		IF COL_LENGTH('HEM_RTW','Claim_Closed_flag') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			ADD Claim_Closed_flag varchar(256) null
		END	
		IF COL_LENGTH('HEM_RTW','Group_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			DROP COLUMN Group_
		END
		IF COL_LENGTH('HEM_RTW','Team_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			DROP COLUMN Team_
		END
		IF COL_LENGTH('HEM_RTW','Case_manager_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			DROP COLUMN Case_manager_
		END
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
	--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_RTW_Target_Base.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEM_RTW_Target_Base]') AND type in (N'U'))	
	BEGIN
			CREATE TABLE [dbo].[HEM_RTW_Target_Base](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Type] [varchar](20) NOT NULL,
			[Value] [varchar](256) NULL,
			[Sub_Value] [varchar](256) NULL,
			[Measure] [int] NULL,
			[Target] [float] NULL,
			[Base] [float] NULL,
			[UpdatedBy] [int] NULL,
			[Create_Date] [datetime] NULL,
			[Status] [smallint] NULL,
			[Remuneration] varchar(20) NULL
		 CONSTRAINT [PK_HEM_RTW_Target_Base] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]		
	END
ELSE
	BEGIN	
		IF COL_LENGTH('HEM_RTW_Target_Base','Remuneration') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW_Target_Base]
			ADD Remuneration nvarchar(20) null
		END		
	END	


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_RTW_Target_Base.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_AWC.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMF_AWC]') AND type in (N'U'))	
BEGIN
	IF COL_LENGTH('TMF_AWC','Group_') IS NULL
		BEGIN
			DROP TABLE TMF_AWC
		END	
END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMF_AWC]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[TMF_AWC](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Time_ID] [datetime] NOT NULL,
		[Claim_no] [varchar](19) NULL,
		[Group] [varchar](20) NULL,
		[Team] [varchar](20) NULL,
		[Case_manager] [varchar](81) NULL,		
		[AgencyName] [char](20) NULL,
		[Date_of_Injury] [datetime] NULL,
		[create_date] [datetime]  DEFAULT GETDATE(),		
		[POLICY_NO] [char](19) NULL,
		[Agency_Id] [varchar](20) NULL,
		[Sub_Category] [varchar](256) NULL,
		[EMPL_SIZE] [varchar](256) NULL,
		[Cert_Type] [varchar](256) NULL,
		[Med_cert_From] [datetime] NULL,
		[Med_cert_To] [datetime] NULL,
		[Account_Manager] [varchar](256) NULL,
		[Cell_no] [tinyint] NULL,
		[Portfolio] [varchar](256) NULL
	 CONSTRAINT [PK_TMF_AWC_ID] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
	
	END
ELSE
	BEGIN		
		IF COL_LENGTH('TMF_AWC','Team') IS NULL
		BEGIN
			ALTER TABLE TMF_AWC
			ADD Team varchar(20) null
		END
		IF COL_LENGTH('TMF_AWC','Case_manager') IS NULL
		BEGIN
			ALTER TABLE TMF_AWC
			ADD Case_manager varchar(81) null
		END
		IF COL_LENGTH('TMF_AWC','POLICY_NO') IS NULL
		BEGIN
			ALTER TABLE TMF_AWC
			ADD POLICY_NO char(19) null
		END
		IF COL_LENGTH('TMF_AWC','Agency_Id') IS NULL
		BEGIN
			ALTER TABLE TMF_AWC
			ADD Agency_Id varchar(20) null
		END
		IF COL_LENGTH('TMF_AWC','Sub_Category') IS NULL
		BEGIN
			ALTER TABLE TMF_AWC
			ADD Sub_Category varchar(256) null
		END	
		IF COL_LENGTH('TMF_AWC','EMPL_SIZE') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			ADD EMPL_SIZE nchar(2) null
		END	
		IF COL_LENGTH('TMF_AWC','Cert_Type') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			ADD Cert_Type varchar(256) null
		END	
		IF COL_LENGTH('TMF_AWC','Med_cert_From') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			ADD Med_cert_From datetime null
		END	
		IF COL_LENGTH('TMF_AWC','Med_cert_To') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			ADD Med_cert_To datetime null
		END	
		IF COL_LENGTH('TMF_AWC','Account_Manager') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			ADD Account_Manager varchar(256) null
		END	
		IF COL_LENGTH('TMF_AWC','Cell_no') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			ADD Cell_no tinyint null
		END
		IF COL_LENGTH('TMF_AWC','Portfolio') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			ADD Portfolio varchar(256) null
		END
		IF COL_LENGTH('TMF_AWC','Group_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			DROP COLUMN Group_
		END
		IF COL_LENGTH('TMF_AWC','Team_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			DROP COLUMN Team_
		END
		IF COL_LENGTH('TMF_AWC','Case_manager_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			DROP COLUMN Case_manager_
		END
	END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_AWC.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_AWC_Projections.sql  
--------------------------------  
/****** Object:  Table [dbo].[TMF_AWC_Projections]    Script Date: 07/08/2013 08:24:30 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMF_AWC_Projections]') AND type in (N'U'))	
BEGIN	
	CREATE TABLE [dbo].[TMF_AWC_Projections](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Unit_Type] [varchar](20) NOT NULL,
		[Unit_Name] [varchar](256) NOT NULL,
		[Type] [varchar](20) NOT NULL,
		[Time_Id] [datetime] NOT NULL,
		[Projection] [float] NOT NULL,
	 CONSTRAINT [PK_TMF_AWC_Projections] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_AWC_Projections.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_Portfolio.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMF_Portfolio]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[TMF_Portfolio](				
			[Id] [int] IDENTITY(1,1) NOT NULL,			
			[Group] [char](20) NULL,
			[Team] [varchar](20) NULL,
			[Case_Manager] [varchar](81) NULL,			
			[Agency_Name] [char](20) NULL,			
			[Agency_Id] [varchar](20) NULL,					
			[Policy_No] [char](19) NULL,			
			[Sub_Category] [varchar](256) NULL,
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
			[Is_Last_Month] [bit] NULL
		 CONSTRAINT [PK_TMF_Portfolio_ID] PRIMARY KEY CLUSTERED
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
		
	END
ELSE
	-- Update Users table schema
	IF COL_LENGTH('TMF_Portfolio','Is_Last_Month') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[TMF_Portfolio]
		ADD Is_Last_Month bit NULL	
	END	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_Portfolio.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_RTW.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMF_RTW]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[TMF_RTW](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Remuneration_Start] [datetime] NULL,
			[Remuneration_End] [datetime] NULL,
			[Measure_months] [bigint] NULL,
			[Group] [varchar](20) NULL,
			[Team] [varchar](20) NULL,
			[Case_manager] [varchar](81) NULL,			
			[Agency_Id] [varchar](20) NULL,
			[Claim_no] [varchar](20) NULL,
			[DTE_OF_INJURY] [datetime] NULL,
			[POLICY_NO] [char](19) NULL,
			[LT] [float] NULL,
			[WGT] [float] NULL,
			[EMPL_SIZE] [varchar](256) NULL,
			[Weeks_paid][float] NULL,
			[create_date] [datetime]  DEFAULT GETDATE(),
			[AgencyName] [char](20) NULL,
			[Sub_Category] [varchar](256) NULL,
			[Measure] [int] NULL,
			[Cert_Type] [varchar](256) NULL,
			[Med_cert_From] [datetime] NULL,
			[Med_cert_To] [datetime] NULL,
			[Account_Manager] [varchar](256) NULL,
			[Cell_no] [tinyint] NULL,
			[Portfolio] [varchar](256) NULL,
			[Stress] [varchar](256) NULL,
			[Liability_Status] [varchar](256) NULL,
			[cost_code] [varchar](256) NULL,
			[cost_code2] [varchar](256) NULL,
			[Claim_Closed_flag] [varchar] (256) NULL
		 CONSTRAINT [PK_TMF_RTW_MEASURE] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]	
		
	END
ELSE
	BEGIN
		IF COL_LENGTH('TMF_RTW','Cert_Type') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			ADD Cert_Type varchar(256) null
		END	
		IF COL_LENGTH('TMF_RTW','Med_cert_From') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			ADD Med_cert_From datetime null
		END	
		IF COL_LENGTH('TMF_RTW','Med_cert_To') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			ADD Med_cert_To datetime null
		END	
		IF COL_LENGTH('TMF_RTW','Account_Manager') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			ADD Account_Manager varchar(256) null
		END	
		IF COL_LENGTH('TMF_RTW','Cell_no') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			ADD Cell_no tinyint null
		END
		IF COL_LENGTH('TMF_RTW','Portfolio') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			ADD Portfolio varchar(256) null
		END
		
		IF COL_LENGTH('TMF_RTW','Stress') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			ADD Stress varchar(256) null
		END	
		IF COL_LENGTH('TMF_RTW','Liability_Status') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			ADD Liability_Status varchar(256) null
		END	
		IF COL_LENGTH('TMF_RTW','cost_code') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			ADD cost_code varchar(256) null
		END	
		IF COL_LENGTH('TMF_RTW','cost_code2') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			ADD cost_code2 varchar(256) null
		END	
		IF COL_LENGTH('TMF_RTW','Claim_Closed_flag') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			ADD Claim_Closed_flag varchar(256) null
		END	
		IF COL_LENGTH('TMF_RTW','Group_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			DROP COLUMN Group_
		END
		IF COL_LENGTH('TMF_RTW','Team_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			DROP COLUMN Team_
		END
		IF COL_LENGTH('TMF_RTW','Case_manager_') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			DROP COLUMN Case_manager_
		END
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
	--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_RTW_Target_Base.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMF_RTW_Target_Base]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[TMF_RTW_Target_Base](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Type] [varchar](20) NOT NULL,
			[Value] [varchar](256) NULL,
			[Sub_Value] [varchar](256) NULL,
			[Measure] [int] NULL,
			[Target] [float] NULL,
			[Base] [float] NULL,
			[UpdatedBy] [int] NULL,
			[Create_Date] [datetime] NULL,
			[Status] [smallint] NULL,
			[Remuneration] varchar(20)
		 CONSTRAINT [PK_TMF_RTW_Target_Base] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]	
	END
ELSE
	BEGIN	
		IF COL_LENGTH('TMF_RTW_Target_Base','Remuneration') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW_Target_Base]
			ADD Remuneration nvarchar(20) null
		END		
	END	


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_RTW_Target_Base.sql  
--------------------------------  
---------------------------------------------------------- 
------------------- UserDefinedFunction 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_CPR_Overall.sql  
--------------------------------  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_CPR_Overall]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_CPR_Overall]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_CPR_Overall]    Script Date: 08/01/2014 11:30:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_CPR_Overall](@System varchar(20), @Type VARCHAR(20), @Is_Last_Month bit)
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
	[Rehab_Paid] [float] NULL)
AS
BEGIN	
	IF UPPER(@System) = 'TMF'
	BEGIN
		INSERT @port_overall
		SELECT Value=RTRIM(case when @Type ='agency' then [Agency_Name] else [Group] end)
			,SubValue=RTRIM(case when @Type='agency' then [Sub_Category] else [Team] end)
			,SubValue2=RTRIM([Claims_Officer_Name])
			,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
			,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
			,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
			,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
			,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
			,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
			,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid]
			FROM TMF_Portfolio
			WHERE ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		INSERT @port_overall
		SELECT Value=RTRIM(case when @Type='employer_size' then [EMPL_SIZE] when @Type='group' then [Group] else [account_manager] end)
			,SubValue=RTRIM(case when @Type='group' then [Team] else [EMPL_SIZE] end)
			,SubValue2=RTRIM([Claims_Officer_Name])
			,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
			,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
			,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
			,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
			,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
			,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
			,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid]
			FROM EML_Portfolio
			WHERE ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		INSERT @port_overall
		SELECT Value=RTRIM(case when @Type='account_manager' then [Account_Manager] when @Type = 'portfolio' then [portfolio] else [Group] end)
			,SubValue=RTRIM(case when @Type='account_manager' or @Type = 'portfolio' then [EMPL_SIZE] else [Team] end)
			,SubValue2=RTRIM([Claims_Officer_Name])
			,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
			,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
			,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
			,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
			,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
			,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
			,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid]
			FROM HEM_Portfolio
			WHERE ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
	END
	RETURN;
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_CPR_Overall.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_dashboard_EML_RTW_getTargetAndBase.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_dashboard_EML_RTW_getTargetAndBase]    Script Date: 02/21/2013 11:06:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_dashboard_EML_RTW_getTargetAndBase]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_dashboard_EML_RTW_getTargetAndBase]
GO


/****** Object:  UserDefinedFunction [dbo].[udf_dashboard_EML_RTW_getTargetAndBase]    Script Date: 02/21/2013 11:06:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

create FUNCTION [dbo].[udf_dashboard_EML_RTW_getTargetAndBase](@rem_end datetime, @item varchar(20), @type varchar(20), @value varchar(20), @sub_value varchar(20), @measure int)
	returns FLOAT
as
BEGIN
	Declare @target float,@base float, @count int
	
	SELECT  @target = min(isnull(tb.[Target], 0)),@base = min(isnull(tb.[base], 0)),@count = count(*)
	FROM [EML_RTW_Target_Base] tb 
	WHERE 
	(([Type] = @type AND [Value] = @value)
	OR ([Value] = @value AND @value = 'eml'))
	AND ISNULL([Sub_Value], '') = ISNULL(@sub_value, '')
	AND [Measure] = @measure and Remuneration= (cast(year(@rem_end) AS varchar) 
                      + 'M' + CASE WHEN MONTH(@rem_end) <= 9 THEN '0' ELSE '' END 
                      + cast(month(@rem_end) AS varchar))	
	
	IF @COUNT = 0 OR @target = 0 OR @base = 0
	BEGIN		
		SELECT @target = min(tb.[Target]), @base = min(tb.[base])
		FROM [EML_RTW_Target_Base] tb 
		WHERE [Value] = 'eml'		
		AND [Measure] = @measure and Remuneration= (cast(year(@rem_end) AS varchar) 
                      + 'M' + CASE WHEN MONTH(@rem_end) <= 9 THEN '0' ELSE '' END 
                      + cast(month(@rem_end) AS varchar))						
	END
	
	IF @item = 'target' 
	BEGIN
		RETURN @target
	END 

	IF @item = 'base' 
	BEGIN
		RETURN @base
	END
	RETURN 0
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_dashboard_EML_RTW_getTargetAndBase.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_dashboard_HEM_RTW_getTargetAndBase.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[[udf_dashboard_HEM_RTW_getTargetAndBase]]    Script Date: 02/21/2013 11:06:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_dashboard_HEM_RTW_getTargetAndBase]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_dashboard_HEM_RTW_getTargetAndBase]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_dashboard_HEM_RTW_getTargetAndBase]    Script Date: 01/27/2014 09:51:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_dashboard_HEM_RTW_getTargetAndBase](@rem_end datetime, @item varchar(20), @type varchar(20), @value varchar(20), @sub_value varchar(20), @measure int)
	returns FLOAT
as
BEGIN
	Declare @target float,@base float, @count int
	
	SELECT  @target = min(isnull(tb.[Target], 0))
		   ,@base = min(isnull(tb.[base], 0))
		   ,@count = count(*)
	FROM [HEM_RTW_Target_Base] tb 
	WHERE (([Type] = @type AND [Value] = @value) OR ([Value] = @value AND @value = 'Hospitality'))
		   AND ISNULL([Sub_Value], '') = ISNULL(@sub_value, '')
			AND [Measure] = @measure and Remuneration= (cast(year(@rem_end) AS varchar) 
                      + 'M' + CASE WHEN MONTH(@rem_end) <= 9 THEN '0' ELSE '' END 
                      + cast(month(@rem_end) AS varchar))
	
	IF @COUNT = 0 OR @target = 0 OR @base = 0
	BEGIN		
		SELECT @target = min(tb.[Target]), @base = min(tb.[base])
		FROM [HEM_RTW_Target_Base] tb 
		WHERE [Value] = 'Hospitality'
		AND [Measure] = @measure and Remuneration= (cast(year(@rem_end) AS varchar) 
                      + 'M' + CASE WHEN MONTH(@rem_end) <= 9 THEN '0' ELSE '' END 
                      + cast(month(@rem_end) AS varchar))
	END
	
	IF @item = 'target' 
	BEGIN
		RETURN @target
	END 

	IF @item = 'base' 
	BEGIN
		RETURN @base
	END
	RETURN 0
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO

--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_dashboard_HEM_RTW_getTargetAndBase.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_dashboard_TMF_RTW_getTargetAndBase.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_dashboard_TMF_RTW_getTargetAndBase]    Script Date: 02/21/2013 11:06:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_dashboard_TMF_RTW_getTargetAndBase]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_dashboard_TMF_RTW_getTargetAndBase]
GO


/****** Object:  UserDefinedFunction [dbo].[udf_dashboard_TMF_RTW_getTargetAndBase]    Script Date: 02/21/2013 11:06:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

create FUNCTION [dbo].[udf_dashboard_TMF_RTW_getTargetAndBase](@rem_end datetime, @item varchar(20), @type varchar(20), @value varchar(20), @sub_value varchar(20), @measure int)
	returns FLOAT
as
BEGIN
	Declare @target float,@base float, @count int
	
	SELECT @target = min(isnull(tb.[Target], 0)), @base = min(isnull(tb.[base], 0)), @count = count(*)
	FROM [TMF_RTW_Target_Base] tb 
	WHERE 
	(([Type] = @type AND [Value] = @value)
	OR ([Value] = @value AND @value = 'tmf'))
	AND ISNULL([Sub_Value], '') = ISNULL(@sub_value, '')
	AND [Measure] = @measure and Remuneration= (cast(year(@rem_end) AS varchar) 
                      + 'M' + CASE WHEN MONTH(@rem_end) <= 9 THEN '0' ELSE '' END 
                      + cast(month(@rem_end) AS varchar))
	
	IF @COUNT = 0 OR @target = 0 OR @base = 0
	BEGIN	
		
		SELECT @target = min(tb.[Target]), @base = min(tb.[base])
		FROM [TMF_RTW_Target_Base] tb 
		WHERE [Value] = 'tmf'		
		AND [Measure] = @measure and Remuneration= (cast(year(@rem_end) AS varchar) 
                      + 'M' + CASE WHEN MONTH(@rem_end) <= 9 THEN '0' ELSE '' END 
                      + cast(month(@rem_end) AS varchar))			
	END
	
	IF @item = 'target' 
	BEGIN
		RETURN @target
	END 

	IF @item = 'base' 
	BEGIN
		RETURN @base
	END
	RETURN 0
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_dashboard_TMF_RTW_getTargetAndBase.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_EML_AWC_Generate_Time_ID.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_EML_AWC_Generate_Time_ID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_EML_AWC_Generate_Time_ID]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_EML_AWC_Generate_Time_ID]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_EML_AWC_Generate_Time_ID](@Type varchar(20),@WeeklyType varchar(20))
RETURNS TABLE 
AS
RETURN 
(	
    WITH temp AS
	(
		--SELECT CAST('01/01/' + cast(year(getdate()) AS varchar(4)) + ' 23:59' AS DATETIME) Time_Id
		--UNION ALL
		--SELECT DATEADD(m, 1, Time_Id)
		--FROM temp WHERE Time_Id < CAST('06/01/' + cast(year(getdate())+1 AS varchar(4)) + ' 23:59' AS DATETIME)
		SELECT CAST('01/01/' + cast(year(getdate()) AS varchar(4)) AS DATETIME) Time_Id
		UNION ALL
		SELECT DATEADD(m, 1, Time_Id)
		FROM temp WHERE Time_Id < CAST('06/01/' + cast(year(getdate())+1 AS varchar(4)) AS DATETIME)
	)

	select  [Type] =@Type
			,uv_Unit.Unit
			,uv_Unit.[Primary]
			,WeeklyType = @WeeklyType
			--,Time_Id =temp.Time_Id
			,Time_Id = dateadd(dd, -1, dateadd(mm, 1, temp.Time_Id)) + '23:59'
		    ,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' 
							+ RIGHT(datename(year, Time_Id), 2)
		    ,Actual = 0
		    ,Projection =(select ISNULL(sum(Projection), 0)
								 from dbo.eml_awc_Projections 
								 where [Type] =@WeeklyType 
								 and Unit_Type=@Type 
								 and RTRIM(Unit_Name)=uv_Unit.Unit 
								 and year(Time_Id)=Year(temp.Time_Id) 
								 and month(Time_Id)=month(temp.Time_Id))
	from temp
	cross join
	(
		SELECT  distinct 
			case 
				when @Type = 'eml' then 'EML'
				when @Type = 'employer_size' then RTRIM(Empl_Size)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then RTRIM(Team)
				when @Type = 'am_empl_size' then RTRIM(Empl_Size)
				else RTRIM([Group]) end as Unit,
			case 
				when @Type = 'eml' then 'EML'
				when @Type = 'employer_size' then RTRIM(Empl_Size)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then RTRIM([Group])
				when @Type = 'am_empl_size' then RTRIM(Account_Manager)
				else RTRIM([Group]) end as [Primary]
		FROM   eml_awc where RTRIM(Account_Manager) is not null
	) as uv_Unit
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_EML_AWC_Generate_Time_ID.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_HEM_AWC_Generate_Time_ID.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_HEM_AWC_Generate_Time_ID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_HEM_AWC_Generate_Time_ID]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_HEM_AWC_Generate_Time_ID]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_HEM_AWC_Generate_Time_ID](@Type varchar(20),@WeeklyType varchar(20))
RETURNS TABLE 
AS
RETURN 
(	
    WITH temp AS
	(
		--SELECT CAST('01/01/' + cast(year(getdate()) AS varchar(4)) + ' 23:59' AS DATETIME) Time_Id
		--UNION ALL
		--SELECT DATEADD(m, 1, Time_Id)
		--FROM temp WHERE Time_Id < CAST('06/01/' + cast(year(getdate())+1 AS varchar(4)) + ' 23:59' AS DATETIME)
		SELECT CAST('01/01/' + cast(year(getdate()) AS varchar(4)) AS DATETIME) Time_Id
		UNION ALL
		SELECT DATEADD(m, 1, Time_Id)
		FROM temp WHERE Time_Id < CAST('06/01/' + cast(year(getdate())+1 AS varchar(4)) AS DATETIME)
	)

	select  [Type] =@Type
			,uv_Unit.Unit
			,uv_Unit.[Primary]
			,WeeklyType = @WeeklyType
			--,Time_Id =temp.Time_Id
			,Time_Id = dateadd(dd, -1, dateadd(mm, 1, temp.Time_Id)) + '23:59'
		    ,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' 
							+ RIGHT(datename(year, Time_Id), 2)
		    ,Actual = 0
		    ,Projection =(select ISNULL(sum(Projection), 0)
								 from dbo.hem_awc_Projections 
								 where [Type] =@WeeklyType 
								 and Unit_Type=@Type 
								 and RTRIM(Unit_Name)=uv_Unit.Unit 
								 and year(Time_Id)=Year(temp.Time_Id) 
								 and month(Time_Id)=month(temp.Time_Id))
	from temp
	cross join
	(
		SELECT  distinct 
			case 
				when @Type = 'hem' then 'HEM'
				when @Type = 'portfolio' then RTRIM(Portfolio)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then RTRIM(Team)
				when @Type = 'am_empl_size' then RTRIM(Empl_Size)
				when @Type = 'portfolio_empl_size' then RTRIM(Empl_Size)
				else RTRIM([Group]) end as Unit,
			case 
				when @Type = 'hem' then 'HEM'
				when @Type = 'portfolio' then RTRIM(Portfolio)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then RTRIM([Group])
				when @Type = 'am_empl_size' then RTRIM(Account_Manager)
				when @Type = 'portfolio_empl_size' then RTRIM(Portfolio)
				else RTRIM([Group]) end as [Primary]
		FROM   hem_awc 
	) as uv_Unit
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_HEM_AWC_Generate_Time_ID.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_PORT_Overall.sql  
--------------------------------  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_PORT_Overall]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_PORT_Overall]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_PORT_Overall]    Script Date: 08/01/2014 11:30:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_PORT_Overall](@System varchar(20), @Type VARCHAR(20),@End_Date Datetime)
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
	[Rehab_Paid] [float] NULL)
AS
BEGIN	
	IF UPPER(@System) = 'TMF'
	BEGIN
		INSERT @port_overall
		SELECT Value=(case when @Type ='agency' then [Agency_Name] else [Group] end)
			,SubValue=(case when @Type='agency' then [Sub_Category] else [Team] end)
			,SubValue2=[Claims_Officer_Name]
			,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
			,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
			,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
			,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
			,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
			,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
			,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid]
			FROM TMF_Portfolio
			WHERE	ISNULL(Is_Last_Month, 0) = 0
					AND Reporting_Date = (select top 1 Reporting_Date from TMF_Portfolio
											where CONVERT(datetime, Reporting_Date, 101) 
												>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		INSERT @port_overall
		SELECT Value=(case when @Type='employer_size' then [EMPL_SIZE] when @Type='group' then [Group] else [account_manager] end)
			,SubValue=(case when @Type='group' then [Team] else [EMPL_SIZE] end)
			,SubValue2=[Claims_Officer_Name]
			,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
			,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
			,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
			,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
			,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
			,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
			,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid]
			FROM EML_Portfolio
			WHERE ISNULL(Is_Last_Month, 0) = 0 
				  AND Reporting_Date = (select top 1 Reporting_Date from EML_Portfolio
											where CONVERT(datetime, Reporting_Date, 101) 
												>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		INSERT @port_overall
		SELECT Value=(case when @Type='account_manager' then [Account_Manager] when @Type = 'portfolio' then [portfolio] else [Group] end)
			,SubValue=(case when @Type='account_manager' or @Type = 'portfolio' then [EMPL_SIZE] else [Team] end)
			,SubValue2=[Claims_Officer_Name]
			,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
			,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
			,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
			,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
			,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
			,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
			,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid]
			FROM HEM_Portfolio
			WHERE	ISNULL(Is_Last_Month, 0) = 0
					AND Reporting_Date = (select top 1 Reporting_Date from HEM_Portfolio
											where CONVERT(datetime, Reporting_Date, 101) 
												>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
	END
	RETURN;
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_PORT_Overall.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_TMF_AWC_Generate_Time_ID.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_TMF_AWC_Generate_Time_ID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_TMF_AWC_Generate_Time_ID]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_TMF_AWC_Generate_Time_ID]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_TMF_AWC_Generate_Time_ID](@Type varchar(20),@WeeklyType varchar(20))
RETURNS TABLE 
AS
RETURN 
(   
    WITH temp AS 
	(
		--SELECT CAST('01/01/' + cast(year(getdate()) AS varchar(4)) + ' 23:59' AS DATETIME) Time_Id
		--UNION ALL
		--SELECT DATEADD(m, 1, Time_Id)
		--FROM temp WHERE Time_Id < CAST('06/01/' + cast(year(getdate())+1 AS varchar(4)) + ' 23:59' AS DATETIME)
		SELECT CAST('01/01/' + cast(year(getdate()) AS varchar(4)) AS DATETIME) Time_Id
		UNION ALL
		SELECT DATEADD(m, 1, Time_Id)
		FROM temp WHERE Time_Id < CAST('06/01/' + cast(year(getdate())+1 AS varchar(4)) AS DATETIME)
	)

	select  [Type] =@Type
			,uv_Unit.Unit
			,uv_Unit.[Primary]
			,WeeklyType = @WeeklyType
			--,Time_Id =temp.Time_Id
			,Time_Id = dateadd(dd, -1, dateadd(mm, 1, temp.Time_Id)) + '23:59'
		    ,Month_Year = LEFT(datename(month, Time_Id), 3) + '- ' 
							+ RIGHT(datename(year, Time_Id), 2)
		    ,Actual = 0
		    ,Projection =(select ISNULL(sum(Projection), 0)
								 from dbo.tmf_awc_Projections 
								 where [Type] =@WeeklyType 
								 and Unit_Type=@Type 
								 and RTRIM(Unit_Name)=uv_Unit.Unit 
								 and year(Time_Id)=Year(temp.Time_Id) 
								 and month(Time_Id)=month(temp.Time_Id))
	from temp
	cross join
	(
		SELECT  distinct 
		case
			when @Type = 'tmf' then 'TMF' 
			when @Type = 'agency' then RTRIM(AgencyName)
			when @Type = 'sub_category' then RTRIM(Sub_Category)
			when @Type = 'team' then RTRIM(Team)
			else RTRIM([Group]) end as Unit,
		case 
			when @Type = 'tmf' then 'TMF'
			when @Type = 'agency' then RTRIM(AgencyName) 
			when @Type = 'sub_category' then RTRIM(AgencyName)
			when @Type = 'team' then RTRIM([Group])
			else RTRIM([Group]) end as [Primary]
		from TMF_AWC
	) as uv_Unit	
)
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_TMF_AWC_Generate_Time_ID.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group]()
RETURNS TABLE 
AS
RETURN 
(	
    select * from 
	(
	select Month_period = 1
	union select Month_period =3
	union select Month_period =6
	union select Month_period =12
	) as tmp1
	cross join
	(

	select Measure_months =13
	union select Measure_months =26
	union select Measure_months =52
	union select Measure_months =78
	union select Measure_months =104) as tmp2

	cross join
	(
	select [type]='group'  ,Agency_Group  ='4' ,LT=0,WGT  =0   ,AVGDURN   =0   ,[Target] = 0
	union select [type]='group'  ,Agency_Group  ='6' ,LT=0,WGT  =0   ,AVGDURN   =0   ,[Target] = 0
	union select [type]='group'  ,Agency_Group  ='9' ,LT=0,WGT  =0   ,AVGDURN   =0   ,[Target] = 0
	) as tmp3
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_Whole_EML_Generate_Years.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Whole_EML_Generate_Years]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_Whole_EML_Generate_Years]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_Whole_EML_Generate_Years]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_Whole_EML_Generate_Years](@Type varchar(20))
RETURNS TABLE 
AS
RETURN 
(	
    WITH temp AS
	(
		SELECT CAST(CAST(MONTH(getdate()) as varchar(2)) + '/01/2005 23:59' as Datetime) Time_Id
		UNION ALL
		SELECT DATEADD(YEAR,1, Time_Id)
		FROM temp WHERE year(Time_Id) < YEAR(getdate()) - 1
	)
	select  [UnitType] =@Type
			,uv_Unit.Unit
			,uv_Unit.[Primary]
			,Transaction_Year = temp.Time_Id
		    ,[Type] = 'Actual'
		    ,No_of_Active_Weekly_Claims = 0
	from temp
	cross join
	(
		SELECT  distinct 
			case 
				when @Type = 'eml' then 'EML'
				when @Type = 'employer_size' then RTRIM(Empl_Size)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then RTRIM(Team)
				when @Type = 'am_empl_size' then RTRIM(Empl_Size)
				else RTRIM([Group]) end as Unit,
			case 
				when @Type = 'eml' then 'EML'
				when @Type = 'employer_size' then RTRIM(Empl_Size)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then RTRIM([Group])
				when @Type = 'am_empl_size' then RTRIM(Account_Manager)
				else RTRIM([Group]) end as [Primary]
		FROM   eml_awc where RTRIM(Account_Manager) is not null
	) as uv_Unit
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_Whole_EML_Generate_Years.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_Whole_HEM_Generate_Years.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Whole_HEM_Generate_Years]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [udf_Whole_HEM_Generate_Years]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_Whole_HEM_Generate_Years]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_Whole_HEM_Generate_Years](@Type varchar(20))
RETURNS TABLE 
AS
RETURN 
(	
    WITH temp AS
	(
		SELECT CAST(CAST(MONTH(getdate()) as varchar(2)) + '/01/2005 23:59' as Datetime) Time_Id
		UNION ALL
		SELECT DATEADD(YEAR,1, Time_Id)
		FROM temp WHERE year(Time_Id) < YEAR(getdate()) - 1
	)
	select  [UnitType] =@Type
			,uv_Unit.Unit
			,uv_Unit.[Primary]
			,Transaction_Year = temp.Time_Id
		    ,[Type] = 'Actual'
		    ,No_of_Active_Weekly_Claims = 0
	from temp
	cross join
	(
		SELECT  distinct 
			case 
				when @Type = 'hem' then 'HEM'
				when @Type = 'portfolio' then RTRIM(Portfolio)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then RTRIM(Team)
				when @Type = 'am_empl_size' then RTRIM(Empl_Size)
				when @Type = 'portfolio_empl_size' then RTRIM(Empl_Size)
				else RTRIM([Group]) end as Unit,
			case 
				when @Type = 'hem' then 'HEM'
				when @Type = 'portfolio' then RTRIM(Portfolio)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then RTRIM([Group])
				when @Type = 'am_empl_size' then RTRIM(Account_Manager)
				when @Type = 'portfolio_empl_size' then RTRIM(Portfolio)
				else RTRIM([Group]) end as [Primary]
		FROM   hem_awc 
	) as uv_Unit
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_Whole_HEM_Generate_Years.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_Whole_TMF_Generate_Years.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Whole_TMF_Generate_Years]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_Whole_TMF_Generate_Years]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_Whole_TMF_Generate_Years]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_Whole_TMF_Generate_Years](@Type varchar(20))
RETURNS TABLE 
AS
RETURN 
(   
    WITH temp AS 
	(
		SELECT CAST(CAST(MONTH(getdate()) as varchar(2)) + '/01/2005 23:59' as Datetime) Time_Id
		UNION ALL
		SELECT DATEADD(YEAR,1, Time_Id)
		FROM temp WHERE year(Time_Id) < YEAR(getdate()) - 1
	)

	select  [UnitType] =@Type
			,uv_Unit.Unit
			,uv_Unit.[Primary]
			,Transaction_Date = temp.Time_Id
		    ,[Type] = 'Actual'
		    ,No_of_Active_Weekly_Claims = 0
	from temp
	cross join
	(
		SELECT  distinct 
		case
			when @Type = 'tmf' then 'TMF' 
			when @Type = 'agency' then RTRIM(AgencyName)
			when @Type = 'sub_category' then RTRIM(Sub_Category)
			when @Type = 'team' then RTRIM(Team)
			else RTRIM([Group]) end as Unit,
		case 
			when @Type = 'tmf' then 'TMF'
			when @Type = 'agency' then RTRIM(AgencyName) 
			when @Type = 'sub_category' then RTRIM(AgencyName)
			when @Type = 'team' then RTRIM([Group])
			else RTRIM([Group]) end as [Primary]
		from TMF_AWC
	) as uv_Unit	
)
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\udf_Whole_TMF_Generate_Years.sql  
--------------------------------  
---------------------------------------------------------- 
------------------- View 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_CPR_Raw.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_CPR_Raw')
	DROP VIEW [dbo].[uv_CPR_Raw]
GO
CREATE VIEW [dbo].[uv_CPR_Raw]
AS
	SELECT  System='TMF',Med_Cert_Status=Med_Cert_Status_This_Week,*,
		[Grouping] = case when RTRIM(Agency_Name) in ('Health', 'Other')
							then 'HEALTH & OTHER'
						when RTRIM(Agency_Name) in ('Police', 'Fire')
							then 'POLICE & FIRE'
						else ''
					end
		FROM dbo.TMF_Portfolio
		WHERE Reporting_Date = (select max(reporting_date) from dbo.TMF_Portfolio)
		 
	UNION ALL
	
	SELECT  System='HEM',Med_Cert_Status=Med_Cert_Status_This_Week,*, 
		[Grouping] = case when RTRIM(Portfolio) in ('Accommodation', 'Pubs, Taverns and Bars')
							then 'Hotel'
						else ''
					end 
		FROM dbo.HEM_Portfolio
		WHERE Reporting_Date = (select max(reporting_date) from dbo.HEM_Portfolio)
	
	UNION ALL
	
	SELECT  System='EML',Med_Cert_Status=Med_Cert_Status_This_Week,*, [Grouping] = ''
		FROM dbo.EML_Portfolio
		WHERE Reporting_Date = (select max(reporting_date) from dbo.EML_Portfolio)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_CPR_Raw.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Raw_Data.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Raw_Data')
	DROP VIEW [dbo].[uv_EML_AWC_Raw_Data]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Raw_Data] 
AS
SELECT    Time_ID
		, Claim_no
		, Team
		, [Group] = RTRIM([Group])
		, Sub_Category = RTRIM(Sub_Category)
		, Employer_Size = RTRIM(Empl_Size)
		, Date_of_Injury
		,Cert_Type
		,Med_cert_From
		,Med_cert_To
		,Account_Manager
		,Portfolio
		,Cell_no
FROM    dbo.EML_AWC
WHERE    (Time_ID >= DATEADD(mm, - 2,DATEADD(yy, DATEDIFF(yy,0,GETDATE()), 0)))
                          
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Raw_Data.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Weekly_Open_1_2.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Weekly_Open_1_2')
	DROP VIEW [dbo].[uv_EML_AWC_Weekly_Open_1_2]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Weekly_Open_1_2] 
AS	
	---EML---
	SELECT  [Type] ='EML'
			,Unit = 'EML'
			,[Primary] = 'EML'
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2)
			,Actual = (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
						FROM	EML_AWC EML_AWC1
						WHERE   EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID 
								AND Year(EML_AWC1.Date_of_injury) = Year(eml_awc.Time_ID) - 1
									AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)							
						)
			,Projection =  (SELECT ISNULL(sum(Projection), 0)
								FROM	dbo.EML_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'eml' 										
										AND year(Time_Id) = Year(EML_AWC.Time_Id) 
										AND month(Time_Id)= month(EML_AWC.Time_Id))
	FROM    dbo.udf_EML_AWC_Generate_Time_ID('eml','1-2') eml_awc
	
	UNION ALL
	---Employer size---
	SELECT  [Type] = 'employer_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2)
			,Actual = (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
						FROM	EML_AWC EML_AWC1
						WHERE   RTRIM(Empl_Size) = RTRIM(EML_AWC.[Primary]) 
								AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID 
								AND Year(EML_AWC1.Date_of_injury) = Year(eml_awc.Time_ID) - 1
									AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)								
						)
			,Projection =  (SELECT ISNULL(sum(Projection), 0)
								FROM	dbo.EML_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'employer_size' 
										AND RTRIM(Unit_Name) = RTRIM(EML_AWC.[Primary]) 
										AND year(Time_Id) = Year(EML_AWC.Time_Id) 
										AND month(Time_Id)= month(EML_AWC.Time_Id))
	FROM    dbo.udf_EML_AWC_Generate_Time_ID('employer_size','1-2') eml_awc
	
	---Group---
	UNION ALL
	SELECT  [Type] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 						  
			,Actual = (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
						FROM	EML_AWC EML_AWC1
						WHERE   RTRIM([Group]) = RTRIM(EML_AWC.Unit) 
								AND NOT EXISTS(SELECT   1
												FROM	EML_AWC EML_AWC2
												WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
														AND EML_AWC2.time_id =(SELECT   max(time_Id)
																				FROM    EML_AWC EML_AWC3
																				WHERE   EML_AWC3.claim_no = EML_AWC1.claim_no 
																						AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND  EML_AWC.Time_ID
																				) 
														AND EML_AWC2.[group] <> EML_AWC1.[group]
												)
								AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,EML_AWC.Time_ID) AND EML_AWC.Time_ID 
								AND Year(EML_AWC1.Date_of_injury) = Year(eml_awc.Time_ID) - 1
								AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)								
						)
			,Projection =(SELECT	ISNULL(sum(Projection), 0)
							FROM    dbo.EML_AWC_Projections
							WHERE   [Type] = '1-2' AND Unit_Type = 'group' 
									AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit) 
									AND year(Time_Id) = Year(EML_AWC.Time_Id) 
									AND month(Time_Id)= month(EML_AWC.Time_Id)
							)
	FROM    dbo.udf_EML_AWC_Generate_Time_ID('group','1-2') eml_awc	
	
	---Account manager---
	UNION ALL
	SELECT  [Type] = 'account_manager'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 						  
			,Actual = (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
						FROM	EML_AWC EML_AWC1
						WHERE   RTRIM([Account_Manager]) = RTRIM(EML_AWC.[Primary]) 
								AND NOT EXISTS(SELECT   1
												FROM	EML_AWC EML_AWC2
												WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
														AND EML_AWC2.time_id =(SELECT   max(time_Id)
																				FROM    EML_AWC EML_AWC3
																				WHERE   EML_AWC3.claim_no = EML_AWC1.claim_no 
																						AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND  EML_AWC.Time_ID
																				) 
														AND EML_AWC2.[Account_Manager] <> EML_AWC1.[Account_Manager]
												)
								AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,EML_AWC.Time_ID) AND EML_AWC.Time_ID 
								AND Year(EML_AWC1.Date_of_injury) = Year(eml_awc.Time_ID) - 1
								AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)							
						)
			,Projection =(SELECT	ISNULL(sum(Projection), 0)
							FROM    dbo.EML_AWC_Projections
							WHERE   [Type] = '1-2' AND Unit_Type = 'account_manager' 
									AND RTRIM(Unit_Name) = RTRIM(EML_AWC.[Primary]) 
									AND year(Time_Id) = Year(EML_AWC.Time_Id) 
									AND month(Time_Id)= month(EML_AWC.Time_Id)
							)
	FROM    dbo.udf_EML_AWC_Generate_Time_ID('account_manager','1-2') eml_awc
	
	---Team---
	UNION ALL
	SELECT  [Type] = 'team'
			,Unit = Unit
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 						
			,Actual = (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
								FROM	EML_AWC EML_AWC1
								WHERE   Team = EML_AWC.Unit 
										AND [Group] = EML_AWC.[Primary]
										AND NOT EXISTS(SELECT   1
														FROM	EML_AWC EML_AWC2
														WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
																AND EML_AWC2.time_id =
																	(SELECT max(time_Id)
																	  FROM  EML_AWC EML_AWC3
																	  WHERE EML_AWC3.claim_no = EML_AWC1.claim_no 
																			AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID)
																AND EML_AWC2.[group] <> EML_AWC1.[group]
														) 
										AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID 
										AND Year(EML_AWC1.Date_of_injury) = Year(eml_awc.Time_ID) - 1
										AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
						)
			,Projection = (SELECT   ISNULL(sum(Projection), 0)
								FROM	dbo.EML_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'team' 
										AND Unit_Name = EML_AWC.Unit 
										AND year(Time_Id) = Year(EML_AWC.Time_Id) 
										AND month(Time_Id)= month(EML_AWC.Time_Id))
	FROM    dbo.udf_EML_AWC_Generate_Time_ID('team','1-2') EML_AWC
	
	---AM_EMPL_Size---
	UNION ALL
	SELECT  [Type] = 'am_empl_size'
			,Unit = Unit
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 						
			,Actual = (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
								FROM	EML_AWC EML_AWC1
								WHERE   Empl_Size = EML_AWC.Unit
										AND Account_Manager = EML_AWC.[Primary]
										AND NOT EXISTS(SELECT   1
														FROM	EML_AWC EML_AWC2
														WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
																AND EML_AWC2.time_id =
																	(SELECT max(time_Id)
																	  FROM  EML_AWC EML_AWC3
																	  WHERE EML_AWC3.claim_no = EML_AWC1.claim_no 
																			AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID)
																AND EML_AWC2.[Account_Manager] <> EML_AWC1.[Account_Manager]
														) 
										AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID 
										AND Year(EML_AWC1.Date_of_injury) = Year(eml_awc.Time_ID) - 1
										AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
						)
			,Projection = (SELECT   ISNULL(sum(Projection), 0)
								FROM	dbo.EML_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'am_empl_size' 
										AND Unit_Name = EML_AWC.Unit 										
										AND year(Time_Id) = Year(EML_AWC.Time_Id) 
										AND month(Time_Id)= month(EML_AWC.Time_Id))
	FROM    dbo.udf_EML_AWC_Generate_Time_ID('am_empl_size','1-2') EML_AWC
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Weekly_Open_1_2.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Weekly_Open_3_5.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Weekly_Open_3_5')
	DROP VIEW [dbo].[uv_EML_AWC_Weekly_Open_3_5]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Weekly_Open_3_5] 
AS	
--EML--
SELECT  [Type] ='EML'
		, Unit = 'EML'
		, [Primary] = 'EML'
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year,Time_Id), 2) 
        , Actual =
				  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
                    FROM    EML_AWC EML_AWC1
                    WHERE   EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID 
							AND Year(EML_AWC1.Date_of_injury) BETWEEN Year(eml_awc.Time_ID) - 4 AND Year(eml_awc.Time_ID) - 2
							AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
                   )
        , Projection =
                  (SELECT ISNULL(sum(Projection), 0)
                    FROM	dbo.EML_AWC_Projections
                    WHERE   [Type] = '3-5' AND Unit_Type = 'eml' 							
							AND year(Time_Id) = Year(EML_AWC.Time_Id) 
							AND month(Time_Id) = month(EML_AWC.Time_Id)
                    )
FROM    dbo.udf_EML_AWC_Generate_Time_ID('eml','3-5') EML_AWC

UNION ALL
--Employer size--
SELECT  [Type] = 'employer_size'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year,Time_Id), 2) 
        , Actual =
				  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
                    FROM    EML_AWC EML_AWC1
                    WHERE   RTRIM(Empl_Size) = RTRIM(EML_AWC.[Primary]) 
							AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID 
							AND Year(EML_AWC1.Date_of_injury) BETWEEN Year(eml_awc.Time_ID) - 4 AND Year(eml_awc.Time_ID) - 2
							AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
                   )
        , Projection =
                  (SELECT ISNULL(sum(Projection), 0)
                    FROM	dbo.EML_AWC_Projections
                    WHERE   [Type] = '3-5' AND Unit_Type = 'employer_size' 
							AND RTRIM(Unit_Name) = RTRIM(EML_AWC.[Primary]) 
							AND year(Time_Id) = Year(EML_AWC.Time_Id) 
							AND month(Time_Id) = month(EML_AWC.Time_Id)
                    )
FROM    dbo.udf_EML_AWC_Generate_Time_ID('employer_size','3-5') eml_awc

UNION ALL
SELECT  [Type] = 'group'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year =LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        , Actual =
                  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
                    FROM    EML_AWC EML_AWC1
                    WHERE   RTRIM([Group]) = RTRIM(EML_AWC.Unit) 
							AND NOT EXISTS (SELECT     1
											FROM    EML_AWC EML_AWC2
											WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
													AND EML_AWC2.time_id =
                                                        (SELECT max(time_Id)
                                                          FROM  EML_AWC EML_AWC3
                                                          WHERE EML_AWC3.claim_no = EML_AWC1.claim_no 
																	AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) 
																	AND EML_AWC.Time_ID
														) 
													AND EML_AWC2.[group] <> EML_AWC1.[group]
											) 
                            AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) 
                            AND EML_AWC.Time_ID AND Year(EML_AWC1.Date_of_injury) BETWEEN Year(eml_awc.Time_ID) - 4 AND Year(eml_awc.Time_ID) - 2
                            AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
                    )
        , Projection =
                          (SELECT   ISNULL(sum(Projection), 0)
                            FROM    dbo.EML_AWC_Projections
                            WHERE   [Type] = '3-5' AND Unit_Type = 'group' 
									AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit) 
									AND year(Time_Id) = Year(EML_AWC.Time_Id) 
									AND month(Time_Id)= month(EML_AWC.Time_Id)
							)
FROM    dbo.udf_EML_AWC_Generate_Time_ID('group','3-5') eml_awc

UNION ALL
SELECT  [Type] = 'account_manager'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year =LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        , Actual =
                  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
                    FROM    EML_AWC EML_AWC1
                    WHERE   RTRIM([Account_Manager]) = RTRIM(EML_AWC.[Primary]) 
							AND NOT EXISTS (SELECT     1
											FROM    EML_AWC EML_AWC2
											WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
													AND EML_AWC2.time_id =
                                                        (SELECT max(time_Id)
                                                          FROM  EML_AWC EML_AWC3
                                                          WHERE EML_AWC3.claim_no = EML_AWC1.claim_no 
																	AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) 
																	AND EML_AWC.Time_ID
														) 
													AND EML_AWC2.[Account_Manager] <> EML_AWC1.[Account_Manager]
											) 
                            AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) 
                            AND EML_AWC.Time_ID AND Year(EML_AWC1.Date_of_injury) BETWEEN Year(eml_awc.Time_ID) - 4 AND Year(eml_awc.Time_ID) - 2
                            AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
                    )
        , Projection =
                          (SELECT   ISNULL(sum(Projection), 0)
                            FROM    dbo.EML_AWC_Projections
                            WHERE   [Type] = '3-5' AND Unit_Type = 'account_manager' 
									AND RTRIM(Unit_Name) = RTRIM(EML_AWC.[Primary]) 
									AND year(Time_Id) = Year(EML_AWC.Time_Id) 
									AND month(Time_Id)= month(EML_AWC.Time_Id)
							)
FROM    dbo.udf_EML_AWC_Generate_Time_ID('account_manager','3-5') eml_awc

UNION ALL
SELECT  [Type] = 'team'
		,Unit = Unit
		,[Primary] = RTRIM([Primary])
		,WeeklyType = '3-5'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =
                  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
						FROM	EML_AWC EML_AWC1
						WHERE   Team = EML_AWC.Unit 
								AND [Group] = EML_AWC.[Primary]
								AND NOT EXISTS  (SELECT  1
                                                 FROM   EML_AWC EML_AWC2
                                                 WHERE  EML_AWC2.claim_no = EML_AWC1.claim_no 
														AND EML_AWC2.time_id =(SELECT	max(time_Id)
																				FROM    EML_AWC EML_AWC3
																				WHERE   EML_AWC3.claim_no = EML_AWC1.claim_no 
																						AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID
																				) 
														AND EML_AWC2.[group] <> EML_AWC1.[group]
												) 
								AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,EML_AWC.Time_ID) AND EML_AWC.Time_ID 
                                AND Year(EML_AWC1.Date_of_injury) BETWEEN Year(eml_awc.Time_ID) - 4 AND Year(eml_awc.Time_ID) - 2
                                AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc) 
                    )
        ,Projection =
                  (SELECT   ISNULL(sum(Projection), 0)
					FROM    dbo.EML_AWC_Projections
					WHERE   [Type] = '3-5' AND Unit_Type = 'team' 
							AND Unit_Name = EML_AWC.Unit 
							AND year(Time_Id)  = Year(EML_AWC.Time_Id) 
							AND month(Time_Id) = month(EML_AWC.Time_Id)
					)
FROM    dbo.udf_EML_AWC_Generate_Time_ID('team','3-5') EML_AWC

UNION ALL
SELECT  [Type] = 'am_empl_size'
		,Unit = Unit
		,[Primary] = RTRIM([Primary])
		,WeeklyType = '3-5'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =
                  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
						FROM	EML_AWC EML_AWC1
						WHERE   Empl_Size = EML_AWC.Unit
								AND [Account_Manager] = EML_AWC.[Primary]
								AND NOT EXISTS  (SELECT  1
                                                 FROM   EML_AWC EML_AWC2
                                                 WHERE  EML_AWC2.claim_no = EML_AWC1.claim_no 
														AND EML_AWC2.time_id =(SELECT	max(time_Id)
																				FROM    EML_AWC EML_AWC3
																				WHERE   EML_AWC3.claim_no = EML_AWC1.claim_no 
																						AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID
																				) 
														AND EML_AWC2.[Account_Manager] <> EML_AWC1.[Account_Manager]
												) 
								AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,EML_AWC.Time_ID) AND EML_AWC.Time_ID 
                                AND Year(EML_AWC1.Date_of_injury) BETWEEN Year(eml_awc.Time_ID) - 4 AND Year(eml_awc.Time_ID) - 2
                                AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)                                
                    )
        ,Projection =
                  (SELECT   ISNULL(sum(Projection), 0)
					FROM    dbo.EML_AWC_Projections
					WHERE   [Type] = '3-5' AND Unit_Type = 'am_empl_size' 
							AND Unit_Name = EML_AWC.Unit 
							--AND [Account_Manager] = EML_AWC.[Account_Manager]
							AND year(Time_Id)  = Year(EML_AWC.Time_Id) 
							AND month(Time_Id) = month(EML_AWC.Time_Id)
					)
FROM    dbo.udf_EML_AWC_Generate_Time_ID('am_empl_size','3-5') EML_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Weekly_Open_3_5.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Weekly_Open_5_Plus.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Weekly_Open_5_Plus')
	DROP VIEW [dbo].[uv_EML_AWC_Weekly_Open_5_Plus]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Weekly_Open_5_Plus] 
AS 
--EML--
SELECT  [Type] = 'EML'
		, Unit = 'EML'
		, [Primary] = 'EML'
		, WeeklyType = '5-plus'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, 
                      Time_Id), 2) 
        , Actual = (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
                    FROM    EML_AWC EML_AWC1
                    WHERE   EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) 
										AND EML_AWC.Time_ID 
							AND Year(EML_AWC1.Date_of_injury) < Year(eml_awc.Time_ID) - 4
							AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc) 
					)
		, Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.EML_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'eml' 								
								AND year(Time_Id) = Year(EML_AWC.Time_Id) 
								AND month(Time_Id)= month(EML_AWC.Time_Id)
						)
FROM    dbo.udf_EML_AWC_Generate_Time_ID('eml','5-plus') eml_awc

UNION ALL
--Employer size--
SELECT  [Type] = 'employer_size'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '5-plus'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, 
                      Time_Id), 2) 
        , Actual = (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
                    FROM    EML_AWC EML_AWC1
                    WHERE   RTRIM(Empl_Size) = RTRIM(EML_AWC.[Primary]) 
							AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) 
										AND EML_AWC.Time_ID 
							AND Year(EML_AWC1.Date_of_injury) < Year(eml_awc.Time_ID) - 4
							AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
					)
		, Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.EML_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'employer_size' 
								AND RTRIM(Unit_Name) = RTRIM(EML_AWC.[Primary]) 
								AND year(Time_Id) = Year(EML_AWC.Time_Id) 
								AND month(Time_Id)= month(EML_AWC.Time_Id)
						)
FROM    dbo.udf_EML_AWC_Generate_Time_ID('employer_size','5-plus') eml_awc

UNION ALL
SELECT  [Type] = 'group'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '5-plus'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =(SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
                    FROM    EML_AWC EML_AWC1
                    WHERE   RTRIM([Group]) = RTRIM(EML_AWC.Unit) 
							AND NOT EXISTS
								(SELECT 1
								 FROM   EML_AWC EML_AWC2
								 WHERE  EML_AWC2.claim_no = EML_AWC1.claim_no 
										AND EML_AWC2.time_id =
													(SELECT max(time_Id)
													  FROM  EML_AWC EML_AWC3
													  WHERE EML_AWC3.claim_no = EML_AWC1.claim_no 
															AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) 
															AND EML_AWC.Time_ID
													) 
										AND EML_AWC2.[group] <> EML_AWC1.[group]
								) 
							AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,EML_AWC.Time_ID) 
                            AND EML_AWC.Time_ID AND Year(EML_AWC1.Date_of_injury) < Year(eml_awc.Time_ID) - 4
                            AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc) 
                    )
		,Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.EML_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'group' 
								AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit) 
								AND year(Time_Id) = Year(EML_AWC.Time_Id) 
								AND month(Time_Id)= month(EML_AWC.Time_Id)
					)
FROM    dbo.udf_EML_AWC_Generate_Time_ID('group','5-plus') eml_awc	

UNION ALL
SELECT  [Type] = 'account_manager'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '5-plus'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =(SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
                    FROM    EML_AWC EML_AWC1
                    WHERE   RTRIM([Account_Manager]) = RTRIM(EML_AWC.[Primary]) 
							AND NOT EXISTS
								(SELECT 1
								 FROM   EML_AWC EML_AWC2
								 WHERE  EML_AWC2.claim_no = EML_AWC1.claim_no 
										AND EML_AWC2.time_id =
													(SELECT max(time_Id)
													  FROM  EML_AWC EML_AWC3
													  WHERE EML_AWC3.claim_no = EML_AWC1.claim_no 
															AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) 
															AND EML_AWC.Time_ID
													) 
										AND EML_AWC2.[Account_Manager] <> EML_AWC1.[Account_Manager]
								) 
							AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,EML_AWC.Time_ID) 
                            AND EML_AWC.Time_ID AND Year(EML_AWC1.Date_of_injury) < Year(eml_awc.Time_ID) - 4
                            AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
                    )
		,Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.EML_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'account_manager' 
								AND RTRIM(Unit_Name) = RTRIM(EML_AWC.[Primary]) 
								AND year(Time_Id) = Year(EML_AWC.Time_Id) 
								AND month(Time_Id)= month(EML_AWC.Time_Id)
					)
FROM    dbo.udf_EML_AWC_Generate_Time_ID('account_manager','5-plus') eml_awc

UNION ALL
SELECT     [Type] = 'team'
, Unit = Unit
, [Primary] = RTRIM([Primary])
, WeeklyType = '5-plus'
, Time_Id
, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
, Actual =(SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
            FROM    EML_AWC EML_AWC1
            WHERE   Team = EML_AWC.Unit 
					AND [Group] = EML_AWC.[Primary]
					AND NOT EXISTS (SELECT  1
                                    FROM    EML_AWC EML_AWC2
                                    WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
											AND EML_AWC2.time_id =(SELECT   max(time_Id)
                                                                      FROM  EML_AWC EML_AWC3
                                                                      WHERE EML_AWC3.claim_no = EML_AWC1.claim_no 
																			AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID
																	) 
                                            AND EML_AWC2.[group] <> EML_AWC1.[group]
                                    ) 
                    AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID 
                    AND Year(EML_AWC1.Date_of_injury) < Year(eml_awc.Time_ID) - 4
                    AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
            )
, Projection =  (SELECT ISNULL(sum(Projection), 0)
					FROM	dbo.EML_AWC_Projections
                    WHERE   [Type] = '5-plus' AND Unit_Type = 'team' AND Unit_Name = EML_AWC.Unit
							 AND year(Time_Id) = Year(EML_AWC.Time_Id) 
							 AND month(Time_Id)= month(EML_AWC.Time_Id)
                )
FROM    dbo.udf_EML_AWC_Generate_Time_ID('team','5-plus') EML_AWC

UNION ALL
SELECT     [Type] = 'am_empl_size'
, Unit = Unit
, [Primary] = RTRIM([Primary])
, WeeklyType = '5-plus'
, Time_Id
, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
, Actual =(SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
            FROM    EML_AWC EML_AWC1
            WHERE   Empl_Size = EML_AWC.Unit
					AND [Account_Manager] = EML_AWC.[Primary]
					AND NOT EXISTS (SELECT  1
                                    FROM    EML_AWC EML_AWC2
                                    WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
											AND EML_AWC2.time_id =(SELECT   max(time_Id)
                                                                      FROM  EML_AWC EML_AWC3
                                                                      WHERE EML_AWC3.claim_no = EML_AWC1.claim_no 
																			AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID
																	) 
                                            AND EML_AWC2.[Account_Manager] <> EML_AWC1.[Account_Manager]
                                    ) 
                    AND EML_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID 
                    AND Year(EML_AWC1.Date_of_injury) < Year(eml_awc.Time_ID) - 4
                    AND EML_AWC.Time_ID <= (select MAX(Time_ID) from eml_awc)
            )
, Projection =  (SELECT ISNULL(sum(Projection), 0)
					FROM	dbo.EML_AWC_Projections
                    WHERE   [Type] = '5-plus' AND Unit_Type = 'am_empl_size' AND Unit_Name = EML_AWC.Unit
							 AND year(Time_Id) = Year(EML_AWC.Time_Id) 
							 AND month(Time_Id)= month(EML_AWC.Time_Id)
                )
FROM    dbo.udf_EML_AWC_Generate_Time_ID('am_empl_size','5-plus') EML_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Weekly_Open_5_Plus.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Whole_EML.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Whole_EML')
	DROP VIEW [dbo].[uv_EML_AWC_Whole_EML]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Whole_EML] 
AS
	-----EML------
	SELECT  [UnitType] = 'EML'
			,Unit = 'EML'
			,[Primary] = 'EML'
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = 
				isnull(
						(SELECT     COUNT(DISTINCT EML_AWC1.claim_no)
							FROM    EML_AWC EML_AWC1
							WHERE   EML_AWC1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM  EML_AWC))						
									AND year(Date_of_Injury) = Year(EML_AWC.Transaction_Year))
					, 0)
	FROM      dbo.udf_Whole_EML_Generate_Years('eml')  EML_AWC

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'EML'
			,Unit = 'EML'
			,[Primary] = 'EML'
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
					isnull(
						(SELECT top 1 Projection
							FROM   dbo.EML_AWC_Projections
							WHERE  [Type] = 'Whole-EML' AND Unit_Type = 'EML' 
									AND RTRIM(Unit_Name) = 'EML'
									AND Time_Id = DATEADD(month,- 1,EML_AWC.Transaction_Year) 
							ORDER BY time_id DESC									
						)
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('eml') EML_AWC
	-----End EML------
	
	-----Employer size------
	UNION ALL
	SELECT  [UnitType] = 'employer_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT EML_AWC1.claim_no)
				  FROM         EML_AWC EML_AWC1
				  WHERE     RTRIM(Empl_Size) = RTRIM(EML_AWC.[Primary]) 
							AND EML_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  EML_AWC)) 
							AND year(Date_of_Injury) = Year(EML_AWC.Transaction_Year))
				, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('employer_size')   EML_AWC

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'employer_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT top 1 Projection
				  FROM   dbo.EML_AWC_Projections
				  WHERE [Type] = 'Whole-EML' AND Unit_Type = 'employer_size' 
						AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit) 
						AND Time_Id = DATEADD(month,- 1,EML_AWC.Transaction_Year) 
				  ORDER BY time_id DESC	
				)
				, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('employer_size')  EML_AWC	
	-----End Employer size------

	-----Group------
	UNION ALL
	SELECT	[UnitType] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
					  FROM  EML_AWC EML_AWC1
					  WHERE RTRIM([Group]) = RTRIM(EML_AWC.[Primary]) 
							AND EML_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT     max(time_id) FROM EML_AWC)) 
							AND year(Date_of_Injury) = Year(EML_AWC.Transaction_Year))
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('group') EML_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year) 
			,[Type] = 'Projection' 
			,No_of_Active_Weekly_Claims = isnull(
					(SELECT     top 1 Projection
						FROM    dbo.EML_AWC_Projections
						WHERE   [Type] = 'Whole-EML' AND Unit_Type = 'group' 
								AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit) 
								AND Time_Id = DATEADD(month,- 1,EML_AWC.Transaction_Year) 
						ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('group') EML_AWC	
	-----End Group------	
	
	-----Account manager------
	UNION ALL
	SELECT	[UnitType] = 'account_manager'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
					  FROM  EML_AWC EML_AWC1
					  WHERE RTRIM([Account_Manager]) = RTRIM(EML_AWC.[Primary]) 
							AND EML_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT     max(time_id) FROM EML_AWC)) 
							AND year(Date_of_Injury) = Year(EML_AWC.Transaction_Year))
					, 0)
	FROM      dbo.udf_Whole_EML_Generate_Years('account_manager')  EML_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'account_manager'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year) 
			,[Type] = 'Projection' 
			,No_of_Active_Weekly_Claims = isnull(
					(SELECT     top 1 Projection
						FROM    dbo.EML_AWC_Projections
						WHERE   [Type] = 'Whole-EML' AND Unit_Type = 'account_manager' 
								AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit) 
								AND Time_Id = DATEADD(month,- 1,EML_AWC.Transaction_Year) 
						ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('account_manager') EML_AWC
	-----End Account manager------	
	
	---Team---
	UNION ALL
	SELECT  [UnitType] = 'team'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
					  FROM  EML_AWC EML_AWC1
					  WHERE RTRIM([Group]) = RTRIM(EML_AWC.[Primary]) AND RTRIM(Team) = RTRIM(EML_AWC.Unit)
					   AND EML_AWC1.time_id >= dateadd(mm, - 2,	(SELECT max(time_id) FROM EML_AWC)) 
							AND year(Date_of_Injury) = Year(EML_AWC.Transaction_Year))
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('team') EML_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'team'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.EML_AWC_Projections
					  WHERE [Type] = 'Whole-EML' AND Unit_Type = 'team' 
								AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit)
								AND Time_Id = DATEADD(month,- 1,EML_AWC.Transaction_Year) 
					  ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('team') EML_AWC
	
	---AM_EMPL_SIZE---
	UNION ALL
	SELECT  [UnitType] = 'am_empl_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT EML_AWC1.claim_no)
					  FROM  EML_AWC EML_AWC1
					  WHERE RTRIM(Account_Manager) = RTRIM(EML_AWC.[Primary]) 
					  AND RTRIM(Empl_Size) = RTRIM(EML_AWC.Unit) 
					  AND EML_AWC1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM EML_AWC)) 
							AND year(Date_of_Injury) = Year(EML_AWC.Transaction_Year))
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('am_empl_size')  EML_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'am_empl_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.EML_AWC_Projections
					  WHERE [Type] = 'Whole-EML' AND Unit_Type = 'am_empl_size' 
								AND RTRIM(Unit_Name) = RTRIM(EML_AWC.Unit)
								AND Time_Id = DATEADD(month,- 1,EML_AWC.Transaction_Year) 
					  ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_EML_Generate_Years('am_empl_size') EML_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Whole_EML.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_CPR_Weekly_Open.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_CPR_Weekly_Open')
	DROP VIEW [dbo].[uv_EML_CPR_Weekly_Open]
GO
CREATE VIEW [dbo].[uv_EML_CPR_Weekly_Open]
AS
	WITH temp AS
	(		
		-- For monthly in one year
		SELECT	DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0) AS Start_Date
				,DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()) + 1, 0)) + '23:59' AS End_Date
				,13 AS iMonth
		UNION ALL
		SELECT DATEADD(m, -1, Start_Date), DATEADD(d, -1, Start_Date) + '23:59', iMonth - 1
		FROM temp WHERE End_Date > DATEADD(m, -11, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
	)
	
	--EML--
	select  [UnitType] = 'WCNSW'
			,Unit = 'WCNSW'
			,[Primary] = 'WCNSW'
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y')
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	--End EML--
	
	UNION ALL
	
	--Employer size--
	select  [UnitType] = 'employer_size'
			,Unit = tmp_value.Value
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join 
	(
		SELECT DISTINCT Value
			FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
			WHERE Value <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Employer size--
	
	UNION ALL
	
	--Group--
	select  [UnitType] = 'group'
			,Unit = tmp_value.Value
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'group', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join 
	(
		SELECT DISTINCT Value
			FROM [dbo].[udf_CPR_Overall]('EML', 'group', 0)
			WHERE Value <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Group--
	
	UNION ALL
	
	--Account manager--
	select  [UnitType] = 'account_manager'
			,Unit = tmp_value.Value
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join 
	(
		SELECT DISTINCT Value
			FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
			WHERE Value <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Account manager--
	
	UNION ALL
	
	--Team--
	select  [UnitType] = 'team'
			,Unit = tmp_value.SubValue
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'group', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join
	(
		SELECT DISTINCT SubValue, Value
			FROM [dbo].[udf_CPR_Overall]('EML', 'group', 0)
			WHERE Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue, Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Team--
	
	UNION ALL
	
	--AM_EMPL_SIZE--
	select  [UnitType] = 'am_empl_size'
			,Unit = tmp_value.SubValue
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join
	(
		SELECT DISTINCT SubValue, Value
			FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
			WHERE Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue, Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End AM_EMPL_SIZE--
	
	UNION ALL
	
	--Claim Officer
	select  [UnitType] = 'claim_officer'
			,Unit = tmp_value.SubValue2
			,[Primary] = tmp_value.SubValue
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('EML', 'group', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and SubValue = tmp_value.SubValue
											and SubValue2 = tmp_value.SubValue2)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and SubValue = tmp_value.SubValue
											and SubValue2 = tmp_value.SubValue2)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and SubValue = tmp_value.SubValue
											and SubValue2 = tmp_value.SubValue2)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join
	(
		SELECT DISTINCT SubValue2, SubValue
			FROM [dbo].[udf_CPR_Overall]('EML', 'group', 0)
			WHERE SubValue <> '' and SubValue2 <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue2, SubValue
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Claim Officer
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_CPR_Weekly_Open.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current')
	DROP VIEW [dbo].[uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current]
GO
CREATE VIEW [dbo].[uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current] 
AS
	--Employer size---	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='employer_size'
			,'WCNSW' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','','EML',NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
	union all
	select top 100000000 Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='employer_size'
			,rtrim(EMPL_SIZE) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','employer_size',rtrim(EMPL_SIZE),NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by EMPL_SIZE,Measure,Remuneration_Start, Remuneration_End
	order by EMPL_SIZE
	---Group---
	union all
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,'WCNSW' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','','EML',NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
	union all
	select top 100000000 Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,rtrim([Group]) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','group',rtrim([Group]),NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Measure,Remuneration_Start, Remuneration_End	
	order by [Group]
	---Account manager---
	union all
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='account_manager'
			,'WCNSW' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','','EML',NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
	union all
	select top 100000000 Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='account_manager'
			,rtrim([Account_Manager]) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','account_manager',rtrim([Account_Manager]),NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Account_Manager]) is not null

	group by [Account_Manager],Measure,Remuneration_Start, Remuneration_End
	order by [Account_Manager]
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous')
	DROP VIEW [dbo].[uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous]
GO
CREATE VIEW [dbo].[uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous] 
AS
	--Employer size---
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='employer_size'
			,'WCNSW' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from EML_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.EML_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='employer_size'
			,rtrim(EMPL_SIZE) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from EML_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.EML_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by EMPL_SIZE,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	
	
	
	---Group---
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,'WCNSW' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from EML_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.EML_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,rtrim([Group]) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from EML_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.EML_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	

	---Account manager---
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='account_manager'
			,'WCNSW' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from EML_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.EML_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='account_manager'
			,rtrim([Account_Manager]) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from EML_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.EML_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Account_Manager]) is not null

	group by [Account_Manager],Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Rolling_Month_1.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_EML_RTW_Agency_Group_Rolling_Month_1
IF EXISTS(select * FROM sys.views where name = 'uv_EML_RTW_Agency_Group_Rolling_Month_1')
	DROP VIEW [dbo].[uv_EML_RTW_Agency_Group_Rolling_Month_1]
GO
CREATE VIEW [dbo].[uv_EML_RTW_Agency_Group_Rolling_Month_1] 
AS

SELECT     rtrim(uv.[Group]) as EmployerSize_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],NULL,uv.Measure)
						
FROM         dbo.EML_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
GROUP BY  uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     rtrim(uv.EMPL_SIZE) as EmployerSize_Group
		   ,[Type] = 'employer_size' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','employer_size',uv.EMPL_SIZE,NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','employer_size',uv.EMPL_SIZE,NULL,uv.Measure)					 
FROM         dbo.EML_RTW uv 
			where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
GROUP BY  uv.EMPL_SIZE, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     rtrim(uv.Account_Manager) as EmployerSize_Group
		   ,[Type] = 'account_manager' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',uv.Account_Manager,NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','account_manager',uv.Account_Manager,NULL,uv.Measure)					 
FROM         dbo.EML_RTW uv 
			where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
			and rtrim(uv.Account_Manager) is not null
GROUP BY  uv.Account_Manager, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL
SELECT     'WCNSW' AS EmployerSize_Group
			, [Type] = 'group'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			, Measure AS Measure_months
			, SUM(t.LT) AS LT
            , SUM(t.WGT) AS WGT
			, SUM(LT) / SUM(WGT) AS AVGDURN			
			, [Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(t.Remuneration_End,'target','group','EML',NULL,t.Measure)
			, Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(t.Remuneration_End,'base','group','EML',NULL,t.Measure)

FROM         EML_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 0
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     'WCNSW' AS EmployerSize_Group
			, [Type] = 'employer_size'
			,t.Remuneration_Start
			,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			, Measure AS Measure_months
			, SUM(t.LT) AS LT
            , SUM(t.WGT) AS WGT
			, SUM(LT) / SUM(WGT) AS AVGDURN
			
			, [Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(t.Remuneration_End,'target','employer_size','EML',NULL,t.Measure)
			, Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(t.Remuneration_End,'base','employer_size','EML',NULL,t.Measure)

FROM         EML_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 0
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     'WCNSW' AS EmployerSize_Group
			, [Type] = 'account_manager'
			,t.Remuneration_Start
			,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			, Measure AS Measure_months
			, SUM(t.LT) AS LT
            , SUM(t.WGT) AS WGT
			, SUM(LT) / SUM(WGT) AS AVGDURN
			
			, [Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(t.Remuneration_End,'target','account_manager','EML',NULL,t.Measure)
			, Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(t.Remuneration_End,'base','account_manager','EML',NULL,t.Measure)

FROM         EML_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 0
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Rolling_Month_1.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Rolling_Month_12.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_EML_RTW_Agency_Group_Rolling_Month_12
IF EXISTS(select * FROM sys.views where name = 'uv_EML_RTW_Agency_Group_Rolling_Month_12')
	DROP VIEW [dbo].[uv_EML_RTW_Agency_Group_Rolling_Month_12]
GO
CREATE VIEW [dbo].[uv_EML_RTW_Agency_Group_Rolling_Month_12] 
AS

SELECT    EmployerSize_Group = rtrim(uv.[Group])
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) 
          
          ,Measure_months = Measure 
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],NULL,uv.Measure)
						
FROM      dbo.EML_RTW uv 

WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
		  and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)

GROUP BY  uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     EmployerSize_Group = rtrim(uv.EMPL_SIZE)
		   ,[Type] = 'employer_size' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','employer_size',uv.EMPL_SIZE,NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','employer_size',uv.EMPL_SIZE,NULL,uv.Measure)					 
FROM         dbo.EML_RTW uv 
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
GROUP BY  uv.EMPL_SIZE, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     EmployerSize_Group = rtrim(uv.Account_Manager)
		   ,[Type] = 'account_manager' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',uv.Account_Manager,NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','account_manager',uv.Account_Manager,NULL,uv.Measure)					 
FROM         dbo.EML_RTW uv 
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
			and rtrim(uv.Account_Manager) is not null
GROUP BY  uv.Account_Manager, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL
SELECT     EmployerSize_Group ='WCNSW'
			,[Type] = 'group'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months = Measure
			,LT= SUM(t.LT)
            ,WGT= SUM(t.WGT)
			,AVGDURN= SUM(LT) / SUM(WGT)			
			,[Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(t.Remuneration_End,'target','group','EML',NULL,t.Measure)
			,Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(t.Remuneration_End,'base','group','EML',NULL,t.Measure)

FROM         EML_RTW t 
inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     EmployerSize_Group= 'WCNSW'
			,[Type] = 'employer_size'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			,Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months= Measure
			,LT = SUM(t.LT)  
            ,WGT =SUM(t.WGT)  
			,AVGDURN =SUM(LT) / SUM(WGT)  			
			,[Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(t.Remuneration_End,'target','employer_size','EML',NULL,t.Measure)
			,Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(t.Remuneration_End,'base','employer_size','EML',NULL,t.Measure)

FROM         EML_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     EmployerSize_Group= 'WCNSW'
			,[Type] = 'account_manager'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			,Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months= Measure
			,LT = SUM(t.LT)  
            ,WGT =SUM(t.WGT)  
			,AVGDURN =SUM(LT) / SUM(WGT)  			
			,[Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(t.Remuneration_End,'target','account_manager','EML',NULL,t.Measure)
			,Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(t.Remuneration_End,'base','account_manager','EML',NULL,t.Measure)

FROM         EML_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Rolling_Month_12.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Raw_Data.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_RTW_Raw_Data')
	DROP VIEW [dbo].[uv_EML_RTW_Raw_Data]
GO
CREATE VIEW [dbo].[uv_EML_RTW_Raw_Data] 
AS
	SELECT  Claim_Closed_flag
			,Remuneration_Start
			,Remuneration_End
			,Measure_months = Measure
			,[Group] = RTRIM([group])
			,Team
			,Sub_Category = RTRIM(Sub_Category)
			,Case_manager
			,AgencyName = RTRIM(AgencyName)
			,rtw.Claim_no
			,DTE_OF_INJURY 
			,rtw.POLICY_NO
			,LT= ROUND(LT, 2)
			,WGT=ROUND(WGT, 2)
			,EMPL_SIZE
			,Weeks_from_date_of_injury= DATEDIFF(week, DTE_OF_INJURY, Remuneration_End)
			,Weeks_paid= ROUND(Weeks_paid, 2)
			,Stress
			,Liability_Status
			,cost_code
			,cost_code2
			,Cert_Type
			,Med_cert_From
			,Med_cert_To
			,rtw.Account_Manager
			,rtw.Cell_no
			,rtw.Portfolio
	FROM dbo.EML_RTW rtw 
	WHERE remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		 AND  DATEDIFF(month, Remuneration_Start, Remuneration_End) + 1 =12  

GO 
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Raw_Data.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current')
	DROP VIEW [dbo].[uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current]
GO
CREATE VIEW [dbo].[uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current] 
AS
	---Group---			
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,rtrim([Group]) as EmployerSize_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','group',rtrim([Group]),rtrim(Team),Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Team,Measure,Remuneration_Start, Remuneration_End
	
	--Account Manager--
	union all
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='account_manager'
			,rtrim([Account_Manager]) as EmployerSize_Group
			,rtrim(EMPL_SIZE) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','account_manager',rtrim([Account_Manager]),rtrim(EMPL_SIZE),Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Account_Manager])is not null

	group by [Account_Manager],EMPL_SIZE,Measure,Remuneration_Start, Remuneration_End
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous')
	DROP VIEW [dbo].[uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous]
GO
CREATE VIEW [dbo].[uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous] 
AS	
	---Group---	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,rtrim([Group]) as EmployerSize_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN
	from EML_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.EML_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Team,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	---Account manager---	
	union all 
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='account_manager'
			,rtrim([Account_Manager]) as EmployerSize_Group
			,rtrim(EMPL_SIZE) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN
	from EML_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.EML_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Account_Manager]) is not null

	group by [Account_Manager],EMPL_SIZE,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Team_Sub_Rolling_Month_1.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_EML_RTW_Team_Sub_Rolling_Month_1
IF EXISTS(select * FROM sys.views where name = 'uv_EML_RTW_Team_Sub_Rolling_Month_1')
	DROP VIEW [dbo].[uv_EML_RTW_Team_Sub_Rolling_Month_1]
GO
CREATE VIEW [dbo].[uv_EML_RTW_Team_Sub_Rolling_Month_1] 
AS

SELECT     rtrim(uv.Team) as Team_Sub
			, uv.[Group] as EmployerSize_Group
			,[Type] = 'group'
			,uv.Remuneration_Start
			,uv.Remuneration_End
			,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
			,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
			,[Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],uv.Team,uv.Measure)									
			, Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],uv.Team,uv.Measure)
						
FROM         dbo.EML_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
GROUP BY uv.Team, uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

union all

SELECT     rtrim(uv.EMPL_SIZE) as Team_Sub
			, uv.[Account_Manager] as EmployerSize_Group
			,[Type] = 'account_manager'
			,uv.Remuneration_Start
			,uv.Remuneration_End
			,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
			,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
			,[Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',uv.[Account_Manager],uv.EMPL_SIZE,uv.Measure)									
			, Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','account_manager',uv.[Account_Manager],uv.EMPL_SIZE,uv.Measure)
						
FROM         dbo.EML_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		and uv.[Account_Manager] is not null
GROUP BY uv.EMPL_SIZE, uv.[Account_Manager], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Team_Sub_Rolling_Month_1.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Team_Sub_Rolling_Month_12.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_EML_RTW_Team_Sub_Rolling_Month_12
IF EXISTS(select * FROM sys.views where name = 'uv_EML_RTW_Team_Sub_Rolling_Month_12')
	DROP VIEW [dbo].[uv_EML_RTW_Team_Sub_Rolling_Month_12]
GO
CREATE VIEW [dbo].[uv_EML_RTW_Team_Sub_Rolling_Month_12] 
AS
SELECT     rtrim(uv.Team) as Team_Sub
		  ,rtrim(uv.[Group]) as  EmployerSize_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration        
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],uv.Team,uv.Measure)									
		  , Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],uv.Team,uv.Measure)
						
FROM         dbo.EML_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
GROUP BY uv.Team, uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

union all

SELECT     rtrim(uv.EMPL_SIZE) as Team_Sub
		  ,rtrim(uv.Account_Manager) as  EmployerSize_Group
		  ,[Type] = 'account_manager'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration        
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',uv.[Account_Manager],uv.EMPL_SIZE,uv.Measure)									
		  , Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','account_manager',uv.[Account_Manager],uv.EMPL_SIZE,uv.Measure)
						
FROM         dbo.EML_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
	  and rtrim(uv.Account_Manager) is not null
GROUP BY uv.EMPL_SIZE, uv.[Account_Manager], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Team_Sub_Rolling_Month_12.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Raw_Data.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_AWC_Raw_Data')
	DROP VIEW [dbo].[uv_HEM_AWC_Raw_Data]
GO
CREATE VIEW [dbo].[uv_HEM_AWC_Raw_Data] 
AS
SELECT    Time_ID
		, Claim_no
		, Team
		, [Group] = RTRIM([Group])
		, Sub_Category = RTRIM(Sub_Category)
		, Employer_Size = RTRIM(Empl_Size)
		, Date_of_Injury
		,Cert_Type
		,Med_cert_From
		,Med_cert_To
		,Account_Manager
		,Portfolio
		,Cell_no
FROM    dbo.HEM_AWC
WHERE    (Time_ID >= DATEADD(mm, - 2,DATEADD(yy, DATEDIFF(yy,0,GETDATE()), 0)))
                          
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Raw_Data.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Weekly_Open_1_2.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_AWC_Weekly_Open_1_2')
	DROP VIEW [dbo].[uv_HEM_AWC_Weekly_Open_1_2]
GO
CREATE VIEW [dbo].[uv_HEM_AWC_Weekly_Open_1_2] 
AS	
	---HEM---
	SELECT  [Type] = 'HEM'
			,Unit = 'HEM'
			,[Primary] = 'HEM'
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2)
			,Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
						FROM	HEM_AWC HEM_AWC1
						WHERE   HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
								AND Year(HEM_AWC1.Date_of_injury) = Year(HEM_awc.Time_ID) - 1
									AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)							
						)
			,Projection =  (SELECT ISNULL(sum(Projection), 0)
								FROM	dbo.HEM_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'hem' 										
										AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
										AND month(Time_Id)= month(HEM_AWC.Time_Id))
	FROM    dbo.udf_HEM_AWC_Generate_Time_ID('hem','1-2') HEM_AWC
	
	UNION ALL
	---Portfolio---
	SELECT  [Type] = 'portfolio'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2)
			,Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
						FROM	HEM_AWC HEM_AWC1
						WHERE   RTRIM(Portfolio) = RTRIM(HEM_AWC.[Primary]) 
								AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
								AND Year(HEM_AWC1.Date_of_injury) = Year(HEM_awc.Time_ID) - 1
									AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)								
						)
			,Projection =  (SELECT ISNULL(sum(Projection), 0)
								FROM	dbo.HEM_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'portfolio' 
										AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.[Primary]) 
										AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
										AND month(Time_Id)= month(HEM_AWC.Time_Id))
	FROM    dbo.udf_HEM_AWC_Generate_Time_ID('portfolio','1-2') HEM_AWC
	
	--Portfolio Hotel Summary--
	UNION ALL
	SELECT  [Type] = 'portfolio'
			,Unit = 'Hotel'
			,[Primary] = 'Hotel'
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2)
			,Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
						FROM	HEM_AWC HEM_AWC1
						WHERE   RTRIM(Portfolio) in ('Accommodation','Pubs, Taverns and Bars')
								AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
								AND Year(HEM_AWC1.Date_of_injury) = Year(HEM_awc.Time_ID) - 1
									AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)								
						)
			,Projection =  (SELECT ISNULL(sum(Projection), 0)
								FROM	dbo.HEM_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'portfolio' 
										AND RTRIM(Unit_Name) in ('Accommodation','Pubs, Taverns and Bars')
										AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
										AND month(Time_Id)= month(HEM_AWC.Time_Id))
	FROM    dbo.udf_HEM_AWC_Generate_Time_ID('portfolio','1-2') HEM_AWC
	WHERE   RTRIM([Primary]) = 'Accommodation'
	
	---Group---
	UNION ALL
	SELECT  [Type] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 						  
			,Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
						FROM	HEM_AWC HEM_AWC1
						WHERE   RTRIM([Group]) = RTRIM(HEM_AWC.Unit) 
								AND NOT EXISTS(SELECT   1
												FROM	HEM_AWC HEM_AWC2
												WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
														AND HEM_AWC2.time_id =(SELECT   max(time_Id)
																				FROM    HEM_AWC HEM_AWC3
																				WHERE   HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																						AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND  HEM_AWC.Time_ID
																				) 
														AND HEM_AWC2.[group] <> HEM_AWC1.[group]
												)
								AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
								AND Year(HEM_AWC1.Date_of_injury) = Year(HEM_awc.Time_ID) - 1
								AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)								
						)
			,Projection =(SELECT	ISNULL(sum(Projection), 0)
							FROM    dbo.HEM_AWC_Projections
							WHERE   [Type] = '1-2' AND Unit_Type = 'group' 
									AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
									AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
									AND month(Time_Id)= month(HEM_AWC.Time_Id)
							)
	FROM	dbo.udf_HEM_AWC_Generate_Time_ID('group','1-2') HEM_AWC
	
	---Account manager---
	UNION ALL
	SELECT  [Type] = 'account_manager'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 						  
			,Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
						FROM	HEM_AWC HEM_AWC1
						WHERE   RTRIM([Account_Manager]) = RTRIM(HEM_AWC.[Primary]) 
								AND NOT EXISTS(SELECT   1
												FROM	HEM_AWC HEM_AWC2
												WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
														AND HEM_AWC2.time_id =(SELECT   max(time_Id)
																				FROM    HEM_AWC HEM_AWC3
																				WHERE   HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																						AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND  HEM_AWC.Time_ID
																				) 
														AND HEM_AWC2.[Account_Manager] <> HEM_AWC1.[Account_Manager]
												)
								AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
								AND Year(HEM_AWC1.Date_of_injury) = Year(HEM_awc.Time_ID) - 1
								AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)							
						)
			,Projection =(SELECT	ISNULL(sum(Projection), 0)
							FROM    dbo.HEM_AWC_Projections
							WHERE   [Type] = '1-2' AND Unit_Type = 'account_manager' 
									AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.[Primary]) 
									AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
									AND month(Time_Id)= month(HEM_AWC.Time_Id)
							)
	FROM	dbo.udf_HEM_AWC_Generate_Time_ID('account_manager','1-2') HEM_AWC
	
	---Team---
	UNION ALL
	SELECT  [Type] = 'team'
			,Unit = Unit
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 						
			,Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
								FROM	HEM_AWC HEM_AWC1
								WHERE   Team = HEM_AWC.Unit 
										AND [Group] = HEM_AWC.[Primary]
										AND NOT EXISTS(SELECT   1
														FROM	HEM_AWC HEM_AWC2
														WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
																AND HEM_AWC2.time_id =
																	(SELECT max(time_Id)
																	  FROM  HEM_AWC HEM_AWC3
																	  WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																			AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID)
																AND HEM_AWC2.[group] <> HEM_AWC1.[group]
														) 
										AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID
										AND Year(HEM_AWC1.Date_of_injury) = Year(HEM_awc.Time_ID) - 1
										AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
						)
			,Projection = (SELECT   ISNULL(sum(Projection), 0)
								FROM	dbo.HEM_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'team' 
										AND Unit_Name = HEM_AWC.Unit 
										AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
										AND month(Time_Id)= month(HEM_AWC.Time_Id))
	FROM    dbo.udf_HEM_AWC_Generate_Time_ID('team','1-2') HEM_AWC
	
	---AM_EMPL_Size---
	UNION ALL
	SELECT  [Type] = 'am_empl_size'
			,Unit = Unit
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 						
			,Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
								FROM	HEM_AWC HEM_AWC1
								WHERE   Empl_Size = HEM_AWC.Unit
										AND Account_Manager = HEM_AWC.[Primary]
										AND NOT EXISTS(SELECT   1
														FROM	HEM_AWC HEM_AWC2
														WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
																AND HEM_AWC2.time_id =
																	(SELECT max(time_Id)
																	  FROM  HEM_AWC HEM_AWC3
																	  WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																			AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID)
																AND HEM_AWC2.[Account_Manager] <> HEM_AWC1.[Account_Manager]
														) 
										AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
										AND Year(HEM_AWC1.Date_of_injury) = Year(HEM_awc.Time_ID) - 1 
										AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
						)
			,Projection = (SELECT   ISNULL(sum(Projection), 0)
								FROM	dbo.HEM_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'am_empl_size' 
										AND Unit_Name = HEM_AWC.Unit 
										AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
										AND month(Time_Id)= month(HEM_AWC.Time_Id))
	FROM    dbo.udf_HEM_AWC_Generate_Time_ID('am_empl_size','1-2') HEM_AWC
	
	---Portfolio_EMPL_Size---
	UNION ALL
	SELECT  [Type] = 'portfolio_empl_size'
			,Unit = Unit
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 						
			,Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
								FROM	HEM_AWC HEM_AWC1
								WHERE   Empl_Size = HEM_AWC.Unit
										and Portfolio = HEM_AWC.[Primary]
										AND NOT EXISTS(SELECT   1
														FROM	HEM_AWC HEM_AWC2
														WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
																AND HEM_AWC2.time_id =
																	(SELECT max(time_Id)
																	  FROM  HEM_AWC HEM_AWC3
																	  WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																			AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID)
																AND HEM_AWC2.[Portfolio] <> HEM_AWC1.[Portfolio]
														) 
										AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
										AND Year(HEM_AWC1.Date_of_injury) = Year(HEM_awc.Time_ID) - 1
										AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
						)
			,Projection = (SELECT   ISNULL(sum(Projection), 0)
								FROM	dbo.HEM_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'portfolio_empl_size' 
										AND Unit_Name = HEM_AWC.Unit 
										AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
										AND month(Time_Id)= month(HEM_AWC.Time_Id))
	FROM    udf_HEM_AWC_Generate_Time_ID('portfolio_empl_size','1-2') HEM_AWC
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Weekly_Open_1_2.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Weekly_Open_3_5.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_AWC_Weekly_Open_3_5')
	DROP VIEW [dbo].[uv_HEM_AWC_Weekly_Open_3_5]
GO
CREATE VIEW [dbo].[uv_HEM_AWC_Weekly_Open_3_5] 
AS	
--HEM--
SELECT  [Type] = 'HEM'
		, Unit = 'HEM'
		, [Primary] = 'HEM'
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year,Time_Id), 2) 
        , Actual =
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
							AND Year(HEM_AWC1.Date_of_injury) BETWEEN Year(HEM_awc.Time_ID) - 4 AND Year(HEM_awc.Time_ID) - 2
							AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
                   )
        , Projection =
                  (SELECT ISNULL(sum(Projection), 0)
                    FROM	dbo.HEM_AWC_Projections
                    WHERE   [Type] = '3-5' AND Unit_Type = 'hem' 							
							AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
							AND month(Time_Id) = month(HEM_AWC.Time_Id)
                    )
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('hem','3-5') HEM_AWC

--Portfolio--
UNION ALL

SELECT  [Type] = 'portfolio'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year,Time_Id), 2) 
        , Actual =
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   RTRIM(Portfolio) = RTRIM(HEM_AWC.Unit) 
							AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
							AND Year(HEM_AWC1.Date_of_injury) BETWEEN Year(HEM_awc.Time_ID) - 4 AND Year(HEM_awc.Time_ID) - 2
							AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
                   )
        , Projection =
                  (SELECT ISNULL(sum(Projection), 0)
                    FROM	dbo.HEM_AWC_Projections
                    WHERE   [Type] = '3-5' AND Unit_Type = 'portfolio' 
							AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
							AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
							AND month(Time_Id) = month(HEM_AWC.Time_Id)
                    )
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('portfolio','3-5') HEM_AWC

--Portfolio Hotel Summay--
UNION ALL
SELECT  [Type] = 'portfolio'
		, Unit = 'Hotel'
		, [Primary] = 'Hotel'
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year,Time_Id), 2) 
        , Actual =
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   RTRIM(Portfolio) in ('Accommodation','Pubs, Taverns and Bars')
							AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
							AND Year(HEM_AWC1.Date_of_injury) BETWEEN Year(HEM_awc.Time_ID) - 4 AND Year(HEM_awc.Time_ID) - 2
							AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
                   )
        , Projection =
                  (SELECT ISNULL(sum(Projection), 0)
                    FROM	dbo.HEM_AWC_Projections
                    WHERE   [Type] = '3-5' AND Unit_Type = 'portfolio' 
							AND RTRIM(Unit_Name) in ('Accommodation','Pubs, Taverns and Bars')
							AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
							AND month(Time_Id) = month(HEM_AWC.Time_Id)
                    )
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('portfolio','3-5') HEM_AWC
WHERE     RTRIM(Unit) = 'Accommodation'

UNION ALL
SELECT  [Type] = 'group'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year =LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        , Actual =
                  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   RTRIM([Group]) = RTRIM(HEM_AWC.Unit) 
							AND NOT EXISTS (SELECT     1
											FROM    HEM_AWC HEM_AWC2
											WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
													AND HEM_AWC2.time_id =
                                                        (SELECT max(time_Id)
                                                          FROM  HEM_AWC HEM_AWC3
                                                          WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																	AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
																	AND HEM_AWC.Time_ID
														) 
													AND HEM_AWC2.[group] <> HEM_AWC1.[group]
											) 
                            AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
                            AND HEM_AWC.Time_ID AND Year(HEM_AWC1.Date_of_injury) BETWEEN Year(HEM_awc.Time_ID) - 4 AND Year(HEM_awc.Time_ID) - 2
                            AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC) 
                    )
        , Projection =
                          (SELECT   ISNULL(sum(Projection), 0)
                            FROM    dbo.HEM_AWC_Projections
                            WHERE   [Type] = '3-5' AND Unit_Type = 'group' 
									AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
									AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
									AND month(Time_Id)= month(HEM_AWC.Time_Id)
							)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('group','3-5') HEM_AWC

UNION ALL
SELECT  [Type] = 'account_manager'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '3-5'
		, Time_Id
		, Month_Year =LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        , Actual =
                  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   RTRIM([Account_Manager]) = RTRIM(HEM_AWC.Unit) 
							AND NOT EXISTS (SELECT     1
											FROM    HEM_AWC HEM_AWC2
											WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
													AND HEM_AWC2.time_id =
                                                        (SELECT max(time_Id)
                                                          FROM  HEM_AWC HEM_AWC3
                                                          WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																	AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
																	AND HEM_AWC.Time_ID
														) 
													AND HEM_AWC2.[Account_Manager] <> HEM_AWC1.[Account_Manager]
											) 
                            AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
                            AND HEM_AWC.Time_ID AND Year(HEM_AWC1.Date_of_injury) BETWEEN Year(HEM_awc.Time_ID) - 4 AND Year(HEM_awc.Time_ID) - 2 
                            AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
                    )
        , Projection =
                          (SELECT   ISNULL(sum(Projection), 0)
                            FROM    dbo.HEM_AWC_Projections
                            WHERE   [Type] = '3-5' AND Unit_Type = 'account_manager' 
									AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
									AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
									AND month(Time_Id)= month(HEM_AWC.Time_Id)
							)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('account_manager','3-5') HEM_AWC

UNION ALL
SELECT  [Type] = 'team'
		,Unit = Unit
		,[Primary] = RTRIM([Primary])
		,WeeklyType = '3-5'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =
                  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
						FROM	HEM_AWC HEM_AWC1
						WHERE   Team = HEM_AWC.Unit 
								AND [Group] = HEM_AWC.[Primary]
								AND NOT EXISTS  (SELECT  1
                                                 FROM   HEM_AWC HEM_AWC2
                                                 WHERE  HEM_AWC2.claim_no = HEM_AWC1.claim_no 
														AND HEM_AWC2.time_id =(SELECT	max(time_Id)
																				FROM    HEM_AWC HEM_AWC3
																				WHERE   HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																						AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID
																				) 
														AND HEM_AWC2.[group] <> HEM_AWC1.[group]
												) 
								AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
                                AND Year(HEM_AWC1.Date_of_injury) BETWEEN Year(HEM_awc.Time_ID) - 4 AND Year(HEM_awc.Time_ID) - 2 
                                AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
                    )
        ,Projection =
                  (SELECT   ISNULL(sum(Projection), 0)
					FROM    dbo.HEM_AWC_Projections
					WHERE   [Type] = '3-5' AND Unit_Type = 'team' 
							AND Unit_Name = HEM_AWC.Unit
							AND year(Time_Id)  = Year(HEM_AWC.Time_Id) 
							AND month(Time_Id) = month(HEM_AWC.Time_Id)
					)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('team','3-5') HEM_AWC

UNION ALL
SELECT  [Type] = 'am_empl_size'
		,Unit = Unit
		,[Primary] = RTRIM([Primary])
		,WeeklyType = '3-5'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =
                  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
						FROM	HEM_AWC HEM_AWC1
						WHERE   Empl_Size = HEM_AWC.Unit
								AND [Account_Manager] = HEM_AWC.[Primary]
								AND NOT EXISTS  (SELECT  1
                                                 FROM   HEM_AWC HEM_AWC2
                                                 WHERE  HEM_AWC2.claim_no = HEM_AWC1.claim_no 
														AND HEM_AWC2.time_id =(SELECT	max(time_Id)
																				FROM    HEM_AWC HEM_AWC3
																				WHERE   HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																						AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID
																				) 
														AND HEM_AWC2.[Account_Manager] <> HEM_AWC1.[Account_Manager]
												) 
								AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
                                AND Year(HEM_AWC1.Date_of_injury) BETWEEN Year(HEM_awc.Time_ID) - 4 AND Year(HEM_awc.Time_ID) - 2
                                AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
                    )
        ,Projection =
                  (SELECT   ISNULL(sum(Projection), 0)
					FROM    dbo.HEM_AWC_Projections
					WHERE   [Type] = '3-5' AND Unit_Type = 'am_empl_size' 
							AND Unit_Name = HEM_AWC.Unit 
							AND year(Time_Id)  = Year(HEM_AWC.Time_Id) 
							AND month(Time_Id) = month(HEM_AWC.Time_Id)
					)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('am_empl_size','3-5') HEM_AWC

UNION ALL
SELECT  [Type] = 'portfolio_empl_size'
		,Unit = Unit
		,[Primary] = RTRIM([Primary])
		,WeeklyType = '3-5'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =
                  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
						FROM	HEM_AWC HEM_AWC1
						WHERE   Empl_Size = HEM_AWC.Unit
								AND [Portfolio] = HEM_AWC.[Primary]
								AND NOT EXISTS  (SELECT  1
                                                 FROM   HEM_AWC HEM_AWC2
                                                 WHERE  HEM_AWC2.claim_no = HEM_AWC1.claim_no 
														AND HEM_AWC2.time_id =(SELECT	max(time_Id)
																				FROM    HEM_AWC HEM_AWC3
																				WHERE   HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																						AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID
																				) 
														AND HEM_AWC2.[Portfolio] <> HEM_AWC1.[Portfolio]
												) 
								AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
                                AND Year(HEM_AWC1.Date_of_injury) BETWEEN Year(HEM_awc.Time_ID) - 4 AND Year(HEM_awc.Time_ID) - 2
                                AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
                    )
        ,Projection =
                  (SELECT   ISNULL(sum(Projection), 0)
					FROM    dbo.HEM_AWC_Projections
					WHERE   [Type] = '3-5' AND Unit_Type = 'portfolio_empl_size' 
							AND Unit_Name = HEM_AWC.Unit 
							AND year(Time_Id)  = Year(HEM_AWC.Time_Id) 
							AND month(Time_Id) = month(HEM_AWC.Time_Id)
					)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('portfolio_empl_size','3-5') HEM_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Weekly_Open_3_5.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Weekly_Open_5_Plus.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_AWC_Weekly_Open_5_Plus')
	DROP VIEW [dbo].[uv_HEM_AWC_Weekly_Open_5_Plus]
GO
CREATE VIEW [dbo].[uv_HEM_AWC_Weekly_Open_5_Plus] 
AS 
--HEM--
SELECT  [Type] = 'HEM'
		, Unit = 'HEM'
		, [Primary] ='HEM'
		, WeeklyType = '5-plus'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, 
                      Time_Id), 2) 
        , Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
										AND HEM_AWC.Time_ID 
							AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4 
							AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
					)
		, Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'hem' 								
								AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
								AND month(Time_Id)= month(HEM_AWC.Time_Id)
						)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('hem','5-plus')   HEM_AWC

--Portfolio Hotel Summay--
UNION ALL
SELECT  [Type] = 'portfolio'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '5-plus'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, 
                      Time_Id), 2) 
        , Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   RTRIM(Portfolio) = RTRIM(HEM_AWC.Unit) 
							AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
										AND HEM_AWC.Time_ID 
							AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4 
							AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
					)
		, Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'portfolio' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
								AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
								AND month(Time_Id)= month(HEM_AWC.Time_Id)
						)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('portfolio','5-plus')   HEM_AWC

--Portfolio Hotel Summay--
UNION ALL
SELECT  [Type] = 'portfolio'
		, Unit = 'Hotel'
		, [Primary] = 'Hotel'
		, WeeklyType = '5-plus'
		, Time_Id
		, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, 
                      Time_Id), 2) 
        , Actual = (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   RTRIM(Portfolio) in ('Accommodation','Pubs, Taverns and Bars')
							AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
										AND HEM_AWC.Time_ID 
							AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4
							AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
					)
		, Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'portfolio' 
								AND RTRIM(Unit_Name) in ('Accommodation','Pubs, Taverns and Bars')
								AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
								AND month(Time_Id)= month(HEM_AWC.Time_Id)
						)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('portfolio','5-plus')   HEM_AWC
WHERE     RTRIM(Unit) = 'Accommodation'
--end Portfolio Hotel Summay--

UNION ALL
SELECT  [Type] = 'group'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '5-plus'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =(SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   RTRIM([Group]) = RTRIM(HEM_AWC.Unit) 
							AND NOT EXISTS
								(SELECT 1
								 FROM   HEM_AWC HEM_AWC2
								 WHERE  HEM_AWC2.claim_no = HEM_AWC1.claim_no 
										AND HEM_AWC2.time_id =
													(SELECT max(time_Id)
													  FROM  HEM_AWC HEM_AWC3
													  WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
															AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
															AND HEM_AWC.Time_ID
													) 
										AND HEM_AWC2.[group] <> HEM_AWC1.[group]
								) 
							AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,HEM_AWC.Time_ID) 
                            AND HEM_AWC.Time_ID AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4
                            AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC) 
                    )
		,Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'group' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
								AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
								AND month(Time_Id)= month(HEM_AWC.Time_Id)
					)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('group','5-plus')   HEM_AWC

UNION ALL
SELECT  [Type] = 'account_manager'
		, Unit = RTRIM(Unit)
		, [Primary] = RTRIM([Primary])
		, WeeklyType = '5-plus'
		, Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
        ,Actual =(SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
                    FROM    HEM_AWC HEM_AWC1
                    WHERE   RTRIM([Account_Manager]) = RTRIM(HEM_AWC.Unit) 
							AND NOT EXISTS
								(SELECT 1
								 FROM   HEM_AWC HEM_AWC2
								 WHERE  HEM_AWC2.claim_no = HEM_AWC1.claim_no 
										AND HEM_AWC2.time_id =
													(SELECT max(time_Id)
													  FROM  HEM_AWC HEM_AWC3
													  WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
															AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) 
															AND HEM_AWC.Time_ID
													) 
										AND HEM_AWC2.[Account_Manager] <> HEM_AWC1.[Account_Manager]
								) 
							AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2,HEM_AWC.Time_ID) 
                            AND HEM_AWC.Time_ID AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4 
                            AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
                    )
		,Projection =(SELECT   ISNULL(sum(Projection), 0)
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = '5-plus' AND Unit_Type = 'account_manager' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
								AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
								AND month(Time_Id)= month(HEM_AWC.Time_Id)
					)
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('account_manager','5-plus')   HEM_AWC

UNION ALL
SELECT     [Type] = 'team'
, Unit = Unit
, [Primary] = RTRIM([Primary])
, WeeklyType = '5-plus'
, Time_Id
, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
, Actual =(SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
            FROM    HEM_AWC HEM_AWC1
            WHERE   Team = HEM_AWC.Unit 
					AND [Group] = HEM_AWC.[Primary]
					AND NOT EXISTS (SELECT  1
                                    FROM    HEM_AWC HEM_AWC2
                                    WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
											AND HEM_AWC2.time_id =(SELECT   max(time_Id)
                                                                      FROM  HEM_AWC HEM_AWC3
                                                                      WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																			AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID
																	) 
                                            AND HEM_AWC2.[group] <> HEM_AWC1.[group]
                                    ) 
                    AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
                    AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4
                    AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
            )
, Projection =  (SELECT ISNULL(sum(Projection), 0)
					FROM	dbo.HEM_AWC_Projections
                    WHERE   [Type] = '5-plus' AND Unit_Type = 'team' AND Unit_Name = HEM_AWC.Unit
							 AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
							 AND month(Time_Id)= month(HEM_AWC.Time_Id)
                )
FROM      dbo.udf_HEM_AWC_Generate_Time_ID('team','5-plus') HEM_AWC

UNION ALL
SELECT     [Type] = 'am_empl_size'
, Unit = Unit
, [Primary] = RTRIM([Primary])
, WeeklyType = '5-plus'
, Time_Id
, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
, Actual =(SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
            FROM    HEM_AWC HEM_AWC1
            WHERE   Empl_Size = HEM_AWC.Unit
					AND [Account_Manager] = HEM_AWC.[Primary]
					AND NOT EXISTS (SELECT  1
                                    FROM    HEM_AWC HEM_AWC2
                                    WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
											AND HEM_AWC2.time_id =(SELECT   max(time_Id)
                                                                      FROM  HEM_AWC HEM_AWC3
                                                                      WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																			AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID
																	) 
                                            AND HEM_AWC2.[Account_Manager] <> HEM_AWC1.[Account_Manager]
                                    ) 
                    AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
                    AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4
                    AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
            )
, Projection =  (SELECT ISNULL(sum(Projection), 0)
					FROM	dbo.HEM_AWC_Projections
                    WHERE   [Type] = '5-plus' AND Unit_Type = 'am_empl_size' AND Unit_Name = HEM_AWC.Unit
							 AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
							 AND month(Time_Id)= month(HEM_AWC.Time_Id)
                )
FROM     dbo.udf_HEM_AWC_Generate_Time_ID('am_empl_size','5-plus')    HEM_AWC

UNION ALL
SELECT     [Type] = 'portfolio_empl_size'
, Unit = Unit
, [Primary] = RTRIM([Primary])
, WeeklyType = '5-plus'
, Time_Id
, Month_Year = LEFT(datename(month, Time_Id), 3) + '-' + RIGHT(datename(year, Time_Id), 2) 
, Actual =(SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
            FROM    HEM_AWC HEM_AWC1
            WHERE   Empl_Size = HEM_AWC.Unit
					AND [Portfolio] = HEM_AWC.[Primary]
					AND NOT EXISTS (SELECT  1
                                    FROM    HEM_AWC HEM_AWC2
                                    WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
											AND HEM_AWC2.time_id =(SELECT   max(time_Id)
                                                                      FROM  HEM_AWC HEM_AWC3
                                                                      WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																			AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID
																	) 
                                            AND HEM_AWC2.[portfolio] <> HEM_AWC1.[portfolio]
                                    ) 
                    AND HEM_AWC1.Time_ID BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID 
                    AND Year(HEM_AWC1.Date_of_injury) < Year(HEM_awc.Time_ID) - 4
                    AND HEM_AWC.Time_ID <= (select MAX(Time_ID) from HEM_AWC)
            )
, Projection =  (SELECT ISNULL(sum(Projection), 0)
					FROM	dbo.HEM_AWC_Projections
                    WHERE   [Type] = '5-plus' AND Unit_Type = 'portfolio_empl_size' AND Unit_Name = HEM_AWC.Unit
							 AND year(Time_Id) = Year(HEM_AWC.Time_Id) 
							 AND month(Time_Id)= month(HEM_AWC.Time_Id)
                )
FROM    dbo.udf_HEM_AWC_Generate_Time_ID('portfolio_empl_size','5-plus') HEM_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Weekly_Open_5_Plus.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Whole_HEM.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_AWC_Whole_HEM')
	DROP VIEW [dbo].[uv_HEM_AWC_Whole_HEM]
GO
CREATE VIEW [dbo].[uv_HEM_AWC_Whole_HEM] 
AS
	-----HEM------
	SELECT  [UnitType] = 'HEM'
			,Unit = 'HEM'
			,[Primary] = 'HEM'
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = 
				isnull(
						(SELECT     COUNT(DISTINCT HEM_AWC1.claim_no)
							FROM    HEM_AWC HEM_AWC1
							WHERE   HEM_AWC1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM  HEM_AWC))						
									AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
					, 0)
	FROM      dbo.udf_Whole_HEM_Generate_Years('hem')HEM_AWC
	GROUP BY  Year(Transaction_Year)

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'HEM'
			,Unit = 'HEM'
			,[Primary] = 'HEM'
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
					isnull(
						(SELECT top 1 Projection
							FROM   dbo.HEM_AWC_Projections
							WHERE  [Type] = 'Whole-HEM' AND Unit_Type = 'HEM' 
									AND RTRIM(Unit_Name) = 'HEM'
									AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
							ORDER BY time_id DESC									
						)
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('hem')  HEM_AWC	
	-----End HEM------
	
	-----Portfolio------
	UNION ALL
	SELECT  [UnitType] = 'portfolio'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT HEM_AWC1.claim_no)
				  FROM         HEM_AWC HEM_AWC1
				  WHERE     RTRIM(portfolio) = RTRIM(HEM_AWC.[Primary]) 
							AND HEM_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
				, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('portfolio') HEM_AWC

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'portfolio'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT top 1 Projection
				  FROM   dbo.HEM_AWC_Projections
				  WHERE [Type] = 'Whole-HEM' AND Unit_Type = 'portfolio' 
						AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
						AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
				  ORDER BY time_id DESC	
				)
				, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('portfolio') HEM_AWC	
		
	--Portfolio Hotel Summary--
	UNION ALL
	SELECT  [UnitType] = 'portfolio'
			,Unit = 'Hotel'
			,[Primary] = 'Hotel'
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT HEM_AWC1.claim_no)
				  FROM         HEM_AWC HEM_AWC1
				  WHERE     RTRIM(portfolio) in ('Accommodation','Pubs, Taverns and Bars')
							AND HEM_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
				, 0)
	FROM    dbo.udf_Whole_HEM_Generate_Years('portfolio')  HEM_AWC
	WHERE	RTRIM([Primary]) = 'Accommodation'

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'portfolio'
			,Unit = 'Hotel'
			,[Primary] = 'Hotel'
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT top 1 Projection
				  FROM   dbo.HEM_AWC_Projections
				  WHERE [Type] = 'Whole-HEM' AND Unit_Type = 'portfolio' 
						AND RTRIM(Unit_Name) in ('Accommodation','Pubs, Taverns and Bars')
						AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
				  ORDER BY time_id DESC	
				)
				, 0)
	FROM       dbo.udf_Whole_HEM_Generate_Years('portfolio')  HEM_AWC
	WHERE RTRIM([Primary]) = 'Accommodation'
	-----End Portfolio------
	
	-----Group------
	UNION ALL
	SELECT	[UnitType] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
					  FROM  HEM_AWC HEM_AWC1
					  WHERE RTRIM([Group]) = RTRIM(HEM_AWC.[Primary]) 
							AND HEM_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT     max(time_id) FROM HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('group')  HEM_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year) 
			,[Type] = 'Projection' 
			,No_of_Active_Weekly_Claims = isnull(
					(SELECT     top 1 Projection
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = 'Whole-HEM' AND Unit_Type = 'group' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
								AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
						ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('group')  HEM_AWC	
	-----End Group------	
	
	-----Account manager------
	UNION ALL
	SELECT	[UnitType] = 'account_manager'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
					  FROM  HEM_AWC HEM_AWC1
					  WHERE RTRIM([Account_Manager]) = RTRIM(HEM_AWC.[Primary]) 
							AND HEM_AWC1.time_id >= dateadd(mm, - 2,
								(SELECT     max(time_id) FROM HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
					, 0)
	FROM      dbo.udf_Whole_HEM_Generate_Years('account_manager') HEM_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'account_manager'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year) 
			,[Type] = 'Projection' 
			,No_of_Active_Weekly_Claims = isnull(
					(SELECT     top 1 Projection
						FROM    dbo.HEM_AWC_Projections
						WHERE   [Type] = 'Whole-HEM' AND Unit_Type = 'account_manager' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit) 
								AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
						ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('account_manager') HEM_AWC
	-----End Account manager------	
	
	---Team---
	UNION ALL
	SELECT  [UnitType] = 'team'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
					  FROM  HEM_AWC HEM_AWC1
					  WHERE RTRIM([Group]) = RTRIM(HEM_AWC.[Primary]) AND RTRIM(Team) = RTRIM(HEM_AWC.Unit) 
					  AND HEM_AWC1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('team') HEM_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'team'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.HEM_AWC_Projections
					  WHERE [Type] = 'Whole-HEM' AND Unit_Type = 'team' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit)
								AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
					  ORDER BY time_id DESC	
					)
					, 0)
	FROM  dbo.udf_Whole_HEM_Generate_Years('team')  HEM_AWC
	
	---AM_EMPL_SIZE---
	UNION ALL
	SELECT  [UnitType] = 'am_empl_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
					  FROM  HEM_AWC HEM_AWC1
					  WHERE RTRIM([Account_Manager]) = RTRIM(HEM_AWC.[Primary]) AND RTRIM(Empl_Size) = RTRIM(HEM_AWC.Unit) 
					  AND HEM_AWC1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
					, 0)
	FROM   dbo.udf_Whole_HEM_Generate_Years('am_empl_size') HEM_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'am_empl_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.HEM_AWC_Projections
					  WHERE [Type] = 'Whole-HEM' AND Unit_Type = 'am_empl_size' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit)
								AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
					  ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('am_empl_size') HEM_AWC
	
	---Portfolio_EMPL_SIZE---
	UNION ALL
	SELECT  [UnitType] = 'portfolio_empl_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Year)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT HEM_AWC1.claim_no)
					  FROM  HEM_AWC HEM_AWC1
					  WHERE RTRIM([Portfolio]) = RTRIM(HEM_AWC.[Primary]) AND RTRIM(Empl_Size) = RTRIM(HEM_AWC.Unit) 
					  AND HEM_AWC1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM HEM_AWC)) 
							AND year(Date_of_Injury) = Year(HEM_AWC.Transaction_Year))
					, 0)
	FROM     dbo.udf_Whole_HEM_Generate_Years('portfolio_empl_size')    HEM_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'portfolio_empl_size'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Year)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.HEM_AWC_Projections
					  WHERE [Type] = 'Whole-HEM' AND Unit_Type = 'portfolio_empl_size' 
								AND RTRIM(Unit_Name) = RTRIM(HEM_AWC.Unit)
								AND Time_Id = DATEADD(month,- 1,HEM_AWC.Transaction_Year) 
					  ORDER BY time_id DESC	
					)
					, 0)
	FROM   dbo.udf_Whole_HEM_Generate_Years('portfolio_empl_size') HEM_AWC
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Whole_HEM.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_CPR_Weekly_Open.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_CPR_Weekly_Open')
	DROP VIEW [dbo].[uv_HEM_CPR_Weekly_Open]
GO
CREATE VIEW [dbo].[uv_HEM_CPR_Weekly_Open]
AS
	WITH temp AS
	(	
		-- For monthly in one year
		SELECT	DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0) AS Start_Date
				,DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()) + 1, 0)) + '23:59' AS End_Date
				,13 AS iMonth
		UNION ALL
		SELECT DATEADD(m, -1, Start_Date), DATEADD(d, -1, Start_Date) + '23:59', iMonth - 1
		FROM temp WHERE End_Date > DATEADD(m, -11, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
	)
		
	--HEM--
	select  [UnitType] = 'Hospitality'
			,Unit = 'Hospitality'
			,[Primary] = 'Hospitality'
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y')
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	--End HEM
	
	UNION ALL
	
	--Portfolio--
	select  [UnitType] = 'portfolio'
			,Unit = tmp_value.Value
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join 
	(
		SELECT DISTINCT Value
			FROM [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
			WHERE Value <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Portfolio--
	
	UNION ALL
		
	--Portfolio Hotel--
	select  [UnitType] = 'portfolio'
			,Unit = 'Hotel'
			,[Primary] = 'Hotel'
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value in ('Accommodation','Pubs, Taverns and Bars'))
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value in ('Accommodation','Pubs, Taverns and Bars'))
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value in ('Accommodation','Pubs, Taverns and Bars'))
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	--End Portfolio Hotel--
	
	UNION ALL
	
	--Group--
	select  [UnitType] = 'group'
			,Unit = tmp_value.Value
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('HEM', 'group', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join 
	(
		SELECT DISTINCT Value
			FROM [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
			WHERE Value <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Group--
	
	UNION ALL
	
	--Account manager--
	select  [UnitType] = 'account_manager'
			,Unit = tmp_value.Value
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join 
	(
		SELECT DISTINCT Value
			FROM [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
			WHERE Value <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Account manager--
	
	UNION ALL
	
	--Team--
	select  [UnitType] = 'team'
			,Unit = tmp_value.SubValue
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('HEM', 'group', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join
	(
		SELECT DISTINCT SubValue, Value
			FROM [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
			WHERE Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue, Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Team--
	
	UNION ALL
	
	--AM_EMPL_SIZE--
	select  [UnitType] = 'am_empl_size'
			,Unit = tmp_value.SubValue
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join
	(
		SELECT DISTINCT SubValue, Value
			FROM [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
			WHERE Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue, Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End AM_EMPL_SIZE--
	
	UNION ALL
	
	--Portfolio_EMPL_SIZE--
	select  [UnitType] = 'portfolio_empl_size'
			,Unit = tmp_value.SubValue
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join
	(
		SELECT DISTINCT SubValue, Value
			FROM [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
			WHERE Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue, Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Portfolio_EMPL_SIZE--
	
	UNION ALL
	
	--Claim Officer
	select  [UnitType] = 'claim_officer'
			,Unit = tmp_value.SubValue2
			,[Primary] = tmp_value.SubValue
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('HEM', 'group', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and SubValue = tmp_value.SubValue
											and SubValue2 = tmp_value.SubValue2)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and SubValue = tmp_value.SubValue
											and SubValue2 = tmp_value.SubValue2)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and SubValue = tmp_value.SubValue
											and SubValue2 = tmp_value.SubValue2)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join
	(
		SELECT DISTINCT SubValue2, SubValue
			FROM [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
			WHERE SubValue <> '' and SubValue2 <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue2, SubValue
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Claim Officer
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_CPR_Weekly_Open.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current')
	DROP VIEW [dbo].[uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current] 
AS
	--Portfolio---	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='portfolio'
			,'Hospitality' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(Remuneration_End,'target','','Hospitality',NULL,Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='portfolio'
			,rtrim(Portfolio) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(Remuneration_End,'target','portfolio',rtrim(Portfolio),NULL,Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11) and rtrim(Portfolio) IS NOT NULL

	group by Portfolio,Measure,Remuneration_Start, Remuneration_End
	
	--hotel summary--
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='portfolio'
			,'Hotel' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(Remuneration_End,'target','portfolio','Hotel',NULL,Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11) and rtrim(Portfolio) IS NOT NULL
		   and RTRIM(Portfolio) in ('Accommodation','Pubs, Taverns and Bars')

	group by Measure,Remuneration_Start, Remuneration_End
	
	---Group---
	union all
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,'Hospitality' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(Remuneration_End,'target','','Hospitality',NULL,Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,rtrim([Group]) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(Remuneration_End,'target','group',rtrim([Group]),NULL,Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Measure,Remuneration_Start, Remuneration_End
	
	---Account manager---
	union all
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='account_manager'
			,'Hospitality' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(Remuneration_End,'target','','Hospitality',NULL,Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='account_manager'
			,rtrim([Account_Manager]) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(Remuneration_End,'target','account_manager',rtrim([Account_Manager]),NULL,Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Account_Manager]) is not null

	group by [Account_Manager],Measure,Remuneration_Start, Remuneration_End	

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous')
	DROP VIEW [dbo].[uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous] 
AS
	--Employer size---
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='portfolio'
			,'Hospitality' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='portfolio'
			,rtrim(Portfolio) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Portfolio,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	
	
	--Portfolio Hotel Summary--
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='portfolio'
			,'Hotel' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')

	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	
	
	---Group---
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,'Hospitality' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,rtrim([Group]) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	

	---Account manager---
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='account_manager'
			,'Hospitality' as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='account_manager'
			,rtrim([Account_Manager]) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Account_Manager]) is not null

	group by [Account_Manager],Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Rolling_Month_1.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_HEM_RTW_Agency_Group_Rolling_Month_1
IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Agency_Group_Rolling_Month_1')
	DROP VIEW [dbo].[uv_HEM_RTW_Agency_Group_Rolling_Month_1]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Agency_Group_Rolling_Month_1] 
AS

SELECT     rtrim(uv.[Group]) as EmployerSize_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],NULL,uv.Measure)
						
FROM         dbo.HEM_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
GROUP BY  uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     rtrim(uv.Portfolio) as EmployerSize_Group
		   ,[Type] = 'portfolio' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio',uv.Portfolio,NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','portfolio',uv.Portfolio,NULL,uv.Measure)					 
FROM         dbo.HEM_RTW uv 
			where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
GROUP BY  uv.Portfolio, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Portfolio Hotel Summary--
UNION ALL

SELECT     'Hotel' as EmployerSize_Group
		   ,[Type] = 'portfolio' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio','Hotel',NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','portfolio','Hotel',NULL,uv.Measure)					 
FROM         dbo.HEM_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		and RTRIM([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')
GROUP BY  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     rtrim(uv.Account_Manager) as EmployerSize_Group
		   ,[Type] = 'account_manager' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',uv.Account_Manager,NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','account_manager',uv.Account_Manager,NULL,uv.Measure)					 
FROM         dbo.HEM_RTW uv 
			where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
			and rtrim(uv.Account_Manager) is not null
GROUP BY  uv.Account_Manager, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL
SELECT     'Hospitality' AS EmployerSize_Group
			, [Type] = 'group'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			, Measure AS Measure_months
			, SUM(t.LT) AS LT
            , SUM(t.WGT) AS WGT
			, SUM(LT) / SUM(WGT) AS AVGDURN
			
			, [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'target','group','Hospitality',NULL,t.Measure)
			, Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'base','group','Hospitality',NULL,t.Measure)
			
FROM         HEM_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 0
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     'Hospitality' AS EmployerSize_Group
			, [Type] = 'portfolio'
			,t.Remuneration_Start
			,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			, Measure AS Measure_months
			, SUM(t.LT) AS LT
            , SUM(t.WGT) AS WGT
			, SUM(LT) / SUM(WGT) AS AVGDURN
			
			, [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'target','portfolio','Hospitality',NULL,t.Measure)
			, Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'base','portfolio','Hospitality',NULL,t.Measure)

FROM         HEM_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 0
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     'Hospitality' AS EmployerSize_Group
			, [Type] = 'account_manager'
			,t.Remuneration_Start
			,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			, Measure AS Measure_months
			, SUM(t.LT) AS LT
            , SUM(t.WGT) AS WGT
			, SUM(LT) / SUM(WGT) AS AVGDURN
			
			, [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'target','account_manager','Hospitality',NULL,t.Measure)
			, Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'base','account_manager','Hospitality',NULL,t.Measure)
            
            
FROM         HEM_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 0
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Rolling_Month_1.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Rolling_Month_12.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_HEM_RTW_Agency_Group_Rolling_Month_12
IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Agency_Group_Rolling_Month_12')
	DROP VIEW [dbo].[uv_HEM_RTW_Agency_Group_Rolling_Month_12]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Agency_Group_Rolling_Month_12] 
AS

SELECT    EmployerSize_Group = rtrim(uv.[Group])
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) 
          
          ,Measure_months = Measure 
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],NULL,uv.Measure)
						
FROM      dbo.HEM_RTW uv 

WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
		  and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)

GROUP BY  uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     EmployerSize_Group = rtrim(uv.Portfolio)
		   ,[Type] = 'portfolio' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio',uv.Portfolio,NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','portfolio',uv.Portfolio,NULL,uv.Measure)					 
FROM         dbo.HEM_RTW uv 
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
			and uv.Portfolio is not null
GROUP BY  uv.Portfolio, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Hotel summary--
UNION ALL

SELECT     EmployerSize_Group = 'Hotel'
		   ,[Type] = 'portfolio' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio','Hotel',NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','portfolio', 'Hotel',NULL,uv.Measure)					 
FROM         dbo.HEM_RTW uv 
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
			and uv.Portfolio is not null
			and uv.Portfolio in ('Accommodation','Pubs, Taverns and Bars')
GROUP BY  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     EmployerSize_Group = rtrim(uv.Account_Manager)
		   ,[Type] = 'account_manager' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',uv.Account_Manager,NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','account_manager',uv.Account_Manager,NULL,uv.Measure)					 
FROM         dbo.HEM_RTW uv 
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
			and rtrim(uv.Account_Manager) is not null
GROUP BY  uv.Account_Manager, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL
SELECT     EmployerSize_Group ='Hospitality'
			,[Type] = 'group'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months = Measure
			,LT= SUM(t.LT)
            ,WGT= SUM(t.WGT)
			,AVGDURN= SUM(LT) / SUM(WGT)			
			,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'target','group','Hospitality',NULL,t.Measure)
			,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'base','group','Hospitality',NULL,t.Measure)

FROM         HEM_RTW t
inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     EmployerSize_Group= 'Hospitality'
			,[Type] = 'portfolio'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			,Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months= Measure
			,LT = SUM(t.LT)  
            ,WGT =SUM(t.WGT)  
			,AVGDURN =SUM(LT) / SUM(WGT)  			
			,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'target','portfolio','Hospitality',NULL,t.Measure)
			,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'base','portfolio','Hospitality',NULL,t.Measure)
            
            
FROM         HEM_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     EmployerSize_Group= 'Hospitality'
			,[Type] = 'account_manager'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			,Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months= Measure
			,LT = SUM(t.LT)  
            ,WGT =SUM(t.WGT)  
			,AVGDURN =SUM(LT) / SUM(WGT)  			
			,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'target','account_manager','Hospitality',NULL,t.Measure)
			,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(t.Remuneration_End,'base','account_manager','Hospitality',NULL,t.Measure)
            
            
FROM         HEM_RTW t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Rolling_Month_12.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Raw_Data.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Raw_Data')
	DROP VIEW [dbo].[uv_HEM_RTW_Raw_Data]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Raw_Data] 
AS
	SELECT  Claim_Closed_flag
			,Remuneration_Start
			,Remuneration_End
			,Measure_months = Measure
			,[Group] = RTRIM([group])
			,Team
			,Sub_Category = RTRIM(Sub_Category)
			,Case_manager
			,AgencyName = RTRIM(AgencyName)
			,rtw.Claim_no
			,DTE_OF_INJURY 
			,rtw.POLICY_NO
			,LT= ROUND(LT, 2)
			,WGT=ROUND(WGT, 2)
			,EMPL_SIZE
			,Weeks_from_date_of_injury = DATEDIFF(week, DTE_OF_INJURY, Remuneration_End)
			,Weeks_paid= ROUND(Weeks_paid, 2)
			,Stress
			,Liability_Status
			,cost_code
			,cost_code2
			,Cert_Type
			,Med_cert_From
			,Med_cert_To
			,rtw.Account_Manager
			,Portfolio
			,Cell_no
	FROM dbo.HEM_RTW rtw 
	WHERE remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		 AND  DATEDIFF(month, Remuneration_Start, Remuneration_End) + 1 =12  

GO 
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Raw_Data.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current')
	DROP VIEW [dbo].[uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current] 
AS
	---Group---			
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,rtrim([Group]) as EmployerSize_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',rtrim([Group]),rtrim(Team),Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Team,Measure,Remuneration_Start, Remuneration_End
	
	--Account Manager--
	union all
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='account_manager'
			,rtrim([Account_Manager]) as EmployerSize_Group
			,rtrim(EMPL_SIZE) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',rtrim([Account_Manager]),rtrim(EMPL_SIZE),Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Account_Manager])is not null

	group by [Account_Manager],EMPL_SIZE,Measure,Remuneration_Start, Remuneration_End
	
	--Portfolio--
	union all
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='portfolio'
			,rtrim([Portfolio]) as EmployerSize_Group
			,rtrim(EMPL_SIZE) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio',rtrim([Portfolio]),rtrim(EMPL_SIZE),Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Portfolio])is not null

	group by [Portfolio],EMPL_SIZE,Measure, Remuneration_Start, Remuneration_End
	
	--Portfolio Hotel Summary--
	union all
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='portfolio'
			,'Hotel' as EmployerSize_Group
			,rtrim(EMPL_SIZE) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio','Hotel',rtrim(EMPL_SIZE),Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Portfolio])is not null
		   and rtrim([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')

	group by EMPL_SIZE,Measure, Remuneration_Start, Remuneration_End
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous')
	DROP VIEW [dbo].[uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous] 
AS	
	---Group---	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='group'
			,rtrim([Group]) as EmployerSize_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Team,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	---Account manager---	
	union all 
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='account_manager'
			,rtrim([Account_Manager]) as EmployerSize_Group
			,rtrim(EMPL_SIZE) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Account_Manager]) is not null

	group by [Account_Manager],EMPL_SIZE,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	---Portfolio---	
	union all 
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='portfolio'
			,rtrim([Portfolio]) as EmployerSize_Group
			,rtrim(EMPL_SIZE) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Portfolio]) is not null

	group by [Portfolio],EMPL_SIZE,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	--Portfolio Hotel Summary--
	union all 
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[Type]='portfolio'
			,'Hotel' as EmployerSize_Group
			,rtrim(EMPL_SIZE) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim([Portfolio]) is not null
		   and RTRIM([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')

	group by EMPL_SIZE,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Team_Sub_Rolling_Month_1.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_HEM_RTW_Team_Sub_Rolling_Month_1
IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Team_Sub_Rolling_Month_1')
	DROP VIEW [dbo].[uv_HEM_RTW_Team_Sub_Rolling_Month_1]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Team_Sub_Rolling_Month_1] 
AS

SELECT     rtrim(uv.Team) as Team_Sub
			, uv.[Group] as EmployerSize_Group
			,[Type] = 'group'
			,uv.Remuneration_Start
			,uv.Remuneration_End
			,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
			,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
			,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],uv.Team,uv.Measure)									
			, Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],uv.Team,uv.Measure)
						
FROM         dbo.HEM_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
GROUP BY uv.Team, uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

union all

SELECT     rtrim(uv.EMPL_SIZE) as Team_Sub
			, uv.[Account_Manager] as EmployerSize_Group
			,[Type] = 'account_manager'
			,uv.Remuneration_Start
			,uv.Remuneration_End
			,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
			,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
			,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',uv.[Account_Manager],uv.EMPL_SIZE,uv.Measure)									
			, Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','account_manager',uv.[Account_Manager],uv.EMPL_SIZE,uv.Measure)
						
FROM         dbo.HEM_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		and uv.[Account_Manager] is not null
GROUP BY uv.EMPL_SIZE, uv.[Account_Manager], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

union all

SELECT     rtrim(uv.EMPL_SIZE) as Team_Sub
			, uv.[Portfolio] as EmployerSize_Group
			,[Type] = 'portfolio'
			,uv.Remuneration_Start
			,uv.Remuneration_End
			,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
			,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
			,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio',uv.[Portfolio],uv.EMPL_SIZE,uv.Measure)									
			, Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','portfolio',uv.[Portfolio],uv.EMPL_SIZE,uv.Measure)
						
FROM         dbo.HEM_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		and uv.[Portfolio] is not null
GROUP BY uv.EMPL_SIZE, uv.[Portfolio], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Portfolio Hotel Summary--
union all

SELECT     rtrim(uv.EMPL_SIZE) as Team_Sub
			, 'Hotel' as EmployerSize_Group
			,[Type] = 'portfolio'
			,uv.Remuneration_Start
			,uv.Remuneration_End
			,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
			,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
			,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio','Hotel',uv.EMPL_SIZE,uv.Measure)									
			, Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','portfolio','Hotel',uv.EMPL_SIZE,uv.Measure)
						
FROM         dbo.HEM_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		and uv.[Portfolio] is not null
		and RTRIM([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')
GROUP BY uv.EMPL_SIZE, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Team_Sub_Rolling_Month_1.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Team_Sub_Rolling_Month_12.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_HEM_RTW_Team_Sub_Rolling_Month_12
IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Team_Sub_Rolling_Month_12')
	DROP VIEW [dbo].[uv_HEM_RTW_Team_Sub_Rolling_Month_12]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Team_Sub_Rolling_Month_12] 
AS
SELECT     rtrim(uv.Team) as Team_Sub
		  ,rtrim(uv.[Group]) as  EmployerSize_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration        
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],uv.Team,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],uv.Team,uv.Measure)
						
FROM         dbo.HEM_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
GROUP BY uv.Team, uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

union all

SELECT     rtrim(uv.EMPL_SIZE) as Team_Sub
		  ,rtrim(uv.Account_Manager) as  EmployerSize_Group
		  ,[Type] = 'account_manager'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration        
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','account_manager',uv.[Account_Manager],uv.EMPL_SIZE,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','account_manager',uv.[Account_Manager],uv.EMPL_SIZE,uv.Measure)
						
FROM         dbo.HEM_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
	  and rtrim(uv.Account_Manager) is not null
GROUP BY uv.EMPL_SIZE, uv.[Account_Manager], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

union all

SELECT     rtrim(uv.EMPL_SIZE) as Team_Sub
		  ,rtrim(uv.[Portfolio]) as  EmployerSize_Group
		  ,[Type] = 'portfolio'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration        
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio',uv.[Portfolio],uv.EMPL_SIZE,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','portfolio',uv.[Portfolio],uv.EMPL_SIZE,uv.Measure)
						
FROM         dbo.HEM_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
GROUP BY uv.EMPL_SIZE, uv.[Portfolio], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Portfolio Hotel Summary--
union all

SELECT     rtrim(uv.EMPL_SIZE) as Team_Sub
		  ,'Hotel' as  EmployerSize_Group
		  ,[Type] = 'portfolio'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration        
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','portfolio','Hotel',uv.EMPL_SIZE,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','portfolio','Hotel',uv.EMPL_SIZE,uv.Measure)
						
FROM         dbo.HEM_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		and RTRIM([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')
GROUP BY uv.EMPL_SIZE, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Team_Sub_Rolling_Month_12.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_PORT.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_PORT')
	DROP VIEW [dbo].[uv_PORT]
GO
CREATE VIEW [dbo].[uv_PORT]
AS
	SELECT  System='TMF',Med_Cert_Status=Med_Cert_Status_This_Week,*,
		[Grouping] = case when RTRIM(Agency_Name) in ('Health', 'Other')
							then 'HEALTH & OTHER'
						when RTRIM(Agency_Name) in ('Police', 'Fire')
							then 'POLICE & FIRE'
						else ''
					end
		FROM dbo.TMF_Portfolio
		WHERE isnull(Is_Last_Month,0) =0
		 
	UNION ALL
	
	SELECT  System='HEM',Med_Cert_Status=Med_Cert_Status_This_Week,*, 
		[Grouping] = case when RTRIM(Portfolio) in ('Accommodation', 'Pubs, Taverns and Bars')
							then 'Hotel'
						else ''
					end 
		FROM dbo.HEM_Portfolio
		WHERE isnull(Is_Last_Month,0) =0
	
	UNION ALL
	
	SELECT  System='EML',Med_Cert_Status=Med_Cert_Status_This_Week,*, [Grouping] = ''
		FROM dbo.EML_Portfolio
		WHERE isnull(Is_Last_Month,0) =0
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_PORT.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_PORT_Get_All_Claim_Type.sql  
--------------------------------  
IF EXISTS(select * FROM sys.views where name = 'uv_PORT_Get_All_Claim_Type')
	DROP VIEW [dbo].[uv_PORT_Get_All_Claim_Type]
GO

/****** Object:  UserDefinedFunction [dbo].[uv_PORT_Get_All_Claim_Type]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[uv_PORT_Get_All_Claim_Type]
AS
		-- NEW CLAIMS
		SELECT  Claim_Type = 'claim_new_all'
		union SELECT Claim_Type = 'claim_new_nlt'
		union SELECT Claim_Type = 'claim_new_lt'
		
		-- BEGIN: OPEN CLAIMS	
			
		union SELECT Claim_Type = 'claim_open_all'
		union SELECT Claim_Type = 'claim_open_nlt'
		
		-- OPEN CLAIMS: NCMM
		union SELECT Claim_Type = 'claim_open_ncmm_this_week'
		union SELECT Claim_Type = 'claim_open_ncmm_next_week'
		
		-- OPEN CLAIMS: RTW
		union SELECT Claim_Type = 'claim_open_0_13'
		union SELECT Claim_Type = 'claim_open_13_26'
		union SELECT Claim_Type = 'claim_open_26_52'
		union SELECT Claim_Type = 'claim_open_52_78'
		union SELECT Claim_Type = 'claim_open_0_78'
		union SELECT Claim_Type = 'claim_open_78_130'
		union SELECT Claim_Type = 'claim_open_gt_130'
		
		-- OPEN CLAIMS: THERAPY TREATMENTS
		union SELECT Claim_Type = 'claim_open_acupuncture'
		union SELECT Claim_Type = 'claim_open_chiro'
		union SELECT Claim_Type = 'claim_open_massage'
		union SELECT Claim_Type = 'claim_open_osteo'
		union SELECT Claim_Type = 'claim_open_physio'
		union SELECT Claim_Type = 'claim_open_rehab'
		
		-- OPEN CLAIMS: LUMP SUM INTIMATIONS
		union SELECT Claim_Type = 'claim_open_death'
		union SELECT Claim_Type = 'claim_open_industrial_deafness'
		union SELECT Claim_Type = 'claim_open_ppd'
		union SELECT Claim_Type = 'claim_open_recovery'
		
		-- OPEN CLAIMS: LUMP SUM INTIMATIONS - WPI
		union SELECT Claim_Type = 'claim_open_wpi_all'
		union SELECT Claim_Type = 'claim_open_wpi_0_10'
		union SELECT Claim_Type = 'claim_open_wpi_11_14'
		union SELECT Claim_Type = 'claim_open_wpi_15_20'
		union SELECT Claim_Type = 'claim_open_wpi_21_30'
		union SELECT Claim_Type = 'claim_open_wpi_31_more'
		
		union SELECT Claim_Type = 'claim_open_wid'
		
		-- END: OPEN CLAIMS
		
		-- CLAIM CLOSURES
		union SELECT Claim_Type = 'claim_closure'
		union SELECT Claim_Type = 'claim_re_open'
		union SELECT Claim_Type = 'claim_still_open'

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_PORT_Get_All_Claim_Type.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Raw_Data.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Raw_Data')
	DROP VIEW [dbo].[uv_TMF_AWC_Raw_Data]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Raw_Data] 
AS
SELECT    Time_ID
		, Claim_no
		, Team
		, [Group] = RTRIM([Group])
		, Sub_Category = RTRIM(Sub_Category)
		, AgencyName = RTRIM(AgencyName)
		, Date_of_Injury
		, Cert_Type
		, Med_cert_From
		, Med_cert_To
		, Account_Manager
		, Cell_no
		, Portfolio
FROM    dbo.TMF_AWC
WHERE    (Time_ID >=DATEADD(mm, - 2,DATEADD(yy, DATEDIFF(yy,0,GETDATE()), 0)))
		
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Raw_Data.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Weekly_Open_1_2.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Weekly_Open_1_2')
	DROP VIEW [dbo].[uv_TMF_AWC_Weekly_Open_1_2]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Weekly_Open_1_2] 
AS	
	---TMF---
	SELECT  [Type] = 'TMF'
			,Unit = 'TMF'
			,[Primary] = 'TMF'
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2)
			,Actual = (SELECT   COUNT(DISTINCT tmf_awc1.claim_no)
						FROM	TMF_AWC tmf_awc1
						WHERE   tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID 
								AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1
									AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC)
								)
			,Projection =  (SELECT ISNULL(sum(Projection), 0)
								FROM	dbo.TMF_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'TMF' 										 
										AND year(Time_Id) = Year(tmf_awc.Time_Id) 
										AND month(Time_Id)= month(tmf_awc.Time_Id))
	FROM    dbo.udf_TMF_AWC_Generate_Time_ID('tmf','1-2') TMF_AWC
	
	UNION ALL
	---Agency---
	SELECT  [Type] = 'agency'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2)
			,Actual = (SELECT   COUNT(DISTINCT tmf_awc1.claim_no)
						FROM	TMF_AWC tmf_awc1
						WHERE   RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) 
								AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID 
								AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1
									AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	 								
									)
			,Projection =  (SELECT ISNULL(sum(Projection), 0)
								FROM	dbo.TMF_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'agency' 
										AND RTRIM(Unit_Name) = RTRIM(tmf_awc.[Primary]) 
										AND year(Time_Id) = Year(tmf_awc.Time_Id) 
										AND month(Time_Id)= month(tmf_awc.Time_Id))
	FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','1-2') TMF_AWC
	
	--Agency Police & Fire--
	UNION ALL
	SELECT  [Type] = 'agency'
			,Unit = 'Police & Fire'
			,[Primary] = 'Police & Fire'
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2)
			,Actual = (SELECT   COUNT(DISTINCT tmf_awc1.claim_no)
						FROM	TMF_AWC tmf_awc1
						WHERE   RTRIM(AgencyName) in ('Police','Fire')
								AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID 
								AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1
									AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	 
								)
			,Projection =  (SELECT ISNULL(sum(Projection), 0)
								FROM	dbo.TMF_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'agency' 
										AND RTRIM(Unit_Name) in ('Police','Fire')
										AND year(Time_Id) = Year(tmf_awc.Time_Id) 
										AND month(Time_Id)= month(tmf_awc.Time_Id))
	FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','1-2') TMF_AWC
	WHERE   RTRIM([Primary]) = 'Police'
		
	--Agency Health & Other--
	UNION ALL
	SELECT  [Type] = 'agency'
			,Unit = 'Health & Other'
			,[Primary] = 'Health & Other'
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2)
			,Actual = (SELECT   COUNT(DISTINCT tmf_awc1.claim_no)
						FROM	TMF_AWC tmf_awc1
						WHERE   RTRIM(AgencyName) in ('Health','Other')
								AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID 
								AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1
									AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
					   )
			,Projection =  (SELECT ISNULL(sum(Projection), 0)
								FROM	dbo.TMF_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'agency' 
										AND RTRIM(Unit_Name) in ('Health','Other')
										AND year(Time_Id) = Year(tmf_awc.Time_Id) 
										AND month(Time_Id)= month(tmf_awc.Time_Id))
	FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','1-2') TMF_AWC
	WHERE   RTRIM([Primary]) = 'Health'
		
	---Group---
	UNION ALL
	SELECT  [Type] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2) 						  
			,Actual = (SELECT   COUNT(DISTINCT tmf_awc1.claim_no)
						FROM	TMF_AWC tmf_awc1
						WHERE   RTRIM([Group]) = RTRIM(tmf_awc.Unit) 
								AND NOT EXISTS(SELECT   1
												FROM	tmf_awc tmf_awc2
												WHERE   tmf_awc2.claim_no = tmf_awc1.claim_no 
														AND tmf_awc2.time_id =(SELECT   max(time_Id)
																				FROM    tmf_awc tmf_awc3
																				WHERE   tmf_awc3.claim_no = tmf_awc1.claim_no 
																						AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND  tmf_awc.Time_ID
																				) 
														AND tmf_awc2.[group] <> tmf_awc1.[group]
												)
								AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2,tmf_awc.Time_ID) AND tmf_awc.Time_ID 
								AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1
								AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
						)
			,Projection =(SELECT	ISNULL(sum(Projection), 0)
							FROM    dbo.TMF_AWC_Projections
							WHERE   [Type] = '1-2' AND Unit_Type = 'group' 
									AND RTRIM(Unit_Name) = RTRIM(tmf_awc.Unit) 
									AND year(Time_Id) = Year(tmf_awc.Time_Id) 
									AND month(Time_Id)= month(tmf_awc.Time_Id)
							)
	FROM    dbo.udf_TMF_AWC_Generate_Time_ID('group','1-2') TMF_AWC
	
	---Sub category---
	UNION ALL
	SELECT  [Type] = 'sub_category'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2) 
			,Actual =(SELECT	COUNT(DISTINCT tmf_awc1.claim_no)
						FROM    TMF_AWC tmf_awc1
						WHERE   Sub_Category = tmf_awc.Unit 
								AND RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) 
								AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID 
								AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1
								AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	 								
								)
			,Projection =(SELECT	ISNULL(sum(Projection), 0)
									FROM	dbo.TMF_AWC_Projections
									WHERE   [Type] = '1-2' AND Unit_Type = 'sub_category' 
											AND Unit_Name = tmf_awc.Unit AND 
											year(Time_Id) = Year(tmf_awc.Time_Id) AND 
											month(Time_Id) = month(tmf_awc.Time_Id))							
	FROM    dbo.udf_TMF_AWC_Generate_Time_ID('sub_category','1-2') TMF_AWC
	
	---Team---
	UNION ALL
	SELECT  [Type] = 'team'
			,Unit = Unit
			,[Primary] = RTRIM([Primary])
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2) 						
			,Actual = (SELECT   COUNT(DISTINCT tmf_awc1.claim_no)
								FROM	TMF_AWC tmf_awc1
								WHERE   Team = TMF_AWC.Unit 
										AND [Group] = TMF_AWC.[Primary]
										AND NOT EXISTS(SELECT   1
														FROM	tmf_awc tmf_awc2
														WHERE   tmf_awc2.claim_no = tmf_awc1.claim_no 
																AND tmf_awc2.time_id =
																	(SELECT max(time_Id)
																	  FROM  tmf_awc tmf_awc3
																	  WHERE tmf_awc3.claim_no = tmf_awc1.claim_no 
																			AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID)
																AND tmf_awc2.[group] <> tmf_awc1.[group]
														) 
										AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID 
										AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1 
										AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 											
										)
			,Projection = (SELECT   ISNULL(sum(Projection), 0)
								FROM	dbo.TMF_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'team' 
										AND Unit_Name = tmf_awc.Unit 
										AND year(Time_Id) = Year(tmf_awc.Time_Id) 
										AND month(Time_Id)= month(tmf_awc.Time_Id))
	FROM    dbo.udf_TMF_AWC_Generate_Time_ID('team','1-2') TMF_AWC
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Weekly_Open_1_2.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Weekly_Open_3_5.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Weekly_Open_3_5')
	DROP VIEW [dbo].[uv_TMF_AWC_Weekly_Open_3_5]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Weekly_Open_3_5] 
AS	
---TMF---
SELECT  [Type] = 'TMF'
		,Unit = 'TMF'
		,[Primary] = 'TMF'
		,WeeklyType = '3-5'
		,Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2)
		,Actual = (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                        FROM          TMF_AWC tmf_awc1
                        WHERE      tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                               Year(tmf_awc1.Date_of_injury) BETWEEN Year(tmf_awc.Time_ID) - 4 AND Year(tmf_awc.Time_ID) - 2
                                               AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC)
                                                
                                                     )
		,Projection =  (SELECT ISNULL(sum(Projection), 0)
							FROM	dbo.TMF_AWC_Projections
							WHERE   [Type] = '3-5' AND Unit_Type = 'TMF' 										 
									AND year(Time_Id) = Year(tmf_awc.Time_Id) 
									AND month(Time_Id)= month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('tmf','3-5') TMF_AWC
	
UNION ALL
--Agency--
SELECT     [Type] = 'agency', Unit = RTRIM(Unit), [Primary] = RTRIM([Primary]), WeeklyType = '3-5', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) BETWEEN Year(tmf_awc.Time_ID) - 4 AND Year(tmf_awc.Time_ID) - 2
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
                                                    
                                                )
                , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '3-5' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) = RTRIM(tmf_awc.[Primary]) AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','3-5') TMF_AWC

--Agency Police & Fire--
UNION ALL
SELECT     [Type] = 'agency', Unit = 'Police & Fire', [Primary] = 'Police & Fire', WeeklyType = '3-5', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      RTRIM(AgencyName) in ('Police', 'Fire') AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) BETWEEN Year(tmf_awc.Time_ID) - 4 AND Year(tmf_awc.Time_ID) - 2
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC)
                                                    )
                , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '3-5' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) in ('Police', 'Fire') AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','3-5') TMF_AWC
WHERE   RTRIM([Primary]) = 'Police'
		
--Agency Health & Other--
UNION ALL
SELECT     [Type] = 'agency', Unit = 'Health & Other', [Primary] = 'Health & Other', WeeklyType = '3-5', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      RTRIM(AgencyName) in ('Health','Other') AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) BETWEEN Year(tmf_awc.Time_ID) - 4 AND Year(tmf_awc.Time_ID) - 2
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
                                                   
                                                    )
                , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '3-5' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) in ('Health','Other') AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','3-5') TMF_AWC
WHERE   RTRIM([Primary]) = 'Health'


UNION ALL
SELECT     [Type] = 'group', Unit = RTRIM(Unit), [Primary] = RTRIM([Primary]), WeeklyType = '3-5', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2) 
                      AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      RTRIM([Group]) = RTRIM(tmf_awc.Unit) AND NOT EXISTS
                                                       (SELECT     1
                                                         FROM          tmf_awc tmf_awc2
                                                         WHERE      tmf_awc2.claim_no = tmf_awc1.claim_no AND tmf_awc2.time_id =
                                                                                    (SELECT     max(time_Id)
                                                                                      FROM          tmf_awc tmf_awc3
                                                                                      WHERE      tmf_awc3.claim_no = tmf_awc1.claim_no AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND 
                                                                                                             tmf_awc.Time_ID) AND tmf_awc2.[group] <> tmf_awc1.[group]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
                                                   tmf_awc.Time_ID) AND tmf_awc.Time_ID AND Year(tmf_awc1.Date_of_injury) BETWEEN Year(tmf_awc.Time_ID) - 4 AND Year(tmf_awc.Time_ID) - 2
                                                    AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
                                                    )
                                                     , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '3-5' AND Unit_Type = 'group' AND RTRIM(Unit_Name) = RTRIM(tmf_awc.Unit) AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('group','3-5') TMF_AWC

UNION ALL
SELECT     [Type] = 'sub_category', Unit = Unit, [Primary] = RTRIM([Primary]), WeeklyType = '3-5', Time_Id, LEFT(datename(month, Time_Id), 3) 
                      + '- ' + RIGHT(datename(year, Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      Sub_Category = tmf_awc.Unit AND RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
                                                   tmf_awc.Time_ID) AND tmf_awc.Time_ID AND Year(tmf_awc1.Date_of_injury) BETWEEN Year(tmf_awc.Time_ID) - 4 AND Year(tmf_awc.Time_ID) - 2
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
                                                    )
                                                    , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '3-5' AND Unit_Type = 'sub_category' AND Unit_Name = tmf_awc.Unit AND year(Time_Id) = Year(tmf_awc.Time_Id) AND 
                                                   month(Time_Id) = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('sub_category','3-5') TMF_AWC

UNION ALL
SELECT     [Type] = 'team', Unit = Unit, [Primary] = RTRIM([Primary]), WeeklyType = '3-5', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2) 
                      AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      Team = TMF_AWC.Unit 
									   AND [Group] = TMF_AWC.[Primary]
										AND NOT EXISTS
                                                       (SELECT     1
                                                         FROM          tmf_awc tmf_awc2
                                                         WHERE      tmf_awc2.claim_no = tmf_awc1.claim_no AND tmf_awc2.time_id =
                                                                                    (SELECT     max(time_Id)
                                                                                      FROM          tmf_awc tmf_awc3
                                                                                      WHERE      tmf_awc3.claim_no = tmf_awc1.claim_no AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND 
                                                                                                             tmf_awc.Time_ID) AND tmf_awc2.[group] <> tmf_awc1.[group]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
                                                   tmf_awc.Time_ID) AND tmf_awc.Time_ID AND Year(tmf_awc1.Date_of_injury) BETWEEN Year(tmf_awc.Time_ID) - 4 AND Year(tmf_awc.Time_ID) - 2
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
                                                    )
                                                         
                                                         , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '3-5' AND Unit_Type = 'team' AND Unit_Name = tmf_awc.Unit AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('sub_category','3-5') TMF_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Weekly_Open_3_5.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Weekly_Open_5_Plus.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Weekly_Open_5_Plus')
	DROP VIEW [dbo].[uv_TMF_AWC_Weekly_Open_5_Plus]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Weekly_Open_5_Plus] 
AS 
SELECT  [Type] = 'TMF'
		,Unit = 'TMF'
		,[Primary] = 'TMF'
		,WeeklyType = '5-plus'
		,Time_Id
		,Month_Year = LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2)
		,Actual = 
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM         TMF_AWC tmf_awc1
                            WHERE       tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
                                                   )
		,Projection =  (SELECT ISNULL(sum(Projection), 0)
							FROM	dbo.TMF_AWC_Projections
							WHERE   [Type] = '5-plus' AND Unit_Type = 'TMF' 										 
									AND year(Time_Id) = Year(tmf_awc.Time_Id) 
									AND month(Time_Id)= month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('tmf','5-plus') TMF_AWC
	
UNION ALL
--Agency--
SELECT     [Type] = 'agency', Unit = RTRIM(Unit), [Primary] = RTRIM([Primary]), WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4  
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	                                                  
                                                        )
                        , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) = RTRIM(tmf_awc.[Primary]) AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','5-plus') TMF_AWC

--Agency Police & Fire--
UNION ALL 
SELECT     [Type] = 'agency', Unit = 'Police & Fire', [Primary] = 'Police & Fire', WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      RTRIM(AgencyName) in ('Police','Fire') AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4    
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	                                                
                                            )
                        , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) in ('Police','Fire') AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','5-plus') TMF_AWC
WHERE   RTRIM([Primary]) = 'Police'
		
--Agency Health & Other--
UNION ALL 
SELECT     [Type] = 'agency', Unit = 'Health & Other', [Primary] = 'Health & Other', WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      RTRIM(AgencyName) in ('Health','Other') AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4  
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	                                                  
                                             )
                        , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) in ('Health','Other') AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','5-plus') TMF_AWC
WHERE   RTRIM([Primary]) = 'Health'

UNION ALL
SELECT     [Type] = 'group', Unit = RTRIM(Unit), [Primary] = RTRIM([Primary]), WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2) 
                      AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      RTRIM([Group]) = RTRIM(tmf_awc.Unit) AND NOT EXISTS
                                                       (SELECT     1
                                                         FROM          tmf_awc tmf_awc2
                                                         WHERE      tmf_awc2.claim_no = tmf_awc1.claim_no AND tmf_awc2.time_id =
                                                                                    (SELECT     max(time_Id)
                                                                                      FROM          tmf_awc tmf_awc3
                                                                                      WHERE      tmf_awc3.claim_no = tmf_awc1.claim_no AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND 
                                                                                                             tmf_awc.Time_ID) AND tmf_awc2.[group] <> tmf_awc1.[group]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
                                                   tmf_awc.Time_ID) AND tmf_awc.Time_ID AND Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4 
                                                  AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	 
                                                )
                                , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'group' AND RTRIM(Unit_Name) = RTRIM(tmf_awc.Unit) AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('group','5-plus') TMF_AWC

UNION ALL
SELECT     [Type] = 'sub_category', Unit = Unit, [Primary] = RTRIM([Primary]), WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) 
                      + '- ' + RIGHT(datename(year, Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE      Sub_Category = tmf_awc.Unit AND RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
                                                   tmf_awc.Time_ID) AND tmf_awc.Time_ID AND Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4 
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
                                                    )
                                    , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'sub_category' AND Unit_Name = tmf_awc.Unit AND year(Time_Id) = Year(tmf_awc.Time_Id) AND 
                                                   month(Time_Id) = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('sub_category','5-plus') TMF_AWC

UNION ALL
SELECT     [Type] = 'team', Unit = Unit, [Primary] = RTRIM([Primary]), WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2) 
                      AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1
                            WHERE       Team = TMF_AWC.Unit 
										AND [Group] = TMF_AWC.[Primary]
										AND NOT EXISTS
                                                       (SELECT     1
                                                         FROM          tmf_awc tmf_awc2
                                                         WHERE      tmf_awc2.claim_no = tmf_awc1.claim_no AND tmf_awc2.time_id =
                                                                                    (SELECT     max(time_Id)
                                                                                      FROM          tmf_awc tmf_awc3
                                                                                      WHERE      tmf_awc3.claim_no = tmf_awc1.claim_no AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND 
                                                                                                             tmf_awc.Time_ID) AND tmf_awc2.[group] <> tmf_awc1.[group]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
                                                   tmf_awc.Time_ID) AND tmf_awc.Time_ID AND Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4 
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	
                                                 )
                                                , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'team' AND Unit_Name = tmf_awc.Unit AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('team','5-plus') TMF_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Weekly_Open_5_Plus.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Whole_TMF.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Whole_TMF')
	DROP VIEW [dbo].[uv_TMF_AWC_Whole_TMF]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Whole_TMF] 
AS
	-----TMF------	
	SELECT  [UnitType] = 'TMF'
			,Unit = 'TMF'
			,[Primary] = 'TMF'
			,Transaction_Year = year(tmf_awc.Transaction_Date)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
				  FROM         TMF_AWC tmf_awc1
				  WHERE     tmf_awc1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  tmf_awc)) 
							AND year(Date_of_Injury) = year(tmf_awc.Transaction_Date))
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('tmf') TMF_AWC

	UNION ALL ----Projection----	
	SELECT  [UnitType] = 'TMF'
			,Unit = 'TMF'
			,[Primary] = 'TMF'
			,Transaction_Year = Year(tmf_awc.Transaction_Date)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
										isnull(
											(SELECT TOP 1 Projection
												FROM   dbo.TMF_AWC_Projections
												WHERE  [Type] = 'Whole-TMF' AND Unit_Type = 'TMF' 
														AND RTRIM(Unit_Name) = 'TMF'
														AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 
												ORDER BY time_id DESC	
											 )
										, 0)
	FROM  dbo.udf_Whole_TMF_Generate_Years('tmf') TMF_AWC
	-----End TMF------
	
	-----Agency------
	UNION ALL
	SELECT  [UnitType] = 'agency'
			,Unit = tmf_awc.Unit
			,[Primary] = tmf_awc.[Primary]
			,Transaction_Year = Year(tmf_awc.Transaction_Date)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
				  FROM         TMF_AWC tmf_awc1
				  WHERE     RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) 
							AND tmf_awc1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  tmf_awc)) 
							AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC
	
	UNION ALL ----Projection----
	SELECT  [UnitType] = 'agency'
			,Unit = Unit
			,[Primary] = [Primary]
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
				isnull(
					(SELECT top 1 Projection
						FROM   dbo.TMF_AWC_Projections
						WHERE [Type] = 'Whole-TMF' AND Unit_Type = 'agency' 
							AND RTRIM(Unit_Name) = RTRIM(tmf_awc.[Primary])							
							AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 
						ORDER BY time_id DESC							
					)
				, 0)
	FROM   dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC	
	
	--Agency Police & Fire--
	UNION ALL
	SELECT  [UnitType] = 'agency'
			,Unit = 'Police & Fire'
			,[Primary] = 'Police & Fire'
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
				  FROM         TMF_AWC tmf_awc1
				  WHERE     RTRIM(AgencyName) in ('Police','Fire')
							AND tmf_awc1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  tmf_awc)) 
							AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC
	WHERE	RTRIM([Primary]) = 'Police'

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'agency'
			,Unit = 'Police & Fire'
			,[Primary] = 'Police & Fire'
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
				isnull(
					(SELECT top 1 Projection
						FROM   dbo.TMF_AWC_Projections
						WHERE [Type] = 'Whole-TMF' AND Unit_Type = 'agency' 
							AND RTRIM(Unit_Name) in ('Police', 'Fire')							
							AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 
						ORDER BY time_id DESC							
					)
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC
	WHERE	RTRIM([Primary])  = 'Police'
	
	--Agency Health & Other--
	UNION ALL
	SELECT  [UnitType] = 'agency'
			,Unit = 'Health & Other'
			,[Primary] = 'Health & Other'
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
				  FROM         TMF_AWC tmf_awc1
				  WHERE     RTRIM(AgencyName) in ('Health','Other')
							AND tmf_awc1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  tmf_awc)) 
							AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC
	WHERE	RTRIM([Primary]) = 'Health'

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'agency'
			,Unit = 'Health & Other'
			,[Primary] = 'Health & Other'
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
				isnull(
					(SELECT top 1 Projection
						FROM   dbo.TMF_AWC_Projections
						WHERE [Type] = 'Whole-TMF' AND Unit_Type = 'agency' 
							AND RTRIM(Unit_Name) in ('Health','Other')						
							AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 	
						ORDER BY time_id DESC							
					)
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC
	WHERE	RTRIM([Primary]) = 'Health'
	-----End Agency------

	-----Group------
	UNION ALL
	SELECT	[UnitType] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT tmf_awc1.claim_no)
					  FROM  TMF_AWC tmf_awc1
					  WHERE RTRIM([Group]) = RTRIM(tmf_awc.[Primary]) 
							AND tmf_awc1.time_id >= dateadd(mm, - 2,
								(SELECT     max(time_id) FROM tmf_awc)) 
							AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
					, 0)
	FROM     dbo.udf_Whole_TMF_Generate_Years('group')   TMF_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'group'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Date) 
			,[Type] = 'Projection' 
			,No_of_Active_Weekly_Claims = isnull(
					(SELECT     top 1 Projection
						FROM    dbo.TMF_AWC_Projections
						WHERE   [Type] = 'Whole-TMF' AND Unit_Type = 'group' 
								AND RTRIM(Unit_Name) = RTRIM(tmf_awc.Unit)								
								AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 
						ORDER BY time_id DESC	
					)
					, 0)
	FROM     dbo.udf_Whole_TMF_Generate_Years('group') TMF_AWC
	-----End Group------
	
	-----Sub Category------
	UNION ALL
	SELECT  [UnitType] = 'sub_category'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Date)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
					(SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
					  FROM         TMF_AWC tmf_awc1
					  WHERE     RTRIM(Sub_Category) = RTRIM(tmf_awc.Unit)
								AND RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) 
								AND tmf_awc1.time_id >= dateadd(mm, - 2,
									(SELECT max(time_id) FROM tmf_awc)) 
								AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
					, 0)
	FROM     dbo.udf_Whole_TMF_Generate_Years('sub_category') TMF_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'sub_category'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Year(Transaction_Date) AS Transaction_Year
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.TMF_AWC_Projections
					  WHERE [Type] = 'Whole-TMF' AND Unit_Type = 'sub_category' 
							AND RTRIM(Unit_Name) = RTRIM(tmf_awc.Unit)							
							AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 
					  ORDER BY time_id DESC	
					)
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('sub_category') TMF_AWC
	---End Sub category---
	
	---Team---
	UNION ALL
	SELECT  [UnitType] = 'team'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Actual'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   COUNT(DISTINCT tmf_awc1.claim_no)
					  FROM  TMF_AWC tmf_awc1
					  WHERE RTRIM(Team) = RTRIM(TMF_AWC.Unit) 
							AND RTRIM([Group]) = RTRIM(TMF_AWC.[Primary])
							AND tmf_awc1.time_id >= dateadd(mm, - 2,(SELECT max(time_id) FROM tmf_awc)) 
							AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
					, 0)
	FROM     dbo.udf_Whole_TMF_Generate_Years('team') TMF_AWC
	
	UNION ALL
	SELECT  [UnitType] = 'team'
			,Unit = RTRIM(Unit)
			,[Primary] = RTRIM([Primary])
			,Transaction_Year =Year(Transaction_Date)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = isnull(
				  (SELECT   top 1 Projection
					  FROM  dbo.TMF_AWC_Projections
					  WHERE [Type] = 'Whole-TMF' AND Unit_Type = 'team' 
								AND RTRIM(Unit_Name) = RTRIM(tmf_awc.Unit)								
								AND Time_Id = DATEADD(month,- 1,TMF_AWC.Transaction_Date) 
					  ORDER BY time_id DESC	
					)
				 , 0)
	FROM     dbo.udf_Whole_TMF_Generate_Years('team') TMF_AWC

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Whole_TMF.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_CPR_Weekly_Open.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_CPR_Weekly_Open')
	DROP VIEW [dbo].[uv_TMF_CPR_Weekly_Open]
GO
CREATE VIEW [dbo].[uv_TMF_CPR_Weekly_Open]
AS
	WITH temp AS
	(	
		-- For monthly in one year
		SELECT	DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0) AS Start_Date
				,DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()) + 1, 0)) + '23:59' AS End_Date
				,13 AS iMonth
		UNION ALL
		SELECT DATEADD(m, -1, Start_Date), DATEADD(d, -1, Start_Date) + '23:59', iMonth - 1
		FROM temp WHERE End_Date > DATEADD(m, -11, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
	)
	
	--TMF--
	select  [UnitType] = 'TMF'
			,Unit = 'TMF'
			,[Primary] = 'TMF'
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y')
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	--End TMF--
	
	UNION ALL
	
	--Agency--
	select  [UnitType] = 'agency'
			,Unit = tmp_value.Value
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join 
	(
		SELECT DISTINCT Value
			FROM [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
			WHERE Value <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Agency--
	
	UNION ALL
	
	--Agency Police & Fire--
	select  [UnitType] = 'agency'
			,Unit = 'Police & Fire'
			,[Primary] = 'Police & Fire'
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value in ('Police','Fire'))
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value in ('Police','Fire'))
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value in ('Police','Fire'))
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	--End Agency Police & Fire--
	
	UNION ALL
	
	--Agency Health & Other--
	select  [UnitType] = 'agency'
			,Unit = 'Health & Other'
			,[Primary] = 'Health & Other'
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value in ('Health','Other'))
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value in ('Health','Other'))
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value in ('Health','Other'))
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	--End Agency Health & Other--
	
	UNION ALL
	
	--Group--
	select  [UnitType] = 'group'
			,Unit = tmp_value.Value
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('TMF', 'group', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join 
	(
		SELECT DISTINCT Value
			FROM [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
			WHERE Value <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Group--
	
	UNION ALL
	
	--Sub Category--
	select  [UnitType] = 'sub_category'
			,Unit = tmp_value.SubValue
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join 
	(
		SELECT DISTINCT SubValue, Value
			FROM [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
			WHERE Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue, Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Sub Category--
	
	UNION ALL
	
	--Team--
	select  [UnitType] = 'team'
			,Unit = tmp_value.SubValue
			,[Primary] = tmp_value.Value
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('TMF', 'group', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and Value = tmp_value.Value
											and SubValue = tmp_value.SubValue)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join
	(
		SELECT DISTINCT SubValue, Value
			FROM [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
			WHERE Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue, Value
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Team--
	
	UNION ALL
	
	--Claim Officer
	select  [UnitType] = 'claim_officer'
			,Unit = tmp_value.SubValue2
			,[Primary] = tmp_value.SubValue
			,uv_ClaimType.ClaimType
			,temp.iMonth
			,Month_Year = LEFT(DATENAME(MONTH, temp.Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, temp.Start_Date), 2)
			,temp.Start_Date
			,temp.End_Date
			,No_Of_Port_Claims =
					CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM	[dbo].[udf_CPR_Overall]('TMF', 'group', 0)
									WHERE	Date_Claim_Received between temp.Start_Date	and temp.End_Date
											and SubValue = tmp_value.SubValue
											and SubValue2 = tmp_value.SubValue2)
						WHEN uv_ClaimType.ClaimType = 'open_claims'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
									WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < temp.End_Date)
											and (Date_Claim_Reopened is null or Date_Claim_Reopened < temp.End_Date)
											and Claim_Closed_Flag <> 'Y'
											and SubValue = tmp_value.SubValue
											and SubValue2 = tmp_value.SubValue2)
						WHEN uv_ClaimType.ClaimType = 'claim_closures'
							THEN
								(SELECT     COUNT(distinct Claim_No)
									FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
									WHERE   Date_Claim_Closed between temp.Start_Date and temp.End_Date
											and SubValue = tmp_value.SubValue
											and SubValue2 = tmp_value.SubValue2)
						ELSE 0
					END
	from temp
	cross join
	(
		SELECT 'new_claims' as ClaimType
		UNION
		SELECT 'open_claims' as ClaimType
		UNION
		SELECT 'claim_closures' as ClaimType
	) as uv_ClaimType
	cross join
	(
		SELECT DISTINCT SubValue2, SubValue
			FROM [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
			WHERE SubValue <> '' and SubValue2 <> '' and Claim_Closed_Flag <> 'Y'
			GROUP BY SubValue2, SubValue
			HAVING COUNT(*) > 0
	) as tmp_value
	--End Claim Officer
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_CPR_Weekly_Open.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current')
	DROP VIEW [dbo].[uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current] 
AS
	--Agency---	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,'TMF' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency','TMF',NULL,Measure),0)	
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,rtrim(AgencyName) as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency',rtrim(AgencyName),NULL,Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by AgencyName,Measure, Remuneration_Start, Remuneration_End
	
	--Agency Police & Fire
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,'POLICE & FIRE' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency','Police & Fire',NULL,Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM(AgencyName) in ('Police','Fire')

	group by Measure, Remuneration_Start, Remuneration_End
	
	--Agency Health & Other
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,'HEALTH & OTHER' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency','Health & Other',NULL,Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM(AgencyName) in ('Health','Other')

	group by Measure, Remuneration_Start, Remuneration_End
	
	---Group---
	union all
	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='group'
			,'TMF' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','group','TMF',NULL,Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,Remuneration_Start, Remuneration_End
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='group'
			,rtrim([Group]) as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','group',rtrim([Group]),NULL,Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Measure,Remuneration_Start, Remuneration_End	
	
	union all 
	select  Month_period
			,[type]
			,Agency_Group
			,Measure_months
			,LT
			,WGT
			,AVGDURN
			,[Target]
			from dbo.udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group()
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous')
	DROP VIEW [dbo].[uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous] 
AS
	--Agency---
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,'TMF' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,rtrim(AgencyName) as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by AgencyName,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	
	
	--Agency Police & Fire--
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,'POLICE & FIRE' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM(AgencyName) in ('Police','Fire')
	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	--Agency Health & Other--
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,'HEALTH & OTHER' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM(AgencyName) in ('Health','Other')
	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	---Group---
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='group'
			,'TMF' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='group'
			,rtrim([Group]) as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Rolling_Month_1.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_TMF_RTW_Agency_Group_Rolling_Month_1
IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Agency_Group_Rolling_Month_1')
	DROP VIEW [dbo].[uv_TMF_RTW_Agency_Group_Rolling_Month_1]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Agency_Group_Rolling_Month_1] 
AS

SELECT     rtrim(uv.[Group]) as Agency_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],NULL,uv.Measure)
						
FROM         dbo.TMF_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY  uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     rtrim(uv.AgencyName) as Agency_Group
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency',uv.AgencyName,NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency',uv.AgencyName,NULL,uv.Measure)					 
FROM         dbo.TMF_RTW uv 
			where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY  uv.AgencyName, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Police & Fire--
UNION ALL

SELECT     'POLICE & FIRE' as Agency_Group
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','Police & Fire',NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','Police & Fire',NULL,uv.Measure)					 
FROM         dbo.TMF_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		and RTRIM(AgencyName) in ('Police','Fire')
GROUP BY  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Health & Other--
UNION ALL

SELECT     'HEALTH & OTHER' as Agency_Group
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','Health & Other',NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','Health & Other',NULL,uv.Measure)					 
FROM         dbo.TMF_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		and RTRIM(AgencyName) in ('Health','Other')
GROUP BY  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure


UNION ALL
SELECT     'TMF' AS Agency_Group
			, [Type] = 'group'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			, Measure AS Measure_months
			, SUM(t.LT) AS LT
            , SUM(t.WGT) AS WGT
			, SUM(LT) / SUM(WGT) AS AVGDURN			
			, [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(t.Remuneration_End,'target','group','TMF',NULL,t.Measure)
			, Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(t.Remuneration_End,'base','group','TMF',NULL,t.Measure)
            
            
FROM         tmf_rtw t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 0
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     'TMF' AS Agency_Group
			, [Type] = 'agency'
			,t.Remuneration_Start
			,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			, Measure AS Measure_months
			, SUM(t.LT) AS LT
            , SUM(t.WGT) AS WGT
			, SUM(LT) / SUM(WGT) AS AVGDURN
			
			, [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(t.Remuneration_End,'target','agency','TMF',NULL,t.Measure)
			, Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(t.Remuneration_End,'base','agency','TMF',NULL,t.Measure)
            
            
FROM         tmf_rtw t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 0
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Rolling_Month_1.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Rolling_Month_12.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_TMF_RTW_Agency_Group_Rolling_Month_12
IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Agency_Group_Rolling_Month_12')
	DROP VIEW [dbo].[uv_TMF_RTW_Agency_Group_Rolling_Month_12]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Agency_Group_Rolling_Month_12] 
AS

SELECT    Agency_Group = rtrim(uv.[Group])
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) 
          
          ,Measure_months = Measure 
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],NULL,uv.Measure)
						
FROM      dbo.TMF_RTW uv 

WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
		  and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)

GROUP BY  uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     Agency_Group = rtrim(uv.AgencyName)
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency',uv.AgencyName,NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency',uv.AgencyName,NULL,uv.Measure)					 
FROM         dbo.TMF_RTW uv 
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY  uv.AgencyName, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Police & Fire--
UNION ALL

SELECT     Agency_Group = 'POLICE & FIRE'
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','Police & Fire',NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','Police & Fire',NULL,uv.Measure)					 
FROM         dbo.TMF_RTW uv 
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
			and RTRIM(AgencyName) in ('Police','Fire')
GROUP BY  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Health & Other--
UNION ALL

SELECT     Agency_Group = 'HEALTH & OTHER'
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','Health & Other',NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','Health & Other',NULL,uv.Measure)					 
FROM         dbo.TMF_RTW uv 
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
			and RTRIM(AgencyName) in ('Health','Other')
GROUP BY  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL
SELECT     Agency_Group ='TMF'
			,[Type] = 'group'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			, Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months = Measure
			,LT= SUM(t.LT)
            ,WGT= SUM(t.WGT)
			,AVGDURN= SUM(LT) / SUM(WGT)			
			,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(t.Remuneration_End,'target','group','TMF',NULL,t.Measure)
			,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(t.Remuneration_End,'base','group','TMF',NULL,t.Measure)

FROM         tmf_rtw t 
inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end

UNION ALL

SELECT     Agency_Group= 'TMF'
			,[Type] = 'agency'
			,t.Remuneration_Start
		    ,t.Remuneration_End
			,Remuneration = cast(year(t .Remuneration_End) AS varchar) + 'M' + CASE WHEN MONTH(t .Remuneration_End) 
                      <= 9 THEN '0' ELSE '' END + cast(month(t .Remuneration_End) AS varchar)                      
			,Measure_months= Measure
			,LT = SUM(t.LT)  
            ,WGT =SUM(t.WGT)  
			,AVGDURN =SUM(LT) / SUM(WGT)  			
			,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(t.Remuneration_End, 'target','agency','TMF',NULL,t.Measure)
			,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(t.Remuneration_End,'base','agency','TMF',NULL,t.Measure)

FROM         tmf_rtw t inner join (SELECT     dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) - 23, 0))) + '23:59' AS Remuneration_End
                       FROM          master.dbo.spt_values
                       WHERE      'P' = type AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) - 23, 0))) + '23:59' <= (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)) u on t.Remuneration_End = u.Remuneration_End
AND     DATEDIFF(MM, t .remuneration_start, t .remuneration_end) = 11
GROUP BY  t .Measure, t .remuneration_start, t .remuneration_end


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Rolling_Month_12.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Raw_Data.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Raw_Data')
	DROP VIEW [dbo].[uv_TMF_RTW_Raw_Data]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Raw_Data] 
AS
	SELECT  Claim_Closed_flag
			,Remuneration_Start
			,Remuneration_End
			,Measure_months = Measure
			,[Group] = RTRIM([group])
			,Team
			,Sub_Category = RTRIM(Sub_Category)
			,Case_manager
			,Agency = RTRIM(AgencyName)
			,rtw.Claim_no
			,DTE_OF_INJURY 
			,rtw.POLICY_NO
			,LT= ROUND(LT, 2)
			,WGT=ROUND(WGT, 2)
			,EMPL_SIZE
			,Weeks_from_date_of_injury= DATEDIFF(week, DTE_OF_INJURY, Remuneration_End)
			,Weeks_paid= ROUND(Weeks_paid, 2)
			,Stress
			,Liability_Status
			,cost_code
			,cost_code2
			,Cert_Type
			,Med_cert_From
			,Med_cert_To
			,rtw.Account_Manager
			,rtw.Cell_no
			,rtw.Portfolio
	
	FROM dbo.TMF_RTW rtw
	WHERE remuneration_End = (SELECT max(remuneration_End) FROM  dbo.TMF_RTW)
		 AND  DATEDIFF(month, Remuneration_Start, Remuneration_End) + 1 =12  
		 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Raw_Data.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current')
	DROP VIEW [dbo].[uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current] 
AS
	--Agency---		
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,rtrim(AgencyName) as Agency_Group
			,rtrim(Sub_Category) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency',rtrim(AgencyName),rtrim(Sub_Category),Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by AgencyName,Sub_Category,Measure,Remuneration_Start, Remuneration_End
	
	--Agency Police & Fire--
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,'Police & Fire' as Agency_Group
			,rtrim(Sub_Category) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency','Police & Fire',rtrim(Sub_Category),Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM(AgencyName) in ('Police','Fire')
	group by Sub_Category,Measure,Remuneration_Start, Remuneration_End
	
	--Agency Health & Other--
	union all
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,'Health & Other' as Agency_Group
			,rtrim(Sub_Category) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency','Health & Other',rtrim(Sub_Category),Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM(AgencyName) in ('Health','Other')
	group by Sub_Category,Measure,Remuneration_Start, Remuneration_End
	
	---Group---
	union all 	
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='group'
			,rtrim([Group]) as Agency_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','group',rtrim([Group]),rtrim(Team),Measure),0)
	from tmf_rtw uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Team,Measure,Remuneration_Start, Remuneration_End

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous')
	DROP VIEW [dbo].[uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous] 
AS
	--Agency---		
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,rtrim(AgencyName) as Agency_Group
			,rtrim(Sub_Category) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by AgencyName,Sub_Category,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)		
		
	--Agency Police & Fire--
	Union All
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,'Police & Fire' as Agency_Group
			,rtrim(Sub_Category) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM(AgencyName) in ('Police','Fire') 

	group by Sub_Category,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)		
	
	--Agency Health & Other--
	Union All
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='agency'
			,'Health & Other' as Agency_Group
			,rtrim(Sub_Category) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and RTRIM(AgencyName) in ('Health','Other') 

	group by Sub_Category,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	
		
	---Group---
	union all 
	select Month_period=case when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 0
							then 1
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 2
							then 3
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 5
							then 6
						 when DATEDIFF(MM, Remuneration_Start, Remuneration_End) = 11
							then 12
					end
			,[type]='group'
			,rtrim([Group]) as Agency_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by [Group],Team,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Team_Sub_Rolling_Month_1.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_TMF_RTW_Team_Sub_Rolling_Month_1
IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Team_Sub_Rolling_Month_1')
	DROP VIEW [dbo].[uv_TMF_RTW_Team_Sub_Rolling_Month_1]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Team_Sub_Rolling_Month_1] 
AS

SELECT     rtrim(uv.Team) as Team_Sub
			, uv.[Group] as Agency_Group
			,[Type] = 'group'
			,uv.Remuneration_Start
			,uv.Remuneration_End
			,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
			,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
			,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],uv.Team,uv.Measure)									
			, Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],uv.Team,uv.Measure)
						
FROM         dbo.TMF_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY uv.Team, uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT    rtrim(uv.Sub_category) as Team_Sub
		  , uv.AgencyName  Agency_Group
		  ,[Type] = 'agency' 
		  ,uv.Remuneration_Start
		  , uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency',uv.AgencyName,uv.Sub_category,uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency',uv.AgencyName,uv.Sub_category,uv.Measure)					 
FROM         dbo.TMF_RTW uv 
			where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY uv.Sub_category, uv.AgencyName, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Police & Fire--
UNION ALL

SELECT    rtrim(uv.Sub_category) as Team_Sub
		  , 'Police & Fire' as Agency_Group
		  ,[Type] = 'agency' 
		  ,uv.Remuneration_Start
		  , uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','Police & Fire',uv.Sub_category,uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','Police & Fire',uv.Sub_category,uv.Measure)					 
FROM         dbo.TMF_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	  and RTRIM(AgencyName) in ('Police','Fire') 
GROUP BY uv.Sub_category,  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Health & Other--
UNION ALL

SELECT    rtrim(uv.Sub_category) as Team_Sub
		  , 'Health & Other' as Agency_Group
		  ,[Type] = 'agency' 
		  ,uv.Remuneration_Start
		  , uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','Health & Other',uv.Sub_category,uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','Health & Other',uv.Sub_category,uv.Measure)					 
FROM         dbo.TMF_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	  and RTRIM(AgencyName) in ('Health','Other') 
GROUP BY uv.Sub_category, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Team_Sub_Rolling_Month_1.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Team_Sub_Rolling_Month_12.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from uv_TMF_RTW_Team_Sub_Rolling_Month_12
IF EXISTS(select * FROM sys.views where name = 'uv_TMF_RTW_Team_Sub_Rolling_Month_12')
	DROP VIEW [dbo].[uv_TMF_RTW_Team_Sub_Rolling_Month_12]
GO
CREATE VIEW [dbo].[uv_TMF_RTW_Team_Sub_Rolling_Month_12] 
AS

SELECT     rtrim(uv.Team) as Team_Sub
		  ,rtrim(uv.[Group]) as  Agency_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration        
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',uv.[Group],uv.Team,uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',uv.[Group],uv.Team,uv.Measure)
						
FROM         dbo.TMF_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY uv.Team, uv.[Group], uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT    rtrim(uv.Sub_category) as  Team_Sub
		 ,uv.AgencyName as  Agency_Group
		 ,[Type] = 'agency' 
		 ,uv.Remuneration_Start
		 , uv.Remuneration_End
		 ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency',uv.AgencyName,uv.Sub_category,uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency',uv.AgencyName,uv.Sub_category,uv.Measure)					 
FROM         dbo.TMF_RTW uv 
			where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY uv.Sub_category, uv.AgencyName, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Police & Fire--
UNION ALL

SELECT    rtrim(uv.Sub_category) as  Team_Sub
		 ,'Police & Fire' as  Agency_Group
		 ,[Type] = 'agency' 
		 ,uv.Remuneration_Start
		 , uv.Remuneration_End
		 ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','Police & Fire',uv.Sub_category,uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','Police & Fire', uv.Sub_category,uv.Measure)					 
FROM         dbo.TMF_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	  and RTRIM(AgencyName) in ('Police','Fire') 
GROUP BY uv.Sub_category, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure
--Agency Health & Other--
UNION ALL

SELECT    rtrim(uv.Sub_category) as  Team_Sub
		 ,'Health & Other' as  Agency_Group
		 ,[Type] = 'agency' 
		 ,uv.Remuneration_Start
		 , uv.Remuneration_End
		 ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','Health & Other',uv.Sub_category,uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','Health & Other',uv.Sub_category,uv.Measure)					 
FROM         dbo.TMF_RTW uv 
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	  and RTRIM(AgencyName) in ('Health','Other') 
GROUP BY uv.Sub_category, uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Team_Sub_Rolling_Month_12.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_AWC_Agency_Group_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Agency_Group_Summary')
	DROP VIEW [dbo].[uv_EML_AWC_Agency_Group_Summary]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Agency_Group_Summary] 
AS
SELECT	top 1	EmployerSize_Group ='WCNSW'
				,[Type]='employer_size'
				,No_Of_Active_Weekly_Claims=                
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'group')  AND (Type = 'Actual'))
                ,Projection =       
						 100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'group')  AND (Type = 'Actual'))
						 /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'group') AND (Type = 'Projection')),0) 
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))

UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM(ISNULL(Empl_Size, 'Miscellaneous')) 
				,[Type]='employer_size'
				,No_Of_Active_Weekly_Claims =
						(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'employer_size') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
                ,Projection =
						100*(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'employer_size') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
                        /NULLIF((SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
							FROM   dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
							WHERE      (UnitType = 'employer_size') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
GROUP BY RTRIM(ISNULL(Empl_Size, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Empl_Size, 'Miscellaneous'))


UNION ALL
SELECT top 1000 EmployerSize_Group = RTRIM(ISNULL([Group], 'Miscellaneous'))
				,[Type]='group'
				,No_Of_Active_Weekly_Claims =
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Actual'))
                ,Projection = 
						  100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Actual'))
                          /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
GROUP BY RTRIM(ISNULL([Group], 'Miscellaneous'))
ORDER BY RTRIM(ISNULL([Group], 'Miscellaneous'))

UNION ALL
SELECT top 1000 EmployerSize_Group = RTRIM([Account_Manager])
				,[Type]='account_manager'
				,No_Of_Active_Weekly_Claims =
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'account_manager') AND (Unit = RTRIM(dbo.EML_AWC.[Account_Manager])) AND (Type = 'Actual'))
                ,Projection = 
						  100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'account_manager') AND (Unit = RTRIM(dbo.EML_AWC.[Account_Manager])) AND (Type = 'Actual'))
                          /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'account_manager') AND (Unit = RTRIM(dbo.EML_AWC.[Account_Manager])) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
           and [Account_Manager] is not null
GROUP BY [Account_Manager]
ORDER BY [Account_Manager]

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_AWC_Agency_Group_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_AWC_Team_Sub_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Team_Sub_Summary')
	DROP VIEW [dbo].[uv_EML_AWC_Team_Sub_Summary]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Team_Sub_Summary] 
AS

SELECT  top 1000000   
		   [Type] ='group'
		   ,EmployerSize_Group = RTRIM(ISNULL([Group], 'Miscellaneous'))
		   ,Team_Sub = RTRIM(ISNULL(Team, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_EML_AWC_Whole_EML
                    WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Team, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_EML_AWC_Whole_EML
                    WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Team, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Team, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
GROUP BY RTRIM(ISNULL([Group], 'Miscellaneous')), RTRIM(ISNULL(Team, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Team, 'Miscellaneous'))

union all

SELECT  top 1000000   
		   [Type] ='account_manager'
		   ,EmployerSize_Group = RTRIM([Account_Manager])
		   ,Team_Sub = RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_EML_AWC_Whole_EML
                    WHERE      (UnitType = 'am_empl_size') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_EML_AWC_Whole_EML
                    WHERE      (UnitType = 'am_empl_size') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'am_empl_size') AND (Unit = RTRIM(ISNULL(dbo.EML_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
           and RTRIM([Account_Manager]) is not null
GROUP BY RTRIM([Account_Manager]), RTRIM(ISNULL(Empl_Size, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Empl_Size, 'Miscellaneous'))

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_AWC_Team_Sub_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_AWC_Weekly_Open.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Weekly_Open')
	DROP VIEW [dbo].[uv_EML_AWC_Weekly_Open]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Weekly_Open] 
AS
	select * from [dbo].[uv_EML_AWC_Weekly_Open_1_2] 
	union select * from [dbo].[uv_EML_AWC_Weekly_Open_3_5]
	union select * from [dbo].[uv_EML_AWC_Weekly_Open_5_Plus]
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_AWC_Weekly_Open.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_CPR_Agency_Group_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_CPR_Agency_Group_Summary')
	DROP VIEW [dbo].[uv_EML_CPR_Agency_Group_Summary]
GO
CREATE VIEW [dbo].[uv_EML_CPR_Agency_Group_Summary]
AS
SELECT	top 1	EmployerSize_Group = 'WCNSW'
				,[Type] = 'employer_size'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	EML_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)

UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM(Empl_Size)
				,[Type] = 'employer_size'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = Empl_Size)
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = Empl_Size)
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('EML', 'employer_size', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = Empl_Size)
FROM	EML_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY Empl_Size
ORDER BY Empl_Size

UNION ALL

SELECT top 1 EmployerSize_Group = 'WCNSW'
				,[Type] = 'group'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('EML', 'group', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	EML_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)

UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM([Group])
				,[Type] = 'group'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('EML', 'group', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Group])
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = [Group])
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Group])
FROM	EML_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Group]
ORDER BY [Group]

UNION ALL

SELECT top 1 EmployerSize_Group = 'WCNSW'
				,[Type] = 'account_manager'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	EML_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)
		and [Account_Manager] is not null
		
UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM([Account_Manager])
				,[Type] = 'account_manager'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Account_Manager])
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = [Account_Manager])
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Account_Manager])
FROM	EML_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)
		and [Account_Manager] is not null
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Account_Manager]
ORDER BY [Account_Manager]
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_CPR_Agency_Group_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_CPR_ClaimOfficer_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_CPR_ClaimOfficer_Summary')
	DROP VIEW [dbo].[uv_EML_CPR_ClaimOfficer_Summary]
GO
CREATE VIEW [dbo].[uv_EML_CPR_ClaimOfficer_Summary]
AS
SELECT		top 1000000
			[Type] = 'group'
			,EmployerSize_Group = RTRIM([Group])
			,Team_Sub = RTRIM(Team)
			,ClaimOfficer = RTRIM(Claims_Officer_Name)
            ,No_Of_New_Claims = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM	[dbo].[udf_CPR_Overall]('EML', 'group', 0)
       --             WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Group]
							--and SubValue = Team
							--and SubValue2 = Claims_Officer_Name)
            ,No_Of_Open_Claims =
                (SELECT     COUNT(distinct Claim_No)
                    FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and Claim_Closed_Flag <> 'Y'
							and Value = [Group]
							and SubValue = Team
							and SubValue2 = Claims_Officer_Name)
            ,No_Of_Claim_Closures = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
       --             WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Group]
							--and SubValue = Team
							--and SubValue2 = Claims_Officer_Name)
FROM	EML_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Group], Team, Claims_Officer_Name
ORDER BY Claims_Officer_Name
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_CPR_ClaimOfficer_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_CPR_Team_Sub_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_CPR_Team_Sub_Summary')
	DROP VIEW [dbo].[uv_EML_CPR_Team_Sub_Summary]
GO
CREATE VIEW [dbo].[uv_EML_CPR_Team_Sub_Summary] 
AS
SELECT		top 1000000
			[Type] = 'group'
			,EmployerSize_Group = RTRIM([Group])
			,Team_Sub = rtrim(Team)
            ,No_Of_New_Claims = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM	[dbo].[udf_CPR_Overall]('EML', 'group', 0)
       --             WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Group]
							--and SubValue = Team)
            ,No_Of_Open_Claims =
                (SELECT     COUNT(distinct Claim_No)
                    FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and Claim_Closed_Flag <> 'Y'
							and Value = [Group]
							and SubValue = Team)
            ,No_Of_Claim_Closures = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM    [dbo].[udf_CPR_Overall]('EML', 'group', 0)
       --             WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Group]
							--and SubValue = Team)
FROM	EML_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Group], Team
ORDER BY Team

UNION ALL

SELECT		top 1000000
			[Type] = 'account_manager'
			,EmployerSize_Group = RTRIM([Account_Manager])
			,Team_Sub = rtrim(EMPL_SIZE)
            ,No_Of_New_Claims = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM	[dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
       --             WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Account_Manager]
							--and SubValue = EMPL_SIZE)
            ,No_Of_Open_Claims =
                (SELECT     COUNT(distinct Claim_No)
                    FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and Claim_Closed_Flag <> 'Y'
							and Value = [Account_Manager]
							and SubValue = EMPL_SIZE)
            ,No_Of_Claim_Closures = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM    [dbo].[udf_CPR_Overall]('EML', 'account_manager', 0)
       --             WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Account_Manager]
							--and SubValue = EMPL_SIZE)
FROM	EML_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)
        and RTRIM([Account_Manager]) is not null
        and Claim_Closed_Flag <> 'Y'
GROUP BY [Account_Manager], Empl_Size
ORDER BY Empl_Size
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_CPR_Team_Sub_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_AWC_Agency_Group_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_AWC_Agency_Group_Summary')
	DROP VIEW [dbo].[uv_HEM_AWC_Agency_Group_Summary]
GO
CREATE VIEW [dbo].[uv_HEM_AWC_Agency_Group_Summary] 
AS
SELECT	top 1	EmployerSize_Group ='Hospitality'
				,[Type]='portfolio'
				,No_Of_Active_Weekly_Claims=                
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'group')  AND (Type = 'Actual'))
                ,Projection =       
						 100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'group')  AND (Type = 'Actual'))
						 /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'group') AND (Type = 'Projection')),0) 
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))

UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM(ISNULL(Portfolio, 'Miscellaneous'))
				,[Type]='portfolio'
				,No_Of_Active_Weekly_Claims =
						(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'portfolio') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Portfolio, 'Miscellaneous'))) AND (Type = 'Actual'))
                ,Projection =
						100*(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'portfolio') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Portfolio, 'Miscellaneous'))) AND (Type = 'Actual'))
                        /NULLIF((SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
							FROM   dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
							WHERE      (UnitType = 'portfolio') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Portfolio, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
GROUP BY RTRIM(ISNULL(Portfolio, 'Miscellaneous')) 
ORDER BY RTRIM(ISNULL(Portfolio, 'Miscellaneous'))

--Portfolio Hotel summary--
UNION ALL

SELECT top 1 EmployerSize_Group = 'Hotel'
				,[Type]='portfolio'
				,No_Of_Active_Weekly_Claims =
						(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'portfolio') AND (Unit in ('Accommodation','Pubs, Taverns and Bars')) AND (Type = 'Actual'))
                ,Projection =
						100*(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'portfolio') AND (Unit in ('Accommodation','Pubs, Taverns and Bars')) AND (Type = 'Actual'))
                        /NULLIF((SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
							FROM   dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
							WHERE      (UnitType = 'portfolio') AND (Unit in ('Accommodation','Pubs, Taverns and Bars')) AND (Type = 'Projection')),0)		
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))     

UNION ALL
SELECT top 1000 EmployerSize_Group = RTRIM(ISNULL([Group], 'Miscellaneous'))
				,[Type]='group'
				,No_Of_Active_Weekly_Claims =
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Actual'))
                ,Projection = 
						  100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Actual'))
                          /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
GROUP BY RTRIM(ISNULL([Group], 'Miscellaneous'))
ORDER BY RTRIM(ISNULL([Group], 'Miscellaneous'))

UNION ALL
SELECT top 1000 EmployerSize_Group = RTRIM([Account_Manager])
				,[Type]='account_manager'
				,No_Of_Active_Weekly_Claims =
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'account_manager') AND (Unit = RTRIM(dbo.HEM_AWC.[Account_Manager])) AND (Type = 'Actual'))
                ,Projection = 
						  100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'account_manager') AND (Unit = RTRIM(dbo.HEM_AWC.[Account_Manager])) AND (Type = 'Actual'))
                          /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'account_manager') AND (Unit = RTRIM(dbo.HEM_AWC.[Account_Manager])) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
           and [Account_Manager] is not null
GROUP BY [Account_Manager]
ORDER BY [Account_Manager]

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_AWC_Agency_Group_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_AWC_Team_Sub_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_AWC_Team_Sub_Summary')
	DROP VIEW [dbo].[uv_HEM_AWC_Team_Sub_Summary]
GO
CREATE VIEW [dbo].[uv_HEM_AWC_Team_Sub_Summary] 
AS

SELECT  top 1000000   
		   [Type] ='group'
		   ,EmployerSize_Group = RTRIM(ISNULL([Group], 'Miscellaneous'))
		   ,Team_Sub = RTRIM(ISNULL(Team, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Team, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Team, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Team, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
GROUP BY RTRIM(ISNULL([Group], 'Miscellaneous')), RTRIM(ISNULL(Team, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Team, 'Miscellaneous'))

union all

SELECT  top 1000000   
		   [Type] ='account_manager'
		   ,EmployerSize_Group = RTRIM([Account_Manager])
		   ,Team_Sub = RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims = 
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'am_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'am_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'am_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
           and RTRIM([Account_Manager]) is not null
GROUP BY RTRIM([Account_Manager]), RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))

union all

SELECT  top 1000000   
		   [Type] ='portfolio'
		   ,EmployerSize_Group = RTRIM([Portfolio])
		   ,Team_Sub = RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'portfolio_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'portfolio_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'portfolio_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
           and RTRIM([portfolio]) is not null
GROUP BY RTRIM([portfolio]), RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))

--Portfolio Hotel Summay--
union all

SELECT  top 1000000   
		   [Type] ='portfolio'
		   ,EmployerSize_Group = 'Hotel'
		   ,Team_Sub = RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'portfolio_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                    FROM          dbo.uv_HEM_AWC_Whole_HEM
                    WHERE      (UnitType = 'portfolio_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'portfolio_empl_size') AND (Unit = RTRIM(ISNULL(dbo.HEM_AWC.Empl_Size, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
           and RTRIM([portfolio]) is not null
           and RTRIM([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')
GROUP BY RTRIM([portfolio]), RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(EMPL_SIZE, 'Miscellaneous'))

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_AWC_Team_Sub_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_AWC_Weekly_Open.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_AWC_Weekly_Open')
	DROP VIEW [dbo].[uv_HEM_AWC_Weekly_Open]
GO
CREATE VIEW [dbo].[uv_HEM_AWC_Weekly_Open] 
AS
	select * from [dbo].[uv_HEM_AWC_Weekly_Open_1_2] 
	union select * from [dbo].[uv_HEM_AWC_Weekly_Open_3_5]
	union select * from [dbo].[uv_HEM_AWC_Weekly_Open_5_Plus]
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_AWC_Weekly_Open.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_CPR_Agency_Group_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_CPR_Agency_Group_Summary')
	DROP VIEW [dbo].[uv_HEM_CPR_Agency_Group_Summary]
GO
CREATE VIEW [dbo].[uv_HEM_CPR_Agency_Group_Summary]
AS
SELECT	top 1	EmployerSize_Group = 'Hospitality'
				,[Type] = 'portfolio'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)

UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM(Portfolio)
				,[Type] = 'portfolio'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = Portfolio)
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = Portfolio)
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = Portfolio)
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY Portfolio 
ORDER BY Portfolio

--Portfolio Hotel summary--
UNION ALL

SELECT top 1 EmployerSize_Group = 'Hotel'
				,[Type] = 'portfolio'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value in ('Accommodation','Pubs, Taverns and Bars'))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value in ('Accommodation','Pubs, Taverns and Bars'))
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value in ('Accommodation','Pubs, Taverns and Bars'))
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)

UNION ALL

SELECT top 1 EmployerSize_Group = 'Hospitality'
				,[Type] = 'group'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'group', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)

UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM([Group])
				,[Type] = 'group'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'group', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Group])
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = [Group])
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Group])
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Group]
ORDER BY [Group]

UNION ALL

SELECT top 1 EmployerSize_Group = 'Hospitality'
				,[Type] = 'account_manager'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
        and [Account_Manager] is not null

UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM([Account_Manager])
				,[Type] = 'account_manager'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Account_Manager])
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = [Account_Manager])
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Account_Manager])
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
        and [Account_Manager] is not null
        and Claim_Closed_Flag <> 'Y'
GROUP BY [Account_Manager]
ORDER BY [Account_Manager]
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_CPR_Agency_Group_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_CPR_ClaimOfficer_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_CPR_ClaimOfficer_Summary')
	DROP VIEW [dbo].[uv_HEM_CPR_ClaimOfficer_Summary]
GO
CREATE VIEW [dbo].[uv_HEM_CPR_ClaimOfficer_Summary]
AS
SELECT		top 1000000
			[Type] = 'group'
			,EmployerSize_Group = RTRIM([Group])
			,Team_Sub = RTRIM(Team)
			,ClaimOfficer = RTRIM(Claims_Officer_Name)
            ,No_Of_New_Claims = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM	[dbo].[udf_CPR_Overall]('HEM', 'group', 0)
       --             WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Group]
							--and SubValue = Team
							--and SubValue2 = Claims_Officer_Name)
            ,No_Of_Open_Claims =
                (SELECT     COUNT(distinct Claim_No)
                    FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and Claim_Closed_Flag <> 'Y'
							and Value = [Group]
							and SubValue = Team
							and SubValue2 = Claims_Officer_Name)
            ,No_Of_Claim_Closures = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
       --             WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Group]
							--and SubValue = Team
							--and SubValue2 = Claims_Officer_Name)
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Group], Team, Claims_Officer_Name
ORDER BY Claims_Officer_Name
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_CPR_ClaimOfficer_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_CPR_Team_Sub_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_CPR_Team_Sub_Summary')
	DROP VIEW [dbo].[uv_HEM_CPR_Team_Sub_Summary]
GO
CREATE VIEW [dbo].[uv_HEM_CPR_Team_Sub_Summary] 
AS
SELECT		top 1000000
			[Type] = 'group'
			,EmployerSize_Group = RTRIM([Group])
			,Team_Sub = rtrim(Team)
            ,No_Of_New_Claims = 0
        --            (SELECT     COUNT(distinct Claim_No)
        --                FROM	[dbo].[udf_CPR_Overall]('HEM', 'group', 0)
        --                WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and Value = [Group]
								--and SubValue = Team)
            ,No_Of_Open_Claims =
                    (SELECT     COUNT(distinct Claim_No)
                        FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
                        WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
								and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
								and Claim_Closed_Flag <> 'Y'
								and Value = [Group]
								and SubValue = Team)
            ,No_Of_Claim_Closures = 0
        --            (SELECT     COUNT(distinct Claim_No)
        --                FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
        --                WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and Value = [Group]
								--and SubValue = Team)
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Group], Team
ORDER BY Team

UNION ALL

SELECT		top 1000000
			[Type] = 'account_manager'
			,EmployerSize_Group = RTRIM([Account_Manager])
			,Team_Sub = rtrim(EMPL_SIZE)
			,No_Of_New_Claims = 0
        --            (SELECT     COUNT(distinct Claim_No)
        --                FROM	[dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
        --                WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and Value = [Account_Manager]
								--and SubValue = EMPL_SIZE)
            ,No_Of_Open_Claims =
                    (SELECT     COUNT(distinct Claim_No)
                        FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
                        WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
								and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
								and Claim_Closed_Flag <> 'Y'
								and Value = [Account_Manager]
								and SubValue = EMPL_SIZE)
            ,No_Of_Claim_Closures = 0
        --            (SELECT     COUNT(distinct Claim_No)
        --                FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
        --                WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and Value = [Account_Manager]
								--and SubValue = EMPL_SIZE)
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
        and RTRIM([Account_Manager]) is not null
        and Claim_Closed_Flag <> 'Y'
GROUP BY [Account_Manager], Empl_Size
ORDER BY Empl_Size

UNION ALL

SELECT		top 1000000
			[Type] = 'portfolio'
			,EmployerSize_Group = RTRIM([Portfolio])
			,Team_Sub = rtrim(EMPL_SIZE)
			,No_Of_New_Claims = 0
        --            (SELECT     COUNT(distinct Claim_No)
        --                FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
        --                WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and Value = [Portfolio]
								--and SubValue = EMPL_SIZE)
            ,No_Of_Open_Claims =
                    (SELECT     COUNT(distinct Claim_No)
                        FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
                        WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
								and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
								and Claim_Closed_Flag <> 'Y'
								and Value = [Portfolio]
								and SubValue = EMPL_SIZE)
            ,No_Of_Claim_Closures = 0
        --            (SELECT     COUNT(distinct Claim_No)
        --                FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
        --                WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and Value = [Portfolio]
								--and SubValue = EMPL_SIZE)
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
        and RTRIM([portfolio]) is not null
        and Claim_Closed_Flag <> 'Y'
GROUP BY [portfolio], Empl_Size
ORDER BY Empl_Size

--Uncomment this section to active the combine grouping logic--
----Portfolio Hotel Summay--
--UNION ALL

--SELECT		top 1000000   
--			[Type] = 'portfolio'
--			,EmployerSize_Group = 'Hotel'
--			,Team_Sub = rtrim(EMPL_SIZE)
--			,No_Of_New_Claims =
--                    (SELECT     COUNT(distinct Claim_No)
--                        FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
--                        WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--								and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--								and Value in ('Accommodation','Pubs, Taverns and Bars')
--								and SubValue = EMPL_SIZE)
--            ,No_Of_Open_Claims =
--                    (SELECT     COUNT(distinct Claim_No)
--                        FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
--                        WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
--								and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
--								and Claim_Closed_Flag <> 'Y'
--								and Value in ('Accommodation','Pubs, Taverns and Bars')
--								and SubValue = EMPL_SIZE)
--            ,No_Of_Claim_Closures =
--                    (SELECT     COUNT(distinct Claim_No)
--                        FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
--                        WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--								and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--								and Value in ('Accommodation','Pubs, Taverns and Bars')
--								and SubValue = EMPL_SIZE)
--FROM	HEM_Portfolio
--WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
--        and RTRIM([portfolio]) is not null
--        and RTRIM([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')
--GROUP BY [portfolio], Empl_Size
--ORDER BY Empl_Size
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_CPR_Team_Sub_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_AWC_Agency_Group_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Agency_Group_Summary')
	DROP VIEW [dbo].[uv_TMF_AWC_Agency_Group_Summary]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Agency_Group_Summary] 
AS
SELECT   top 1  Agency_Group= 'TMF'
				,[Type]='agency'
                ,No_Of_Active_Weekly_Claims =
                        (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'group')  AND (Type = 'Actual'))
                ,Projection =
						 100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'group')  AND (Type = 'Actual')) 
						/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'group') AND (Type = 'Projection')),0)                       
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
UNION ALL

SELECT  top 1000 Agency_Group = RTRIM(ISNULL(AgencyName, 'Miscellaneous'))
				,[Type]='agency'
                ,No_Of_Active_Weekly_Claims =				
					      (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.AgencyName, 'Miscellaneous'))) AND (Type = 'Actual'))
                ,Projection = 
						100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.AgencyName, 'Miscellaneous'))) AND (Type = 'Actual'))
						/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'agency') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.AgencyName, 'Miscellaneous'))) AND (Type = 'Projection')),0)
                        
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY RTRIM(ISNULL(AgencyName, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(AgencyName, 'Miscellaneous'))

UNION ALL

--Agency Police & Fire--
SELECT  top 1 Agency_Group = 'POLICE & FIRE' 
				,[Type]='agency'
                ,No_Of_Active_Weekly_Claims =				
					      (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit in ('Police','Fire')) AND (Type = 'Actual'))
                ,Projection = 
						100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit in ('Police','Fire')) AND (Type = 'Actual'))
						/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'agency') AND (Unit in ('Police','Fire')) AND (Type = 'Projection')),0)
                        
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))

UNION ALL
--Agency Health & Other--
SELECT  top 1 Agency_Group = 'HEALTH & OTHER'
				,[Type]='agency'
                ,No_Of_Active_Weekly_Claims =				
					      (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit in ('Health','Other')) AND (Type = 'Actual'))
                ,Projection = 
						100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit in ('Health','Other')) AND (Type = 'Actual'))
						/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'agency') AND (Unit in ('Health','Other')) AND (Type = 'Projection')),0)
                        
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))

UNION ALL
SELECT top 1000 Agency_Group = RTRIM(ISNULL([Group], 'Miscellaneous'))
				,[Type]='group'
                ,No_Of_Active_Weekly_Claims =
						(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Actual'))
                ,Projection =                        
                        100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Actual'))
                        /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'group') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.[Group], 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY RTRIM(ISNULL([Group], 'Miscellaneous'))
ORDER BY CASE IsNumeric(RTRIM(ISNULL([Group],'Miscellaneous')))
			WHEN 1 THEN Replicate('0', 100 - Len(RTRIM(ISNULL([Group],'Miscellaneous')))) + RTRIM(ISNULL([Group],'Miscellaneous'))
			ELSE RTRIM(ISNULL([Group],'Miscellaneous')) 
		 END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_AWC_Agency_Group_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_AWC_Team_Sub_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Team_Sub_Summary')
	DROP VIEW [dbo].[uv_TMF_AWC_Team_Sub_Summary]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Team_Sub_Summary] 
AS

SELECT   top 1000000  
		   [Type] ='agency'
		   ,Agency_Group = RTRIM(ISNULL(AgencyName, 'Miscellaneous'))
		   ,Team_Sub = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))
           ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
						FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
						WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Sub_Category, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous')), RTRIM(ISNULL(AgencyName, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))

--Agency Police & Fire--
UNION ALL
SELECT   top 1000000  
		   [Type] ='agency'
		   ,Agency_Group = 'Police & Fire'
		   ,Team_Sub = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))
           ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
						FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
						WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Sub_Category, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
           AND RTRIM(AgencyName) in ('Police','Fire')	
GROUP BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous')), RTRIM(AgencyName)
ORDER BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))

--Agency Health & Other--
UNION ALL
SELECT   top 1000000  
		   [Type] ='agency'
		   ,Agency_Group = 'Health & Other'
		   ,Team_Sub = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))
           ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
						FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
						WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Sub_Category, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
           AND RTRIM(AgencyName) in ('Health','Other')	
GROUP BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous')), RTRIM(AgencyName)
ORDER BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))

UNION ALL
SELECT  top 1000000   
		   [Type] ='group'
		   ,Agency_Group = RTRIM(ISNULL([Group], 'Miscellaneous'))
		   ,Team_Sub = RTRIM(ISNULL(Team, 'Miscellaneous'))
		   ,No_Of_Active_Weekly_Claims =
					(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Team, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
					100*(SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Team, 'Miscellaneous'))) AND (Type = 'Actual'))
					/NULLIF((SELECT SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'team') AND (Unit = RTRIM(ISNULL(dbo.TMF_AWC.Team, 'Miscellaneous'))) AND (Type = 'Projection')),0) 
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY RTRIM(ISNULL([Group], 'Miscellaneous')), RTRIM(ISNULL(Team, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Team, 'Miscellaneous'))
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_AWC_Team_Sub_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_AWC_Weekly_Open.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Weekly_Open')
	DROP VIEW [dbo].[uv_TMF_AWC_Weekly_Open]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Weekly_Open] 
AS
	select * from [dbo].[uv_TMF_AWC_Weekly_Open_1_2] 
	union select * from [dbo].[uv_TMF_AWC_Weekly_Open_3_5]
	union select * from [dbo].[uv_TMF_AWC_Weekly_Open_5_Plus]
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_AWC_Weekly_Open.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_CPR_Agency_Group_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_CPR_Agency_Group_Summary')
	DROP VIEW [dbo].[uv_TMF_CPR_Agency_Group_Summary]
GO
CREATE VIEW [dbo].[uv_TMF_CPR_Agency_Group_Summary]
AS
SELECT   top 1  Agency_Group = 'TMF'
				,[Type] = 'agency'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)

UNION ALL

SELECT  top 1000 Agency_Group = RTRIM(Agency_Name)
				,[Type] = 'agency'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = Agency_Name)
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = Agency_Name)
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = Agency_Name)
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY Agency_Name
ORDER BY Agency_Name

UNION ALL

--Agency Police & Fire--
SELECT  top 1 Agency_Group = 'POLICE & FIRE'
				,[Type] = 'agency'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value in ('Police','Fire'))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value in ('Police','Fire'))
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value in ('Police','Fire'))
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)

UNION ALL

--Agency Health & Other--
SELECT  top 1 Agency_Group = 'HEALTH & OTHER'
				,[Type] = 'agency'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value in ('Health','Other'))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value in ('Health','Other'))
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value in ('Health','Other'))
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)

UNION ALL

SELECT top 1 Agency_Group = 'TMF'
				,[Type] = 'group'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'group', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		 
UNION ALL
		 
SELECT top 1000 Agency_Group = RTRIM([Group])
				,[Type] = 'group'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'group', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Group])
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = [Group])
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Group])
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Group]
ORDER BY CASE IsNumeric([Group]) 
			WHEN 1 THEN Replicate('0', 100 - Len([Group])) + [Group]
			ELSE [Group] 
		 END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_CPR_Agency_Group_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_CPR_ClaimOfficer_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_CPR_ClaimOfficer_Summary')
	DROP VIEW [dbo].[uv_TMF_CPR_ClaimOfficer_Summary]
GO
CREATE VIEW [dbo].[uv_TMF_CPR_ClaimOfficer_Summary]
AS
SELECT		top 1000000
			[Type] = 'group'
			,Agency_Group = RTRIM([Group])
			,Team_Sub = RTRIM(Team)
			,ClaimOfficer = RTRIM(Claims_Officer_Name)
            ,No_Of_New_Claims = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM	[dbo].[udf_CPR_Overall]('TMF', 'group', 0)
       --             WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Group]
							--and SubValue = Team
							--and SubValue2 = Claims_Officer_Name)
            ,No_Of_Open_Claims =
                (SELECT     COUNT(distinct Claim_No)
                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and Claim_Closed_Flag <> 'Y'
							and Value = [Group]
							and SubValue = Team
							and SubValue2 = Claims_Officer_Name)
            ,No_Of_Claim_Closures = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
       --             WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Group]
							--and SubValue = Team
							--and SubValue2 = Claims_Officer_Name)
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Group], Team, Claims_Officer_Name
ORDER BY Claims_Officer_Name
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_CPR_ClaimOfficer_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_CPR_Team_Sub_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_CPR_Team_Sub_Summary')
	DROP VIEW [dbo].[uv_TMF_CPR_Team_Sub_Summary]
GO
CREATE VIEW [dbo].[uv_TMF_CPR_Team_Sub_Summary]
AS
SELECT		top 1000000
			[Type] = 'agency'
			,Agency_Group = RTRIM(Agency_Name)
			,Team_Sub = rtrim(Sub_Category)
			,No_Of_New_Claims = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
       --             WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = Agency_Name
							--and SubValue = Sub_Category)
            ,No_Of_Open_Claims =
                (SELECT     COUNT(distinct Claim_No)
                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and Claim_Closed_Flag <> 'Y'
							and Value = Agency_Name
							and SubValue = Sub_Category)
            ,No_Of_Claim_Closures = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
       --             WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = Agency_Name
							--and SubValue = Sub_Category)
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY Sub_Category, Agency_Name
ORDER BY Sub_Category

--Uncomment this to active the combine grouping logic--
----Agency Police & Fire--
--UNION ALL

--SELECT		top 1000000
--			[Type] = 'agency'
--			,Agency_Group = 'Police & Fire'
--			,Team_Sub = rtrim(Sub_Category)
--			,No_Of_New_Claims =
--                (SELECT     COUNT(distinct Claim_No)
--                    FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
--                    WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and Value in ('Police','Fire')
--							and SubValue = Sub_Category)
--            ,No_Of_Open_Claims =
--                (SELECT     COUNT(distinct Claim_No)
--                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
--                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
--							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
--							and Claim_Closed_Flag <> 'Y'
--							and Value in ('Police','Fire')
--							and SubValue = Sub_Category)
--            ,No_Of_Claim_Closures =
--                (SELECT     COUNT(distinct Claim_No)
--                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
--                    WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and Value in ('Police','Fire')
--							and SubValue = Sub_Category)
--FROM	TMF_Portfolio
--WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
--        AND RTRIM(Agency_Name) in ('Police','Fire')
--GROUP BY Sub_Category, Agency_Name
--ORDER BY Sub_Category

----Agency Health & Other--
--UNION ALL

--SELECT		top 1000000
--			[Type] = 'agency'
--			,Agency_Group = 'Health & Other'
--			,Team_Sub = rtrim(Sub_Category)
--			,No_Of_New_Claims =
--                (SELECT     COUNT(distinct Claim_No)
--                    FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
--                    WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and Value in ('Health','Other')
--							and SubValue = Sub_Category)
--            ,No_Of_Open_Claims =
--                (SELECT     COUNT(distinct Claim_No)
--                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
--                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
--							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
--							and Claim_Closed_Flag <> 'Y'
--							and Value in ('Health','Other')
--							and SubValue = Sub_Category)
--            ,No_Of_Claim_Closures =
--                (SELECT     COUNT(distinct Claim_No)
--                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
--                    WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and Value in ('Health','Other')
--							and SubValue = Sub_Category)
--FROM	TMF_Portfolio
--WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
--        AND RTRIM(Agency_Name) in ('Health','Other')
--GROUP BY Sub_Category, Agency_Name
--ORDER BY Sub_Category

UNION ALL

SELECT		top 1000000
			[Type] = 'group'
			,Agency_Group = RTRIM([Group])
			,Team_Sub = rtrim(Team)
            ,No_Of_New_Claims = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM	[dbo].[udf_CPR_Overall]('TMF', 'group', 0)
       --             WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Group]
							--and SubValue = Team)
            ,No_Of_Open_Claims =
                (SELECT     COUNT(distinct Claim_No)
                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and Claim_Closed_Flag <> 'Y'
							and Value = [Group]
							and SubValue = Team)
            ,No_Of_Claim_Closures = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
       --             WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Group]
							--and SubValue = Team)
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Group], Team
ORDER BY Team
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_CPR_Team_Sub_Summary.sql  
--------------------------------  
---------------------------------------------------------- 
------------------- StoredProcedure 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\ArrangeLevel_Role.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[sp_ArrangeLevel_Role]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_ArrangeLevel_Role]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_ArrangeLevel_Role]
GO

/****** Object:  StoredProcedure [dbo].[sp_ArrangeLevel_Role]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.usp_GetPaymntFlgCommonLaw    Script Date: 1/17/04 12:27:14 PM ******/
create PROC [dbo].[sp_ArrangeLevel_Role](@data varchar(500),@updatedby int)
AS	
	DECLARE @Item varchar(20)	
	begin try
	BEGIN TRANSACTION trans	
		
		DECLARE cur CURSOR FOR 			
			with cte as
			(
				select 0 a, 1 b
				union all
				select b, charindex(',', @data, b) + len(',')
				from cte
				where b > a
			)
			select substring(@data,a,
			case when b > len(',') then b-a-len(',') else len(@data) - a + 1 end) value      
			from cte where a >0					
		OPEN cur
		FETCH NEXT FROM cur	INTO @Item
		WHILE @@FETCH_STATUS = 0
			BEGIN				
				update Organisation_Levels
				set sort = Convert(int,SUBSTRING(@Item,CHARINDEX('|', @Item)+1,LEN(@Item))),UpdatedBy=@updatedby 
				where LevelId = CONVERT(int,SUBSTRING(@Item, 1, CHARINDEX('|', @Item)-1))
				FETCH NEXT FROM cur INTO @Item  
			END
		CLOSE cur
		DEALLOCATE cur
		COMMIT TRANSACTION trans		
	end try
	begin catch
		ROLLBACK TRANSACTION trans		
	end catch;
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\ArrangeLevel_Role.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\GetUser.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[PRO_Login]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[PRO_GetUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_GetUser]
GO

/****** Object:  StoredProcedure [dbo].[PRO_GetUser]    Script Date: 20/09/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[PRO_GetUser] (@UserName varchar(150)) 
	
AS
BEGIN	
	select UserName, [Password] from dbo.Users where UserName = @UserName and [Status] = 1		
END

GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\GetUser.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\PRO_GetUser.sql  
--------------------------------  

/****** Object:  StoredProcedure [dbo].[PRO_GetUser]    Script Date: 08/13/2014 13:38:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRO_GetUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_GetUser]
GO


/****** Object:  StoredProcedure [dbo].[PRO_GetUser]    Script Date: 08/13/2014 13:38:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PRO_GetUser] (@UserName varchar(150)) 
	
AS
BEGIN	
	select UserName, [Password], [Is_System_User] from dbo.Users where UserName = @UserName or Email = @UserName and [Status] = 1		
END
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\PRO_GetUser.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\PRO_Internal_Login.sql  
--------------------------------  

/****** Object:  StoredProcedure [dbo].[PRO_Internal_Login]    Script Date: 07/03/2014 16:14:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRO_Internal_Login]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_Internal_Login]
GO



/****** Object:  StoredProcedure [dbo].[PRO_Internal_Login]    Script Date: 07/03/2014 16:14:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- exec PRO_Login
CREATE PROCEDURE [dbo].[PRO_Internal_Login] (@Username varchar(150), @NoLimitLoginAttempts int = 3, @NoDaysBlockedAttempts int = 1, @SystemId int)
	
AS
BEGIN
	declare @loginAttempts int;
	declare @UserId int	
	declare @Status_Active smallint
	
	select @Status_Active = statusid from dbo.[Status] where name='Active'
	
	select @UserId =
		u.UserId from Users u left join ReportUsers r on u.UserId=r.UserId left join Organisation_Roles o 
		on r.Organisation_RoleId=o.Organisation_RoleId 
		left join Organisation_Levels ol on o.LevelId=ol.LevelId 
		left join Systems s on s.SystemId=ol.SystemId 
		where u.UserName=@Username and s.SystemId = @SystemId and o.[Status]=@Status_Active 
		and ol.[Status]=@Status_Active and u.[Status]=@Status_Active
	if @UserId >0
		select @UserId
	else if exists(select top 1 UserId,UserName from dbo.Users where UserName=@Username and [Status] = @Status_Active)
		begin						
			select @UserId = UserId from dbo.Users where UserId =(select top 1 userid from dbo.Users where UserName=@Username and [Status] = @Status_Active)
			if exists(select UserId from SystemUsers where UserId=@UserId)
				or exists(select UserId from ReportUsers r left join External_Groups e on r.External_GroupId=e.External_GroupId where  Is_External_User = 1 and UserId=@UserId and e.[Status]=@Status_Active)
				or exists(select UserId 
							from ReportUsers r 
								left join Organisation_Roles o on r.Organisation_RoleId=o.Organisation_RoleId 
								left join Organisation_Levels ol on o.LevelId=ol.LevelId 
							where UserId=@UserId and o.[Status]=@Status_Active and ol.[Status]=@Status_Active)
					select @UserId
			else
					select @loginAttempts = ISNULL(Online_No_Of_Login_Attempts, 0) + 1 from Users
						where UserName=@Username
									
					update Users set Online_No_Of_Login_Attempts = @loginAttempts
						where UserName=@Username
					
					if @loginAttempts >= @NoLimitLoginAttempts
					begin
						update Users set [Status] = 2, Online_Locked_Until_Datetime = DATEADD(dd, @NoDaysBlockedAttempts, GETDATE()) 
							where UserName=@Username	
						select -2 -- account has been blocked
					end
					else
						select -1
		end
	else
		begin
			if exists(select top 1 UserId, UserName from dbo.Users where UserName=@Username and [Status] = 2 and Online_Locked_Until_Datetime is not null and Online_Locked_Until_Datetime <= GETDATE())
				begin
					-- unblock user login
					update Users set [Status] = 1, Online_No_Of_Login_Attempts = NULL, Online_Locked_Until_Datetime = NULL
						where UserName=@Username
					
					select UserId from dbo.Users where UserName=@Username
				end
			else if exists(select top 1 UserId, UserName from dbo.Users where UserName=@Username and [Status] = 2 and Online_Locked_Until_Datetime is not null and Online_Locked_Until_Datetime > GETDATE())
				select -2 -- account has been blocking
			else if exists(select top 1 UserId, UserName from dbo.Users where UserName=@Username and [Status] = 1)
			begin
				select @loginAttempts = ISNULL(Online_No_Of_Login_Attempts, 0) + 1 from Users where UserName=@Username
									
				update Users set Online_No_Of_Login_Attempts = @loginAttempts where UserName=@Username
				
				if @loginAttempts >= @NoLimitLoginAttempts
				begin
					update Users set [Status] = 2, Online_Locked_Until_Datetime = DATEADD(dd, @NoDaysBlockedAttempts, GETDATE())where UserName=@Username
					select -2 -- account has been blocked
				end
				else
					select -1 -- wrong password
			end	
			else
				select -1 -- wrong password
		end
	
	--Update Last_Online_Login_Date column if user exist	
	if @UserId > 0
		begin
			update Users set Last_Online_Login_Date = getdate() where UserId = @UserId
		end
END


GO


--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\PRO_Internal_Login.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\PRO_Login.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[PRO_Login]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[PRO_Login]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_Login]
GO

/****** Object:  StoredProcedure [dbo].[PRO_Login]    Script Date: 20/09/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- exec PRO_Login
CREATE PROCEDURE [dbo].[PRO_Login] (@Email varchar(150),@PassWord varchar(300), @NoLimitLoginAttempts int = 3, @NoDaysBlockedAttempts int = 1, @SystemId int)
	
AS
BEGIN
	declare @loginAttempts int;
	declare @UserId int	
	declare @Status_Active smallint
	
	select @Status_Active = statusid from dbo.[Status] where name='Active'
	
	select @UserId =
		u.UserId from Users u left join ReportUsers r on u.UserId=r.UserId left join Organisation_Roles o 
		on r.Organisation_RoleId=o.Organisation_RoleId 
		left join Organisation_Levels ol on o.LevelId=ol.LevelId 
		left join Systems s on s.SystemId=ol.SystemId 
		where u.Email=@Email and [Password]=@Password and s.SystemId = @SystemId and o.[Status]=@Status_Active 
		and ol.[Status]=@Status_Active and u.[Status]=@Status_Active
	if @UserId >0
		select @UserId
	else if exists(select top 1 UserId,Email,[Password] from dbo.Users where Email=@Email and [Password]=@PassWord and [Status] = @Status_Active)
		begin						
			select @UserId = UserId from dbo.Users where UserId =(select top 1 userid from dbo.Users where Email=@Email and [Password]=@PassWord and [Status] = @Status_Active)
			if exists(select UserId from SystemUsers where UserId=@UserId)
				or exists(select UserId from ReportUsers r left join External_Groups e on r.External_GroupId=e.External_GroupId where  Is_External_User = 1 and UserId=@UserId and e.[Status]=@Status_Active)
				or exists(select UserId 
							from ReportUsers r 
								left join Organisation_Roles o on r.Organisation_RoleId=o.Organisation_RoleId 
								left join Organisation_Levels ol on o.LevelId=ol.LevelId 
							where UserId=@UserId and o.[Status]=@Status_Active and ol.[Status]=@Status_Active)
					select @UserId
			else
					select @loginAttempts = ISNULL(Online_No_Of_Login_Attempts, 0) + 1 from Users
						where Email=@Email and [Password]=@PassWord
									
					update Users set Online_No_Of_Login_Attempts = @loginAttempts
						where Email=@Email and [Password]=@PassWord
					
					if @loginAttempts >= @NoLimitLoginAttempts
					begin
						update Users set [Status] = 2, Online_Locked_Until_Datetime = DATEADD(dd, @NoDaysBlockedAttempts, GETDATE()) 
							where Email=@Email and [Password]=@PassWord		
						select -2 -- account has been blocked
					end
					else
						select -1
		end
	else
		begin
			if exists(select top 1 UserId, Email,[Password] from dbo.Users where Email=@Email and [Password]=@PassWord and [Status] = 2 and Online_Locked_Until_Datetime is not null and Online_Locked_Until_Datetime <= GETDATE())
				begin
					-- unblock user login
					update Users set [Status] = 1, Online_No_Of_Login_Attempts = NULL, Online_Locked_Until_Datetime = NULL
						where Email=@Email and [Password]=@PassWord
					
					select UserId from dbo.Users where Email=@Email and [Password]=@PassWord
				end
			else if exists(select top 1 UserId, Email,[Password] from dbo.Users where Email=@Email and [Status] = 2 and Online_Locked_Until_Datetime is not null and Online_Locked_Until_Datetime > GETDATE())
				select -2 -- account has been blocking
			else if exists(select top 1 UserId, Email,[Password] from dbo.Users where Email=@Email and [Password]<>@PassWord and [Status] = 1)
			begin
				select @loginAttempts = ISNULL(Online_No_Of_Login_Attempts, 0) + 1 from Users where Email=@Email
									
				update Users set Online_No_Of_Login_Attempts = @loginAttempts where Email=@Email
				
				if @loginAttempts >= @NoLimitLoginAttempts
				begin
					update Users set [Status] = 2, Online_Locked_Until_Datetime = DATEADD(dd, @NoDaysBlockedAttempts, GETDATE()) where Email=@Email
					select -2 -- account has been blocked
				end
				else
					select -1 -- wrong password
			end	
			else
				select -1 -- wrong password
		end
	
	--Update Last_Online_Login_Date column if user exist	
	if @UserId > 0
		begin
			update Users set Last_Online_Login_Date = getdate() where UserId = @UserId
		end
END
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\PRO_Login.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\Register.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[PRO_Register]    Script Date: 09/23/2013 13:05:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRO_Register]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_Register]
GO

/****** Object:  StoredProcedure [dbo].[PRO_Register]    Script Date: 09/23/2013 13:05:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PRO_Register] (@UserName varchar(150),@PassWord varchar(300),@Email varchar(256),@FirstName nvarchar(256),@LastName nvarchar(256),@Address nvarchar(400),@i_Status int) 
	
AS
BEGIN
	If exists(select UserId from USERs where Email=@Email and Address<>'')
		select -2
	Else If exists(select UserId from USERs where UserName=@UserName)
		select -1
	Else
		Begin
			Insert into USERs (UserName,Password,Email,FirstName,LastName,Address,Status) values(@UserName,@Password,@Email,@FirstName,@LastName,@Address,@i_Status)
			select SCOPE_IDENTITY()
		End
END

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\Register.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\ResetPassword.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[PRO_ResetPassword]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[PRO_ResetPassword]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_ResetPassword]
GO

/****** Object:  StoredProcedure [dbo].[PRO_ResetPassword]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[PRO_ResetPassword] (@UserNameOrEmail varchar(256),@PassWordReset varchar(256)) 
	
AS
BEGIN
	If exists(select UserId from USERs where Email=@UserNameOrEmail)
		begin
			update USERs set Password = @PassWordReset where Email =@UserNameOrEmail
			select userid from Users where Email =@UserNameOrEmail
		end
	Else If exists(select UserId from USERs where UserName=@UserNameOrEmail)
		begin
			update USERs set Password = @PassWordReset where UserName =@UserNameOrEmail
			select userid from Users where UserName =@UserNameOrEmail
		end
	Else
		select -1
END
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\ResetPassword.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\SaveSystemRoles.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[sp_SaveSystemRoles]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SaveSystemRoles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_SaveSystemRoles]
GO

/****** Object:  StoredProcedure [dbo].[sp_SaveSystemRoles]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.usp_GetPaymntFlgCommonLaw    Script Date: 1/17/04 12:27:14 PM ******/
create PROC [dbo].[sp_SaveSystemRoles](@System_RoleId bigint,@Name varchar(256),@Description nvarchar(500),@SystemRoles varchar(500),@UpdatedBy int)
AS	
	DECLARE @Item varchar(20)	
	begin try
	BEGIN TRANSACTION trans
	
		if(exists(select top 1 System_RoleId from System_Roles where System_RoleId=@System_RoleId))
			begin
				update System_Roles set Name=@Name,[Description] =@Description where System_RoleId =@System_RoleId			
				delete from System_Role_Permissions where System_RoleId = @System_RoleId
			end 
		else
			begin
				insert into System_Roles(Name,[Description]) values(@Name,@Description)	
				select @System_RoleId =SCOPE_IDENTITY()
			end 
		
		DECLARE cur CURSOR FOR 			
			with cte as
			(
				select 0 a, 1 b
				union all
				select b, charindex(',', @SystemRoles, b) + len(',')
				from cte
				where b > a
			)
			select substring(@SystemRoles,a,
			case when b > len(',') then b-a-len(',') else len(@SystemRoles) - a + 1 end) value      
			from cte where a >0					
		OPEN cur
		FETCH NEXT FROM cur	INTO @Item
		WHILE @@FETCH_STATUS = 0
			BEGIN				
				insert into System_Role_Permissions(System_RoleId,System_PermissionId,PermissionId,[Status],UpdatedBy) 
				values(@System_RoleId,Convert(bigint,SUBSTRING(@Item, 1,CHARINDEX('_', @Item) - 1)),Convert(bigint,SUBSTRING(@Item, CHARINDEX('_', @Item)+1,CHARINDEX('_', @Item) - 1)),1,@UpdatedBy)				
				FETCH NEXT FROM cur INTO @Item  
			END
		CLOSE cur
		DEALLOCATE cur
		COMMIT TRANSACTION trans
		select 1
	end try
	begin catch
		ROLLBACK TRANSACTION trans
		select -1
	end catch;
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\SaveSystemRoles.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\SetScheduleType.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[PRO_SetScheduleType]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[PRO_SetScheduleType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_SetScheduleType]
GO

/****** Object:  StoredProcedure [dbo].[PRO_SetScheduleType]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery1.sql|0|0|C:\Users\Administrator.ASWLAP08\AppData\Local\Temp\~vs2B93.sql
create proc [dbo].[PRO_SetScheduleType]
	@SubID varchar(50),
	@ScheduleType smallint
as
begin
	update Subscriptions
	set ScheduleType = @ScheduleType
	where SubscriptionID = @SubID
end
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\SetScheduleType.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\SetSubscriptonStatus.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[PRO_SetSubscriptonStatus]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[PRO_SetSubscriptonStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_SetSubscriptonStatus]
GO

/****** Object:  StoredProcedure [dbo].[PRO_SetSubscriptonStatus]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[PRO_SetSubscriptonStatus]
	@SubID varchar(50),
	@Status smallint
as
begin
	declare @scheduleID varchar(50)
	update Subscriptions
	set [Status] = @Status,
		@scheduleID = ScheduleID
	where SubscriptionID = @SubID
	select @scheduleID
end
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\SetSubscriptonStatus.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\Update_OrganisationRole_Level.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[sp_Update_OrganisationRole_Level]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_Update_OrganisationRole_Level]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_Update_OrganisationRole_Level]
GO

/****** Object:  StoredProcedure [dbo].[sp_Update_OrganisationRole_Level]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.usp_GetPaymntFlgCommonLaw    Script Date: 1/17/04 12:27:14 PM ******/
create PROC [dbo].[sp_Update_OrganisationRole_Level](@roleid bigint ,@levelid bigint,@updatedby int)
AS	
	update Organisation_Roles 
	set UpdatedBy = @updatedby
	,LevelId = @levelid
	where Organisation_RoleId = @roleid
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\Update_OrganisationRole_Level.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Dashboard_Period.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Dashboard_Period]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Dashboard_Period]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Dashboard_Period]
(
	@System VARCHAR(10)			-- TMF, EML, HEM
	,@ViewType VARCHAR(20)		-- Agency_Group, Sub_Team, ClaimOfficer
	,@PeriodType VARCHAR(20)	-- last_two_weeks, last_month
)
AS
BEGIN
	DECLARE @Start_Date datetime
	DECLARE @End_Date datetime
	DECLARE @Is_Last_Month bit = 0

	IF LOWER(RTRIM(@PeriodType)) =  'last_month'
	BEGIN
		-- Last month
		SET @Start_Date = DATEADD(m, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0))
		SET @End_Date = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59'
		SET @Is_Last_Month = 1
	END
	ELSE
	BEGIN
		-- default period: Last two weeks: Start = last two weeks from yesterday; End = yesterday
		SET @Start_Date = DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
		SET @End_Date = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	END

	IF UPPER(RTRIM(@ViewType)) = 'AGENCY_GROUP'
	BEGIN
		EXEC('EXEC usp_' + @System + '_CPR_Dashboard_Agency_Group ''' + @Start_Date + ''',''' + @End_Date + ''',' + @Is_Last_Month + '')
	END
	ELSE IF UPPER(RTRIM(@ViewType)) = 'SUB_TEAM'
	BEGIN
		EXEC('EXEC usp_' + @System + '_CPR_Dashboard_Sub_Team ''' + @Start_Date + ''',''' + @End_Date + ''',' + @Is_Last_Month + '')
	END
	ELSE IF UPPER(RTRIM(@ViewType)) = 'CLAIMOFFICER'
	BEGIN
		EXEC('EXEC usp_' + @System + '_CPR_Dashboard_ClaimOfficer ''' + @Start_Date + ''',''' + @End_Date + ''',' + @Is_Last_Month + '')
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Dashboard_Period.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_DART_Index.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_DART_Index]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_DART_Index]
GO

CREATE PROCEDURE [dbo].[usp_DART_Index]
AS
BEGIN
	
-------------------------------------------CPR Index-----------------------------------
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_Portfolio_RAW_Data') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_Portfolio_RAW_Data]
		ON [dbo].[EML_Portfolio] ([Reporting_Date])
		INCLUDE ([Id],[Group],[Team],[Case_Manager],[Agency_Name],[Agency_Id],[Policy_No],[Sub_Category],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claim_No],[WIC_Code],[Company_Name],[Worker_Name],[Employee_Number],[Worker_Phone_Number],[Claims_Officer_Name],[Date_Of_Birth],[Date_Of_Injury],[Date_Of_Notification],[Notification_Lag],[Entered_Lag],[Claim_Liability_Indicator_Group],[Investigation_Incurred],[Total_Paid],[Is_Time_Lost],[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received],[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid],[Acupuncture_Paid],[Create_Date],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt],[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week],[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[Action_Required],[RTW_Impacting],[Weeks_In],[Weeks_Band],[Hindsight],[Active_Weekly],[Active_Medical],[Cost_Code],[Cost_Code2],[CC_Injury],[CC_Current],[Med_Cert_Status_This_Week],[Med_Cert_Status_Next_Week],[Capacity],[Entitlement_Weeks],[Med_Cert_Status_Prev_1_Week],[Med_Cert_Status_Prev_2_Week],[Med_Cert_Status_Prev_3_Week],[Med_Cert_Status_Prev_4_Week],[Is_Last_Month])
	END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_Portfolio_Reporting_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_Portfolio_Reporting_Date]
		ON [dbo].[EML_Portfolio] ([Reporting_Date])
		INCLUDE ([Group],[Team],[Agency_Name],[Sub_Category],[Claim_No],[Claims_Officer_Name],[Date_Of_Injury],
					 [Claim_Liability_Indicator_Group],  
					 [Is_Time_Lost],  
					 [Claim_Closed_Flag],  
					 [Date_Claim_Entered],  
					 [Date_Claim_Closed],  
					 [Date_Claim_Received],  
					 [Date_Claim_Reopened],  
					 [Result_Of_Injury_Code],  
					 [WPI],  
					 [Common_Law],  
					 [Total_Recoveries],  
					 [Is_Working],  
					 [Physio_Paid],  
					 [Chiro_Paid],  
					 [Massage_Paid],  
					 [Osteopathy_Paid],  
					 [Acupuncture_Paid],  
					 [Is_Stress],  
					 [Is_Inactive_Claims],  
					 [Is_Medically_Discharged],  
					 [Is_Exempt],  
					 [Is_Reactive],  
					 [Is_Medical_Only],  
					 [Is_D_D],  
					 [NCMM_Actions_This_Week],  
					 [NCMM_Actions_Next_Week],  
					 [HoursPerWeek],  
					 [Is_Industrial_Deafness],  
					 [Rehab_Paid],
					 [Med_Cert_Status_This_Week],
					 [Is_Last_Month]
		 ) 
			
	END	
	
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_Portfolio_RAW_Data') 
	BEGIN		
		CREATE NONCLUSTERED INDEX [idx_TMF_Portfolio_RAW_Data]
		ON [dbo].[TMF_Portfolio] ([Reporting_Date])
		INCLUDE ([Id],[Group],[Team],[Case_Manager],[Agency_Name],[Agency_Id],[Policy_No],[Sub_Category],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claim_No],[WIC_Code],[Company_Name],[Worker_Name],[Employee_Number],[Worker_Phone_Number],[Claims_Officer_Name],[Date_Of_Birth],[Date_Of_Injury],[Date_Of_Notification],[Notification_Lag],[Entered_Lag],[Claim_Liability_Indicator_Group],[Investigation_Incurred],[Total_Paid],[Is_Time_Lost],[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received],[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid],[Acupuncture_Paid],[Create_Date],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt],[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week],[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[Action_Required],[RTW_Impacting],[Weeks_In],[Weeks_Band],[Hindsight],[Active_Weekly],[Active_Medical],[Cost_Code],[Cost_Code2],[CC_Injury],[CC_Current],[Med_Cert_Status_This_Week],[Med_Cert_Status_Next_Week],[Capacity],[Entitlement_Weeks],[Med_Cert_Status_Prev_1_Week],[Med_Cert_Status_Prev_2_Week],[Med_Cert_Status_Prev_3_Week],[Med_Cert_Status_Prev_4_Week],[Is_Last_Month])
	END	
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_Portfolio_Reporting_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_Portfolio_Reporting_Date]
		ON [dbo].[TMF_Portfolio] ([Reporting_Date])
		INCLUDE ([Group],[Team],[Agency_Name],[Sub_Category],[Claim_No],[Claims_Officer_Name],[Date_Of_Injury],
					 [Claim_Liability_Indicator_Group],  
					 [Is_Time_Lost],  
					 [Claim_Closed_Flag],  
					 [Date_Claim_Entered],  
					 [Date_Claim_Closed],  
					 [Date_Claim_Received],  
					 [Date_Claim_Reopened],  
					 [Result_Of_Injury_Code],  
					 [WPI],  
					 [Common_Law],  
					 [Total_Recoveries],  
					 [Is_Working],  
					 [Physio_Paid],  
					 [Chiro_Paid],  
					 [Massage_Paid],  
					 [Osteopathy_Paid],  
					 [Acupuncture_Paid],  
					 [Is_Stress],  
					 [Is_Inactive_Claims],  
					 [Is_Medically_Discharged],  
					 [Is_Exempt],  
					 [Is_Reactive],  
					 [Is_Medical_Only],  
					 [Is_D_D],  
					 [NCMM_Actions_This_Week],  
					 [NCMM_Actions_Next_Week],  
					 [HoursPerWeek],  
					 [Is_Industrial_Deafness],  
					 [Rehab_Paid],
					 [Med_Cert_Status_This_Week],
					 [Is_Last_Month]
		 ) 
			
	END	
	
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_Portfolio_RAW_Data') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_Portfolio_RAW_Data]
		ON [dbo].[HEM_Portfolio] ([Reporting_Date])
		INCLUDE ([Id],[Group],[Team],[Case_Manager],[Agency_Name],[Agency_Id],[Policy_No],[Sub_Category],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claim_No],[WIC_Code],[Company_Name],[Worker_Name],[Employee_Number],[Worker_Phone_Number],[Claims_Officer_Name],[Date_Of_Birth],[Date_Of_Injury],[Date_Of_Notification],[Notification_Lag],[Entered_Lag],[Claim_Liability_Indicator_Group],[Investigation_Incurred],[Total_Paid],[Is_Time_Lost],[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received],[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid],[Acupuncture_Paid],[Create_Date],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt],[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week],[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[Action_Required],[RTW_Impacting],[Weeks_In],[Weeks_Band],[Hindsight],[Active_Weekly],[Active_Medical],[Cost_Code],[Cost_Code2],[CC_Injury],[CC_Current],[Med_Cert_Status_This_Week],[Med_Cert_Status_Next_Week],[Capacity],[Entitlement_Weeks],[Med_Cert_Status_Prev_1_Week],[Med_Cert_Status_Prev_2_Week],[Med_Cert_Status_Prev_3_Week],[Med_Cert_Status_Prev_4_Week],[Is_Last_Month])
	END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_Portfolio_Reporting_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_Portfolio_Reporting_Date]
		ON [dbo].[HEM_Portfolio] ([Reporting_Date])
		INCLUDE ([Group],[Team],[Agency_Name],[Sub_Category],[Claim_No],[Claims_Officer_Name],[Date_Of_Injury],
					 [Claim_Liability_Indicator_Group],  
					 [Is_Time_Lost],  
					 [Claim_Closed_Flag],  
					 [Date_Claim_Entered],  
					 [Date_Claim_Closed],  
					 [Date_Claim_Received],  
					 [Date_Claim_Reopened],  
					 [Result_Of_Injury_Code],  
					 [WPI],  
					 [Common_Law],  
					 [Total_Recoveries],  
					 [Is_Working],  
					 [Physio_Paid],  
					 [Chiro_Paid],  
					 [Massage_Paid],  
					 [Osteopathy_Paid],  
					 [Acupuncture_Paid],  
					 [Is_Stress],  
					 [Is_Inactive_Claims],  
					 [Is_Medically_Discharged],  
					 [Is_Exempt],  
					 [Is_Reactive],  
					 [Is_Medical_Only],  
					 [Is_D_D],  
					 [NCMM_Actions_This_Week],  
					 [NCMM_Actions_Next_Week],  
					 [HoursPerWeek],  
					 [Is_Industrial_Deafness],  
					 [Rehab_Paid],
					 [Med_Cert_Status_This_Week],
					 [Is_Last_Month]
		 ) 
			
	END	

--------------------------------------------RTW index----------------------------------------
----EML----
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Measure_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Measure_Group] ON [dbo].[EML_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Group] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Measure_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Measure_Acc] ON [dbo].[EML_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Account_Manager] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Measure_EMPL') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Measure_EMPL] ON [dbo].[EML_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[EMPL_Size] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RAW_Data') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_RTW_RAW_Data]
		ON [dbo].[EML_RTW] ([Remuneration_End])
		INCLUDE ([Remuneration_Start],[Group],[Team],[Case_manager],[Claim_no],[DTE_OF_INJURY],[POLICY_NO],[LT],[WGT],[EMPL_SIZE],[Weeks_paid],[AgencyName],[Sub_Category],[Measure],[Cert_Type],[Med_cert_From],[Med_cert_To],[Account_Manager],[Cell_no],[Portfolio],[Stress],[Liability_Status],[cost_code],[cost_code2],[Claim_Closed_flag])
	END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_Acc_RT_Measure_EMPL') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_Acc_RT_Measure_EMPL] ON [dbo].[EML_RTW] 
	(
		[Remuneration_End] ASC,
		[Account_Manager] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[EMPL_SIZE] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_Group_RT_Measure_Team') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_Group_RT_Measure_Team] ON [dbo].[EML_RTW] 
	(
		[Remuneration_End] ASC,
		[Group] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Team] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

---TMF----
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_RS_Measure_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_RS_Measure_Group] ON [dbo].[TMF_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Group] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_RS_Measure_Agency') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_RS_Measure_Agency] ON [dbo].[TMF_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[AgencyName] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RAW_Data')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RAW_Data]
		ON [dbo].[TMF_RTW] ([Remuneration_End])
		INCLUDE ([Remuneration_Start],[Group],[Team],[Case_manager],[Claim_no],[DTE_OF_INJURY],[POLICY_NO],[LT],[WGT],[EMPL_SIZE],[Weeks_paid],[AgencyName],[Sub_Category],[Measure],[Cert_Type],[Med_cert_From],[Med_cert_To],[Account_Manager],[Cell_no],[Portfolio],[Stress],[Liability_Status],[cost_code],[cost_code2],[Claim_Closed_flag])
	END	
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_RS_Measure_Team_Group')
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_RS_Measure_Team_Group] ON [dbo].[TMF_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Team] ASC,
		[Group] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_RS_Measure_Sub_Agency') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_RS_Measure_Sub_Agency] ON [dbo].[TMF_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Sub_Category] ASC,
		[AgencyName] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

----HEM---
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Group] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Group] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Acc] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Account_Manager] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Portfolio') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Portfolio] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RAW_Data') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RAW_Data]
		ON [dbo].[HEM_RTW] ([Remuneration_End])
		INCLUDE ([Remuneration_Start],[Group],[Team],[Case_manager],[Claim_no],[DTE_OF_INJURY],[POLICY_NO],[LT],[WGT],[EMPL_SIZE],[Weeks_paid],[AgencyName],[Sub_Category],[Measure],[Cert_Type],[Med_cert_From],[Med_cert_To],[Account_Manager],[Cell_no],[Portfolio],[Stress],[Liability_Status],[cost_code],[cost_code2],[Claim_Closed_flag])
	END
	
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC
	)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Team_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Team_Group] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Team] ASC,
		[Group] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_EMPL_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_EMPL_Acc] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[EMPL_SIZE] ASC,
		[Account_Manager] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_EMPL_Portfolio') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_EMPL_Portfolio] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[EMPL_SIZE] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]


END

---------------------------------------AWC Index----------------------------------	
---+++EML+++-------
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Group_Time_ID_Claim_No_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Group_Time_ID_Claim_No_Acc] ON [dbo].[EML_AWC] 
	(
		[Group] ASC,
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Account_Manager] ASC
	)
	INCLUDE ( [Team],
	[Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Projection_Unit_Type_Type') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Projection_Unit_Type_Type] ON [dbo].[EML_AWC_Projections] 
	(
		[Unit_Type] ASC,
		[Type] ASC
	)
	INCLUDE ( [Unit_Name],
	[Time_Id],
	[Projection]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Claim_No_Time_ID_Account_Manager_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Claim_No_Time_ID_Account_Manager_Group] ON [dbo].[EML_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC,
		[Account_Manager] ASC,
		[Group] ASC
	)
	INCLUDE ( [Team],
	[Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Group] ON [dbo].[EML_AWC] 
	(
		[Group] ASC
	)
	INCLUDE ( [Team],
	[EMPL_SIZE],
	[Account_Manager]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Claim_No_Time_ID_Include') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Claim_No_Time_ID_Include] ON [dbo].[EML_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[EMPL_SIZE],
	[Account_Manager]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_No_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_No_Group] ON [dbo].[EML_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Group] ASC
	)
	INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_No_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_No_Acc] ON [dbo].[EML_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Account_Manager] ASC
	)
	INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_No') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_No] ON [dbo].[EML_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Claim_no_Time_ID') 	
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Claim_no_Time_ID] ON [dbo].[EML_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC
	)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID') 	
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID]
	ON [dbo].[EML_AWC] ([Time_ID] ASC) 
	INCLUDE ([Claim_no],[Date_of_Injury],[EMPL_SIZE],[Account_Manager])
	WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
	
---+++TMF+++-------
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Time_ID_Claim_No_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Time_ID_Claim_No_Group] ON [dbo].[TMF_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Group] ASC
	)
	INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Claim_No_Group_Time_ID') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Claim_No_Group_Time_ID] ON [dbo].[TMF_AWC] 
	(		
		[Claim_no] ASC,
		[Group] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Team],[Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Time_ID_Claim_No') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Time_ID_Claim_No] ON [dbo].[TMF_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Claim_no_Time_ID') 	
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Claim_no_Time_ID] ON [dbo].[TMF_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC
	)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Group_Sub') 
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Group_Sub] ON [dbo].[TMF_AWC] 
	(
		[Group] ASC,
		[Sub_Category] ASC
	)
	INCLUDE ( [Team],
	[AgencyName]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Sub_Time_ID_Claim_No_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Sub_Time_ID_Claim_No_Group] ON [dbo].[TMF_AWC] 
	(
		[Sub_Category] ASC,
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Group] ASC
	)
	INCLUDE ( [Team],[AgencyName],
	[Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Group_Time_ID_Claim_No_Sub') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Group_Time_ID_Claim_No_Sub] ON [dbo].[TMF_AWC] 
	(	
		[Group] ASC,
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Sub_Category] ASC
	)
	INCLUDE ( [Team],[AgencyName],
	[Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Projections_Unit_Type_Type') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Projections_Unit_Type_Type] ON [dbo].[TMF_AWC_Projections] 
	(
		[Unit_Type] ASC,
		[Type] ASC
	)
	INCLUDE ( [Unit_Name],
	[Time_Id],
	[Projection]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

---+++HEM+++-------
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_No_Time_ID_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_No_Time_ID_Acc] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC,
		[Account_Manager] ASC
	)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_Claim_No_Time_ID') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_Claim_No_Time_ID] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[Account_Manager]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_No_Portfolio_Time_ID') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_No_Portfolio_Time_ID] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Portfolio] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_No_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_No_Acc] ON [dbo].[HEM_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Account_Manager] ASC
	)
	INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_No_Time_ID_Group_Date_of_Injury') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_No_Time_ID_Group_Date_of_Injury] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Group],
	[Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_No_Group_Time_ID') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_No_Group_Time_ID] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Group] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Team],
	[Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_No_Acc_Time_ID') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_No_Acc_Time_ID] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Account_Manager] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_No_Portfolio') 	
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_No_Portfolio] ON [dbo].[HEM_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_No_Portfolio_Time_ID_Date_of_Injury_EMPL') 
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_No_Portfolio_Time_ID_Date_of_Injury_EMPL] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Portfolio] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Group_Acc_Portfolio') 
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Group_Acc_Portfolio] ON [dbo].[HEM_AWC] 
	(
		[Group] ASC,
		[Account_Manager] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [Team],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Group_Time_ID_Claim_No_Acc_Portfolio') 
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Group_Time_ID_Claim_No_Acc_Portfolio] ON [dbo].[HEM_AWC] 
	(
		[Group] ASC,
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Account_Manager] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [Team],
	[Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_No_Group_Acc_Portfolio') 
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_No_Group_Acc_Portfolio] ON [dbo].[HEM_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Group] ASC,
		[Account_Manager] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [Team],
	[Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Acc_Time_ID_Claim_No_Group_Portfolio') 
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Acc_Time_ID_Claim_No_Group_Portfolio] ON [dbo].[HEM_AWC] 
	(
		[Account_Manager] ASC,
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Group] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [Team],
	[Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Projection_Unit_Type_Type') 
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Projection_Unit_Type_Type] ON [dbo].[HEM_AWC_Projections] 
	(
		[Unit_Type] ASC,
		[Type] ASC
	)
	INCLUDE ( [Unit_Name],
	[Time_Id],
	[Projection]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_DART_Index.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Dashboard_EML_RTW_AddTargetAndBase_GenerateData.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [usp_Dashboard_EML_RTW_AddTargetAndBase] 2013, 2
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_EML_RTW_AddTargetAndBase_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_EML_RTW_AddTargetAndBase_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_EML_RTW_AddTargetAndBase_GenerateData]

AS
BEGIN
	DELETE FROM [dbo].[EML_RTW_Target_Base]
	DBCC CHECKIDENT('EML_RTW_Target_Base', RESEED, 0)
	
	INSERT INTO [EML_RTW_Target_Base]([Type], [Value], [Sub_Value], 
				[Measure], [Target], [Base],[Create_Date],Remuneration)
	
	-- EML --
	SELECT [Type] = ''
		   ,[Value] = 'EML'
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM EML_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							)
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM EML_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							)					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select [Value]='') as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	-- Group --
	UNION ALL
	SELECT [Type] = 'group'
		   ,[Value] = tmp.[group] 
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM EML_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group]))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM EML_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group]))					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [group] from EML_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	-- Employer size --
	UNION ALL
	SELECT [Type] = 'employer_size'
		   ,[Value] = tmp.EMPL_SIZE
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM EML_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.EMPL_SIZE) =RTRIM(EMPL_SIZE))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM EML_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.EMPL_SIZE) =RTRIM(EMPL_SIZE))					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [EMPL_SIZE] from EML_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
	
	-- Account manager --
	UNION ALL
	SELECT [Type] = 'account_manager'
		   ,[Value] = tmp.[Account_Manager] 
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM EML_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[Account_Manager]) =RTRIM([Account_Manager]))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM EML_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[Account_Manager]) =RTRIM([Account_Manager]))					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [Account_Manager] from EML_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	-- Group -> Team --
	UNION ALL
	SELECT [Type] = 'group'
		   ,[Value] = tmp.[group] 
		   ,[Sub_Value] = tmp.Team
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM EML_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group])
							AND RTRIM(tmp.[Team]) =RTRIM([Team]))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM EML_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group])
							AND RTRIM(tmp.[Team]) =RTRIM([Team]))					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [group],[Team] from EML_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp

	-- Account manager -> Employer size --
	UNION ALL
	SELECT [Type] = 'account_manager'
		   ,[Value] = tmp.Account_Manager 
		   ,[Sub_Value] = tmp.EMPL_SIZE
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM EML_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Account_Manager) =RTRIM(Account_Manager)
							AND RTRIM(tmp.EMPL_SIZE) =RTRIM(EMPL_SIZE))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM EML_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Account_Manager) =RTRIM(Account_Manager)
							AND RTRIM(tmp.EMPL_SIZE) =RTRIM(EMPL_SIZE))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [Account_Manager],[EMPL_SIZE] from EML_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Dashboard_EML_RTW_AddTargetAndBase_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [usp_Dashboard_HEM_RTW_AddTargetAndBase] 2013, 2
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData]

AS
BEGIN
	DELETE FROM [dbo].[HEM_RTW_Target_Base]
	DBCC CHECKIDENT('HEM_RTW_Target_Base', RESEED, 0)
	
	INSERT INTO [HEM_RTW_Target_Base]([Type], [Value], [Sub_Value], 
				[Measure], [Target], [Base],[Create_Date],Remuneration)
	
	-- HEM --
	SELECT [Type] = ''
		   ,[Value] = 'Hospitality'
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							)
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							)					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select [Value]='') as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp

	-- Group --
	UNION ALL
	SELECT [Type] = 'group'
		   ,[Value] = tmp.[group] 
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group]))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group]))					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [group] from HEM_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	-- Portfolio --
	UNION ALL
	SELECT [Type] = 'portfolio'
		   ,[Value] = tmp.Portfolio 
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Portfolio) =RTRIM(Portfolio))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Portfolio) =RTRIM(Portfolio))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [Portfolio] from HEM_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	-- Portfolio: Hotel Summary --
	UNION ALL
	SELECT [Type] = 'portfolio'
		   ,[Value] = 'Hotel'
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(Portfolio) in ('Accommodation','Pubs, Taverns and Bars'))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(Portfolio) in ('Accommodation','Pubs, Taverns and Bars'))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select [Portfolio] = 'Hotel') as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	-- Account Manager --
	UNION ALL
	SELECT [Type] = 'account_manager'
		   ,[Value] = tmp.Account_Manager 
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Account_Manager) =RTRIM(Account_Manager))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Account_Manager) =RTRIM(Account_Manager))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [Account_Manager] from HEM_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp

	-- Group -> Team --
	UNION ALL
	SELECT [Type] = 'group'
		   ,[Value] = tmp.[group]
		   ,[Sub_Value] = tmp.Team
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group])
							AND RTRIM(tmp.[Team]) =RTRIM([Team]))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group])
							AND RTRIM(tmp.[Team]) =RTRIM([Team]))					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [group],[Team] from HEM_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp

	-- Portfolio - Employer Size --
	UNION ALL
	SELECT [Type] = 'portfolio'
		   ,[Value] = tmp.Portfolio 
		   ,[Sub_Value] = tmp.EMPL_SIZE
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Portfolio) =RTRIM(Portfolio)
							AND RTRIM(tmp.EMPL_SIZE) =RTRIM(EMPL_SIZE))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Portfolio) =RTRIM(Portfolio)
							AND RTRIM(tmp.EMPL_SIZE) =RTRIM(EMPL_SIZE))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar)
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [Portfolio],[EMPL_SIZE] from HEM_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	--Account Manager - Employer Size--
	UNION ALL
	SELECT [Type] = 'account_manager'
		   ,[Value] = tmp.Account_Manager 
		   ,[Sub_Value] = tmp.EMPL_SIZE
		   ,[Measure]= tmp.measure
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))
		 			   FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Account_Manager) =RTRIM(Account_Manager)
							AND RTRIM(tmp.EMPL_SIZE) =RTRIM(EMPL_SIZE))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(tmp.Remuneration) -1 as varchar(10)) +'/06/30',tmp.Remuneration)) as float)/18))*1.15
						FROM HEM_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(tmp.Remuneration) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.Account_Manager) =RTRIM(Account_Manager)
							AND RTRIM(tmp.EMPL_SIZE) =RTRIM(EMPL_SIZE))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [Account_Manager],[EMPL_SIZE] from HEM_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Dashboard_TMF_RTW_AddTargetAndBase_GenerateData.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [usp_Dashboard_TMF_RTW_AddTargetAndBase] 2013, 2
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_TMF_RTW_AddTargetAndBase_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_TMF_RTW_AddTargetAndBase_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_TMF_RTW_AddTargetAndBase_GenerateData]

AS
BEGIN
	DELETE FROM [dbo].[TMF_RTW_Target_Base]
	DBCC CHECKIDENT('TMF_RTW_Target_Base', RESEED, 0)
	INSERT INTO [TMF_RTW_Target_Base]([Type], [Value], [Sub_Value], 
				[Measure], [Target], [Base],[Create_Date],Remuneration)
	
	--TMF--
	SELECT [Type] = ''
		   ,[Value] = 'TMF'
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))
		 			   FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							)
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							)					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select [Value]='') as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	--Agency--
	UNION ALL
	SELECT [Type] = 'agency'
		   ,[Value] = tmp.agencyname 
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))
		 			   FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.agencyname) =RTRIM(agencyname))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.agencyname) =RTRIM(agencyname))					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [agencyname] from TMF_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	--Agency Police & Fire
	UNION ALL
	SELECT [Type] = 'agency'
		   ,[Value] = 'Police & Fire'
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))
		 			   FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							and RTRIM(AgencyName) in ('Police','Fire'))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							and RTRIM(AgencyName) in ('Police','Fire'))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select [agencyname] = 'Police & Fire') as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	--Agency Health & Other
	UNION ALL
	SELECT [Type] = 'agency'
		   ,[Value] = 'Health & Other'
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))
		 			   FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							and RTRIM(AgencyName) in ('Health','Other'))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							and RTRIM(AgencyName) in ('Health','Other'))
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select [agencyname] = 'Health & Other') as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp

	--Group--
	UNION ALL
	SELECT [Type] = 'group'
		   ,[Value] = tmp.[group] 
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))
		 			   FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group]))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group]))					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [group] from TMF_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp

	--Team--
	UNION ALL
	SELECT [Type] = 'group'
		   ,[Value] = tmp.[group] 
		   ,[Sub_Value] = Team
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))
		 			   FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group])
							AND RTRIM(tmp.[Team]) =RTRIM([Team]))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) =RTRIM([group])
							AND RTRIM(tmp.[Team]) =RTRIM([Team]))					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [group],[Team] from TMF_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp

	--Sub cagetory--
	UNION ALL
	SELECT [Type] = 'agency'
		   ,[Value] = tmp.agencyname 
		   ,[Sub_Value] = tmp.Sub_Category
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))
		 			   FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.agencyname) =RTRIM(agencyname)
							AND RTRIM(tmp.sub_category) =RTRIM(sub_category))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.agencyname) =RTRIM(agencyname)
							AND RTRIM(tmp.sub_category) =RTRIM(sub_category))					
		   ,Create_Date = GETDATE()
		   ,Remuneration = cast(year(tmp.Remuneration) AS varchar) 
		  + 'M' + CASE WHEN MONTH(tmp.Remuneration) <= 9 THEN '0' ELSE '' END 
		  + cast(month(tmp.Remuneration) AS varchar)
	FROM 
	(select * from 
		(SELECT   Remuneration = dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59'
			FROM          master.dbo.spt_values t1
			WHERE      'P' = type 
			AND dateadd(dd, - 1, DateAdd(m, number, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 23, 0))) + '23:59' 
			<= cast(year(getdate()) as  varchar(10)) + '-12-31 ' + '23:59') as t1
	CROSS JOIN

	(select distinct  [agencyname],[Sub_Category] from TMF_RTW) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp

END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO

--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Dashboard_TMF_RTW_AddTargetAndBase_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_EML_CPR_Dashboard_Agency_Group.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_EML_CPR_Dashboard_Agency_Group]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_EML_CPR_Dashboard_Agency_Group]
GO

CREATE PROCEDURE [dbo].[usp_EML_CPR_Dashboard_Agency_Group]
(
	@Start_Date datetime
	,@End_Date datetime
	,@Is_Last_Month bit
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING
	
	-- NEW CLAIMS
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury =  0
	INTO #claim_new_all 
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	
	-- CLAIM CLOSURES
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury = 0
	INTO #claim_closure 
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury = 0
	INTO #claim_re_open 
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		
	-- REOPEN CLAIMS: STILL OPEN
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury = 0
	INTO #claim_re_open_still_open 
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	
	-- OPEN CLAIMS
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
	INTO #claim_open_all
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
	
	-- drop temp tables
	DROP TABLE #claim_new_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
	DROP TABLE #claim_open_all
	
	SELECT  tmp.[Value] as [Unit], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType])

		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Is_Medical_Only = 1)

		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Is_D_D = 1)
			
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType]
			and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
			
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'TU')
			
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
			
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
							
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 0)
			
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'PID')
			
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType]
			and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and NCMM_Actions_This_Week <> '')
			
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and NCMM_Actions_Next_Week <> '')
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, [UnitType] = 'employer_size'
						from [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
						where Value <> '' and Claim_Closed_Flag <> 'Y'
						group by Value
						having COUNT(*) > 0
					union all
					select distinct Value, [UnitType] = 'group'
						from [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
						where Value <> '' and Claim_Closed_Flag <> 'Y'
						group by Value
						having COUNT(*) > 0
					union all
					select distinct Value, [UnitType] = 'account_manager'
						from [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
						where Value <> '' and Claim_Closed_Flag <> 'Y'
						group by Value
						having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- drop temp table
	DROP TABLE #claim_all
	
	-- GET RESULTS
	
	SELECT * FROM #total
		
	UNION ALL -- WCNSW
		
	SELECT [Unit] = 'WCNSW', [UnitType] = 'WCNSW', Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	WHERE [UnitType] = 'employer_size'
	GROUP BY Claim_Type
		
	--drop temp table
	DROP table #total
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_EML_CPR_Dashboard_Agency_Group.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_EML_CPR_Dashboard_ClaimOfficer.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_EML_CPR_Dashboard_ClaimOfficer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_EML_CPR_Dashboard_ClaimOfficer]
GO

CREATE PROCEDURE [dbo].[usp_EML_CPR_Dashboard_ClaimOfficer]
(
	@Start_Date datetime
	,@End_Date datetime
	,@Is_Last_Month bit
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING
	
	-- NEW CLAIMS
	SELECT *,[UnitType] = 'group', weeks_since_injury =  0
	INTO #claim_new_all
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	
	-- CLAIM CLOSURES
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
	INTO #claim_closure
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
	INTO #claim_re_open
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		
	-- REOPEN CLAIMS: STILL OPEN
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
	INTO #claim_re_open_still_open
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	
	-- OPEN CLAIMS
	SELECT *,[UnitType] = 'group', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
	INTO #claim_open_all
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
	
	-- drop temp tables
	DROP TABLE #claim_new_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
	DROP TABLE #claim_open_all
	
	SELECT  tmp.[SubValue2] as [Unit], tmp.[SubValue] as [Primary], tmp.[Value] as [Parent], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType])

		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Is_Medical_Only = 1)

		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Is_D_D = 1)
			
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType]
			and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
			
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'TU')
			
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
			
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
							
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 0)
			
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'PID')
			
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType]
			and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and NCMM_Actions_This_Week <> '')
			
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and NCMM_Actions_Next_Week <> '')
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, SubValue, SubValue2, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and SubValue2 <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue, SubValue2
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- Add an overall column for Teams
	SELECT  tmp.[SubValue2] as [Unit], tmp.[SubValue] as [Primary], tmp.[Value] as [Parent], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType])

		,med_only = 0
		,d_d = 0
		,lum_sum_in = 0
		,totally_unfit = 0
		,ffsd_at_work_15_less = 0
		,ffsd_at_work_15_more = 0
		,ffsd_not_at_work = 0
		,pid = 0
		,therapy_treat = 0
		,ncmm_this_week = 0
		,ncmm_next_week = 0
	INTO #total2
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, SubValue, [SubValue2] = SubValue, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- drop temp table
	DROP TABLE #claim_all
	
	-- GET RESULTS
	SELECT * FROM #total
	UNION ALL
	SELECT * FROM #total2
		
	--drop temp table
	DROP table #total
	DROP table #total2
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_EML_CPR_Dashboard_ClaimOfficer.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_EML_CPR_Dashboard_Sub_Team.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_EML_CPR_Dashboard_Sub_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_EML_CPR_Dashboard_Sub_Team]
GO

CREATE PROCEDURE [dbo].[usp_EML_CPR_Dashboard_Sub_Team]
(
	@Start_Date datetime
	,@End_Date datetime
	,@Is_Last_Month bit
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING
	
	-- NEW CLAIMS
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury =  0
	INTO #claim_new_all 
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	
	-- CLAIM CLOSURES
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury = 0
	INTO #claim_closure 
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury = 0
	INTO #claim_re_open 
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		
	-- REOPEN CLAIMS: STILL OPEN
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury = 0
	INTO #claim_re_open_still_open 
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	
	-- OPEN CLAIMS
	SELECT *,[UnitType] = 'employer_size', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
	INTO #claim_open_all
		FROM [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
		FROM [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'account_manager', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
		FROM [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
	
	-- drop temp tables
	DROP TABLE #claim_new_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
	DROP TABLE #claim_open_all
	
	SELECT  tmp.[SubValue] as [Unit], tmp.[Value] as [Primary], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType])

		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Is_Medical_Only = 1)

		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Is_D_D = 1)
			
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType]
			and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
			
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'TU')
			
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
			
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
							
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 0)
			
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'PID')
			
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType]
			and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and NCMM_Actions_This_Week <> '')
			
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and NCMM_Actions_Next_Week <> '')
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, SubValue, [UnitType] = 'employer_size'
							from [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0
					union all
					select distinct Value, SubValue, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0
					union all
					select distinct Value, SubValue, [UnitType] = 'account_manager'
							from [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- add an overall column for employer sizes, groups and account managers
	SELECT  tmp.[SubValue] + '_total' as [Unit], tmp.[Value] as [Primary], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [Value]=tmp.[SubValue] and [UnitType]=tmp.[UnitType])

		,med_only = 0
		,d_d = 0
		,lum_sum_in = 0
		,totally_unfit = 0
		,ffsd_at_work_15_less = 0
		,ffsd_at_work_15_more = 0
		,ffsd_not_at_work = 0
		,pid = 0
		,therapy_treat = 0
		,ncmm_this_week = 0
		,ncmm_next_week = 0
	INTO #total2
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, [SubValue] = Value, [UnitType] = 'employer_size'
							from [dbo].[udf_CPR_Overall]('EML', 'employer_size', @Is_Last_Month)
							where Value <> '' and Claim_Closed_Flag <> 'Y'
							group by Value
							having COUNT(*) > 0
					union all
					select distinct Value, [SubValue] = Value, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('EML', 'group', @Is_Last_Month)
							where Value <> '' and Claim_Closed_Flag <> 'Y'
							group by Value
							having COUNT(*) > 0
					union all
					select distinct Value, [SubValue] = Value, [UnitType] = 'account_manager'
							from [dbo].[udf_CPR_Overall]('EML', 'account_manager', @Is_Last_Month)
							where Value <> '' and Claim_Closed_Flag <> 'Y'
							group by Value
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- drop temp table
	DROP TABLE #claim_all
	
	-- GET RESULTS
	SELECT * FROM #total
	UNION ALL
	SELECT * FROM #total2
		
	--drop temp table
	DROP table #total
	DROP table #total2
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_EML_CPR_Dashboard_Sub_Team.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Generate_active_directory_user.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Generate_active_directory_user]    Script Date: 20/05/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Generate_active_directory_user]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Generate_active_directory_user]
GO

CREATE PROCEDURE [dbo].[usp_Generate_active_directory_user]
	@tmfprod varchar(20),
	@emlprod varchar(20),
	@hemprod varchar(20)
AS
BEGIN
	IF OBJECT_ID('tempdb..#all_records') IS NOT NULL DROP TABLE #all_records
	
	declare @tmf_query varchar(500)
	declare @eml_query varchar(500)
	declare @hem_query varchar(500)
	set @tmf_query = 'SELECT 1 as TMF,
						   0 as EML,
						   0 as HEM,
						   Alias as Alias,
						   First_Name as FirstName,
						   Last_Name as LastName,
						   active as active
					 FROM ' + @tmfprod + '.[dbo].[CLAIMS_OFFICERS]'
					 
	set @eml_query = 'SELECT 0 as TMF,
						   1 as EML,
						   0 as HEM,
						   Alias as Alias,
						   First_Name as FirstName,
						   Last_Name as LastName,
						   active as active
					 FROM ' + @emlprod + '.[dbo].[CLAIMS_OFFICERS]'
					 
	set @hem_query = 'SELECT 0 as TMF,
						   0 as EML,
						   1 as HEM,
						   Alias as Alias,
						   First_Name as FirstName,
						   Last_Name as LastName,
						   active as active
					 FROM ' + @hemprod + '.[dbo].[CLAIMS_OFFICERS]'
								
	--CREATE TABLE TO STORE ALL RECORDS FROM EMIC DATABASE--
	CREATE TABLE #all_records
	(
		ID int identity,
		TMF bit null,
		EML bit null,
		HEM bit null,
		Alias nvarchar (10) null,
		FirstName nvarchar(256) null,
		LastName nvarchar(256) null,
		Email nvarchar (256) null,
		Status smallint null,
		Create_date datetime null,
		Is_System_User bit null,
		Default_System_Id int null,
		active bit null,
		Organisation_RoleId int null
	)

	INSERT INTO #all_records(TMF,EML,HEM,Alias,FirstName,LastName,active)
	exec(@tmf_query)
	
	INSERT INTO #all_records(TMF,EML,HEM,Alias,FirstName,LastName,active)
	exec(@eml_query)
	
	INSERT INTO #all_records(TMF,EML,HEM,Alias,FirstName,LastName,active)
	exec(@hem_query)
	
	--UPDATE OTHER FIELDS IN TEMPT TABLE
	UPDATE #all_records
	SET Email = '',
		Status = 1,
		Create_date = GETDATE(),
		Is_System_User = 0,
		Default_System_Id = (SELECT SystemId 
							 FROM [Dart].[dbo].[Systems]
							 WHERE LOWER(Name)  = case when TMF = 1 then 'tmf'
													   when HEM = 1 then 'hem'
													   when EML = 1 then 'eml'
												  end),
        Organisation_RoleId = (SELECT roles.Organisation_RoleId
												  FROM [Dart].[dbo].[Organisation_Levels] levels join [Dart].[dbo].[Organisation_Roles] roles 
														ON levels.LevelId = roles.LevelId
												  WHERE levels.SystemId = (SELECT SystemId 
																		   FROM [Dart].[dbo].[Systems]
																		   WHERE LOWER(Name)  = case when TMF = 1 then 'tmf'
																							    when HEM = 1 then 'hem'
																							    when EML = 1 then 'eml'
																						        end)
											            and roles.Name = 'Pilot Users') 												
									            	
	--DELETE EXISTING USER WITH ACTIVE = 0 FROM USER TABLE--
	DELETE FROM [Dart].[dbo].[Users]
	WHERE UserId in (SELECT UserId
				 FROM [Dart].[dbo].[Users] u1
				 WHERE UserName COLLATE Latin1_General_CI_AS in (SELECT distinct Alias
												   FROM #all_records ar join [Dart].[dbo].[Users] u 
															on ar.Alias = u.UserName COLLATE Latin1_General_CI_AS
												   WHERE ar.active = 0)
				  AND Default_System_Id in (SELECT ar.Default_System_Id
											FROM #all_records ar join [Dart].[dbo].[Users] u 
													on ar.Alias = u.UserName COLLATE Latin1_General_CI_AS
											WHERE ar.active = 0 and u.UserId = u1.UserId)
				)
				
	--INSERT NEW USER INTO DART USER TABLE--
	INSERT INTO [Dart].[dbo].[Users] (UserName,
									  Password,
									  FirstName,
									  LastName,
									  Email,
									  [Status],
									  Create_Date,
									  Is_System_User,
									  Default_System_Id)
	SELECT Alias,
		   '',
		   FirstName,
		   LastName,
		   Email,
		   Status, 
		   Create_date,
		   Is_System_User, 
		   Default_System_Id 
	FROM #all_records ar	
	WHERE ID = (SELECT MAX(ID) 
				FROM #all_records t1 
				WHERE t1.Alias = ar.Alias and active = 1)
		  AND NOT EXISTS (SELECT * 
						  FROM [Dart].[dbo].[Users] u
						  WHERE u.UserName COLLATE Latin1_General_CI_AS = ar.Alias)

	--INSERT NEW USER INTO DART REPORT USER TABLE--
	INSERT INTO [Dart].[dbo].[ReportUsers] (UserId,Is_External_User,Organisation_RoleId)
	SELECT u.UserId
		  ,0 as Is_External_User
		  ,Organisation_RoleId = Organisation_RoleId
	FROM #all_records join [Dart].[dbo].[Users] u ON u.UserName COLLATE Latin1_General_CI_AS = #all_records.Alias
	WHERE active = 1
		 AND NOT EXISTS (SELECT * 
						 FROM [Dart].[dbo].[ReportUsers] ru
						 WHERE ru.UserId = u.UserId)
							 
	--DELETE EXISTING USER WITH ACTIVE CHANGED FROM 1 TO 0 FROM REPORT USER TABLE--
	DELETE FROM [Dart].[dbo].[ReportUsers]
	WHERE Id in (SELECT Id 
				FROM [Dart].[dbo].[ReportUsers] ru
				WHERE UserId in (SELECT UserId
							 FROM [Dart].[dbo].[Users] u 
								inner join #all_records ar ON u.UserName COLLATE Latin1_General_CI_AS = ar.Alias
							 WHERE active = 0)
				and Organisation_RoleId in (SELECT ar.Organisation_RoleId
											 FROM [Dart].[dbo].[Users] u 
												inner join #all_records ar ON u.UserName COLLATE Latin1_General_CI_AS = ar.Alias
											 WHERE ar.active = 0 and u.UserId = ru.UserId)
				)
	
	--INSERT EXISTING USER WITH ACTIVE CHANGED FROM 0 TO 1 INTO REPORT USER TABLE--				
	INSERT INTO [Dart].[dbo].[ReportUsers] (UserId,Is_External_User,Organisation_RoleId)
	SELECT u.UserId
		  ,0 as Is_External_User
		  ,Organisation_RoleId = Organisation_RoleId
	FROM #all_records join [Dart].[dbo].[Users] u ON u.UserName COLLATE Latin1_General_CI_AS = #all_records.Alias
	WHERE active = 1
	AND u.UserId in (SELECT ru.UserId
					 FROM [Dart].[dbo].[ReportUsers] ru
					 WHERE ru.UserId = u.UserId)
	AND Organisation_RoleId not in (SELECT ru.Organisation_RoleId
									FROM [Dart].[dbo].[ReportUsers] ru
									WHERE ru.UserId = u.UserId)
						 			
	
	IF OBJECT_ID('tempdb..#all_records') IS NOT NULL DROP TABLE #all_records
			
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Generate_active_directory_user.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_HEM_CPR_Dashboard_Agency_Group.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_HEM_CPR_Dashboard_Agency_Group]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_HEM_CPR_Dashboard_Agency_Group]
GO

CREATE PROCEDURE [dbo].[usp_HEM_CPR_Dashboard_Agency_Group]
(
	@Start_Date datetime
	,@End_Date datetime
	,@Is_Last_Month bit
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING
	
	-- NEW CLAIMS
	SELECT *,[UnitType] = 'portfolio', weeks_since_injury =  0
	INTO #claim_new_all 
		FROM [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	
	-- CLAIM CLOSURES
	SELECT *,[UnitType] = 'portfolio', weeks_since_injury = 0
	INTO #claim_closure 
		FROM [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS
	SELECT *,[UnitType] = 'portfolio', weeks_since_injury = 0
	INTO #claim_re_open 
		FROM [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		
	-- REOPEN CLAIMS: STILL OPEN
	SELECT *,[UnitType] = 'portfolio', weeks_since_injury = 0
	INTO #claim_re_open_still_open
		FROM [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	
	-- OPEN CLAIMS
	SELECT *,[UnitType] = 'portfolio', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
	INTO #claim_open_all
		FROM [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
	
	-- drop temp tables
	DROP TABLE #claim_new_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
	DROP TABLE #claim_open_all
	
	SELECT  tmp.[Value] as [Unit], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType])

		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Is_Medical_Only = 1)

		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Is_D_D = 1)
			
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType]
			and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
			
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'TU')
			
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
			
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
							
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 0)
			
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'PID')
			
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType]
			and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and NCMM_Actions_This_Week <> '')
			
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and NCMM_Actions_Next_Week <> '')
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, [UnitType] = 'portfolio'
						from [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
						where Value <> '' and Claim_Closed_Flag <> 'Y'
						group by Value
						having COUNT(*) > 0
					union all
					select distinct Value, [UnitType] = 'group'
						from [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
						where Value <> '' and Claim_Closed_Flag <> 'Y'
						group by Value
						having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- drop temp table
	DROP TABLE #claim_all
	
	-- GET RESULTS
	
	SELECT * FROM #total
		
	UNION ALL -- Grouping Value: Hotel
		
	SELECT [Unit] = 'Hotel', [UnitType] = 'portfolio', Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	WHERE ([Unit] = 'Accommodation' or [Unit] = 'Pubs, Taverns and Bars')
	GROUP BY Claim_Type
		
	UNION ALL -- Hospitality
		
	SELECT [Unit] = 'Hospitality', [UnitType] = 'Hospitality', Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	WHERE [UnitType] = 'portfolio'
	GROUP BY Claim_Type
		
	--drop temp table
	DROP table #total
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_HEM_CPR_Dashboard_Agency_Group.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_HEM_CPR_Dashboard_ClaimOfficer.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_HEM_CPR_Dashboard_ClaimOfficer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_HEM_CPR_Dashboard_ClaimOfficer]
GO

CREATE PROCEDURE [dbo].[usp_HEM_CPR_Dashboard_ClaimOfficer]
(
	@Start_Date datetime
	,@End_Date datetime
	,@Is_Last_Month bit
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING
	
	-- NEW CLAIMS
	SELECT *,[UnitType] = 'group', weeks_since_injury =  0
	INTO #claim_new_all
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	
	-- CLAIM CLOSURES
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
	INTO #claim_closure
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
	INTO #claim_re_open
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		
	-- REOPEN CLAIMS: STILL OPEN
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
	INTO #claim_re_open_still_open
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	
	-- OPEN CLAIMS
	SELECT *,[UnitType] = 'group', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
	INTO #claim_open_all
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
	
	-- drop temp tables
	DROP TABLE #claim_new_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
	DROP TABLE #claim_open_all
	
	SELECT  tmp.[SubValue2] as [Unit], tmp.[SubValue] as [Primary], tmp.[Value] as [Parent], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType])

		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Is_Medical_Only = 1)

		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Is_D_D = 1)
			
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType]
			and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
			
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'TU')
			
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
			
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
							
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 0)
			
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'PID')
			
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType]
			and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and NCMM_Actions_This_Week <> '')
			
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and NCMM_Actions_Next_Week <> '')
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, SubValue, SubValue2, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and SubValue2 <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue, SubValue2
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	--add an overal column for teams
	SELECT  tmp.[SubValue2] as [Unit], tmp.[SubValue] as [Primary], tmp.[Value] as [Parent], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType])

		,med_only = 0
		,d_d = 0
		,lum_sum_in = 0
		,totally_unfit = 0
		,ffsd_at_work_15_less = 0
		,ffsd_at_work_15_more = 0
		,ffsd_not_at_work = 0
		,pid = 0
		,therapy_treat = 0
		,ncmm_this_week = 0
		,ncmm_next_week = 0
	INTO #total2
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, SubValue, [SubValue2] = SubValue, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- drop temp table
	DROP TABLE #claim_all
	
	-- GET RESULTS
	SELECT * FROM #total
	UNION ALL
	SELECT * FROM #total2
		
	--drop temp table
	DROP table #total
	DROP table #total2
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_HEM_CPR_Dashboard_ClaimOfficer.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_HEM_CPR_Dashboard_Sub_Team.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_HEM_CPR_Dashboard_Sub_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_HEM_CPR_Dashboard_Sub_Team]
GO

CREATE PROCEDURE [dbo].[usp_HEM_CPR_Dashboard_Sub_Team]
(
	@Start_Date datetime
	,@End_Date datetime
	,@Is_Last_Month bit
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING
	
	-- NEW CLAIMS
	SELECT *,[UnitType] = 'portfolio', weeks_since_injury =  0
	INTO #claim_new_all 
		FROM [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	
	-- CLAIM CLOSURES
	SELECT *,[UnitType] = 'portfolio', weeks_since_injury = 0
	INTO #claim_closure 
		FROM [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS
	SELECT *,[UnitType] = 'portfolio', weeks_since_injury = 0
	INTO #claim_re_open 
		FROM [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		
	-- REOPEN CLAIMS: STILL OPEN
	SELECT *,[UnitType] = 'portfolio', weeks_since_injury = 0
	INTO #claim_re_open_still_open 
		FROM [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	
	-- OPEN CLAIMS
	SELECT *,[UnitType] = 'portfolio', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
	INTO #claim_open_all
		FROM [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
		FROM [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
	
	-- drop temp tables
	DROP TABLE #claim_new_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
	DROP TABLE #claim_open_all
	
	SELECT  tmp.[SubValue] as [Unit], tmp.[Value] as [Primary], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType])

		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Is_Medical_Only = 1)

		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Is_D_D = 1)
			
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType]
			and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
			
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'TU')
			
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
			
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
							
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 0)
			
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'PID')
			
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType]
			and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and NCMM_Actions_This_Week <> '')
			
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and NCMM_Actions_Next_Week <> '')
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, SubValue, [UnitType] = 'portfolio'
							from [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0
					union all
					select distinct Value, SubValue, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	--add an overal column for portfolio, and groups
	SELECT  tmp.[SubValue] + '_total' as [Unit], tmp.[Value] as [Primary], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [Value]=tmp.[SubValue] and [UnitType]=tmp.[UnitType])

		,med_only = 0
		,d_d = 0
		,lum_sum_in = 0
		,totally_unfit = 0
		,ffsd_at_work_15_less = 0
		,ffsd_at_work_15_more = 0
		,ffsd_not_at_work = 0
		,pid = 0
		,therapy_treat = 0
		,ncmm_this_week = 0
		,ncmm_next_week = 0
	INTO #total2
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, [SubValue] = Value, [UnitType] = 'portfolio'
							from [dbo].[udf_CPR_Overall]('HEM', 'portfolio', @Is_Last_Month)
							where Value <> '' and Claim_Closed_Flag <> 'Y'
							group by Value
							having COUNT(*) > 0
					union all
					select distinct Value, [SubValue] = Value, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('HEM', 'group', @Is_Last_Month)
							where Value <> '' and Claim_Closed_Flag <> 'Y'
							group by Value
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- drop temp table
	DROP TABLE #claim_all
	
	-- GET RESULTS
	SELECT * FROM #total
	UNION ALL 
	SELECT * FROM #total2
		
	--drop temp table
	DROP table #total
	DROP table #total2
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_HEM_CPR_Dashboard_Sub_Team.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_PORT_Agency_Group_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PORT_Agency_Group_Summary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PORT_Agency_Group_Summary]
GO

CREATE PROCEDURE [dbo].[usp_PORT_Agency_Group_Summary]
(
	@System VARCHAR(20)
	,@Type VARCHAR(20)
	,@Start_Date DATETIME
	,@End_Date DATETIME
	,@Claim_Liability_Indicator NVARCHAR(256)
	,@Psychological_Claims VARCHAR(10)
	,@Inactive_Claims VARCHAR(10)
	,@Medically_Discharged VARCHAR(10)
	,@Exempt_From_Reform VARCHAR(10)
	,@Reactivation VARCHAR(10)
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING

	SELECT *, weeks_since_injury = 0
	INTO #claim_new_all 
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE Date_Claim_Received between @Start_Date and @End_Date
		  and (case when @Claim_Liability_Indicator <> 'all' then Claim_Liability_Indicator_Group	else '1' end)
				= (case when @Claim_Liability_Indicator <> 'all' then @Claim_Liability_Indicator else '1' end)
	
	SELECT *, weeks_since_injury = 0
	INTO #claim_closure 
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	SELECT *, weeks_since_injury = 0
	INTO #claim_re_open 
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	
	SELECT *, weeks_since_injury = 0
	INTO #claim_re_open_still_open
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
		and Claim_Closed_Flag <> 'Y'
	
	SELECT *, weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0 
	INTO #claim_open_all
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date) 
			and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
			
			and (case when @Psychological_Claims <> 'all' then Is_Stress else '1' end)
				= (case when @Psychological_Claims <> 'all'	then @Psychological_Claims	else '1' end)

			and (case when @Inactive_Claims <> 'all' then Is_Inactive_Claims else '1' end)
				= (case when @Inactive_Claims <> 'all'	then  @Inactive_Claims	else '1' end)

			and (case when @Medically_Discharged <> 'all' then Is_Medically_Discharged	else '1' end)
				= (case when @Medically_Discharged <> 'all' then @Medically_Discharged else '1'	end)

			and (case when @Exempt_From_Reform <> 'all'	then Is_Exempt	else '1' end)
				= (case when @Exempt_From_Reform <> 'all' then @Exempt_From_Reform	else '1' end)

			and (case when @Reactivation <> 'all' then Is_Reactive	else '1' end)
				= (case when @Reactivation <> 'all'	then @Reactivation	else '1' end)
	
	SELECT * 
	INTO #claim_all 
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open'  from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
			
	SELECT  tmp.Value,Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=tmp.Value)
						
		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=tmp.Value and Is_Medical_Only = 1)
						
		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=tmp.Value and Is_D_D = 1)
		
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type and [Value]=tmp.Value
						and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
		
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=tmp.Value and  Med_Cert_Status = 'TU')
		
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=tmp.Value and  Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
		
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=tmp.Value and  Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
						
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all	where claim_type =tmp.Claim_Type  and [Value]=tmp.Value and  Med_Cert_Status = 'SID' and Is_Working = 0)
		
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=tmp.Value and  Med_Cert_Status = 'PID')					
		
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type and [Value]=tmp.Value 
						and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type and [Value]=tmp.Value and NCMM_Actions_This_Week <> '')
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type and [Value]=tmp.Value and NCMM_Actions_Next_Week <> '') 
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value 
						from [dbo].[udf_PORT_Overall](@System, @Type,@End_Date) 
						where Value <> '' and Claim_Closed_Flag <> 'Y'
						group by Value
						having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- GET RESULTS
	
	SELECT * FROM #total
	
	UNION ALL -- Grouping Value: Health & Other
	
	SELECT Value = 'HEALTH & OTHER', Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	WHERE (Value = 'Health' or Value = 'Other') and UPPER(@System) = 'TMF'
	GROUP BY Claim_Type
	
	UNION ALL -- Grouping Value: Police & Fire
	
	SELECT Value = 'POLICE & FIRE', Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	WHERE (Value = 'Police' or Value = 'Fire') and UPPER(@System) = 'TMF'
	GROUP BY Claim_Type
	
	UNION ALL -- Grouping Value: Hotel
	
	SELECT Value = 'Hotel', Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	WHERE (Value = 'Accommodation' or Value = 'Pubs, Taverns and Bars') and UPPER(@System) = 'HEM'
	GROUP BY Claim_Type

	UNION ALL -- TMF
	
	SELECT Value = 'TMF_total', Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	WHERE UPPER(@System) = 'TMF'
	GROUP BY Claim_Type
	
	UNION ALL -- WCNSW
	
	SELECT Value = 'WCNSW_total', Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	WHERE UPPER(@System) = 'EML'
	GROUP BY Claim_Type
	
	UNION ALL -- Hospitality
	
	SELECT Value = 'Hospitality_total', Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	WHERE UPPER(@System) = 'HEM'
	GROUP BY Claim_Type
	
	DROP TABLE #total
	DROP TABLE #claim_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_new_all
	DROP TABLE #claim_open_all
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_PORT_Agency_Group_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_PORT_ClaimOfficer_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PORT_ClaimOfficer_Summary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PORT_ClaimOfficer_Summary]
GO

CREATE PROCEDURE [dbo].[usp_PORT_ClaimOfficer_Summary]
(
	@System VARCHAR(20)
	,@Type VARCHAR(20)
	,@Value NVARCHAR(256)
	,@SubValue NVARCHAR(256)
	,@Start_Date DATETIME
	,@End_Date DATETIME
	,@Claim_Liability_Indicator NVARCHAR(256)
	,@Psychological_Claims VARCHAR(10)
	,@Inactive_Claims VARCHAR(10)
	,@Medically_Discharged VARCHAR(10)
	,@Exempt_From_Reform VARCHAR(10)
	,@Reactivation VARCHAR(10)
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING

	SELECT *, weeks_since_injury = 0
	INTO #claim_new_all 
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE Date_Claim_Received between @Start_Date and @End_Date
		  and (case when @Claim_Liability_Indicator <> 'all' then Claim_Liability_Indicator_Group	else '1' end)
				= (case when @Claim_Liability_Indicator <> 'all' then @Claim_Liability_Indicator else '1' end)
	
	SELECT *, weeks_since_injury = 0
	INTO #claim_closure 
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	SELECT *, weeks_since_injury = 0
	INTO #claim_re_open 
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	
	SELECT *, weeks_since_injury = 0
	INTO #claim_re_open_still_open
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
		and Claim_Closed_Flag <> 'Y'
	
	SELECT *, weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0 
	INTO #claim_open_all
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date) 
			and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
			
			and (case when @Psychological_Claims <> 'all' then Is_Stress else '1' end)
				= (case when @Psychological_Claims <> 'all'	then @Psychological_Claims	else '1' end)

			and (case when @Inactive_Claims <> 'all' then Is_Inactive_Claims else '1' end)
				= (case when @Inactive_Claims <> 'all'	then  @Inactive_Claims	else '1' end)

			and (case when @Medically_Discharged <> 'all' then Is_Medically_Discharged	else '1' end)
				= (case when @Medically_Discharged <> 'all' then @Medically_Discharged else '1'	end)

			and (case when @Exempt_From_Reform <> 'all'	then Is_Exempt	else '1' end)
				= (case when @Exempt_From_Reform <> 'all' then @Exempt_From_Reform	else '1' end)

			and (case when @Reactivation <> 'all' then Is_Reactive	else '1' end)
				= (case when @Reactivation <> 'all'	then @Reactivation	else '1' end)
	
	SELECT * 
	INTO #claim_all 
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open'  from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
			   
			
	SELECT  tmp.Value,Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value)
						
		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and Is_Medical_Only = 1)
						
		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and Is_D_D = 1)
		
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value
						and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
		
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and  Med_Cert_Status = 'TU')
		
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and  Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
		
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and  Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
						
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all	where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and  Med_Cert_Status = 'SID' and Is_Working = 0)
		
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and  Med_Cert_Status = 'PID')					
		
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value 
						and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and NCMM_Actions_This_Week <> '')
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=@SubValue and [SubValue2]=tmp.Value and NCMM_Actions_Next_Week <> '') 
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct SubValue2 as Value from [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
					where Value=@Value and SubValue=@SubValue and SubValue2 <> '' and Claim_Closed_Flag <> 'Y'
					group by SubValue2
					having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- GET RESULTS
	
	SELECT * FROM #total
	
	UNION ALL
	
	SELECT Value = @SubValue + "_total", Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	GROUP BY Claim_Type
	
	DROP TABLE #total
	DROP TABLE #claim_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_new_all
	DROP TABLE #claim_open_all
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_PORT_ClaimOfficer_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_PORT_Raw.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_PORT_Raw]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_PORT_Raw]
GO

CREATE PROCEDURE [dbo].[usp_PORT_Raw]
(
	@System VARCHAR(10)	
	,@End_Date DATETIME
)
AS
BEGIN
	select * from [uv_PORT] 
		where Reporting_Date =  (select top 1 Reporting_Date from [uv_PORT]
									where CONVERT(datetime,  Reporting_Date, 101) 
										>= CONVERT(datetime, @End_Date, 101) AND [system]=@System order by Reporting_Date)
		AND [system]=@System
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_PORT_Raw.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_PORT_Sub_Team_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PORT_Sub_Team_Summary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PORT_Sub_Team_Summary]
GO

CREATE PROCEDURE [dbo].[usp_PORT_Sub_Team_Summary]
(
	@System VARCHAR(20)
	,@Type VARCHAR(20)
	,@Value NVARCHAR(256)
	,@Start_Date DATETIME
	,@End_Date DATETIME
	,@Claim_Liability_Indicator NVARCHAR(256)
	,@Psychological_Claims VARCHAR(10)
	,@Inactive_Claims VARCHAR(10)
	,@Medically_Discharged VARCHAR(10)
	,@Exempt_From_Reform VARCHAR(10)
	,@Reactivation VARCHAR(10)
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING

	SELECT *, weeks_since_injury = 0
	INTO #claim_new_all 
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE Date_Claim_Received between @Start_Date and @End_Date
		  and (case when @Claim_Liability_Indicator <> 'all' then Claim_Liability_Indicator_Group	else '1' end)
				= (case when @Claim_Liability_Indicator <> 'all' then @Claim_Liability_Indicator else '1' end)
	
	SELECT *, weeks_since_injury = 0
	INTO #claim_closure 
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	SELECT *, weeks_since_injury = 0
	INTO #claim_re_open 
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	
	SELECT *, weeks_since_injury = 0
	INTO #claim_re_open_still_open
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
		and Claim_Closed_Flag <> 'Y'
	
	SELECT *, weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0 
	INTO #claim_open_all
	FROM [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
	WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date) 
			and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
			
			and (case when @Psychological_Claims <> 'all' then Is_Stress else '1' end)
				= (case when @Psychological_Claims <> 'all'	then @Psychological_Claims	else '1' end)

			and (case when @Inactive_Claims <> 'all' then Is_Inactive_Claims else '1' end)
				= (case when @Inactive_Claims <> 'all'	then  @Inactive_Claims	else '1' end)

			and (case when @Medically_Discharged <> 'all' then Is_Medically_Discharged	else '1' end)
				= (case when @Medically_Discharged <> 'all' then @Medically_Discharged else '1'	end)

			and (case when @Exempt_From_Reform <> 'all'	then Is_Exempt	else '1' end)
				= (case when @Exempt_From_Reform <> 'all' then @Exempt_From_Reform	else '1' end)

			and (case when @Reactivation <> 'all' then Is_Reactive	else '1' end)
				= (case when @Reactivation <> 'all'	then @Reactivation	else '1' end)
	
	SELECT * 
	INTO #claim_all 
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open'  from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
			
	SELECT  tmp.Value,Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=tmp.Value)
						
		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=tmp.Value and Is_Medical_Only = 1)
						
		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=tmp.Value and Is_D_D = 1)
		
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=tmp.Value
						and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
		
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=tmp.Value and  Med_Cert_Status = 'TU')
		
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=tmp.Value and  Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
		
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=tmp.Value and  Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
						
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all	where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=tmp.Value and  Med_Cert_Status = 'SID' and Is_Working = 0)
		
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type  and [Value]=@Value and [SubValue]=tmp.Value and  Med_Cert_Status = 'PID')					
		
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=tmp.Value 
						and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=tmp.Value and NCMM_Actions_This_Week <> '')
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type and [Value]=@Value and [SubValue]=tmp.Value and NCMM_Actions_Next_Week <> '') 
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct SubValue as Value
						from [dbo].[udf_PORT_Overall](@System, @Type,@End_Date)
						where Value = @Value and SubValue <> '' and Claim_Closed_Flag <> 'Y'
						group by SubValue
						having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- GET RESULTS
	
	SELECT * FROM #total
	
	UNION ALL
	
	select Value = @Value + "_total", Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	from #total
	group by Claim_Type
	
	DROP TABLE #total
	DROP TABLE #claim_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_new_all
	DROP TABLE #claim_open_all
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_PORT_Sub_Team_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_PORT_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_PORT_Summary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_PORT_Summary]
GO

CREATE PROCEDURE [dbo].[usp_PORT_Summary]
(
	@System VARCHAR(10)
	,@Type VARCHAR(20)
	,@Value NVARCHAR(256)
	,@SubValue NVARCHAR(256)
	,@Start_Date DATETIME
	,@End_Date DATETIME
	,@Claim_Liability_Indicator NVARCHAR(256)
	,@Psychological_Claims VARCHAR(10)
	,@Inactive_Claims VARCHAR(10)
	,@Medically_Discharged VARCHAR(10)
	,@Exempt_From_Reform VARCHAR(10)
	,@Reactivation VARCHAR(10)
)
AS
BEGIN
	IF @Value =  'all'
	BEGIN
		EXEC('EXEC usp_PORT_Agency_Group_Summary ''' + @System + ''',''' + @Type + ''',''' + @Start_Date + ''',''' + @End_Date 
			+ ''',''' + @Claim_Liability_Indicator + ''',''' + @Psychological_Claims + ''',''' + @Inactive_Claims
			+ ''',''' + @Medically_Discharged + ''',''' + @Exempt_From_Reform + ''',''' + @Reactivation + '''')
	END
	ELSE
	BEGIN
		IF @SubValue  = 'all'
		BEGIN
			EXEC('EXEC usp_PORT_Sub_Team_Summary ''' + @System + ''',''' + @Type + ''',''' + @Value + ''',''' + @Start_Date + ''',''' + @End_Date 
				+ ''',''' + @Claim_Liability_Indicator + ''',''' + @Psychological_Claims + ''',''' + @Inactive_Claims
				+ ''',''' + @Medically_Discharged + ''',''' + @Exempt_From_Reform + ''',''' + @Reactivation + '''')
		END
		ELSE
		BEGIN
			EXEC('EXEC usp_PORT_ClaimOfficer_Summary ''' + @System + ''',''' + @Type + ''',''' + @Value + ''',''' + @SubValue + ''',''' + @Start_Date + ''',''' + @End_Date 
				+ ''',''' + @Claim_Liability_Indicator + ''',''' + @Psychological_Claims + ''',''' + @Inactive_Claims
				+ ''',''' + @Medically_Discharged + ''',''' + @Exempt_From_Reform + ''',''' + @Reactivation + '''')
		END
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_PORT_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_TMF_CPR_Dashboard_Agency_Group.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TMF_CPR_Dashboard_Agency_Group]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TMF_CPR_Dashboard_Agency_Group]
GO

CREATE PROCEDURE [dbo].[usp_TMF_CPR_Dashboard_Agency_Group]
(
	@Start_Date datetime
	,@End_Date datetime
	,@Is_Last_Month bit
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING
	
	-- NEW CLAIMS
	SELECT *,[UnitType] =  'agency', weeks_since_injury = 0
	INTO #claim_new_all
		FROM [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	
	-- CLAIM CLOSURES
	SELECT *,[UnitType] = 'agency', weeks_since_injury = 0
	INTO #claim_closure 
		FROM [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS
	SELECT *,[UnitType] = 'agency', weeks_since_injury = 0
	INTO #claim_re_open 
		FROM [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		
	-- REOPEN CLAIMS: STILL OPEN
	SELECT *,[UnitType] = 'agency', weeks_since_injury = 0
	INTO #claim_re_open_still_open 
		FROM [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	
	-- OPEN CLAIMS
	SELECT *,[UnitType] = 'agency', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
	INTO #claim_open_all
		FROM [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
	
	-- drop temp tables
	DROP TABLE #claim_new_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
	DROP TABLE #claim_open_all
	
	SELECT  tmp.[Value] as [Unit], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType])

		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Is_Medical_Only = 1)

		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Is_D_D = 1)
			
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType]
			and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
			
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'TU')
			
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
			
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
							
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 0)
			
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'PID')
			
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType]
			and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and NCMM_Actions_This_Week <> '')
			
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [UnitType]=tmp.[UnitType] and NCMM_Actions_Next_Week <> '')
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, [UnitType] = 'agency'
						from [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
						where Value <> '' and Claim_Closed_Flag <> 'Y'
						group by Value
						having COUNT(*) > 0
					union all
					select distinct Value, [UnitType] = 'group'
						from [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
						where Value <> '' and Claim_Closed_Flag <> 'Y'
						group by Value
						having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- drop temp table
	DROP TABLE #claim_all
	
	-- GET RESULTS
	
	SELECT * FROM #total
		
	UNION ALL -- Grouping Value: Health & Other
		
	SELECT [Unit] = 'HEALTH@@@OTHER',[UnitType] = 'agency', Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	WHERE ([Unit] = 'Health' or [Unit] = 'Other')
	GROUP BY Claim_Type
		
	UNION ALL -- Grouping Value: Police & Fire
		
	SELECT [Unit] = 'POLICE@@@FIRE',[UnitType] = 'agency', Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	WHERE ([Unit] = 'Police' or [Unit] = 'Fire')
	GROUP BY Claim_Type

	UNION ALL -- TMF
		
	SELECT [Unit] = 'TMF',[UnitType] = 'TMF', Claim_Type, SUM(overall) as overall, SUM(med_only) as med_only, SUM(d_d) as d_d, SUM(lum_sum_in) as lum_sum_in, SUM(totally_unfit) as totally_unfit, SUM(ffsd_at_work_15_less) as ffsd_at_work_15_less, SUM(ffsd_at_work_15_more) as ffsd_at_work_15_more, SUM(ffsd_not_at_work) as ffsd_not_at_work, SUM(pid) as pid, SUM(therapy_treat) as therapy_treat, SUM(ncmm_this_week) as ncmm_this_week, SUM(ncmm_next_week) as ncmm_next_week
	FROM #total
	WHERE [UnitType] = 'agency'
	GROUP BY Claim_Type
		
	--drop temp table
	DROP table #total
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_TMF_CPR_Dashboard_Agency_Group.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_TMF_CPR_Dashboard_ClaimOfficer.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TMF_CPR_Dashboard_ClaimOfficer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TMF_CPR_Dashboard_ClaimOfficer]
GO

CREATE PROCEDURE [dbo].[usp_TMF_CPR_Dashboard_ClaimOfficer]
(
	@Start_Date datetime
	,@End_Date datetime
	,@Is_Last_Month bit
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING
	
	-- NEW CLAIMS
	SELECT *,[UnitType] = 'group', weeks_since_injury =  0
	INTO #claim_new_all
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	
	-- CLAIM CLOSURES
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
	INTO #claim_closure
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
	INTO #claim_re_open
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		
	-- REOPEN CLAIMS: STILL OPEN
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
	INTO #claim_re_open_still_open
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	
	-- OPEN CLAIMS
	SELECT *,[UnitType] = 'group', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
	INTO #claim_open_all
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
	
	-- drop temp tables
	DROP TABLE #claim_new_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
	DROP TABLE #claim_open_all
	
	SELECT  tmp.[SubValue2] as [Unit], tmp.[SubValue] as [Primary], tmp.[Value] as [Parent], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType])

		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Is_Medical_Only = 1)

		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Is_D_D = 1)
			
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType]
			and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
			
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'TU')
			
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
			
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
							
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 0)
			
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'PID')
			
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType]
			and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and NCMM_Actions_This_Week <> '')
			
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue2]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType] and NCMM_Actions_Next_Week <> '')
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, SubValue, SubValue2, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and SubValue2 <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue, SubValue2
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- add an overall column for team
	SELECT  tmp.[SubValue2] as [Unit], tmp.[SubValue] as [Primary], tmp.[Value] as [Parent], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [SubValue]=tmp.[SubValue2] 
			and [UnitType]=tmp.[UnitType])

		,med_only = 0
		,d_d = 0
		,lum_sum_in = 0
		,totally_unfit = 0
		,ffsd_at_work_15_less = 0
		,ffsd_at_work_15_more = 0
		,ffsd_not_at_work = 0
		,pid = 0
		,therapy_treat = 0
		,ncmm_this_week = 0
		,ncmm_next_week = 0
	INTO #total2
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, SubValue, [SubValue2] = SubValue, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0) as tmp_value
	) as tmp
	-- drop temp table
	DROP TABLE #claim_all
	
	-- GET RESULTS
	SELECT * FROM #total
	UNION ALL
	SELECT * FROM #total2
		
	--drop temp table
	DROP table #total
	DROP table #total2
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_TMF_CPR_Dashboard_ClaimOfficer.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_TMF_CPR_Dashboard_Sub_Team.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TMF_CPR_Dashboard_Sub_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TMF_CPR_Dashboard_Sub_Team]
GO

CREATE PROCEDURE [dbo].[usp_TMF_CPR_Dashboard_Sub_Team]
(
	@Start_Date datetime
	,@End_Date datetime
	,@Is_Last_Month bit
)
AS
BEGIN
	-- PREPARE DATA FOR QUERYING
	
	-- NEW CLAIMS
	SELECT *,[UnitType] = 'agency', weeks_since_injury =  0
	INTO #claim_new_all 
		FROM [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE Date_Claim_Received between @Start_Date and @End_Date
	
	-- CLAIM CLOSURES
	SELECT *,[UnitType] = 'agency', weeks_since_injury = 0
	INTO #claim_closure 
		FROM [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE Date_Claim_Closed between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS
	SELECT *,[UnitType] = 'agency', weeks_since_injury = 0
	INTO #claim_re_open 
		FROM [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		
	-- REOPEN CLAIMS: STILL OPEN
	SELECT *,[UnitType] = 'agency', weeks_since_injury = 0
	INTO #claim_re_open_still_open 
		FROM [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = 0
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE Date_Claim_Reopened between @Start_Date and @End_Date
			and (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
			and Claim_Closed_Flag <> 'Y'
	
	-- OPEN CLAIMS
	SELECT *,[UnitType] = 'agency', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
	INTO #claim_open_all
		FROM [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	UNION ALL
	SELECT *,[UnitType] = 'group', weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0
		FROM [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
		WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date)
				and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
			   union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
			   union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
			   union all select *,claim_type='claim_closure' from #claim_closure
			   union all select *,claim_type='claim_re_open' from #claim_re_open
			   union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   union all select *,claim_type='claim_open_all' from #claim_open_all
			   union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
			   union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
			   union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
			   union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
			   union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
			   union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
			   union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
			   union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> ''
			   union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
			   union all select *,claim_type='claim_open_acupuncture' from #claim_open_all WHERE Acupuncture_Paid > 0
			   union all select *,claim_type='claim_open_chiro' from #claim_open_all  WHERE Chiro_Paid > 1000
			   union all select *,claim_type='claim_open_massage' from #claim_open_all  WHERE Massage_Paid > 0
			   union all select *,claim_type='claim_open_osteo' from #claim_open_all  WHERE Osteopathy_Paid > 0
			   union all select *,claim_type='claim_open_physio' from #claim_open_all  WHERE Physio_Paid > 2000
			   union all select *,claim_type='claim_open_rehab' from #claim_open_all WHERE Rehab_Paid > 0
			   union all select *,claim_type='claim_open_death' from #claim_open_all WHERE Result_Of_Injury_Code = 1
			   union all select *,claim_type='claim_open_industrial_deafness' from #claim_open_all  WHERE Is_Industrial_Deafness = 1
			   union all select *,claim_type='claim_open_ppd' from #claim_open_all  WHERE Result_Of_Injury_Code = 3
			   union all select *,claim_type='claim_open_recovery' from #claim_open_all WHERE Total_Recoveries <> 0
			   union all select *,claim_type='claim_open_wpi_all' from #claim_open_all WHERE WPI > 0
			   union all select *,claim_type='claim_open_wpi_0_10' from #claim_open_all WHERE WPI > 0 AND WPI <= 10
			   union all select *,claim_type='claim_open_wpi_11_14' from #claim_open_all WHERE WPI >= 11 AND WPI <= 14
			   union all select *,claim_type='claim_open_wpi_15_20' from #claim_open_all WHERE WPI >= 15 AND WPI <= 20
			   union all select *,claim_type='claim_open_wpi_21_30' from #claim_open_all WHERE WPI >= 21 AND WPI <= 30
			   union all select *,claim_type='claim_open_wpi_31_more' from #claim_open_all WHERE WPI >= 31
			   union all select *,claim_type='claim_open_wid' from #claim_open_all WHERE Common_Law = 1
			   ) as tmp
	
	-- drop temp tables
	DROP TABLE #claim_new_all
	DROP TABLE #claim_closure
	DROP TABLE #claim_re_open
	DROP TABLE #claim_re_open_still_open
	DROP TABLE #claim_open_all
	
	SELECT  tmp.[SubValue] as [Unit], tmp.[Value] as [Primary], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType])

		,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Is_Medical_Only = 1)

		,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Is_D_D = 1)
			
		,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType]
			and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1))
			
		,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'TU')
			
		,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek <= 15)
			
		,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 1 and HoursPerWeek > 15)
							
		,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'SID' and Is_Working = 0)
			
		,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and Med_Cert_Status = 'PID')
			
		,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType]
			and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0))		
		
		,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and NCMM_Actions_This_Week <> '')
			
		,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [SubValue]=tmp.[SubValue] and [UnitType]=tmp.[UnitType] and NCMM_Actions_Next_Week <> '')
	INTO #total
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, SubValue, [UnitType] = 'agency'
							from [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0
					union all
					select distinct Value, SubValue, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
							where Value <> '' and SubValue <> '' and Claim_Closed_Flag <> 'Y'
							group by Value, SubValue
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- add an overall row for teams or agencies
	SELECT  tmp.[SubValue] + '_total' as [Unit], tmp.[Value] as [Primary], tmp.[UnitType], Claim_type
		,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type =tmp.Claim_Type 
			and [Value]=tmp.[Value] and [Value]=tmp.[SubValue] and [UnitType]=tmp.[UnitType])
			
		,med_only = 0
		,d_d = 0			
		,lum_sum_in = 0
		,totally_unfit = 0
		,ffsd_at_work_15_less = 0
		,ffsd_at_work_15_more = 0
		,ffsd_not_at_work = 0
		,pid = 0
		,therapy_treat=0
		,ncmm_this_week = 0
		,ncmm_next_week = 0
	INTO #total2
	FROM
	(
		select * from dbo.uv_PORT_Get_All_Claim_Type
		cross join (select distinct Value, [SubValue] = Value, [UnitType] = 'agency'
							from [dbo].[udf_CPR_Overall]('TMF', 'agency', @Is_Last_Month)
							where Value <> '' and Claim_Closed_Flag <> 'Y'
							group by Value
							having COUNT(*) > 0
					union all
					select distinct Value, [SubValue] = Value, [UnitType] = 'group'
							from [dbo].[udf_CPR_Overall]('TMF', 'group', @Is_Last_Month)
							where Value <> '' and Claim_Closed_Flag <> 'Y'
							group by Value
							having COUNT(*) > 0) as tmp_value
	) as tmp
	
	-- drop temp table
	DROP TABLE #claim_all
	
	-- GET RESULTS
	SELECT * FROM #total 
	union all 
	SELECT * FROM #total2
		
	--drop temp table
	DROP table #total
	DROP table #total2
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Tags\1.5\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_TMF_CPR_Dashboard_Sub_Team.sql  
--------------------------------  
