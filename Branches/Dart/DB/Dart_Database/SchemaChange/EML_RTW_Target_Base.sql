IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EML_RTW_Target_Base]') AND type in (N'U'))	
	BEGIN
		CREATE TABLE [dbo].[EML_RTW_Target_Base](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Type] [varchar](20) NOT NULL,
			[Value] [varchar](256) NULL,
			[Sub_Value] [varchar](256) NULL,
			[Measure] [int] NULL,
			[Target] [float] NULL,
			[Base] [float] NULL,
			[UpdatedBy] [int] NULL,
			[Create_Date] [datetime] NULL,
			[Status] [smallint] NULL,
			[Remuneration] varchar(20) NULL
		 CONSTRAINT [PK_EML_RTW_Target_Base] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END
ELSE
	BEGIN	
		IF COL_LENGTH('EML_RTW_Target_Base','Remuneration') IS NULL
		BEGIN	
			ALTER TABLE [dbo].[EML_RTW_Target_Base]
			ADD Remuneration nvarchar(20) null
		END		
	END	

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO