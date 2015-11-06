/****** Object:  StoredProcedure [dbo].[usp_GetUserInfo]    Script Date: 07/07/2015 09:03:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetUserInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetUserInfo]
GO



CREATE PROCEDURE [dbo].[usp_GetUserInfo] (@UserNameOrEmail varchar(150)) 
	
AS
BEGIN	
	declare @UserId as int, @System_RoleId as int, @Is_External_User as bit,@Status_Active smallint
	select  @Status_Active = statusid from dbo.[Status] where name='Active'
	
	select  @UserId = UserId from Users where (UserName = @UserNameOrEmail or Email = @UserNameOrEmail) 
			--and ([status]=@Status_Active or (Online_Locked_Until_Datetime < GETDATE()))
	select  @Is_External_User = case when exists(select UserId from ReportUsers where UserId=@UserId and Is_External_User =1) then 1 else 0 end
	
	
	select  u.[UserId]
			 ,[UserName] = SUBSTRING(u.[UserName],CHARINDEX('\',u.[UserName])+1,LEN(u.[UserName]))
			 ,u.[Password]
			 ,u.[FirstName]
			 ,u.[LastName]
			 ,u.[Address]
			 ,u.[Email]
			 ,u.[Status]
			 ,u.[Phone]
			 ,u.[Online_Locked_Until_Datetime]
			 ,u.[Online_No_Of_Login_Attempts]
			 ,u.[Last_Online_Login_Date]
			 ,u.[Create_Date]
			 ,u.[Owner]
			 ,u.[UpdatedBy]
			 ,u.[Is_System_User]
			 ,u.[Default_System_Id]
			,List_Of_System_Group= (case when u.Is_System_User = 1 then
										substring((SELECT ',' + cast(SystemId as varchar(20)) + '_' + Name + '_' + '0' + '_' + [Description]
														FROM Systems														
														FOR XML PATH('')),2,10000)
									else
											(case when @Is_External_User = 0 then -- internal user
													substring((SELECT ',' + cast(s.SystemId as varchar(20)) + '_' + s.Name + '_' + cast(ol.LevelId as varchar(20)) + '_' + s.Description
																FROM Organisation_Levels  ol
																Left join Systems s on s.SystemId=ol.SystemId
																where LevelId in
																(select LevelId from Organisation_Roles where Organisation_RoleId in
																		(Select Organisation_RoleId
																			FROM ReportUsers
																			where UserId = u.UserId))														
																FOR XML PATH('')),2,10000)
											else ---external user												
													substring((SELECT ',' + cast(s.SystemId as varchar(20)) + '_' + s.Name  + '_' + cast(eg.External_GroupId as varchar(20)) + '_' + cast(eg.Name as varchar(30))
																FROM External_Groups eg
																Left join Systems s on s.SystemId=eg.SystemId
																where External_GroupId in
																(select External_GroupId from ReportUsers 
																			where UserId = u.UserId)														
																FOR XML PATH('')),2,10000)
											end)
										
								end)	
			,List_Of_OrganisationRoleId= substring((SELECT ',' + cast(Organisation_RoleId as varchar(20)) 
														FROM ReportUsers
														where UserId = u.UserId
														FOR XML PATH('')),2,10000)
			,List_Of_OrganisationLevelId= substring((SELECT ',' + cast(LevelId as varchar(20)) 
														FROM Organisation_Roles where Organisation_RoleId in
														(Select Organisation_RoleId
															FROM ReportUsers
															where UserId = u.UserId)
														FOR XML PATH('')),2,10000)						
			
			,System_RoleId = su.System_RoleId 
			,List_Of_System_Role_Permissions = substring((SELECT ',' + cast(su.System_RoleId as varchar(20)) + '_' + cast(System_PermissionId as varchar(20)) + '_' + cast(PermissionId as varchar(20)) 
															FROM System_Role_Permissions where System_RoleId=su.System_RoleId											
															FOR XML PATH('')),2,10000)
			
			,Is_External_User = @Is_External_User
			,List_Of_External_GroupId = substring((SELECT ',' + cast(External_GroupId as varchar(20)) 
															FROM ReportUsers where UserId=@UserId														
															FOR XML PATH('')),2,10000)
			,LandingPage_Url = f.Url
			,Default_System_Name = s.Name
				
	 from dbo.Users u
	 left join Systems s on u.Default_System_Id = s.SystemId
	 left join Dashboard_Favours f on u.UserId=f.UserId and f.Is_Landing_Page=1
	 left join SystemUsers su on u.UserId = su.UserId
	
	 where u.UserId = @UserId
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


