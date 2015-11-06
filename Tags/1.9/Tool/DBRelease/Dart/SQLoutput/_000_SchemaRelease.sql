---------------------------------------------------------- 
------------------- SchemaChange 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\CPR_Monthly.sql  
--------------------------------  
/****** Object:  Table [dbo].[CPR_Monthly]    Script Date: 04/10/2015 08:24:30 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CPR_Monthly]') AND type in (N'U'))	
BEGIN	
	CREATE TABLE [dbo].[CPR_Monthly](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[System] [varchar](10) NOT NULL,
		[Type] [varchar](20) NOT NULL,
		[Value] [varchar](256) NOT NULL,
		[Primary] [varchar](256) NOT NULL,
		[ClaimType] [varchar](20) NOT NULL,
		[Month_Year] [varchar](20) NOT NULL,
		[Start_Date] [datetime] NOT NULL,
		[End_Date] [datetime] NOT NULL,
		[No_Of_Port_Claims] [int] NOT NULL
	 CONSTRAINT [PK_CPR_Monthly] PRIMARY KEY CLUSTERED 
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\CPR_Monthly.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dart_SchemaChange.sql  
--------------------------------  

update HEM_AWC_Projections set Unit_Name = 'Miscellaneous' where Unit_Type = 'group' and Unit_Name = 'Other'
update TMF_AWC_Projections set Unit_Name = 'Miscellaneous' where Unit_Type = 'group' and Unit_Name = 'Other'
update EML_AWC_Projections set Unit_Name = 'Miscellaneous' where Unit_Type = 'group' and Unit_Name = 'Other'

----delete old cpr full report----
delete from reports where Name like '%portfolio%'
-----Clean up store/udf/view

/* Drop all non-system stored procs */ 
DECLARE @name VARCHAR(128) 
DECLARE @SQL VARCHAR(254) 
SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'P' AND category = 0 ORDER BY [name]) 
WHILE @name is not null and CHARINDEX('usp_',@name) >0
BEGIN 
	SELECT @SQL = 'DROP PROCEDURE [dbo].[' + RTRIM(@name) +']' 			
	EXEC (@SQL) 
	PRINT 'Dropped Procedure: ' + @name 
	SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'P' AND category = 0 AND [name] > @name ORDER BY [name]) 
END 

/* Drop all views */ 	
SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'V' AND category = 0 ORDER BY [name]) 
WHILE @name IS NOT NULL 
BEGIN 
	SELECT @SQL = 'DROP VIEW [dbo].[' + RTRIM(@name) +']' 
	EXEC (@SQL) 
	PRINT 'Dropped View: ' + @name 
	SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'V' AND category = 0 AND [name] > @name ORDER BY [name]) 
END 

/* Drop all functions */	
SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] IN (N'FN', N'IF', N'TF', N'FS', N'FT') AND category = 0 ORDER BY [name]) 
WHILE @name IS NOT NULL and CHARINDEX('udf_',@name) >0
BEGIN 
	SELECT @SQL = 'DROP FUNCTION [dbo].[' + RTRIM(@name) +']' 
	EXEC (@SQL) 
	PRINT 'Dropped Function: ' + @name 
	SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] IN (N'FN', N'IF', N'TF', N'FS', N'FT') AND category = 0 AND [name] > @name ORDER BY [name]) 
END

/* Update Url for CPR dashboards */
UPDATE Dashboards
	SET Url = 'Level0,TMF_Level1,TMF_CPR_Week_Month_Summary,CPR_Summary,CPR_Summary,CPR_Summary,CPR_Summary,CPR_Summary', 
		[Description] = null,
		[Status] = 1
	WHERE UPPER(RTRIM(Name)) like '%TMF%' and  UPPER(RTRIM(Name)) like '%CPR%'
	
UPDATE Dashboards
	SET Url = 'Level0,EML_Level1,EML_CPR_Week_Month_Summary,CPR_Summary,CPR_Summary,CPR_Summary,CPR_Summary,CPR_Summary', 
		[Description] = null,
		[Status] = 1
	WHERE UPPER(RTRIM(Name)) like '%EML%' and  UPPER(RTRIM(Name)) like '%CPR%'
	
UPDATE Dashboards
	SET Url = 'Level0,HEM_Level1,HEM_CPR_Week_Month_Summary,CPR_Summary,CPR_Summary,CPR_Summary,CPR_Summary,CPR_Summary', 
		[Description] = null,
		[Status] = 1
	WHERE UPPER(RTRIM(Name)) like '%HEM%' and  UPPER(RTRIM(Name)) like '%CPR%'--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dart_SchemaChange.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_Favours.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_Favours.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_Graph_Description.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_Graph_Description.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_TimeAccess.sql  
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
			ADD Url varchar (MAX) null
		END
		ELSE 
		BEGIN
			ALTER TABLE [dbo].[Dashboard_TimeAccess]
			ALTER COLUMN Url varchar (MAX) null
		END
	END
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_TimeAccess.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_Traffic_Light_Rules.sql  
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
ELSE
	BEGIN
		UPDATE [dbo].[Dashboard_Traffic_Light_Rules]
		SET	[Description] = '< -5%'
		WHERE [Name] = 'Superb' 
		AND [DashboardType] = 'RTW'
		
		UPDATE [dbo].[Dashboard_Traffic_Light_Rules]
		SET	[Description] = '< -6%'
		WHERE [Name] = 'Superb'
		AND [DashboardType] = 'AWC'
	END
GO
SET ANSI_PADDING OFF
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\Dashboard_Traffic_Light_Rules.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_AWC.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EML_AWC]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[EML_AWC](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Time_ID] [datetime] NOT NULL,
			[Claim_no] [varchar](19) NULL,
			[Team] [varchar](20) NULL,
			[Case_manager] [varchar](81) NULL,
			[Date_of_Injury] [datetime] NULL,
			[create_date] [datetime]  DEFAULT GETDATE(),		
			[POLICY_NO] [char](19) NULL,
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
		IF COL_LENGTH('EML_AWC','AgencyName') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			DROP COLUMN AgencyName
		END
		IF COL_LENGTH('EML_AWC','Sub_Category') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			DROP COLUMN Sub_Category
		END
		IF COL_LENGTH('EML_AWC','Agency_Id') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			DROP COLUMN Agency_Id
		END
		IF COL_LENGTH('EML_AWC','Group') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_AWC]
			DROP COLUMN [Group]
		END
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_AWC.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_AWC_Projections.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_AWC_Projections.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_Portfolio.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EML_Portfolio]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[EML_Portfolio](				
			[Id] [int] IDENTITY(1,1) NOT NULL,
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
			--[Gateway_Status] [varchar] (256) NULL
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
	IF COL_LENGTH('EML_Portfolio','Agency_Name') IS NOT NULL
	BEGIN	
		ALTER TABLE [dbo].[EML_Portfolio]
		DROP COLUMN Agency_Name
	END
	IF COL_LENGTH('EML_Portfolio','Sub_Category') IS NOT NULL
	BEGIN	
		ALTER TABLE [dbo].[EML_Portfolio]
		DROP COLUMN Sub_Category
	END
	IF COL_LENGTH('EML_Portfolio','Agency_Id') IS NOT NULL
	BEGIN	
		ALTER TABLE [dbo].[EML_Portfolio]
		DROP COLUMN Agency_Id
	END
	IF COL_LENGTH('EML_Portfolio','Group') IS NOT NULL
	BEGIN	
		ALTER TABLE [dbo].[EML_Portfolio]
		DROP COLUMN [Group]
	END
	IF COL_LENGTH('EML_Portfolio','IsPreClosed') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[EML_Portfolio]
		ADD IsPreClosed bit NULL	
	END	
	IF COL_LENGTH('EML_Portfolio','IsPreOpened') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[EML_Portfolio]
		ADD IsPreOpened bit NULL	
	END
	
	-- NCMM Actions
	IF COL_LENGTH('EML_Portfolio','NCMM_Complete_Action_Due') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[EML_Portfolio]
		ADD [NCMM_Complete_Action_Due] [datetime] NULL
	END
	IF COL_LENGTH('EML_Portfolio','NCMM_Complete_Remaining_Days') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[EML_Portfolio]
		ADD [NCMM_Complete_Remaining_Days] [int] NULL
	END
	IF COL_LENGTH('EML_Portfolio','NCMM_Prepare_Action_Due') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[EML_Portfolio]
		ADD [NCMM_Prepare_Action_Due] [datetime] NULL
	END
	IF COL_LENGTH('EML_Portfolio','NCMM_Prepare_Remaining_Days') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[EML_Portfolio]
		ADD [NCMM_Prepare_Remaining_Days] [int] NULL
	END
	
	IF COL_LENGTH('EML_Portfolio','Med_Cert_Status_Next_Week') IS NOT NULL
	BEGIN
		IF EXISTS (SELECT name FROM sysindexes WHERE name = 'idx_EML_Portfolio_RAW_Data')
		BEGIN
			DROP INDEX idx_EML_Portfolio_RAW_Data ON [dbo].[EML_Portfolio]
		END
	
		ALTER TABLE [dbo].[EML_Portfolio]
		DROP COLUMN [Med_Cert_Status_Next_Week]
	END
	
	--IF COL_LENGTH('EML_Portfolio','Gateway_Status') IS NULL
	--BEGIN	
	--	ALTER TABLE [dbo].[EML_Portfolio]
	--	ADD Gateway_Status [varchar] (256) NULL
	--END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_Portfolio.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_RTW.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EML_RTW]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[EML_RTW](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Remuneration_Start] [datetime] NULL,
			[Remuneration_End] [datetime] NULL,
			[Measure_months] [bigint] NULL,
			[Team] [varchar](20) NULL,
			[Case_manager] [varchar](81) NULL,
			[Claim_no] [varchar](20) NULL,
			[DTE_OF_INJURY] [datetime] NULL,
			[POLICY_NO] [char](19) NULL,
			[LT] [float] NULL,
			[WGT] [float] NULL,
			[EMPL_SIZE] [varchar](256) NULL,
			[Weeks_paid][float] NULL,
			[create_date] [datetime]  DEFAULT GETDATE(),
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
		IF COL_LENGTH('EML_RTW','AgencyName') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			DROP COLUMN AgencyName
		END
		IF COL_LENGTH('EML_RTW','Sub_Category') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			DROP COLUMN Sub_Category
		END
		IF COL_LENGTH('EML_RTW','Agency_Id') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			DROP COLUMN Agency_Id
		END
		IF COL_LENGTH('EML_RTW','Group') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW]
			DROP COLUMN [Group]
		END
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_RTW_Target_Base.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_RTW_Target_Base.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_SIW.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EML_SIW]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[EML_SIW](
		[Claim_no] [varchar](20) NULL
	) ON [PRIMARY]
	
	-- INSERT DATA
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'107672016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'108301016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'112062016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'114079016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'129066016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'138561016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'144549016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'154794016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'154925016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'155159016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'158578016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'162143016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'162625016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'162819016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'163788016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'164337016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'167311016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'175780016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'178215016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'183512016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'186829016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'186897016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'189373016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'189796016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'190347016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'191194016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'194408016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'196294016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'197100016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'201222016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'201259016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'201503016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'203539016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'206119016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'207514016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'209481016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'211845016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'212677016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'213724016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'216016016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'216269016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'216332016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'217731016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'217790016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'218554016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'218904016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'219024016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'221955016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'223565016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'230118016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'232716016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'232858016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'233002016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'233063016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'265699016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'272124122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'871099016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'912289016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'941722016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'954221016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'964101016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'2162946122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'3005566122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'95881468122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'97723597122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'97738938122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'97919288122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'98060033122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'98070748122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'98160530122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'98179214122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'101425420122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'101431308122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'338001070122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'388000805122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'2MAB0097326122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'2MCF0082209122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'2MLN0096236122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'930018A016')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'C0048468122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'O1029105122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'O6005782122')
	INSERT [dbo].[EML_SIW] ([Claim_no]) VALUES (N'O8000270122')
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\EML_SIW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_AWC.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEM_AWC]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[HEM_AWC](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Time_ID] [datetime] NOT NULL,
			[Claim_no] [varchar](19) NULL,
			[Team] [varchar](20) NULL,
			[Case_manager] [varchar](81) NULL,
			[Date_of_Injury] [datetime] NULL,
			[create_date] [datetime]  DEFAULT GETDATE(),		
			[POLICY_NO] [char](19) NULL,
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
		IF COL_LENGTH('HEM_AWC','AgencyName') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			DROP COLUMN AgencyName
		END
		IF COL_LENGTH('HEM_AWC','Sub_Category') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			DROP COLUMN Sub_Category
		END
		IF COL_LENGTH('HEM_AWC','Agency_Id') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			DROP COLUMN Agency_Id
		END
		IF COL_LENGTH('HEM_AWC','Group') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_AWC]
			DROP COLUMN [Group]
		END
	END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_AWC.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_AWC_Projections.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_AWC_Projections.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_Portfolio.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEM_Portfolio]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[HEM_Portfolio](				
			[Id] [int] IDENTITY(1,1) NOT NULL,
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
			--[Gateway_Status] [varchar] (256) NULL
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
	IF COL_LENGTH('HEM_Portfolio','Agency_Name') IS NOT NULL
	BEGIN	
		ALTER TABLE [dbo].[HEM_Portfolio]
		DROP COLUMN Agency_Name
	END
	IF COL_LENGTH('HEM_Portfolio','Sub_Category') IS NOT NULL
	BEGIN	
		ALTER TABLE [dbo].[HEM_Portfolio]
		DROP COLUMN Sub_Category
	END
	IF COL_LENGTH('HEM_Portfolio','Agency_Id') IS NOT NULL
	BEGIN	
		ALTER TABLE [dbo].[HEM_Portfolio]
		DROP COLUMN Agency_Id
	END
	IF COL_LENGTH('HEM_Portfolio','Group') IS NOT NULL
	BEGIN	
		ALTER TABLE [dbo].[HEM_Portfolio]
		DROP COLUMN [Group]
	END
	IF COL_LENGTH('HEM_Portfolio','IsPreClosed') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[HEM_Portfolio]
		ADD IsPreClosed bit NULL	
	END	
	IF COL_LENGTH('HEM_Portfolio','IsPreOpened') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[HEM_Portfolio]
		ADD IsPreOpened bit NULL	
	END
	
	-- NCMM Actions
	IF COL_LENGTH('HEM_Portfolio','NCMM_Complete_Action_Due') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[HEM_Portfolio]
		ADD [NCMM_Complete_Action_Due] [datetime] NULL
	END
	IF COL_LENGTH('HEM_Portfolio','NCMM_Complete_Remaining_Days') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[HEM_Portfolio]
		ADD [NCMM_Complete_Remaining_Days] [int] NULL
	END
	IF COL_LENGTH('HEM_Portfolio','NCMM_Prepare_Action_Due') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[HEM_Portfolio]
		ADD [NCMM_Prepare_Action_Due] [datetime] NULL
	END
	IF COL_LENGTH('HEM_Portfolio','NCMM_Prepare_Remaining_Days') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[HEM_Portfolio]
		ADD [NCMM_Prepare_Remaining_Days] [int] NULL
	END
	
	IF COL_LENGTH('HEM_Portfolio','Med_Cert_Status_Next_Week') IS NOT NULL
	BEGIN	
		IF EXISTS (SELECT name FROM sysindexes WHERE name = 'idx_HEM_Portfolio_RAW_Data')
		BEGIN
			DROP INDEX idx_HEM_Portfolio_RAW_Data ON [dbo].[HEM_Portfolio]
		END

		ALTER TABLE [dbo].[HEM_Portfolio]
		DROP COLUMN [Med_Cert_Status_Next_Week]
	END
	
	--IF COL_LENGTH('HEM_Portfolio','Gateway_Status') IS NULL
	--BEGIN	
	--	ALTER TABLE [dbo].[HEM_Portfolio]
	--	ADD Gateway_Status [varchar] (256) NULL
	--END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_Portfolio.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_RTW.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEM_RTW]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[HEM_RTW](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Remuneration_Start] [datetime] NULL,
			[Remuneration_End] [datetime] NULL,
			[Measure_months] [bigint] NULL,
			[Team] [varchar](20) NULL,
			[Case_manager] [varchar](81) NULL,
			[Claim_no] [varchar](20) NULL,
			[DTE_OF_INJURY] [datetime] NULL,
			[POLICY_NO] [char](19) NULL,
			[LT] [float] NULL,
			[WGT] [float] NULL,
			[EMPL_SIZE] [varchar](256) NULL,
			[Weeks_paid][float] NULL,
			[create_date] [datetime]  DEFAULT GETDATE(),
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
		IF COL_LENGTH('HEM_RTW','AgencyName') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			DROP COLUMN AgencyName
		END
		IF COL_LENGTH('HEM_RTW','Sub_Category') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			DROP COLUMN Sub_Category
		END
		IF COL_LENGTH('HEM_RTW','Agency_Id') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			DROP COLUMN Agency_Id
		END
		IF COL_LENGTH('HEM_RTW','Group') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[HEM_RTW]
			DROP COLUMN [Group]
		END
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_RTW_Target_Base.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\HEM_RTW_Target_Base.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_Agencies_Sub_Category.sql  
--------------------------------  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMF_Agencies_Sub_Category]') AND type in (N'U'))
DROP TABLE [dbo].[TMF_Agencies_Sub_Category]
GO	

CREATE TABLE [dbo].[TMF_Agencies_Sub_Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AgencyId] [varchar](20) NULL,
	[AgencyName] [char](20) NULL,
	[Sub_Category] [varchar](256) NULL,
	[POLICY_NO] [char](19) NULL,
	[Group] [varchar](50) NULL,
 CONSTRAINT [PK_TMF_Agencies_Sub_Category] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

