/****** Object:  StoredProcedure [dbo].[PRO_Login]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[PRO_Login]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_Login]
GO

/****** Object:  StoredProcedure [dbo].[PRO_Login]    Script Date: 20/09/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- exec PRO_Login
CREATE PROCEDURE [dbo].[PRO_Login] (@Email varchar(150),@PassWord varchar(300), @NoLimitLoginAttempts int = 3, @NoDaysBlockedAttempts int = 1, @SystemId int)
	
AS
BEGIN
	declare @loginAttempts int;
	declare @UserId int	
	declare @Status_Active smallint
	
	select @Status_Active = statusid from dbo.[Status] where name='Active'
	
	select @UserId =
		u.UserId from Users u left join ReportUsers r on u.UserId=r.UserId left join Organisation_Roles o 
		on r.Organisation_RoleId=o.Organisation_RoleId 
		left join Organisation_Levels ol on o.LevelId=ol.LevelId 
		left join Systems s on s.SystemId=ol.SystemId 
		where u.Email=@Email and [Password]=@Password and s.SystemId = @SystemId and o.[Status]=@Status_Active 
		and ol.[Status]=@Status_Active and u.[Status]=@Status_Active
	if @UserId >0
		select @UserId
	else if exists(select top 1 UserId,Email,[Password] from dbo.Users where Email=@Email and [Password]=@PassWord and [Status] = @Status_Active)
		begin						
			select @UserId = UserId from dbo.Users where UserId =(select top 1 userid from dbo.Users where Email=@Email and [Password]=@PassWord and [Status] = @Status_Active)
			if exists(select UserId from SystemUsers where UserId=@UserId)
				or exists(select UserId from ReportUsers r left join External_Groups e on r.External_GroupId=e.External_GroupId where  Is_External_User = 1 and UserId=@UserId and e.[Status]=@Status_Active)
				or exists(select UserId 
							from ReportUsers r 
								left join Organisation_Roles o on r.Organisation_RoleId=o.Organisation_RoleId 
								left join Organisation_Levels ol on o.LevelId=ol.LevelId 
							where UserId=@UserId and o.[Status]=@Status_Active and ol.[Status]=@Status_Active)
					select @UserId
			else
					select @loginAttempts = ISNULL(Online_No_Of_Login_Attempts, 0) + 1 from Users
						where Email=@Email and [Password]=@PassWord
									
					update Users set Online_No_Of_Login_Attempts = @loginAttempts
						where Email=@Email and [Password]=@PassWord
					
					if @loginAttempts >= @NoLimitLoginAttempts
					begin
						update Users set [Status] = 2, Online_Locked_Until_Datetime = DATEADD(dd, @NoDaysBlockedAttempts, GETDATE()) 
							where Email=@Email and [Password]=@PassWord		
						select -2 -- account has been blocked
					end
					else
						select -1
		end
	else
		begin
			if exists(select top 1 UserId, Email,[Password] from dbo.Users where Email=@Email and [Password]=@PassWord and [Status] = 2 and Online_Locked_Until_Datetime is not null and Online_Locked_Until_Datetime <= GETDATE())
				begin
					-- unblock user login
					update Users set [Status] = 1, Online_No_Of_Login_Attempts = NULL, Online_Locked_Until_Datetime = NULL
						where Email=@Email and [Password]=@PassWord
					
					select UserId from dbo.Users where Email=@Email and [Password]=@PassWord
				end
			else if exists(select top 1 UserId, Email,[Password] from dbo.Users where Email=@Email and [Status] = 2 and Online_Locked_Until_Datetime is not null and Online_Locked_Until_Datetime > GETDATE())
				select -2 -- account has been blocking
			else if exists(select top 1 UserId, Email,[Password] from dbo.Users where Email=@Email and [Password]<>@PassWord and [Status] = 1)
			begin
				select @loginAttempts = ISNULL(Online_No_Of_Login_Attempts, 0) + 1 from Users where Email=@Email
									
				update Users set Online_No_Of_Login_Attempts = @loginAttempts where Email=@Email
				
				if @loginAttempts >= @NoLimitLoginAttempts
				begin
					update Users set [Status] = 2, Online_Locked_Until_Datetime = DATEADD(dd, @NoDaysBlockedAttempts, GETDATE()) where Email=@Email
					select -2 -- account has been blocked
				end
				else
					select -1 -- wrong password
			end	
			else
				select -1 -- wrong password
		end
	
	--Update Last_Online_Login_Date column if user exist	
	if @UserId > 0
		begin
			update Users set Last_Online_Login_Date = getdate() where UserId = @UserId
		end
END
GO