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
GO