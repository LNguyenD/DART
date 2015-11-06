SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_DART_Index]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_DART_Index]
GO

CREATE PROCEDURE [dbo].[usp_DART_Index]
AS
BEGIN
	
-------------------------------------------CPR Index-----------------------------------
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_Portfolio_RAW_Data') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_Portfolio_RAW_Data]
		ON [dbo].[EML_Portfolio] ([Reporting_Date])
		INCLUDE ([Id],[Group],[Team],[Case_Manager],[Agency_Name],[Agency_Id],[Policy_No],[Sub_Category],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claim_No],[WIC_Code],[Company_Name],[Worker_Name],[Employee_Number],[Worker_Phone_Number],[Claims_Officer_Name],[Date_Of_Birth],[Date_Of_Injury],[Date_Of_Notification],[Notification_Lag],[Entered_Lag],[Claim_Liability_Indicator_Group],[Investigation_Incurred],[Total_Paid],[Is_Time_Lost],[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received],[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid],[Acupuncture_Paid],[Create_Date],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt],[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week],[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[Action_Required],[RTW_Impacting],[Weeks_In],[Weeks_Band],[Hindsight],[Active_Weekly],[Active_Medical],[Cost_Code],[Cost_Code2],[CC_Injury],[CC_Current],[Med_Cert_Status_This_Week],[Med_Cert_Status_Next_Week],[Capacity],[Entitlement_Weeks],[Med_Cert_Status_Prev_1_Week],[Med_Cert_Status_Prev_2_Week],[Med_Cert_Status_Prev_3_Week],[Med_Cert_Status_Prev_4_Week],[Is_Last_Month])
	END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_Portfolio_Reporting_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_Portfolio_Reporting_Date]
		ON [dbo].[EML_Portfolio] ([Reporting_Date])
		INCLUDE ([Group],[Team],[Agency_Name],[Sub_Category],[Claim_No],[Claims_Officer_Name],[Date_Of_Injury],
					 [Claim_Liability_Indicator_Group],  
					 [Is_Time_Lost],  
					 [Claim_Closed_Flag],  
					 [Date_Claim_Entered],  
					 [Date_Claim_Closed],  
					 [Date_Claim_Received],  
					 [Date_Claim_Reopened],  
					 [Result_Of_Injury_Code],  
					 [WPI],  
					 [Common_Law],  
					 [Total_Recoveries],  
					 [Is_Working],  
					 [Physio_Paid],  
					 [Chiro_Paid],  
					 [Massage_Paid],  
					 [Osteopathy_Paid],  
					 [Acupuncture_Paid],  
					 [Is_Stress],  
					 [Is_Inactive_Claims],  
					 [Is_Medically_Discharged],  
					 [Is_Exempt],  
					 [Is_Reactive],  
					 [Is_Medical_Only],  
					 [Is_D_D],  
					 [NCMM_Actions_This_Week],  
					 [NCMM_Actions_Next_Week],  
					 [HoursPerWeek],  
					 [Is_Industrial_Deafness],  
					 [Rehab_Paid],
					 [Med_Cert_Status_This_Week],
					 [Is_Last_Month]
		 ) 
			
	END	
	
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_Portfolio_RAW_Data') 
	BEGIN		
		CREATE NONCLUSTERED INDEX [idx_TMF_Portfolio_RAW_Data]
		ON [dbo].[TMF_Portfolio] ([Reporting_Date])
		INCLUDE ([Id],[Group],[Team],[Case_Manager],[Agency_Name],[Agency_Id],[Policy_No],[Sub_Category],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claim_No],[WIC_Code],[Company_Name],[Worker_Name],[Employee_Number],[Worker_Phone_Number],[Claims_Officer_Name],[Date_Of_Birth],[Date_Of_Injury],[Date_Of_Notification],[Notification_Lag],[Entered_Lag],[Claim_Liability_Indicator_Group],[Investigation_Incurred],[Total_Paid],[Is_Time_Lost],[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received],[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid],[Acupuncture_Paid],[Create_Date],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt],[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week],[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[Action_Required],[RTW_Impacting],[Weeks_In],[Weeks_Band],[Hindsight],[Active_Weekly],[Active_Medical],[Cost_Code],[Cost_Code2],[CC_Injury],[CC_Current],[Med_Cert_Status_This_Week],[Med_Cert_Status_Next_Week],[Capacity],[Entitlement_Weeks],[Med_Cert_Status_Prev_1_Week],[Med_Cert_Status_Prev_2_Week],[Med_Cert_Status_Prev_3_Week],[Med_Cert_Status_Prev_4_Week],[Is_Last_Month])
	END	
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_Portfolio_Reporting_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_Portfolio_Reporting_Date]
		ON [dbo].[TMF_Portfolio] ([Reporting_Date])
		INCLUDE ([Group],[Team],[Agency_Name],[Sub_Category],[Claim_No],[Claims_Officer_Name],[Date_Of_Injury],
					 [Claim_Liability_Indicator_Group],  
					 [Is_Time_Lost],  
					 [Claim_Closed_Flag],  
					 [Date_Claim_Entered],  
					 [Date_Claim_Closed],  
					 [Date_Claim_Received],  
					 [Date_Claim_Reopened],  
					 [Result_Of_Injury_Code],  
					 [WPI],  
					 [Common_Law],  
					 [Total_Recoveries],  
					 [Is_Working],  
					 [Physio_Paid],  
					 [Chiro_Paid],  
					 [Massage_Paid],  
					 [Osteopathy_Paid],  
					 [Acupuncture_Paid],  
					 [Is_Stress],  
					 [Is_Inactive_Claims],  
					 [Is_Medically_Discharged],  
					 [Is_Exempt],  
					 [Is_Reactive],  
					 [Is_Medical_Only],  
					 [Is_D_D],  
					 [NCMM_Actions_This_Week],  
					 [NCMM_Actions_Next_Week],  
					 [HoursPerWeek],  
					 [Is_Industrial_Deafness],  
					 [Rehab_Paid],
					 [Med_Cert_Status_This_Week],
					 [Is_Last_Month]
		 ) 
			
	END	
	
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_Portfolio_RAW_Data') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_Portfolio_RAW_Data]
		ON [dbo].[HEM_Portfolio] ([Reporting_Date])
		INCLUDE ([Id],[Group],[Team],[Case_Manager],[Agency_Name],[Agency_Id],[Policy_No],[Sub_Category],[EMPL_SIZE],[Account_Manager],[Portfolio],[Claim_No],[WIC_Code],[Company_Name],[Worker_Name],[Employee_Number],[Worker_Phone_Number],[Claims_Officer_Name],[Date_Of_Birth],[Date_Of_Injury],[Date_Of_Notification],[Notification_Lag],[Entered_Lag],[Claim_Liability_Indicator_Group],[Investigation_Incurred],[Total_Paid],[Is_Time_Lost],[Claim_Closed_Flag],[Date_Claim_Entered],[Date_Claim_Closed],[Date_Claim_Received],[Date_Claim_Reopened],[Result_Of_Injury_Code],[WPI],[Common_Law],[Total_Recoveries],[Is_Working],[Physio_Paid],[Chiro_Paid],[Massage_Paid],[Osteopathy_Paid],[Acupuncture_Paid],[Create_Date],[Is_Stress],[Is_Inactive_Claims],[Is_Medically_Discharged],[Is_Exempt],[Is_Reactive],[Is_Medical_Only],[Is_D_D],[NCMM_Actions_This_Week],[NCMM_Actions_Next_Week],[HoursPerWeek],[Is_Industrial_Deafness],[Rehab_Paid],[Action_Required],[RTW_Impacting],[Weeks_In],[Weeks_Band],[Hindsight],[Active_Weekly],[Active_Medical],[Cost_Code],[Cost_Code2],[CC_Injury],[CC_Current],[Med_Cert_Status_This_Week],[Med_Cert_Status_Next_Week],[Capacity],[Entitlement_Weeks],[Med_Cert_Status_Prev_1_Week],[Med_Cert_Status_Prev_2_Week],[Med_Cert_Status_Prev_3_Week],[Med_Cert_Status_Prev_4_Week],[Is_Last_Month])
	END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_Portfolio_Reporting_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_Portfolio_Reporting_Date]
		ON [dbo].[HEM_Portfolio] ([Reporting_Date])
		INCLUDE ([Group],[Team],[Agency_Name],[Sub_Category],[Claim_No],[Claims_Officer_Name],[Date_Of_Injury],
					 [Claim_Liability_Indicator_Group],  
					 [Is_Time_Lost],  
					 [Claim_Closed_Flag],  
					 [Date_Claim_Entered],  
					 [Date_Claim_Closed],  
					 [Date_Claim_Received],  
					 [Date_Claim_Reopened],  
					 [Result_Of_Injury_Code],  
					 [WPI],  
					 [Common_Law],  
					 [Total_Recoveries],  
					 [Is_Working],  
					 [Physio_Paid],  
					 [Chiro_Paid],  
					 [Massage_Paid],  
					 [Osteopathy_Paid],  
					 [Acupuncture_Paid],  
					 [Is_Stress],  
					 [Is_Inactive_Claims],  
					 [Is_Medically_Discharged],  
					 [Is_Exempt],  
					 [Is_Reactive],  
					 [Is_Medical_Only],  
					 [Is_D_D],  
					 [NCMM_Actions_This_Week],  
					 [NCMM_Actions_Next_Week],  
					 [HoursPerWeek],  
					 [Is_Industrial_Deafness],  
					 [Rehab_Paid],
					 [Med_Cert_Status_This_Week],
					 [Is_Last_Month]
		 ) 
			
	END	

