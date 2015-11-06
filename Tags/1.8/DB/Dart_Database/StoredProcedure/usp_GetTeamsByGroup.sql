SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_GetTeamsByGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_GetTeamsByGroup]
GO

CREATE PROCEDURE [dbo].usp_GetTeamsByGroup(@System varchar(20),@Group varchar(20))
AS
BEGIN	
	DECLARE @Team varchar(20)
	DECLARE @GroupName varchar(20)
	
	/* create team table */
	IF OBJECT_ID('tempdb..#team') IS NULL
	BEGIN
		CREATE TABLE #team
		(
			Team varchar(20)
		)
	END
		
	IF UPPER(@System) = 'TMF'
	BEGIN
		DECLARE cur CURSOR FOR
		SELECT DISTINCT Team FROM TMF_Portfolio
			WHERE Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		OPEN cur
		FETCH NEXT FROM cur	INTO @Team
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @GroupName = dbo.udf_TMF_GetGroupByTeam(@Team)
			IF UPPER(@GroupName) = UPPER(@Group)
			BEGIN
				INSERT INTO #team SELECT @Team
			END
			
			FETCH NEXT FROM cur INTO @Team
		END
		CLOSE cur
		DEALLOCATE cur
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		DECLARE cur CURSOR FOR
		SELECT DISTINCT Team FROM EML_Portfolio
			WHERE Reporting_Date = (select MAX(Reporting_Date) from EML_Portfolio)
		OPEN cur
		FETCH NEXT FROM cur	INTO @Team
		WHILE @@FETCH_STATUS = 0
		BEGIN				
			SET @GroupName = dbo.udf_EML_GetGroupByTeam(@Team)
			IF UPPER(@GroupName) = UPPER(@Group)
			BEGIN
				INSERT INTO #team SELECT @Team
			END
			
			FETCH NEXT FROM cur INTO @Team
		END
		CLOSE cur
		DEALLOCATE cur
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		DECLARE cur CURSOR FOR
		SELECT DISTINCT Team FROM HEM_Portfolio
			WHERE Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
		OPEN cur
		FETCH NEXT FROM cur	INTO @Team
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @GroupName = dbo.udf_HEM_GetGroupByTeam(@Team)
			IF UPPER(@GroupName) = UPPER(@Group)
			BEGIN
				INSERT INTO #team SELECT @Team
			END
			
			FETCH NEXT FROM cur INTO @Team
		END
		CLOSE cur
		DEALLOCATE cur
	END
	
	SELECT DISTINCT * FROM #team
	
	DROP TABLE #team
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO