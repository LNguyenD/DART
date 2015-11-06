/****** Object:  Table [dbo].[HEM_AWC_Projections]    Script Date: 07/08/2013 08:24:30 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEM_AWC_Projections]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[HEM_AWC_Projections](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Unit_Type] [varchar](20) NOT NULL,
			[Unit_Name] [varchar](256) NOT NULL,
			[Type] [varchar](20) NOT NULL,
			[Time_Id] [datetime] NOT NULL,
			[Projection] [float] NOT NULL,
		 CONSTRAINT [PK_HEM_AWC_Projections] PRIMARY KEY CLUSTERED 
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