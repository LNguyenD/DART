SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_AWC_Index]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_AWC_Index]
GO

CREATE PROCEDURE [dbo].[usp_AWC_Index]
AS
BEGIN
	-- AWC
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_POLICY_TERM_DETAIL_Policy_No_Broker_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_POLICY_TERM_DETAIL_Policy_No_Broker_No] ON [dbo].[POLICY_TERM_DETAIL] 
		(
			[POLICY_NO] ASC,
			[BROKER_NO] ASC
		)
		INCLUDE ( [CELL_NO]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_Medical_Cert_Cancelled_By_Claim_no_Cancelled_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_Medical_Cert_Cancelled_By_Claim_no_Cancelled_Date] ON [dbo].[Medical_Cert] 
		(
			[Cancelled_By] ASC,
			[Claim_no] ASC,
			[Cancelled_Date] ASC
		)
		INCLUDE ( [ID],
		[Date_From],
		[Date_To],
		[Type]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_ESTIMATE_DETAILS_Claim_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_ESTIMATE_DETAILS_Claim_No] ON [dbo].[ESTIMATE_DETAILS] 
		(
			[Claim_No] ASC
		)
		INCLUDE ( [Amount]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CO_Audit_Alias_ID_Officer_ID_Create_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CO_Audit_Alias_ID_Officer_ID_Create_Date] ON [dbo].[CO_Audit] 
		(
			[Alias] ASC,
			[ID] ASC,
			[Officer_ID] ASC,
			[Create_date] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CLAIMS_OFFICERS_Alias_Officer_ID_Active_Grp') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CLAIMS_OFFICERS_Alias_Officer_ID_Active_Grp] ON [dbo].[CLAIMS_OFFICERS] 
		(
			[Alias] ASC,
			[Officer_ID] ASC,
			[active] ASC,
			[grp] ASC
		)
		INCLUDE ( [First_Name],
		[Last_Name]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CLAIM_PAYMENT_RUN_Payment_No_Claim_Number_Authorised_dte') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CLAIM_PAYMENT_RUN_Payment_No_Claim_Number_Authorised_dte] ON [dbo].[CLAIM_PAYMENT_RUN] 
		(
			[Payment_no] ASC,
			[Claim_number] ASC,
			[Authorised_dte] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CLAIM_DETAIL_Date_Created_Claim_Number_Anzsic') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CLAIM_DETAIL_Date_Created_Claim_Number_Anzsic] ON [dbo].[CLAIM_DETAIL] 
		(
			[Date_Created] ASC,
			[Claim_Number] ASC,
			[ANZSIC] ASC
		)
		INCLUDE ( [Policy_No],
		[Renewal_No]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CLAIM_ACTIVITY_DETAIL_Claim_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CLAIM_ACTIVITY_DETAIL_Claim_No] ON [dbo].[CLAIM_ACTIVITY_DETAIL] 
		(
			[Claim_no] ASC
		)
		INCLUDE ( [Claim_Closed_Flag],
		[Claim_Liability_Indicator]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_cd_audit_claim_no_create_date_id') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_cd_audit_claim_no_create_date_id] ON [dbo].[cd_audit] 
		(
			[claim_no] ASC,
			[create_date] ASC,
			[id] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CAD_AUDIT_Claim_no_Transaction_Date_ID') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CAD_AUDIT_Claim_no_Transaction_Date_ID] ON [dbo].[CAD_AUDIT] 
		(
			[Claim_no] ASC,
			[Transaction_Date] ASC,
			[ID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_BROKER_Broker_No_emi_contact') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_BROKER_Broker_No_emi_contact] ON [dbo].[BROKER] 
		(
			[BROKER_NO] ASC,
			[emi_contact] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_ANZSIC_Code') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_ANZSIC_Code] ON [dbo].[ANZSIC] 
		(
			[CODE] ASC
		)
		INCLUDE ( [ID],
		[DESCRIPTION]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
END
GO

EXEC [dbo].[usp_AWC_Index]