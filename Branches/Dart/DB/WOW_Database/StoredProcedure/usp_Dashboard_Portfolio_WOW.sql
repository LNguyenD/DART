SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Dustin (DART)
-- CREATE date: 14/07/2015 14:31:45
-- Description:	SQL store procedure to generate data for WOW Dashboard
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_Portfolio_WOW]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_Portfolio_WOW]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_Portfolio_WOW]
	@as_at datetime,
	@is_last_month bit
AS
BEGIN
	SET NOCOUNT ON
	SET ANSI_WARNINGS OFF
	
	/* Drop all temp tables first */
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL DROP table #claim
	IF OBJECT_ID('tempdb..#claim_prior') IS NOT NULL DROP table #claim_prior
	IF OBJECT_ID('tempdb..#claim_status_history_grp') IS NOT NULL DROP table #claim_status_history_grp
	IF OBJECT_ID('tempdb..#claim_status_history') IS NOT NULL DROP table #claim_status_history
	IF OBJECT_ID('tempdb..#external_payments') IS NOT NULL DROP table #external_payments
	IF OBJECT_ID('tempdb..#weekly_payments') IS NOT NULL DROP table #weekly_payments
	IF OBJECT_ID('tempdb..#estimate') IS NOT NULL DROP table #estimate
	
	DECLARE @default_period_start datetime
	DECLARE @Reporting_Date datetime
	SET @Reporting_Date = DATEADD(d, DATEDIFF(d, 0, @as_at), 0) + '23:59'
	
	/* determine if this is generating data process for last month or not */
	IF @is_last_month = 1
	BEGIN
		/* get the end of last month as input parameter */
		SET @as_at = DATEADD(m, DATEDIFF(m, 0, @as_at), -1) + '23:59'
		SET @default_period_start = DATEADD(mm, DATEDIFF(mm, 0, @as_at), 0)
	END
	ELSE
	BEGIN
		SET @as_at = DATEADD(d, DATEDIFF(d, 0, @as_at), 0) + '23:59'
		SET @default_period_start = DATEADD(week,-2,DATEADD(d, DATEDIFF(d, 0, @as_at), 0))
	END
	
	/* previous 3 months from @as_at */
	DECLARE @as_at_prev_3_months datetime
	SET @as_at_prev_3_months = DATEADD(m, -3, @as_at)
	
	/* previous 1 week from @as_at */
	DECLARE @as_at_Prev_1_Week datetime
	SET @as_at_Prev_1_Week = DATEADD(WEEK, -1, @as_at)
	
	/* previous 2 weeks from @as_at */
	DECLARE @as_at_Prev_2_Week datetime
	SET @as_at_Prev_2_Week = DATEADD(WEEK, -2, @as_at)
	
	/* previous 3 weeks from @as_at */
	DECLARE @as_at_Prev_3_Week datetime
	SET @as_at_Prev_3_Week = DATEADD(WEEK, -3, @as_at)
	
	/* previous 4 weeks from @as_at */
	DECLARE @as_at_Prev_4_Week datetime
	SET @as_at_Prev_4_Week = DATEADD(WEEK, -4, @as_at)
	
	/* previous 5 years from @as_at */
	DECLARE @data_date_start datetime = DATEADD(YY, -5, @as_at)
	
	DECLARE @SQL varchar(500)
	
	/* THE ORIGINAL CLAIM LIST */
	
	/* Prepare Claim Status History data */
	SELECT	MAX(ID) AS ID, CLAIM_NO, DTE_STATUS_CHANGED
	INTO	#claim_status_history_grp
	FROM	dbo.vw_WOW_Claim_Status_History
	GROUP BY CLAIM_NO, DTE_STATUS_CHANGED
	
	SELECT	csh_grp.*, csh.CLAIM_STATUS
	INTO	#claim_status_history
	FROM	#claim_status_history_grp csh_grp 
			INNER JOIN dbo.vw_WOW_Claim_Status_History csh ON csh.CLAIM_NO = csh_grp.CLAIM_NO and csh.ID = csh_grp.ID
			
	/* Drop unused temp table */
	IF OBJECT_ID('tempdb..#claim_status_history_grp') IS NOT NULL DROP table #claim_status_history_grp
	
	IF OBJECT_ID('tempdb..#claim') IS NULL
	BEGIN
		/* The original claim list for output result. Make sure all of the calculations base on this claim list */
		CREATE TABLE #claim
		(
			CLAIM_NO varchar(15)
			,TEAM varchar(20)
			,JURISDICTION nvarchar(3)
			,CLAIMS_OFFICER varchar(150)
			,WORK_HOURS float
			,CLAIM_CLOSED_FLAG varchar(1)
			,FUND smallint
			,POLICY_NO varchar(10)
			,COST_CODE varchar(10)
			,TARIFF_NO varchar(50)
			,GIVEN_NAMES varchar(30)
			,LAST_NAMES varchar(30)
			,EMPLOYEE_NO varchar(20)
			,PHONE_NO varchar(20)
			,DTE_OF_BIRTH datetime
			,DTE_NOTICE_GIVEN datetime
			,INJURYRESULT int
			,MECHANISM_OF_INJURY int
			,NATURE_OF_INJURY int
			,EMPLOYMENT_TERMINATED_REASON int
			,DTE_OF_INJURY datetime
			,CLAIM_LIABILITY_INDICATOR varchar(5)
			,WPI int
			,WORK_STATUS_CODE smallint
			,DTE_CLAIM_RECEIVED datetime
			,DTE_CLAIM_ENTERED datetime
			,DTE_CLAIM_CLOSED datetime
			,DTE_CLAIM_REOPENED datetime
			,DTE_STATUS_CHANGED datetime
			,CLAIM_STATUS varchar(1)
		)

		/* create index for #claim table */
		SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(CLAIM_NO)'
		EXEC(@SQL)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #claim
		SELECT	DISTINCT CLAIM_NO = cd.CLAIM_NO
				,TEAM = cd.TEAM
				,JURISDICTION = cd.JURISDICTION
				,CLAIMS_OFFICER = cd.OFFICER
				,WORK_HOURS = cd.WORK_HOURS
				,CLAIM_CLOSED_FLAG = CASE WHEN csh.CLAIM_STATUS IN ('F','C') THEN 'Y' ELSE 'N' END
				,FUND = cd.FUND
				,POLICY_NO = cd.POLICY_NO
				,COST_CODE = cd.COST_CODE
				,TARIFF_NO = CONVERT(varchar, cd.TARIFF_NO)
				,GIVEN_NAMES = cd.GIVEN_NAMES
				,LAST_NAMES = cd.LAST_NAMES
				,EMPLOYEE_NO = cd.EMPLOYEE_NO
				,PHONE_NO = cd.PHONE_NO
				,DTE_OF_BIRTH = cd.DTE_OF_BIRTH
				,DTE_NOTICE_GIVEN = cd.DTE_NOTICE_GIVEN
				,INJURYRESULT = cd.INJURYRESULT
				,MECHANISM_OF_INJURY = cd.MECHANISM_OF_INJURY
				,NATURE_OF_INJURY = cd.NATURE_OF_INJURY
				,EMPLOYMENT_TERMINATED_REASON = cd.EMPLOYMENT_TERMINATED_REASON
				,DTE_OF_INJURY = cd.DTE_OF_INJURY
				,CLAIM_LIABILITY_INDICATOR = cd.CLAIM_LIABILITY_INDICATOR
				,WPI = cd.WPI
				,WORK_STATUS_CODE = case cd.WORK_STATUS_CODE
										when '01' then 1
										when '02' then 2
										when '03' then 3
										when '04' then 4
										when '06' then 6
										when '08' then 8
										when '09' then 9
										when '10' then 10
										when '13' then 13
									end
				,DTE_CLAIM_RECEIVED = cd.DTE_CLAIM_RECEIVED
				,DTE_CLAIM_ENTERED = cd.DTE_CLAIM_ENTERED
				,DTE_CLAIM_CLOSED = cd.DTE_CLAIM_CLOSED
				,DTE_CLAIM_REOPENED = cd.DTE_CLAIM_REOPENED
				,DTE_STATUS_CHANGED = csh.DTE_STATUS_CHANGED
				,CLAIM_STATUS = csh.CLAIM_STATUS
		FROM	dbo.vw_WOW_Claim_Detail cd
				LEFT JOIN #claim_status_history csh on cd.CLAIM_NO = csh.CLAIM_NO
					AND csh.DTE_STATUS_CHANGED = (SELECT MAX(csh2.DTE_STATUS_CHANGED)
														FROM #claim_status_history csh2
														WHERE csh2.CLAIM_NO = cd.CLAIM_NO
															and csh2.DTE_STATUS_CHANGED <= @as_at)
		/* limit data */
		WHERE	((cd.DTE_CLAIM_ENTERED BETWEEN @data_date_start AND @as_at)
				OR (csh.DTE_STATUS_CHANGED <= @as_at AND csh.CLAIM_STATUS NOT IN ('F','C'))
				OR (csh.DTE_STATUS_CHANGED BETWEEN @data_date_start AND @as_at AND csh.CLAIM_STATUS IN ('F','C','E'))
				OR csh.CLAIM_STATUS IS NULL)
	END
	
	IF OBJECT_ID('tempdb..#claim_prior') IS NULL
	BEGIN
		/* The original prior claim list */
		CREATE TABLE #claim_prior
		(
			CLAIM_NO varchar(15)
			,CLAIM_CLOSED_FLAG varchar(1)
		)

		/* create index for #claim table */
		SET @SQL = 'CREATE INDEX pk_claim_prior_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim_prior(CLAIM_NO)'
		EXEC(@SQL)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #claim_prior
		SELECT	DISTINCT CLAIM_NO = cd.CLAIM_NO
				,CLAIM_CLOSED_FLAG = CASE WHEN csh.CLAIM_STATUS IN ('F','C') THEN 'Y' ELSE 'N' END
		FROM	dbo.vw_WOW_Claim_Detail cd
				LEFT JOIN #claim_status_history csh on cd.CLAIM_NO = csh.CLAIM_NO
					AND csh.DTE_STATUS_CHANGED = (SELECT MAX(csh2.DTE_STATUS_CHANGED)
														FROM #claim_status_history csh2
														WHERE csh2.CLAIM_NO = cd.CLAIM_NO
															and csh2.DTE_STATUS_CHANGED <= @default_period_start)
	END
	
	/* Drop unused temp table */
	IF OBJECT_ID('tempdb..#claim_status_history') IS NOT NULL DROP table #claim_status_history
	
	IF OBJECT_ID('tempdb..#external_payments') IS NULL
	BEGIN
		CREATE TABLE #external_payments
		(
			CLAIM varchar(15)
			,CLAIM_CLOSED_FLAG varchar(1)
			,TRANS_AMOUNT float
			,TRANSACTION_DTE datetime
			,TOTAL_PAID float
			,ESTIMATE_TYPE int
			,SICATEGORYID int
			,SICODE varchar(10)
			,ISRECOVERY bit
		)		

		INSERT INTO #external_payments
		SELECT	CLAIM = pr.Claim_No
				,cd.CLAIM_CLOSED_FLAG
				,TRANS_AMOUNT
				,TRANSACTION_DTE
				,TOTAL_PAID = ISNULL(TRANS_AMOUNT,0) -
								ISNULL(ITC,0) -
								ISNULL(DAM,0)
				,ESTIMATE_TYPE
				,SICATEGORYID
				,SICODE
				,ISRECOVERY
		FROM	dbo.vw_WOW_External_Pay_Recovery pr
				INNER JOIN #claim cd ON pr.CLAIM_NO = cd.CLAIM_NO
		WHERE	TRANSACTION_DTE <= @as_at
	END
	
	IF OBJECT_ID('tempdb..#weekly_payments') IS NULL
	BEGIN
		CREATE TABLE #weekly_payments
		(
			 claim varchar(15)
			 ,datepaid datetime
			 ,paid float
			 ,latest_datepaid datetime
			 ,latest_datepaid_prev datetime
		)

		/* create index for #weekly_payments table */
		SET @SQL = 'CREATE INDEX pk_weekly_payments_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #weekly_payments(claim)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #weekly_payments
		SELECT	Claim
				,DatePaid
				,Paid
				,latest_datepaid = (SELECT MAX(DatePaid)
										FROM dbo.Entitle ent1
										WHERE ent1.Claim = ent.Claim
											AND ent1.[Type] in ('I', 'R')
											AND ent1.PaymentType = 2
											AND ent1.DatePaid IS NOT NULL
											AND ent1.DatePaid <= @as_at)
				,latest_datepaid_prev = null
		FROM	dbo.Entitle ent
		WHERE	[Type] in ('I', 'R') AND PaymentType = 2 AND DatePaid IS NOT NULL AND DatePaid <= @as_at
		
		/* determine the payment date before the latest payment date */
		UPDATE #weekly_payments
			SET latest_datepaid_prev = (SELECT MAX(DatePaid)
											FROM #weekly_payments ent1
											WHERE ent1.Claim = Claim
												AND ent1.DatePaid < latest_datepaid)
	END
	
	IF OBJECT_ID('tempdb..#estimate') IS NULL
	BEGIN
		CREATE TABLE #estimate
		(
			claim char(19)
			,incurred money
			,estimate_type int
		)		

		INSERT INTO #estimate
		SELECT	ed.Claim
				,INCURRED
				,Estimate_Type
		FROM	dbo.vw_WOW_Estimates_Detail ed
				INNER JOIN #claim cd ON ed.Claim = cd.CLAIM_NO
	END
	
	/* Output data */
	SELECT	[Group] = case when RTRIM(ISNULL(cd.JURISDICTION, '')) = ''
								then 'Miscellaneous'
							else 'Group - ' + RTRIM(UPPER(cd.JURISDICTION))
						end
			,Team = case when RTRIM(ISNULL(cd.TEAM, '')) = ''
							then 'Miscellaneous'
						else RTRIM(UPPER(cd.TEAM))
					end
			,Division = dbo.udf_GetDivisionByCostCode(cc.CCCode5)
			,[State] = case when RTRIM(ISNULL(cd.JURISDICTION, '')) = ''
								then 'Miscellaneous'
							else RTRIM(UPPER(cd.JURISDICTION))
						end
						
			/* Not Required */
			,Case_Manager = ''
			
			,Policy_No = cd.POLICY_NO
			,Reporting_Date = @Reporting_Date
			,Claim_No = RTRIM(cd.CLAIM_NO)
			,WIC_Code = cd.TARIFF_NO
			
			/* Not Required */
			,Company_Name = ''
			
			,Worker_Name = cd.GIVEN_NAMES + ', ' + cd.LAST_NAMES
			,Employee_Number = cd.EMPLOYEE_NO
			,Worker_Phone_Number = cd.PHONE_NO
			,Claims_Officer_Name = cd.CLAIMS_OFFICER
			,Date_of_Birth = cd.DTE_OF_BIRTH
			,Date_of_Injury = cd.DTE_OF_INJURY
			,Date_Of_Notification = ISNULL(cd.DTE_CLAIM_ENTERED,cd.DTE_CLAIM_RECEIVED)
			,Notification_Lag = case when cd.DTE_OF_INJURY IS NULL then -1
									 else
										(case when ISNULL(DATEDIFF(day,cd.DTE_OF_INJURY, ISNULL(cd.DTE_CLAIM_ENTERED,cd.DTE_CLAIM_RECEIVED)), 0) < 0
												then 0
											else ISNULL(DATEDIFF(day,cd.DTE_OF_INJURY, ISNULL(cd.DTE_CLAIM_ENTERED,cd.DTE_CLAIM_RECEIVED)), 0)
										end)
								end
			,Entered_Lag = DATEDIFF(day,cd.DTE_CLAIM_RECEIVED, cd.DTE_CLAIM_ENTERED)
			,Claim_Liability_Indicator_Group = dbo.udf_GetLiabilityStatusByCode(cd.CLAIM_LIABILITY_INDICATOR)
			,Investigation_Incurred = ISNULL(invest_incur.INVEST_INCURRED, 0)
			,Total_Paid = ISNULL(total_paid.TOTAL_PAID,0)
			,Is_Time_Lost =	case when ISNULL(weekly_paid.WEEKLY_PAID,0) > 0
									then 1
								else 0
							end
			,Claim_Closed_Flag = cd.CLAIM_CLOSED_FLAG
			,Date_Claim_Entered = cd.DTE_CLAIM_ENTERED
			,Date_Claim_Closed = cd.DTE_CLAIM_CLOSED
			,Date_Claim_Received = cd.DTE_CLAIM_RECEIVED
			,Date_Claim_Reopened = cd.DTE_CLAIM_REOPENED
			,Date_Status_Changed = cd.DTE_STATUS_CHANGED
			,Result_Of_Injury_Code = cd.INJURYRESULT
			,WPI = cd.WPI
			,Common_Law = case when	ISNULL(clp.COMMON_LAW, 0) > 0
									then 1
								else 0
							end
			,Total_Recoveries = ISNULL(recovs.TOTAL_RECOVERIES,0)
			,Is_Working = case when cd.WORK_STATUS_CODE in (1,2,3,4,14) then 1
								when cd.WORK_STATUS_CODE in (5,6,7,8,9) then 0
							end
			,Physio_Paid = ISNULL(phy_paid.PHYSIO_PAID,0)
			,Chiro_Paid = ISNULL(chiro_paid.CHIRO_PAID,0)			
			,Massage_Paid = ISNULL(mass_paid.MASSAGE_PAID,0)				
			,Osteopathy_Paid = ISNULL(ost_paid.OSTEOPATHY_PAID,0)
			,Acupuncture_Paid = ISNULL(acu_paid.ACUPUNCTURE_PAID,0)
			,Create_Date = GETDATE()
			,Is_Stress = case when cd.MECHANISM_OF_INJURY in (81,82,84,85,86,87,88)
									OR cd.NATURE_OF_INJURY in (910,702,703,704,705,706,707,718,719)
								then 1
							else 0
						  end
						  
			/* Using a rolling quarter */
			,Is_Inactive_Claims = case when	ISNULL(total_paid_last_3m.TOTAL_PAID_LAST_3M,0) = 0
											then 1
										else 0
									end
									
			,Is_Medically_Discharged = case when cd.EMPLOYMENT_TERMINATED_REASON = 2 then 1
											else 0
									   end
									   
			/* Not Required */
			,Is_Exempt = 0
			
			,Is_Reactive = case when wbp.claim IS NOT NULL
									then 1
								else 0
							end
			
			,Is_Medical_Only = case when ISNULL(med_paid.MEDICAL_PAID,0) > 0
										then 1
									else 0
								end
			,Is_D_D = case when cd.EMPLOYMENT_TERMINATED_REASON = 2
								then 1
							else 0
						end
						
			/* Not Required */
			,NCMM_Actions_This_Week = ''
			,NCMM_Actions_Next_Week = ''
			
			,HoursPerWeek = cd.WORK_HOURS
			,Is_Industrial_Deafness = case when cd.NATURE_OF_INJURY in (152,250,312,389,771)
												then 1
											else 0
										end
										
			/* Using a rolling quarter */
			,Rehab_Paid = ISNULL(rehab_paid.REHAB_PAID,0)
			
			/* Not Required */
			,Action_Required = ''
			
			/* Not Required */
			,RTW_Impacting = ''
			
			/* Measure the number of weeks since the DOI */
			,Weeks_In = dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at)
			
			,Weeks_Band = case when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 0 and 12 then 'A.0-12 WK'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 13 and 18 then 'B.13-18 WK'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 19 and 22 then 'C.19-22 WK'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 23 and 26 then 'D.23-26 WK'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 27 and 34 then 'E.27-34 WK'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 35 and 48 then 'F.35-48 WK'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 49 and 52 then 'G.48-52 WK'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 53 and 60 then 'H.53-60 WK'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 61 and 76 then 'I.61-76 WK'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 77 and 90 then 'J.77-90 WK'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 91 and 100 then 'K.91-100 WK'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 101 and 117 then 'L.101-117 WK'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) between 118 and 130 then 'M.117 - 130 WKS'
							   when dbo.udf_GetWeeksIn(cd.DTE_OF_INJURY,@as_at) > 130 then 'N.130+ WKS'
						  end
						  
			/* Not Required */
			,Hindsight = ''
			
			/* Using a rolling quarter */
			,Active_Weekly = case when ISNULL(weekly_comp.WEEKLY_COMP,0) > 0
										then 'Y'
								  else 'N'
							 end
			
			/* Using a rolling quarter */
			,Active_Medical = case when ISNULL(active_medical.ACTIVE_MEDICAL,0) > 0
										then 'Y'
								  else 'N'
								end
							 
			,Cost_Code = RTRIM(cd.Cost_Code)
			,Cost_Code2 = RTRIM(cc.CCCode2)
			,CC_Injury = cc.CCName1
			,CC_Current = ISNULL(cc.CCName2, cc.CCName1)
			,Med_Cert_Status_This_Week = dbo.udf_ExtractMedCertStatus_Code(
											(select top 1 [Type] from dbo.vw_WOW_Medical_Cert mc
												where mc.CLAIM_NO = cd.CLAIM_NO and mc.CREATE_DTE < @as_at
												order by MC.DTE_FROM desc, mc.CREATE_DTE desc))
			,Capacity = case when (select top 1 [Type] from dbo.vw_WOW_Medical_Cert mc
										where mc.CLAIM_NO = cd.CLAIM_NO and mc.CREATE_DTE < @as_at
										order by MC.DTE_FROM desc, mc.CREATE_DTE desc) = 'P'
								then 'Partial Capacity'
							when (select top 1 [Type] from dbo.vw_WOW_Medical_Cert mc
										where mc.CLAIM_NO = cd.CLAIM_NO and mc.CREATE_DTE < @as_at
										order by MC.DTE_FROM desc, mc.CREATE_DTE desc) = 'U'
								then 'No Capacity'
							else ''
						end
			,Entitlement_Weeks = ent_period.EntitlementPeriod
			,Med_Cert_Status_Prev_1_Week = dbo.udf_ExtractMedCertStatus_Code(
											(select top 1 [Type] from dbo.vw_WOW_Medical_Cert mc
												where mc.CLAIM_NO = cd.CLAIM_NO and mc.CREATE_DTE < @as_at_Prev_1_Week
												order by MC.DTE_FROM desc, mc.CREATE_DTE desc))
			,Med_Cert_Status_Prev_2_Week = dbo.udf_ExtractMedCertStatus_Code(
											(select top 1 [Type] from dbo.vw_WOW_Medical_Cert mc
												where mc.CLAIM_NO = cd.CLAIM_NO and mc.CREATE_DTE < @as_at_Prev_2_Week
												order by MC.DTE_FROM desc, mc.CREATE_DTE desc))
			,Med_Cert_Status_Prev_3_Week = dbo.udf_ExtractMedCertStatus_Code(
											(select top 1 [Type] from dbo.vw_WOW_Medical_Cert mc
												where mc.CLAIM_NO = cd.CLAIM_NO and mc.CREATE_DTE < @as_at_Prev_3_Week
												order by MC.DTE_FROM desc, mc.CREATE_DTE desc))
			,Med_Cert_Status_Prev_4_Week = dbo.udf_ExtractMedCertStatus_Code(
											(select top 1 [Type] from dbo.vw_WOW_Medical_Cert mc
												where mc.CLAIM_NO = cd.CLAIM_NO and mc.CREATE_DTE < @as_at_Prev_4_Week
												order by MC.DTE_FROM desc, mc.CREATE_DTE desc))
			,Is_Last_Month = @is_last_month
			
			,IsPreClosed = case when claim_preclosed.CLAIM_NO IS NOT NULL
									then 1
								else 0
							end
			,IsPreOpened = case when claim_preopened.CLAIM_NO IS NOT NULL
									then 1
								else 0
							end
			
			/* Not Required */
			,NCMM_Complete_Action_Due = ''
			,NCMM_Complete_Remaining_Days = ''
			,NCMM_Prepare_Action_Due = ''
			,NCMM_Prepare_Remaining_Days = ''
			
			,ClaimStatus = cd.CLAIM_STATUS
			,Cost_Code4 = RTRIM(cc.CCCode4)
			,Cost_Code5 = RTRIM(cc.CCCode5)
			
			/* Measure the number of weeks since the DON */
			,Weeks_Since_DON = dbo.udf_GetWeeksIn(ISNULL(cd.DTE_CLAIM_ENTERED,cd.DTE_CLAIM_RECEIVED),@as_at)
			
			,Injury_Type = dbo.GetJurisdictionalDescriptionFromTypeName('InjuryNature', ISNULL(cd.DTE_CLAIM_ENTERED,cd.DTE_CLAIM_RECEIVED), cd.JURISDICTION, cd.NATURE_OF_INJURY, '')
			,Mechanism_Of_Injury = dbo.GetJurisdictionalDescriptionFromTypeName('Mechanism', ISNULL(cd.DTE_CLAIM_ENTERED,cd.DTE_CLAIM_RECEIVED), cd.JURISDICTION, cd.MECHANISM_OF_INJURY, '')
			
	FROM	#claim cd
			LEFT JOIN (SELECT EntitlementID, Claim, EntitlementPeriod
							FROM Entitle
							WHERE [Type] = 'I' AND PaymentType = 0
								AND DateEntered <= @as_at) ent_period ON ent_period.Claim = cd.CLAIM_NO
			LEFT JOIN ClientSpecific_WOW_CostCentres cc on cd.COST_CODE = cc.CCCode1
			
			/* For retrieving IsPreClosed */
			LEFT JOIN #claim_prior claim_preclosed ON claim_preclosed.CLAIM_NO = cd.CLAIM_NO
				AND claim_preclosed.CLAIM_CLOSED_FLAG = 'Y'
				
			/* For retrieving IsPreOpened */
			LEFT JOIN #claim_prior claim_preopened ON claim_preopened.CLAIM_NO = cd.CLAIM_NO
				AND claim_preopened.CLAIM_CLOSED_FLAG = 'N'
			
			/* External payments */
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TOTAL_PAID,0)) as TOTAL_PAID 
							FROM #external_payments 
							GROUP BY CLAIM) total_paid ON total_paid.CLAIM = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TRANS_AMOUNT,0)) as TOTAL_RECOVERIES
							FROM #external_payments
							WHERE ISRECOVERY = 1
							GROUP BY CLAIM) recovs ON recovs.CLAIM = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TRANS_AMOUNT,0)) as WEEKLY_COMP
							FROM #external_payments
							WHERE SICATEGORYID in (390, 391) AND TRANSACTION_DTE > @as_at_prev_3_months
							GROUP BY claim) weekly_comp ON weekly_comp.CLAIM = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TRANS_AMOUNT,0)) as ACTIVE_MEDICAL
							FROM #external_payments
							WHERE SICODE like '1P%' AND TRANSACTION_DTE > @as_at_prev_3_months
							GROUP BY CLAIM) active_medical ON active_medical.CLAIM = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TRANS_AMOUNT,0)) as PHYSIO_PAID
							FROM #external_payments 
							WHERE (SICODE like 'pta%' OR SICODE like 'ptx%') AND ESTIMATE_TYPE = 7
							GROUP BY CLAIM) phy_paid ON phy_paid.CLAIM = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TRANS_AMOUNT,0)) as CHIRO_PAID
							FROM #external_payments
							WHERE (SICODE like 'cha%' OR SICODE like 'chx%') AND ESTIMATE_TYPE = 7
							GROUP BY CLAIM) chiro_paid ON chiro_paid.CLAIM = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TRANS_AMOUNT,0)) as MASSAGE_PAID
							FROM #external_payments
							WHERE (SICODE like 'rma%' OR SICODE like 'rmx%') AND ESTIMATE_TYPE = 7
							GROUP BY CLAIM) mass_paid ON mass_paid.CLAIM = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TRANS_AMOUNT,0)) as OSTEOPATHY_PAID
							FROM #external_payments 
							WHERE (SICODE like 'osa%' OR SICODE like 'osx%') AND ESTIMATE_TYPE = 7
							GROUP BY CLAIM) ost_paid ON ost_paid.CLAIM = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TRANS_AMOUNT,0)) as ACUPUNCTURE_PAID
							FROM #external_payments 
							WHERE SICODE = 'ott001' AND ESTIMATE_TYPE = 7
							GROUP BY CLAIM) acu_paid ON acu_paid.CLAIM = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TOTAL_PAID,0)) as TOTAL_PAID_LAST_3M
							FROM #external_payments 
							WHERE TRANSACTION_DTE > @as_at_prev_3_months
							GROUP BY CLAIM) total_paid_last_3m ON total_paid_last_3m.CLAIM = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TRANS_AMOUNT,0)) as REHAB_PAID
							FROM #external_payments 
							WHERE SICODE like 'or%' AND ESTIMATE_TYPE = 9
								AND TRANSACTION_DTE > @as_at_prev_3_months
							GROUP BY CLAIM) rehab_paid ON rehab_paid.CLAIM = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TRANS_AMOUNT,0)) as COMMON_LAW
							FROM #external_payments
							WHERE SICATEGORYID in (306, 368, 400)
							GROUP BY claim) clp ON clp.CLAIM = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(TRANS_AMOUNT,0)) as MEDICAL_PAID
							FROM #external_payments
							WHERE SICODE like '1P%'
							GROUP BY CLAIM) med_paid ON med_paid.CLAIM = cd.CLAIM_NO
							
			/* Weekly benefit payments */
			LEFT JOIN (SELECT DISTINCT CLAIM
							FROM #weekly_payments
							WHERE latest_datepaid_prev IS NOT NULL
								AND DATEDIFF(MONTH, latest_datepaid_prev, latest_datepaid) > 3) wbp ON wbp.claim = cd.CLAIM_NO
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(paid,0)) as WEEKLY_PAID
							FROM #weekly_payments
							GROUP BY CLAIM) weekly_paid ON weekly_paid.claim = cd.CLAIM_NO
							
			LEFT JOIN (SELECT CLAIM, SUM(ISNULL(incurred,0)) as INVEST_INCURRED
							FROM #estimate
							WHERE estimate_type = 19
							GROUP BY claim) invest_incur ON invest_incur.CLAIM = cd.CLAIM_NO
			
	WHERE	ISNULL(ent_period.EntitlementID, 1) = ISNULL((SELECT MAX(ent_period2.EntitlementID)
																	FROM Entitle ent_period2
																	WHERE ent_period2.[Type] = 'I' AND ent_period2.PaymentType = 0
																		AND ent_period2.DateEntered <= @as_at
																		AND ent_period2.Claim = ent_period.Claim), 1)
							
	/* Drop remaining temp tables */
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL DROP table #claim
	IF OBJECT_ID('tempdb..#claim_prior') IS NOT NULL DROP table #claim_prior
	IF OBJECT_ID('tempdb..#claim_status_history') IS NOT NULL DROP table #claim_status_history
	IF OBJECT_ID('tempdb..#external_payments') IS NOT NULL DROP table #external_payments
	IF OBJECT_ID('tempdb..#weekly_payments') IS NOT NULL DROP table #weekly_payments
	IF OBJECT_ID('tempdb..#estimate') IS NOT NULL DROP table #estimate
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO