SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Dustin (DART)
-- CREATE date: 10/15/2015 14:31:45
-- Description:	SQL store procedure to generate data for AWC Dashboard
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_AWC_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_AWC_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_AWC_GenerateData]
	@system varchar(20),
	@prd_year_start int = null,
	@prd_month_start int = null
AS
BEGIN	
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF
	
	/*** Begin: Cleaning up ***/
	
	IF OBJECT_ID('tempdb..#estimate_summary_clm') IS NOT NULL DROP TABLE #estimate_summary_clm
	IF OBJECT_ID('tempdb..#data_clm') IS NOT NULL DROP TABLE #data_clm
	IF OBJECT_ID('tempdb..#clm_list') IS NOT NULL DROP TABLE #clm_list
	IF OBJECT_ID('tempdb..#payment') IS NOT NULL DROP TABLE #payment
	IF OBJECT_ID('tempdb..#data_policy') IS NOT NULL DROP table #data_policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL DROP table #activity_detail_audit
	IF OBJECT_ID('tempdb..#check') IS NOT NULL DROP TABLE #check
	
	/*** End: Cleaning up ***/
	
	/*** Begin: Commmon variables ***/
		
	DECLARE @SQL varchar(MAX)
	DECLARE @current_date datetime = GETDATE()
	
	/* default: end of last month */
	DECLARE @overall_prd_end datetime = DATEADD(m, DATEDIFF(m, 0, @current_date), -1) + '23:59'
	
	/*	get max Time_ID date */
	DECLARE @max_Time_ID datetime = ISNULL((SELECT dbo.udf_GetAWC_MaxTimeID(UPPER(@system))), @overall_prd_end)
	
	IF @prd_year_start is null
		/* last year from max Time_ID */
		SET @prd_year_start = YEAR(@max_Time_ID) - 1
	
	IF @prd_month_start is null
		/* November, last year from max Time_ID */
		SET @prd_month_start = 11
		
	DECLARE @overall_prd_start datetime = CAST(CAST(@prd_year_start as varchar) + '/' 
									+ CAST(@prd_month_start as varchar) 
									+ '/01' as datetime)
	
	DECLARE @loops int = DATEDIFF(month, @overall_prd_start, @current_date)
	DECLARE @i int = @loops
	DECLARE @prd_start_temp datetime
		
	CREATE TABLE #check
	(
		Id int null
	)
		
	/*** End: Commmon variables ***/

	/* Clean up Time_IDs:
		Last 3 months
		Before November, last year
	*/
	SET @SQL = 'DELETE FROM [DART].[dbo].[' + UPPER(@system) + '_AWC]
				WHERE Time_ID IN (SELECT DISTINCT TOP 3 Time_ID
									FROM [DART].[dbo].[' + UPPER(@system) + '_AWC]
									ORDER BY Time_ID DESC)
					OR Time_ID < ''' + CONVERT(VARCHAR, @overall_prd_start, 120) + ''''
	EXEC(@SQL)
	
	/*** Begin: Process the estimate details data ***/
	
	CREATE TABLE #estimate_summary_clm
	(
		claim varchar(19)
		,totalamt money
	) 
	
	SET @SQL = 'CREATE INDEX pk_estimate_summary_clm_' + CONVERT(VARCHAR, @@SPID) + ' ON #estimate_summary_clm(claim, totalamt)'
	EXEC(@SQL)
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		 
	INSERT INTO #estimate_summary_clm
    SELECT Claim_No, SUM(ISNULL(Amount, 0)) FROM ESTIMATE_DETAILS GROUP BY Claim_No
    
    /*** End: Process the estimate details data ***/
    
    /*** Begin: Process the claim data ***/
    
    /* create #data_clm table to store claim detail info */
    CREATE TABLE #data_clm
	(
		claim varchar(19)
		,policy_no char(19)
		,Claim_Closed_Flag char(1)
		,Claim_Liability_Indicator tinyint
		,renewal_no int
		,anzsic varchar(255)
	)
	
	SET @SQL = 'CREATE INDEX pk_data_clm_' + CONVERT(VARCHAR, @@SPID) + ' ON #data_clm(claim, policy_no, Claim_Closed_Flag, Claim_Liability_Indicator)'
	EXEC(@SQL)
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	SET @SQL = 'SELECT  Claim_Number
						,policy_no
						,Claim_Closed_Flag
						,Claim_Liability_Indicator
						,Renewal_No'
						+
						case when UPPER(@system) = 'HEM'
								then ',anz.DESCRIPTION'
							else ',anzsic = '''''
						end
						+
				' FROM	CLAIM_DETAIL cd INNER JOIN CLAIM_ACTIVITY_DETAIL cad ON RTRIM(cd.Claim_Number) = RTRIM(cad.Claim_no)
							AND Date_Created <= ''' + CONVERT(VARCHAR, @overall_prd_end, 120) + ''' AND Claim_Number <> ''''
						LEFT OUTER JOIN amendment_exemptions ae ON cd.Claim_Number = ae.claim_no'
						+
						case when UPPER(@system) = 'HEM'
								then ' LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE
										WHERE ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2
																			WHERE anz2.CODE = anz.CODE),1)'
							else ''
						end
	
	INSERT INTO #data_clm
	EXEC(@SQL)
	
	CREATE TABLE #clm_list
	(
		claim varchar(19)
		,exclude bit
	)
	
	SET @SQL = 'CREATE INDEX pk_clm_list_' + CONVERT(VARCHAR, @@SPID) + ' ON #clm_list(claim, exclude)'
	EXEC(@SQL)
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #clm_list
	SELECT cd.claim
		   ,exclude = (CASE WHEN (cd.Claim_Liability_Indicator IN (1,6,12))
									OR (cd.Claim_Liability_Indicator IN (4) AND est_clm.totalamt <= 0)
									OR (cd.Claim_Closed_Flag = 'Y' AND est_clm.totalamt = 0)
							   THEN 1
						   ELSE 0
					   END)
	FROM #data_clm cd INNER JOIN #estimate_summary_clm est_clm ON cd.claim = est_clm.claim
	
	/* Drop unused temp table */
	IF OBJECT_ID('tempdb..#estimate_summary_clm') IS NOT NULL DROP table #estimate_summary_clm
	
	/*** End: Process the claim data ***/
	
	/*** Begin: Process the policy data ***/
	
	/* create #data_policy table to store policy info for claim */
	CREATE TABLE #data_policy
	(
		policyno char(19)
		,renewal_no int
		,bastarif money
		,wages money
		,const_flag_final int
	)
	
	/* create index for #policy table */
	SET @SQL = 'CREATE INDEX pk_data_policy_' + CONVERT(VARCHAR, @@SPID) + ' ON #data_policy(policyno, renewal_no)'
	EXEC(@SQL)
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	IF UPPER(@system) <> 'TMF'
	BEGIN
		INSERT INTO #data_policy
		SELECT	POLICY_NO
				,RENEWAL_NO
				,BTP
				,WAGES0
				,Process_Flags
		FROM dbo.PREMIUM_DETAIL pd
		WHERE EXISTS (SELECT 1 FROM #data_clm cd where cd.policy_no = pd.POLICY_NO)
		ORDER BY POLICY_NO, RENEWAL_NO
	END
	
	/* create #activity_detail_audit table to store policy info for claim */
	CREATE TABLE #activity_detail_audit
	(
		policyno char(19)
		,renewal_no int
		,tariff int
		,wages_shifts money
	)
	
	/* create index for #activity_detail_audit table */
	SET @SQL = 'CREATE INDEX pk_activity_detail_audit_' + CONVERT(VARCHAR, @@SPID)
				+ ' ON #activity_detail_audit(policyno, renewal_no, tariff)'
	EXEC(@SQL)

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	IF UPPER(@system) = 'HEM'
	BEGIN
		INSERT INTO #activity_detail_audit
		SELECT Policy_No, Renewal_No, Tariff, SUM(ISNULL(Wages_Shifts, 0))
		FROM ACTIVITY_DETAIL_AUDIT ada
		GROUP BY Policy_No, Renewal_No, Tariff
		HAVING EXISTS (SELECT 1 FROM #data_clm cd where cd.policy_no = ada.Policy_No)
	END
			
	/*** End: Process the policy data ***/
	
	/*** Begin: Process the payment data ***/
	
	CREATE TABLE #payment
	(
		claim varchar(19)
		,submitted_trans_date datetime
		,ppstart datetime
		,ppend datetime
		,wc_paytype varchar(8)
		,paytype varchar(15)
		,payamt money
	)
	
	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_payment_submitted_trans_date ON #payment(submitted_trans_date) INCLUDE (claim)'
	EXEC(@SQL)
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT	INTO #payment
	SELECT  u.Claim_No
			,submitted_trans_date
			,Period_Start_Date
			,Period_End_Date
			,WC_Payment_Type
			,Payment_Type
			,Trans_Amount = (SELECT SUM(ISNULL(u1.Trans_Amount, 0))
								FROM uv_submitted_Transaction_Payments u1
								WHERE u1.Claim_No = u.Claim_No
									AND u1.Period_Start_Date = u.Period_Start_Date
									AND u1.Period_End_Date = u.Period_End_Date
									AND u1.WC_Payment_Type = u.WC_Payment_Type
									AND u1.Payment_Type = u.Payment_Type)
	FROM uv_submitted_Transaction_Payments u
	WHERE u.submitted_trans_date = (SELECT MIN(u1.submitted_trans_date)
									FROM uv_submitted_Transaction_Payments u1 
									WHERE u1.Claim_No = u.Claim_No
										  AND u1.Period_Start_Date = u.Period_Start_Date 
										  AND u1.Period_End_Date = u.Period_End_Date 
										  AND u1.WC_Payment_Type = u.WC_Payment_Type 
										  AND u1.Payment_Type = u.Payment_Type)
		AND u.submitted_trans_date BETWEEN @overall_prd_start AND @overall_prd_end
		AND u.WeeklyPayment = 1
	GROUP BY u.claim_no, submitted_trans_date
			 ,Period_Start_Date, Period_End_Date
			 ,WC_Payment_Type, Payment_Type
	ORDER BY claim_no, payment_type, Period_Start_Date, Period_End_Date

	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_payment_payamt ON #payment(payamt)'
	EXEC(@SQL)
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* data cleaning */
	DELETE FROM #payment WHERE payamt = 0
	DELETE FROM #payment
	WHERE claim IN (SELECT	p.claim
					FROM	#payment p
							INNER JOIN #clm_list cl on p.claim = cl.claim AND cl.exclude = 1)
		
	/* Drop unused temp table */					
	IF OBJECT_ID('tempdb..#clm_list') IS NOT NULL DROP TABLE #clm_list

	/*** End: Process the payment data ***/

	WHILE (@i >= 0)
	BEGIN
		SET @prd_start_temp = DATEADD(mm, @i, @overall_prd_start)
		DECLARE @yy int = YEAR(@prd_start_temp)
		DECLARE @mm int = MONTH(@prd_start_temp)
		
		SET @SQL = 'SELECT TOP 1 Id FROM [DART].[dbo].[' + UPPER(@system) + '_AWC]
						WHERE YEAR(Time_ID) = ' + CONVERT(varchar, @yy) + ' AND MONTH(Time_ID ) = ' + CONVERT(varchar, @mm)
		
		INSERT INTO #check
		EXEC(@SQL)
		
		If NOT EXISTS(SELECT * FROM #check)
		   AND 
		   CAST(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
				< CAST(CAST(YEAR(GETDATE()) as varchar) + '/' +  CAST(MONTH(GETDATE()) as varchar) + '/01' as datetime)
		BEGIN
			IF OBJECT_ID('tempdb..#awc_list') IS NOT NULL DROP table #awc_list
			
			DECLARE @prd_start datetime = CAST(CAST(@yy as char(4)) + '/'  + CAST(@mm as char(2)) + '/01' as datetime)
			DECLARE @prd_end datetime  = DATEADD(dd, -1, DATEADD(mm, 1, @prd_start)) + '23:59'
			
			/* Display action message to console window */
			PRINT 'Start inserting ' + CAST(@prd_start_temp as varchar)
			
			CREATE TABLE #awc_list
			(
				claim varchar (19)
				,injdate datetime
			)
			
			SET @SQL = 'CREATE INDEX pk_awc_list_' + CONVERT(VARCHAR, @@SPID) + ' ON #awc_list(claim,injdate)'
			EXEC(@SQL)
			
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				RETURN
			END
			
			INSERT INTO #awc_list
			SELECT DISTINCT RTRIM(cla.claim),ca.Date_of_Injury
			FROM #payment cla INNER JOIN cd_audit ca ON cla.claim = ca.claim_no
					AND cla.submitted_trans_date BETWEEN @prd_start and @prd_end
					AND ca.id = (SELECT MAX(id)
									FROM cd_audit
									WHERE ca.claim_no = claim_no
										AND create_date < @prd_end)
					AND ca.fund <> 98
					
			SET @SQL = 'INSERT INTO [Dart].[dbo].[' + UPPER(@system) + '_AWC]
						SELECT	Time_ID = ''' + CONVERT(VARCHAR, @prd_end, 120) + '''
								,Claim_no = awc.claim
								,Team = case when RTRIM(ISNULL(co.Grp, '''')) = ''''
														OR NOT EXISTS (select distinct grp
																			from claims_officers
																			where active = 1 and len(rtrim(ltrim(grp))) > 0
																				and grp like co.Grp + ''%'')
														then ''Miscellaneous''
													else RTRIM(UPPER(co.Grp))
												end
								,Case_manager = ISNULL(UPPER(co.First_Name + '' '' + co.Last_Name), ''Miscellaneous'')
								,awc.injdate
								,create_date = ''' + CONVERT(varchar, @current_date, 120) + '''
								,cd.policy_no'
								+
								/* Determine Employer size: Small, Small-Medium, Medium or Large.
										Set default to Small when missing policy data; */
								case when UPPER(@system) <> 'TMF'
										then ',Empl_Size = case when pd.bastarif IS NULL OR pd.const_flag_final IS NULL OR pd.wages IS NULL then ''A - Small''
																when pd.wages <= 300000 then ''A - Small''
																when pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final = 1 then ''A - Small''
																when pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final <> 1 then ''B - Small-Medium''
																when pd.wages > 1000000 AND pd.wages <= 5000000 then ''C - Medium''
																when pd.wages > 5000000 AND pd.wages <= 15000000 AND pd.bastarif <= 100000 then ''C - Medium''
																when pd.wages > 15000000 then ''D - Large''
																when pd.wages > 5000000 AND pd.bastarif > 100000 then ''D - Large''
																else ''A - Small''
															end'
									else ',Empl_Size = '''''
								end
								+
								',Cert_Type = case when mc.TYPE = ''P'' then ''No Time Lost'' 
												  when mc.TYPE = ''T'' then ''Totally Unfit''
												  when mc.TYPE = ''S'' then ''Suitable Duties''
												  when mc.TYPE = ''I'' then ''Pre-Injury Duties''
												  when mc.TYPE = ''M'' then ''Permanently Modified Duties''
												  else ''Invalid type''
											 end
								,Med_cert_From = mc.Date_From
								,Med_cert_To = mc.Date_To'
								+
								case when UPPER(@system) <> 'TMF'
										then ',Account_Manager = isnull(acm.account_manager,''Miscellaneous'')'
									else ',Account_Manager = '''''
								end
								+
								case when UPPER(@system) = 'HEM'
										then ',cno.CELL_NO as Cell_no'
									else ',Cell_no = null'
								end
								+
								case when UPPER(@system) = 'HEM'
										then ',Portfolio = case when isnull(cd.anzsic,'''') <> ''''
																	then
																		case when UPPER(cd.anzsic) = ''ACCOMMODATION''
																				or UPPER(cd.anzsic) = ''PUBS, TAVERNS AND BARS'' 
																				or UPPER(cd.anzsic) = ''CLUBS (HOSPITALITY)'' then cd.anzsic
																			else ''Other''
																		end
																else
																	case when LEFT(ada.tariff, 1) = ''1'' and LEN(ada.tariff) = 7
																			then 
																				case when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = ''571000''
																						then ''Accommodation''
																					when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = ''572000''
																						then ''Pubs, Taverns and Bars''
																					when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = ''574000''
																						then ''Clubs''
																					else ''Other''
																				end
																		else
																			case when ada.tariff = 571000 then ''Accommodation''
																				when ada.tariff = 572000 then ''Pubs, Taverns and Bars''
																				when ada.tariff = 574000 then ''Clubs''
																				else ''Other''
																			end
																	end
															end'
									else ',Portfolio = '''''
								end
								+
						' FROM	#awc_list awc
								INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = awc.claim
								LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
								INNER JOIN #data_clm cd on awc.claim = cd.claim
								INNER JOIN cad_audit cada1 on cada1.Claim_No = awc.claim
								INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
								LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To FROM Medical_Cert) mc
									ON mc.Claim_no = cd.claim AND mc.id = ISNULL((SELECT MAX(mc1.id)
																					FROM Medical_Cert mc1
																					WHERE mc1.Claim_no = mc.Claim_no
																						AND mc1.cancelled_date is null
																						AND mc1.cancelled_by is null), '''')'
								+
								case when UPPER(@system) <> 'TMF'
										then ' LEFT JOIN #data_policy pd ON pd.policyno = cd.policy_no and pd.renewal_no = cd.renewal_no
          										LEFT JOIN (SELECT U.First_Name + '' '' + U.SurName as account_manager, claim_number
          														FROM CLAIM_DETAIL cld LEFT JOIN POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
																	LEFT JOIN Broker Br on PTD.Broker_No = Br.Broker_no
																	LEFT JOIN UnderWriters U on BR.emi_Contact = U.Alias
																WHERE U.is_Active = 1 AND U.is_EMLContact = 1) as acm on acm.claim_number = cd.claim'
									else ''
								end
								+
								case when UPPER(@system) = 'HEM'
										then '/* for retrieving cell number info */
												LEFT JOIN (SELECT CELL_NO, claim_number
																FROM CLAIM_DETAIL cld INNER JOIN POLICY_TERM_DETAIL ptd ON cld.Policy_No = ptd.POLICY_NO) as cno
																	ON cno.Claim_Number = cd.claim
															
												/* for retrieving WIC info */
												LEFT JOIN #activity_detail_audit ada
													ON ada.policyno = cd.policy_no AND ada.renewal_no = cd.renewal_no'
									else ''
								end
								+
						' WHERE cada1.id = (SELECT MAX(cada2.id)
												FROM  cad_audit cada2 
												WHERE cada2.claim_no = cada1.claim_no
													AND cada2.transaction_date <= ''' + CONVERT(VARCHAR, @prd_end, 120) + ''')
								AND coa1.id = (SELECT   MAX(coa2.id) 
												FROM   CO_audit coa2
												WHERE  coa2.officer_id = coa1.officer_id
													AND coa2.create_date <= ''' + CONVERT(VARCHAR, @prd_end, 120) + ''')'
								+
								case when UPPER(@system) = 'HEM'
										then '	AND ada.wages_shifts = (SELECT MAX(ada2.wages_shifts)
																			FROM #activity_detail_audit ada2
																			WHERE ada2.policyno = ada.policyno
																				AND ada2.renewal_no = ada.renewal_no)'
									else ''
								end
			
			EXEC(@SQL)
					
			/* Drop unused temp table */
			IF OBJECT_ID('tempdb..#awc_list') IS NOT NULL DROP table #awc_list
		END
		
		DELETE FROM #check
		
		SET @i = @i - 1
	END
	
	/*** Begin: Cleaning up ***/
	
	IF OBJECT_ID('tempdb..#data_clm') IS NOT NULL DROP TABLE #data_clm
	IF OBJECT_ID('tempdb..#payment') IS NOT NULL DROP TABLE #payment
	IF OBJECT_ID('tempdb..#data_policy') IS NOT NULL DROP table #data_policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL DROP table #activity_detail_audit
	IF OBJECT_ID('tempdb..#check') IS NOT NULL DROP TABLE #check
	
	/*** End: Cleaning up ***/
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_AWC_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_AWC_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_AWC_GenerateData] TO [DART_Role]
GO