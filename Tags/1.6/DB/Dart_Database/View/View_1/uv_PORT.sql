SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_PORT')
	DROP VIEW [dbo].[uv_PORT]
GO
CREATE VIEW [dbo].[uv_PORT]
AS
	SELECT  System='TMF',Med_Cert_Status=Med_Cert_Status_This_Week,rtrim(isnull(sub.AgencyName,'Miscellaneous')) as Agency_Name,rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Sub_Category
						,[Group] = dbo.udf_TMF_GetGroupByTeam(Team),sub.AgencyId as Agency_Id,uv.*,
		[Grouping] = case when rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health', 'Other')
							then 'HEALTH & OTHER'
						when rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police', 'Fire')
							then 'POLICE & FIRE'
						else ''
					end
		FROM dbo.TMF_Portfolio uv left join TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO		
		 
	UNION ALL
	
	SELECT  System='HEM',Med_Cert_Status=Med_Cert_Status_This_Week,Agency_Name = '',Sub_Category='',[Group] = dbo.udf_HEM_GetGroupByTeam(Team),Agency_Id = '',*, 
		[Grouping] = case when RTRIM(Portfolio) in ('Accommodation', 'Pubs, Taverns and Bars')
							then 'Hotel'
						else ''
					end 
		FROM dbo.HEM_Portfolio		
	
	UNION ALL
	
	SELECT  System='EML',Med_Cert_Status=Med_Cert_Status_This_Week,Agency_Name = '',Sub_Category='',[Group] = dbo.udf_EML_GetGroupByTeam(Team),Agency_Id = '',*, [Grouping] = ''
		FROM dbo.EML_Portfolio		
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO