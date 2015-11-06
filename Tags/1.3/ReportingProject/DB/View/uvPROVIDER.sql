IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[uvPROVIDER]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[uvPROVIDER]
GO

/****** Object:  View [dbo].[uvPROVIDER]    Script Date: 06/20/2012 12:17:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[uvPROVIDER]
as
select * from providers

GO