--------------------------------------------RTW index----------------------------------------
----EML----
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Measure_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Measure_Group] ON [dbo].[EML_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Group] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Measure_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Measure_Acc] ON [dbo].[EML_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Account_Manager] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Measure_EMPL') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Measure_EMPL] ON [dbo].[EML_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[EMPL_Size] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RAW_Data') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_RTW_RAW_Data]
		ON [dbo].[EML_RTW] ([Remuneration_End])
		INCLUDE ([Remuneration_Start],[Group],[Team],[Case_manager],[Claim_no],[DTE_OF_INJURY],[POLICY_NO],[LT],[WGT],[EMPL_SIZE],[Weeks_paid],[AgencyName],[Sub_Category],[Measure],[Cert_Type],[Med_cert_From],[Med_cert_To],[Account_Manager],[Cell_no],[Portfolio],[Stress],[Liability_Status],[cost_code],[cost_code2],[Claim_Closed_flag])
	END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_Acc_RT_Measure_EMPL') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_Acc_RT_Measure_EMPL] ON [dbo].[EML_RTW] 
	(
		[Remuneration_End] ASC,
		[Account_Manager] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[EMPL_SIZE] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_Group_RT_Measure_Team') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_Group_RT_Measure_Team] ON [dbo].[EML_RTW] 
	(
		[Remuneration_End] ASC,
		[Group] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Team] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

---TMF----
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_RS_Measure_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_RS_Measure_Group] ON [dbo].[TMF_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Group] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_RS_Measure_Agency') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_RS_Measure_Agency] ON [dbo].[TMF_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[AgencyName] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RAW_Data')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RAW_Data]
		ON [dbo].[TMF_RTW] ([Remuneration_End])
		INCLUDE ([Remuneration_Start],[Group],[Team],[Case_manager],[Claim_no],[DTE_OF_INJURY],[POLICY_NO],[LT],[WGT],[EMPL_SIZE],[Weeks_paid],[AgencyName],[Sub_Category],[Measure],[Cert_Type],[Med_cert_From],[Med_cert_To],[Account_Manager],[Cell_no],[Portfolio],[Stress],[Liability_Status],[cost_code],[cost_code2],[Claim_Closed_flag])
	END	
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_RS_Measure_Team_Group')
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_RS_Measure_Team_Group] ON [dbo].[TMF_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Team] ASC,
		[Group] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_RS_Measure_Sub_Agency') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_RS_Measure_Sub_Agency] ON [dbo].[TMF_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Sub_Category] ASC,
		[AgencyName] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

