/****** Object:  Table [dbo].[Dashboard_TimeAccess]    Script Date: 09/23/2013 11:50:02 ******/
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dashboard_TimeAccess]') AND type in (N'U'))
	CREATE TABLE [dbo].[Dashboard_TimeAccess](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[DashboardId] [int] NOT NULL,
		[DashboardLevelId] [int] NOT NULL,
		[UserId] [int] NOT NULL,
		[StartTime] [datetime] NOT NULL,
		[EndTime] [datetime] NOT NULL,
		[Status] [smallint] NULL,
		[Create_Date] [datetime] NULL,
		[Owner] [int] NULL,
		[UpdatedBy] [int] NULL,
	 CONSTRAINT [PK_TimeAccessCalculator] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
ELSE
	BEGIN	
		
		IF COL_LENGTH('Dashboard_TimeAccess','DashboardId') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[Dashboard_TimeAccess]
			DROP COLUMN DashboardId
		END
		
		IF COL_LENGTH('Dashboard_TimeAccess','DashboardLevelId') IS NOT NULL
		BEGIN	
			ALTER TABLE [dbo].[Dashboard_TimeAccess]
			DROP COLUMN DashboardLevelId
		END
		
		IF COL_LENGTH('Dashboard_TimeAccess','Url') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[Dashboard_TimeAccess]
			ADD Url varchar (MAX) null
		END
		ELSE 
		BEGIN
			ALTER TABLE [dbo].[Dashboard_TimeAccess]
			ALTER COLUMN Url varchar (MAX) null
		END
	END
GO