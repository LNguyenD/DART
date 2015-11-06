
/****** Object:  StoredProcedure [dbo].[usp_GetUser]    Script Date: 08/13/2014 13:38:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetUser]
GO


/****** Object:  StoredProcedure [dbo].[usp_GetUser]    Script Date: 08/13/2014 13:38:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_GetUser] (@UserName varchar(150)) 
	
AS
BEGIN	
	select UserName, [Password], [Is_System_User] from dbo.Users where UserName = @UserName or Email = @UserName and [Status] = 1		
END
GO