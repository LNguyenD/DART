SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_RTW_Index]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_RTW_Index]
GO

CREATE PROCEDURE [dbo].[usp_RTW_Index]
AS
BEGIN
	-- RTW
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_Payment_Recovery_Transaction_Date_Wc_Tape_Month_Payment_Type') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_Payment_Recovery_Transaction_Date_Wc_Tape_Month_Payment_Type] ON [dbo].[Payment_Recovery]([Transaction_date],[wc_Tape_Month],[Payment_Type]) 
		INCLUDE ([Claim_No],[Payment_no],[Trans_Amount],[hours_per_week],[Period_Start_Date],[Period_End_Date],[wc_Hours],[wc_Minutes],[wc_Weeks])	
	END	
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CLAIM_DETAIL_Claim_Number_DOI_Date_of_Injury_Anzsic') 
	BEGIN		
		CREATE NONCLUSTERED INDEX [idx_CLAIM_DETAIL_Claim_Number_DOI_Date_of_Injury_Anzsic] ON [dbo].[CLAIM_DETAIL] 
		(
			[Claim_Number] ASC,
			[Date_of_Injury] ASC,
			[ANZSIC] ASC
		)
		INCLUDE ( [Renewal_No],
		[Work_Hours]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_cd_audit_claim_no') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_cd_audit_claim_no] ON [dbo].[cd_audit] 
		(
			[claim_no] ASC
		)
		INCLUDE ( [id],
		[Date_of_Injury],
		[Policy_No]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CAD_AUDIT_Claim_no_ID_Claim_Officer_Transaction_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CAD_AUDIT_Claim_no_ID_Claim_Officer_Transaction_Date] ON [dbo].[CAD_AUDIT] 
		(
			[Claim_no] ASC,
			[ID] ASC,
			[Claims_Officer] ASC,
			[Transaction_Date] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END	

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_ACTIVITY_DETAIL_AUDIT_Policy_No_Renewal_No_Tariff') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_ACTIVITY_DETAIL_AUDIT_Policy_No_Renewal_No_Tariff] ON [dbo].[ACTIVITY_DETAIL_AUDIT] 
		(
			[Policy_No] ASC,
			[Renewal_No] ASC,
			[Tariff] ASC
		)
		INCLUDE ( [Wages_Shifts]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
END
GO

IF DATEDIFF(DD,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0),GETDATE()) >= 9
BEGIN
	EXEC [dbo].[usp_RTW_Index]
END