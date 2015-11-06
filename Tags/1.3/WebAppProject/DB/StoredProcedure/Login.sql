/****** Object:  StoredProcedure [dbo].[PRO_Login]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[PRO_Login]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_Login]
GO

/****** Object:  StoredProcedure [dbo].[PRO_Login]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- exec PRO_Login
create PROCEDURE [dbo].[PRO_Login] (@UserName varchar(150),@PassWord varchar(300)) 
	
AS
BEGIN
	declare @UserId int	
	if exists(select top 1 UserId,UserName,[Password] from dbo.Users where UserName=@UserName and [Password]=@PassWord and [Status] = 1)
		begin
			select @UserId = UserId from dbo.Users where UserName=@UserName and [Password]=@PassWord
			if exists(select UserId from SystemUsers where UserId=@UserId)
				select @UserId
			else if exists(select UserId from ReportUsers r left join External_Groups e on r.External_GroupId=e.External_GroupId where  Is_External_User = 1 and UserId=@UserId and e.[Status]=1 )
				select @UserId
			else if exists(select UserId from ReportUsers r left join Organisation_Roles o on r.Organisation_RoleId=o.Organisation_RoleId left join Organisation_Levels ol on o.LevelId=ol.LevelId where UserId=@UserId and o.[Status]=1 and ol.[Status]=1 )
				select @UserId
			else 
				select -1					
		end
	else
		Begin
			if exists(select top 1 UserId,UserName,[Password] from dbo.Users where UserName=@UserName and [Password]=@PassWord and [Status] = 4 and Online_Locked_Until_Datetime < GETDATE())
				begin
					update Users set [Status] = 1,Online_Locked_Until_Datetime =null where UserName=@UserName and [Password]=@PassWord 
					select UserId from dbo.Users where UserName=@UserName and [Password]=@PassWord
				end
			else if exists(select top 1 UserId,UserName,[Password] from dbo.Users where UserName=@UserName and [Status] = 4 and Online_Locked_Until_Datetime >= GETDATE())			
				select -2
			else
				select -1 	
		End
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO