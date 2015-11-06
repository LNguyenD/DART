SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_GetGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_GetGroups]
GO

CREATE PROCEDURE [dbo].usp_GetGroups(@System varchar(20))
AS
BEGIN	
	DECLARE @Team varchar(20)
	
	/* create group table */
	IF OBJECT_ID('tempdb..#group') IS NULL
	BEGIN
		CREATE TABLE #group
		(
			[Group] varchar(20)
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
			INSERT INTO #group SELECT dbo.udf_TMF_GetGroupByTeam(@Team)
			
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
			INSERT INTO #group SELECT dbo.udf_EML_GetGroupByTeam(@Team)
			
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
			INSERT INTO #group SELECT dbo.udf_HEM_GetGroupByTeam(@Team)
			
			FETCH NEXT FROM cur INTO @Team
		END
		CLOSE cur
		DEALLOCATE cur
	END
	
	SELECT DISTINCT * FROM #group
	
	DROP TABLE #group
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO