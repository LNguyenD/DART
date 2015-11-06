/****** Object:  Table [DART].[dbo].[Dashboard_Claim_Liability_Indicator]    Script Date: 31/08/2015 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DART].[dbo].[Dashboard_Claim_Liability_Indicator]') AND type in (N'U'))
	CREATE TABLE [DART].[dbo].[Dashboard_Claim_Liability_Indicator](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[System] [varchar](10) NOT NULL,
		[Liability_Id] [int] NULL,
		[Liability_Code] [varchar](10) NULL,
		[Description] [varchar](256) NOT NULL,
	 CONSTRAINT [PK_Dashboard_Claim_Liability_Indicator] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
GO	
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO