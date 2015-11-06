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
	Print ' Need to delete current index first if change mapping'
	---------------------- DROP INDEXES FIRST --------------------
	DECLARE @qry nvarchar(max);
	SELECT @qry = 
	(SELECT  'DROP INDEX ' + idx.name + ' ON ' + OBJECT_NAME(ID) + '; '
	FROM  sysindexes idx
	WHERE   idx.Name IS NOT null and idx.Name like 'idx_%'
	FOR XML PATH(''));
	EXEC sp_executesql @qry

	-------------------------------------- CPR INDEXES --------------------------------------
	--- EML ---	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_Portfolio_Reporting_Date')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_Portfolio_Reporting_Date] ON [dbo].[EML_Portfolio] 
		(
			[Reporting_Date] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_Portfolio_RAW_Data')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_Portfolio_RAW_Data] ON [dbo].[EML_Portfolio]
		(
			[Reporting_Date] ASC,
			[Med_Cert_Status_This_Week] ASC,
			[Id] ASC,
			[Team] ASC,
			[Case_Manager] ASC,
			[EMPL_SIZE] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ([Policy_No],
		[Portfolio],
		[Claim_No],
		[WIC_Code],
		[Company_Name],
		[Worker_Name],
		[Employee_Number],
		[Worker_Phone_Number],
		[Claims_Officer_Name],
		[Date_Of_Birth],
		[Date_Of_Injury],
		[Date_Of_Notification],
		[Notification_Lag],
		[Entered_Lag],
		[Claim_Liability_Indicator_Group],
		[Investigation_Incurred],
		[Total_Paid],
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
		[Create_Date],
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
		[Action_Required],
		[RTW_Impacting],
		[Weeks_In],
		[Weeks_Band],
		[Hindsight],
		[Active_Weekly],
		[Active_Medical],
		[Cost_Code],
		[Cost_Code2],
		[CC_Injury],
		[CC_Current],
		[Med_Cert_Status_Next_Week],
		[Capacity],
		[Entitlement_Weeks],
		[Med_Cert_Status_Prev_1_Week],
		[Med_Cert_Status_Prev_2_Week],
		[Med_Cert_Status_Prev_3_Week],
		[Med_Cert_Status_Prev_4_Week],
		[Is_Last_Month]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	--- TMF ---	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_Portfolio_Reporting_Date')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_Portfolio_Reporting_Date] ON [dbo].[TMF_Portfolio] 
		(
			[Reporting_Date] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_Portfolio_RAW_Data')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_Portfolio_RAW_Data] ON [dbo].[TMF_Portfolio]
		(
			[Reporting_Date] ASC,
			[Med_Cert_Status_This_Week] ASC,
			[Id] ASC,
			[Team] ASC,
			[Case_Manager] ASC,
			[EMPL_SIZE] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ([Policy_No],
		[Portfolio],
		[Claim_No],
		[WIC_Code],
		[Company_Name],
		[Worker_Name],
		[Employee_Number],
		[Worker_Phone_Number],
		[Claims_Officer_Name],
		[Date_Of_Birth],
		[Date_Of_Injury],
		[Date_Of_Notification],
		[Notification_Lag],
		[Entered_Lag],
		[Claim_Liability_Indicator_Group],
		[Investigation_Incurred],
		[Total_Paid],
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
		[Create_Date],
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
		[Action_Required],
		[RTW_Impacting],
		[Weeks_In],
		[Weeks_Band],
		[Hindsight],
		[Active_Weekly],
		[Active_Medical],
		[Cost_Code],
		[Cost_Code2],
		[CC_Injury],
		[CC_Current],
		[Med_Cert_Status_Next_Week],
		[Capacity],
		[Entitlement_Weeks],
		[Med_Cert_Status_Prev_1_Week],
		[Med_Cert_Status_Prev_2_Week],
		[Med_Cert_Status_Prev_3_Week],
		[Med_Cert_Status_Prev_4_Week],
		[Is_Last_Month]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
		
	--- HEM ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_Portfolio_Reporting_Date')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_Portfolio_Reporting_Date] ON [dbo].[HEM_Portfolio] 
		(
			[Reporting_Date] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_Portfolio_RAW_Data') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_Portfolio_RAW_Data] ON [dbo].[HEM_Portfolio] 
		(
			[Reporting_Date] ASC,
			[Med_Cert_Status_This_Week] ASC,
			[Id] ASC,
			[Team] ASC,
			[Case_Manager] ASC,
			[EMPL_SIZE] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ([Policy_No],
		[Portfolio],
		[Claim_No],
		[WIC_Code],
		[Company_Name],
		[Worker_Name],
		[Employee_Number],
		[Worker_Phone_Number],
		[Claims_Officer_Name],
		[Date_Of_Birth],
		[Date_Of_Injury],
		[Date_Of_Notification],
		[Notification_Lag],
		[Entered_Lag],
		[Claim_Liability_Indicator_Group],
		[Investigation_Incurred],
		[Total_Paid],
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
		[Create_Date],
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
		[Action_Required],
		[RTW_Impacting],
		[Weeks_In],
		[Weeks_Band],
		[Hindsight],
		[Active_Weekly],
		[Active_Medical],
		[Cost_Code],
		[Cost_Code2],
		[CC_Injury],
		[CC_Current],
		[Med_Cert_Status_Next_Week],
		[Capacity],
		[Entitlement_Weeks],
		[Med_Cert_Status_Prev_1_Week],
		[Med_Cert_Status_Prev_2_Week],
		[Med_Cert_Status_Prev_3_Week],
		[Med_Cert_Status_Prev_4_Week],
		[Is_Last_Month]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	-------------------------------------- RTW INDEXES --------------------------------------
	--- EML ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Measure') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Measure] ON [dbo].[EML_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC
		)
		INCLUDE ( [LT],
		[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Measure_Include_Team') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Measure_Include_Team] ON [dbo].[EML_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC
		)
		INCLUDE ( [Team],
		[LT],
		[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Measure_EMPL') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Measure_EMPL] ON [dbo].[EML_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC,
			[EMPL_SIZE] ASC
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
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_RTW_RE_RS_Id_Measure_Team_EMPL_Acc') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_RTW_RE_RS_Id_Measure_Team_EMPL_Acc] ON [dbo].[EML_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Id] ASC,
			[Measure] ASC,
			[Team] ASC,
			[EMPL_SIZE] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [LT],
		[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	--- TMF ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_POLICY_NO_RS_Measure') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_POLICY_NO_RS_Measure] ON [dbo].[TMF_RTW] 
		(
			[Remuneration_End] ASC,
			[POLICY_NO] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC
		)
		INCLUDE ( [LT],[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_Id_POLICY_NO_RS_Measure_Team') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_Id_POLICY_NO_RS_Measure_Team] ON [dbo].[TMF_RTW]
		(
			[Remuneration_End] ASC,
			[Id] ASC,
			[POLICY_NO] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC,
			[Team] ASC
		)
		INCLUDE ( [LT],[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
		
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_RTW_RE_Measure_RS_POLICY_NO')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_RTW_RE_Measure_RS_POLICY_NO] ON [dbo].[TMF_RTW] 
		(
			[Remuneration_End] ASC,
			[Measure] ASC,
			[Remuneration_Start] ASC,
			[POLICY_NO] ASC
		)
		INCLUDE ( [LT],[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	--- HEM ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_Raw_Data')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_Raw_Data] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC,
			[Id] ASC
		)
		INCLUDE ( [Remuneration_Start],
		[Team],
		[Case_manager],
		[Claim_no],
		[DTE_OF_INJURY],
		[POLICY_NO],
		[LT],
		[WGT],
		[EMPL_SIZE],
		[Weeks_paid],
		[Measure],
		[Cert_Type],
		[Med_cert_From],
		[Med_cert_To],
		[Account_Manager],
		[Cell_no],
		[Portfolio],
		[Stress],
		[Liability_Status],
		[cost_code],
		[cost_code2],
		[Claim_Closed_flag]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC
		)
		INCLUDE ( [LT],[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Include_Team') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Include_Team] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC
		)
		INCLUDE ( [Team],
		[LT],
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
		INCLUDE ( [LT],[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
		
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Port') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Port] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC,
			[Portfolio] ASC
		)
		INCLUDE ( [LT],[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Acc_EMPL') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Acc_EMPL] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC,
			[Account_Manager] ASC,
			[EMPL_SIZE] ASC
		)
		INCLUDE ( [LT],
		[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_RTW_RE_RS_Measure_Port_EMPL') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_RTW_RE_RS_Measure_Port_EMPL] ON [dbo].[HEM_RTW] 
		(
			[Remuneration_End] ASC,
			[Remuneration_Start] ASC,
			[Measure] ASC,
			[Portfolio] ASC,
			[EMPL_SIZE] ASC
		)
		INCLUDE ( [LT],
		[WGT]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	-------------------------------------- AWC INDEXES --------------------------------------
	--- EML ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Claim_no_Time_ID') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Claim_no_Time_ID] ON [dbo].[EML_AWC] 
		(
			[Claim_no] ASC,
			[Time_ID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Team') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Team] ON [dbo].[EML_AWC] 
		(
			[Team] ASC
		)
		INCLUDE ( [EMPL_SIZE],
		[Account_Manager]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID] ON [dbo].[EML_AWC] 
		(
			[Time_ID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Claim_no_Time_ID_Acc') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Claim_no_Time_ID_Acc] ON [dbo].[EML_AWC] 
		(
			[Claim_no] ASC,
			[Time_ID] ASC,
			[Account_Manager] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Team_Claim_no') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Team_Claim_no] ON [dbo].[EML_AWC] 
		(
			[Time_ID] ASC,
			[Team] ASC,
			[Claim_no] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_no_Include_EMPL')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_no_Include_EMPL] ON [dbo].[EML_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_no_Include_Team')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_no_Include_Team] ON [dbo].[EML_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC
		)
		INCLUDE ( [Team]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_no_Acc') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_no_Acc] ON [dbo].[EML_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Time_ID_Claim_no_Team_Acc') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Time_ID_Claim_no_Team_Acc] ON [dbo].[EML_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Team] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Acc_Time_ID_Claim_no_Team') 	
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Acc_Time_ID_Claim_no_Team] ON [dbo].[EML_AWC] 
		(
			[Account_Manager] ASC,
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Team] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Team_Time_ID_Claim_no_Acc') 	
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Team_Time_ID_Claim_no_Acc] ON [dbo].[EML_AWC] 
		(
			[Team] ASC,
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_EML_AWC_Projections_Unit_Type_Type') 	
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_EML_AWC_Projections_Unit_Type_Type] ON [dbo].[EML_AWC_Projections] 
		(
			[Unit_Type] ASC,
			[Type] ASC
		)
		INCLUDE ( [Unit_Name],
		[Time_Id],
		[Projection]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
		
	--- TMF ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_POLICY_NO_Team')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_POLICY_NO_Team] ON [dbo].[TMF_AWC] 
		(
			[POLICY_NO] ASC,
			Team ASC
		)
		WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Time_ID')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Time_ID] ON [dbo].[TMF_AWC]
		(
			[Time_ID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Claim_no_Time_ID_Team')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Claim_no_Time_ID_Team] ON [dbo].[TMF_AWC]
		(
			[Claim_no] ASC,
			[Time_ID] ASC,
			Team ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Claim_no_Time_ID')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Claim_no_Time_ID] ON [dbo].[TMF_AWC] 
		(
			[Claim_no] ASC,
			[Time_ID] ASC
		)
		INCLUDE ( Team,[Date_of_Injury],POLICY_NO) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Time_ID_Claim_no_Team')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Time_ID_Claim_no_Team] ON [dbo].[TMF_AWC]
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Team] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Time_ID_POLICY_NO_Claim_no')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Time_ID_POLICY_NO_Claim_no] ON [dbo].[TMF_AWC] 
		(
			[Time_ID] ASC,
			[POLICY_NO] ASC,
			[Claim_no] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TMF_AWC_Projections_Type_Unit_Type')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TMF_AWC_Projections_Type_Unit_Type] ON [dbo].[TMF_AWC_Projections] 
		(
			[Type] ASC,
			[Unit_Type] ASC
		)
		INCLUDE ( [Unit_Name],
		[Time_Id],
		[Projection]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
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

	--- HEM ---
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Time_ID')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Time_ID] ON [dbo].[HEM_AWC] 
		(
			[Claim_no] ASC,
			[Time_ID] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[Account_Manager]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Time_ID_Acc') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Time_ID_Acc] ON [dbo].[HEM_AWC] 
		(
			[Claim_no] ASC,
			[Time_ID] ASC,
			[Account_Manager] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Team_Time_ID') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Team_Time_ID] ON [dbo].[HEM_AWC] 
		(
			[Claim_no] ASC,
			[Team] ASC,
			[Time_ID] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Port_Time_ID') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Port_Time_ID] ON [dbo].[HEM_AWC] 
		(
			[Claim_no] ASC,
			[Portfolio] ASC,
			[Time_ID] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Port_Time_ID_Include_EMPL') 
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Port_Time_ID_Include_EMPL] ON [dbo].[HEM_AWC] 
		(
			[Claim_no] ASC,
			[Portfolio] ASC,
			[Time_ID] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Team') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Team] ON [dbo].[HEM_AWC] 
		(
			[Team] ASC
		)
		INCLUDE ( [EMPL_SIZE],
		[Account_Manager],
		[Portfolio]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID')
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID] ON [dbo].[HEM_AWC] 
		(
			[Time_ID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_no_Acc') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_no_Acc] ON [dbo].[HEM_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Account_Manager] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_no_Acc_Include') 
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_no_Acc_Include] ON [dbo].[HEM_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [Date_of_Injury]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_no_Port') 	
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_no_Port] ON [dbo].[HEM_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Portfolio] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Time_ID_Claim_no_Port_Include_EMPL') 
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Time_ID_Claim_no_Port_Include_EMPL] ON [dbo].[HEM_AWC] 
		(
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Portfolio] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Acc_Time_ID') 
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Acc_Time_ID] ON [dbo].[HEM_AWC] 
		(
			[Claim_no] ASC,
			[Account_Manager] ASC,
			[Time_ID] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Acc_Time_ID_Claim_no_Team_Port') 
	BEGIN	
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Acc_Time_ID_Claim_no_Team_Port] ON [dbo].[HEM_AWC] 
		(
			[Account_Manager] ASC,
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Team] ASC,
			[Portfolio] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Claim_no_Time_ID_Port_Team_Acc') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Claim_no_Time_ID_Port_Team_Acc] ON [dbo].[HEM_AWC]
		(
			[Claim_no] ASC,
			[Time_ID] ASC,
			[Portfolio] ASC,
			[Team] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Team_Time_ID_Claim_no_Acc_Port') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Team_Time_ID_Claim_no_Acc_Port] ON [dbo].[HEM_AWC] 
		(
			[Team] ASC,
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Account_Manager] ASC,
			[Portfolio] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_HEM_AWC_Port_Time_ID_Claim_no_Team_Acc') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_HEM_AWC_Port_Time_ID_Claim_no_Team_Acc] ON [dbo].[HEM_AWC] 
		(
			[Portfolio] ASC,
			[Time_ID] ASC,
			[Claim_no] ASC,
			[Team] ASC,
			[Account_Manager] ASC
		)
		INCLUDE ( [Date_of_Injury],
		[EMPL_SIZE]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

EXEC [dbo].[usp_DART_Index]