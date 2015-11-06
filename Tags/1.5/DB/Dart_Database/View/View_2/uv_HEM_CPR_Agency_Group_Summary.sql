SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_CPR_Agency_Group_Summary')
	DROP VIEW [dbo].[uv_HEM_CPR_Agency_Group_Summary]
GO
CREATE VIEW [dbo].[uv_HEM_CPR_Agency_Group_Summary]
AS
SELECT	top 1	EmployerSize_Group = 'Hospitality'
				,[Type] = 'portfolio'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)

UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM(Portfolio)
				,[Type] = 'portfolio'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = Portfolio)
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = Portfolio)
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = Portfolio)
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY Portfolio 
ORDER BY Portfolio

--Portfolio Hotel summary--
UNION ALL

SELECT top 1 EmployerSize_Group = 'Hotel'
				,[Type] = 'portfolio'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value in ('Accommodation','Pubs, Taverns and Bars'))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value in ('Accommodation','Pubs, Taverns and Bars'))
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'portfolio', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value in ('Accommodation','Pubs, Taverns and Bars'))
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)

UNION ALL

SELECT top 1 EmployerSize_Group = 'Hospitality'
				,[Type] = 'group'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'group', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)

UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM([Group])
				,[Type] = 'group'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'group', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Group])
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = [Group])
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Group])
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Group]
ORDER BY [Group]

UNION ALL

SELECT top 1 EmployerSize_Group = 'Hospitality'
				,[Type] = 'account_manager'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
        and [Account_Manager] is not null

UNION ALL

SELECT top 1000 EmployerSize_Group = RTRIM([Account_Manager])
				,[Type] = 'account_manager'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Account_Manager])
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = [Account_Manager])
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('HEM', 'account_manager', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Account_Manager])
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
        and [Account_Manager] is not null
        and Claim_Closed_Flag <> 'Y'
GROUP BY [Account_Manager]
ORDER BY [Account_Manager]
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO