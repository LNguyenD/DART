SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [usp_Dashboard_EML_AWC] 2013, 1
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_EML_AWC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_EML_AWC]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_EML_AWC]
      @year int = 2011,
      @month int = 1
AS
BEGIN
	SET NOCOUNT ON
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List		
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP table #AWC_list
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL DROP table #policy
	
	declare @startdate datetime = cast(cast(@year as char(4)) + '/'  + cast(@month as char(2)) + '/01' as datetime)
	declare @enddate datetime  = dateadd(dd, -1, dateadd(mm, 1, @startdate)) + '23:59'
	
	declare @SQL varchar(500)

	--Check temp table existing then drop	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NULL
	BEGIN
		create table #_CLAIM_ESTIMATE_SUMMARY
		(
			CLAIM_NO varCHAR(19)
			,TotalAmount MONEY
		) 
		
		SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
			 
		INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
			SELECT CLAIM_NO, SUM(ISNULL(Amount, 0)) 
			FROM ESTIMATE_DETAILS
			GROUP BY claim_no
	END
	
	CREATE TABLE #_Claim_Detail
	(
		policy_no char(19)
		,Claim_no varchar(19)
		,Claim_Closed_Flag CHAR(1)
		,Claim_Liability_Indicator TINYINT
		,renewal_no INT
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_Detail_'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_Detail(policy_no, Claim_no, Claim_Closed_Flag, Claim_Liability_Indicator)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT INTO #_Claim_Detail
		-- claim detail here
		SELECT  policy_no, 
				Claim_Number,
				Claim_Closed_Flag,
				Claim_Liability_Indicator, 
				Renewal_No
		FROM CLAIM_DETAIL cd INNER JOIN CLAIM_ACTIVITY_DETAIL cad 
			ON rtrim(cd.Claim_Number) =  rtrim(cad.Claim_no)
				AND Date_Created <= @enddate AND Claim_Number <> ''
				LEFT OUTER JOIN amendment_exemptions ae ON cd.Claim_Number = ae.claim_no

	CREATE TABLE #_Claim_List
	(
		Claim_no varchar(19)
		,EXCLUDE BIT
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_List'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_List(Claim_no, EXCLUDE)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #_Claim_List
	SELECT cd.Claim_no
		   ,EXCLUDE = (CASE WHEN (cd.Claim_Liability_Indicator IN (1,6,12)) 
								 OR (cd.Claim_Liability_Indicator IN (4) 
									AND ces.TotalAmount <= 0) 
								 OR (cd.Claim_Closed_Flag = 'Y' AND ces.TotalAmount = 0)  
							   THEN 1 
						   ELSE 0 
					   END)
	FROM #_Claim_Detail cd INNER JOIN #_CLAIM_ESTIMATE_SUMMARY ces 
									  ON cd.Claim_no = ces.CLAIM_NO

	CREATE TABLE #_Claim_list_adjusted
	(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,WC_Payment_Type varchar(8)
		 ,Payment_Type varchar(15)
		 ,Trans_Amount money
	)
	
	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_
				ON [dbo].[#_Claim_list_adjusted] (submitted_trans_date)
				INCLUDE ([Claim_no])'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT  INTO #_Claim_list_adjusted
	SELECT  u.claim_no
			, submitted_trans_date
			, Period_Start_Date
			, Period_End_Date
			, WC_Payment_Type
			, Payment_Type 
			,Trans_Amount = (SELECT SUM(ISNULL(u1.Trans_Amount, 0)) 
								FROM uv_submitted_Transaction_Payments u1
								WHERE u1.Claim_No = u.claim_no 
								and u1.Period_Start_Date = u.Period_Start_Date
								and u1.Period_End_Date = u.Period_End_Date 
								and u1.WC_Payment_Type = u.WC_Payment_Type 
								and u1.Payment_Type = u.payment_type)
	FROM uv_submitted_Transaction_Payments u
	WHERE u.submitted_trans_date = (SELECT min(u1.submitted_trans_date) 
									FROM uv_submitted_Transaction_Payments u1 
									WHERE u1.Claim_No = u.claim_no 
										  and u1.Period_Start_Date = u.Period_Start_Date 
										  and u1.Period_End_Date = u.Period_End_Date 
										  and u1.WC_Payment_Type = u.WC_Payment_Type 
										  and u1.Payment_Type = u.payment_type)
		and u.submitted_trans_date between @startdate and @enddate
		and u.WeeklyPayment = 1
	GROUP BY u.claim_no, submitted_trans_date
			 ,Period_Start_Date, Period_End_Date
			 ,WC_Payment_Type, Payment_Type
	ORDER BY claim_no, payment_type, Period_Start_Date, Period_End_Date


	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_Trans_Amount
				ON [dbo].[#_Claim_list_adjusted] (Trans_Amount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	DELETE FROM #_Claim_list_adjusted WHERE Trans_Amount = 0
	DELETE FROM #_Claim_list_adjusted 
		   WHERE CLAIM_NO in (SELECT cla1.claim_no 
							  FROM #_Claim_list_adjusted cla1 
									inner join #_Claim_List cl on cla1.Claim_no = cl.Claim_no 
												and cl.EXCLUDE = 1)

	CREATE TABLE #AWC_list 
	(
		claim_no varchar (19)
		,date_of_injury datetime
	)
	
	SET @SQL = 'CREATE INDEX pk_AWC_list'+CONVERT(VARCHAR, @@SPID)+' ON #AWC_list(Claim_no,date_of_injury)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #AWC_list
		SELECT DISTINCT rtrim(cla.claim_no),ca.Date_of_Injury 
		FROM #_Claim_list_adjusted cla 
			 INNER JOIN cd_audit ca ON cla.Claim_no = ca.claim_no 
									   AND cla.submitted_trans_date between @startdate and @enddate
									   AND ca.id = (SELECT MAX(id) 
													FROM cd_audit 
													WHERE ca.claim_no = claim_no 
													AND create_date < @enddate)
										AND ca.fund <> 98

	/* create #policy table to store policy info for claim */
	CREATE TABLE #policy
	(
		policyno CHAR(19)
		,renewal_no INT
		,bastarif MONEY
		,wages MONEY
		,const_flag_final int
	)
	
	/* create index for #policy table */
	SET @SQL = 'CREATE INDEX pk_policy_'+CONVERT(VARCHAR, @@SPID)+' ON #policy(policyno, renewal_no)'
	EXEC(@SQL)

	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
			
	INSERT INTO #policy
		SELECT	POLICY_NO
				, RENEWAL_NO
				, BTP					
				, WAGES0
				, Process_Flags					
			FROM dbo.PREMIUM_DETAIL pd
			WHERE EXISTS (SELECT 1 FROM #_Claim_Detail cd where cd.policy_no = pd.POLICY_NO)
			ORDER BY POLICY_NO,RENEWAL_NO
	
	SELECT	Time_ID = @enddate
			,Claim_no = awc_list.Claim_no	
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')
			,awc_list.Date_of_Injury
			,create_date = getdate()
			,cd.policy_no
			,Empl_Size = (CASE WHEN pd.bastarif IS NULL OR pd.const_flag_final IS NULL OR pd.wages IS NULL then 'A - Small'
							  WHEN pd.wages <= 300000 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final = 1 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final <> 1 then 'B - Small-Medium'
							  WHEN pd.wages > 1000000 AND pd.wages <= 5000000 then 'C - Medium'
							  WHEN pd.wages > 5000000 AND pd.wages <= 15000000 AND pd.bastarif <= 100000 then 'C - Medium'
							  WHEN pd.wages > 15000000 then 'D - Large'
							  WHEN pd.wages > 5000000 AND pd.bastarif > 100000 then 'D - Large'
							  ELSE 'A - Small'
						  END)
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			
	FROM	#AWC_list awc_list
			INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = awc_list.claim_no
			LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
			INNER JOIN #_Claim_Detail cd on awc_list.claim_no = cd.Claim_No		
			INNER JOIN cad_audit cada1 on cada1.Claim_No = awc_list.claim_no 
			INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
			LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
          	LEFT JOIN #policy pd on pd.policyno = cd.policy_no and pd.renewal_no = cd.renewal_no 	
          	LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
						left join Broker Br on PTD.Broker_No = Br.Broker_no 
						left join UnderWriters U on  BR.emi_Contact = U.Alias 
						where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no		
			
	WHERE   cada1.id = (SELECT MAX(cada2.id) 
					      FROM  cad_audit cada2 
					      WHERE cada2.claim_no = cada1.claim_no
							    AND cada2.transaction_date <= @enddate) 
			AND coa1.id = (SELECT   MAX(coa2.id) 
						     FROM   CO_audit coa2
						     WHERE  coa2.officer_id = coa1.officer_id
								    AND coa2.create_date <= @enddate)
				  
	--drop all temp table
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail	
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP TABLE #AWC_list
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL DROP table #policy	
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC] TO [DART_Role]
GO