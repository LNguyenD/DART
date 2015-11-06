SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Index]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Index]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Index]
AS
BEGIN
	-- CPR	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TIME_LOST_DETAIL_Claim_No_ID') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TIME_LOST_DETAIL_Claim_No_ID] ON [dbo].[TIME_LOST_DETAIL] 
		(
			[Claim_No] ASC,
			[ID] ASC
		)
		INCLUDE ( [RTW_Goal],
		[Deemed_HoursPerWeek]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_PREMIUM_DETAIL_Policy_No_Renewal_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_PREMIUM_DETAIL_Policy_No_Renewal_No] ON [dbo].[PREMIUM_DETAIL] 
		(
			[POLICY_NO] ASC,
			[RENEWAL_NO] ASC
		)
		INCLUDE ( [BTP],
		[WAGES0],
		[Process_Flags]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_POLICY_TERM_DETAIL_Policy_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_POLICY_TERM_DETAIL_Policy_No] ON [dbo].[POLICY_TERM_DETAIL] 
		(
			[POLICY_NO] ASC
		)
		INCLUDE ( [BROKER_NO],
		[LEGAL_NAME]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_Payment_Recovery_Estimate_Type_Claim_No_Transaction_Date_Payment_Type_ID') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_Payment_Recovery_Estimate_Type_Claim_No_Transaction_Date_Payment_Type_ID] ON [dbo].[Payment_Recovery] 
		(
			[Estimate_type] ASC,
			[Claim_No] ASC,
			[Transaction_date] ASC,
			[Payment_Type] ASC,
			[ID] ASC
		)
		INCLUDE ( [Trans_Amount],
		[itc],
		[dam],
		[gst]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_Medical_Cert_Claim_No_Create_Date_Is_Deleted_ID_Date_From') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_Medical_Cert_Claim_No_Create_Date_Is_Deleted_ID_Date_From] ON [dbo].[Medical_Cert] 
		(
			[Claim_no] ASC,
			[create_date] ASC,
			[is_deleted] ASC,
			[ID] ASC,
			[Date_From] ASC
		)
		INCLUDE ( [Type]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_ESTIMATE_DETAILS_Type_Claim_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_ESTIMATE_DETAILS_Type_Claim_No] ON [dbo].[ESTIMATE_DETAILS] 
		(
			[Type] ASC,
			[Claim_No] ASC
		)
		INCLUDE ( [Amount]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CLAIM_DETAIL_Claim_No_Anzsic_Policy_No_Renewal_No_Cost_Code_Cost_Code2_Is_Null') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CLAIM_DETAIL_Claim_No_Anzsic_Policy_No_Renewal_No_Cost_Code_Cost_Code2_Is_Null] ON [dbo].[CLAIM_DETAIL] 
		(
			[Claim_Number] ASC,
			[ANZSIC] ASC,
			[Policy_No] ASC,
			[Renewal_No] ASC,
			[Cost_Code] ASC,
			[Cost_Code2] ASC,
			[is_Null] ASC
		)
		INCLUDE ( [Date_of_Birth],
		[Date_of_Injury],
		[Date_Notice_Given],
		[Given_Names],
		[is_Medical_Only],
		[Last_Names],
		[Mechanism_of_Injury],
		[Nature_of_Injury],
		[Phone_no],
		[Tariff_No],
		[Employee_no],
		[Employment_Terminated_Reason],
		[Fund],
		[Work_Hours]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_cd_bit_audit_ID_Is_NUll_Claim_Number_Create_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_cd_bit_audit_ID_Is_NUll_Claim_Number_Create_Date] ON [dbo].[cd_bit_audit] 
		(
			[id] ASC,
			[is_Null] ASC,
			[Claim_Number] ASC,
			[Create_date] ASC
		)
		INCLUDE ( [is_Time_Lost]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_cd_audit_Id_Fund_Claim_No_Create_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_cd_audit_Id_Fund_Claim_No_Create_Date] ON [dbo].[cd_audit] 
		(
			[id] ASC,
			[fund] ASC,
			[claim_no] ASC,
			[create_date] ASC
		)
		INCLUDE ( [Result_of_Injury_Code]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CAD_AUDIT_Claim_No_ID_Liability_Closed_Flag_CO_Reopened_Transaction_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CAD_AUDIT_Claim_No_ID_Liability_Closed_Flag_CO_Reopened_Transaction_Date] ON [dbo].[CAD_AUDIT] 
		(
			[Claim_no] ASC,
			[ID] ASC,
			[Claim_Liability_Indicator] ASC,
			[Date_Claim_Closed] ASC,
			[Claim_Closed_Flag] ASC,
			[Claims_Officer] ASC,
			[Date_Claim_reopened] ASC,
			[Transaction_Date] ASC
		)
		INCLUDE ( [Work_Status_Code],
		[Date_Claim_Entered],
		[date_claim_received],
		[WPI]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_amendment_exemptions_Claim_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_amendment_exemptions_Claim_No] ON [dbo].[amendment_exemptions] 
		(
			[claim_no] ASC
		)
		INCLUDE ( [is_exempt]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_ACTIVITY_DETAIL_AUDIT_Policy_No_Renewal_No_ID_Create_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_ACTIVITY_DETAIL_AUDIT_Policy_No_Renewal_No_ID_Create_Date] ON [dbo].[ACTIVITY_DETAIL_AUDIT] 
		(
			[Policy_No] ASC,
			[Renewal_No] ASC,
			[ID] ASC,
			[CREATE_DATE] ASC
		)
		INCLUDE ( [Tariff]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
END
GO

EXEC [dbo].[usp_CPR_Index]