/****** Object:  Table [dbo].[CPR_Monthly]    Script Date: 04/10/2015 08:24:30 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DashboardExternal_Groups]') AND type in (N'U'))	
BEGIN	
	CREATE TABLE [dbo].[DashboardExternal_Groups](
		[DashboardExternal_GroupId] [int] IDENTITY(1,1) NOT NULL,
		[DashboardId] [int] NOT NULL,
		[DashboardLevelId] [int] NOT NULL,
		[External_GroupId] [int] NOT NULL,
		[Create_Date] [datetime] NULL,
		[Owner] [int] NULL,
		[UpdatedBy] [int] NULL,
	 CONSTRAINT [PK_DashboardExternal_Groups] PRIMARY KEY CLUSTERED 
	(
		[DashboardExternal_GroupId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO