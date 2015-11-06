/****** Object:  StoredProcedure [dbo].[PRO_Register]    Script Date: 09/23/2013 13:05:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRO_Register]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_Register]
GO

/****** Object:  StoredProcedure [dbo].[PRO_Register]    Script Date: 09/23/2013 13:05:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PRO_Register] (@UserName varchar(150),@PassWord varchar(300),@Email varchar(256),@FirstName nvarchar(256),@LastName nvarchar(256),@Address nvarchar(400),@i_Status int) 
	
AS
BEGIN
	If exists(select UserId from USERs where Email=@Email and Address<>'')
		select -2
	Else If exists(select UserId from USERs where UserName=@UserName)
		select -1
	Else
		Begin
			Insert into USERs (UserName,Password,Email,FirstName,LastName,Address,Status) values(@UserName,@Password,@Email,@FirstName,@LastName,@Address,@i_Status)
			select SCOPE_IDENTITY()
		End
END

GO
