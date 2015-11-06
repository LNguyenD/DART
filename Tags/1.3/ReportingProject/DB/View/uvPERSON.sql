IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[uvPERSON]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[uvPERSON]
GO

/****** Object:  View [dbo].[uvPERSON]    Script Date: 06/20/2012 12:17:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[uvPERSON]
as
select * from PERSON

GO

