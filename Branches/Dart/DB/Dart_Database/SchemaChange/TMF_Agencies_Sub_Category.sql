IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TMF_Agencies_Sub_Category]') AND type in (N'U')) 
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
GO	

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO