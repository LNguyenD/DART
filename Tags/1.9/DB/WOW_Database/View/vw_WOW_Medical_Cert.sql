SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS(SELECT * FROM sys.views WHERE name = 'vw_WOW_Medical_Cert')
	DROP VIEW [dbo].[vw_WOW_Medical_Cert]
GO
	CREATE VIEW [dbo].[vw_WOW_Medical_Cert] 
	AS
    SELECT  /*ID,OWNER,*/
		  M.CLAIM AS CLAIM_NO,M.FITNESS AS TYPE,
		/*                IS_PROTECTED,IS_DELETED,PROCESSED4SI,*/
		  M.COMMENT AS DIAGNOSIS,
		/*                TREATMENT_PLAN,RESTRICTIONS,CANCELLED_BY,TREATMENT_LIST,RESTRICTION_LIST,*/
		  M.PROVIDERNAME AS DOCTOR_NAME,
		/*                PROCESS_FLAGS,SOURCE,*/
		  M.PERIODFOR AS EFFECT_DAYS, M.HOURSWEEK AS HOURS_PER_WEEK,
		  CONVERT(DATE,M.DateEntered)  AS CREATE_DTE,
		  CONVERT(TIME(0),M.DateEntered) AS TIME_CREATE,
		  CONVERT(DATE,M.FromDate) AS DTE_FROM, 
		  CONVERT(DATE,M.UntilDate) AS DTE_TO,
		  NULL AS CANCELLED_DTE, 
		/*                RECEIVED_DTE,EFFECT_DTE_FROM,EFFECT_DTE_TO,*/
		  CONVERT(DATE,M.DateSeen) AS EXAMINATION_DTE
	FROM MED_CERT AS M
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO