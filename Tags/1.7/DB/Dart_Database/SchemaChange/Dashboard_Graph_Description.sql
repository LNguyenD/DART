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
GO