----HEM---
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Group] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Group] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Acc] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Account_Manager] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Portfolio') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Portfolio] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RAW_Data') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RAW_Data]
		ON [dbo].[HEM_RTW] ([Remuneration_End])
		INCLUDE ([Remuneration_Start],[Group],[Team],[Case_manager],[Claim_no],[DTE_OF_INJURY],[POLICY_NO],[LT],[WGT],[EMPL_SIZE],[Weeks_paid],[AgencyName],[Sub_Category],[Measure],[Cert_Type],[Med_cert_From],[Med_cert_To],[Account_Manager],[Cell_no],[Portfolio],[Stress],[Liability_Status],[cost_code],[cost_code2],[Claim_Closed_flag])
	END
	
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC
	)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Team_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Team_Group] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[Team] ASC,
		[Group] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_EMPL_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_EMPL_Acc] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[EMPL_SIZE] ASC,
		[Account_Manager] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_EMPL_Portfolio') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_EMPL_Portfolio] ON [dbo].[HEM_RTW] 
	(
		[Remuneration_End] ASC,
		[Remuneration_Start] ASC,
		[Measure] ASC,
		[EMPL_SIZE] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [LT],
	[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]


END

---------------------------------------AWC Index----------------------------------	
---+++EML+++-------
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Group_Time_ID_Claim_No_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Group_Time_ID_Claim_No_Acc] ON [dbo].[EML_AWC] 
	(
		[Group] ASC,
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Account_Manager] ASC
	)
	INCLUDE ( [Team],
	[Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Projection_Unit_Type_Type') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Projection_Unit_Type_Type] ON [dbo].[EML_AWC_Projections] 
	(
		[Unit_Type] ASC,
		[Type] ASC
	)
	INCLUDE ( [Unit_Name],
	[Time_Id],
	[Projection]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Claim_No_Time_ID_Account_Manager_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Claim_No_Time_ID_Account_Manager_Group] ON [dbo].[EML_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC,
		[Account_Manager] ASC,
		[Group] ASC
	)
	INCLUDE ( [Team],
	[Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Group] ON [dbo].[EML_AWC] 
	(
		[Group] ASC
	)
	INCLUDE ( [Team],
	[EMPL_SIZE],
	[Account_Manager]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Claim_No_Time_ID_Include') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Claim_No_Time_ID_Include] ON [dbo].[EML_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[EMPL_SIZE],
	[Account_Manager]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_No_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_No_Group] ON [dbo].[EML_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Group] ASC
	)
	INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_No_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_No_Acc] ON [dbo].[EML_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Account_Manager] ASC
	)
	INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_No') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_No] ON [dbo].[EML_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Claim_no_Time_ID') 	
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Claim_no_Time_ID] ON [dbo].[EML_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC
	)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID') 	
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID]
	ON [dbo].[EML_AWC] ([Time_ID] ASC) 
	INCLUDE ([Claim_no],[Date_of_Injury],[EMPL_SIZE],[Account_Manager])
	WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
	
---+++TMF+++-------
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Time_ID_Claim_No_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Time_ID_Claim_No_Group] ON [dbo].[TMF_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Group] ASC
	)
	INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Claim_No_Group_Time_ID') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Claim_No_Group_Time_ID] ON [dbo].[TMF_AWC] 
	(		
		[Claim_no] ASC,
		[Group] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Team],[Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Time_ID_Claim_No') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Time_ID_Claim_No] ON [dbo].[TMF_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Claim_no_Time_ID') 	
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Claim_no_Time_ID] ON [dbo].[TMF_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC
	)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Group_Sub') 
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Group_Sub] ON [dbo].[TMF_AWC] 
	(
		[Group] ASC,
		[Sub_Category] ASC
	)
	INCLUDE ( [Team],
	[AgencyName]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Sub_Time_ID_Claim_No_Group') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Sub_Time_ID_Claim_No_Group] ON [dbo].[TMF_AWC] 
	(
		[Sub_Category] ASC,
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Group] ASC
	)
	INCLUDE ( [Team],[AgencyName],
	[Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Group_Time_ID_Claim_No_Sub') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Group_Time_ID_Claim_No_Sub] ON [dbo].[TMF_AWC] 
	(	
		[Group] ASC,
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Sub_Category] ASC
	)
	INCLUDE ( [Team],[AgencyName],
	[Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Projections_Unit_Type_Type') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Projections_Unit_Type_Type] ON [dbo].[TMF_AWC_Projections] 
	(
		[Unit_Type] ASC,
		[Type] ASC
	)
	INCLUDE ( [Unit_Name],
	[Time_Id],
	[Projection]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

---+++HEM+++-------
IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_No_Time_ID_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_No_Time_ID_Acc] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC,
		[Account_Manager] ASC
	)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_Claim_No_Time_ID') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_Claim_No_Time_ID] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[Account_Manager]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_No_Portfolio_Time_ID') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_No_Portfolio_Time_ID] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Portfolio] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_No_Acc') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_No_Acc] ON [dbo].[HEM_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Account_Manager] ASC
	)
	INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_No_Time_ID_Group_Date_of_Injury') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_No_Time_ID_Group_Date_of_Injury] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Group],
	[Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_No_Group_Time_ID') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_No_Group_Time_ID] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Group] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Team],
	[Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_No_Acc_Time_ID') 	
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_No_Acc_Time_ID] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Account_Manager] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_No_Portfolio') 	
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_No_Portfolio] ON [dbo].[HEM_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_No_Portfolio_Time_ID_Date_of_Injury_EMPL') 
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_No_Portfolio_Time_ID_Date_of_Injury_EMPL] ON [dbo].[HEM_AWC] 
	(
		[Claim_no] ASC,
		[Portfolio] ASC,
		[Time_ID] ASC
	)
	INCLUDE ( [Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Group_Acc_Portfolio') 
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Group_Acc_Portfolio] ON [dbo].[HEM_AWC] 
	(
		[Group] ASC,
		[Account_Manager] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [Team],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Group_Time_ID_Claim_No_Acc_Portfolio') 
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Group_Time_ID_Claim_No_Acc_Portfolio] ON [dbo].[HEM_AWC] 
	(
		[Group] ASC,
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Account_Manager] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [Team],
	[Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_No_Group_Acc_Portfolio') 
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_No_Group_Acc_Portfolio] ON [dbo].[HEM_AWC] 
	(
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Group] ASC,
		[Account_Manager] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [Team],
	[Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Acc_Time_ID_Claim_No_Group_Portfolio') 
BEGIN	
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Acc_Time_ID_Claim_No_Group_Portfolio] ON [dbo].[HEM_AWC] 
	(
		[Account_Manager] ASC,
		[Time_ID] ASC,
		[Claim_no] ASC,
		[Group] ASC,
		[Portfolio] ASC
	)
	INCLUDE ( [Team],
	[Date_of_Injury],
	[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

END

IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Projection_Unit_Type_Type') 
BEGIN
	CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Projection_Unit_Type_Type] ON [dbo].[HEM_AWC_Projections] 
	(
		[Unit_Type] ASC,
		[Type] ASC
	)
	INCLUDE ( [Unit_Name],
	[Time_Id],
	[Projection]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO