
/****** Object:  StoredProcedure [dbo].[PRO_Internal_Login]    Script Date: 07/03/2014 16:14:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRO_Internal_Login]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_Internal_Login]
GO



/****** Object:  StoredProcedure [dbo].[PRO_Internal_Login]    Script Date: 07/03/2014 16:14:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- exec PRO_Login
CREATE PROCEDURE [dbo].[PRO_Internal_Login] (@Username varchar(150), @NoLimitLoginAttempts int = 3, @NoDaysBlockedAttempts int = 1, @SystemId int)
	
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
		where u.UserName=@Username and s.SystemId = @SystemId and o.[Status]=@Status_Active 
		and ol.[Status]=@Status_Active and u.[Status]=@Status_Active
	if @UserId >0
		select @UserId
	else if exists(select top 1 UserId,UserName from dbo.Users where UserName=@Username and [Status] = @Status_Active)
		begin						
			select @UserId = UserId from dbo.Users where UserId =(select top 1 userid from dbo.Users where UserName=@Username and [Status] = @Status_Active)
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
						where UserName=@Username
									
					update Users set Online_No_Of_Login_Attempts = @loginAttempts
						where UserName=@Username
					
					if @loginAttempts >= @NoLimitLoginAttempts
					begin
						update Users set [Status] = 2, Online_Locked_Until_Datetime = DATEADD(dd, @NoDaysBlockedAttempts, GETDATE()) 
							where UserName=@Username	
						select -2 -- account has been blocked
					end
					else
						select -1
		end
	else
		begin
			if exists(select top 1 UserId, UserName from dbo.Users where UserName=@Username and [Status] = 2 and Online_Locked_Until_Datetime is not null and Online_Locked_Until_Datetime <= GETDATE())
				begin
					-- unblock user login
					update Users set [Status] = 1, Online_No_Of_Login_Attempts = NULL, Online_Locked_Until_Datetime = NULL
						where UserName=@Username
					
					select UserId from dbo.Users where UserName=@Username
				end
			else if exists(select top 1 UserId, UserName from dbo.Users where UserName=@Username and [Status] = 2 and Online_Locked_Until_Datetime is not null and Online_Locked_Until_Datetime > GETDATE())
				select -2 -- account has been blocking
			else if exists(select top 1 UserId, UserName from dbo.Users where UserName=@Username and [Status] = 1)
			begin
				select @loginAttempts = ISNULL(Online_No_Of_Login_Attempts, 0) + 1 from Users where UserName=@Username
									
				update Users set Online_No_Of_Login_Attempts = @loginAttempts where UserName=@Username
				
				if @loginAttempts >= @NoLimitLoginAttempts
				begin
					update Users set [Status] = 2, Online_Locked_Until_Datetime = DATEADD(dd, @NoDaysBlockedAttempts, GETDATE())where UserName=@Username
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


