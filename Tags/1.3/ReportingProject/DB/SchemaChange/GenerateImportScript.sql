--README:
-- First run this script on EMICS DBs
-- Then Copy the result and Run these result on web DB
-- Examle: run script on EML DB of EMICS, copy the result and run On EM_Reporting DB. 
--			Repeat this step for TMF & HEM

SET NOCOUNT ON
--Delete old data and reset identity user
PRINT	'delete from dbo.ReportUsers '
PRINT	'delete from dbo.SystemUsers '
PRINT	'delete from dbo.Users '
PRINT	'DBCC CHECKIDENT(''dbo.users'', RESEED, 0) '
--Delete and insert Organisation Role
PRINT	'delete from dbo.Organisation_Roles '
PRINT	'DBCC CHECKIDENT(''dbo.Organisation_Roles'', RESEED, 0) '
PRINT	'DECLARE @user_id int '
	 --Start cursor
		DECLARE @org_id int
		DECLARE @organisation_name VARCHAR(500)		

			DECLARE db_cursor CURSOR FOR	
				SELECT  Convert(int, ITEM) as ID,
				 VALUE as OrganisationRole
				  FROM [dbo].[CONTROL]
					where type ='OfficerTtl'
						order by ID			
		OPEN db_cursor   
		FETCH NEXT FROM db_cursor INTO @org_id,@organisation_name

		WHILE @@FETCH_STATUS = 0   
		BEGIN
			   PRINT 'insert into dbo.Organisation_Roles(Name,LevelId,Status) values(''' + @organisation_name + ''',1,1) '			   
			   FETCH NEXT FROM db_cursor INTO @org_id, @organisation_name  
		END   

		CLOSE db_cursor   
		DEALLOCATE db_cursor
  --End 
--Delete and insert Team
PRINT	'delete from dbo.Teams'
PRINT	'DBCC CHECKIDENT(''dbo.Teams'', RESEED, 0) '
	 --Start cursor
		DECLARE @teamName VARCHAR(10)		

			DECLARE db_cursor CURSOR FOR	
				SELECT distinct grp from dbo.CLAIMS_OFFICERS Where grp <> '' and grp is not null
		OPEN db_cursor   
		FETCH NEXT FROM db_cursor INTO @teamName

		WHILE @@FETCH_STATUS = 0   
		BEGIN
			   PRINT 'insert into dbo.Teams(Name, Status, Create_Date)	values (''' + @teamName + ''', 1, GETDATE())'			   
			   FETCH NEXT FROM db_cursor INTO @teamName  
		END   

		CLOSE db_cursor   
		DEALLOCATE db_cursor
  --End
-- ClmGroup
SELECT [ITEM],
	case when ( CHARINDEX('*', [VALUE]) > 0) then SUBSTRING([VALUE], CHARINDEX('*', [VALUE]) + 1, LEN([VALUE])) else '' end as Email
  into #clmgroup
  FROM [dbo].[CONTROL]
  where type ='clmgroup'
-- uwgroup
  SELECT [ITEM],
	case when ( CHARINDEX('*', [VALUE]) > 0) then SUBSTRING([VALUE], CHARINDEX('*', [VALUE]) + 1, LEN([VALUE])) else '' end as Email
  into #uwgroup
  FROM [dbo].[CONTROL]
  where type ='uwgroup'
  and [ITEM] not in (select ITEM from #clmgroup)
   
  --Ruud add cursor
		DECLARE @username VARCHAR(500) 
		DECLARE @password VARCHAR(500) 
		DECLARE @firstname VARCHAR(500) 
		DECLARE @lastname VARCHAR(500) 
		DECLARE @phone VARCHAR(500) 
		DECLARE @organisation_id int
		DECLARE @organisation_id_str varchar(200)
		DECLARE @email VARCHAR(500)	
		DECLARE @group VARCHAR(10)						
		DECLARE db_cursor CURSOR FOR  
		
		--Start select
				 -- user from Claim Officer
				  select CO.Alias as [UserName],
						[Password]='6Nx0M207QM8sWqmWWZoiiQ==' -- pw:123456
						,Replace(CO.First_Name, '''', '''''') as First_Name
						,Replace(CO.Last_Name, '''', '''''') as Last_Name
						,isnull(CO.Phone_No,'') as Phone_No,
						CO.Title,
						Replace(#clmgroup.Email, '''', '''''') as Email,
						CO.grp as Team
				  from #clmgroup
				  join dbo.CLAIMS_OFFICERS CO
				  on #clmgroup.ITEM = CO.Alias
				  WHERE CO.active <> 0
				UNION
				  -- user from Underwriter
				  select UWT.Alias as [UserName],
						[Password]='6Nx0M207QM8sWqmWWZoiiQ=='
						,Replace(UWT.First_Name, '''', '''''') as First_Name
						,Replace(UWT.Surname, '''', '''''') as Last_Name						
						,'' as Phone_No,
						NULL as OrganisationRoleId,
						Replace(#uwgroup.Email, '''', '''''') as Email,
						NULL as Team
				  from #uwgroup
				  join dbo.Underwriters UWT
				  on #uwgroup.ITEM = UWT.Alias
				  Where UWT.is_Active <> 0
				  order by [UserName]
		--End
		
		OPEN db_cursor   
		FETCH NEXT FROM db_cursor INTO @username,@password,@firstname,@lastname,@phone,@organisation_id,@email, @group

		WHILE @@FETCH_STATUS = 0   
		BEGIN			
			if @organisation_id is null 
				set @organisation_id_str ='NULL'
			else
				set @organisation_id_str =CONVERT(varchar,@organisation_id)
			PRINT
				'insert into dbo.users(UserName,Password,FirstName,LastName,Email,Status,Phone,Create_Date,Is_System_User)
			    values(''' + @username + ''',''' + @password + ''',''' + @firstname + ''',''' + @lastname + ''',''' + @email+ ''',1,''' + @phone + ''',''' + Convert(nvarchar(100), GETDATE()) + ''',0)'			
			PRINT
			    'insert into dbo.ReportUsers(UserId,Is_External_User,Organisation_RoleId, TeamId) 
			    values(SCOPE_IDENTITY(), 0,' + @organisation_id_str + ', (select top 1 TeamId from dbo.Teams where Name =''' + @group + '''))'						
			
			FETCH NEXT FROM db_cursor INTO @username,@password,@firstname,@lastname,@phone,@organisation_id,@email, @group  
		END   

		CLOSE db_cursor   
		DEALLOCATE db_cursor
  --End   
 
  -- clean up
  drop table #uwgroup
  drop table #clmgroup
  
-- Insert default data again
PRINT
'insert into dbo.users(UserName,Password,FirstName,LastName,Email,Status,Phone,Create_Date,Is_System_User)
values(''admin'',''6Nx0M207QM8sWqmWWZoiiQ=='',''admin'',''admin'',''l.le@aswigit.vn'',1,''8095834958'',GETDATE(),1)'

PRINT
'insert into dbo.SystemUsers(UserId,System_RoleId) values(SCOPE_IDENTITY(),1)'

PRINT
'insert into dbo.users(UserName,Password,FirstName,LastName,Email,Status,Phone,Create_Date,Is_System_User)
values(''report_user1'',''6Nx0M207QM8sWqmWWZoiiQ=='',''report_user1'',''report_user1'',''report_user1@aswigit.vn'',1,''8095834958'',GETDATE(),0)'

PRINT
'insert into dbo.ReportUsers(UserId,Is_External_User,Organisation_RoleId) values(SCOPE_IDENTITY(),0,1)'

PRINT 'declare @Guest_RoleId int'
PRINT 'insert into dbo.Organisation_Roles(Name,LevelId,[Status]) values(''Guest'',(select top 1 LevelId from dbo.Organisation_Levels order by Sort desc),1)'
PRINT 'Set @Guest_RoleId = (Select Organisation_RoleId From dbo.Organisation_Roles where Name = ''Guest'')'
PRINT 'update ReportUsers set Organisation_RoleId = @Guest_RoleId where Organisation_RoleId is null'
  

 

