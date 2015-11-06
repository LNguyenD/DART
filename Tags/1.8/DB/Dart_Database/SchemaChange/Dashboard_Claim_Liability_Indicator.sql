/****** Object:  Table [DART].[dbo].[Dashboard_Claim_Liability_Indicator]    Script Date: 31/08/2015 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DART].[dbo].[Dashboard_Claim_Liability_Indicator]') AND type in (N'U'))
DROP TABLE [DART].[dbo].[Dashboard_Claim_Liability_Indicator]
GO	

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

	
--INSERT DATA--
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('TMF',1,NULL,'Notification of work related injury')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('TMF',2,NULL,'Liability accepted')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('TMF',5,NULL,'Liability not yet determined')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('TMF',6,NULL,'Administration error')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('TMF',7,NULL,'Liability denied')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('TMF',8,NULL,'Provisional liability accepted - weekly and medical payments')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('TMF',9,NULL,'Reasonable excuse')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('TMF',10,NULL,'Provisional liability discontinued')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('TMF',11,NULL,'Provisional liability accepted - medical only, weekly payments not applicable')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('TMF',12,NULL,'No action after notification')

INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('EML',1,NULL,'Notification of work related injury')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('EML',2,NULL,'Liability accepted')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('EML',5,NULL,'Liability not yet determined')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('EML',6,NULL,'Administration error')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('EML',7,NULL,'Liability denied')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('EML',8,NULL,'Provisional liability accepted - weekly and medical payments')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('EML',9,NULL,'Reasonable excuse')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('EML',10,NULL,'Provisional liability discontinued')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('EML',11,NULL,'Provisional liability accepted - medical only, weekly payments not applicable')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('EML',12,NULL,'No action after notification')

INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('HEM',1,NULL,'Notification of work related injury')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('HEM',2,NULL,'Liability accepted')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('HEM',5,NULL,'Liability not yet determined')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('HEM',6,NULL,'Administration error')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('HEM',7,NULL,'Liability denied')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('HEM',8,NULL,'Provisional liability accepted - weekly and medical payments')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('HEM',9,NULL,'Reasonable excuse')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('HEM',10,NULL,'Provisional liability discontinued')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('HEM',11,NULL,'Provisional liability accepted - medical only, weekly payments not applicable')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('HEM',12,NULL,'No action after notification')

INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('WOW',NULL,'ACPOR','Liability accepted - Originally Rejected')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('WOW',NULL,'ACPTD','Liability accepted')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('WOW',NULL,'ADERR','Administration error')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('WOW',NULL,'LDENY','Liability denied')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('WOW',NULL,'LDYOA','Liability denied - Originally Accepted')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('WOW',NULL,'NOACT','No action after notification')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('WOW',NULL,'NOTDT','Liability not yet determined')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('WOW',NULL,'NOTFY','Notification of work related injury')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('WOW',NULL,'PAMO','Provisional liability accepted - medical only, weekly payments not applicable')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('WOW',NULL,'PAWM','Provisional liability accepted - weekly and medical payments')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('WOW',NULL,'PDISC','Provisional liability discontinued')
INSERT INTO [DART].[dbo].[Dashboard_Claim_Liability_Indicator] ([System],[Liability_Id],[Liability_Code],[Description]) VALUES ('WOW',NULL,'REXCS','Reasonable excuse')
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO