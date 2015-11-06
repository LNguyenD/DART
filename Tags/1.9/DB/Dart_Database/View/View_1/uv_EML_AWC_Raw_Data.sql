SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Raw_Data')
	DROP VIEW [dbo].[uv_EML_AWC_Raw_Data]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Raw_Data] 
AS
SELECT    Time_ID
		, Claim_no
		, Team
		, [Group] = dbo.udf_EML_GetGroupByTeam(Team)
		, Sub_Category = ''
		, Employer_Size = RTRIM(Empl_Size)
		, Date_of_Injury
		,Cert_Type
		,Med_cert_From
		,Med_cert_To
		,Account_Manager
		,Portfolio
		,Cell_no
FROM    dbo.EML_AWC
WHERE    (Time_ID >= DATEADD(mm, - 2,DATEADD(yy, DATEDIFF(yy,0,GETDATE()), 0)))
                          
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO