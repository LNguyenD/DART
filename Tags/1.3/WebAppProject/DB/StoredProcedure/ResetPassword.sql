/****** Object:  StoredProcedure [dbo].[PRO_ResetPassword]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[PRO_ResetPassword]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_ResetPassword]
GO

/****** Object:  StoredProcedure [dbo].[PRO_ResetPassword]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[PRO_ResetPassword] (@UserNameOrEmail varchar(256),@PassWordReset varchar(256)) 
	
AS
BEGIN
	If exists(select UserId from USERs where Email=@UserNameOrEmail)
		begin
			update USERs set Password = @PassWordReset where Email =@UserNameOrEmail
			select userid from Users where Email =@UserNameOrEmail
		end
	Else If exists(select UserId from USERs where UserName=@UserNameOrEmail)
		begin
			update USERs set Password = @PassWordReset where UserName =@UserNameOrEmail
			select userid from Users where UserName =@UserNameOrEmail
		end
	Else
		select -1
END