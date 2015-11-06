
update HEM_AWC_Projections set Unit_Name = 'Miscellaneous' where Unit_Type = 'group' and Unit_Name = 'Other'
update TMF_AWC_Projections set Unit_Name = 'Miscellaneous' where Unit_Type = 'group' and Unit_Name = 'Other'
update EML_AWC_Projections set Unit_Name = 'Miscellaneous' where Unit_Type = 'group' and Unit_Name = 'Other'

----delete old cpr full report----
delete from reports where Name like '%portfolio%'
-----Clean up store/udf/view

/* Drop all non-system stored procs */ 
DECLARE @name VARCHAR(128) 
DECLARE @SQL VARCHAR(254) 
SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'P' AND category = 0 ORDER BY [name]) 
WHILE @name is not null and CHARINDEX('usp_',@name) >0
BEGIN 
	SELECT @SQL = 'DROP PROCEDURE [dbo].[' + RTRIM(@name) +']' 			
	EXEC (@SQL) 
	PRINT 'Dropped Procedure: ' + @name 
	SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'P' AND category = 0 AND [name] > @name ORDER BY [name]) 
END 

/* Drop all views */ 	
SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'V' AND category = 0 ORDER BY [name]) 
WHILE @name IS NOT NULL 
BEGIN 
	SELECT @SQL = 'DROP VIEW [dbo].[' + RTRIM(@name) +']' 
	EXEC (@SQL) 
	PRINT 'Dropped View: ' + @name 
	SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'V' AND category = 0 AND [name] > @name ORDER BY [name]) 
END 

/* Drop all functions */	
SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] IN (N'FN', N'IF', N'TF', N'FS', N'FT') AND category = 0 ORDER BY [name]) 
WHILE @name IS NOT NULL and CHARINDEX('udf_',@name) >0
BEGIN 
	SELECT @SQL = 'DROP FUNCTION [dbo].[' + RTRIM(@name) +']' 
	EXEC (@SQL) 
	PRINT 'Dropped Function: ' + @name 
	SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] IN (N'FN', N'IF', N'TF', N'FS', N'FT') AND category = 0 AND [name] > @name ORDER BY [name]) 
END

/* Update Url for CPR dashboards */
UPDATE Dashboards
	SET Url = 'Level0,TMF_Level1,TMF_CPR_Week_Month_Summary,CPR_Summary,CPR_Summary,CPR_Summary,CPR_Summary,CPR_Summary', 
		[Description] = null,
		[Status] = 1
	WHERE UPPER(RTRIM(Name)) like '%TMF%' and  UPPER(RTRIM(Name)) like '%CPR%'
	
UPDATE Dashboards
	SET Url = 'Level0,EML_Level1,EML_CPR_Week_Month_Summary,CPR_Summary,CPR_Summary,CPR_Summary,CPR_Summary,CPR_Summary', 
		[Description] = null,
		[Status] = 1
	WHERE UPPER(RTRIM(Name)) like '%EML%' and  UPPER(RTRIM(Name)) like '%CPR%'
	
UPDATE Dashboards
	SET Url = 'Level0,HEM_Level1,HEM_CPR_Week_Month_Summary,CPR_Summary,CPR_Summary,CPR_Summary,CPR_Summary,CPR_Summary', 
		[Description] = null,
		[Status] = 1
	WHERE UPPER(RTRIM(Name)) like '%HEM%' and  UPPER(RTRIM(Name)) like '%CPR%'