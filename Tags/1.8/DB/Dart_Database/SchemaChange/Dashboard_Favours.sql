/****** Object:  Table [dbo].[Dashboard_Favours]    Script Date: 09/23/2013 11:45:13 ******/
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dashboard_Favours]') AND type in (N'U'))
	CREATE TABLE [dbo].[Dashboard_Favours](
		[FavourId] [int] IDENTITY(1,1) NOT NULL,
		[Name] [nvarchar](256) NOT NULL,
		[Url] [nvarchar](300) NOT NULL,
		[UserId] [int] NOT NULL,
		[Status] [smallint] NULL,
		[Create_Date] [datetime] NULL,
		[Owner] [int] NULL,
		[UpdatedBy] [int] NULL,
	 CONSTRAINT [PK_Dashboard_Favour] PRIMARY KEY CLUSTERED 
	(
		[FavourId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
ELSE
	-- Update Users table schema
	IF COL_LENGTH('Dashboard_Favours','Is_Landing_Page') IS NULL
	BEGIN	
		ALTER TABLE [dbo].[Dashboard_Favours]
		ADD Is_Landing_Page bit NULL	
	END	
GO