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
	SELECT  System='TMF',Med_Cert_Status=Med_Cert_Status_This_Week,*,
		[Grouping] = case when RTRIM(Agency_Name) in ('Health', 'Other')
							then 'HEALTH & OTHER'
						when RTRIM(Agency_Name) in ('Police', 'Fire')
							then 'POLICE & FIRE'
						else ''
					end
		FROM dbo.TMF_Portfolio
		WHERE isnull(Is_Last_Month,0) =0
		 
	UNION ALL
	
	SELECT  System='HEM',Med_Cert_Status=Med_Cert_Status_This_Week,*, 
		[Grouping] = case when RTRIM(Portfolio) in ('Accommodation', 'Pubs, Taverns and Bars')
							then 'Hotel'
						else ''
					end 
		FROM dbo.HEM_Portfolio
		WHERE isnull(Is_Last_Month,0) =0
	
	UNION ALL
	
	SELECT  System='EML',Med_Cert_Status=Med_Cert_Status_This_Week,*, [Grouping] = ''
		FROM dbo.EML_Portfolio
		WHERE isnull(Is_Last_Month,0) =0
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO