SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_CPR_ClaimOfficer_Summary')
	DROP VIEW [dbo].[uv_HEM_CPR_ClaimOfficer_Summary]
GO
CREATE VIEW [dbo].[uv_HEM_CPR_ClaimOfficer_Summary]
AS
SELECT		top 1000000
			[Type] = 'group'
			,EmployerSize_Group = RTRIM([Group])
			,Team_Sub = RTRIM(Team)
			,ClaimOfficer = RTRIM(Claims_Officer_Name)
            ,No_Of_New_Claims = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM	[dbo].[udf_CPR_Overall]('HEM', 'group', 0)
       --             WHERE	Date_Claim_Received between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Group]
							--and SubValue = Team
							--and SubValue2 = Claims_Officer_Name)
            ,No_Of_Open_Claims =
                (SELECT     COUNT(distinct Claim_No)
                    FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
                    WHERE	(Date_Claim_Closed is null or Date_Claim_Closed < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and (Date_Claim_Reopened is null or Date_Claim_Reopened < DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106))))
							and Claim_Closed_Flag <> 'Y'
							and Value = [Group]
							and SubValue = Team
							and SubValue2 = Claims_Officer_Name)
            ,No_Of_Claim_Closures = 0
       --         (SELECT     COUNT(distinct Claim_No)
       --             FROM    [dbo].[udf_CPR_Overall]('HEM', 'group', 0)
       --             WHERE   Date_Claim_Closed between DATEADD(d, -15, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and DATEADD(d, -1, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
							--and Value = [Group]
							--and SubValue = Team
							--and SubValue2 = Claims_Officer_Name)
FROM	HEM_Portfolio
WHERE	Reporting_Date = (select MAX(Reporting_Date) from HEM_Portfolio)
		and Claim_Closed_Flag <> 'Y'
GROUP BY [Group], Team, Claims_Officer_Name
ORDER BY Claims_Officer_Name
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO