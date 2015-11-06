SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_WOW_Dashboard_Portfolio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_WOW_Dashboard_Portfolio]
GO

CREATE PROCEDURE [dbo].[usp_WOW_Dashboard_Portfolio]
	@AsAt datetime,
	@Is_Last_Month bit
AS
BEGIN
	SET NOCOUNT ON
	
	/* Drop all temp tables first */
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL DROP table #claim
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL
	
	DECLARE @Reporting_Date datetime
	SET @Reporting_Date = convert(datetime, convert(char, GETDATE(), 106)) + '23:59'
	
	SET @AsAt = convert(datetime, convert(char, @AsAt, 106))
	
	-- determine if this is generating data process for last month or not
	IF @Is_Last_Month = 1
		SET @AsAt = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1)	-- get the end of last month as input parameter
	
	DECLARE @_curr_fiscal_yr datetime
	SET @_curr_fiscal_yr = case when MONTH(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) <= 6 
									then CAST(YEAR(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) AS varchar(5)) + '-06-30'
								else CAST(YEAR(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) +1 AS varchar(5)) + '-06-30'	  
							end
	
	DECLARE @SQL varchar(500)
	
	-- end day of next week from @AsAt
	DECLARE @AsAt_Next_Week_End datetime
	SET @AsAt_Next_Week_End = DATEADD(wk, 1, DATEADD(dd, 7-(DATEPART(dw, @AsAt)), @AsAt))
	
	IF OBJECT_ID('tempdb..#claim') IS NULL
	BEGIN
		/* create #claim table to store claim detail info */
		CREATE TABLE #claim
		(
			claim CHAR(19)
			,claim_status varchar(1)
			,date_of_injury datetime
			,date_claim_opened datetime
			,date_claim_closed datetime
			,date_claim_received datetime
			,date_claim_reopened datetime
		)	

		/* create index for #claim table */
		SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(claim)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #claim
			SELECT	cd.Claim
					,cd.ClaimStatus
					,cd.InjuryDate
					,cd.DateOpened
					,cd.DateClosed
					,cd.DateReceived
					,cd.DateReopened
			FROM dbo.AccData cd
			WHERE cd.Claim <> ''
	END
	
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NULL
	BEGIN
		CREATE TABLE #_WEEKLY_PAYMENT_ALL
		(
			payment_no int
			,claim varchar(19)
			,trans_date datetime
			,payamt money
			,payment_type int
		)

		/* create index for #_WEEKLY_PAYMENT_ALL table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_ALL_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #_WEEKLY_PAYMENT_ALL(payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #_WEEKLY_PAYMENT_ALL
		SELECT  InvoiceID
				,pr.Claim
				,InvoiceDate
				,InvoiceAmount
				,PaymentType
		FROM Invceacc pr INNER JOIN #claim cd on pr.Claim = cd.claim
		WHERE	InvoiceDate <= @AsAt
				
				/* remove reversed claims */
				AND ABS(InvoiceAmount) > 1
	END
	
	SELECT	Case_Manager = UPPER(per.FullName)
			,Reporting_Date = @Reporting_Date
			,Claim_No = cd.Claim
			,Company_Name = cl.ClientName
			,Worker_Name = cd.FirstNames + ', ' + cd.SurName
			,Employee_Number = cd.EmployeeNo
			,Worker_Phone_Number = cd.WorkPhone
			,Date_of_Birth = cd.DOB
			,Date_of_Injury = cd.InjuryDate
			,Total_Paid = (select SUM(pr.InvoiceAmount) + SUM(pr.AmountExGST)
								from Invceacc pr
								where pr.Claim = cd.Claim
									and InvoiceDate <= @AsAt)
			,Date_Claim_Closed = cd.DateClosed
			,Date_Claim_Received = cd.DateReceived
			,Date_Claim_Reopened = cd.DateReopened
			,Result_Of_Injury_Code = cd.InjuryCode
			,Create_Date = getdate()
			,NCMM_Actions_This_Week = (case when cd.ClaimStatus = 'C'
												then ''
											else
												(case when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 2
														then 'First Response Protocol- ensure RTW Plan has been developed'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 3
														then 'Complete 3 week Strategic Plan'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 4
														then 'Treatment Provider Engagement'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 6
														then 'Complete 6 week Strategic Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 10
														then 'Complete 10 Week First Response Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 16
														then 'Complete 16 Week Internal Panel Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 20
														then 'Complete 20 Week Tactical Strategy Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 26
														then 'Complete 26 week Employment Direction Pathyway Review (Internal Panel)'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 40
														then 'Complete 40 Week Tactical Strategy Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 52
														then 'Complete 52 week  Employment Direction Determination (Internal Panel)'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 65
														then 'Complete 65 Week Tactical Strategy Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 76
														then 'Complete 78 week Review in preparation for 78 week panel/handover ( Book Internal Panel)-panel in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 78
														then 'Complete 78 week Internal Panel Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 90
														then 'Complete 90 Week Work Capacity Review (Internal Panel)'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 100
														then 'Complete 100 week Work Capacity Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 114
														then 'Complete 114 week Work Capacity Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 132
														then 'Complete 132 week Internal Panel'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) % 13 = 0
															and CEILING((DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 = 0
														then 'Recovering Independence Internal Panel Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) % 13 = 0
															and CEILING((DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 <> 0
														then 'Recovering Independence Quarterly Review'
													else ''
												end)
										end)
			,NCMM_Actions_Next_Week = (case when cd.ClaimStatus = 'C'
												then ''
											else
												(case when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 2
														then 'Prepare for 3 week Strategic Plan- due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 5
														then 'Prepare for 6 week Strategic Review (book Internal panel)- panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 9
														then 'Prepare for 10 week First Response Review- review due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 14
														then 'Prepare for 16 Week Internal Panel Review ( book Internal Panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 15
														then 'Prepare for 16 Week Internal Panel Review- panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 18
														then 'Prepare 20 Week Tactical Strategy Review -review due  in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 19
														then 'Prepare 20 Week Tactical Strategy Review-  review due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 24
														then 'Prepare 26 Week Employment Direction Pathway Review ( book internal panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 25
														then 'Prepare 26 Week Employment Direction Pathway Review-panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 38
														then 'Prepare 40 Week Tactical Strategy Review-review due in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 39
														then 'Prepare 40 Week Tactical Strategy Review- review due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 50
														then 'Prepare Employment Direction Determination Review ( book Internal Panel)-panel  in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 51
														then 'Prepare Employment Direction Determination Review-panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 63
														then 'Prepare 65 Week Tactical Strategy Review- review due in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 64
														then 'Prepare 65 Week Tactical Strategy Review- review due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 75
														then 'Start preparing  78 week  Work Capacity Review - review to be completed  in week 76 as preparation for handover'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 77
														then 'Prepare Review for 78 week panel- Panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 88
														then 'Prepare 90 Week Work Capacity Review (book internal panel)-panel  in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 89
														then 'Prepare 90 Week Work Capacity Review -panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 98
														then 'Prepare 100 week Work Capacity Review- review due in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 99
														then 'Prepare 100 week Work Capacity Review- review due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 112
														then 'Prepare 114 week Work Capacity Review-review due in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 113
														then 'Prepare 114 week Work Capacity Review- review due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 130
														then 'Prepare 132 week Internal Panel (Book Internal panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 131
														then 'Prepare 132 week Internal Panel- panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) % 13 = 11
															and CEILING((DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 = 0
														then 'Prepare review for  Internal Panel (Book Internal panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) % 13 = 12
															and CEILING((DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 = 0
														then 'Prepare review  for Internal Panel- panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) % 13 = 11
															and CEILING((DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 <> 0
														then 'Prepare Recovering Independence Quarterly Review-review due in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) % 13 = 12
															and CEILING((DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 <> 0
														then 'Prepare Recovering Independence Quarterly Review- review due next week'
													else ''
												end)
										end)
			,Action_Required = case when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) in (2,3,4,5,6,9,10,14,15,16,18,19,20,
																					 24,25,26,38,39,40,50,51,52,63,64,65,
																					 75,77,76,78,88,89,90,98,99,100,112,113,
																					 114,130,131,132) 
									  OR (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) -132) % 13 = 0
										  AND CEILING((DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) -132) % 13 = 0
										  AND CEILING((DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0)
									  OR (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) -132) % 13 = 11
										  AND CEILING((DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) -132) % 13 = 12
										  AND CEILING((DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) -132) % 13 = 11
										  AND CEILING((DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0)
									  OR (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) -132) % 13 = 12
										  AND CEILING((DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0) then 'Y'
									else 'N'
							   end
			,Weeks_In = DATEDIFF(week,cd.InjuryDate,@AsAt_Next_Week_End)
			,Weeks_Band = case when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 0 and 12 then 'A.0-12 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 13 and 18 then 'B.13-18 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 19 and 22 then 'C.19-22 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 23 and 26 then 'D.23-26 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 27 and 34 then 'E.27-34 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 35 and 48 then 'F.35-48 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 48 and 52 then 'G.48-52 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 53 and 60 then 'H.53-60 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 61 and 76 then 'I.61-76 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 77 and 90 then 'J.77-90 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 91 and 100 then 'K.91-100 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 101 and 117 then 'L.101-117 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 118 and 130 then 'M.118-130 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 130 then 'N.130+ WK'
						  end
			,Hindsight = case when cd.InjuryDate > DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-36,@_curr_fiscal_yr)) + 1, 0))
								 and  cd.InjuryDate <= DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-24,@_curr_fiscal_yr)) + 1, 0)) 
								 then '3 years'
							  when cd.InjuryDate > DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-60,@_curr_fiscal_yr)) + 1, 0))
								 and  cd.InjuryDate <= DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-48,@_curr_fiscal_yr)) + 1, 0)) 
								 then '5 years'
							  else ''
						 end
			,Is_Last_Month = @Is_Last_Month
	FROM	AccData cd
	
			-- for getting case manager
			LEFT JOIN Permissn per on per.UserID = cd.CaseManagerID
			
			-- for getting company
			LEFT JOIN Clients cl on cl.ID = cd.ClientID
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO