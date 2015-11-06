SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_HEM_RTW_Raw_Data')
	DROP VIEW [dbo].[uv_HEM_RTW_Raw_Data]
GO
CREATE VIEW [dbo].[uv_HEM_RTW_Raw_Data] 
AS
	SELECT  Claim_Closed_flag
			,Remuneration_Start
			,Remuneration_End
			,Measure_months = Measure
			,[Group] = RTRIM([group])
			,Team
			,Sub_Category = RTRIM(Sub_Category)
			,Case_manager
			,AgencyName = RTRIM(AgencyName)
			,rtw.Claim_no
			,DTE_OF_INJURY 
			,rtw.POLICY_NO
			,LT= ROUND(LT, 2)
			,WGT=ROUND(WGT, 2)
			,EMPL_SIZE
			,Weeks_from_date_of_injury= DATEDIFF(week, DTE_OF_INJURY, Remuneration_End)
			,Weeks_paid= ROUND(Weeks_paid, 2)
			,Stress
			,Liability_Status
			,cost_code
			,cost_code2
			,Cert_Type
			,Med_cert_From
			,Med_cert_To
			,rtw.Account_Manager
			,Portfolio
			,Cell_no
	FROM dbo.HEM_RTW rtw 
	WHERE remuneration_End = (SELECT max(Remuneration_End) FROM  dbo.HEM_RTW)
		 AND  DATEDIFF(month, Remuneration_Start, Remuneration_End) + 1 =12  

GO 
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO