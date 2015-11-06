/****** Object:  StoredProcedure [dbo].[usp_Generate_active_directory_user]    Script Date: 20/05/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Generate_active_directory_user]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Generate_active_directory_user]
GO

CREATE PROCEDURE [dbo].[usp_Generate_active_directory_user]
	@tmfprod varchar(20),
	@emlprod varchar(20),
	@hemprod varchar(20)
AS
BEGIN
	IF OBJECT_ID('tempdb..#all_records') IS NOT NULL DROP TABLE #all_records
	
	declare @tmf_query varchar(500)
	declare @eml_query varchar(500)
	declare @hem_query varchar(500)
	set @tmf_query = 'SELECT 1 as TMF,
						   0 as EML,
						   0 as HEM,
						   Alias as Alias,
						   First_Name as FirstName,
						   Last_Name as LastName,
						   active as active
					 FROM ' + @tmfprod + '.[dbo].[CLAIMS_OFFICERS]'
					 
	set @eml_query = 'SELECT 0 as TMF,
						   1 as EML,
						   0 as HEM,
						   Alias as Alias,
						   First_Name as FirstName,
						   Last_Name as LastName,
						   active as active
					 FROM ' + @emlprod + '.[dbo].[CLAIMS_OFFICERS]'
					 
	set @hem_query = 'SELECT 0 as TMF,
						   0 as EML,
						   1 as HEM,
						   Alias as Alias,
						   First_Name as FirstName,
						   Last_Name as LastName,
						   active as active
					 FROM ' + @hemprod + '.[dbo].[CLAIMS_OFFICERS]'
								
	--CREATE TABLE TO STORE ALL RECORDS FROM EMIC DATABASE--
	CREATE TABLE #all_records
	(
		ID int identity,
		TMF bit null,
		EML bit null,
		HEM bit null,
		Alias nvarchar (10) null,
		FirstName nvarchar(256) null,
		LastName nvarchar(256) null,
		Email nvarchar (256) null,
		Status smallint null,
		Create_date datetime null,
		Is_System_User bit null,
		Default_System_Id int null,
		active bit null,
		Organisation_RoleId int null
	)

	INSERT INTO #all_records(TMF,EML,HEM,Alias,FirstName,LastName,active)
	exec(@tmf_query)
	
	INSERT INTO #all_records(TMF,EML,HEM,Alias,FirstName,LastName,active)
	exec(@eml_query)
	
	INSERT INTO #all_records(TMF,EML,HEM,Alias,FirstName,LastName,active)
	exec(@hem_query)
	
	--UPDATE OTHER FIELDS IN TEMPT TABLE
	UPDATE #all_records
	SET Email = '',
		Status = 1,
		Create_date = GETDATE(),
		Is_System_User = 0,
		Default_System_Id = (SELECT SystemId 
							 FROM [Dart].[dbo].[Systems]
							 WHERE LOWER(Name)  = case when TMF = 1 then 'tmf'
													   when HEM = 1 then 'hem'
													   when EML = 1 then 'eml'
												  end),
        Organisation_RoleId = (SELECT roles.Organisation_RoleId
												  FROM [Dart].[dbo].[Organisation_Levels] levels join [Dart].[dbo].[Organisation_Roles] roles 
														ON levels.LevelId = roles.LevelId
												  WHERE levels.SystemId = (SELECT SystemId 
																		   FROM [Dart].[dbo].[Systems]
																		   WHERE LOWER(Name)  = case when TMF = 1 then 'tmf'
																							    when HEM = 1 then 'hem'
																							    when EML = 1 then 'eml'
																						        end)
											            and roles.Name = 'Pilot Users') 												
									            	
	--DELETE EXISTING USER WITH ACTIVE = 0 FROM USER TABLE--
	DELETE FROM [Dart].[dbo].[Users]
	WHERE UserId in (SELECT UserId
				 FROM [Dart].[dbo].[Users] u1
				 WHERE UserName COLLATE Latin1_General_CI_AS in (SELECT distinct Alias
												   FROM #all_records ar join [Dart].[dbo].[Users] u 
															on ar.Alias = u.UserName COLLATE Latin1_General_CI_AS
												   WHERE ar.active = 0)
				  AND Default_System_Id in (SELECT ar.Default_System_Id
											FROM #all_records ar join [Dart].[dbo].[Users] u 
													on ar.Alias = u.UserName COLLATE Latin1_General_CI_AS
											WHERE ar.active = 0 and u.UserId = u1.UserId)
				)
				
	--INSERT NEW USER INTO DART USER TABLE--
	INSERT INTO [Dart].[dbo].[Users] (UserName,
									  Password,
									  FirstName,
									  LastName,
									  Email,
									  [Status],
									  Create_Date,
									  Is_System_User,
									  Default_System_Id)
	SELECT Alias,
		   '',
		   FirstName,
		   LastName,
		   Email,
		   Status, 
		   Create_date,
		   Is_System_User, 
		   Default_System_Id 
	FROM #all_records ar	
	WHERE ID = (SELECT MAX(ID) 
				FROM #all_records t1 
				WHERE t1.Alias = ar.Alias and active = 1)
		  AND NOT EXISTS (SELECT * 
						  FROM [Dart].[dbo].[Users] u
						  WHERE u.UserName COLLATE Latin1_General_CI_AS = ar.Alias)

	--INSERT NEW USER INTO DART REPORT USER TABLE--
	INSERT INTO [Dart].[dbo].[ReportUsers] (UserId,Is_External_User,Organisation_RoleId)
	SELECT u.UserId
		  ,0 as Is_External_User
		  ,Organisation_RoleId = Organisation_RoleId
	FROM #all_records join [Dart].[dbo].[Users] u ON u.UserName COLLATE Latin1_General_CI_AS = #all_records.Alias
	WHERE active = 1
		 AND NOT EXISTS (SELECT * 
						 FROM [Dart].[dbo].[ReportUsers] ru
						 WHERE ru.UserId = u.UserId)
							 
	--DELETE EXISTING USER WITH ACTIVE CHANGED FROM 1 TO 0 FROM REPORT USER TABLE--
	DELETE FROM [Dart].[dbo].[ReportUsers]
	WHERE Id in (SELECT Id 
				FROM [Dart].[dbo].[ReportUsers] ru
				WHERE UserId in (SELECT UserId
							 FROM [Dart].[dbo].[Users] u 
								inner join #all_records ar ON u.UserName COLLATE Latin1_General_CI_AS = ar.Alias
							 WHERE active = 0)
				and Organisation_RoleId in (SELECT ar.Organisation_RoleId
											 FROM [Dart].[dbo].[Users] u 
												inner join #all_records ar ON u.UserName COLLATE Latin1_General_CI_AS = ar.Alias
											 WHERE ar.active = 0 and u.UserId = ru.UserId)
				)
	
	--INSERT EXISTING USER WITH ACTIVE CHANGED FROM 0 TO 1 INTO REPORT USER TABLE--				
	INSERT INTO [Dart].[dbo].[ReportUsers] (UserId,Is_External_User,Organisation_RoleId)
	SELECT u.UserId
		  ,0 as Is_External_User
		  ,Organisation_RoleId = Organisation_RoleId
	FROM #all_records join [Dart].[dbo].[Users] u ON u.UserName COLLATE Latin1_General_CI_AS = #all_records.Alias
	WHERE active = 1
	AND u.UserId in (SELECT ru.UserId
					 FROM [Dart].[dbo].[ReportUsers] ru
					 WHERE ru.UserId = u.UserId)
	AND Organisation_RoleId not in (SELECT ru.Organisation_RoleId
									FROM [Dart].[dbo].[ReportUsers] ru
									WHERE ru.UserId = u.UserId)
						 			
	
	IF OBJECT_ID('tempdb..#all_records') IS NOT NULL DROP TABLE #all_records
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON