SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_CPR_Team_Sub_Summary')
	DROP VIEW [dbo].[uv_HEM_CPR_Team_Sub_Summary]
GO
CREATE VIEW [dbo].[uv_HEM_CPR_Team_Sub_Summary] 
AS
SELECT		top 1000000
			[Type] = 'group'
			,EmployerSize_Group = dbo.udf_HEM_GetGroupByTeam(Team)
			,Team_Sub = rtrim(Team)
            ,No_Of_New_Claims = 0
        --            (SELECT     COUNT(distinct Claim_No)
        --                FROM	[dbo].[udf_CPR_Overall]('HEM', 'group', 0)
        --                WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and Value = dbo.udf_HEM_GetGroupByTeam(Team)
								--and SubValue = Team)
            ,No_Of_Open_Claims =
                    (SELECT     COUNT(distinct Claim_No)
                        FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
                        WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
								and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
								and Claim_Closed_Flag <> 'Y'
								and Value = dbo.udf_HEM_GetGroupByTeam(Team)
								and SubValue = Team)
            ,No_Of_Claim_Closures = 0
        --            (SELECT     COUNT(distinct Claim_No)
        --                FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
        --                WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and Value = dbo.udf_HEM_GetGroupByTeam(Team)
								--and SubValue = Team)
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY dbo.udf_HEM_GetGroupByTeam(Team), Team
ORDER BY Team

UNION ALL

SELECT		top 1000000
			[Type] = 'account_manager'
			,EmployerSize_Group = RTRIM([Account_Manager])
			,Team_Sub = rtrim(EMPL_SIZE)
			,No_Of_New_Claims = 0
        --            (SELECT     COUNT(distinct Claim_No)
        --                FROM	[dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
        --                WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and Value = [Account_Manager]
								--and SubValue = EMPL_SIZE)
            ,No_Of_Open_Claims =
                    (SELECT     COUNT(distinct Claim_No)
                        FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
                        WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
								and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
								and Claim_Closed_Flag <> 'Y'
								and Value = [Account_Manager]
								and SubValue = EMPL_SIZE)
            ,No_Of_Claim_Closures = 0
        --            (SELECT     COUNT(distinct Claim_No)
        --                FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
        --                WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and Value = [Account_Manager]
								--and SubValue = EMPL_SIZE)
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
        and RTRIM([Account_Manager]) is not null
        and Claim_Closed_Flag <> 'Y'
GROUP BY [Account_Manager], Empl_Size
ORDER BY Empl_Size

UNION ALL

SELECT		top 1000000
			[Type] = 'portfolio'
			,EmployerSize_Group = RTRIM([Portfolio])
			,Team_Sub = rtrim(EMPL_SIZE)
			,No_Of_New_Claims = 0
        --            (SELECT     COUNT(distinct Claim_No)
        --                FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
        --                WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and Value = [Portfolio]
								--and SubValue = EMPL_SIZE)
            ,No_Of_Open_Claims =
                    (SELECT     COUNT(distinct Claim_No)
                        FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
                        WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
								and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
								and Claim_Closed_Flag <> 'Y'
								and Value = [Portfolio]
								and SubValue = EMPL_SIZE)
            ,No_Of_Claim_Closures = 0
        --            (SELECT     COUNT(distinct Claim_No)
        --                FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
        --                WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
								--and Value = [Portfolio]
								--and SubValue = EMPL_SIZE)
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
        and RTRIM([portfolio]) is not null
        and Claim_Closed_Flag <> 'Y'
GROUP BY [portfolio], Empl_Size
ORDER BY Empl_Size

--Uncomment this section to active the combine grouping logic--
----Portfolio Hotel Summay--
--UNION ALL

--SELECT		top 1000000   
--			[Type] = 'portfolio'
--			,EmployerSize_Group = 'Hotel'
--			,Team_Sub = rtrim(EMPL_SIZE)
--			,No_Of_New_Claims =
--                    (SELECT     COUNT(distinct Claim_No)
--                        FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
--                        WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--								and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--								and Value in ('Accommodation','Pubs, Taverns and Bars')
--								and SubValue = EMPL_SIZE)
--            ,No_Of_Open_Claims =
--                    (SELECT     COUNT(distinct Claim_No)
--                        FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
--                        WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
--								and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
--								and Claim_Closed_Flag <> 'Y'
--								and Value in ('Accommodation','Pubs, Taverns and Bars')
--								and SubValue = EMPL_SIZE)
--            ,No_Of_Claim_Closures =
--                    (SELECT     COUNT(distinct Claim_No)
--                        FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
--                        WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--								and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--								and Value in ('Accommodation','Pubs, Taverns and Bars')
--								and SubValue = EMPL_SIZE)
--FROM	HEM_Portfolio
--WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
--        and RTRIM([portfolio]) is not null
--        and RTRIM([Portfolio]) in ('Accommodation','Pubs, Taverns and Bars')
--GROUP BY [portfolio], Empl_Size
--ORDER BY Empl_Size
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO