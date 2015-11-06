SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_CPR_Agency_Group_Summary')
	DROP VIEW [dbo].[uv_TMF_CPR_Agency_Group_Summary]
GO
CREATE VIEW [dbo].[uv_TMF_CPR_Agency_Group_Summary]
AS
SELECT   top 1  Agency_Group = 'TMF'
				,[Type] = 'agency'
				,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)

UNION ALL

SELECT  top 1000 Agency_Group = RTRIM(Agency_Name)
				,[Type] = 'agency'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = Agency_Name)
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = Agency_Name)
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = Agency_Name)
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY Agency_Name
ORDER BY Agency_Name

UNION ALL

--Agency Police & Fire--
SELECT  top 1 Agency_Group = 'POLICE & FIRE'
				,[Type] = 'agency'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value in ('Police','Fire'))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value in ('Police','Fire'))
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value in ('Police','Fire'))
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)

UNION ALL

--Agency Health & Other--
SELECT  top 1 Agency_Group = 'HEALTH & OTHER'
				,[Type] = 'agency'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value in ('Health','Other'))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value in ('Health','Other'))
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value in ('Health','Other'))
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)

UNION ALL

SELECT top 1 Agency_Group = 'TMF'
				,[Type] = 'group'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'group', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y')
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		 
UNION ALL
		 
SELECT top 1000 Agency_Group = RTRIM([Group])
				,[Type] = 'group'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'group', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Group])
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = [Group])
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = [Group])
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Group]
ORDER BY CASE IsNumeric([Group]) 
			WHEN 1 THEN Replicate('0', 100 - Len([Group])) + [Group]
			ELSE [Group] 
		 END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO