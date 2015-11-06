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
	SELECT  [System] = 'TMF',
			Med_Cert_Status = Med_Cert_Status_This_Week,
			rtrim(isnull(sub.AgencyName,'Miscellaneous')) as Agency_Name,
			rtrim(isnull(sub.Sub_Category,'Miscellaneous')) as Sub_Category,
			[Group] = dbo.udf_TMF_GetGroupByTeam(Team),
			sub.AgencyId as Agency_Id,
			
			-- NCMM action complete
			NCMM_Complete_Action_Due_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Action_Due end,
			NCMM_Complete_Remaining_Days_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Remaining_Days end,
			
			-- NCMM action prepare
			NCMM_Actions_Next_Week_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Actions_Next_Week
										end,
			NCMM_Prepare_Action_Due_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Prepare_Action_Due
										end,
			NCMM_Prepare_Remaining_Days_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
													then NCMM_Prepare_Remaining_Days
											end,
			
			uv.*,
			Date_Status_Changed = null,
			Division = '',
			[State] = '',
			ClaimStatus = '',
			[Grouping] = case when rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Health', 'Other')
								then 'HEALTH & OTHER'
							when rtrim(isnull(sub.AgencyName,'Miscellaneous')) in ('Police', 'Fire', 'RFS')
								then 'POLICE & FIRE & RFS'
							else ''
						end			
			,Cost_Code4 = ''
			,Cost_Code5 = ''
			,Weeks_Since_DON = null
			,Injury_Type = ''
			,Mechanism_Of_Injury = ''
	FROM	dbo.TMF_Portfolio uv
			LEFT JOIN TMF_Agencies_Sub_Category sub on uv.POLICY_NO = sub.POLICY_NO
		 
	UNION ALL
	
	SELECT  [System] = 'HEM',
			Med_Cert_Status = Med_Cert_Status_This_Week,
			Agency_Name = '',
			Sub_Category = '',
			[Group] = dbo.udf_HEM_GetGroupByTeam(Team),
			Agency_Id = '',
			
			-- NCMM action complete
			NCMM_Complete_Action_Due_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Action_Due end,
			NCMM_Complete_Remaining_Days_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Remaining_Days end,
			
			-- NCMM action prepare
			NCMM_Actions_Next_Week_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Actions_Next_Week
										end,
			NCMM_Prepare_Action_Due_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Prepare_Action_Due
										end,
			NCMM_Prepare_Remaining_Days_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
													then NCMM_Prepare_Remaining_Days
											end,
			*,
			Date_Status_Changed = null,
			Division = '',
			[State] = '',
			ClaimStatus = '',
			[Grouping] = case when RTRIM(Portfolio) in ('Accommodation', 'Pubs, Taverns and Bars')
								then 'Hotel'
							else ''
						end			
			,Cost_Code4 = ''
			,Cost_Code5 = ''
			,Weeks_Since_DON = null
			,Injury_Type = ''
			,Mechanism_Of_Injury = ''
	FROM dbo.HEM_Portfolio
	
	UNION ALL
	
	SELECT  [System] = 'EML',
			Med_Cert_Status = Med_Cert_Status_This_Week,
			Agency_Name = '',
			Sub_Category = '',
			[Group] = dbo.udf_EML_GetGroupByTeam(Team),
			Agency_Id = '',
			
			-- NCMM action complete
			NCMM_Complete_Action_Due_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Action_Due end,
			NCMM_Complete_Remaining_Days_2 = case when NCMM_Actions_This_Week <> '' then NCMM_Complete_Remaining_Days end,
			
			-- NCMM action prepare
			NCMM_Actions_Next_Week_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Actions_Next_Week
										end,
			NCMM_Prepare_Action_Due_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
												then NCMM_Prepare_Action_Due
										end,
			NCMM_Prepare_Remaining_Days_2 = case when NCMM_Prepare_Action_Due BETWEEN DATEADD(week, 1, Reporting_Date) AND DATEADD(week, 3, Reporting_Date)
													then NCMM_Prepare_Remaining_Days
											end,
			*,
			Date_Status_Changed = null,
			Division = '',
			[State] = '',
			ClaimStatus = '',
			[Grouping] = ''
			,Cost_Code4 = ''
			,Cost_Code5 = ''
			,Weeks_Since_DON = null
			,Injury_Type = ''
			,Mechanism_Of_Injury = ''
	FROM dbo.EML_Portfolio
	
	UNION ALL
	
	SELECT [System] = 'WOW',
			Med_Cert_Status = Med_Cert_Status_This_Week,
			Agency_Name = '',
			Sub_Category = '',
			[Group],
			Agency_Id = '',
			
			-- NCMM action complete
			NCMM_Complete_Action_Due_2 = '',
			NCMM_Complete_Remaining_Days_2 = '',
			
			-- NCMM action prepare
			NCMM_Actions_Next_Week_2 = '',
			NCMM_Prepare_Action_Due_2 = '',
			NCMM_Prepare_Remaining_Days_2 = ''
			,Id
			,Team
			,Case_Manager
			,Policy_No
			,EMPL_SIZE = ''
			,Account_manager = ''
			,Portfolio = ''
			,Reporting_Date
			,Claim_No
			,WIC_Code
			,Company_Name
			,Worker_Name
			,Employee_Number
			,Worker_Phone_Number
			,Claims_Officer_Name
			,Date_Of_Birth
			,Date_Of_Injury
			,Date_Of_Notification
			,Notification_Lag
			,Entered_Lag
			,Claim_Liability_Indicator_Group
			,Investigation_Incurred
			,Total_Paid
			,Is_Time_Lost
			,Claim_Closed_Flag
			,Date_Claim_Entered
			,Date_Claim_Closed
			,Date_Claim_Received
			,Date_Claim_Reopened
			,Result_Of_Injury_Code
			,WPI
			,Common_Law
			,Total_Recoveries
			,Is_Working
			,Physio_Paid
			,Chiro_Paid
			,Massage_Paid
			,Osteopathy_Paid
			,Acupuncture_Paid
			,Create_Date
			,Is_Stress
			,Is_Inactive_Claims
			,Is_Medically_Discharged
			,Is_Exempt
			,Is_Reactive
			,Is_Medical_Only
			,Is_D_D
			,NCMM_Actions_This_Week
			,NCMM_Actions_Next_Week
			,HoursPerWeek
			,Is_Industrial_Deafness
			,Rehab_Paid
			,Action_Required
			,RTW_Impacting
			,Weeks_In
			,Weeks_Band
			,Hindsight
			,Active_Weekly
			,Active_Medical
			,Cost_Code
			,Cost_Code2
			,CC_Injury
			,CC_Current			
			,Med_Cert_Status_This_Week
			,Capacity
			,Entitlement_Weeks
			,Med_Cert_Status_Prev_1_Week
			,Med_Cert_Status_Prev_2_Week
			,Med_Cert_Status_Prev_3_Week
			,Med_Cert_Status_Prev_4_Week
			,Is_Last_Month
			,IsPreClosed
			,IsPreOpened
			,NCMM_Complete_Action_Due
			,NCMM_Complete_Remaining_Days
			,NCMM_Prepare_Action_Due
			,NCMM_Prepare_Remaining_Days			
			,Broker_Name = ''
			,Broker_No = ''
			,Date_Status_Changed
			,[Division] = Division
			,[State] = [State]
			,ClaimStatus
			,[Grouping] = ''
			,Cost_Code4
			,Cost_Code5
			,Weeks_Since_DON
			,Injury_Type
			,Mechanism_Of_Injury
	FROM dbo.WOW_Portfolio
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO