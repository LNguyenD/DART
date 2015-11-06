SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_TMF_AWC_Raw_Data')
	DROP VIEW [dbo].[uv_TMF_AWC_Raw_Data]
GO
CREATE VIEW [dbo].[uv_TMF_AWC_Raw_Data] 
AS
SELECT    Time_ID
		, Claim_no
		, Team
		, [Group] = dbo.udf_TMF_GetGroupByTeam(Team)
		, Sub_Category = RTRIM(ISNULL(sub.Sub_Category,'Miscellaneous'))
		, AgencyName = RTRIM(ISNULL(sub.AgencyName,'Miscellaneous'))
		, Date_of_Injury
		, Cert_Type
		, Med_cert_From
		, Med_cert_To
		, Account_Manager
		, Cell_no
		, Portfolio
FROM    dbo.TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
WHERE    (Time_ID >= DATEADD(mm, - 2,DATEADD(yy, DATEDIFF(yy,0,GETDATE()), 0)))
		
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO