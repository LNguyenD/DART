IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[uvPOLICY_TERM_DETAIL]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[uvPOLICY_TERM_DETAIL]
GO

/****** Object:  View [dbo].[uvPOLICY_TERM_DETAIL]    Script Date: 06/20/2012 12:17:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[uvPOLICY_TERM_DETAIL]
as
select * from POLICY_TERM_DETAIL

GO

