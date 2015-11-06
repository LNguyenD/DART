SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS(SELECT * FROM sys.views WHERE name = 'vw_WOW_Claims_Officers')
	DROP VIEW [dbo].[vw_WOW_Claims_Officers]
GO
	CREATE VIEW [dbo].[vw_WOW_Claims_Officers]
	AS 
	SELECT
		P.UserID AS Officer_Id,
		RTRIM(SUBSTRING(P.FullName, 1, CASE WHEN (CHARINDEX(' ', P.Fullname) - 1) < 0
								THEN LEN(P.Fullname) ELSE CHARINDEX(' ', P.Fullname) - 1 END)) AS First_Name,
		LTRIM(SUBSTRING(P.FullName, CHARINDEX(' ', P.FullName) + 1, 100)) AS Last_Name,
		T.Name AS GRP,
		P.UserName AS Alias,
		CASE WHEN P.ActiveUser = 'Y' THEN 1 ELSE 0 END AS ACTIVE,
		P.CMWorkPhone AS Phone_No,
		P.EmailAddress,
		P.FullName AS Officer
	FROM	dbo.Permissn P LEFT JOIN dbo.UserTeams UT ON P.userid = UT.UserId
			LEFT JOIN dbo.Teams T ON UT.TeamId = T.Id
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO