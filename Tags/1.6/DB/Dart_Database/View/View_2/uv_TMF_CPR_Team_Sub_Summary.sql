SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_CPR_Team_Sub_Summary')
	DROP VIEW [dbo].[uv_TMF_CPR_Team_Sub_Summary]
GO
CREATE VIEW [dbo].[uv_TMF_CPR_Team_Sub_Summary]
AS
SELECT		top 1000000
			[Type] = 'agency'
			,Agency_Group = rtrim(isnull(sub.AgencyName,'Miscellaneous'))
			,Team_Sub = rtrim(isnull(sub.Sub_Category,'Miscellaneous'))
			,No_Of_New_Claims = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
       --             WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = rtrim(isnull(sub.AgencyName,'Miscellaneous'))
							--and SubValue = rtrim(isnull(sub.Sub_Category,'Miscellaneous')))
            ,No_Of_Open_Claims =
                (SELECT     COUNT(distinct Claim_No)
                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and Claim_Closed_Flag <> 'Y'
							and Value = rtrim(isnull(sub.AgencyName,'Miscellaneous'))
							and SubValue = rtrim(isnull(sub.Sub_Category,'Miscellaneous')))
            ,No_Of_Claim_Closures = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
       --             WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = rtrim(isnull(sub.AgencyName,'Miscellaneous'))
							--and SubValue = rtrim(isnull(sub.Sub_Category,'Miscellaneous')))
FROM	TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on sub.POLICY_NO = uv.Policy_No
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY rtrim(isnull(sub.Sub_Category,'Miscellaneous')), rtrim(isnull(sub.AgencyName,'Miscellaneous'))
ORDER BY rtrim(isnull(sub.Sub_Category,'Miscellaneous'))

--Uncomment this to active the combine grouping logic--
----Agency Police & Fire--
--UNION ALL

--SELECT		top 1000000
--			[Type] = 'agency'
--			,Agency_Group = 'Police & Fire'
--			,Team_Sub = rtrim(Sub_Category)
--			,No_Of_New_Claims =
--                (SELECT     COUNT(distinct Claim_No)
--                    FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
--                    WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and Value in ('Police','Fire')
--							and SubValue = Sub_Category)
--            ,No_Of_Open_Claims =
--                (SELECT     COUNT(distinct Claim_No)
--                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
--                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
--							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
--							and Claim_Closed_Flag <> 'Y'
--							and Value in ('Police','Fire')
--							and SubValue = Sub_Category)
--            ,No_Of_Claim_Closures =
--                (SELECT     COUNT(distinct Claim_No)
--                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
--                    WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and Value in ('Police','Fire')
--							and SubValue = Sub_Category)
--FROM	TMF_Portfolio
--WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
--        AND RTRIM(Agency_Name) in ('Police','Fire')
--GROUP BY Sub_Category, Agency_Name
--ORDER BY Sub_Category

----Agency Health & Other--
--UNION ALL

--SELECT		top 1000000
--			[Type] = 'agency'
--			,Agency_Group = 'Health & Other'
--			,Team_Sub = rtrim(Sub_Category)
--			,No_Of_New_Claims =
--                (SELECT     COUNT(distinct Claim_No)
--                    FROM	[dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
--                    WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and Value in ('Health','Other')
--							and SubValue = Sub_Category)
--            ,No_Of_Open_Claims =
--                (SELECT     COUNT(distinct Claim_No)
--                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
--                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
--							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
--							and Claim_Closed_Flag <> 'Y'
--							and Value in ('Health','Other')
--							and SubValue = Sub_Category)
--            ,No_Of_Claim_Closures =
--                (SELECT     COUNT(distinct Claim_No)
--                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'agency', 0)
--                    WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
--							and Value in ('Health','Other')
--							and SubValue = Sub_Category)
--FROM	TMF_Portfolio
--WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
--        AND RTRIM(Agency_Name) in ('Health','Other')
--GROUP BY Sub_Category, Agency_Name
--ORDER BY Sub_Category

UNION ALL

SELECT		top 1000000
			[Type] = 'group'
			,Agency_Group = dbo.udf_TMF_GetGroupByTeam(Team)
			,Team_Sub = rtrim(Team)
            ,No_Of_New_Claims = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM	[dbo].[udf_CPR_Overall]('TMF', 'group', 0)
       --             WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = dbo.udf_TMF_GetGroupByTeam(Team)
							--and SubValue = Team)
            ,No_Of_Open_Claims =
                (SELECT     COUNT(distinct Claim_No)
                    FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and Claim_Closed_Flag <> 'Y'
							and Value = dbo.udf_TMF_GetGroupByTeam(Team)
							and SubValue = Team)
            ,No_Of_Claim_Closures = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM    [dbo].[udf_CPR_Overall]('TMF', 'group', 0)
       --             WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = dbo.udf_TMF_GetGroupByTeam(Team)
							--and SubValue = Team)
FROM	TMF_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from TMF_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY dbo.udf_TMF_GetGroupByTeam(Team), Team
ORDER BY Team
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO