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
GO