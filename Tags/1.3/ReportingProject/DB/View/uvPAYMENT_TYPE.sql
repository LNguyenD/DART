IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[uvPAYMENT_TYPE]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[uvPAYMENT_TYPE]
GO

/****** Object:  View [dbo].[uvPAYMENT_TYPE]    Script Date: 06/20/2012 12:17:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[uvPAYMENT_TYPE]
as
select * from PAYMENT_TYPES

GO

