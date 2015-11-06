/****** Object:  Table [dbo].[HEM_SIW]    Script Date: 30/12/2013 08:24:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEM_SIW]') AND type in (N'U'))	
	DROP TABLE [dbo].[HEM_SIW]
GO
/****** Object:  Table [dbo].[HEM_SIW]    Script Date: 30/12/2013 08:24:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HEM_SIW](
	[Claim_no] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  SELECT  ON [dbo].[HEM_SIW] TO [EMICS]
GRANT  SELECT  ON [dbo].[HEM_SIW] TO [EMIUS]
GRANT  SELECT  ON [dbo].[HEM_SIW] TO [DART_Role]
GO

