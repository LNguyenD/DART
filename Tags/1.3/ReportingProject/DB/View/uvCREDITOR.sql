IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[uvCREDITOR]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[uvCREDITOR]
GO

/****** Object:  View [dbo].[uvCREDITOR]    Script Date: 06/20/2012 12:17:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[uvCREDITOR]
as
select * from CREDITORS

GO

