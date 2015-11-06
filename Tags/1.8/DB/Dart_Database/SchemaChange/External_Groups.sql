/****** Object:  Table [dbo].[External_Groups]    Script Date: 04/10/2015 08:24:30 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[External_Groups]') AND type in (N'U'))	
	BEGIN	
		CREATE TABLE [dbo].[External_Groups](
			[External_GroupId] [int] IDENTITY(1,1) NOT NULL,
			[Name] [nvarchar](256) NULL,
			[Status] [smallint] NULL,
			[Create_Date] [datetime] NULL,
			[Owner] [int] NULL,
			[UpdatedBy] [int] NULL,
			[Description] [nvarchar](256) NULL,
			[SystemId] [int] NULL,
		 CONSTRAINT [PK_External_Groups] PRIMARY KEY CLUSTERED 
		(
			[External_GroupId] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END

ELSE
	BEGIN
		IF COL_LENGTH('External_Groups','SystemId') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[External_Groups]
			ADD [SystemId] INT NULL
		END
	END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