-- INSERT DATA
SET IDENTITY_INSERT [dbo].[TMF_Agencies_Sub_Category] ON
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900321', N'10010', N'OTHER', N'OTHER - THE LEGISLATURE', N'1', 1)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900331', N'10015', N'OTHER', N'OTHER - CABINET OFFICE', N'1', 2)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900772', N'10015', N'OTHER', N'OTHER - CABINET OFFICE', N'1', 3)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900275', N'10020', N'OTHER', N'OTHER - DEPARTMENT OF PREMIER AND CABINET', N'1', 4)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900665', N'10020', N'OTHER', N'OTHER - PUBLIC EMPLOYMENT OFFICE', N'1', 5)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900773', N'10025', N'OTHER', N'OTHER - PARLIAMENTARY COUNSEL''S OFFICE', N'1', 6)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900547', N'10035', N'OTHER', N'OTHER - INDEPENDENT PRICING AND REGULATORY TRIBUNAL', N'1', 7)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900327', N'10045', N'OTHER', N'OTHER - INDEPENDENT COMMISSION AGAINST CORRUPTION', N'1', 8)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900305', N'10050', N'OTHER', N'OTHER - NSW OMBUDSMAN', N'1', 9)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10083', N'10052', N'OTHER', N'OTHER - PUBLIC SERVICE COMMISSION', N'1', 10)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900311', N'10060', N'OTHER', N'OTHER - NSW ELECTORAL COMMISSION', N'1', 11)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900310', N'10065', N'OTHER', N'OTHER - NSW CRIME COMMISSION', N'1', 12)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900306', N'10069', N'OTHER', N'OTHER - DEPARTMENT OF URBAN AFFAIRS', N'3', 13)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900695', N'10069', N'OTHER', N'OTHER - MINISTRY OF URBAN INFRASTRUCTURE MANAGEM', N'Miscellaneous', 14)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900397', N'10090', N'OTHER', N'OTHER - SOUTHERN METROPOLITIAN DEVELOP', N'Miscellaneous', 15)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900398', N'10090', N'OTHER', N'OTHER - WESTERN SYDNEY DEVELOPMENTAL DISABILITY', N'Miscellaneous', 16)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'MWJ3333309', N'10142', N'OTHER', N'OTHER - WORLD YOUTH DAY COORDINATION', N'Miscellaneous', 17)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'MWJ3333297', N'10250', N'POLICE', N'POLICE - SOUTH WEST METRO', N'7', 18)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900264', N'10250', N'POLICE', N'POLICE - OTHER', N'8', 19)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900332', N'10250', N'POLICE', N'POLICE - OTHER', N'5', 20)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900537', N'10250', N'POLICE', N'POLICE - OTHER', N'5', 21)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900538', N'10250', N'POLICE', N'POLICE - OPERATIONAL SUPPORT', N'5', 22)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900539', N'10250', N'POLICE', N'POLICE - NORTHERN REGION', N'7', 23)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900540', N'10250', N'POLICE', N'POLICE - NORTH-WEST REGION', N'7', 24)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900541', N'10250', N'POLICE', N'POLICE - SOUTHERN REGION', N'5', 25)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900542', N'10250', N'POLICE', N'POLICE - OTHER', N'7', 26)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900543', N'10250', N'POLICE', N'POLICE - OTHER', N'8', 27)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900544', N'10250', N'POLICE', N'POLICE - OTHER', N'8', 28)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900631', N'10250', N'POLICE', N'POLICE - OTHER', N'7', 29)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900720', N'10250', N'POLICE', N'POLICE - OTHER', N'7', 30)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900721', N'10250', N'POLICE', N'POLICE - OTHER', N'5', 31)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900722', N'10250', N'POLICE', N'POLICE - OTHER', N'5', 32)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900723', N'10250', N'POLICE', N'POLICE - OTHER', N'7', 33)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900724', N'10250', N'POLICE', N'POLICE - OTHER', N'7', 34)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900725', N'10250', N'POLICE', N'POLICE - OTHER', N'5', 35)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900726', N'10250', N'POLICE', N'POLICE - OTHER', N'5', 36)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900727', N'10250', N'POLICE', N'POLICE - OTHER', N'7', 37)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900728', N'10250', N'POLICE', N'POLICE - OTHER', N'5', 38)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900729', N'10250', N'POLICE', N'POLICE - OTHER', N'7', 39)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900730', N'10250', N'POLICE', N'POLICE - OTHER', N'8', 40)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900731', N'10250', N'POLICE', N'POLICE - OTHER', N'8', 41)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900732', N'10250', N'POLICE', N'POLICE - OTHER', N'8', 42)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900733', N'10250', N'POLICE', N'POLICE - OTHER', N'5', 43)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900734', N'10250', N'POLICE', N'POLICE - OTHER', N'5', 44)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900735', N'10250', N'POLICE', N'POLICE - OTHER', N'5', 45)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900854', N'10250', N'POLICE', N'POLICE - CENTRAL METROPOLITAN', N'8', 46)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900855', N'10250', N'POLICE', N'POLICE - NORTH WEST METRO', N'7', 47)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900856', N'10250', N'POLICE', N'POLICE - NORTHERN REGION', N'7', 48)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900857', N'10250', N'POLICE', N'POLICE - SOUTHERN REGION', N'5', 49)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900859', N'10250', N'POLICE', N'POLICE - SPECIALIST OPERATIONS', N'5', 50)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900860', N'10250', N'POLICE', N'POLICE - OPERATIONS SUPPORT', N'5', 51)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900861', N'10250', N'POLICE', N'POLICE - OTHER', N'5', 52)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900862', N'10250', N'POLICE', N'POLICE - WESTERN REGION', N'8', 53)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900630', N'10255', N'POLICE', N'POLICE - OTHER', N'7', 54)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900266', N'10260', N'OTHER', N'OTHER - SES', N'5', 55)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900477', N'10260', N'OTHER', N'OTHER - SES', N'5', 56)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10082', N'10265', N'OTHER', N'OTHER - SES', N'5', 57)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900276', N'10270', N'OTHER', N'OTHER - DCS', N'5', 58)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900592', N'10270', N'OTHER', N'OTHER - DCS', N'5', 59)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900593', N'10270', N'OTHER', N'OTHER - DCS', N'5', 60)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900594', N'10270', N'OTHER', N'OTHER - DCS', N'5', 61)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900595', N'10270', N'OTHER', N'OTHER - DCS', N'5', 62)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900596', N'10270', N'OTHER', N'OTHER - DCS', N'5', 63)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900597', N'10270', N'OTHER', N'OTHER - DCS', N'5', 64)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900789', N'10270', N'OTHER', N'OTHER - DCS', N'5', 65)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900790', N'10270', N'OTHER', N'OTHER - DCS', N'5', 66)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900536', N'10275', N'OTHER', N'OTHER - DJJ', N'5', 67)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900302', N'10280', N'OTHER', N'OTHER - DEPARTMENT OF LOCAL GOVERNMENT', N'1', 68)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'MWJ3333319', N'10305', N'OTHER', N'OTHER - LPMA-STRATEGIC LANDS', N'2', 69)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'MWJ3333320', N'10305', N'OTHER', N'OTHER - LPMA - HUNTER DEVELOPMENT CORP', N'2', 70)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10067', N'10305', N'OTHER', N'OTHER - WASTE ASSET MANAGEMENT CORPORATION', N'2', 71)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900746', N'10305', N'OTHER', N'OTHER - LAND PROPERTY INFORMATION', N'2', 72)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900871', N'10305', N'OTHER', N'OTHER - LAND AND PROPERTY MANAGEMENT AUTHORITY', N'2', 73)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900263', N'10355', N'FIRE', N'FIRE - FIRE AND RESCUE NSW', N'8', 74)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10116', N'10355', N'FIRE', N'FIRE - OTHER', N'8', 75)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10117', N'10355', N'FIRE', N'FIRE - OTHER', N'8', 76)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10118', N'10355', N'FIRE', N'FIRE - OTHER', N'8', 77)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10119', N'10355', N'FIRE', N'FIRE - OTHER', N'8', 78)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10120', N'10355', N'FIRE', N'FIRE - OTHER', N'8', 79)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10121', N'10355', N'FIRE', N'FIRE - OTHER', N'8', 80)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10122', N'10355', N'FIRE', N'FIRE - METROPOLITAN', N'8', 81)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10123', N'10355', N'FIRE', N'FIRE - METROPOLITAN', N'8', 82)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10124', N'10355', N'FIRE', N'FIRE - METROPOLITAN', N'8', 83)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10125', N'10355', N'FIRE', N'FIRE - METROPOLITAN', N'8', 84)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10126', N'10355', N'FIRE', N'FIRE - REGIONAL', N'8', 85)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10127', N'10355', N'FIRE', N'FIRE - REGIONAL', N'8', 86)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10128', N'10355', N'FIRE', N'FIRE - REGIONAL', N'8', 87)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10129', N'10355', N'FIRE', N'FIRE - OTHER', N'8', 88)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10130', N'10355', N'FIRE', N'FIRE - OTHER', N'8', 89)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10131', N'10355', N'FIRE', N'FIRE - OTHER', N'8', 90)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900265', N'10405', N'RFS', N'RFS - DEPARTMENT OF RURAL FIRE SERVICES', N'8', 91)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900599', N'10460', N'OTHER', N'OTHER - THE DEPARTMENT FOR WOMEN', N'3', 92)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900907', N'10475', N'OTHER', N'OTHER - REDFERN WATERLOO AUTHORITY', N'2', 93)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'MWJ3333294', N'10500', N'OTHER', N'OTHER - DEPARTMENT OF PLANNING', N'1', 94)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900694', N'10500', N'OTHER', N'OTHER - HERITAGE OFFICE', N'1', 95)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10087', N'10594', N'OTHER', N'OTHER - INFRASTRUCTURE NSW', N'1', 96)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10084', N'10597', N'OTHER', N'OTHER - DEVELOPMENT AUTHORITY', N'1', 97)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10132', N'10644', N'OTHER', N'TRANSGRID', N'1', 98)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900288', N'15506', N'OTHER', N'OTHER - THE AUDIT OFFICE OF NSW', N'1', 99)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900795', N'15513', N'OTHER', N'OTHER - CORPORATION SOLE', N'3', 100)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900317', N'15523', N'OTHER', N'OTHER - LAND AND PROPERTY INFORMATION', N'2', 101)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900565', N'15524', N'OTHER', N'OTHER - LUNA PARK RESERVE TRUST', N'Miscellaneous', 102)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900318', N'15549', N'OTHER', N'OTHER - VALUER GENERAL S OFFICE', N'3', 103)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'MWJ3333303', N'15595', N'OTHER', N'OTHER - LPMA - STATE PROPERTY AUTHORITY', N'2', 104)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'MWJ3333315', N'15596', N'OTHER', N'OTHER - BARANGAROO DELIVERY AUTHORITY', N'Miscellaneous', 105)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900576', N'15851', N'OTHER', N'OTHER - ANZAC MEMORIAL TRUST', N'1', 106)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900608', N'15864', N'OTHER', N'OTHER - NATIONAL TRUST OF AUSTRALIA (NSW)', N'Miscellaneous', 107)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900611', N'15864', N'OTHER', N'OTHER - NATIONAL TRUST OF AUSTRALIA (NSW)', N'1', 108)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900633', N'20608', N'OTHER', N'OTHER - CITY WEST HOUSING', N'Miscellaneous', 109)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900291', N'20653', N'OTHER', N'OTHER - SYDNEY HARBOUR FORESHORE AUTHORITY', N'1', 110)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900415', N'20653', N'OTHER', N'OTHER - SYDNEY HARBOUR FORESHORE AUTHORITY', N'1', 111)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900775', N'20653', N'OTHER', N'OTHER - SYDNEY HARBOUR FORESHORE AUTHORITY', N'1', 112)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10068', N'25664', N'OTHER', N'OTHER - COBBORA HOLDING COMPANY PTY LTD', N'Miscellaneous', 113)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10029', N'10090J', N'HEALTH', N'HEALTH - SYDNEY CHILDREN''S HOSPITAL NETWORK', N'2', 114)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10078', N'10090J', N'HEALTH', N'HEALTH - SYDNEY CHILDREN''S HOSPITAL NETWORK', N'2', 115)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900246', N'10090J', N'HEALTH', N'HEALTH - SYDNEY CHILDREN''S HOSPITAL NETWORK', N'2', 116)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900675', N'10090J', N'HEALTH', N'HEALTH - SYDNEY CHILDREN''S HOSPITAL NETWORK', N'2', 117)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900060', N'10090K', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 118)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900186', N'10090K', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 119)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900202', N'10090K', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 120)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900338', N'10090K', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 121)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900354', N'10090K', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 122)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900362', N'10090K', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 123)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900370', N'10090K', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 124)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900376', N'10090K', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 125)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900489', N'10090K', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 126)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900180', N'10090L', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 127)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900188', N'10090L', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 128)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900355', N'10090L', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 129)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900357', N'10090L', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 130)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900369', N'10090L', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 131)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900473', N'10090L', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 132)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900490', N'10090L', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 133)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10022', N'10090R', N'HEALTH', N'HEALTH - ST VINCENT LOCAL HEALTH NETWORK', N'2', 134)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10024', N'10090R', N'HEALTH', N'HEALTH - ST VINCENT LOCAL HEALTH NETWORK', N'2', 135)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900034', N'10090R', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 136)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900241', N'10090R', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 137)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900340', N'10090R', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 138)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900356', N'10090R', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 139)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900359', N'10090R', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 140)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900472', N'10090R', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'2', 141)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900488', N'10090R', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 142)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900494', N'10090R', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 143)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900525', N'10090R', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 144)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900531', N'10090R', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 145)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900821', N'10090R', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 146)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900385', N'10090S', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 147)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900471', N'10090S', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 148)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900486', N'10090S', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 149)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900605', N'10090S', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 150)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10017', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 151)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10018', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 152)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10019', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 153)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10020', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 154)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10021', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 155)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10028', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 156)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10032', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 157)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10033', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 158)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10034', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 159)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10041', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 160)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10042', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 161)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10043', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 162)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10044', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 163)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10045', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 164)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10046', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 165)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10047', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 166)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10048', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 167)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10049', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 168)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900352', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 169)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900375', N'10090Y', N'HEALTH', N'HEALTH - HEALTH SUPPORT SERVICES', N'2', 170)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10058', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 171)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10076', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 172)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900007', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 173)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900008', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 174)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900010', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 175)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900011', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 176)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900059', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 177)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900074', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 178)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900230', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 179)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900235', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 180)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900245', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 181)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900252', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 182)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900366', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 183)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900371', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 184)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900386', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 185)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900422', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 186)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900451', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 187)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900530', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 188)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900577', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 189)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900662', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 190)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900702', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 191)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900780', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 192)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900816', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 193)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900817', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 194)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10092', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 195)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10095', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 196)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10096', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 197)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10133', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 198)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10134', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 199)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10135', N'15090A', N'HEALTH', N'HEALTH - SYDNEY LOCAL HEALTH DISTRICT', N'2', 200)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10014', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 201)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10059', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 202)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10077', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 203)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900051', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 204)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900052', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 205)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900053', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 206)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900054', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 207)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900055', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 208)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900056', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 209)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900228', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 210)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900233', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 211)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900238', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 212)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900372', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 213)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900390', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 214)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900436', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 215)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900437', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 216)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900499', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 217)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900500', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 218)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900501', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 219)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900533', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 220)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900534', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 221)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900686', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 222)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10093', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 223)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10094', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 224)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10097', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 225)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10136', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 226)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10137', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 227)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10138', N'15090B', N'HEALTH', N'HEALTH - SOUTH WEST SYDNEY HEALTH DISTRICT', N'2', 228)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10057', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 229)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900013', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 230)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900014', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 231)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900015', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 232)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900016', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 233)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900017', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 234)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900057', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 235)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900058', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 236)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900079', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 237)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900082', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 238)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900232', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 239)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900240', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 240)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900392', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 241)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900674', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 242)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900676', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 243)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900677', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 244)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900678', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 245)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10110', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 246)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10111', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 247)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10112', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 248)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10113', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 249)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10114', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 250)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10115', N'15090C', N'HEALTH', N'HEALTH - SOUTH EASTERN SYDNEY LOCAL HEALTH DISTRICT', N'1', 251)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10030', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 252)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10056', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 253)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900033', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 254)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900035', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 255)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900036', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 256)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900037', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 257)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900038', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 258)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900039', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 259)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900040', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 260)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900041', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 261)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900193', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 262)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900440', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 263)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900452', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 264)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900749', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 265)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900818', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 266)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900819', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 267)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900820', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 268)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900822', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 269)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10104', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 270)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10105', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 271)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10106', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 272)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10107', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 273)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10108', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 274)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10109', N'15090D', N'HEALTH', N'HEALTH - ILLAWARRA SHOALHAVEN LOCAL HEALTH DISTRICT', N'1', 275)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10010', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 276)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10011', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 277)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10012', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 278)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10013', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 279)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10038', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 280)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10039', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 281)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10040', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 282)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10060', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 283)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10073', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 284)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10075', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 285)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10086', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 286)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900068', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 287)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900069', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 288)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900070', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 289)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900083', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 290)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900239', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 291)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900377', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 292)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900391', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'3', 293)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900684', N'15090E', N'HEALTH', N'HEALTH - WESTERN SYDNEY LOCAL HEALTH DISTRICT', N'2', 294)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10037', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 295)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10061', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 296)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10062', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 297)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10063', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 298)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10064', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 299)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10072', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 300)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10074', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 301)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10080', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 302)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10081', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 303)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10143', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 304) -- fake group
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10085', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 305)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900061', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 306)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900062', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 307)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900063', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 308)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900064', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 309)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900065', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 310)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900066', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 311)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900085', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 312)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900171', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 313)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900178', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 314)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900445', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 315)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900446', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 316)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900528', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 317)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900529', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 318)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900546', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 319)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900910', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 320)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900911', N'15090F', N'HEALTH', N'HEALTH - NEPEAN BLUE MOUNTAINS LOCAL HEALTH DISTRICT', N'3', 321)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10054', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 322)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10069', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 323)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900090', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 324)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900091', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 325)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900092', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 326)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900094', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 327)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900095', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 328)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900096', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 329)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900097', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 330)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900098', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 331)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900099', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 332)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900100', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 333)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900101', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 334)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900102', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 335)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900103', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 336)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900104', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 337)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900105', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 338)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900106', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 339)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900107', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 340)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900108', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 341)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900109', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'2', 342)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900110', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 343)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900111', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 344)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900113', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 345)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900114', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 346)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900159', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 347)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900170', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 348)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900187', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 349)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900191', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 350)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900197', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'2', 351)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900199', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 352)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900204', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 353)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900226', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 354)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900341', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 355)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900655', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 356)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900777', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'2', 357)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900794', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 358)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10101', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 359)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10102', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 360)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10103', N'15090J', N'HEALTH', N'HEALTH - MURRUMBIDGEE LOCAL HEALTH DISTRICT', N'3', 361)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10055', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 362)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900050', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 363)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900189', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 364)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900190', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 365)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900192', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 366)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900194', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 367)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900195', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 368)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900198', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 369)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900200', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 370)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900201', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 371)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900203', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 372)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900227', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 373)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900229', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 374)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900256', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 375)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10098', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 376)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10099', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 377)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10100', N'15090K', N'HEALTH', N'HEALTH - SOUTHERN NSW LOCAL HEALTH DISTRICT', N'3', 378)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10065', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 379)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10088', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 380)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10089', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 381)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900116', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 382)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900117', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 383)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900119', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 384)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900120', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 385)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900121', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 386)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900122', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 387)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900123', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 388)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900124', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 389)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900125', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 390)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900126', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 391)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900127', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 392)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900130', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 393)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900131', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 394)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900132', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 395)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900133', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 396)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900136', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 397)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900137', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 398)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900138', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 399)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900160', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 400)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900161', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 401)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900162', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 402)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900163', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 403)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900164', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 404)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900165', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 405)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900166', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 406)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900167', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 407)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900168', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 408)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900169', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 409)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900172', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 410)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900173', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 411)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900174', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 412)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900175', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 413)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900176', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 414)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900181', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 415)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900182', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 416)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900183', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 417)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900185', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 418)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900374', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 419)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900601', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 420)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900639', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 421)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900640', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 422)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900641', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 423)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900642', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 424)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900643', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 425)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900644', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 426)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900645', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 427)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900646', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 428)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900647', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 429)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900648', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 430)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900667', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 431)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900668', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 432)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900669', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 433)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900670', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 434)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900671', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 435)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900748', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 436)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900935', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 437)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900959', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 438)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900975', N'15090L', N'HEALTH', N'HEALTH - WESTERN NSW LOCAL DISTRICT', N'3', 439)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10066', N'15090M', N'HEALTH', N'HEALTH - FAR WEST LOCAL HEALTH DISTRICT', N'3', 440)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900089', N'15090M', N'HEALTH', N'HEALTH - FAR WEST LOCAL HEALTH DISTRICT', N'3', 441)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900115', N'15090M', N'HEALTH', N'HEALTH - FAR WEST LOCAL HEALTH DISTRICT', N'3', 442)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900118', N'15090M', N'HEALTH', N'HEALTH - FAR WEST LOCAL HEALTH DISTRICT', N'3', 443)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900129', N'15090M', N'HEALTH', N'HEALTH - FAR WEST LOCAL HEALTH DISTRICT', N'3', 444)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900134', N'15090M', N'HEALTH', N'HEALTH - FAR WEST LOCAL HEALTH DISTRICT', N'3', 445)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900139', N'15090M', N'HEALTH', N'HEALTH - FAR WEST LOCAL HEALTH DISTRICT', N'3', 446)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900603', N'15090M', N'HEALTH', N'HEALTH - FAR WEST LOCAL HEALTH DISTRICT', N'3', 447)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900604', N'15090M', N'HEALTH', N'HEALTH - FAR WEST LOCAL HEALTH DISTRICT', N'3', 448)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900745', N'15090M', N'HEALTH', N'HEALTH - FAR WEST LOCAL HEALTH DISTRICT', N'3', 449)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10090', N'15090M', N'HEALTH', N'HEALTH - FAR WEST LOCAL HEALTH DISTRICT', N'3', 450)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10091', N'15090M', N'HEALTH', N'HEALTH - FAR WEST LOCAL HEALTH DISTRICT', N'3', 451)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10052', N'15090R', N'HEALTH', N'HEALTH - CLINICAL SUPPORT CLUSTER', N'Miscellaneous', 452)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10053', N'15090S', N'HEALTH', N'HEALTH - CLINICAL SUPPORT CLUSTER', N'Miscellaneous', 453)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10023', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 454)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10025', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 455)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10026', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 456)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10027', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 457)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10050', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 458)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900080', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 459)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900196', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 460)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900259', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 461)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900345', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 462)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900349', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 463)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900441', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 464)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900444', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 465)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900502', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 466)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900503', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 467)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900504', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 468)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900535', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 469)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900654', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 470)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900673', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 471)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900679', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 472)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900751', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 473)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900776', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 474)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900778', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 475)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900779', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 476)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900783', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 477)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900793', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 478)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900796', N'15090U', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 479)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10003', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 480)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10004', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 481)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10005', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 482)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10006', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 483)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10007', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 484)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10008', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 485)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10009', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 486)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10016', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 487)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10036', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 488)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10051', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 489)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10071', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 490)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900339', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 491)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900342', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 492)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900343', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 493)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900346', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 494)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900348', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 495)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900365', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 496)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900383', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 497)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900384', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 498)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900435', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 499)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900450', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 500)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900474', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 501)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900487', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 502)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900523', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 503)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900586', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 504)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900602', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 505)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900606', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 506)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900607', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 507)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900666', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 508)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900703', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 509)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900791', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 510)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900803', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 511)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900829', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 512)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900830', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 513)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900831', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 514)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900832', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 515)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900833', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 516)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900834', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 517)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900835', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 518)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900836', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 519)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900837', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 520)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900838', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 521)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900839', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 522)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900840', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 523)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900881', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 524)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900906', N'15090V', N'HEALTH', N'HEALTH - HEALTH REFORM TRANSITIONAL OFFICE', N'2', 525)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10070', N'15090W', N'HEALTH', N'HEALTH - ST VINCENT LOCAL HEALTH NETWORK', N'1', 526)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900078', N'15090W', N'HEALTH', N'HEALTH - ST VINCENT LOCAL HEALTH NETWORK', N'1', 527)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900081', N'15090W', N'HEALTH', N'HEALTH - ST VINCENT LOCAL HEALTH NETWORK', N'1', 528)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'WC900249', N'15090W', N'HEALTH', N'HEALTH - ST VINCENT LOCAL HEALTH NETWORK', N'1', 529)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10035', N'15190C', N'HEALTH', N'HEALTH - ALBURY WODONGA HEALTH', N'3', 530)
INSERT [dbo].[TMF_Agencies_Sub_Category] ([Policy_No], [AgencyId], [AgencyName], [Sub_Category], [Group], [Id]) VALUES (N'T10079', N'15190G', N'HEALTH', N'HEALTH - NSW SERVICE FOR THE TREATMENT AND REHABILITATION OF TORTURE AND TRAUMA SURVIVORS', N'1', 531)
SET IDENTITY_INSERT [dbo].[TMF_Agencies_Sub_Category] OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_Agencies_Sub_Category.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_AWC.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMF_AWC]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[TMF_AWC](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Time_ID] [datetime] NOT NULL,
		[Claim_no] [varchar](19) NULL,
		[Team] [varchar](20) NULL,
		[Case_manager] [varchar](81) NULL,
		[Date_of_Injury] [datetime] NULL,
		[create_date] [datetime]  DEFAULT GETDATE(),		
		[POLICY_NO] [char](19) NULL,
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
		IF COL_LENGTH('TMF_AWC','AgencyName') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			DROP COLUMN AgencyName
		END
		IF COL_LENGTH('TMF_AWC','Sub_Category') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			DROP COLUMN Sub_Category
		END
		IF COL_LENGTH('TMF_AWC','Agency_Id') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			DROP COLUMN Agency_Id
		END
		IF COL_LENGTH('TMF_AWC','Group') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_AWC]
			DROP COLUMN [Group]
		END
	END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_AWC.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_AWC_Projections.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_AWC_Projections.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_Portfolio.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMF_Portfolio]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[TMF_Portfolio](				
			[Id] [int] IDENTITY(1,1) NOT NULL,
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
			--[Gateway_Status] [varchar] (256) NULL
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
	IF COL_LENGTH('TMF_Portfolio','Agency_Name') IS NOT NULL
	BEGIN	
		ALTER TABLE [dbo].[TMF_Portfolio]
		DROP COLUMN Agency_Name
	END
	IF COL_LENGTH('TMF_Portfolio','Sub_Category') IS NOT NULL
	BEGIN	
		ALTER TABLE [dbo].[TMF_Portfolio]
		DROP COLUMN Sub_Category
	END
	IF COL_LENGTH('TMF_Portfolio','Agency_Id') IS NOT NULL
	BEGIN	
		ALTER TABLE [dbo].[TMF_Portfolio]
		DROP COLUMN Agency_Id
	END
	IF COL_LENGTH('TMF_Portfolio','Group') IS NOT NULL
	BEGIN	
		ALTER TABLE [dbo].[TMF_Portfolio]
		DROP COLUMN [Group]
	END
	IF COL_LENGTH('TMF_Portfolio','IsPreClosed') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[TMF_Portfolio]
		ADD IsPreClosed bit NULL	
	END	
	IF COL_LENGTH('TMF_Portfolio','IsPreOpened') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[TMF_Portfolio]
		ADD IsPreOpened bit NULL	
	END
	
	-- NCMM Actions
	IF COL_LENGTH('TMF_Portfolio','NCMM_Complete_Action_Due') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[TMF_Portfolio]
		ADD [NCMM_Complete_Action_Due] [datetime] NULL
	END
	IF COL_LENGTH('TMF_Portfolio','NCMM_Complete_Remaining_Days') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[TMF_Portfolio]
		ADD [NCMM_Complete_Remaining_Days] [int] NULL
	END
	IF COL_LENGTH('TMF_Portfolio','NCMM_Prepare_Action_Due') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[TMF_Portfolio]
		ADD [NCMM_Prepare_Action_Due] [datetime] NULL
	END
	IF COL_LENGTH('TMF_Portfolio','NCMM_Prepare_Remaining_Days') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[TMF_Portfolio]
		ADD [NCMM_Prepare_Remaining_Days] [int] NULL
	END
	
	IF COL_LENGTH('TMF_Portfolio','Med_Cert_Status_Next_Week') IS NOT NULL
	BEGIN
		IF EXISTS (SELECT name FROM sysindexes WHERE name = 'idx_TMF_Portfolio_RAW_Data')
		BEGIN
			DROP INDEX idx_TMF_Portfolio_RAW_Data ON [dbo].[TMF_Portfolio]
		END
		
		ALTER TABLE [dbo].[TMF_Portfolio]
		DROP COLUMN [Med_Cert_Status_Next_Week]
	END
	
	--IF COL_LENGTH('TMF_Portfolio','Gateway_Status') IS NULL
	--BEGIN	
	--	ALTER TABLE [dbo].[TMF_Portfolio]
	--	ADD Gateway_Status [varchar] (256) NULL
	--END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_Portfolio.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_RTW.sql  
--------------------------------  
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMF_RTW]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[TMF_RTW](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Remuneration_Start] [datetime] NULL,
			[Remuneration_End] [datetime] NULL,
			[Measure_months] [bigint] NULL,
			[Team] [varchar](20) NULL,
			[Case_manager] [varchar](81) NULL,
			[Claim_no] [varchar](20) NULL,
			[DTE_OF_INJURY] [datetime] NULL,
			[POLICY_NO] [char](19) NULL,
			[LT] [float] NULL,
			[WGT] [float] NULL,
			[EMPL_SIZE] [varchar](256) NULL,
			[Weeks_paid][float] NULL,
			[create_date] [datetime]  DEFAULT GETDATE(),
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
		IF COL_LENGTH('TMF_RTW','AgencyName') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			DROP COLUMN AgencyName
		END
		IF COL_LENGTH('TMF_RTW','Sub_Category') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			DROP COLUMN Sub_Category
		END
		IF COL_LENGTH('TMF_RTW','Agency_Id') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			DROP COLUMN Agency_Id
		END
		IF COL_LENGTH('TMF_RTW','Group') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[TMF_RTW]
			DROP COLUMN [Group]
		END
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_RTW_Target_Base.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\TMF_RTW_Target_Base.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\WOW_Portfolio.sql  
--------------------------------  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WOW_Portfolio]') AND type in (N'U'))	
	BEGIN
		DROP TABLE [dbo].[WOW_Portfolio]
	END

CREATE TABLE [dbo].[WOW_Portfolio](				
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Team] [varchar](20) NULL,
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
	[NCMM_Prepare_Remaining_Days] [int] NULL
 CONSTRAINT [PK_WOW_Portfolio_ID] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\SchemaChange\WOW_Portfolio.sql  
--------------------------------  
---------------------------------------------------------- 
------------------- UserDefinedFunction 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_CPR_Overall.sql  
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
	[Rehab_Paid] [float] NULL,
	[IsPreClosed] [bit] NULL,
	[IsPreOpened] [bit] NULL)
AS
BEGIN	
	IF UPPER(@System) = 'TMF'
	BEGIN
		INSERT @port_overall
		SELECT Value=RTRIM(case when @Type='agency' then rtrim(isnull(sub.AgencyName,'Miscellaneous')) else dbo.udf_TMF_GetGroupByTeam(Team) end)
			,SubValue=RTRIM(case when @Type='agency' then rtrim(isnull(sub.Sub_Category,'Miscellaneous')) else [Team] end)
			,SubValue2=RTRIM([Claims_Officer_Name])
			,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
			,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
			,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
			,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
			,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
			,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
			,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[IsPreClosed],[IsPreOpened]
			FROM TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No
			WHERE ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		INSERT @port_overall
		SELECT Value=RTRIM(case when @Type='employer_size' then [EMPL_SIZE] when @Type='group' then dbo.udf_EML_GetGroupByTeam(Team) else [account_manager] end)
			,SubValue=RTRIM(case when @Type='group' then [Team] else [EMPL_SIZE] end)
			,SubValue2=RTRIM([Claims_Officer_Name])
			,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
			,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
			,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
			,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
			,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
			,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
			,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[IsPreClosed],[IsPreOpened]
			FROM EML_Portfolio
			WHERE ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		INSERT @port_overall
		SELECT Value=RTRIM(case when @Type='account_manager' then [Account_Manager] when @Type = 'portfolio' then [portfolio] else dbo.udf_HEM_GetGroupByTeam(Team) end)
			,SubValue=RTRIM(case when @Type='account_manager' or @Type = 'portfolio' then [EMPL_SIZE] else [Team] end)
			,SubValue2=RTRIM([Claims_Officer_Name])
			,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
			,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
			,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
			,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
			,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
			,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week]
			,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[IsPreClosed],[IsPreOpened]
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_CPR_Overall.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_dashboard_EML_RTW_getTargetAndBase.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_dashboard_EML_RTW_getTargetAndBase.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_dashboard_HEM_RTW_getTargetAndBase.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_dashboard_HEM_RTW_getTargetAndBase.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_dashboard_TMF_RTW_getTargetAndBase.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_dashboard_TMF_RTW_getTargetAndBase.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_EML_GetGroupByTeam.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_EML_GetGroupByTeam') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].udf_EML_GetGroupByTeam
GO

