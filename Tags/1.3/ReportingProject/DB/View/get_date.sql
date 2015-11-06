/****** Object:  View [dbo].[get_date]    Script Date: 06/14/2012 12:17:39 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_date]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[get_date]
GO

/****** Object:  View [dbo].[get_date]    Script Date: 06/14/2012 12:17:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[get_date]
as
select getdate() dt

GO


