/****** Object:  StoredProcedure [dbo].[PRO_Login]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[PRO_GetUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_GetUser]
GO

/****** Object:  StoredProcedure [dbo].[PRO_GetUser]    Script Date: 20/09/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[PRO_GetUser] (@UserName varchar(150)) 
	
AS
BEGIN	
	select UserName, [Password] from dbo.Users where UserName = @UserName and [Status] = 1		
END

GO