/****** Object:  UserDefinedFunction [dbo].udf_EML_GetGroupByTeam    Script Date: 01/05/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].udf_EML_GetGroupByTeam(@Team varchar(20))
	returns varchar(20)	 
AS
	BEGIN
		RETURN CASE WHEN (RTRIM(ISNULL(@Team,''))='') OR (@Team NOT LIKE 'wcnsw%' or PATINDEX('WCNSW', RTRIM(@Team))>0)
						THEN 'Miscellaneous'
					WHEN PATINDEX('WCNSW%', @Team) = 0 
						THEN Left(UPPER(RTRIM(@Team)), 1) + Right(LOWER(RTRIM(@Team)), LEN(RTRIM(@Team))-1)
					WHEN RTRIM(@Team) = 'WCNSW'
						THEN 'WCNSW(Group)'
					ELSE SUBSTRING(Left(UPPER(RTRIM(@Team)), 1) + Right(LOWER(RTRIM(@Team)), LEN(RTRIM(@Team))-1), 1, 
							CASE WHEN PATINDEX('%[A-Z]%', SUBSTRING(RTRIM(@Team), 6, LEN(RTRIM(@Team)) - 5)) > 0 
									THEN (PATINDEX('%[A-Z]%', SUBSTRING(RTRIM(@Team), 6, LEN(RTRIM(@Team)) - 5)) + 4) 
								ELSE LEN(RTRIM(@Team))
							END)
				END
	END 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_EML_GetGroupByTeam.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetAgencyNameByPolicyNo.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetAgencyNameByPolicyNo') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetAgencyNameByPolicyNo
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetAgencyNameByPolicyNo    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
--select dbo.udf_GetAgencyNameByPolicyNo('gdfgdfg')
CREATE function [dbo].udf_GetAgencyNameByPolicyNo(@Policy_no char(19))
	returns char(20)
as
begin
	declare @AgencyName char(20)
	select @AgencyName =  AgencyName from dbo.TMF_Agencies_Sub_Category where Policy_no = @Policy_no	
	RETURN 	rtrim(isnull(@AgencyName,'Miscellaneous'))	
end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetAgencyNameByPolicyNo.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetCPR_ClaimList.sql  
--------------------------------  
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
	[IsPreOpened] [bit] NULL)
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
				,[Date_Claim_Received],[Date_Claim_Reopened],[IsPreOpened]
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
				,[Date_Claim_Received],[Date_Claim_Reopened],[IsPreOpened]
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
				,[Date_Claim_Received],[Date_Claim_Reopened],[IsPreOpened]
			FROM HEM_Portfolio
			WHERE ISNULL(Is_Last_Month, 0) = @Is_Last_Month
				AND Reporting_Date = @Reporting_Date
	END
	RETURN;
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetCPR_ClaimList.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetCPR_PeriodType.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetCPR_PeriodType') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetCPR_PeriodType
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetCPR_PeriodType    Script Date: 04/14/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetCPR_PeriodType(
	@Start_Date DATETIME
	,@End_Date DATETIME
)
RETURNS INT
AS
BEGIN
	-- Determine the last month period
	DECLARE @LastMonth_Start_Date datetime = DATEADD(m, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0))
	DECLARE @LastMonth_End_Date datetime = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59'
	
	-- Determine last two weeks: Start = last two weeks from yesterday; End = yesterday
	DECLARE @Last2Weeks_Start_Date datetime = DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
	DECLARE @Last2Weeks_End_Date datetime = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	
	DECLARE @IsLastMonthRange bit = 0
	IF DATEDIFF(d, @LastMonth_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @LastMonth_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLastMonthRange = 1
	END
	
	DECLARE @IsLast2WeeksRange bit = 0
	IF DATEDIFF(d, @Last2Weeks_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @Last2Weeks_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLast2WeeksRange = 1
	END
	
	-- Determine period type
	DECLARE @Period_Type int
	IF @IsLastMonthRange = 1
	BEGIN
		SET @Period_Type = 1
	END
	ELSE IF @IsLast2WeeksRange = 1
	BEGIN
		SET @Period_Type = 0
	END
	ELSE IF @IsLastMonthRange = 0 AND @IsLast2WeeksRange = 0
	BEGIN
		SET @Period_Type = -1
	END
	
	RETURN @Period_Type
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetCPR_PeriodType.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetCPR_PreClaimList.sql  
--------------------------------  
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
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetCPR_PreClaimList.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetCPR_ReportingDate.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetCPR_ReportingDate') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetCPR_ReportingDate
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetCPR_ReportingDate    Script Date: 04/14/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetCPR_ReportingDate(
	@System VARCHAR(10)
	,@Period_Type INT
	,@End_Date DATETIME
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @Reporting_Date datetime
	
	IF UPPER(@System) = 'TMF'
	BEGIN
		SET @Reporting_Date = case when @Period_Type = -1
										then (SELECT top 1 Reporting_Date FROM TMF_Portfolio
												WHERE CONVERT(datetime, Reporting_Date, 101)
													>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
									else (select MAX(Reporting_Date) from TMF_Portfolio)
								end
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		SET @Reporting_Date = case when @Period_Type = -1
										then (SELECT top 1 Reporting_Date FROM EML_Portfolio
												WHERE CONVERT(datetime, Reporting_Date, 101)
													>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
									else (select MAX(Reporting_Date) from EML_Portfolio)
								end
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		SET @Reporting_Date = case when @Period_Type = -1
										then (SELECT top 1 Reporting_Date FROM HEM_Portfolio
												WHERE CONVERT(datetime, Reporting_Date, 101)
													>= CONVERT(datetime, @End_Date, 101) order by Reporting_Date)
									else (select MAX(Reporting_Date) from HEM_Portfolio)
								end
	END
	
	RETURN @Reporting_Date
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetCPR_ReportingDate.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetCPR_ReportingDate_Pre.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetCPR_ReportingDate_Pre') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetCPR_ReportingDate_Pre
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetCPR_ReportingDate_Pre    Script Date: 04/14/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetCPR_ReportingDate_Pre(
	@System VARCHAR(10)
	,@Start_Date DATETIME
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @Reporting_Date_Pre datetime
	
	IF UPPER(@System) = 'TMF'
	BEGIN
		SET @Reporting_Date_Pre = (SELECT top 1 Reporting_Date FROM TMF_Portfolio
										WHERE CONVERT(datetime, Reporting_Date, 101)
											>= CONVERT(datetime, DATEADD(DAY, -1, @Start_Date) + '23:59', 101) order by Reporting_Date)
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		SET @Reporting_Date_Pre = (SELECT top 1 Reporting_Date FROM EML_Portfolio
										WHERE CONVERT(datetime, Reporting_Date, 101)
											>= CONVERT(datetime, DATEADD(DAY, -1, @Start_Date) + '23:59', 101) order by Reporting_Date)
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		SET @Reporting_Date_Pre = (SELECT top 1 Reporting_Date FROM HEM_Portfolio
										WHERE CONVERT(datetime, Reporting_Date, 101)
											>= CONVERT(datetime, DATEADD(DAY, -1, @Start_Date) + '23:59', 101) order by Reporting_Date)
	END
	
	RETURN @Reporting_Date_Pre
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetCPR_ReportingDate_Pre.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetGroupByPolicyNo.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetGroupByPolicyNo') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetGroupByPolicyNo
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetGroupByPolicyNo    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
--select dbo.udf_GetGroupByPolicyNo('fsdfsdf')
CREATE function [dbo].udf_GetGroupByPolicyNo(@Policy_no char(19))
	returns varchar(20)	 
AS
	BEGIN
		declare @Group char(20)
		select @Group =  [Group] from dbo.TMF_Agencies_Sub_Category where Policy_no = @Policy_no	
		RETURN 	rtrim(isnull(@Group,'Miscellaneous'))		
	END 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


GO
--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetGroupByPolicyNo.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetSubCategoryByPolicyNo.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetSubCategoryByPolicyNo') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetSubCategoryByPolicyNo
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetSubCategoryByPolicyNo    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
--select dbo.udf_GetSubCategoryByPolicyNo('fsdfsdf')
CREATE function [dbo].udf_GetSubCategoryByPolicyNo(@Policy_no char(19))
	returns varchar(256)
as
	BEGIN
		declare @sub_category varchar(256)
		select @sub_category =  sub_category from dbo.TMF_Agencies_Sub_Category where Policy_no = @Policy_no	
		RETURN 	rtrim(isnull(@sub_category,'Miscellaneous'))
	END 

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


GO
--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_GetSubCategoryByPolicyNo.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_HEM_GetGroupByTeam.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_HEM_GetGroupByTeam') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].udf_HEM_GetGroupByTeam
GO

/****** Object:  UserDefinedFunction [dbo].udf_HEM_GetGroupByTeam    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].udf_HEM_GetGroupByTeam(@Team varchar(20))
	returns varchar(20)	 
AS
	BEGIN
		RETURN CASE WHEN (RTRIM(ISNULL(@Team,''))='') OR @Team NOT LIKE 'hosp%'
						THEN 'Miscellaneous'
				WHEN PATINDEX('HEM%', @Team) = 0 
					THEN Left(UPPER(RTRIM(@Team)), 1) + Right(LOWER(RTRIM(@Team)), LEN(RTRIM(@Team))-1)
				ELSE SUBSTRING(Left(UPPER(RTRIM(@Team)), 1) + Right(LOWER(RTRIM(@Team)), LEN(RTRIM(@Team))-1), 1, 
						CASE WHEN PATINDEX('%[A-Z]%', SUBSTRING(RTRIM(@Team), 4, LEN(RTRIM(@Team)) - 3)) > 0 
								THEN (PATINDEX('%[A-Z]%', SUBSTRING(RTRIM(@Team), 4, LEN(RTRIM(@Team)) - 3)) + 2) 
							ELSE LEN(RTRIM(@Team))
						END)
				END
	END 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_HEM_GetGroupByTeam.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_TMF_GetGroupByTeam.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_TMF_GetGroupByTeam') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_TMF_GetGroupByTeam
GO

/****** Object:  UserDefinedFunction [dbo].udf_TMF_GetGroupByTeam    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].udf_TMF_GetGroupByTeam(@Team varchar(20))
	returns varchar(20)	 
AS
	BEGIN
		DECLARE @strReturn varchar(20)
		
		IF RTRIM(ISNULL(@Team, '')) = ''
		BEGIN
			SET @strReturn = 'Miscellaneous'
		END
		ELSE
		BEGIN
			SET @strReturn= REPLACE(@Team,'tmf','')
		END
			
		SELECT @strReturn =(case when PATINDEX('%[A-Z]%',@strReturn) >=2 
									then SUBSTRING(@strReturn,1,PATINDEX('%[A-Z]%',@strReturn)-1)
		ELSE @strReturn end)
		
		RETURN (case when PATINDEX('%[A-Z]%',@strReturn) <1
					then RTRIM(@strReturn) else 'Miscellaneous' 
				end)
	END 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_TMF_GetGroupByTeam.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group.sql  
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
	select Month_period =1
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
	
	union 
	select distinct [type]='agency' 
		   ,rtrim(isnull(sub.AgencyName,'Miscellaneous')) as Agency_Group
		   ,LT = 0
		   ,WGT = 0
		   ,AVGDURN = 0
		   ,[Target] = 0
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO 
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
	   
	union 
	select distinct [type]='agency' 
		   ,'POLICE & EMERGENCY SERVICES' as Agency_Group
		   ,LT = 0
		   ,WGT = 0
		   ,AVGDURN = 0
		   ,[Target] = 0
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO 
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11) 
	   and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire','RFS')
	   
	union 
	select distinct [type]='agency' 
		   ,'HEALTH & OTHER' as Agency_Group
		   ,LT = 0
		   ,WGT = 0
		   ,AVGDURN = 0
		   ,[Target] = 0
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO 
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)  
	   and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other')   
	   
	union 
	select distinct [type]='agency' 
		   ,'TMF' as Agency_Group
		   ,LT = 0
		   ,WGT = 0
		   ,AVGDURN = 0
		   ,[Target] = 0
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO 
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)     
	
	union   
	select distinct [type]='group' 
		   ,'TMF' as Agency_Group
		   ,LT = 0
		   ,WGT = 0
		   ,AVGDURN = 0
		   ,[Target] = 0
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO 
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)    
	) as tmp3
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_Whole_EML_Generate_Years.sql  
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
				else dbo.udf_EML_GetGroupByTeam(Team) end as Unit,
			case 
				when @Type = 'eml' then 'EML'
				when @Type = 'employer_size' then RTRIM(Empl_Size)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then dbo.udf_EML_GetGroupByTeam(Team)
				when @Type = 'am_empl_size' then RTRIM(Account_Manager)
				else dbo.udf_EML_GetGroupByTeam(Team) end as [Primary]
		FROM   eml_awc where RTRIM(Account_Manager) is not null
	) as uv_Unit
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_Whole_EML_Generate_Years.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_Whole_HEM_Generate_Years.sql  
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
				else dbo.udf_HEM_GetGroupByTeam(Team) end as Unit,
			case 
				when @Type = 'hem' then 'HEM'
				when @Type = 'portfolio' then RTRIM(Portfolio)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then dbo.udf_HEM_GetGroupByTeam(Team)
				when @Type = 'am_empl_size' then RTRIM(Account_Manager)
				when @Type = 'portfolio_empl_size' then RTRIM(Portfolio)
				else dbo.udf_HEM_GetGroupByTeam(Team) end as [Primary]
		FROM   hem_awc 
	) as uv_Unit
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_Whole_HEM_Generate_Years.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_Whole_TMF_Generate_Years.sql  
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
			when @Type = 'agency' then RTRIM(ISNULL(sub.AgencyName,'Miscellaneous'))
			when @Type = 'sub_category' then RTRIM(ISNULL(sub.Sub_Category,'Miscellaneous'))
			when @Type = 'team' then RTRIM(Team)
			else dbo.udf_TMF_GetGroupByTeam(Team) end as Unit,
		case 
			when @Type = 'tmf' then 'TMF'
			when @Type = 'agency' then RTRIM(ISNULL(sub.AgencyName,'Miscellaneous'))
			when @Type = 'sub_category' then RTRIM(ISNULL(sub.AgencyName,'Miscellaneous'))
			when @Type = 'team' then dbo.udf_TMF_GetGroupByTeam(Team)
			else dbo.udf_TMF_GetGroupByTeam(Team) end as [Primary]
		from TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
	) as uv_Unit	
)
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_Whole_TMF_Generate_Years.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_WOW_GetGroupByTeam.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_WOW_GetGroupByTeam') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].udf_WOW_GetGroupByTeam
GO

/****** Object:  UserDefinedFunction [dbo].udf_EML_GetGroupByTeam    Script Date: 01/05/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].udf_WOW_GetGroupByTeam(@Team varchar(20))
	returns varchar(20)	 
AS
	BEGIN
		RETURN CASE WHEN (RTRIM(ISNULL(@Team,''))='') OR (@Team NOT LIKE 'wcnsw%' or PATINDEX('WCNSW', RTRIM(@Team))>0)
						THEN 'Miscellaneous'
					WHEN PATINDEX('WCNSW%', @Team) = 0 
						THEN Left(UPPER(RTRIM(@Team)), 1) + Right(LOWER(RTRIM(@Team)), LEN(RTRIM(@Team))-1)
					WHEN RTRIM(@Team) = 'WCNSW'
						THEN 'WCNSW(Group)'
					ELSE SUBSTRING(Left(UPPER(RTRIM(@Team)), 1) + Right(LOWER(RTRIM(@Team)), LEN(RTRIM(@Team))-1), 1, 
							CASE WHEN PATINDEX('%[A-Z]%', SUBSTRING(RTRIM(@Team), 6, LEN(RTRIM(@Team)) - 5)) > 0 
									THEN (PATINDEX('%[A-Z]%', SUBSTRING(RTRIM(@Team), 6, LEN(RTRIM(@Team)) - 5)) + 4) 
								ELSE LEN(RTRIM(@Team))
							END)
				END
	END 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_1\udf_WOW_GetGroupByTeam.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_2\udf_EML_AWC_Generate_Time_ID.sql  
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
		SELECT CAST('01/01/' + cast(year(getdate()) AS varchar(4)) AS DATETIME) Time_Id
		UNION ALL
		SELECT DATEADD(m, 1, Time_Id)
		FROM temp WHERE Time_Id < CAST('06/01/' + cast(year(getdate())+1 AS varchar(4)) AS DATETIME)
	)

	select  [Type] =@Type
			,uv_Unit.Unit
			,uv_Unit.[Primary]
			,WeeklyType = @WeeklyType		
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
				else dbo.udf_EML_GetGroupByTeam(Team) end as Unit,
			case 
				when @Type = 'eml' then 'EML'
				when @Type = 'employer_size' then RTRIM(Empl_Size)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then dbo.udf_EML_GetGroupByTeam(Team)
				when @Type = 'am_empl_size' then RTRIM(Account_Manager)
				else dbo.udf_EML_GetGroupByTeam(Team) end as [Primary]
		FROM   eml_awc where RTRIM(Account_Manager) is not null
	) as uv_Unit
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_2\udf_EML_AWC_Generate_Time_ID.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_2\udf_HEM_AWC_Generate_Time_ID.sql  
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
		SELECT CAST('01/01/' + cast(year(getdate()) AS varchar(4)) AS DATETIME) Time_Id
		UNION ALL
		SELECT DATEADD(m, 1, Time_Id)
		FROM temp WHERE Time_Id < CAST('06/01/' + cast(year(getdate())+1 AS varchar(4)) AS DATETIME)
	)

	select  [Type] =@Type
			,uv_Unit.Unit
			,uv_Unit.[Primary]
			,WeeklyType = @WeeklyType		
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
				else dbo.udf_HEM_GetGroupByTeam(Team) end as Unit,
			case 
				when @Type = 'hem' then 'HEM'
				when @Type = 'portfolio' then RTRIM(Portfolio)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then dbo.udf_HEM_GetGroupByTeam(Team)
				when @Type = 'am_empl_size' then RTRIM(Account_Manager)
				when @Type = 'portfolio_empl_size' then RTRIM(Portfolio)
				else dbo.udf_HEM_GetGroupByTeam(Team) end as [Primary]
		FROM   hem_awc 
	) as uv_Unit
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_2\udf_HEM_AWC_Generate_Time_ID.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_2\udf_TMF_AWC_Generate_Time_ID.sql  
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
		SELECT CAST('01/01/' + cast(year(getdate()) AS varchar(4)) AS DATETIME) Time_Id
		UNION ALL
		SELECT DATEADD(m, 1, Time_Id)
		FROM temp WHERE Time_Id < CAST('06/01/' + cast(year(getdate())+1 AS varchar(4)) AS DATETIME)
	)

	select  [Type] =@Type
			,uv_Unit.Unit
			,uv_Unit.[Primary]
			,WeeklyType = @WeeklyType			
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
			when @Type = 'agency' then RTRIM(ISNULL(sub.AgencyName,'Miscellaneous'))
			when @Type = 'sub_category' then RTRIM(ISNULL(sub.Sub_Category,'Miscellaneous'))
			when @Type = 'team' then RTRIM(Team)
			else dbo.udf_TMF_GetGroupByTeam(Team) end as Unit,
		case 
			when @Type = 'tmf' then 'TMF'
			when @Type = 'agency' then RTRIM(ISNULL(sub.AgencyName,'Miscellaneous'))
			when @Type = 'sub_category' then RTRIM(ISNULL(sub.AgencyName,'Miscellaneous'))
			when @Type = 'team' then dbo.udf_TMF_GetGroupByTeam(Team)
			else dbo.udf_TMF_GetGroupByTeam(Team) end as [Primary]
		from TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
	) as uv_Unit	
)
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\UserDefinedFunction\UserDefinedFunction_2\udf_TMF_AWC_Generate_Time_ID.sql  
--------------------------------  
---------------------------------------------------------- 
------------------- View 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Raw_Data.sql  
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
		, [Group] = dbo.udf_EML_GetGroupByTeam(Team)
		, Sub_Category = ''
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Raw_Data.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Weekly_Open_1_2.sql  
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
	SELECT  [Type] = 'EML'
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
						WHERE   dbo.udf_EML_GetGroupByTeam(Team) = RTRIM(EML_AWC.Unit)
								AND NOT EXISTS(SELECT   1
												FROM	EML_AWC EML_AWC2
												WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
														AND EML_AWC2.time_id =(SELECT   max(time_Id)
																				FROM    EML_AWC EML_AWC3
																				WHERE   EML_AWC3.claim_no = EML_AWC1.claim_no 
																						AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND  EML_AWC.Time_ID
																				) 
														AND dbo.udf_EML_GetGroupByTeam(EML_AWC2.Team) <> dbo.udf_EML_GetGroupByTeam(EML_AWC1.Team)
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
										AND dbo.udf_EML_GetGroupByTeam(Team) = EML_AWC.[Primary]
										AND NOT EXISTS(SELECT   1
														FROM	EML_AWC EML_AWC2
														WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
																AND EML_AWC2.time_id =
																	(SELECT max(time_Id)
																	  FROM  EML_AWC EML_AWC3
																	  WHERE EML_AWC3.claim_no = EML_AWC1.claim_no 
																			AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID)
																AND dbo.udf_EML_GetGroupByTeam(EML_AWC2.Team) <> dbo.udf_EML_GetGroupByTeam(EML_AWC1.Team)
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Weekly_Open_1_2.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Weekly_Open_3_5.sql  
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
SELECT  [Type] = 'EML'
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
                    WHERE   dbo.udf_EML_GetGroupByTeam(Team) = RTRIM(EML_AWC.Unit) 
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
													AND dbo.udf_EML_GetGroupByTeam(EML_AWC2.Team) <> dbo.udf_EML_GetGroupByTeam(EML_AWC1.Team)
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
								AND dbo.udf_EML_GetGroupByTeam(Team) = EML_AWC.[Primary]
								AND NOT EXISTS  (SELECT  1
                                                 FROM   EML_AWC EML_AWC2
                                                 WHERE  EML_AWC2.claim_no = EML_AWC1.claim_no 
														AND EML_AWC2.time_id =(SELECT	max(time_Id)
																				FROM    EML_AWC EML_AWC3
																				WHERE   EML_AWC3.claim_no = EML_AWC1.claim_no 
																						AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID
																				) 
														AND dbo.udf_EML_GetGroupByTeam(EML_AWC2.Team) <> dbo.udf_EML_GetGroupByTeam(EML_AWC1.Team)
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Weekly_Open_3_5.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Weekly_Open_5_Plus.sql  
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
                    WHERE   dbo.udf_EML_GetGroupByTeam(Team) = RTRIM(EML_AWC.Unit)
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
										AND dbo.udf_EML_GetGroupByTeam(EML_AWC2.Team) <> dbo.udf_EML_GetGroupByTeam(EML_AWC1.Team)
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
					AND dbo.udf_EML_GetGroupByTeam(Team) = EML_AWC.[Primary]
					AND NOT EXISTS (SELECT  1
                                    FROM    EML_AWC EML_AWC2
                                    WHERE   EML_AWC2.claim_no = EML_AWC1.claim_no 
											AND EML_AWC2.time_id =(SELECT   max(time_Id)
                                                                      FROM  EML_AWC EML_AWC3
                                                                      WHERE EML_AWC3.claim_no = EML_AWC1.claim_no 
																			AND EML_AWC3.time_id BETWEEN DATEADD(mm, - 2, EML_AWC.Time_ID) AND EML_AWC.Time_ID
																	) 
                                            AND dbo.udf_EML_GetGroupByTeam(EML_AWC2.Team) <> dbo.udf_EML_GetGroupByTeam(EML_AWC1.Team)
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Weekly_Open_5_Plus.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Whole_EML.sql  
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
					  WHERE dbo.udf_EML_GetGroupByTeam(Team) = RTRIM(EML_AWC.[Primary]) 
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
					  WHERE dbo.udf_EML_GetGroupByTeam(Team) = RTRIM(EML_AWC.[Primary]) AND RTRIM(Team) = RTRIM(EML_AWC.Unit)
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_AWC_Whole_EML.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current.sql  
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
	WITH temp AS 
	(
		select * 
		from
			(select 0 as month_period
			union all
			select 2 as month_period
			union all
			select 5 as month_period
			union all
			select 11 as month_period) as month_period
			cross join
			(select 13 as Measure_months
			union all
			select 26 as Measure_months
			union all
			select 52 as Measure_months
			union all
			select 78 as Measure_months
			union all
			select 104 as Measure_months) as measure_months		
			cross join
			(
			select distinct 'WCNSW' as EmployerSize_Group,[Type]='employer_size'
			from EML_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
			   
			union
			select distinct rtrim(EMPL_SIZE) as EmployerSize_Group, [Type]='employer_size'
			from EML_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				
			union
			select distinct 'WCNSW' as EmployerSize_Group, [Type]='group'
			from EML_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				
			union
			select distinct dbo.udf_EML_GetGroupByTeam(Team) as EmployerSize_Group, [Type]='group'
			from EML_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				
			union
			select distinct 'WCNSW' as EmployerSize_Group, [Type]='account_manager'
			from EML_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				
			union
			select distinct rtrim([Account_Manager]) as EmployerSize_Group, [Type]='account_manager'
			from EML_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				
			) as temp_value
	)
	
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
			,dbo.udf_EML_GetGroupByTeam(Team) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','group',dbo.udf_EML_GetGroupByTeam(Team),NULL,Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by dbo.udf_EML_GetGroupByTeam(Team),Measure,Remuneration_Start, Remuneration_End	
	order by dbo.udf_EML_GetGroupByTeam(Team)
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
	
	--add missing measure months
	union all
	select Month_period=case when month_period = 0
							then 1
						 when month_period = 2
							then 3
						 when month_period = 5
							then 6
						 when month_period = 11
							then 12
					end
		  ,[Type]
		  ,EmployerSize_Group
		  ,Measure_months
		  ,LT = 0
		  ,WGT = 0
		  ,AVGDURN = 0
		  ,[Target] = 0
	from temp as tmp
	where Measure_months not in (select distinct Measure from EML_RTW uv
							where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
							and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) = tmp.month_period
							and case when [Type] = 'group' then (case when EmployerSize_Group <> 'WCNSW' then dbo.udf_EML_GetGroupByTeam(rtrim(uv.Team)) else 'WCNSW' end)
									 when [Type] = 'employer_size' then (case when EmployerSize_Group <> 'WCNSW' then rtrim(uv.EMPL_SIZE) else 'WCNSW' end)
									 when [Type] = 'account_manager' then (case when EmployerSize_Group <> 'WCNSW' then rtrim(uv.Account_Manager) else 'WCNSW' end)
								end
									 = EmployerSize_Group )
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous.sql  
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
			,dbo.udf_EML_GetGroupByTeam(Team) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from EML_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.EML_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by dbo.udf_EML_GetGroupByTeam(Team),Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Rolling_Month_1.sql  
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

SELECT     dbo.udf_EML_GetGroupByTeam(Team) as EmployerSize_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',dbo.udf_EML_GetGroupByTeam(Team),NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',dbo.udf_EML_GetGroupByTeam(Team),NULL,uv.Measure)
						
FROM         dbo.EML_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
GROUP BY  dbo.udf_EML_GetGroupByTeam(Team), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Rolling_Month_1.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Rolling_Month_12.sql  
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

SELECT    EmployerSize_Group = dbo.udf_EML_GetGroupByTeam(Team)
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) 
          
          ,Measure_months = Measure 
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',dbo.udf_EML_GetGroupByTeam(Team),NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',dbo.udf_EML_GetGroupByTeam(Team),NULL,uv.Measure)
						
FROM      dbo.EML_RTW uv 

WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
		  and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)

GROUP BY  dbo.udf_EML_GetGroupByTeam(Team), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Agency_Group_Rolling_Month_12.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Raw_Data.sql  
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
			,[Group] = dbo.udf_EML_GetGroupByTeam(Team)
			,Team
			,Sub_Category = ''
			,Case_manager
			,AgencyName = ''
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Raw_Data.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current.sql  
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
	WITH temp AS 
	(
		select * 
		from
			(select 0 as month_period
			union all
			select 2 as month_period
			union all
			select 5 as month_period
			union all
			select 11 as month_period) as month_period
			cross join
			(select 13 as Measure_months
			union all
			select 26 as Measure_months
			union all
			select 52 as Measure_months
			union all
			select 78 as Measure_months
			union all
			select 104 as Measure_months) as measure_months		
			cross join
			(
			select distinct dbo.udf_EML_GetGroupByTeam(Team) as EmployerSize_Group,rtrim(Team) as Team_Sub, [Type]='group'
			from EML_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				
			union
			
			select distinct rtrim([Account_Manager]) as EmployerSize_Group,rtrim(EMPL_SIZE) as Team_Sub, [Type]='account_manager'
			from EML_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				
			) as temp_value
	)
	
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
			,dbo.udf_EML_GetGroupByTeam(Team) as EmployerSize_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_EML_RTW_getTargetAndBase(Remuneration_End,'target','group',dbo.udf_EML_GetGroupByTeam(Team),rtrim(Team),Measure),0)
	from EML_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by dbo.udf_EML_GetGroupByTeam(Team),Team,Measure,Remuneration_Start, Remuneration_End
	
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
	
	--add missing measure months
	union all
	select Month_period=case when month_period = 0
							then 1
						 when month_period = 2
							then 3
						 when month_period = 5
							then 6
						 when month_period = 11
							then 12
					end
		  ,[Type]
		  ,EmployerSize_Group
		  ,Team_Sub
		  ,Measure_months
		  ,LT = 0
		  ,WGT = 0
		  ,AVGDURN = 0
		  ,[Target] = 0
	from temp as tmp
	where Measure_months not in (select distinct Measure from EML_RTW uv
							where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
							and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) = tmp.month_period
							and case when [Type] = 'group' then dbo.udf_EML_GetGroupByTeam(rtrim(uv.Team))
									 when [Type] = 'account_manager' then rtrim(uv.Account_Manager)
								end
									 = EmployerSize_Group
							and case when [Type] = 'group' then uv.Team
									 when [Type] = 'account_manager' then rtrim(uv.EMPL_SIZE)
								end
									 = Team_Sub )
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous.sql  
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
			,dbo.udf_EML_GetGroupByTeam(Team) as EmployerSize_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN
	from EML_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.EML_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by dbo.udf_EML_GetGroupByTeam(Team),Team,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Team_Sub_Rolling_Month_1.sql  
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
			, dbo.udf_EML_GetGroupByTeam(Team) as EmployerSize_Group
			,[Type] = 'group'
			,uv.Remuneration_Start
			,uv.Remuneration_End
			,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
			,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
			,[Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',dbo.udf_EML_GetGroupByTeam(Team),uv.Team,uv.Measure)									
			, Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',dbo.udf_EML_GetGroupByTeam(Team),uv.Team,uv.Measure)
						
FROM         dbo.EML_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
GROUP BY uv.Team, dbo.udf_EML_GetGroupByTeam(Team), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Team_Sub_Rolling_Month_1.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Team_Sub_Rolling_Month_12.sql  
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
		  ,dbo.udf_EML_GetGroupByTeam(Team) as  EmployerSize_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration        
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',dbo.udf_EML_GetGroupByTeam(Team),uv.Team,uv.Measure)									
		  , Base = dbo.udf_dashboard_EML_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',dbo.udf_EML_GetGroupByTeam(Team),uv.Team,uv.Measure)
						
FROM         dbo.EML_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.EML_RTW)
GROUP BY uv.Team, dbo.udf_EML_GetGroupByTeam(Team), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_EML_RTW_Team_Sub_Rolling_Month_12.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Raw_Data.sql  
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
		, [Group] = dbo.udf_HEM_GetGroupByTeam(Team)
		, Sub_Category = ''
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Raw_Data.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Weekly_Open_1_2.sql  
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
						WHERE   dbo.udf_TMF_GetGroupByTeam(Team) = RTRIM(HEM_AWC.Unit)
								AND NOT EXISTS(SELECT   1
												FROM	HEM_AWC HEM_AWC2
												WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
														AND HEM_AWC2.time_id =(SELECT   max(time_Id)
																				FROM    HEM_AWC HEM_AWC3
																				WHERE   HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																						AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND  HEM_AWC.Time_ID
																				)
														AND dbo.udf_HEM_GetGroupByTeam(HEM_AWC2.Team) <> dbo.udf_HEM_GetGroupByTeam(HEM_AWC1.Team)
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
										AND dbo.udf_HEM_GetGroupByTeam(Team) = HEM_AWC.[Primary]
										AND NOT EXISTS(SELECT   1
														FROM	HEM_AWC HEM_AWC2
														WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
																AND HEM_AWC2.time_id =
																	(SELECT max(time_Id)
																	  FROM  HEM_AWC HEM_AWC3
																	  WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																			AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID)
																AND dbo.udf_HEM_GetGroupByTeam(HEM_AWC2.Team) <> dbo.udf_HEM_GetGroupByTeam(HEM_AWC1.Team)
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Weekly_Open_1_2.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Weekly_Open_3_5.sql  
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
                    WHERE   dbo.udf_HEM_GetGroupByTeam(Team) = RTRIM(HEM_AWC.Unit) 
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
													AND dbo.udf_HEM_GetGroupByTeam(HEM_AWC2.Team) <> dbo.udf_HEM_GetGroupByTeam(HEM_AWC1.Team)
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
								AND dbo.udf_HEM_GetGroupByTeam(Team) = HEM_AWC.[Primary]
								AND NOT EXISTS  (SELECT  1
                                                 FROM   HEM_AWC HEM_AWC2
                                                 WHERE  HEM_AWC2.claim_no = HEM_AWC1.claim_no 
														AND HEM_AWC2.time_id =(SELECT	max(time_Id)
																				FROM    HEM_AWC HEM_AWC3
																				WHERE   HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																						AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID
																				) 
														AND dbo.udf_HEM_GetGroupByTeam(HEM_AWC2.Team) <> dbo.udf_HEM_GetGroupByTeam(HEM_AWC1.Team)
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Weekly_Open_3_5.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Weekly_Open_5_Plus.sql  
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
                    WHERE   dbo.udf_HEM_GetGroupByTeam(Team) = RTRIM(HEM_AWC.Unit)
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
										AND dbo.udf_HEM_GetGroupByTeam(HEM_AWC2.Team) <> dbo.udf_HEM_GetGroupByTeam(HEM_AWC1.Team)
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
					AND dbo.udf_HEM_GetGroupByTeam(Team) = HEM_AWC.[Primary]
					AND NOT EXISTS (SELECT  1
                                    FROM    HEM_AWC HEM_AWC2
                                    WHERE   HEM_AWC2.claim_no = HEM_AWC1.claim_no 
											AND HEM_AWC2.time_id =(SELECT   max(time_Id)
                                                                      FROM  HEM_AWC HEM_AWC3
                                                                      WHERE HEM_AWC3.claim_no = HEM_AWC1.claim_no 
																			AND HEM_AWC3.time_id BETWEEN DATEADD(mm, - 2, HEM_AWC.Time_ID) AND HEM_AWC.Time_ID
																	) 
                                            AND dbo.udf_HEM_GetGroupByTeam(HEM_AWC2.Team) <> dbo.udf_HEM_GetGroupByTeam(HEM_AWC1.Team)
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Weekly_Open_5_Plus.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Whole_HEM.sql  
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
					  WHERE dbo.udf_TMF_GetGroupByTeam(Team) = RTRIM(HEM_AWC.[Primary]) 
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
					  WHERE dbo.udf_TMF_GetGroupByTeam(Team) = RTRIM(HEM_AWC.[Primary]) AND RTRIM(Team) = RTRIM(HEM_AWC.Unit) 
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_AWC_Whole_HEM.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current.sql  
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
	WITH temp AS 
	(
		select * 
		from
			(select 0 as month_period
			union all
			select 2 as month_period
			union all
			select 5 as month_period
			union all
			select 11 as month_period) as month_period
			cross join
			(select 13 as Measure_months
			union all
			select 26 as Measure_months
			union all
			select 52 as Measure_months
			union all
			select 78 as Measure_months
			union all
			select 104 as Measure_months) as measure_months		
			cross join
			(
			select distinct 'Hospitality' as EmployerSize_Group,[Type]='portfolio'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
			   
			union
			select distinct rtrim(Portfolio) as EmployerSize_Group, [Type]='portfolio'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				and rtrim(Portfolio) IS NOT NULL
				
			union
			select distinct 'Hospitality' as EmployerSize_Group, [Type]='group'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				
			union
			select distinct dbo.udf_HEM_GetGroupByTeam(Team) as EmployerSize_Group, [Type]='group'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				
			union
			select distinct 'Hospitality' as EmployerSize_Group, [Type]='account_manager'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				
			union
			select distinct rtrim([Account_Manager]) as EmployerSize_Group, [Type]='account_manager'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				and rtrim([Account_Manager]) is not null
				
			union
			select distinct 'Hotel' as EmployerSize_Group, [Type]='portfolio'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				and rtrim(Portfolio) IS NOT NULL	
				
			) as temp_value
	)
	
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
			,dbo.udf_HEM_GetGroupByTeam(Team) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(Remuneration_End,'target','group',dbo.udf_HEM_GetGroupByTeam(Team),NULL,Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by dbo.udf_HEM_GetGroupByTeam(Team),Measure,Remuneration_Start, Remuneration_End
	
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
	
	--add missing measure months
	union all
	select Month_period=case when month_period = 0
							then 1
						 when month_period = 2
							then 3
						 when month_period = 5
							then 6
						 when month_period = 11
							then 12
					end
		  ,[Type]
		  ,EmployerSize_Group
		  ,Measure_months
		  ,LT = 0
		  ,WGT = 0
		  ,AVGDURN = 0
		  ,[Target] = 0
	from temp as tmp
	where Measure_months not in (select distinct Measure from HEM_RTW uv
							where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
							and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) = tmp.month_period
							and case when [Type] = 'group' then (case when EmployerSize_Group <> 'Hospitality' then dbo.udf_HEM_GetGroupByTeam(rtrim(uv.Team)) else 'Hospitality' end)
									 when [Type] = 'portfolio' then (case when EmployerSize_Group <> 'Hospitality' 
																			then (case when EmployerSize_Group = 'hotel' and uv.Portfolio in ('Accommodation','Pubs, Taverns and Bars') then 'hotel'
																					   else rtrim(uv.Portfolio)
																				  end
																			     )
																		  else 'Hospitality' 
																	 end)
									 when [Type] = 'account_manager' then (case when EmployerSize_Group <> 'Hospitality' then rtrim(uv.Account_Manager) else 'Hospitality' end)
								end
									 = EmployerSize_Group )
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous.sql  
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
			,dbo.udf_HEM_GetGroupByTeam(Team) as EmployerSize_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by dbo.udf_HEM_GetGroupByTeam(Team),Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Rolling_Month_1.sql  
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

SELECT     dbo.udf_HEM_GetGroupByTeam(Team) as EmployerSize_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',dbo.udf_HEM_GetGroupByTeam(Team),NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',dbo.udf_HEM_GetGroupByTeam(Team),NULL,uv.Measure)
						
FROM         dbo.HEM_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
GROUP BY  dbo.udf_HEM_GetGroupByTeam(Team), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Rolling_Month_1.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Rolling_Month_12.sql  
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

SELECT    EmployerSize_Group = dbo.udf_HEM_GetGroupByTeam(Team)
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) 
          
          ,Measure_months = Measure 
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',dbo.udf_HEM_GetGroupByTeam(Team),NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',dbo.udf_HEM_GetGroupByTeam(Team),NULL,uv.Measure)
						
FROM      dbo.HEM_RTW uv 

WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
		  and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)

GROUP BY  dbo.udf_HEM_GetGroupByTeam(Team), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Agency_Group_Rolling_Month_12.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Raw_Data.sql  
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
			,[Group] = dbo.udf_HEM_GetGroupByTeam(Team)
			,Team
			,Sub_Category = ''
			,Case_manager
			,AgencyName = ''
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Raw_Data.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current.sql  
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
	WITH temp AS 
	(
		select * 
		from
			(select 0 as month_period
			union all
			select 2 as month_period
			union all
			select 5 as month_period
			union all
			select 11 as month_period) as month_period
			cross join
			(select 13 as Measure_months
			union all
			select 26 as Measure_months
			union all
			select 52 as Measure_months
			union all
			select 78 as Measure_months
			union all
			select 104 as Measure_months) as measure_months		
			cross join
			(
			select distinct rtrim(Portfolio) as EmployerSize_Group, rtrim(EMPL_SIZE) as Team_Sub, [Type]='portfolio'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				and rtrim(Portfolio) IS NOT NULL
				
			union
			select distinct dbo.udf_HEM_GetGroupByTeam(Team) as EmployerSize_Group,rtrim(Team) as Team_Sub, [Type]='group'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				
			union
			select distinct rtrim([Account_Manager]) as EmployerSize_Group, rtrim(EMPL_SIZE) as Team_Sub, [Type]='account_manager'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				and rtrim([Account_Manager]) is not null
				
			union
			select distinct 'Hotel' as EmployerSize_Group ,rtrim(EMPL_SIZE) as Team_Sub, [Type]='portfolio'
			from HEM_RTW uv 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
				and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
				and rtrim(Portfolio) IS NOT NULL
				and rtrim([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')	
				
			) as temp_value
	)
	
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
			,dbo.udf_HEM_GetGroupByTeam(Team) as EmployerSize_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',dbo.udf_HEM_GetGroupByTeam(Team),rtrim(Team),Measure),0)
	from HEM_RTW uv
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by dbo.udf_HEM_GetGroupByTeam(Team),Team,Measure,Remuneration_Start, Remuneration_End
	
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
	
	--add missing measure months
	union all
	select Month_period=case when month_period = 0
							then 1
						 when month_period = 2
							then 3
						 when month_period = 5
							then 6
						 when month_period = 11
							then 12
					end
		  ,[Type]
		  ,EmployerSize_Group
		  ,Team_Sub
		  ,Measure_months
		  ,LT = 0
		  ,WGT = 0
		  ,AVGDURN = 0
		  ,[Target] = 0
	from temp as tmp
	where Measure_months not in (select distinct Measure from HEM_RTW uv
							where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
							and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) = tmp.month_period
							and case when [Type] = 'group' then dbo.udf_HEM_GetGroupByTeam(rtrim(uv.Team))
									 when [Type] = 'portfolio' then (case when EmployerSize_Group = 'hotel' and uv.Portfolio in ('Accommodation','Pubs, Taverns and Bars') then 'hotel'
																					   else rtrim(uv.Portfolio)
																				  end
																			     ) 
									 when [Type] = 'account_manager' then rtrim(uv.Account_Manager)
								end
									 = EmployerSize_Group
							and case when [Type] = 'group' then rtrim(uv.Team)
									 when [Type] = 'portfolio' then rtrim(uv.EMPL_SIZE) 
									 when [Type] = 'account_manager' then rtrim(uv.EMPL_SIZE)
								end
									 = Team_Sub)
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous.sql  
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
			,dbo.udf_HEM_GetGroupByTeam(Team) as EmployerSize_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from HEM_RTW uv
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.HEM_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by dbo.udf_HEM_GetGroupByTeam(Team),Team,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)
	
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Team_Sub_Rolling_Month_1.sql  
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
			, dbo.udf_HEM_GetGroupByTeam(Team) as EmployerSize_Group
			,[Type] = 'group'
			,uv.Remuneration_Start
			,uv.Remuneration_End
			,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
			,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
			,[Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',dbo.udf_HEM_GetGroupByTeam(Team),uv.Team,uv.Measure)									
			, Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',dbo.udf_HEM_GetGroupByTeam(Team),uv.Team,uv.Measure)
						
FROM         dbo.HEM_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
GROUP BY uv.Team, dbo.udf_HEM_GetGroupByTeam(Team), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Team_Sub_Rolling_Month_1.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Team_Sub_Rolling_Month_12.sql  
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
		  ,dbo.udf_HEM_GetGroupByTeam(Team) as  EmployerSize_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration        
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',dbo.udf_HEM_GetGroupByTeam(Team),uv.Team,uv.Measure)									
		  , Base = dbo.udf_dashboard_HEM_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',dbo.udf_HEM_GetGroupByTeam(Team),uv.Team,uv.Measure)
						
FROM         dbo.HEM_RTW uv where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
GROUP BY uv.Team, dbo.udf_HEM_GetGroupByTeam(Team), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_HEM_RTW_Team_Sub_Rolling_Month_12.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_PORT.sql  
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
	SELECT  System='TMF',
			Med_Cert_Status=Med_Cert_Status_This_Week,
			rtrim(isnull(sub.AgencyName,'Miscellaneous')) as Agency_Name,
			rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Sub_Category,
			[Group] = dbo.udf_TMF_GetGroupByTeam(Team),
			sub.AgencyId as Agency_Id,
			
			-- NCMM action complete
			NCMM_Complete_Action_Due_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Action_Due end,
			NCMM_Complete_Remaining_Days_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Remaining_Days end,
			
			-- NCMM action prepare
			NCMM_Actions_Next_Week_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Actions_Next_Week
										end,
			NCMM_Prepare_Action_Due_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Prepare_Action_Due
										end,
			NCMM_Prepare_Remaining_Days_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
													then NCMM_Prepare_Remaining_Days
											end,
			
			uv.*,
			[Grouping] = case when rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health', 'Other')
								then 'HEALTH & OTHER'
							when rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police', 'Fire', 'RFS')
								then 'POLICE & FIRE & RFS'
							else ''
						end
		FROM dbo.TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
		 
	UNION ALL
	
	SELECT  System='HEM',
			Med_Cert_Status=Med_Cert_Status_This_Week,
			Agency_Name = '',
			Sub_Category='',
			[Group] = dbo.udf_HEM_GetGroupByTeam(Team),
			Agency_Id = '',
			
			-- NCMM action complete
			NCMM_Complete_Action_Due_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Action_Due end,
			NCMM_Complete_Remaining_Days_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Remaining_Days end,
			
			-- NCMM action prepare
			NCMM_Actions_Next_Week_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Actions_Next_Week
										end,
			NCMM_Prepare_Action_Due_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Prepare_Action_Due
										end,
			NCMM_Prepare_Remaining_Days_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
													then NCMM_Prepare_Remaining_Days
											end,
			
			*,
			[Grouping] = case when RTRIM(Portfolio) in ('Accommodation', 'Pubs, Taverns and Bars')
								then 'Hotel'
							else ''
						end
		FROM dbo.HEM_Portfolio
	
	UNION ALL
	
	SELECT  System='EML',
			Med_Cert_Status=Med_Cert_Status_This_Week,
			Agency_Name = '',
			Sub_Category='',
			[Group] = dbo.udf_EML_GetGroupByTeam(Team),
			Agency_Id = '',
			
			-- NCMM action complete
			NCMM_Complete_Action_Due_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Action_Due end,
			NCMM_Complete_Remaining_Days_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Remaining_Days end,
			
			-- NCMM action prepare
			NCMM_Actions_Next_Week_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Actions_Next_Week
										end,
			NCMM_Prepare_Action_Due_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Prepare_Action_Due
										end,
			NCMM_Prepare_Remaining_Days_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
													then NCMM_Prepare_Remaining_Days
											end,
			
			*,
			[Grouping] = ''
		FROM dbo.EML_Portfolio
		
	UNION ALL
	
	SELECT System='WOW',
			Med_Cert_Status=Med_Cert_Status_This_Week,
			Agency_Name = '',
			Sub_Category='',
			[Group] = dbo.udf_WOW_GetGroupByTeam(Team),
			Agency_Id = '',
			
			-- NCMM action complete
			NCMM_Complete_Action_Due_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Action_Due end,
			NCMM_Complete_Remaining_Days_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Remaining_Days end,
			
			-- NCMM action prepare
			NCMM_Actions_Next_Week_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Actions_Next_Week
										end,
			NCMM_Prepare_Action_Due_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Prepare_Action_Due
										end,
			NCMM_Prepare_Remaining_Days_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
													then NCMM_Prepare_Remaining_Days
											end
			,Id
			,Team
			,Case_Manager
			,Policy_No
			,EMPL_SIZE = ''
			,Account_manager = ''
			,Portfolio = ''
			,Reporting_Date
			,Claim_No
			,WIC_Code
			,Company_Name
			,Worker_Name
			,Employee_Number
			,Worker_Phone_Number
			,Claims_Officer_Name
			,Date_Of_Birth
			,Date_Of_Injury
			,Date_Of_Notification
			,Notification_Lag
			,Entered_Lag
			,Claim_Liability_Indicator_Group
			,Investigation_Incurred
			,Total_Paid
			,Is_Time_Lost
			,Claim_Closed_Flag
			,Date_Claim_Entered
			,Date_Claim_Closed
			,Date_Claim_Received
			,Date_Claim_Reopened
			,Result_Of_Injury_Code
			,WPI
			,Common_Law
			,Total_Recoveries
			,Is_Working
			,Physio_Paid
			,Chiro_Paid
			,Massage_Paid
			,Osteopathy_Paid
			,Acupuncture_Paid
			,Create_Date
			,Is_Stress
			,Is_Inactive_Claims
			,Is_Medically_Discharged
			,Is_Exempt
			,Is_Reactive
			,Is_Medical_Only
			,Is_D_D
			,NCMM_Actions_This_Week
			,NCMM_Actions_Next_Week
			,HoursPerWeek
			,Is_Industrial_Deafness
			,Rehab_Paid
			,Action_Required
			,RTW_Impacting
			,Weeks_In
			,Weeks_Band
			,Hindsight
			,Active_Weekly
			,Active_Medical
			,Cost_Code
			,Cost_Code2
			,CC_Injury
			,CC_Current			
			,Med_Cert_Status_This_Week
			,Capacity
			,Entitlement_Weeks
			,Med_Cert_Status_Prev_1_Week
			,Med_Cert_Status_Prev_2_Week
			,Med_Cert_Status_Prev_3_Week
			,Med_Cert_Status_Prev_4_Week
			,Is_Last_Month
			,IsPreClosed
			,IsPreOpened
			,NCMM_Complete_Action_Due
			,NCMM_Complete_Remaining_Days
			,NCMM_Prepare_Action_Due
			,NCMM_Prepare_Remaining_Days			
			,[Grouping] = ''
		FROM dbo.WOW_Portfolio
		
	
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_PORT.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_PORT_Get_All_Claim_Type.sql  
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
	SELECT  Claim_Type = 'claim_new_all', iClaim_Type = 0
	union SELECT Claim_Type = 'claim_new_lt', iClaim_Type = 1
	union SELECT Claim_Type = 'claim_new_nlt', iClaim_Type = 2
	
	-- BEGIN: OPEN CLAIMS	
		
	union SELECT Claim_Type = 'claim_open_all', iClaim_Type = 3
	
	-- OPEN CLAIMS: RTW
	union SELECT Claim_Type = 'claim_open_0_13', iClaim_Type = 4
	union SELECT Claim_Type = 'claim_open_13_26', iClaim_Type = 5
	union SELECT Claim_Type = 'claim_open_26_52', iClaim_Type = 6
	union SELECT Claim_Type = 'claim_open_52_78', iClaim_Type = 7
	union SELECT Claim_Type = 'claim_open_0_78', iClaim_Type = 8
	union SELECT Claim_Type = 'claim_open_78_130', iClaim_Type = 9
	union SELECT Claim_Type = 'claim_open_gt_130', iClaim_Type = 10
	
	union SELECT Claim_Type = 'claim_open_nlt', iClaim_Type = 11
	
	-- OPEN CLAIMS: NCMM
	union SELECT Claim_Type = 'claim_open_ncmm_this_week', iClaim_Type = 12
	union SELECT Claim_Type = 'claim_open_ncmm_next_week', iClaim_Type = 13
	
	-- OPEN CLAIMS: THERAPY TREATMENTS
	union SELECT Claim_Type = 'claim_open_acupuncture', iClaim_Type = 14
	union SELECT Claim_Type = 'claim_open_chiro', iClaim_Type = 15
	union SELECT Claim_Type = 'claim_open_massage', iClaim_Type = 16
	union SELECT Claim_Type = 'claim_open_osteo', iClaim_Type = 17
	union SELECT Claim_Type = 'claim_open_physio', iClaim_Type = 18
	union SELECT Claim_Type = 'claim_open_rehab', iClaim_Type = 19
	
	-- OPEN CLAIMS: LUMP SUM INTIMATIONS
	union SELECT Claim_Type = 'claim_open_death', iClaim_Type = 20
	union SELECT Claim_Type = 'claim_open_industrial_deafness', iClaim_Type = 21
	union SELECT Claim_Type = 'claim_open_ppd', iClaim_Type = 22
	union SELECT Claim_Type = 'claim_open_recovery', iClaim_Type = 23
	
	-- OPEN CLAIMS: LUMP SUM INTIMATIONS - WPI
	union SELECT Claim_Type = 'claim_open_wpi_all', iClaim_Type = 24
	union SELECT Claim_Type = 'claim_open_wpi_0_10', iClaim_Type = 25
	union SELECT Claim_Type = 'claim_open_wpi_11_14', iClaim_Type = 26
	union SELECT Claim_Type = 'claim_open_wpi_15_20', iClaim_Type = 27
	union SELECT Claim_Type = 'claim_open_wpi_21_30', iClaim_Type = 28
	union SELECT Claim_Type = 'claim_open_wpi_31_more', iClaim_Type = 29
	
	union SELECT Claim_Type = 'claim_open_wid', iClaim_Type = 30
	
	-- END: OPEN CLAIMS
	
	-- CLAIM CLOSURES
	union SELECT Claim_Type = 'claim_closure', iClaim_Type = 31
	union SELECT Claim_Type = 'claim_re_open', iClaim_Type = 32
	union SELECT Claim_Type = 'claim_still_open', iClaim_Type = 33
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_PORT_Get_All_Claim_Type.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_PORT_Get_All_PORT_Type.sql  
--------------------------------  
IF EXISTS(select * FROM sys.views where name = 'uv_PORT_Get_All_PORT_Type')
	DROP VIEW [dbo].[uv_PORT_Get_All_PORT_Type]
GO

/****** Object:  UserDefinedFunction [dbo].[uv_PORT_Get_All_PORT_Type]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[uv_PORT_Get_All_PORT_Type]
AS
		SELECT PORT_Type = 'ffsd_at_work_15_less', iPORT_Type = 1
		union SELECT PORT_Type = 'ffsd_at_work_15_more', iPORT_Type = 2
		union SELECT PORT_Type = 'ffsd_not_at_work', iPORT_Type = 3
		union SELECT PORT_Type = 'pid', iPORT_Type = 4
		union SELECT PORT_Type = 'totally_unfit', iPORT_Type = 5
		union SELECT PORT_Type = 'therapy_treat', iPORT_Type = 6
		union SELECT PORT_Type = 'd_d', iPORT_Type = 7
		union SELECT PORT_Type = 'med_only', iPORT_Type = 8
		union SELECT PORT_Type = 'lum_sum_in', iPORT_Type = 9
		union SELECT PORT_Type = 'ncmm_this_week', iPORT_Type = 10
		union SELECT PORT_Type = 'ncmm_next_week', iPORT_Type = 11
		union SELECT PORT_Type = 'overall', iPORT_Type = 12
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_PORT_Get_All_PORT_Type.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Raw_Data.sql  
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
		, [Group] = dbo.udf_TMF_GetGroupByTeam(Team)
		, Sub_Category = RTRIM(ISNULL(sub.Sub_Category,'Miscellaneous'))
		, AgencyName = RTRIM(ISNULL(sub.AgencyName,'Miscellaneous'))
		, Date_of_Injury
		, Cert_Type
		, Med_cert_From
		, Med_cert_To
		, Account_Manager
		, Cell_no
		, Portfolio
FROM    dbo.TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
WHERE    (Time_ID >= DATEADD(mm, - 2,DATEADD(yy, DATEDIFF(yy,0,GETDATE()), 0)))
		
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Raw_Data.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Weekly_Open_1_2.sql  
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
			,Actual = (SELECT	COUNT(DISTINCT tmf_awc1.claim_no)
						FROM	TMF_AWC tmf_awc1
						WHERE   tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID 
								AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1
									AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC))
			,Projection =  (SELECT	ISNULL(sum(Projection), 0)
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
						FROM	TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
						WHERE   RTRIM(ISNULL(AgencyName, 'Miscellaneous')) = RTRIM(tmf_awc.[Primary])
								AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID 
								AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1
									AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC))
			,Projection =  (SELECT	ISNULL(sum(Projection), 0)
								FROM	dbo.TMF_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'agency' 
										AND RTRIM(Unit_Name) = RTRIM(tmf_awc.[Primary]) 
										AND year(Time_Id) = Year(tmf_awc.Time_Id) 
										AND month(Time_Id)= month(tmf_awc.Time_Id))
	FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','1-2') TMF_AWC
	
	--Agency Police & Fire & RFS--
	UNION ALL
	SELECT  [Type] = 'agency'
			,Unit = 'POLICE & EMERGENCY SERVICES'
			,[Primary] = 'POLICE & EMERGENCY SERVICES'
			,WeeklyType = '1-2'
			,Time_Id
			,Month_Year = LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, Time_Id), 2)
			,Actual = (SELECT   COUNT(DISTINCT tmf_awc1.claim_no)
						FROM	TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
						WHERE   RTRIM(AgencyName) in ('Police','Fire','RFS')
								AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID 
								AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1
								AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC))
			,Projection =  (SELECT ISNULL(sum(Projection), 0)
								FROM	dbo.TMF_AWC_Projections
								WHERE   [Type] = '1-2' AND Unit_Type = 'agency' 
										AND RTRIM(Unit_Name) in ('Police','Fire','RFS')
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
						FROM	TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
						WHERE   RTRIM(AgencyName) in ('Health','Other')
								AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID 
								AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1
									AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC))
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
						WHERE   dbo.udf_TMF_GetGroupByTeam(Team) = RTRIM(tmf_awc.Unit)
								AND NOT EXISTS(SELECT   1
												FROM	tmf_awc tmf_awc2
												WHERE   tmf_awc2.claim_no = tmf_awc1.claim_no 
														AND tmf_awc2.time_id =(SELECT   max(time_Id)
																				FROM    tmf_awc tmf_awc3
																				WHERE   tmf_awc3.claim_no = tmf_awc1.claim_no 
																						AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND  tmf_awc.Time_ID)
														AND dbo.udf_TMF_GetGroupByTeam(tmf_awc2.Team) <> dbo.udf_TMF_GetGroupByTeam(tmf_awc1.Team))
								AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2,tmf_awc.Time_ID) AND tmf_awc.Time_ID 
								AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1
								AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC))
			,Projection =(SELECT	ISNULL(sum(Projection), 0)
							FROM    dbo.TMF_AWC_Projections
							WHERE   [Type] = '1-2' AND Unit_Type = 'group' 
									AND RTRIM(Unit_Name) = RTRIM(tmf_awc.Unit) 
									AND year(Time_Id) = Year(tmf_awc.Time_Id) 
									AND month(Time_Id)= month(tmf_awc.Time_Id))
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
						FROM    TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
						WHERE   RTRIM(ISNULL(Sub_Category, 'Miscellaneous')) = RTRIM(tmf_awc.Unit)
								AND RTRIM(ISNULL(AgencyName, 'Miscellaneous')) = RTRIM(tmf_awc.[Primary])
								AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID 
								AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1
								AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC))
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
								WHERE   RTRIM(Team) = RTRIM(TMF_AWC.Unit)
										AND dbo.udf_TMF_GetGroupByTeam(Team) = RTRIM(TMF_AWC.[Primary])
										AND NOT EXISTS(SELECT   1
														FROM	tmf_awc tmf_awc2
														WHERE   tmf_awc2.claim_no = tmf_awc1.claim_no 
																AND tmf_awc2.time_id =
																	(SELECT max(time_Id)
																	  FROM  tmf_awc tmf_awc3
																	  WHERE tmf_awc3.claim_no = tmf_awc1.claim_no 
																			AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID)
																AND dbo.udf_TMF_GetGroupByTeam(tmf_awc2.Team) <> dbo.udf_TMF_GetGroupByTeam(tmf_awc1.Team)) 
										AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID 
										AND Year(tmf_awc1.Date_of_injury) = Year(tmf_awc.Time_ID) - 1 
										AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC))
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Weekly_Open_1_2.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Weekly_Open_3_5.sql  
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
                            FROM          TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
                            WHERE      RTRIM(ISNULL(AgencyName, 'Miscellaneous')) = RTRIM(tmf_awc.[Primary]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) BETWEEN Year(tmf_awc.Time_ID) - 4 AND Year(tmf_awc.Time_ID) - 2
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC)
                                                    
                                                )
                , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '3-5' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) = RTRIM(tmf_awc.[Primary]) AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','3-5') TMF_AWC

--Agency Police & Fire & RFS--
UNION ALL
SELECT     [Type] = 'agency', Unit = 'POLICE & EMERGENCY SERVICES', [Primary] = 'POLICE & EMERGENCY SERVICES', WeeklyType = '3-5', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
                            WHERE      RTRIM(AgencyName) in ('Police','Fire','RFS') AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) BETWEEN Year(tmf_awc.Time_ID) - 4 AND Year(tmf_awc.Time_ID) - 2
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC)
                                                    )
                , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '3-5' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) in ('Police','Fire','RFS') AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','3-5') TMF_AWC
WHERE   RTRIM([Primary]) = 'Police'
		
--Agency Health & Other--
UNION ALL
SELECT     [Type] = 'agency', Unit = 'Health & Other', [Primary] = 'Health & Other', WeeklyType = '3-5', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
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
                            WHERE      dbo.udf_TMF_GetGroupByTeam(Team) = RTRIM(tmf_awc.Unit) AND NOT EXISTS
                                                       (SELECT     1
                                                         FROM          tmf_awc tmf_awc2
                                                         WHERE      tmf_awc2.claim_no = tmf_awc1.claim_no AND tmf_awc2.time_id =
                                                                                    (SELECT     max(time_Id)
                                                                                      FROM          tmf_awc tmf_awc3
                                                                                      WHERE	tmf_awc3.claim_no = tmf_awc1.claim_no AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID)
																							AND dbo.udf_TMF_GetGroupByTeam(tmf_awc2.Team) <> dbo.udf_TMF_GetGroupByTeam(tmf_awc1.Team))
                                                    AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
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
                            FROM          TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
                            WHERE      RTRIM(ISNULL(Sub_Category, 'Miscellaneous')) = RTRIM(tmf_awc.Unit) AND RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
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
                            WHERE		RTRIM(Team) = RTRIM(TMF_AWC.Unit)
										AND dbo.udf_TMF_GetGroupByTeam(Team) = RTRIM(TMF_AWC.[Primary])
										AND NOT EXISTS
                                                       (SELECT     1
                                                         FROM          tmf_awc tmf_awc2
                                                         WHERE      tmf_awc2.claim_no = tmf_awc1.claim_no AND tmf_awc2.time_id =
                                                                                    (SELECT     max(time_Id)
                                                                                      FROM          tmf_awc tmf_awc3
                                                                                      WHERE      tmf_awc3.claim_no = tmf_awc1.claim_no AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID) 
																							AND dbo.udf_TMF_GetGroupByTeam(tmf_awc2.Team) <> dbo.udf_TMF_GetGroupByTeam(tmf_awc1.Team)) 
										AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Weekly_Open_3_5.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Weekly_Open_5_Plus.sql  
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
                          (SELECT	COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM    TMF_AWC tmf_awc1
                            WHERE	tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND
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
                            FROM          TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
                            WHERE      RTRIM(ISNULL(AgencyName, 'Miscellaneous')) = RTRIM(tmf_awc.[Primary]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4  
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	                                                  
                                                        )
                        , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) = RTRIM(tmf_awc.[Primary]) AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','5-plus') TMF_AWC

--Agency Police & Fire & RFS--
UNION ALL 
SELECT     [Type] = 'agency', Unit = 'POLICE & EMERGENCY SERVICES', [Primary] = 'POLICE & EMERGENCY SERVICES', WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
                            WHERE      RTRIM(AgencyName) in ('Police','Fire','RFS') AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID AND 
                                                   Year(tmf_awc1.Date_of_injury) < Year(tmf_awc.Time_ID) - 4    
                                                   AND TMF_AWC.Time_ID <= (select MAX(Time_ID) from TMF_AWC) 	                                                
                                            )
                        , Projection =
                          (SELECT     ISNULL(sum(Projection), 0)
                            FROM          dbo.TMF_AWC_Projections
                            WHERE      [Type] = '5-plus' AND Unit_Type = 'agency' AND RTRIM(Unit_Name) in ('Police','Fire','RFS') AND year(Time_Id) = Year(tmf_awc.Time_Id) AND month(Time_Id) 
                                                   = month(tmf_awc.Time_Id))
FROM    dbo.udf_TMF_AWC_Generate_Time_ID('agency','5-plus') TMF_AWC
WHERE   RTRIM([Primary]) = 'Police'
		
--Agency Health & Other--
UNION ALL 
SELECT     [Type] = 'agency', Unit = 'Health & Other', [Primary] = 'Health & Other', WeeklyType = '5-plus', Time_Id, LEFT(datename(month, Time_Id), 3) + '- ' + RIGHT(datename(year, 
                      Time_Id), 2) AS Month_Year, Actual =
                          (SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
                            FROM          TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
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
                            WHERE      dbo.udf_TMF_GetGroupByTeam(Team) = RTRIM(tmf_awc.Unit) AND NOT EXISTS
                                                       (SELECT     1
                                                         FROM          tmf_awc tmf_awc2
                                                         WHERE      tmf_awc2.claim_no = tmf_awc1.claim_no AND tmf_awc2.time_id =
                                                                                    (SELECT     max(time_Id)
                                                                                      FROM          tmf_awc tmf_awc3
                                                                                      WHERE      tmf_awc3.claim_no = tmf_awc1.claim_no AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID) 
																						AND dbo.udf_TMF_GetGroupByTeam(tmf_awc2.Team) <> dbo.udf_TMF_GetGroupByTeam(tmf_awc1.Team))
									AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
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
                            FROM          TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
                            WHERE      RTRIM(ISNULL(Sub_Category, 'Miscellaneous')) = RTRIM(tmf_awc.Unit) AND RTRIM(AgencyName) = RTRIM(tmf_awc.[Primary]) AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
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
                            WHERE       RTRIM(Team) = RTRIM(TMF_AWC.Unit)
										AND dbo.udf_TMF_GetGroupByTeam(Team) = RTRIM(TMF_AWC.[Primary])
										AND NOT EXISTS
                                                       (SELECT     1
                                                         FROM          tmf_awc tmf_awc2
                                                         WHERE      tmf_awc2.claim_no = tmf_awc1.claim_no 
															AND tmf_awc2.time_id =
																(SELECT     max(time_Id)
																  FROM          tmf_awc tmf_awc3
																  WHERE      tmf_awc3.claim_no = tmf_awc1.claim_no AND tmf_awc3.time_id BETWEEN DATEADD(mm, - 2, tmf_awc.Time_ID) AND tmf_awc.Time_ID) 
																			AND dbo.udf_TMF_GetGroupByTeam(tmf_awc2.Team) <> dbo.udf_TMF_GetGroupByTeam(tmf_awc1.Team))
										AND tmf_awc1.Time_ID BETWEEN DATEADD(mm, - 2, 
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Weekly_Open_5_Plus.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Whole_TMF.sql  
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
				  FROM         TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
				  WHERE     RTRIM(ISNULL(AgencyName, 'Miscellaneous')) = RTRIM(tmf_awc.[Primary]) 
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
	
	--Agency Police & Fire & RFS--
	UNION ALL
	SELECT  [UnitType] = 'agency'
			,Unit = 'POLICE & EMERGENCY SERVICES'
			,[Primary] = 'POLICE & EMERGENCY SERVICES'
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Actual' 
			,No_of_Active_Weekly_Claims = isnull(
				(SELECT     COUNT(DISTINCT tmf_awc1.claim_no)
				  FROM         TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
				  WHERE     RTRIM(AgencyName) in ('Police','Fire','RFS')
							AND tmf_awc1.time_id >= dateadd(mm, - 2,
								(SELECT    max(time_id) FROM  tmf_awc)) 
							AND year(Date_of_Injury) = Year(tmf_awc.Transaction_Date))
				, 0)
	FROM    dbo.udf_Whole_TMF_Generate_Years('agency') TMF_AWC
	WHERE	RTRIM([Primary]) = 'Police'

	UNION ALL ----Projection----
	SELECT  [UnitType] = 'agency'
			,Unit = 'POLICE & EMERGENCY SERVICES'
			,[Primary] = 'POLICE & EMERGENCY SERVICES'
			,Transaction_Year = Year(Transaction_Date)
			,[Type] = 'Projection'
			,No_of_Active_Weekly_Claims = 
				isnull(
					(SELECT top 1 Projection
						FROM   dbo.TMF_AWC_Projections
						WHERE [Type] = 'Whole-TMF' AND Unit_Type = 'agency' 
							AND RTRIM(Unit_Name) in ('Police', 'Fire', 'RFS')
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
				  FROM         TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
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
					  WHERE dbo.udf_TMF_GetGroupByTeam(Team) = RTRIM(tmf_awc.[Primary]) 
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
					  FROM         TMF_AWC tmf_awc1 left join TMF_Agencies_Sub_Category sub on tmf_awc1.POLICY_NO = sub.POLICY_NO
					  WHERE     RTRIM(ISNULL(Sub_Category, 'Miscellaneous')) = RTRIM(tmf_awc.Unit)
								AND RTRIM(ISNULL(AgencyName, 'Miscellaneous')) = RTRIM(tmf_awc.[Primary])
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
							AND dbo.udf_TMF_GetGroupByTeam(Team) = RTRIM(TMF_AWC.[Primary])
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_AWC_Whole_TMF.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current.sql  
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
			,rtrim(isnull(sub.AgencyName,'Miscellaneous')) as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),NULL,Measure),0)
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   
	group by rtrim(isnull(sub.AgencyName,'Miscellaneous')),Measure, Remuneration_Start, Remuneration_End
	
	--Agency Police & Fire & RFS
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
			,'POLICE & EMERGENCY SERVICES' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency','POLICE & EMERGENCY SERVICES',NULL,Measure),0)
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire', 'RFS')

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
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other')

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
			,rtrim(isnull(sub.[Group],'Miscellaneous')) as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','group',rtrim(isnull(sub.[group],'Miscellaneous')),NULL,Measure),0)
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by rtrim(isnull(sub.[Group],'Miscellaneous')),Measure,Remuneration_Start, Remuneration_End	
	
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
	where Measure_months not in (select distinct Measure from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
							where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
							and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) = case when month_period = 1 then 0
																						   when month_period = 3 then 2
																						   when month_period = 6 then 5
																						   when month_period = 12 then 11
																					  end
							and CHARINDEX(case when RTRIM(Agency_Group) = 'TMF' then 'TMF' else RTRIM(sub.AgencyName) end, RTRIM(Agency_Group),0) > 0
							)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous.sql  
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
			,rtrim(isnull(sub.AgencyName,'Miscellaneous')) as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by rtrim(isnull(sub.AgencyName,'Miscellaneous')),Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	
	
	--Agency Police & Fire & RFS
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
			,'POLICE & EMERGENCY SERVICES' as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire', 'RFS')
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
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other')
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
			,rtrim(isnull(sub.[Group],'Miscellaneous')) as Agency_Group
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by rtrim(isnull(sub.[Group],'Miscellaneous')),Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Rolling_Month_1.sql  
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

SELECT     rtrim(isnull(sub.[Group],'Miscellaneous')) as Agency_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',rtrim(isnull(sub.[Group],'Miscellaneous')),NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',rtrim(isnull(sub.[Group],'Miscellaneous')),NULL,uv.Measure)
						
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY  rtrim(isnull(sub.[Group],'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     rtrim(isnull(sub.AgencyName,'Miscellaneous')) as Agency_Group
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),NULL,uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),NULL,uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY  rtrim(isnull(sub.AgencyName,'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Police & Fire & RFS--
UNION ALL

SELECT     'POLICE & EMERGENCY SERVICES' as Agency_Group
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   , uv.Remuneration_End
		   ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
          
          , Measure AS Measure_months
          , SUM(uv.LT) AS LT
          , SUM(uv.WGT) AS WGT
          , SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','POLICE & EMERGENCY SERVICES',NULL,uv.Measure)
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','POLICE & EMERGENCY SERVICES',NULL,uv.Measure)
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire','RFS')
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
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other')
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Rolling_Month_1.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Rolling_Month_12.sql  
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

SELECT    Agency_Group = rtrim(isnull(sub.[Group],'Miscellaneous'))
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) 
          
          ,Measure_months = Measure 
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',rtrim(isnull(sub.[Group],'Miscellaneous')),NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',rtrim(isnull(sub.[Group],'Miscellaneous')),NULL,uv.Measure)
						
FROM      dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO

WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
		  and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)

GROUP BY  rtrim(isnull(sub.[Group],'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT     Agency_Group = rtrim(isnull(sub.AgencyName,'Miscellaneous'))
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),NULL,uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),NULL,uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY  rtrim(isnull(sub.AgencyName,'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Police & Fire & RFS--
UNION ALL

SELECT     Agency_Group = 'POLICE & EMERGENCY SERVICES'
		   ,[Type] = 'agency' 
		   ,uv.Remuneration_Start
		   ,uv.Remuneration_End
		   ,Remuneration = cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar)
          
          ,Measure_months = Measure
          ,LT = SUM(uv.LT)
          ,WGT = SUM(uv.WGT)
          ,AVGDURN = SUM(uv.LT) / nullif(SUM(uv.WGT),0)
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','POLICE & EMERGENCY SERVICES',NULL,uv.Measure)
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','POLICE & EMERGENCY SERVICES',NULL,uv.Measure)
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
			and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire','RFS')
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
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
WHERE	  DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 
			and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
			and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other')
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Agency_Group_Rolling_Month_12.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Raw_Data.sql  
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
			,[Group] = rtrim(isnull(sub.[Group],'Miscellaneous'))
			,Team
			,Sub_Category = rtrim(isnull(sub.Sub_Category,'Miscellaneous'))
			,Case_manager
			,Agency = rtrim(isnull(sub.AgencyName,'Miscellaneous'))
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
	
	FROM dbo.TMF_RTW rtw left join TMF_Agencies_Sub_Category sub on rtw.POLICY_NO = sub.POLICY_NO
	WHERE remuneration_End = (SELECT max(remuneration_End) FROM  dbo.TMF_RTW)
		 AND  DATEDIFF(month, Remuneration_Start, Remuneration_End) + 1 =12  
		 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Raw_Data.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current.sql  
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
	WITH temp AS 
	(
		select * 
		from
			(select 0 as month_period
			union all
			select 2 as month_period
			union all
			select 5 as month_period
			union all
			select 11 as month_period) as month_period
			cross join
			(select 13 as Measure_months
			union all
			select 26 as Measure_months
			union all
			select 52 as Measure_months
			union all
			select 78 as Measure_months
			union all
			select 104 as Measure_months) as measure_months		
			cross join
			(
			select distinct rtrim(isnull(sub.AgencyName,'Miscellaneous')) as Agency_Group
					,rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
			from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO 
			where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
			   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
			) as temp_value
	)
	
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
			,rtrim(isnull(sub.AgencyName,'Miscellaneous')) as Agency_Group
			,rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
			,[Target] = sum(LT)/nullif(sum(WGT),0)*100/nullif(dbo.udf_dashboard_TMF_RTW_getTargetAndBase(Remuneration_End,'target','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),rtrim(isnull(sub.Sub_Category,'Miscellaneous')),Measure),0)
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by rtrim(isnull(sub.AgencyName,'Miscellaneous')),rtrim(isnull(sub.Sub_Category,'Miscellaneous')),Measure,Remuneration_Start, Remuneration_End
	
	union all
	select Month_period=case when month_period = 0
							then 1
						 when month_period = 2
							then 3
						 when month_period = 5
							then 6
						 when month_period = 11
							then 12
					end
		  ,[type]='agency'
		  ,Agency_Group
		  ,Team_Sub
		  ,Measure_months
		  ,LT = 0
		  ,WGT = 0
		  ,AVGDURN = 0
		  ,[Target] = 0
	from temp as tmp
	where Measure_months not in (select distinct Measure from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
							where  uv.Remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
							and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) = tmp.month_period
							and sub.AgencyName = tmp.Agency_Group
							and sub.Sub_Category = tmp.Team_Sub)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Current.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous.sql  
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
			,rtrim(isnull(sub.AgencyName,'Miscellaneous')) as Agency_Group
			,rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by rtrim(isnull(sub.AgencyName,'Miscellaneous')),rtrim(isnull(sub.Sub_Category,'Miscellaneous')),Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)		
		
	--Agency Police & Fire & RFS--
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
			,'POLICE & EMERGENCY SERVICES' as Agency_Group
			,rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire','RFS') 

	group by rtrim(isnull(sub.Sub_Category,'Miscellaneous')),Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)		
	
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
			,rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)
		   and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other') 

	group by rtrim(isnull(sub.Sub_Category,'Miscellaneous')),Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)	
		
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
			,rtrim(isnull(sub.[Group],'Miscellaneous')) as Agency_Group
			,rtrim(Team) as Team_Sub
			,Measure as Measure_months
			,sum(LT) as LT,sum(WGT) as WGT
			,sum(LT)/nullif(sum(WGT),0) as AVGDURN 
	from tmf_rtw uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
	where  uv.Remuneration_End = dateadd(mm,-12,(SELECT max(Remuneration_End) FROM  dbo.TMF_RTW))
		   and  DATEDIFF(MM, Remuneration_Start, Remuneration_End) in (0,2,5,11)

	group by rtrim(isnull(sub.[Group],'Miscellaneous')),Team,Measure,DATEDIFF(MM, Remuneration_Start, Remuneration_End)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Sub_Team_Compares_To_Same_Time_Last_Year_Previous.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Team_Sub_Rolling_Month_1.sql  
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
			, rtrim(isnull(sub.[Group],'Miscellaneous')) as Agency_Group
			,[Type] = 'group'
			,uv.Remuneration_Start
			,uv.Remuneration_End
			,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
			,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
			,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',rtrim(isnull(sub.[Group],'Miscellaneous')),uv.Team,uv.Measure)									
			, Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',rtrim(isnull(sub.[Group],'Miscellaneous')),uv.Team,uv.Measure)
						
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY uv.Team, rtrim(isnull(sub.[Group],'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT    rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
		  , rtrim(isnull(sub.AgencyName,'Miscellaneous')) as  Agency_Group
		  ,[Type] = 'agency' 
		  ,uv.Remuneration_Start
		  , uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY rtrim(isnull(sub.Sub_Category,'Miscellaneous')), rtrim(isnull(sub.AgencyName,'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Police & Fire & RFS--
UNION ALL

SELECT    rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
		  , 'POLICE & EMERGENCY SERVICES' as Agency_Group
		  ,[Type] = 'agency' 
		  ,uv.Remuneration_Start
		  , uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','POLICE & EMERGENCY SERVICES',rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','POLICE & EMERGENCY SERVICES',rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	  and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire','RFS')
GROUP BY rtrim(isnull(sub.Sub_Category,'Miscellaneous')),  uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Health & Other--
UNION ALL

SELECT    rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Team_Sub
		  , 'Health & Other' as Agency_Group
		  ,[Type] = 'agency' 
		  ,uv.Remuneration_Start
		  , uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          ,[Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','Health & Other',rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)									
		  ,Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','Health & Other',rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =0 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	  and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other') 
GROUP BY rtrim(isnull(sub.Sub_Category,'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Team_Sub_Rolling_Month_1.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Team_Sub_Rolling_Month_12.sql  
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
		  ,rtrim(isnull(sub.[Group],'Miscellaneous')) as  Agency_Group
		  ,[Type] = 'group'
		  ,uv.Remuneration_Start 
		  ,uv.Remuneration_End
		  ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration        
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','group',rtrim(isnull(sub.[Group],'Miscellaneous')),uv.Team,uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','group',rtrim(isnull(sub.[Group],'Miscellaneous')),uv.Team,uv.Measure)
						
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY uv.Team, rtrim(isnull(sub.[Group],'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

UNION ALL

SELECT    rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as  Team_Sub
		 ,rtrim(isnull(sub.AgencyName,'Miscellaneous')) as  Agency_Group
		 ,[Type] = 'agency' 
		 ,uv.Remuneration_Start
		 , uv.Remuneration_End
		 ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency',rtrim(isnull(sub.AgencyName,'Miscellaneous')),rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
GROUP BY rtrim(isnull(sub.Sub_Category,'Miscellaneous')), rtrim(isnull(sub.AgencyName,'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

--Agency Police & Fire & RFS--
UNION ALL

SELECT    rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as  Team_Sub
		 ,'POLICE & EMERGENCY SERVICES' as  Agency_Group
		 ,[Type] = 'agency' 
		 ,uv.Remuneration_Start
		 , uv.Remuneration_End
		 ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','POLICE & EMERGENCY SERVICES',rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','POLICE & EMERGENCY SERVICES', rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	  and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire','RFS') 
GROUP BY rtrim(isnull(sub.Sub_Category,'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure
--Agency Health & Other--
UNION ALL

SELECT    rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as  Team_Sub
		 ,'Health & Other' as  Agency_Group
		 ,[Type] = 'agency' 
		 ,uv.Remuneration_Start
		 , uv.Remuneration_End
		 ,cast(year(uv.Remuneration_End) AS varchar) 
                      + 'M' + CASE WHEN MONTH(uv.Remuneration_End) <= 9 THEN '0' ELSE '' END + cast(month(uv.Remuneration_End) AS varchar) AS Remuneration
                      
          ,Measure AS Measure_months, SUM(uv.LT) AS LT, SUM(uv.WGT) AS WGT, SUM(uv.LT) / nullif(SUM(uv.WGT),0) AS AVGDURN
          , [Target] = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'target','agency','Health & Other',rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)									
		  , Base = dbo.udf_dashboard_TMF_RTW_getTargetAndBase(uv.Remuneration_End,'base','agency','Health & Other',rtrim(isnull(sub.Sub_Category,'Miscellaneous')),uv.Measure)					 
FROM         dbo.TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
where DATEDIFF(MM, uv.Remuneration_Start, uv.Remuneration_End) =11 and uv.Remuneration_End between DATEADD(DAY, -1, DATEADD(M, -23 + DATEDIFF(M, 0, (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)), 0)) + '23:59' and (SELECT max(Remuneration_End) FROM  dbo.TMF_RTW)
	  and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other') 
GROUP BY rtrim(isnull(sub.Sub_Category,'Miscellaneous')), uv.Remuneration_Start, uv.Remuneration_End, uv.Measure

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_1\uv_TMF_RTW_Team_Sub_Rolling_Month_12.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_AWC_Agency_Group_Summary.sql  
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
SELECT top 1000 EmployerSize_Group = dbo.udf_EML_GetGroupByTeam(Team)
				,[Type]='group'
				,No_Of_Active_Weekly_Claims =
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'group') AND (Unit = dbo.udf_EML_GetGroupByTeam(Team)) AND (Type = 'Actual'))
                ,Projection = 
						  100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML
                            WHERE      (UnitType = 'group') AND (Unit = dbo.udf_EML_GetGroupByTeam(Team)) AND (Type = 'Actual'))
                          /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_EML_AWC_Whole_EML AS uv_EML_AWC_Whole_EML_1
                            WHERE      (UnitType = 'group') AND (Unit = dbo.udf_EML_GetGroupByTeam(Team)) AND (Type = 'Projection')),0)
FROM         dbo.EML_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.EML_AWC AS EML_AWC_1)))
GROUP BY dbo.udf_EML_GetGroupByTeam(Team)
ORDER BY dbo.udf_EML_GetGroupByTeam(Team)

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_AWC_Agency_Group_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_AWC_Team_Sub_Summary.sql  
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
		   ,EmployerSize_Group = dbo.udf_EML_GetGroupByTeam(Team)
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
GROUP BY dbo.udf_EML_GetGroupByTeam(Team), RTRIM(ISNULL(Team, 'Miscellaneous'))
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_AWC_Team_Sub_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_AWC_Weekly_Open.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_EML_AWC_Weekly_Open.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_AWC_Agency_Group_Summary.sql  
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
SELECT top 1000 EmployerSize_Group = dbo.udf_HEM_GetGroupByTeam(Team)
				,[Type]='group'
				,No_Of_Active_Weekly_Claims =
                          (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'group') AND (Unit = dbo.udf_HEM_GetGroupByTeam(Team)) AND (Type = 'Actual'))
                ,Projection = 
						  100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM
                            WHERE      (UnitType = 'group') AND (Unit = dbo.udf_HEM_GetGroupByTeam(Team)) AND (Type = 'Actual'))
                          /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_HEM_AWC_Whole_HEM AS uv_HEM_AWC_Whole_HEM_1
                            WHERE      (UnitType = 'group') AND (Unit = dbo.udf_HEM_GetGroupByTeam(Team)) AND (Type = 'Projection')),0)
FROM         dbo.HEM_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.HEM_AWC AS HEM_AWC_1)))
GROUP BY dbo.udf_HEM_GetGroupByTeam(Team)
ORDER BY dbo.udf_HEM_GetGroupByTeam(Team)

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_AWC_Agency_Group_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_AWC_Team_Sub_Summary.sql  
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
		   ,EmployerSize_Group = dbo.udf_HEM_GetGroupByTeam(Team)
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
GROUP BY dbo.udf_HEM_GetGroupByTeam(Team), RTRIM(ISNULL(Team, 'Miscellaneous'))
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_AWC_Team_Sub_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_AWC_Weekly_Open.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_HEM_AWC_Weekly_Open.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_AWC_Agency_Group_Summary.sql  
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
                            WHERE      (UnitType = 'agency') AND (Unit = RTRIM(ISNULL(AgencyName, 'Miscellaneous'))) AND (Type = 'Actual'))
                ,Projection = 
						100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit = RTRIM(ISNULL(AgencyName, 'Miscellaneous'))) AND (Type = 'Actual'))
						/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'agency') AND (Unit = RTRIM(ISNULL(AgencyName, 'Miscellaneous'))) AND (Type = 'Projection')),0)
                        
FROM         dbo.TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY RTRIM(ISNULL(AgencyName, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(AgencyName, 'Miscellaneous'))

UNION ALL

--Agency Police & Fire & RFS--
SELECT  top 1 Agency_Group = 'POLICE & EMERGENCY SERVICES'
				,[Type]='agency'
                ,No_Of_Active_Weekly_Claims =				
					      (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit in ('Police','Fire','RFS')) AND (Type = 'Actual'))
                ,Projection = 
						100*(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'agency') AND (Unit in ('Police','Fire','RFS')) AND (Type = 'Actual'))
						/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'agency') AND (Unit in ('Police','Fire','RFS')) AND (Type = 'Projection')),0)
                        
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
SELECT top 1000 Agency_Group = dbo.udf_TMF_GetGroupByTeam(Team)
				,[Type]='group'
                ,No_Of_Active_Weekly_Claims =
						(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'group') AND (Unit = dbo.udf_TMF_GetGroupByTeam(Team)) AND (Type = 'Actual'))
                ,Projection =                        
                        100 * (SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF
                            WHERE      (UnitType = 'group') AND (Unit = dbo.udf_TMF_GetGroupByTeam(Team)) AND (Type = 'Actual'))
                        /NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
                            FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
                            WHERE      (UnitType = 'group') AND (Unit = dbo.udf_TMF_GetGroupByTeam(Team)) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY dbo.udf_TMF_GetGroupByTeam(Team)
ORDER BY CASE ISNUMERIC(dbo.udf_TMF_GetGroupByTeam(Team))
			WHEN 1 THEN REPLICATE('0', 100 - LEN(dbo.udf_TMF_GetGroupByTeam(Team))) + dbo.udf_TMF_GetGroupByTeam(Team)
			ELSE dbo.udf_TMF_GetGroupByTeam(Team)
		 END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_AWC_Agency_Group_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_AWC_Team_Sub_Summary.sql  
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
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
						FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
						WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
GROUP BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous')), RTRIM(ISNULL(AgencyName, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))

--Agency Police & Fire & RFS--
UNION ALL
SELECT   top 1000000  
		   [Type] ='agency'
		   ,Agency_Group = 'POLICE & EMERGENCY SERVICES'
		   ,Team_Sub = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))
           ,No_Of_Active_Weekly_Claims =
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
						FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
						WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
           AND RTRIM(AgencyName) in ('Police','Fire','RFS')
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
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
           ,Projection =
				100*
				(SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
					FROM          dbo.uv_TMF_AWC_Whole_TMF
					WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Actual'))
				/NULLIF((SELECT     SUM(No_of_Active_Weekly_Claims) AS Expr1
						FROM          dbo.uv_TMF_AWC_Whole_TMF AS uv_TMF_AWC_Whole_TMF_1
						WHERE      (UnitType = 'sub_category') AND (Unit = RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))) AND (Type = 'Projection')),0)
FROM         dbo.TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
WHERE     (Time_ID >= DATEADD(mm, - 2,
                          (SELECT     MAX(Time_ID) AS Expr1
                            FROM          dbo.TMF_AWC AS TMF_AWC_1)))
           AND RTRIM(AgencyName) in ('Health','Other')	
GROUP BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous')), RTRIM(AgencyName)
ORDER BY RTRIM(ISNULL(Sub_Category, 'Miscellaneous'))

UNION ALL
SELECT  top 1000000   
		   [Type] ='group'
		   ,Agency_Group = dbo.udf_TMF_GetGroupByTeam(Team)
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
GROUP BY dbo.udf_TMF_GetGroupByTeam(Team), RTRIM(ISNULL(Team, 'Miscellaneous'))
ORDER BY RTRIM(ISNULL(Team, 'Miscellaneous'))
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_AWC_Team_Sub_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_AWC_Weekly_Open.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\View\View_2\uv_TMF_AWC_Weekly_Open.sql  
--------------------------------  
---------------------------------------------------------- 
------------------- StoredProcedure 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\ArrangeLevel_Role.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\ArrangeLevel_Role.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\GetUser.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\GetUser.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\PRO_GetUser.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\PRO_GetUser.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\PRO_Internal_Login.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\PRO_Internal_Login.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\PRO_Login.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\PRO_Login.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\Register.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\Register.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\ResetPassword.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\ResetPassword.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\SaveSystemRoles.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\SaveSystemRoles.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\SetScheduleType.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\SetScheduleType.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\SetSubscriptonStatus.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\SetSubscriptonStatus.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\Update_OrganisationRole_Level.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\Update_OrganisationRole_Level.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Detail.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CPR_Detail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CPR_Detail]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Detail]
(
	@System VARCHAR(10)
	,@Type VARCHAR(20)
	,@Value NVARCHAR(256)
	,@SubValue NVARCHAR(256)
	,@SubSubValue NVARCHAR(256)
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
	IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total
	IF OBJECT_ID('tempdb..#claim_all') IS NOT NULL DROP TABLE #claim_all
	IF OBJECT_ID('tempdb..#claim_new_all') IS NOT NULL DROP TABLE #claim_new_all
	IF OBJECT_ID('tempdb..#claim_open_all') IS NOT NULL DROP TABLE #claim_open_all
	IF OBJECT_ID('tempdb..#claim_closure') IS NOT NULL DROP TABLE #claim_closure
	IF OBJECT_ID('tempdb..#claim_re_open') IS NOT NULL DROP TABLE #claim_re_open
	IF OBJECT_ID('tempdb..#claim_re_open_still_open') IS NOT NULL DROP TABLE #claim_re_open_still_open
	IF OBJECT_ID('tempdb..#claim_list') IS NOT NULL DROP TABLE #claim_list
	IF OBJECT_ID('tempdb..#pre_claim_list') IS NOT NULL DROP TABLE #pre_claim_list
	IF OBJECT_ID('tempdb..#reporting_date') IS NOT NULL DROP TABLE #reporting_date
	
	-- Determine the last month period
	DECLARE @LastMonth_Start_Date datetime = DATEADD(m, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0))
	DECLARE @LastMonth_End_Date datetime = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59'
	
	-- Determine last two weeks: Start = last two weeks from yesterday; End = yesterday
	DECLARE @Last2Weeks_Start_Date datetime = DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
	DECLARE @Last2Weeks_End_Date datetime = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	
	DECLARE @IsLastMonthRange bit = 0
	IF DATEDIFF(d, @LastMonth_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @LastMonth_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLastMonthRange = 1
	END
	
	DECLARE @IsLast2WeeksRange bit = 0
	IF DATEDIFF(d, @Last2Weeks_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @Last2Weeks_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLast2WeeksRange = 1
	END
	
	-- Determine period type
	DECLARE @Period_Type int
	IF @IsLastMonthRange = 1
	BEGIN
		SET @Period_Type = 1
	END
	ELSE IF @IsLast2WeeksRange = 1
	BEGIN
		SET @Period_Type = 0
	END
	ELSE IF @IsLastMonthRange = 0 AND @IsLast2WeeksRange = 0
	BEGIN
		SET @Period_Type = -1
	END
	
	-- Append time to @End_Date
	SET @End_Date = DATEADD(dd, DATEDIFF(dd, 0, @End_Date), 0) + '23:59'
	
	-- Prepare data before querying
	
	DECLARE @SQL varchar(MAX)
	
	CREATE TABLE #reporting_date
	(
		Reporting_Date datetime null,
		IsPre bit null
	)
	
	-- Determine filter conditions
	DECLARE @Is_Last_Month bit
	IF @Period_Type = -1
	BEGIN
		SET @Is_Last_Month = 0
		SET @SQL = 'SELECT top 1 Reporting_Date, 0 FROM ' + @System + '_Portfolio
			WHERE CONVERT(datetime, Reporting_Date, 101) 
				>= CONVERT(datetime, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''', 101) order by Reporting_Date'
		
		INSERT INTO #reporting_date
		EXEC(@SQL)
	END
	ELSE
	BEGIN
		SET @Is_Last_Month = @Period_Type
		SET @SQL = 'SELECT MAX(Reporting_Date), 0 FROM ' + @System + '_Portfolio'
				
		INSERT INTO #reporting_date
		EXEC(@SQL)
	END
	
	-- Determine current Reporting date
	DECLARE @Reporting_Date datetime
	SELECT TOP 1 @Reporting_Date = Reporting_Date FROM #reporting_date WHERE IsPre = 0
	
	CREATE TABLE #claim_list
	(
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
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[HoursPerWeek] [numeric](5, 2) NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Rehab_Paid] [float] NULL,
		[IsPreClosed] [bit] NULL,
		[IsPreOpened] [bit] NULL
	)
	
	DECLARE @WHERE_CONS VARCHAR(MAX) = 
		/* Append the filter condition based on @Value */
		case when @Value <> 'all'
				then 
					case when UPPER(@System) = 'TMF'
							then
								case when @Type='agency' 
										then
											case when @Value = 'health@@@other' 
													then ' and rtrim(isnull(sub.AgencyName,''Miscellaneous'')) in (''health'',''other'')'
												when @Value = 'police@@@emergency services'
													then ' and rtrim(isnull(sub.AgencyName,''Miscellaneous'')) in (''police'',''fire'',''rfs'')'
												when @Value like '%_total' 
													then ' '
												else ' and rtrim(isnull(sub.AgencyName,''Miscellaneous'')) = ''' + @Value + ''' '
											end														
									when @Type='group'
										then
											case when @Value like '%_total'
													then ' '
												else ' and dbo.udf_TMF_GetGroupByTeam(Team) = ''' + @Value +''''
											end
									else ''''''
								end
						when UPPER(@System) = 'EML'
							then
								case when @Type='employer_size' 
										then
											case when @Value like '%_total' 
													then ' '
												else ' and [EMPL_SIZE] = ''' + @Value + '''' 
											end
									when @Type='group' 
										then
											case when @Value like '%_total' 
													then ' '
												else ' and dbo.udf_EML_GetGroupByTeam(Team) = ''' + @Value + '''' 
											end
									when @Type='account_manager' 
										then 
											case when @Value like '%_total' 
													then ' '
												else ' and [account_manager] = ''' + @Value + '''' 
											end
									else ''''''
								end
						when UPPER(@System) = 'HEM'
							then
								case when @Type='account_manager' 
										then
											case when @Value like '%_total' 
													then ' '
												else ' and [Account_Manager] = ''' + @Value + '''' 
											end
									when @Type = 'portfolio' 
										then
											case when @Value = 'hotel'
													then ' and ([portfolio] = ''Accommodation'' or [portfolio] = ''Pubs, Taverns and Bars'')'
												when @Value like '%_total' 
													then ' '
												else ' and [portfolio] = ''' + @Value + ''''
											end
									when @Type='group' 
										then
											case when @Value like '%_total' 
													then ' '
												else ' and dbo.udf_HEM_GetGroupByTeam(Team) = ''' + @Value + ''''
											end
									else ''''''
								end
						--WOW system--
						when UPPER(@System) = 'WOW'
							then
								case when @Type='group' 
										then
											case when @Value like '%_total' 
													then ' '
												else ' and dbo.udf_WOW_GetGroupByTeam(Team) = ''' + @Value + '''' 
											end
									--for other views such as division or state
									else ''''''
								end
					end
		end +
		
		/* Append the filter condition based on @SubValue */
		case when @SubValue <> 'all' 
				then
					case when @SubValue like '%_total' 
							then
								case when UPPER(@System) = 'TMF'
									then
										case when @Type='agency' 
												then ' and rtrim(isnull(sub.AgencyName,''Miscellaneous'')) = ''' + @Value + ''''
											when @Type='group' 
												then ' and dbo.udf_TMF_GetGroupByTeam(Team) = ''' + @Value + ''''
											else ''''''
										end
									when UPPER(@System) = 'EML'
										then
											case when @Type='group' 
													then ' and dbo.udf_EML_GetGroupByTeam(Team) = ''' + @Value + ''''
												when @Type='employer_size'
													then ' and [EMPL_SIZE] = ''' + @Value + ''''
												when @Type='account_manager'
													then ' and [account_manager] = ''' + @Value + ''''
												else ''''''
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type='account_manager'
													then ' and [account_manager] = ''' + @Value + ''''
												when @Type = 'portfolio' 
													then ' and [portfolio] = ''' + @Value + ''''
												when @Type='group' 
													then ' and dbo.udf_HEM_GetGroupByTeam(Team) = ''' + @Value + ''''
												else ''''''
											end
									--WOW system--
									when UPPER(@System) = 'WOW'
										then
											case when @Type='group' 
													then ' and dbo.udf_WOW_GetGroupByTeam(Team) = ''' + @Value + ''''
												--for other views such as division or state
												else ''''''
											end
								end
						else
							case when UPPER(@System) = 'TMF'
									then
										case when @Type='agency' 
												then ' and rtrim(isnull(sub.Sub_Category,''Miscellaneous'')) = ''' + @SubValue + ''''
											when @Type='group' 
												then ' and [Team] = ''' + @SubValue + ''''
											else ''''''
										end
								when UPPER(@System) = 'EML'
									then
										case when @Type='group' 
												then ' and [Team] = ''' + @SubValue + ''''
											when @Type='employer_size' or @Type='account_manager'
												then ' and [EMPL_SIZE] = ''' + @SubValue + ''''
											else ''''''
										end
								when UPPER(@System) = 'HEM'
									then
										case when @Type='account_manager' or @Type = 'portfolio' 
												then ' and [EMPL_SIZE] = ''' + @SubValue + '''' 
											when @Type='group' 
												then ' and [Team] = ''' + @SubValue + ''''
											else ''''''
										end
								--WOW system--
								when UPPER(@System) = 'WOW'
									then
										case when @Type='group' 
												then ' and [Team] = ''' + @SubValue + ''''											
											else ''''''
										end
							end
					end
			else ''
		end +
		
		/* Append the filter condition based on @SubSubValue */
		case when @SubSubValue <> 'all' 
				then
					case when @SubSubValue like '%_total' 
							then
								case when UPPER(@System) = 'TMF'
									then
										case when @Type='agency' 
												then ' and rtrim(isnull(sub.Sub_Category,''Miscellaneous'')) = ''' + @SubValue + ''''
											when @Type='group' 
												then ' and [Team] = ''' + @SubValue + ''''
											else ''''''
										end
									when UPPER(@System) = 'EML'
										then
											case when @Type='group' 
													then ' and [Team] = ''' + @SubValue + ''''
												when @Type='employer_size' or @Type='account_manager'
													then ' and [EMPL_SIZE] = ''' + @SubValue + ''''
												else ''''''
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type='account_manager' or @Type = 'portfolio' 
													then ' and [EMPL_SIZE] = ''' + @SubValue + '''' 
												when @Type='group' 
													then ' and [Team] = ''' + @SubValue + ''''
												else ''''''
											end
									--WOW system--
									when UPPER(@System) = 'WOW'
										then
											case when @Type='group' 
													then ' and [Team] = ''' + @SubValue + ''''
												else ''''''
											end
								end
						else ' and [Claims_Officer_Name] = ''' + @SubSubValue + ''''
					end
			else ''
		end
	
	SET @SQL = 'SELECT Value=' + case when UPPER(@System) = 'TMF'
										then
											case when @Type='agency'
													then + 'rtrim(isnull(sub.AgencyName,''Miscellaneous''))'
												when @Type='group'
													then 'dbo.udf_TMF_GetGroupByTeam(Team)'
												else ''''''
											end
									when UPPER(@System) = 'EML'
										then
											case when @Type='employer_size' 
													then '[EMPL_SIZE]' 
												when @Type='group' 
													then 'dbo.udf_EML_GetGroupByTeam(Team)' 
												when @Type='account_manager'
													then '[account_manager]' 
												else ''''''
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type='account_manager' 
													then '[Account_Manager]' 
												when @Type = 'portfolio'
													then '[portfolio]' 
												when @Type='group'
													then 'dbo.udf_HEM_GetGroupByTeam(Team)'
												else ''''''
											end
									--WOW System--
									when UPPER(@System) = 'WOW'
										then
											case when @Type='group'
													then 'dbo.udf_WOW_GetGroupByTeam(Team)'
												else ''''''
											end
								end	+
				',SubValue=' + case when UPPER(@System) = 'TMF'
										then
											case when @Type='agency'
													then 'rtrim(isnull(sub.Sub_Category,''Miscellaneous''))'
												when @Type='group'
													then '[Team]'
												else ''''''
											end
									when UPPER(@System) = 'EML'
										then
											case when @Type='group'
													then '[Team]'
												when @Type='employer_size' or @Type = 'account_manager'
													then '[EMPL_SIZE]'
												else ''''''
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type='account_manager' or @Type = 'portfolio' 
													then '[EMPL_SIZE]' 
												when @Type='group' 
													then '[Team]' 
												else ''''''
											end
									--WOW system--
									when UPPER(@System) = 'WOW'
										then
											case when @Type='group' 
													then '[Team]' 
												else ''''''
											end
								end	+
				',SubValue2=[Claims_Officer_Name]
				,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
				,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
				,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
				,[Med_Cert_Status_This_Week],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid]
				,[Acupuncture_Paid],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
				,[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week],[NCMM_Complete_Action_Due],[NCMM_Prepare_Action_Due]
				,[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[IsPreClosed],[IsPreOpened]' +
					case when UPPER(@System) = 'TMF'
							then 
								case when @Type='agency' 
									then ' FROM TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No'
									else ' FROM TMF_Portfolio'
								end
						when UPPER(@System) = 'EML'
							then ' FROM EML_Portfolio'
						when UPPER(@System) = 'HEM'
							then ' FROM HEM_Portfolio'
						when UPPER(@System) = 'WOW'
							then ' FROM WOW_Portfolio'
					end +
				' WHERE ISNULL(Is_Last_Month, 0)=' + CONVERT(VARCHAR, @Is_Last_Month) +	@WHERE_CONS	+
					' AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date, 120) + ''''
					
	-- Apply the user input filters
	SET @SQL = @SQL + case when @Claim_Liability_Indicator <> 'all' then ' and [Claim_Liability_Indicator_Group] = ''' + @Claim_Liability_Indicator + '''' else '' end
	SET @SQL = @SQL + case when @Psychological_Claims <> 'all' then ' and [Is_Stress] = ''' + @Psychological_Claims + '''' else '' end
	SET @SQL = @SQL + case when @Inactive_Claims <> 'all' then ' and [Is_Inactive_Claims] = ''' + @Inactive_Claims + '''' else '' end
	SET @SQL = @SQL + case when @Medically_Discharged <> 'all' then ' and [Is_Medically_Discharged] = ''' + @Medically_Discharged + '''' else '' end
	SET @SQL = @SQL + case when @Exempt_From_Reform <> 'all' then ' and [Is_Exempt] = ''' + @Exempt_From_Reform + '''' else '' end
	SET @SQL = @SQL + case when @Reactivation <> 'all' then ' and [Is_Reactive] = ''' + @Reactivation + '''' else '' end
	
	INSERT INTO #claim_list
	EXEC(@SQL)
	
	CREATE TABLE #pre_claim_list
	(
		[Claim_No] [varchar](19) NULL,
		[Claim_Closed_Flag] [nchar](1) NULL
	)
	
	DECLARE @Reporting_Date_pre datetime
	
	IF @IsLast2WeeksRange <> 1 and @IsLastMonthRange <> 1
	BEGIN
		SET @SQL = 'SELECT top 1 Reporting_Date, 1 FROM ' + @System + '_Portfolio
					WHERE CONVERT(datetime, Reporting_Date, 101)
						>= CONVERT(datetime, DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''') + ''23:59'', 101) order by Reporting_Date'
				
		INSERT INTO #reporting_date
		EXEC(@SQL)
		
		-- Determine previous Reporting date
		SELECT TOP 1 @Reporting_Date_pre = Reporting_Date FROM #reporting_date WHERE IsPre = 1
		
		SET @SQL = 'SELECT Claim_No, Claim_Closed_Flag ' +
					
					case when UPPER(@System) = 'TMF'
							then 
								case when @Type='agency' 
										then ' FROM TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No'
									else ' FROM TMF_Portfolio'
								end
						when UPPER(@System) = 'EML'
							then ' FROM EML_Portfolio'
						when UPPER(@System) = 'HEM'
							then ' FROM HEM_Portfolio'
						when UPPER(@System) = 'WOW'
							then ' FROM WOW_Portfolio'
					end +
					' WHERE ISNULL(Is_Last_Month,0) = 0 ' +
						' AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date_pre, 120) + ''''
						
		INSERT INTO #pre_claim_list
		EXEC(@SQL)
	END		
	
	-- Drop temp table
	IF OBJECT_ID('tempdb..#reporting_date') IS NOT NULL DROP TABLE #reporting_date
	
	-- NEW CLAIMS
	SELECT *, weeks_since_injury = 0
	INTO #claim_new_all 
	FROM #claim_list
	WHERE ISNULL(Date_Claim_Entered,Date_Claim_Received) between @Start_Date and @End_Date
				
	-- OPEN CLAIMS
	SELECT *, weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0 
	INTO #claim_open_all
	FROM #claim_list
	WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date) 
			and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	-- CLAIM CLOSURES
	-- @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 => use IsPreOpened = 1 condition else => bypass this condition
	SELECT *, weeks_since_injury = 0
	INTO #claim_closure 
	FROM #claim_list cpr
	WHERE Date_Claim_Closed between @Start_Date and @End_Date
		and Claim_Closed_Flag = 'Y'
		and (case when @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 then IsPreOpened else 1 end) = 1
		and (@IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 
			or exists (SELECT [Claim_No] FROM #pre_claim_list cpr_pre
							WHERE cpr_pre.Claim_No = cpr.Claim_No AND cpr_pre.Claim_Closed_Flag = 'N')
			or ISNULL(cpr.Date_Claim_Entered, cpr.date_claim_received) >= @Start_Date)
	
	-- REOPEN CLAIMS
	SELECT *, weeks_since_injury = 0
	INTO #claim_re_open 
	FROM #claim_list
	WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS: STILL OPEN
	-- @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 => use IsPreClosed = 1 condition else => bypass this condition
	SELECT *, weeks_since_injury = 0
	INTO #claim_re_open_still_open
	FROM #claim_list cpr
	WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		and Claim_Closed_Flag <> 'Y'
		and (case when @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 then IsPreClosed else 1 end) = 1
		and (@IsLastMonthRange = 1 or @IsLast2WeeksRange = 1
			or exists (SELECT [Claim_No] FROM #pre_claim_list cpr_pre
							WHERE cpr_pre.Claim_No = cpr.Claim_No AND cpr_pre.Claim_Closed_Flag = 'Y'))
							
	-- Drop temp table
	IF OBJECT_ID('tempdb..#pre_claim_list') IS NOT NULL DROP TABLE #pre_claim_list				
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
				union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
				union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
				union all select *,claim_type='claim_open_all' from #claim_open_all
				union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
				union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
				union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
				union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
				union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
				union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
				union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
				union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
				union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> '' AND NCMM_Complete_Action_Due > @End_Date
				union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> '' 
					AND NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, @End_Date) AND DATEADD(week, 3, @End_Date)
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
				union all select *,claim_type='claim_closure' from #claim_closure
				union all select *,claim_type='claim_re_open' from #claim_re_open
				union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   ) as tmp			   	
			
	-- Drop temp tables
	IF OBJECT_ID('tempdb..#claim_new_all') IS NOT NULL DROP TABLE #claim_new_all
	IF OBJECT_ID('tempdb..#claim_open_all') IS NOT NULL DROP TABLE #claim_open_all
	IF OBJECT_ID('tempdb..#claim_closure') IS NOT NULL DROP TABLE #claim_closure
	IF OBJECT_ID('tempdb..#claim_re_open') IS NOT NULL DROP TABLE #claim_re_open
	IF OBJECT_ID('tempdb..#claim_re_open_still_open') IS NOT NULL DROP TABLE #claim_re_open_still_open
		
	CREATE TABLE #total
	(
		Value nvarchar(150) NULL				
		,Claim_type nvarchar(150) NULL
		,iClaim_Type [float] NULL		
		,ffsd_at_work_15_less [float] NULL
		,ffsd_at_work_15_more [float] NULL
		,ffsd_not_at_work [float] NULL
		,pid [float] NULL
		,totally_unfit [float] NULL
		,therapy_treat [float] NULL
		,d_d [float] NULL
		,med_only [float] NULL
		,lum_sum_in [float] NULL
		,ncmm_this_week [float] NULL
		,ncmm_next_week [float] NULL
		,overall [float] NULL
	)				

	SET @SQL = 'SELECT tmp.Value, Claim_type, tmp.iClaim_Type
					,ffsd_at_work_15_less = (select COUNT(distinct Claim_No) from #claim_all where claim_type = tmp.Claim_Type 
						and  Med_Cert_Status = ''SID'' and Is_Working = 1 and HoursPerWeek <= 15)
						
					,ffsd_at_work_15_more = (select COUNT(distinct Claim_No) from #claim_all where claim_type = tmp.Claim_Type
						and  Med_Cert_Status = ''SID'' and Is_Working = 1 and HoursPerWeek > 15)
						
					,ffsd_not_at_work = (select COUNT(distinct Claim_No) from #claim_all where claim_type = tmp.Claim_Type
						and  Med_Cert_Status = ''SID'' and Is_Working = 0)
						
					,pid = (select COUNT(distinct Claim_No) from #claim_all where claim_type = tmp.Claim_Type
						and  Med_Cert_Status = ''PID'')
						
					,totally_unfit = (select COUNT(distinct Claim_No) from #claim_all where claim_type = tmp.Claim_Type
						and  Med_Cert_Status = ''TU'') 
						
					,therapy_treat=(select COUNT(distinct claim_no) from #claim_all where claim_type = tmp.Claim_Type
						and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Osteopathy_Paid > 0 or Acupuncture_Paid > 0 or Rehab_Paid > 0)) 
					
					,d_d = (select COUNT(distinct Claim_No) from #claim_all where claim_type = tmp.Claim_Type
						and Is_D_D = 1) 
					
					,med_only = (select COUNT(distinct Claim_No) from #claim_all where claim_type = tmp.Claim_Type
						and Is_Medical_Only = 1) 
					
					,lum_sum_in = (select COUNT(distinct claim_no) from #claim_all where claim_type = tmp.Claim_Type
						and (Total_Recoveries <> 0 or Common_Law = 1 or WPI >= 0 or Result_Of_Injury_Code = 3 or Result_Of_Injury_Code = 1 or Is_Industrial_Deafness = 1)) 
					
					,ncmm_this_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type = tmp.Claim_Type
						and NCMM_Actions_This_Week <> '''' and NCMM_Complete_Action_Due > ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')
					
					,ncmm_next_week = (select COUNT(distinct Claim_No) from #claim_all where claim_type = tmp.Claim_Type
						and NCMM_Actions_Next_Week <> ''''
						and NCMM_Prepare_Action_Due BETWEEN ''' + CONVERT(VARCHAR, DATEADD(week, 1, @End_Date), 120) + ''' AND ''' + CONVERT(VARCHAR, DATEADD(week, 3, @End_Date), 120) + ''')
					
					,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type = tmp.Claim_Type)
					FROM
					(
						select * from dbo.uv_PORT_Get_All_Claim_Type
						cross join (select ''' +
										case when @SubSubValue <> 'all' 
												then @SubSubValue
											else 
												case when @SubValue <> 'all'
														then @SubValue
													else @Value
												end
										end + ''' as Value) as tmp_value
					) as tmp'
	
	INSERT INTO #total
	EXEC(@SQL)	

	-- Drop temp tables
	IF OBJECT_ID('tempdb..#claim_all') IS NOT NULL DROP TABLE #claim_all
	IF OBJECT_ID('tempdb..#claim_list') IS NOT NULL DROP TABLE #claim_list
	
	-- Transform returning table structure and get results
	SET @SQL = 'SELECT Value,
						Claim_Type,
						[Type] = tmp_port_type.PORT_Type,
						[Sum] = (select (case when tmp_port_type.PORT_Type = ''ffsd_at_work_15_less''
												then tmp_total_2.ffsd_at_work_15_less
											when tmp_port_type.PORT_Type = ''ffsd_at_work_15_more''
												then tmp_total_2.ffsd_at_work_15_more
											when tmp_port_type.PORT_Type = ''ffsd_not_at_work''
												then tmp_total_2.ffsd_not_at_work
											when tmp_port_type.PORT_Type = ''pid''
												then tmp_total_2.pid
											when tmp_port_type.PORT_Type = ''totally_unfit''
												then tmp_total_2.totally_unfit
											when tmp_port_type.PORT_Type = ''therapy_treat''
												then tmp_total_2.therapy_treat
											when tmp_port_type.PORT_Type = ''d_d''
												then tmp_total_2.d_d
											when tmp_port_type.PORT_Type = ''med_only''
												then tmp_total_2.med_only
											when tmp_port_type.PORT_Type = ''lum_sum_in''
												then tmp_total_2.lum_sum_in
											when tmp_port_type.PORT_Type = ''ncmm_this_week''
												then tmp_total_2.ncmm_this_week
											when tmp_port_type.PORT_Type = ''ncmm_next_week''
												then tmp_total_2.ncmm_next_week
											when tmp_port_type.PORT_Type = ''overall''
												then tmp_total_2.overall
										end)
								from #total tmp_total_2
								where tmp_total_2.[Value] = tmp_total.[Value]
									and tmp_total_2.Claim_Type = tmp_total.Claim_Type)
				FROM #total tmp_total
				CROSS JOIN (SELECT * from dbo.uv_PORT_Get_All_PORT_Type) tmp_port_type
				ORDER BY Value, iClaim_Type, tmp_port_type.iPORT_Type'
				
	-- Get final results	
	EXEC(@SQL)
	
	-- Drop temp table
	IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Detail.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Last_Year_Monthly.sql  
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
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Last_Year_Monthly]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Last_Year_Monthly]
GO
CREATE PROCEDURE [dbo].[usp_CPR_Last_Year_Monthly]
	@System VARCHAR(10),
    @Type VARCHAR (20),
    @Value VARCHAR (256),
    @Primary VARCHAR (256)
AS
BEGIN
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

	SELECT * 
	FROM CPR_Monthly
	WHERE [System] = @System
	AND [Type] = @Type
	AND Value = @Value
	AND [Primary] = @Primary
	AND Start_Date in (SELECT Start_Date FROM temp)
	order by Start_Date, case when ClaimType = 'new_claims' then '1'
							when ClaimType = 'open_claims' then '2'
							else ClaimType end asc
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Last_Year_Monthly.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Monthly.sql  
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
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Monthly]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Monthly]
GO
CREATE PROCEDURE [dbo].[usp_CPR_Monthly]
	@System VARCHAR(10),
	@Start_Date DATETIME,
	@End_Date DATETIME
AS
BEGIN
	IF OBJECT_ID('tempdb..#claim_new_all') IS NOT NULL DROP TABLE #claim_new_all
	IF OBJECT_ID('tempdb..#claim_open_all') IS NOT NULL DROP TABLE #claim_open_all
	IF OBJECT_ID('tempdb..#claim_closure') IS NOT NULL DROP TABLE #claim_closure
	IF OBJECT_ID('tempdb..#claim_list') IS NOT NULL DROP TABLE #claim_list
	IF OBJECT_ID('tempdb..#pre_claim_list') IS NOT NULL DROP TABLE #pre_claim_list
	
	-- PREPARE DATA BEFORE QUERYING
	
	-- Determine the period type
	DECLARE @Period_Type INT = [dbo].udf_GetCPR_PeriodType(@Start_Date, @End_Date)
	
	-- Determine the current reporting date
	DECLARE @Reporting_Date datetime = [dbo].udf_GetCPR_ReportingDate(@System, @Period_Type, @End_Date)
	
	-- Determine the claim list
	SELECT *
	INTO #claim_list
	FROM [dbo].[udf_GetCPR_ClaimList](@System, @Period_Type, @Reporting_Date)
	
	DECLARE @Reporting_Date_pre datetime
	IF @Period_Type = -1
	BEGIN
		-- Determine the previous reporting date
		SET @Reporting_Date_pre = [dbo].udf_GetCPR_ReportingDate_Pre(@System, @Start_Date)
	END
	
	-- Determine the previous claim list
	SELECT *
	INTO #pre_claim_list
	FROM [dbo].[udf_GetCPR_PreClaimList](@System, @Period_Type, @Reporting_Date_pre)
	
	-- NEW CLAIMS
	SELECT [AgencyName],[Sub_Category],[Group],[Team],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claims_Officer_Name],[Claim_No]
	INTO #claim_new_all
	FROM #claim_list
	WHERE ISNULL(Date_Claim_Entered,Date_Claim_Received) between @Start_Date and @End_Date
				
	-- OPEN CLAIMS
	SELECT [AgencyName],[Sub_Category],[Group],[Team],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claims_Officer_Name],[Claim_No]
	INTO #claim_open_all
	FROM #claim_list
	WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date) 
			and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	-- CLAIM CLOSURES
	-- @IsLastMonthRange = 1 => use IsPreOpened = 1 condition else => bypass this condition
	SELECT [AgencyName],[Sub_Category],[Group],[Team],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claims_Officer_Name],[Claim_No]
	INTO #claim_closure 
	FROM #claim_list cpr
	WHERE Date_Claim_Closed between @Start_Date and @End_Date
		and Claim_Closed_Flag = 'Y'
		and (case when @Period_Type != -1 then IsPreOpened else 1 end) = 1
		and (@Period_Type != -1
			or exists (SELECT [Claim_No] FROM #pre_claim_list cpr_pre
							WHERE cpr_pre.Claim_No = cpr.Claim_No AND cpr_pre.Claim_Closed_Flag = 'N')
			or ISNULL(cpr.Date_Claim_Entered, cpr.date_claim_received) >= @Start_Date)
	
	IF UPPER(@System) = 'TMF'
	BEGIN
		--TMF--
		SELECT  [System] = 'TMF'
				,[Type] = 'TMF'
				,[Value] = 'TMF'
				,[Primary] = 'TMF'
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure)
							ELSE 0
						END
		FROM
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
		SELECT  [System] = 'TMF'
				,[Type] = 'agency'
				,[Value] = tmp_value.AgencyName
				,[Primary] = tmp_value.AgencyName
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	AgencyName = tmp_value.AgencyName)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	AgencyName = tmp_value.AgencyName)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	AgencyName = tmp_value.AgencyName)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join
		(
			SELECT DISTINCT AgencyName
				FROM #claim_list
				WHERE AgencyName <> ''
				GROUP BY AgencyName
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Agency--		
		
		UNION ALL
		
		--Group--
		SELECT  [System] = 'TMF'
				,[Type] = 'group'
				,[Value] = tmp_value.[Group]
				,[Primary] = tmp_value.[Group]
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	[Group] = tmp_value.[Group])
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	[Group] = tmp_value.[Group])
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	[Group] = tmp_value.[Group])
							ELSE 0
						END
		from
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join 
		(
			SELECT DISTINCT [Group]
				FROM #claim_list
				WHERE [Group] <> ''
				GROUP BY [Group]
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Group--		
		
		UNION ALL
		
		--Team--
		SELECT  [System] = 'TMF'
				,[Type] = 'team'
				,[Value] = tmp_value.Team
				,[Primary] = tmp_value.[Group]
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join
		(
			SELECT DISTINCT [Group], Team
				FROM #claim_list
				WHERE [Group] <> '' and Team <> ''
				GROUP BY [Group], Team
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Team--		
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		--EML--
		SELECT  [System] = 'EML'
				,[Type] = 'EML'
				,[Value] = 'EML'
				,[Primary] = 'EML'
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		--End EML--		
		
		UNION ALL
		
		--Group--
		SELECT  [System] = 'EML'
				,[Type] = 'group'
				,[Value] = tmp_value.[Group]
				,[Primary] = tmp_value.[Group]
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	[Group] = tmp_value.[Group])
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	[Group] = tmp_value.[Group])
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	[Group] = tmp_value.[Group])
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join 
		(
			SELECT DISTINCT [Group]
				FROM #claim_list
				WHERE [Group] <> ''
				GROUP BY [Group]
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Group--
		
		UNION ALL
		
		--Account manager--
		SELECT  [System] = 'EML'
				,[Type] = 'account_manager'
				,[Value] = tmp_value.Account_Manager
				,[Primary] = tmp_value.Account_Manager
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	Account_Manager = tmp_value.Account_Manager)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	Account_Manager = tmp_value.Account_Manager)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	Account_Manager = tmp_value.Account_Manager)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join
		(
			SELECT DISTINCT Account_Manager
				FROM #claim_list
				WHERE Account_Manager <> ''
				GROUP BY Account_Manager
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Account manager--
		
		UNION ALL
		
		--Team--
		SELECT  [System] = 'EML'
				,[Type] = 'team'
				,[Value] = tmp_value.Team
				,[Primary] = tmp_value.[Group]
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join
		(
			SELECT DISTINCT [Group], Team
				FROM #claim_list
				WHERE [Group] <> '' and Team <> ''
				GROUP BY [Group], Team
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Team--		
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		--HEM--
		SELECT  [System] = 'HEM'
				,[Type] = 'HEM'
				,[Value] = 'HEM'
				,[Primary] = 'HEM'
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure)
							ELSE 0
						END
		FROM
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
		SELECT  [System] = 'HEM'
				,[Type] = 'portfolio'
				,[Value] = tmp_value.Portfolio
				,[Primary] = tmp_value.Portfolio
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	Portfolio = tmp_value.Portfolio)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	Portfolio = tmp_value.Portfolio)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	Portfolio = tmp_value.Portfolio)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join 
		(
			SELECT DISTINCT Portfolio
				FROM #claim_list
				WHERE Portfolio <> ''
				GROUP BY Portfolio
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Portfolio--		
		
		UNION ALL
		
		--Group--
		SELECT  [System] = 'HEM'
				,[Type] = 'group'
				,[Value] = tmp_value.[Group]
				,[Primary] = tmp_value.[Group]
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	[Group] = tmp_value.[Group])
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	[Group] = tmp_value.[Group])
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	[Group] = tmp_value.[Group])
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join 
		(
			SELECT DISTINCT [Group]
				FROM #claim_list
				WHERE [Group] <> ''
				GROUP BY [Group]
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Group--		
		
		UNION ALL
		
		--Team--
		SELECT  [System] = 'HEM'
				,[Type] = 'team'
				,[Value] = tmp_value.Team
				,[Primary] = tmp_value.[Group]
				,uv_ClaimType.ClaimType
				,Month_Year = LEFT(DATENAME(MONTH, @Start_Date), 3) + '- ' + RIGHT(DATENAME(YEAR, @Start_Date), 2)
				,[Start_Date] = @Start_Date
				,[End_Date] = @End_Date
				,No_Of_Port_Claims =
						CASE WHEN uv_ClaimType.ClaimType = 'new_claims'
								THEN
									(SELECT		COUNT(distinct Claim_No)
										FROM	#claim_new_all
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							WHEN uv_ClaimType.ClaimType = 'open_claims'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_open_all
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							WHEN uv_ClaimType.ClaimType = 'claim_closures'
								THEN
									(SELECT     COUNT(distinct Claim_No)
										FROM    #claim_closure
										WHERE	[Group] = tmp_value.[Group]
												and Team = tmp_value.Team)
							ELSE 0
						END
		FROM
		(
			SELECT 'new_claims' as ClaimType
			UNION
			SELECT 'open_claims' as ClaimType
			UNION
			SELECT 'claim_closures' as ClaimType
		) as uv_ClaimType
		cross join
		(
			SELECT DISTINCT [Group], Team
				FROM #claim_list
				WHERE [Group] <> '' and Team <> ''
				GROUP BY [Group], Team
				HAVING COUNT(*) > 0
		) as tmp_value
		--End Team--		
	END
			
	-- Drop temp tables
	IF OBJECT_ID('tempdb..#claim_new_all') IS NOT NULL DROP TABLE #claim_new_all
	IF OBJECT_ID('tempdb..#claim_open_all') IS NOT NULL DROP TABLE #claim_open_all
	IF OBJECT_ID('tempdb..#claim_closure') IS NOT NULL DROP TABLE #claim_closure
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Monthly.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Monthly_GenerateData.sql  
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
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Monthly_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Monthly_GenerateData]
GO
CREATE PROCEDURE [dbo].[usp_CPR_Monthly_GenerateData]
	@Start_Period_Year int = NULL,
	@Start_Period_Month int = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Truncate table first
	TRUNCATE TABLE [dbo].[CPR_Monthly]
	
	IF @Start_Period_Year = NULL OR @Start_Period_Month = NULL
	BEGIN
		-- Default: generate data from last year
		
		SET @Start_Period_Year = YEAR(DATEADD(m, -12, GETDATE()))
		SET @Start_Period_Month = MONTH(GETDATE())
	END
	
	-- Determine period for generating data
	DECLARE @Generate_From datetime = CAST(CAST(@Start_Period_Year as varchar) 
											+ '/' + CAST(@Start_Period_Month as varchar)
											+ '/01' as datetime)
	DECLARE @Generate_To datetime = GETDATE()
	
	DECLARE @iMonths int = DATEDIFF(month, @Generate_From, @Generate_To)
	DECLARE @i int = @iMonths
	
	DECLARE @Start_Date_temp datetime = DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0)
	DECLARE @End_Date_temp datetime = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()) + 1, 0)) + '23:59'
	
	WHILE (@i >= 1)
	BEGIN
		SET @Start_Date_temp = DATEADD(m, -1, @Start_Date_temp)
		SET @End_Date_temp = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @Start_Date_temp) + 1, 0)) + '23:59'
	
		-- INSERT DATA FOR TMF --
		INSERT INTO [dbo].[CPR_Monthly] EXEC [dbo].[usp_CPR_Monthly] 'TMF', @Start_Date_temp, @End_Date_temp
		
		-- INSERT DATA FOR EML --
		INSERT INTO [dbo].[CPR_Monthly] EXEC [dbo].[usp_CPR_Monthly] 'EML', @Start_Date_temp, @End_Date_temp
		
		-- INSERT DATA FOR HEM --
		INSERT INTO [dbo].[CPR_Monthly] EXEC [dbo].[usp_CPR_Monthly] 'HEM', @Start_Date_temp, @End_Date_temp
		
		SET @i = @i - 1
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Monthly_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Raw.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- exec usp_System_CPR_Raw 'EML','group','Wcnsw1','all','all','claim_open_all_overall','2012-10-01','2012-10-31','all','all','all','all','all','all'

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CPR_Raw]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CPR_Raw]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Raw]
(
	@System nvarchar(20)
	,@Type nvarchar(100)
	,@Value nvarchar(100)
	,@SubValue nvarchar(100)
	,@SubSubValue nvarchar(100)
	,@ClaimType nvarchar(100)
	,@Start_Date datetime
	,@End_Date datetime
	,@Claim_Liability_Indicator nvarchar(100)
	,@Psychological_Claims nvarchar(100)
	,@Inactive_Claims nvarchar(10)
	,@Medically_Discharged nvarchar(10)
	,@Exempt_From_Reform nvarchar(100)
	,@Reactivation nvarchar(100)
	,@Claim_No varchar(19) = NULL
)
AS
BEGIN
	IF OBJECT_ID('tempdb..#cpr_preopen') IS NOT NULL DROP TABLE #cpr_preopen
	IF OBJECT_ID('tempdb..#cpr_preclose') IS NOT NULL DROP TABLE #cpr_preclose
		
	-- Determine the last month period
	DECLARE @LastMonth_Start_Date datetime = DATEADD(m, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0))
	DECLARE @LastMonth_End_Date datetime = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59'
	
	-- Determine last two weeks: Start = last two weeks from yesterday; End = yesterday
	DECLARE @Last2Weeks_Start_Date datetime = DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
	DECLARE @Last2Weeks_End_Date datetime = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	
	DECLARE @IsLastMonthRange bit = 0
	IF DATEDIFF(d, @LastMonth_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @LastMonth_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLastMonthRange = 1
	END
	
	DECLARE @IsLast2WeeksRange bit = 0
	IF DATEDIFF(d, @Last2Weeks_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @Last2Weeks_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLast2WeeksRange = 1
	END
	
	-- Determine period type
	DECLARE @Period_Type int
	IF @IsLastMonthRange = 1
	BEGIN
		SET @Period_Type = 1
	END
	ELSE IF @IsLast2WeeksRange = 1
	BEGIN
		SET @Period_Type = 0
	END
	ELSE IF @IsLastMonthRange = 0 AND @IsLast2WeeksRange = 0
	BEGIN
		IF @Claim_No is not null and @Claim_No <> ''
			SET @Period_Type = -2
		ELSE
			SET @Period_Type = -1
	END
	
	-- Prepare data before querying
	
	DECLARE @SQL varchar(MAX)
	DECLARE @SQL1 varchar(MAX)
	
	CREATE TABLE #reporting_date
	(
		Reporting_Date datetime null,
		IsPre bit null
	)
	
	-- Determine filter conditions
	DECLARE @Is_Last_Month bit
	DECLARE @Reporting_Date datetime
	
	IF @Period_Type = -1
	BEGIN
		SET @Is_Last_Month = 0
		SET @SQL1 = 'SELECT top 1 Reporting_Date, 0 FROM ' + @System + '_Portfolio
						WHERE CONVERT(datetime, Reporting_Date, 101)
							>= CONVERT(datetime, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''', 101) order by Reporting_Date'
				
		INSERT INTO #reporting_date
		EXEC(@SQL1)
	END
	ELSE IF @Period_Type = -2
	BEGIN
		SET @Is_Last_Month = 0
		SET @SQL1 = 'SELECT top 1 Reporting_Date, 0 FROM ' + @System + '_Portfolio
						WHERE Claim_No = ''' + @Claim_No + ''' ORDER BY Reporting_Date DESC'
				
		INSERT INTO #reporting_date
		EXEC(@SQL1)
	END
	ELSE
	BEGIN
		SET @Is_Last_Month = @Period_Type
		SET @SQL1 = 'SELECT MAX(Reporting_Date), 0 FROM ' + @System + '_Portfolio'
		
		INSERT INTO #reporting_date
		EXEC(@SQL1)
	END
	
	SELECT TOP 1 @Reporting_Date = Reporting_Date FROM #reporting_date WHERE IsPre = 0
	DECLARE @Reporting_Date_pre datetime
	
	SET @SQL = 'SELECT *
				FROM [dbo].[uv_PORT] cpr 
				WHERE [System] = ''' + @System + ''' ' +
				
				/* Append the filter condition based on specified @Claim_No */
				(case when @Claim_No is not null and @Claim_No <> '' then ' and Claim_No = ''' + @Claim_No + ''' '
						else ''
				end)
				+

				/* Append the filter condition based on @Value */
				(case when UPPER(@System) = 'EML'
						then case when @value <> 'all' and @Type = 'employer_size' then ' and [EMPL_SIZE] = ''' +  @value + ''''
									when @value <> 'all' and @Type = 'group' then ' and [Group] = ''' +  @value + ''''
									when @value <> 'all' and @Type = 'account_manager' then ' and [Account_Manager] = ''' +  @value + ''''
									when @Value = 'all' then ''
									else ''
							end
						else ''
				end)
				+							 
				(case when UPPER(@System) = 'TMF'
						then case when @Value <> 'all' and @Value <> 'health@@@other' and @Value <> 'police@@@emergency services' and @Type = 'agency' then ' and [Agency_Name] = ''' + @Value + ''''
								when @Value <> 'all' and @Type = 'group' then ' and [Group] = ''' + @Value	+ ''''
								when @Value = 'health@@@other' then ' and [Agency_Name] in (''health'',''other'')'
								when @Value = 'police@@@emergency services' then ' and [Agency_Name] in (''police'',''fire'',''rfs'')'
								when @Value = 'all' then ''
								else ''
							end
					else ''
				end)
				+
				(case when UPPER(@System) = 'HEM' 
						then case when @Value <> 'all' and @Value <> 'hotel' and @Type = 'portfolio' then ' and [Portfolio] = ''' + @Value + ''''
								 when @Value <> 'all' and @Type = 'group' then ' and [Group] = ''' + @Value	 + ''''						  
								 when @Value = 'hotel' then ' and [Portfolio] in (''Accommodation'',''Pubs, Taverns and Bars'') '
								 when @Value = 'all' then ''
								else ''
							end
					else ''
				end)
				+
				--WOW system--
				(case when UPPER(@System) = 'WOW'
						then case	when @value <> 'all' and @Type = 'group' then ' and [Group] = ''' +  @value + ''''									
									when @Value = 'all' then ''
									else ''
							end
						else ''
				end)
				+
				
				/* Append the filter condition based on @SubValue */
				(case when @SubValue <> 'all' and @Type = 'group' then ' and [Team] = ''' + @SubValue + ''''
					  when @SubValue <> 'all' and @Type = 'account_manager' then ' and [EMPL_SIZE] = ''' + @SubValue + ''''	
					  when @SubValue <> 'all' and @Type = 'portfolio' then ' and [EMPL_SIZE] = ''' + @SubValue + ''''
					  when @SubValue <> 'all' and @Type = 'group' then ' and [Team] = ''' + @SubValue		+ ''''	
					  when @SubValue <> 'all' and @Type = 'agency' then ' and [Sub_Category] = ''' + @SubValue + ''''
					  when @SubValue = 'all' then ''					 						 
					 else ''
				end) 
				 +
				 
				 /* Append the filter condition based on @SubSubValue */
				(case when @SubSubValue <> 'all' then ' and [Claims_Officer_Name] = ''' + @SubSubValue + ''''
					else ''
				end)

	/* Append the filter condition based on @ClaimType */
	
	SET @SQL = @SQL + (case when @ClaimType like '%med_only'
								then ' and [Is_Medical_Only] = 1'
							when @ClaimType like '%d_d' 
								then ' and [Is_D_D] = 1'
							when @ClaimType like '%lum_sum_in'
								then ' and ([Total_Recoveries] <> 0 or [Common_Law] = 1 or [Result_Of_Injury_Code] = 3 or [Result_Of_Injury_Code] = 1 or ([WPI] >= 0 and [WPI] is not null) or [Is_Industrial_Deafness] = 1)'												
							when @ClaimType like '%totally_unfit'
								then ' and [Med_Cert_Status] = ''TU'''
							when @ClaimType like '%ffsd_at_work_15_less'
								then ' and [Med_Cert_Status] = ''SID'' and Is_Working = 1 and HoursPerWeek <= 15'
							when @ClaimType like '%ffsd_at_work_15_more'
								then ' and [Med_Cert_Status] = ''SID'' And Is_Working = 1 and HoursPerWeek > 15'
							when @ClaimType like '%ffsd_not_at_work'
								then ' and [Med_Cert_Status] = ''SID'' And Is_Working = 0'
							when @ClaimType like '%pid'
								then ' and [Med_Cert_Status] = ''PID'''														
							when @ClaimType like '%therapy_treat'
								then ' and (Physio_Paid > 2000 or Chiro_Paid > 1000 or Massage_Paid > 0 or Acupuncture_Paid > 0 or Osteopathy_Paid > 0 or Rehab_Paid > 0) '													
							when @ClaimType like '%ncmm_this_week'
								 then ' and [NCMM_Actions_This_Week] <> '''' and [NCMM_Complete_Action_Due] > ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
							when @ClaimType like '%ncmm_next_week'
								then ' and [NCMM_Actions_Next_Week] <> ''''
									and [NCMM_Prepare_Action_Due] BETWEEN ''' + CONVERT(VARCHAR, DATEADD(week, 1, @End_Date), 120) + ''' AND ''' + CONVERT(VARCHAR, DATEADD(week, 3, @End_Date), 120) + ''''
							else '' 
						end)
	
	-- Apply the user input filters
	SET @SQL = @SQL + case when @Claim_Liability_Indicator <> 'all' then ' and [Claim_Liability_Indicator_Group] = ''' + @Claim_Liability_Indicator + '''' else '' end
	SET @SQL = @SQL + case when @Psychological_Claims <> 'all' then ' and [Is_Stress] = ''' + @Psychological_Claims + '''' else '' end
	SET @SQL = @SQL + case when @Inactive_Claims <> 'all' then ' and [Is_Inactive_Claims] = ''' + @Inactive_Claims + '''' else '' end
	SET @SQL = @SQL + case when @Medically_Discharged <> 'all' then ' and [Is_Medically_Discharged] = ''' + @Medically_Discharged + '''' else '' end
	SET @SQL = @SQL + case when @Exempt_From_Reform <> 'all' then ' and [Is_Exempt] = ''' + @Exempt_From_Reform + '''' else '' end
	SET @SQL = @SQL + case when @Reactivation <> 'all' then ' and [Is_Reactive] = ''' + @Reactivation + '''' else '' end
						  
	/* Append more filter condition based on @ClaimType */
											  
	IF @ClaimType like 'claim_new%'
	BEGIN
		SET @SQL = @SQL + ' and ISNULL(Date_Claim_Entered,Date_Claim_Received) between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
		
		SET @SQL = @SQL + case when @ClaimType like 'claim_new_nlt%' then ' and[Is_Time_Lost] = 0' 
								when @ClaimType like 'claim_new_lt%' then ' and [Is_Time_Lost] = 1' 
								else ''	 	
							end
	END
	ELSE IF @ClaimType like 'claim_open%'
	BEGIN
		SET @SQL = @SQL + ' AND (Date_Claim_Closed is null or Date_Claim_Closed < '''+ CONVERT(VARCHAR, @End_Date, 120) + ''')
							AND (Date_Claim_Reopened is null or Date_Claim_Reopened < '''+ CONVERT(VARCHAR, @End_Date, 120) + ''') and Claim_Closed_Flag <> ''Y'' '
							+ case when @ClaimType like 'claim_open_0_13%'
										then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 0 and 
												DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 <= 13'
									when @ClaimType like 'claim_open_13_26%'
										then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 13 and 
												DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 <= 26'
									when @ClaimType like 'claim_open_26_52%'
										then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 26 and 
												DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 <= 52'
									when @ClaimType like 'claim_open_52_78%'
										then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 52 and 
												DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 <= 78'
									when @ClaimType like 'claim_open_0_78%'
										then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 0 and 
												DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 <= 78'
									when @ClaimType like 'claim_open_78_130%'
										then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 78 and 
												DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 <= 130'
									when @ClaimType like 'claim_open_gt_130%'
										then ' and [Is_Time_Lost] = 1 and DATEDIFF(DAY, [Date_of_Injury], DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''')) / 7.0 > 130 '
									when @ClaimType like 'claim_open_ncmm_this_week%'
										then ' and [NCMM_Actions_This_Week] <> '''' and NCMM_Complete_Action_Due > ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
									when @ClaimType like 'claim_open_ncmm_next_week%'
										then ' and [NCMM_Actions_Next_Week] <> ''''
											and [NCMM_Prepare_Action_Due] BETWEEN ''' + CONVERT(VARCHAR, DATEADD(week, 1, @End_Date), 120) + ''' AND ''' + CONVERT(VARCHAR, DATEADD(week, 3, @End_Date), 120) + ''''
									when @ClaimType like 'claim_open_nlt%' then ' and  [Is_Time_Lost] = 0'
									when @ClaimType like 'claim_open_acupuncture%' then ' and Acupuncture_Paid > 0'
									when @ClaimType like 'claim_open_chiro%' then ' and [Chiro_Paid] > 1000'
									when @ClaimType like 'claim_open_massage%' then ' and [Massage_Paid] > 0'
									when @ClaimType like 'claim_open_ost%' then ' and [Osteopathy_Paid] > 0'										
									when @ClaimType like 'claim_open_physio%' then ' and [Physio_Paid] > 2000'
									when @ClaimType like 'claim_open_rehab%' then ' and [Rehab_Paid] > 0'
									when @ClaimType like 'claim_open_industrial_deafness%' then ' and Is_Industrial_Deafness = 1'																	
									when @ClaimType like 'claim_open_wpi_all%' then ' and [WPI] > 0 and [WPI] is not null'
									when @ClaimType like 'claim_open_wpi_0_10%' then ' and [WPI] > 0 and [WPI] <= 10 and  [WPI] is not null'
								    when @ClaimType like 'claim_open_wpi_11_14%' then ' and [WPI] >= 11 and [WPI]<= 14'
								    when @ClaimType like 'claim_open_wpi_15_20%' then ' and [WPI] >= 15 and [WPI] <= 20'
								    when @ClaimType like 'claim_open_wpi_21_30%' then ' and [WPI] >= 21 and [WPI] <= 30'
								    when @ClaimType like 'claim_open_wpi_31_more%' then ' and [WPI] >= 31'
									when @ClaimType like 'claim_open_wid%' then ' and Common_Law = 1'
									when @ClaimType like 'claim_open_death_%' then ' and Result_Of_Injury_Code = 1'
									when @ClaimType like 'claim_open_ppd_%' then ' and Result_Of_Injury_Code = 3'
									when @ClaimType like 'claim_open_recovery_%' then ' and Total_Recoveries <> 0'
									else ''
								end
	END
	ELSE IF @ClaimType like 'claim_re_open%'
	BEGIN
		SET @SQL = @SQL + ' and Date_Claim_Reopened between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + ''''
	END
	ELSE IF @ClaimType like 'claim_closure%'
	BEGIN
		SET @SQL = @SQL + ' and Date_Claim_Closed between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + '''
							and Claim_Closed_Flag = ''Y'' '
	END
	ELSE IF @ClaimType like 'claim_still_open%'
	BEGIN
		SET @SQL = @SQL + ' and Date_Claim_Reopened between ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''' and ''' + CONVERT(VARCHAR, @End_Date, 120) + '''
			and Claim_Closed_Flag <> ''Y'' '
	END	
		
	IF @ClaimType like 'claim_closure%'
	BEGIN		
		-- For claim closure
		
		IF @IsLastMonthRange = 1 OR @IsLast2WeeksRange = 1
		BEGIN
			SET @SQL = @SQL + '
				AND ISNULL(Is_Last_Month, 0) =' + CONVERT(VARCHAR, @Is_Last_Month) + '
				AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date, 120) + '''
				AND IsPreOpened = 1 '
		END
		ELSE
		BEGIN
			-- Determine Previous Reporting date								
			SET @SQL1 = 'SELECT top 1 Reporting_Date, 1 FROM ' + @System + '_Portfolio
				WHERE CONVERT(datetime, Reporting_Date, 101)
					>=CONVERT(datetime, DATEADD(DAY, -1,''' + CONVERT(VARCHAR, @Start_Date, 120) + ''') + ''23:59'', 101) order by Reporting_Date'
			
			INSERT INTO #reporting_date
			EXEC(@SQL1)						
			
			SELECT TOP 1 @Reporting_Date_pre = Reporting_Date FROM #reporting_date WHERE IsPre = 1						
			
			-- Create temp table for previous Reporting date
			SELECT [Claim_No]
				INTO #cpr_preopen
				FROM [dbo].[uv_PORT]
				WHERE [System] = @System
					AND ISNULL(Is_Last_Month, 0) = 0
					AND Reporting_Date = CONVERT(VARCHAR, isnull(@Reporting_Date_pre,''), 120)
					AND Claim_Closed_Flag = 'N'
					
			SET @SQL = @SQL + '
				 AND ISNULL(Is_Last_Month, 0) = ' + CONVERT(VARCHAR, @Is_Last_Month) + '
				 AND Reporting_Date = ''' + CONVERT(VARCHAR, isnull(@Reporting_Date,''), 120) + '''
				 AND (EXISTS (SELECT [Claim_No] FROM #cpr_preopen cpr_pre WHERE cpr_pre.Claim_No = cpr.Claim_No)
					OR ISNULL(Date_Claim_Entered, date_claim_received) >= ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''') '
		END
	END
	ELSE IF @ClaimType like 'claim_still_open%'
	BEGIN
		-- For claim reopened - still open
		
		IF @IsLastMonthRange = 1 OR @IsLast2WeeksRange = 1
		BEGIN
			SET @SQL = @SQL + '
				AND ISNULL(Is_Last_Month, 0) = ' + CONVERT(VARCHAR, @Is_Last_Month) + '
				AND Reporting_Date = ''' + CONVERT(VARCHAR, isnull(@Reporting_Date,''), 120) + '''
				AND IsPreClosed = 1 '
		END
		ELSE
		BEGIN
			-- Determine Previous Reporting date								
			SET @SQL1 = 'SELECT top 1 Reporting_Date, 1 FROM ' + @System + '_Portfolio
				WHERE CONVERT(datetime, Reporting_Date, 101)
					>= CONVERT(datetime, DATEADD(DAY, -1,''' + CONVERT(VARCHAR, @Start_Date, 120) + ''') + ''23:59'', 101) order by Reporting_Date'
			
			INSERT INTO #reporting_date
			EXEC(@SQL1)
		
			SELECT TOP 1 @Reporting_Date_pre = Reporting_Date FROM #reporting_date WHERE IsPre = 1
					
			-- Create temp table for previous Reporting date
			SELECT [Claim_No]
				INTO #cpr_preclose
				FROM [dbo].[uv_PORT]
				WHERE [System] = @System
					AND ISNULL(Is_Last_Month, 0) = 0
					AND Reporting_Date = CONVERT(VARCHAR, isnull(@Reporting_Date_pre,''), 120)
					AND Claim_Closed_Flag = 'Y'
				
			SET @SQL = @SQL + '
				AND ISNULL(Is_Last_Month, 0) = ' + CONVERT(VARCHAR, @Is_Last_Month) + '
				AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date, 120) + '''
				AND EXISTS (SELECT [Claim_No] FROM #cpr_preclose cpr_pre WHERE cpr_pre.Claim_No = cpr.Claim_No) '
		END
	END
	ELSE
	BEGIN
		-- For other claim types: return data by Reporting date only
	
		SET @SQL = @SQL + ' AND ISNULL(Is_Last_Month, 0) = ''' + CONVERT(VARCHAR, @Is_Last_Month) + '''
			AND Reporting_Date = ''' + CONVERT(VARCHAR, isnull(@Reporting_Date,''), 120) + ''''
	END	
		
	-- Get final results
	EXEC(@SQL)
		
	/* Drop all temp tables */
	IF OBJECT_ID('tempdb..#cpr_preopen') IS NOT NULL DROP table #cpr_preopen
	IF OBJECT_ID('tempdb..#cpr_preclose') IS NOT NULL DROP table #cpr_preclose	
	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Raw.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CPR_Summary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CPR_Summary]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Summary]
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
	IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total
	IF OBJECT_ID('tempdb..#claim_all') IS NOT NULL DROP TABLE #claim_all
	IF OBJECT_ID('tempdb..#claim_new_all') IS NOT NULL DROP TABLE #claim_new_all
	IF OBJECT_ID('tempdb..#claim_open_all') IS NOT NULL DROP TABLE #claim_open_all
	IF OBJECT_ID('tempdb..#claim_closure') IS NOT NULL DROP TABLE #claim_closure
	IF OBJECT_ID('tempdb..#claim_re_open') IS NOT NULL DROP TABLE #claim_re_open
	IF OBJECT_ID('tempdb..#claim_re_open_still_open') IS NOT NULL DROP TABLE #claim_re_open_still_open
	IF OBJECT_ID('tempdb..#claim_list') IS NOT NULL DROP TABLE #claim_list
	IF OBJECT_ID('tempdb..#pre_claim_list') IS NOT NULL DROP TABLE #pre_claim_list
	IF OBJECT_ID('tempdb..#reporting_date') IS NOT NULL DROP TABLE #reporting_date

	-- Determine the last month period
	DECLARE @LastMonth_Start_Date datetime = DATEADD(m, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0))
	DECLARE @LastMonth_End_Date datetime = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59'
	
	-- Determine last two weeks: Start = last two weeks from yesterday; End = yesterday
	DECLARE @Last2Weeks_Start_Date datetime = DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
	DECLARE @Last2Weeks_End_Date datetime = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	
	DECLARE @IsLastMonthRange bit = 0
	IF DATEDIFF(d, @LastMonth_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @LastMonth_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLastMonthRange = 1
	END
	
	DECLARE @IsLast2WeeksRange bit = 0
	IF DATEDIFF(d, @Last2Weeks_Start_Date, @Start_Date) = 0 AND DATEDIFF(d, @Last2Weeks_End_Date, @End_Date) = 0
	BEGIN
		SET @IsLast2WeeksRange = 1
	END
	
	-- Determine period type
	DECLARE @Period_Type int
	IF @IsLastMonthRange = 1
	BEGIN
		SET @Period_Type = 1
	END
	ELSE IF @IsLast2WeeksRange = 1
	BEGIN
		SET @Period_Type = 0
	END
	ELSE IF @IsLastMonthRange = 0 AND @IsLast2WeeksRange = 0
	BEGIN
		SET @Period_Type = -1
	END
	
	-- Append time to @End_Date
	SET @End_Date = DATEADD(dd, DATEDIFF(dd, 0, @End_Date), 0) + '23:59'
	
	-- Prepare data before querying
	
	DECLARE @SQL varchar(MAX)
	
	CREATE TABLE #reporting_date
	(
		Reporting_Date datetime null,
		IsPre bit null
	)
	
	-- Determine filter conditions
	DECLARE @Is_Last_Month bit
	IF @Period_Type = -1
	BEGIN
		SET @Is_Last_Month = 0
		SET @SQL = 'SELECT top 1 Reporting_Date, 0 FROM ' + @System + '_Portfolio
			WHERE CONVERT(datetime, Reporting_Date, 101) 
				>= CONVERT(datetime, ''' + CONVERT(VARCHAR, @End_Date, 120) + ''', 101) order by Reporting_Date'
		
		INSERT INTO #reporting_date
		EXEC(@SQL)
	END
	ELSE
	BEGIN
		SET @Is_Last_Month = @Period_Type
		SET @SQL = 'SELECT MAX(Reporting_Date), 0 FROM ' + @System + '_Portfolio'
				
		INSERT INTO #reporting_date
		EXEC(@SQL)
	END
	
	-- Determine current Reporting date
	DECLARE @Reporting_Date datetime
	SELECT TOP 1 @Reporting_Date = Reporting_Date FROM #reporting_date WHERE IsPre = 0
	
	CREATE TABLE #claim_list
	(
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
		[Physio_Paid] [float] NULL,
		[Chiro_Paid] [float] NULL,
		[Massage_Paid] [float] NULL,
		[Osteopathy_Paid] [float] NULL,
		[Acupuncture_Paid] [float] NULL,
		[Rehab_Paid] [float] NULL,
		[Is_Industrial_Deafness] [bit] NULL,
		[Is_Stress] [bit] NULL,
		[Is_Inactive_Claims] [bit] NULL,
		[Is_Medically_Discharged] [bit] NULL,
		[Is_Exempt] [bit] NULL,
		[Is_Reactive] [bit] NULL,
		[NCMM_Actions_This_Week] [varchar](256) NULL,
		[NCMM_Actions_Next_Week] [varchar](256) NULL,
		[NCMM_Complete_Action_Due] [datetime] NULL,
		[NCMM_Prepare_Action_Due] [datetime] NULL,
		[IsPreClosed] [bit] NULL,
		[IsPreOpened] [bit] NULL
	)
	
	SET @SQL = 'SELECT Value=' + case when UPPER(@System) = 'TMF'
										then
											case when @Type='agency'
													then + 'rtrim(isnull(sub.AgencyName,''Miscellaneous''))'
												when @Type='group'
													then 'dbo.udf_TMF_GetGroupByTeam(Team)'
												else ''''''
											end
									when UPPER(@System) = 'EML'
										then
											case when @Type='employer_size' 
													then '[EMPL_SIZE]' 
												when @Type='group' 
													then 'dbo.udf_EML_GetGroupByTeam(Team)' 
												when @Type='account_manager'
													then '[account_manager]' 
												else ''''''
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type='account_manager' 
													then '[Account_Manager]' 
												when @Type = 'portfolio'
													then '[portfolio]' 
												when @Type='group'
													then 'dbo.udf_HEM_GetGroupByTeam(Team)'
												else ''''''
											end
									--WOW system
									when UPPER(@System) = 'WOW'
										then
											case when @Type = 'group'
													then 'dbo.udf_HEM_GetGroupByTeam(Team)'
												 --for other views such as Division, State
												 when @Type = 'State'
													then '[dbo].[udf_WOW_GetStateByTeam](Claim_Liability_Indicator_Group)'
												 when @Type = 'division'
													then '[dbo].[udf_WOW_GetDivisionByTeam](Claim_Liability_Indicator_Group)'
											end
								end	+
				',SubValue=' + case when UPPER(@System) = 'TMF'
										then
											case when @Type='agency'
													then 'rtrim(isnull(sub.Sub_Category,''Miscellaneous''))'
												when @Type='group'
													then '[Team]'
												else ''''''
											end
									when UPPER(@System) = 'EML'
										then
											case when @Type='group'
													then '[Team]'
												when @Type='employer_size' or @Type = 'account_manager'
													then '[EMPL_SIZE]'
												else ''''''
											end
									when UPPER(@System) = 'HEM'
										then
											case when @Type='account_manager' or @Type = 'portfolio' 
													then '[EMPL_SIZE]' 
												when @Type='group' 
													then '[Team]' 
												else ''''''
											end
									--WOW system
									when UPPER(@System) = 'WOW'
										then
											case when @Type = 'group'
													then '[Team]'
												 --for other views such as Division, State
												 when @Type = 'State'
													then '[dbo].[udf_WOW_GetStateByTeam](Claim_Liability_Indicator_Group)'
												 when @Type = 'division'
													then '[dbo].[udf_WOW_GetDivisionByTeam](Claim_Liability_Indicator_Group)'
											end
								end	+
				',SubValue2=[Claims_Officer_Name]
				,[Claim_No],[Date_Of_Injury],[Claim_Liability_Indicator_Group],[Is_Time_Lost]
				,[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received]
				,[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries]
				,[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid],[Acupuncture_Paid],[Rehab_Paid]
				,[Is_Industrial_Deafness],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt]
				,[Is_Reactive],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week],[NCMM_Complete_Action_Due],[NCMM_Prepare_Action_Due]
				,[IsPreClosed],[IsPreOpened]' +
					case when UPPER(@System) = 'TMF'
							then 
								case when @Type='agency' 
									then ' FROM TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No'
									else ' FROM TMF_Portfolio'
								end
						when UPPER(@System) = 'EML'
							then ' FROM EML_Portfolio'
						when UPPER(@System) = 'HEM'
							then ' FROM HEM_Portfolio'
						--WOW system--
						when UPPER(@System) = 'WOW'
							then ' FROM WOW_Portfolio'
					end +
				' WHERE ISNULL(Is_Last_Month, 0)=' + CONVERT(VARCHAR, @Is_Last_Month) +
					' AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date, 120) + ''''
					
	-- Apply the user input filters
	SET @SQL = @SQL + case when @Claim_Liability_Indicator <> 'all' then ' and [Claim_Liability_Indicator_Group] = ''' + @Claim_Liability_Indicator + '''' else '' end
	SET @SQL = @SQL + case when @Psychological_Claims <> 'all' then ' and [Is_Stress] = ''' + @Psychological_Claims + '''' else '' end
	SET @SQL = @SQL + case when @Inactive_Claims <> 'all' then ' and [Is_Inactive_Claims] = ''' + @Inactive_Claims + '''' else '' end
	SET @SQL = @SQL + case when @Medically_Discharged <> 'all' then ' and [Is_Medically_Discharged] = ''' + @Medically_Discharged + '''' else '' end
	SET @SQL = @SQL + case when @Exempt_From_Reform <> 'all' then ' and [Is_Exempt] = ''' + @Exempt_From_Reform + '''' else '' end
	SET @SQL = @SQL + case when @Reactivation <> 'all' then ' and [Is_Reactive] = ''' + @Reactivation + '''' else '' end
	
	INSERT INTO #claim_list
	EXEC(@SQL)
	
	CREATE TABLE #pre_claim_list
	(
		[Claim_No] [varchar](19) NULL,
		[Claim_Closed_Flag] [nchar](1) NULL
	)
	
	DECLARE @Reporting_Date_pre datetime
	
	IF @IsLast2WeeksRange <> 1 and @IsLastMonthRange <> 1
	BEGIN
		SET @SQL = 'SELECT top 1 Reporting_Date, 1 FROM ' + @System + '_Portfolio
					WHERE CONVERT(datetime, Reporting_Date, 101)
						>= CONVERT(datetime, DATEADD(DAY, -1, ''' + CONVERT(VARCHAR, @Start_Date, 120) + ''') + ''23:59'', 101) order by Reporting_Date'
				
		INSERT INTO #reporting_date
		EXEC(@SQL)
		
		-- Determine previous Reporting date
		SELECT TOP 1 @Reporting_Date_pre = Reporting_Date FROM #reporting_date WHERE IsPre = 1
		
		SET @SQL = 'SELECT Claim_No, Claim_Closed_Flag
					FROM ' + @System + '_Portfolio
					WHERE ISNULL(Is_Last_Month,0) = 0
						AND Reporting_Date = ''' + CONVERT(VARCHAR, @Reporting_Date_pre, 120) + ''''
						
		INSERT INTO #pre_claim_list
		EXEC(@SQL)
	END
	
	-- Drop temp table
	IF OBJECT_ID('tempdb..#reporting_date') IS NOT NULL DROP TABLE #reporting_date
	
	-- NEW CLAIMS
	SELECT *, weeks_since_injury = 0
	INTO #claim_new_all 
	FROM #claim_list
	WHERE ISNULL(Date_Claim_Entered,Date_Claim_Received) between @Start_Date and @End_Date
			  
	-- OPEN CLAIMS
	SELECT *, weeks_since_injury = DATEDIFF(DAY, Date_of_Injury, DATEADD(DAY, -1, @End_Date)) / 7.0 
	INTO #claim_open_all
	FROM #claim_list
	WHERE (Date_Claim_Closed is null or Date_Claim_Closed < @End_Date) 
			and (Date_Claim_Reopened is null or Date_Claim_Reopened < @End_Date) and Claim_Closed_Flag <> 'Y'
	
	-- CLAIM CLOSURES
	-- @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 => use IsPreOpened = 1 condition else => bypass this condition
	SELECT *, weeks_since_injury = 0
	INTO #claim_closure 
	FROM #claim_list cpr
	WHERE Date_Claim_Closed between @Start_Date and @End_Date
		and Claim_Closed_Flag = 'Y'
		and (case when @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 then IsPreOpened else 1 end) = 1
		and (@IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 
			or exists (SELECT [Claim_No] FROM #pre_claim_list cpr_pre
							WHERE cpr_pre.Claim_No = cpr.Claim_No AND cpr_pre.Claim_Closed_Flag = 'N')
			or ISNULL(cpr.Date_Claim_Entered, cpr.date_claim_received) >= @Start_Date)
	
	-- REOPEN CLAIMS
	SELECT *, weeks_since_injury = 0
	INTO #claim_re_open 
	FROM #claim_list
	WHERE Date_Claim_Reopened between @Start_Date and @End_Date
	
	-- REOPEN CLAIMS: STILL OPEN
	-- @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 => use IsPreClosed = 1 condition else => bypass this condition
	SELECT *, weeks_since_injury = 0
	INTO #claim_re_open_still_open
	FROM #claim_list cpr
	WHERE Date_Claim_Reopened between @Start_Date and @End_Date
		and Claim_Closed_Flag <> 'Y'
		and (case when @IsLastMonthRange = 1 or @IsLast2WeeksRange = 1 then IsPreClosed else 1 end) = 1
		and (@IsLastMonthRange = 1 or @IsLast2WeeksRange = 1
			or exists (SELECT [Claim_No] FROM #pre_claim_list cpr_pre
							WHERE cpr_pre.Claim_No = cpr.Claim_No AND cpr_pre.Claim_Closed_Flag = 'Y'))
									
	-- Drop temp table
	IF OBJECT_ID('tempdb..#pre_claim_list') IS NOT NULL DROP TABLE #pre_claim_list
	
	SELECT *
	INTO #claim_all
	FROM (select *,claim_type='claim_new_all' from #claim_new_all
				union all select *,claim_type='claim_new_lt' from #claim_new_all where is_Time_Lost=1
				union all select *,claim_type='claim_new_nlt' from #claim_new_all where is_Time_Lost=0
				union all select *,claim_type='claim_open_all' from #claim_open_all
				union all select *,claim_type='claim_open_0_13' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 13
				union all select *,claim_type='claim_open_13_26' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 13 and weeks_since_injury <= 26
				union all select *,claim_type='claim_open_26_52' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 26 and weeks_since_injury <= 52
				union all select *,claim_type='claim_open_52_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 52 and weeks_since_injury <= 78
				union all select *,claim_type='claim_open_0_78' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 0 and weeks_since_injury <= 78
				union all select *,claim_type='claim_open_78_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 78 and weeks_since_injury <= 130
				union all select *,claim_type='claim_open_gt_130' from #claim_open_all WHERE Is_Time_Lost = 1 and weeks_since_injury > 130
				union all select *,claim_type='claim_open_nlt' from #claim_open_all where is_Time_Lost=0
				union all select *,claim_type='claim_open_ncmm_this_week' from #claim_open_all WHERE NCMM_Actions_This_Week <> '' AND NCMM_Complete_Action_Due > @End_Date
				union all select *,claim_type='claim_open_ncmm_next_week' from #claim_open_all WHERE NCMM_Actions_Next_Week <> ''
					AND NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, @End_Date) AND DATEADD(week, 3, @End_Date)
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
				union all select *,claim_type='claim_closure' from #claim_closure
				union all select *,claim_type='claim_re_open' from #claim_re_open
				union all select *,claim_type='claim_still_open' from #claim_re_open_still_open
			   ) as tmp
			
	-- Drop temp tables
	IF OBJECT_ID('tempdb..#claim_new_all') IS NOT NULL DROP TABLE #claim_new_all
	IF OBJECT_ID('tempdb..#claim_open_all') IS NOT NULL DROP TABLE #claim_open_all
	IF OBJECT_ID('tempdb..#claim_closure') IS NOT NULL DROP TABLE #claim_closure
	IF OBJECT_ID('tempdb..#claim_re_open') IS NOT NULL DROP TABLE #claim_re_open
	IF OBJECT_ID('tempdb..#claim_re_open_still_open') IS NOT NULL DROP TABLE #claim_re_open_still_open
	
	CREATE TABLE #total
	(
		[Value] [varchar](256) NULL,
		[Claim_type] [varchar](30) NULL,
		[iClaim_Type] [int] NULL,
		[overall] [int] NULL
	)
	
	SET @SQL = 'SELECT  tmp.Value,Claim_type, tmp.iClaim_Type
					,overall = (select COUNT(distinct Claim_No) from #claim_all where claim_type = tmp.Claim_Type' +
					case when @Value = 'all'
							then ' and [Value]=tmp.Value)'
						else (case when @SubValue = 'all'
									then ' and [Value]=''' + @Value + ''' and [SubValue]=tmp.Value)'
								else ' and [Value]=''' + @Value + ''' and [SubValue]=''' + @SubValue + ''' and [SubValue2]=tmp.Value)'
							end)
					end + '
				FROM
				(
					select * from dbo.uv_PORT_Get_All_Claim_Type
					cross join (select distinct' +
									case when @Value = 'all' 
											then ' Value'
										else (case when @SubValue = 'all'
													then ' SubValue as Value'
												else ' SubValue2 as Value'
											end)
									end + '
									from #claim_list
									where' +
									case when @Value = 'all' 
											then ' Value <> '''''
										else (case when @SubValue = 'all'
													then ' Value=''' + @Value + ''' and SubValue <> '''''
												else ' Value=''' + @Value + ''' and SubValue=''' + @SubValue + ''' and SubValue2 <> '''''
											end)
									end + '
									group by' + case when @Value = 'all' 
														then ' Value'
													else (case when @SubValue = 'all'
																then ' SubValue'
															else ' SubValue2'
														end)
												end + '
									having COUNT(*) > 0
									union
									select ''Miscellaneous'') as tmp_value
				) as tmp'
	
	INSERT INTO #total
	EXEC(@SQL)
	
	/* Clean data with zero value for all claim types */
	DELETE FROM #total WHERE Value not in (SELECT Value FROM #total
												GROUP BY Value
												HAVING SUM(overall) > 0)
	
	-- Drop temp tables
	IF OBJECT_ID('tempdb..#claim_all') IS NOT NULL DROP TABLE #claim_all
	IF OBJECT_ID('tempdb..#claim_list') IS NOT NULL DROP TABLE #claim_list
	
	IF @Value = 'all'
	BEGIN
		-- Append Total & Grouping values
	
		IF UPPER(@System) = 'TMF'
		BEGIN
			-- TMF
			INSERT INTO #total
			SELECT Value = 'TMF_total', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			GROUP BY Claim_Type, iClaim_Type
			
			-- Grouping Value: Health & Other	
			INSERT INTO #total
			SELECT Value = 'HEALTH & OTHER', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			WHERE Value = 'Health' or Value = 'Other'
			GROUP BY Claim_Type, iClaim_Type
			
			-- Grouping Value: Police & Emergency Services
			INSERT INTO #total
			SELECT Value = 'POLICE & EMERGENCY SERVICES', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			WHERE Value = 'Police' or Value = 'Fire' or Value = 'RFS'
			GROUP BY Claim_Type, iClaim_Type
		END
		ELSE IF UPPER(@System) = 'EML'
		BEGIN
			-- WCNSW	
			INSERT INTO #total
			SELECT Value = 'WCNSW_total', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			GROUP BY Claim_Type, iClaim_Type
		END
		ELSE IF UPPER(@System) = 'HEM'
		BEGIN
			-- Hospitality	
			INSERT INTO #total
			SELECT Value = 'Hospitality_total', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			GROUP BY Claim_Type, iClaim_Type
			
			-- Grouping Value: Hotel	
			INSERT INTO #total
			SELECT Value = 'Hotel', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			WHERE Value = 'Accommodation' or Value = 'Pubs, Taverns and Bars'
			GROUP BY Claim_Type, iClaim_Type
		END
		ELSE IF UPPER(@System) = 'WOW'
		BEGIN
			-- WCNSW	
			INSERT INTO #total
			SELECT Value = 'WOW_total', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			GROUP BY Claim_Type, iClaim_Type
		END
	END
	ELSE
	BEGIN
		IF @SubValue = 'all'
		BEGIN
			-- Total
			INSERT INTO #total
			SELECT Value = @Value + '_total', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			GROUP BY Claim_Type, iClaim_Type
		END
		ELSE
		BEGIN
			-- Total
			INSERT INTO #total
			SELECT Value = @SubValue + '_total', Claim_Type, iClaim_Type, SUM(overall) as overall
			FROM #total
			GROUP BY Claim_Type, iClaim_Type
		END
	END
	
	-- Transform returning table structure and get results
	SET @SQL = 'SELECT Value,
						Claim_Type,
						[Sum] = (select tmp_total_2.overall
									from #total tmp_total_2
									where tmp_total_2.[Value] = tmp_total.[Value]
										and tmp_total_2.Claim_Type = tmp_total.Claim_Type)
				FROM #total tmp_total
				ORDER BY Value, iClaim_Type'
	
	-- Get final results
	EXEC(@SQL)
	
	-- Drop temp table
	IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Week_Month_Summary.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Week_Month_Summary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Week_Month_Summary]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Week_Month_Summary]
