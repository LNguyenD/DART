IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[uvCONTACT_EXTENSION]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[uvCONTACT_EXTENSION]
GO

/****** Object:  View [dbo].[uvCONTACT_EXTENSION]    Script Date: 06/20/2012 12:17:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[uvCONTACT_EXTENSION]
as
select * from contact_extensions

GO

