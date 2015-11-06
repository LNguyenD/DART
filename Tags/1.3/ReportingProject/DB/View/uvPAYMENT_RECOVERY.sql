IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[uvPAYMENT_RECOVERY]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[uvPAYMENT_RECOVERY]
GO

/****** Object:  View [dbo].[uvPAYMENT_RECOVERY]    Script Date: 06/20/2012 12:17:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[uvPAYMENT_RECOVERY]
as
select * from PAYMENT_RECOVERY

GO

