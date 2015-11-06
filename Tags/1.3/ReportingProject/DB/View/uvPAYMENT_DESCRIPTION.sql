IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[uvPAYMENT_DESCRIPTION]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[uvPAYMENT_DESCRIPTION]
GO

/****** Object:  View [dbo].[uvPAYMENT_DESCRIPTION]    Script Date: 06/20/2012 12:17:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[uvPAYMENT_DESCRIPTION]
as
select * from Payment_Description

GO

