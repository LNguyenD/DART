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
GO