IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[uvBROKER]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[uvBROKER]
GO

/****** Object:  View [dbo].[uvBROKER]    Script Date: 06/20/2012 12:17:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[uvBROKER]
as
select * from BROKER

GO