(
	@System VARCHAR(10)			-- TMF, EML, HEM
	,@Type VARCHAR(20)
	,@PeriodType VARCHAR(20)	-- last_two_weeks, last_month
)
AS
BEGIN
	DECLARE @Start_Date datetime
	DECLARE @End_Date datetime

	IF LOWER(RTRIM(@PeriodType)) = 'last_month'
	BEGIN
		-- Last month
		SET @Start_Date = DATEADD(m, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0))
		SET @End_Date = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59'
	END
	ELSE
	BEGIN
		-- default period: Last two weeks: Start = last two weeks from yesterday; End = yesterday
		SET @Start_Date = DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
		SET @End_Date = DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))) + '23:59'
	END

	EXEC usp_CPR_Summary @System ,@Type,'all','all',@Start_Date,@End_Date,'all','all','all','all','all','all'
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_CPR_Week_Month_Summary.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_DART_Index.sql  
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
	--Print ' Need to delete current index first if change mapping'
	------------------------ DROP INDEXES FIRST --------------------
	--DECLARE @qry nvarchar(max);
	--SELECT @qry = 
	--(SELECT  'DROP INDEX ' + idx.name + ' ON ' + OBJECT_NAME(ID) + '; '
	--FROM  sysindexes idx
	--WHERE   idx.Name IS NOT null and idx.Name like 'idx_%'
	--FOR XML PATH(''));
	--EXEC sp_executesql @qry

	-------------------------------------- CPR INDEXES --------------------------------------
	--- EML ---	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_Portfolio_Reporting_Date')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_Portfolio_Reporting_Date] ON [dbo].[EML_Portfolio] 
		(
			[Reporting_Date] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_Portfolio_RAW_Data')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_Portfolio_RAW_Data] ON [dbo].[EML_Portfolio]
		(
			[Reporting_Date] ASC,
			[Med_Cert_Status_This_Week] ASC,
			[Id] ASC,
			[Team] ASC,
			[Case_Manager] ASC,
			[EMPL_SIZE] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ([Policy_No],
		[Portfolio],
		[Claim_No],
		[WIC_Code],
		[Company_Name],
		[Worker_Name],
		[Employee_Number],
		[Worker_Phone_Number],
		[Claims_Officer_Name],
		[Date_Of_Birth],
		[Date_Of_Injury],
		[Date_Of_Notification],
		[Notification_Lag],
		[Entered_Lag],
		[Claim_Liability_Indicator_Group],
		[Investigation_Incurred],
		[Total_Paid],
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
		[Create_Date],
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
		[Action_Required],
		[RTW_Impacting],
		[Weeks_In],
		[Weeks_Band],
		[Hindsight],
		[Active_Weekly],
		[Active_Medical],
		[Cost_Code],
		[Cost_Code2],
		[CC_Injury],
		[CC_Current],
		[Capacity],
		[Entitlement_Weeks],
		[Med_Cert_Status_Prev_1_Week],
		[Med_Cert_Status_Prev_2_Week],
		[Med_Cert_Status_Prev_3_Week],
		[Med_Cert_Status_Prev_4_Week],
		[Is_Last_Month]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	--- TMF ---	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_Agencies_Sub_Category_PolicyNo')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_Agencies_Sub_Category_PolicyNo] ON [dbo].[TMF_Agencies_Sub_Category] 
		(
			[policy_no] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_Portfolio_PolicyNo')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_Portfolio_PolicyNo] ON [dbo].[TMF_Portfolio] 
		(
			[policy_no] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_Portfolio_Reporting_Date')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_Portfolio_Reporting_Date] ON [dbo].[TMF_Portfolio] 
		(
			[Reporting_Date] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_Portfolio_RAW_Data')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_Portfolio_RAW_Data] ON [dbo].[TMF_Portfolio]
		(
			[Reporting_Date] ASC,
			[Med_Cert_Status_This_Week] ASC,
			[Id] ASC,
			[Team] ASC,
			[Case_Manager] ASC,
			[EMPL_SIZE] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ([Policy_No],
		[Portfolio],
		[Claim_No],
		[WIC_Code],
		[Company_Name],
		[Worker_Name],
		[Employee_Number],
		[Worker_Phone_Number],
		[Claims_Officer_Name],
		[Date_Of_Birth],
		[Date_Of_Injury],
		[Date_Of_Notification],
		[Notification_Lag],
		[Entered_Lag],
		[Claim_Liability_Indicator_Group],
		[Investigation_Incurred],
		[Total_Paid],
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
		[Create_Date],
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
		[Action_Required],
		[RTW_Impacting],
		[Weeks_In],
		[Weeks_Band],
		[Hindsight],
		[Active_Weekly],
		[Active_Medical],
		[Cost_Code],
		[Cost_Code2],
		[CC_Injury],
		[CC_Current],
		[Capacity],
		[Entitlement_Weeks],
		[Med_Cert_Status_Prev_1_Week],
		[Med_Cert_Status_Prev_2_Week],
		[Med_Cert_Status_Prev_3_Week],
		[Med_Cert_Status_Prev_4_Week],
		[Is_Last_Month]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
		
	--- HEM ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_Portfolio_Reporting_Date')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_Portfolio_Reporting_Date] ON [dbo].[HEM_Portfolio] 
		(
			[Reporting_Date] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_Portfolio_RAW_Data') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_Portfolio_RAW_Data] ON [dbo].[HEM_Portfolio] 
		(
			[Reporting_Date] ASC,
			[Med_Cert_Status_This_Week] ASC,
			[Id] ASC,
			[Team] ASC,
			[Case_Manager] ASC,
			[EMPL_SIZE] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ([Policy_No],
		[Portfolio],
		[Claim_No],
		[WIC_Code],
		[Company_Name],
		[Worker_Name],
		[Employee_Number],
		[Worker_Phone_Number],
		[Claims_Officer_Name],
		[Date_Of_Birth],
		[Date_Of_Injury],
		[Date_Of_Notification],
		[Notification_Lag],
		[Entered_Lag],
		[Claim_Liability_Indicator_Group],
		[Investigation_Incurred],
		[Total_Paid],
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
		[Create_Date],
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
		[Action_Required],
		[RTW_Impacting],
		[Weeks_In],
		[Weeks_Band],
		[Hindsight],
		[Active_Weekly],
		[Active_Medical],
		[Cost_Code],
		[Cost_Code2],
		[CC_Injury],
		[CC_Current],
		[Capacity],
		[Entitlement_Weeks],
		[Med_Cert_Status_Prev_1_Week],
		[Med_Cert_Status_Prev_2_Week],
		[Med_Cert_Status_Prev_3_Week],
		[Med_Cert_Status_Prev_4_Week],
		[Is_Last_Month]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	-------------------------------------- RTW INDEXES --------------------------------------
	--- EML ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Measure') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Measure] ON [dbo].[EML_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC
		)
		INCLUDE ( [LT],
		[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Measure_Include_Team') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Measure_Include_Team] ON [dbo].[EML_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC
		)
		INCLUDE ( [Team],
		[LT],
		[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Measure_EMPL') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Measure_EMPL] ON [dbo].[EML_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC,
			[EMPL_SIZE] ASC
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
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Id_Measure_Team_EMPL_Acc') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Id_Measure_Team_EMPL_Acc] ON [dbo].[EML_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Id] ASC,
			[Measure] ASC,
			[Team] ASC,
			[EMPL_SIZE] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [LT],
		[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	--- TMF ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_POLICY_NO_RS_Measure') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_POLICY_NO_RS_Measure] ON [dbo].[TMF_RTW] 
		(
			[Remuneration_End] ASC,
			[POLICY_NO] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC
		)
		INCLUDE ( [LT],[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_Id_POLICY_NO_RS_Measure_Team') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_Id_POLICY_NO_RS_Measure_Team] ON [dbo].[TMF_RTW]
		(
			[Remuneration_End] ASC,
			[Id] ASC,
			[POLICY_NO] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC,
			[Team] ASC
		)
		INCLUDE ( [LT],[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
		
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_Measure_RS_POLICY_NO')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_Measure_RS_POLICY_NO] ON [dbo].[TMF_RTW] 
		(
			[Remuneration_End] ASC,
			[Measure] ASC,
			[Remuneration_Start] ASC,
			[POLICY_NO] ASC
		)
		INCLUDE ( [LT],[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	--- HEM ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_Raw_Data')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_Raw_Data] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC,
			[Id] ASC
		)
		INCLUDE ( [Remuneration_Start],
		[Team],
		[Case_manager],
		[Claim_no],
		[DTE_OF_INJURY],
		[POLICY_NO],
		[LT],
		[WGT],
		[EMPL_SIZE],
		[Weeks_paid],
		[Measure],
		[Cert_Type],
		[Med_cert_From],
		[Med_cert_To],
		[Account_Manager],
		[Cell_no],
		[Portfolio],
		[Stress],
		[Liability_Status],
		[cost_code],
		[cost_code2],
		[Claim_Closed_flag]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC
		)
		INCLUDE ( [LT],[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Include_Team') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Include_Team] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC
		)
		INCLUDE ( [Team],
		[LT],
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
		INCLUDE ( [LT],[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
		
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Port') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Port] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC,
			[Portfolio] ASC
		)
		INCLUDE ( [LT],[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Acc_EMPL') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Acc_EMPL] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC,
			[Account_Manager] ASC,
			[EMPL_SIZE] ASC
		)
		INCLUDE ( [LT],
		[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Port_EMPL') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Port_EMPL] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC,
			[Portfolio] ASC,
			[EMPL_SIZE] ASC
		)
		INCLUDE ( [LT],
		[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	-------------------------------------- AWC INDEXES --------------------------------------
	--- EML ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Claim_no_Time_ID') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Claim_no_Time_ID] ON [dbo].[EML_AWC] 
		(
			[Claim_no] ASC,
			[Time_ID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Team') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Team] ON [dbo].[EML_AWC] 
		(
			[Team] ASC
		)
		INCLUDE ( [EMPL_SIZE],
		[Account_Manager]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID] ON [dbo].[EML_AWC] 
		(
			[Time_ID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Claim_no_Time_ID_Acc') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Claim_no_Time_ID_Acc] ON [dbo].[EML_AWC] 
		(
			[Claim_no] ASC,
			[Time_ID] ASC,
			[Account_Manager] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Team_Claim_no') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Team_Claim_no] ON [dbo].[EML_AWC] 
		(
			[Time_ID] ASC,
			[Team] ASC,
			[Claim_no] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_no_Include_EMPL')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_no_Include_EMPL] ON [dbo].[EML_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_no_Include_Team')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_no_Include_Team] ON [dbo].[EML_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC
		)
		INCLUDE ( [Team]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_no_Acc') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_no_Acc] ON [dbo].[EML_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_no_Team_Acc') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_no_Team_Acc] ON [dbo].[EML_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Team] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Acc_Time_ID_Claim_no_Team') 	
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Acc_Time_ID_Claim_no_Team] ON [dbo].[EML_AWC] 
		(
			[Account_Manager] ASC,
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Team] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Team_Time_ID_Claim_no_Acc') 	
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Team_Time_ID_Claim_no_Acc] ON [dbo].[EML_AWC] 
		(
			[Team] ASC,
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Projections_Unit_Type_Type') 	
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Projections_Unit_Type_Type] ON [dbo].[EML_AWC_Projections] 
		(
			[Unit_Type] ASC,
			[Type] ASC
		)
		INCLUDE ( [Unit_Name],
		[Time_Id],
		[Projection]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
		
	--- TMF ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_POLICY_NO_Team')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_POLICY_NO_Team] ON [dbo].[TMF_AWC] 
		(
			[POLICY_NO] ASC,
			Team ASC
		)
		WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Time_ID')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Time_ID] ON [dbo].[TMF_AWC]
		(
			[Time_ID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Claim_no_Time_ID_Team')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Claim_no_Time_ID_Team] ON [dbo].[TMF_AWC]
		(
			[Claim_no] ASC,
			[Time_ID] ASC,
			Team ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Claim_no_Time_ID')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Claim_no_Time_ID] ON [dbo].[TMF_AWC] 
		(
			[Claim_no] ASC,
			[Time_ID] ASC
		)
		INCLUDE ( Team,[Date_of_Injury],POLICY_NO) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Time_ID_Claim_no_Team')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Time_ID_Claim_no_Team] ON [dbo].[TMF_AWC]
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Team] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Time_ID_POLICY_NO_Claim_no')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Time_ID_POLICY_NO_Claim_no] ON [dbo].[TMF_AWC] 
		(
			[Time_ID] ASC,
			[POLICY_NO] ASC,
			[Claim_no] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Projections_Type_Unit_Type')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Projections_Type_Unit_Type] ON [dbo].[TMF_AWC_Projections] 
		(
			[Type] ASC,
			[Unit_Type] ASC
		)
		INCLUDE ( [Unit_Name],
		[Time_Id],
		[Projection]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
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

	--- HEM ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Time_ID')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Time_ID] ON [dbo].[HEM_AWC] 
		(
			[Claim_no] ASC,
			[Time_ID] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[Account_Manager]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Time_ID_Acc') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Time_ID_Acc] ON [dbo].[HEM_AWC] 
		(
			[Claim_no] ASC,
			[Time_ID] ASC,
			[Account_Manager] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Team_Time_ID') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Team_Time_ID] ON [dbo].[HEM_AWC] 
		(
			[Claim_no] ASC,
			[Team] ASC,
			[Time_ID] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Port_Time_ID') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Port_Time_ID] ON [dbo].[HEM_AWC] 
		(
			[Claim_no] ASC,
			[Portfolio] ASC,
			[Time_ID] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Port_Time_ID_Include_EMPL') 
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Port_Time_ID_Include_EMPL] ON [dbo].[HEM_AWC] 
		(
			[Claim_no] ASC,
			[Portfolio] ASC,
			[Time_ID] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Team') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Team] ON [dbo].[HEM_AWC] 
		(
			[Team] ASC
		)
		INCLUDE ( [EMPL_SIZE],
		[Account_Manager],
		[Portfolio]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID] ON [dbo].[HEM_AWC] 
		(
			[Time_ID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_no_Acc') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_no_Acc] ON [dbo].[HEM_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Account_Manager] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_no_Acc_Include') 
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_no_Acc_Include] ON [dbo].[HEM_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_no_Port') 	
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_no_Port] ON [dbo].[HEM_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Portfolio] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_no_Port_Include_EMPL') 
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_no_Port_Include_EMPL] ON [dbo].[HEM_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Portfolio] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Acc_Time_ID') 
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Acc_Time_ID] ON [dbo].[HEM_AWC] 
		(
			[Claim_no] ASC,
			[Account_Manager] ASC,
			[Time_ID] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Acc_Time_ID_Claim_no_Team_Port') 
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Acc_Time_ID_Claim_no_Team_Port] ON [dbo].[HEM_AWC] 
		(
			[Account_Manager] ASC,
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Team] ASC,
			[Portfolio] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Time_ID_Port_Team_Acc') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Time_ID_Port_Team_Acc] ON [dbo].[HEM_AWC]
		(
			[Claim_no] ASC,
			[Time_ID] ASC,
			[Portfolio] ASC,
			[Team] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Team_Time_ID_Claim_no_Acc_Port') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Team_Time_ID_Claim_no_Acc_Port] ON [dbo].[HEM_AWC] 
		(
			[Team] ASC,
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Account_Manager] ASC,
			[Portfolio] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Port_Time_ID_Claim_no_Team_Acc') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Port_Time_ID_Claim_no_Team_Acc] ON [dbo].[HEM_AWC] 
		(
			[Portfolio] ASC,
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Team] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

EXEC [dbo].[usp_DART_Index]--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_DART_Index.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Dashboard_EML_RTW_AddTargetAndBase_GenerateData.sql  
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

	(select distinct dbo.udf_EML_GetGroupByTeam(Team) as [group] from EML_RTW) as t2

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

	(select distinct dbo.udf_EML_GetGroupByTeam(Team) as [group],[Team] from EML_RTW) as t2

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Dashboard_EML_RTW_AddTargetAndBase_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData.sql  
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

	(select distinct dbo.udf_HEM_GetGroupByTeam(Team) as [group] from HEM_RTW) as t2

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

	(select distinct dbo.udf_HEM_GetGroupByTeam(Team) as [group],[Team] from HEM_RTW) as t2

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Dashboard_TMF_RTW_AddTargetAndBase_GenerateData.sql  
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
		 			   FROM TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.agencyname) = rtrim(isnull(sub.AgencyName,'Miscellaneous')))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.agencyname) = rtrim(isnull(sub.AgencyName,'Miscellaneous')))					
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

	(select distinct rtrim(isnull(sub.AgencyName,'Miscellaneous')) as agencyname from TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO) as t2

	CROSS JOIN

	(select 13 as Measure
		union select 26 as Measure
		union select 52 as Measure
		union select 78 as Measure
		union select 104 as Measure	) as t3) as tmp
		
	--Agency Police & Fire & RFS
	UNION ALL
	SELECT [Type] = 'agency'
		   ,[Value] = 'POLICE & EMERGENCY SERVICES'
		   ,[Sub_Value] = NULL
		   ,[Measure]= tmp.measure 	   
		   ,[Target] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
		 					 * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))
		 			   FROM TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire','RFS'))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police','Fire','RFS'))
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

	(select [agencyname] = 'POLICE & EMERGENCY SERVICES') as t2

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
		 			   FROM TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other'))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							and rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health','Other'))
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
		 			   FROM TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) = rtrim(isnull(sub.[Group],'Miscellaneous')))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) = rtrim(isnull(sub.[Group],'Miscellaneous')))					
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

	(select distinct rtrim(isnull(sub.[Group],'Miscellaneous')) as [group] from TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO) as t2

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
		 			   FROM TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) = rtrim(isnull(sub.[Group],'Miscellaneous'))
							AND RTRIM(tmp.[Team]) =RTRIM([Team]))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.[group]) = rtrim(isnull(sub.[Group],'Miscellaneous'))
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

	(select distinct rtrim(isnull(sub.[Group],'Miscellaneous')) as [group],[Team] from TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO) as t2

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
		 			   FROM TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.agencyname) = rtrim(isnull(sub.AgencyName,'Miscellaneous'))
							AND RTRIM(tmp.sub_category) = rtrim(isnull(sub.Sub_Category,'Miscellaneous')))
		   ,[Base] = (select ISNULL(SUM(LT) / nullif(SUM(WGT),0),0) 
					   * POWER(CAST(0.9 as float), (CAST((DATEDIFF(mm,cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/06/30',DATEADD(mm,-3,tmp.Remuneration))) as float)/18))*1.15
						FROM TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
					   WHERE Measure=tmp.Measure								 
							AND Remuneration_End = cast(year(DATEADD(mm,-3,tmp.Remuneration)) -1 as varchar(10)) +'/09/30 23:59:00.000'
							AND DATEDIFF(MM, Remuneration_Start, Remuneration_End) =11
							AND RTRIM(tmp.agencyname) = rtrim(isnull(sub.AgencyName,'Miscellaneous'))
							AND RTRIM(tmp.sub_category) = rtrim(isnull(sub.Sub_Category,'Miscellaneous')))					
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

	(select distinct rtrim(isnull(sub.AgencyName,'Miscellaneous')) as agencyname, rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as sub_category from TMF_RTW uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO) as t2

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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Dashboard_TMF_RTW_AddTargetAndBase_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Generate_active_directory_user.sql  
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
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_Generate_active_directory_user.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_GetGroups.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_GetGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_GetGroups]
GO

CREATE PROCEDURE [dbo].usp_GetGroups(@System varchar(20))
AS
BEGIN	
	DECLARE @Team varchar(20)
	
	/* create group table */
	IF OBJECT_ID('tempdb..#group') IS NULL
	BEGIN
		CREATE TABLE #group
		(
			[Group] varchar(20)
		)
	END
		
	IF UPPER(@System) = 'TMF'
	BEGIN
		DECLARE cur CURSOR FOR
		SELECT DISTINCT Team FROM TMF_Portfolio
			WHERE Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		OPEN cur
		FETCH NEXT FROM cur	INTO @Team
		WHILE @@FETCH_STATUS = 0
		BEGIN	
			INSERT INTO #group SELECT dbo.udf_TMF_GetGroupByTeam(@Team)
			
			FETCH NEXT FROM cur INTO @Team
		END
		CLOSE cur
		DEALLOCATE cur
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		DECLARE cur CURSOR FOR
		SELECT DISTINCT Team FROM EML_Portfolio
			WHERE Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)
		OPEN cur
		FETCH NEXT FROM cur	INTO @Team
		WHILE @@FETCH_STATUS = 0
		BEGIN				
			INSERT INTO #group SELECT dbo.udf_EML_GetGroupByTeam(@Team)
			
			FETCH NEXT FROM cur INTO @Team
		END
		CLOSE cur
		DEALLOCATE cur
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		DECLARE cur CURSOR FOR
		SELECT DISTINCT Team FROM HEM_Portfolio
			WHERE Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
		OPEN cur
		FETCH NEXT FROM cur	INTO @Team
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO #group SELECT dbo.udf_HEM_GetGroupByTeam(@Team)
			
			FETCH NEXT FROM cur INTO @Team
		END
		CLOSE cur
		DEALLOCATE cur
	END
	
	SELECT DISTINCT * FROM #group
	
	DROP TABLE #group
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_GetGroups.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_GetTeamsByGroup.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_GetTeamsByGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_GetTeamsByGroup]
GO

CREATE PROCEDURE [dbo].usp_GetTeamsByGroup(@System varchar(20),@Group varchar(20))
AS
BEGIN	
	DECLARE @Team varchar(20)
	DECLARE @GroupName varchar(20)
	
	/* create team table */
	IF OBJECT_ID('tempdb..#team') IS NULL
	BEGIN
		CREATE TABLE #team
		(
			Team varchar(20)
		)
	END
		
	IF UPPER(@System) = 'TMF'
	BEGIN
		DECLARE cur CURSOR FOR
		SELECT DISTINCT Team FROM TMF_Portfolio
			WHERE Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		OPEN cur
		FETCH NEXT FROM cur	INTO @Team
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @GroupName = dbo.udf_TMF_GetGroupByTeam(@Team)
			IF UPPER(@GroupName) = UPPER(@Group)
			BEGIN
				INSERT INTO #team SELECT @Team
			END
			
			FETCH NEXT FROM cur INTO @Team
		END
		CLOSE cur
		DEALLOCATE cur
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		DECLARE cur CURSOR FOR
		SELECT DISTINCT Team FROM EML_Portfolio
			WHERE Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)
		OPEN cur
		FETCH NEXT FROM cur	INTO @Team
		WHILE @@FETCH_STATUS = 0
		BEGIN				
			SET @GroupName = dbo.udf_EML_GetGroupByTeam(@Team)
			IF UPPER(@GroupName) = UPPER(@Group)
			BEGIN
				INSERT INTO #team SELECT @Team
			END
			
			FETCH NEXT FROM cur INTO @Team
		END
		CLOSE cur
		DEALLOCATE cur
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		DECLARE cur CURSOR FOR
		SELECT DISTINCT Team FROM HEM_Portfolio
			WHERE Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
		OPEN cur
		FETCH NEXT FROM cur	INTO @Team
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @GroupName = dbo.udf_HEM_GetGroupByTeam(@Team)
			IF UPPER(@GroupName) = UPPER(@Group)
			BEGIN
				INSERT INTO #team SELECT @Team
			END
			
			FETCH NEXT FROM cur INTO @Team
		END
		CLOSE cur
		DEALLOCATE cur
	END
	
	SELECT DISTINCT * FROM #team
	
	DROP TABLE #team
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\Dart\tmpChange\StoredProcedure\usp_GetTeamsByGroup.sql  
--------------------------------  
