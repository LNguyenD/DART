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
GO