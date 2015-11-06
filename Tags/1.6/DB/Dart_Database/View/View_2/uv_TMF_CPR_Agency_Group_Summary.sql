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
FROM	TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)

UNION ALL

SELECT  top 1000 Agency_Group = rtrim(isnull(sub.AgencyName,'Miscellaneous'))
				,[Type] = 'agency'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = rtrim(isnull(sub.AgencyName,'Miscellaneous')))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = rtrim(isnull(sub.AgencyName,'Miscellaneous')))
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = rtrim(isnull(sub.AgencyName,'Miscellaneous')))
FROM	TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY rtrim(isnull(sub.AgencyName,'Miscellaneous'))
ORDER BY rtrim(isnull(sub.AgencyName,'Miscellaneous'))

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
		 
SELECT top 1000 Agency_Group = rtrim(isnull(sub.[Group],'Miscellaneous'))
				,[Type] = 'group'
                ,No_Of_New_Claims = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM	[dbo].[udf_CPR_Overall]('TMF', 'group', 0)
         --                   WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = rtrim(isnull(sub.[Group],'Miscellaneous')))
                ,No_Of_Open_Claims =
                        (SELECT     COUNT(distinct Claim_No)
                            FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
                            WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
									and Claim_Closed_Flag <> 'Y'
									and Value = rtrim(isnull(sub.[Group],'Miscellaneous')))
                ,No_Of_Claim_Closures = 0
         --               (SELECT     COUNT(distinct Claim_No)
         --                   FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
         --                   WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
									--and Value = rtrim(isnull(sub.[Group],'Miscellaneous')))
FROM	TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY rtrim(isnull(sub.[Group],'Miscellaneous'))
ORDER BY CASE IsNumeric(rtrim(isnull(sub.[Group],'Miscellaneous'))) 
			WHEN 1 THEN Replicate('0', 100 - Len(rtrim(isnull(sub.[Group],'Miscellaneous')))) + rtrim(isnull(sub.[Group],'Miscellaneous'))
			ELSE rtrim(isnull(sub.[Group],'Miscellaneous'))
		 END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO