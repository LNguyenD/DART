/****** Object:  StoredProcedure [dbo].[usp_Adjust_Attempt_Login]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_Adjust_Attempt_Login]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Adjust_Attempt_Login]
GO

/****** Object:  StoredProcedure [dbo].[usp_Adjust_Attempt_Login]    Script Date: 20/09/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- exec usp_Adjust_Attempt_Login
CREATE PROCEDURE [dbo].[usp_Adjust_Attempt_Login] (@UserId int,@Type varchar(20), @NoLimitLoginAttempts int = 3, @NoDaysBlockedAttempts int = 1)
	
AS
BEGIN
	declare @loginAttempts int;	
	declare @Status_InActive smallint,@Status_Active smallint	
	select @Status_InActive = statusid from [Status] where Name like 'Inactive'
	select @Status_Active = statusid from [Status] where Name like 'Active'
	select @loginAttempts = ISNULL(Online_No_Of_Login_Attempts, 0) + 1 from Users
		where UserId=@UserId
					
	if @Type <> 'Unlock'
	begin
		if @loginAttempts <= @NoLimitLoginAttempts
		begin
			update Users set Online_No_Of_Login_Attempts = @loginAttempts where UserId=@UserId
		end
		if @loginAttempts >= @NoLimitLoginAttempts
		begin
			update Users set [Status] = @Status_InActive, Online_Locked_Until_Datetime = DATEADD(dd, @NoDaysBlockedAttempts, GETDATE()) 
				where UserId=@UserId						
		end
	end
	else if @Type = 'Unlock'
	begin
		update Users set [Status] = @Status_Active, Online_Locked_Until_Datetime = NULL,Online_No_Of_Login_Attempts = null	where UserId=@UserId
	end 
END
GO