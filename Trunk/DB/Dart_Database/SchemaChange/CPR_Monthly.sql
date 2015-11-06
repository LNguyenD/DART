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
GO