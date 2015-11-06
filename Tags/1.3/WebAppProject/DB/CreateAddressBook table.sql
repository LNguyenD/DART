IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AddressBook_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[AddressBook]'))
ALTER TABLE [dbo].[AddressBook] DROP CONSTRAINT [FK_AddressBook_Users]
GO

/****** Object:  Table [dbo].[AddressBook]    Script Date: 03/13/2012 13:40:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddressBook]') AND type in (N'U'))
DROP TABLE [dbo].[AddressBook]
GO

/****** Object:  Table [dbo].[AddressBook]    Script Date: 03/13/2012 13:40:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AddressBook](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Email] [nvarchar](256) NULL,
	[BusinessPhone] [nvarchar](30) NULL,
	[HomePhone] [nvarchar](30) NULL,
	[MobilePhone] [nvarchar](30) NULL,
	[Address] [nvarchar](256) NULL,
 CONSTRAINT [PK_AddressBook] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AddressBook]  WITH CHECK ADD  CONSTRAINT [FK_AddressBook_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AddressBook] CHECK CONSTRAINT [FK_AddressBook_Users]
GO


