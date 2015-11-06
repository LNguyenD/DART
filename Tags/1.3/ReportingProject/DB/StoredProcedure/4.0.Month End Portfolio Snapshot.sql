/****** Object:  StoredProcedure [dbo].[usp_MonthEndPortfolioSnapshot]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_MonthEndPortfolioSnapshot]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_MonthEndPortfolioSnapshot]
GO

/****** Object:  StoredProcedure [dbo].[usp_MonthEndPortfolioSnapshot]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- exec usp_MonthEndPortfolioSnapshot '1/1/2012', 1, 0
create procedure [dbo].[usp_MonthEndPortfolioSnapshot]
	@reporting_date datetime,
	@IsAll bit,
	@IsRig bit
as
begin
	create table #temp
	(
		Claim_Number varchar(30),
		transaction_date datetime,
		Last_Grp varchar(30),
		grp varchar(30),
		IsTranferredClaim bit,
		Claims_Officer varchar(100),
		Claim_Closed_Flag varchar(2),
		Date_Claim_Entered datetime,
		Date_Claim_Reopened datetime,
		Payment_Total decimal(18,2),
		Incurred_Total decimal(18,2),
	)
	
	declare @tempid int
	declare @reporting_Start datetime
	SET @reporting_start = DATEADD(dd, -DAY(@reporting_date) + 1, @reporting_date)
	set @reporting_date = convert(datetime, convert(char, @reporting_date, 106)) + '23:59'

	insert into #temp
	select
		Claim_Number,
		transaction_date, 
		Last_Grp,
		grp,
		IsTranferredClaim,
		Claims_Officer,
		Claim_Closed_Flag,
		Date_Claim_Entered,
		Date_Claim_Reopened,
		Payment_Total = sum(Payments),
		Incurred_Total = sum(Est_Amount + itc + dam)
	from
	(
		SELECT 
			Claim_Number = CADA1.Claim_No,
			CADA1.transaction_date, 
			Last_Grp = CO2.grp,
			grp = CO1.grp,
			IsTranferredClaim = case when CADA1.transaction_date between @reporting_start and @reporting_date
										AND  LEFT(CO1.grp, 3) = 'RIG'
										AND
										(	LEFT(CO2.grp, 3) <> 'RIG' 
											OR (
												CADA1.transaction_date between @reporting_start and @reporting_date 
												AND (LEFT(CO2.grp, 3) = 'RIG' 
												AND  LEFT(CO1.grp, 3) = 'RIG'
												AND NOT EXISTS (SELECT  id
																FROM CAD_Audit CADA33 join CLAIMS_OFFICERS CO3 ON CADA33.claims_officer = CO3.alias
																WHERE CADA33.Claim_no = CADA1.Claim_No
																	AND CADA33.id < CADA1.id
																	AND LEFT(CO3.grp, 3) = 'RIG'
																	AND datepart(month, CADA33.Transaction_Date) < datepart(month, CADA1.Transaction_Date)))
												)
										) then 1 else null end,
			Claims_Officer = (CO1.First_Name + ' ' + CO1.Last_Name),
			CADA1.Claim_Closed_Flag,
			CADA1.Date_Claim_Entered,
			CADA1.Date_Claim_Closed,
			CADA1.Date_Claim_Reopened,
			--
			Est_Amount = isnull((SELECT Sum(Amount)   
						 FROM  ESTIMATE_DETAILS   
						 WHERE ESTIMATE_DETAILS.Transaction_Date < @Reporting_Date
							AND CADA1.Claim_No = ESTIMATE_DETAILS.Claim_No ),0) ,  
							
			Payments = isnull((SELECT Sum(Trans_amount)   
						 FROM  PAYMENT_RECOVERY   
						 WHERE PAYMENT_RECOVERY.Transaction_Date < @Reporting_Date
							AND PAYMENT_RECOVERY.Claim_No = CADA1.Claim_No ),0) ,  
							
			ITC  =  isnull((SELECT Sum(itc)   
						 FROM  ESTIMATE_DETAILS   
						 WHERE ESTIMATE_DETAILS.Transaction_Date < @Reporting_Date
							AND CADA1.Claim_No = ESTIMATE_DETAILS.Claim_No ),0) ,  
			
			DAM =  isnull((SELECT Sum(dam)   
						 FROM  ESTIMATE_DETAILS   
						 WHERE ESTIMATE_DETAILS.Transaction_Date < @Reporting_Date
							AND CADA1.Claim_No = ESTIMATE_DETAILS.Claim_No ),0) 
			
		FROM CAD_Audit CADA1 JOIN CAD_Audit CADA2 ON CADA1.Claim_no = CADA2.Claim_No
			JOIN Claims_Officers CO1 on CADA1.claims_officer = CO1.alias
			JOIN Claims_Officers CO2 on CADA2.claims_officer = CO2.alias
		WHERE 
			CADA1.id = (SELECT MAX(ID)
							FROM CAD_Audit CADA12
							WHERE CADA12.Claim_no = CADA1.Claim_No
								AND CADA12.Transaction_Date <= @reporting_date)
			AND CADA2.id = (SELECT  max(id)
							FROM CAD_Audit CADA22
							WHERE CADA22.Claim_no = CADA2.Claim_No
								AND CADA22.id < CADA1.id
								AND CADA22.Transaction_Date <= @reporting_Date)
			AND (	
					(CADA1.Date_Claim_Entered BETWEEN @reporting_start AND @reporting_date)
				OR	(ISNULL(CADA1.CLAIM_CLOSED_FLAG, 'N') <> 'Y')
				OR	(CADA1.Date_Claim_Closed BETWEEN @reporting_start AND @reporting_date)
				OR 	(CADA1.Date_Claim_Reopened BETWEEN @reporting_start AND @reporting_date)
				OR 	
					(
						CADA1.transaction_date between @reporting_start and @reporting_date
						AND  LEFT(CO1.grp, 3) = 'RIG'
						AND
						(	LEFT(CO2.grp, 3) <> 'RIG' 
							OR (
								CADA1.transaction_date between @reporting_start and @reporting_date 
								AND (LEFT(CO2.grp, 3) = 'RIG' 
								AND  LEFT(CO1.grp, 3) = 'RIG'
								AND NOT EXISTS (SELECT  id
												FROM CAD_Audit CADA33 join CLAIMS_OFFICERS CO3 ON CADA33.claims_officer = CO3.alias
												WHERE CADA33.Claim_no = CADA1.Claim_No
													AND CADA33.id < CADA1.id
													AND LEFT(CO3.grp, 3) = 'RIG'
													AND datepart(month, CADA33.Transaction_Date) < datepart(month, CADA1.Transaction_Date)))
								)
						)
					)
				)
			--AND CADA1.claim_no = '10204EML           '
		GROUP BY CADA1.id, CADA1.Claim_no,CADA1.transaction_date, CO2.grp, CO1.grp, (CO1.First_Name + ' ' + CO1.Last_Name), CADA1.Claim_Closed_Flag, CADA1.Date_Claim_Entered, CADA1.Date_Claim_Closed, CADA1.Date_Claim_Reopened

		UNION 

		SELECT 
			Claim_Number = PR.Claim_No,
			CADA1.transaction_date, 
			Last_Grp = CO2.grp,
			grp = CO1.grp,
			IsTranferredClaim = case when CADA1.transaction_date between @reporting_start and @reporting_date
										AND  LEFT(CO1.grp, 3) = 'RIG'
										AND
										(	LEFT(CO2.grp, 3) <> 'RIG' 
											OR (
												CADA1.transaction_date between @reporting_start and @reporting_date 
												AND (LEFT(CO2.grp, 3) = 'RIG' 
												AND  LEFT(CO1.grp, 3) = 'RIG'
												AND NOT EXISTS (SELECT  id
																FROM CAD_Audit CADA33 join CLAIMS_OFFICERS CO3 ON CADA33.claims_officer = CO3.alias
																WHERE CADA33.Claim_no = CADA1.Claim_No
																	AND CADA33.id < CADA1.id
																	AND LEFT(CO3.grp, 3) = 'RIG'
																	AND datepart(month, CADA33.Transaction_Date) < datepart(month, CADA1.Transaction_Date)))
												)
										) then 1 else null end,
			Claims_Officer = (CO1.First_Name + ' ' + CO1.Last_Name),
			CADA1.Claim_Closed_Flag,
			CADA1.Date_Claim_Entered,
			CADA1.Date_Claim_Closed,
			CADA1.Date_Claim_Reopened,
			Est_Amount = 0,
			Payments = Sum(Trans_Amount), 
			ITC  =  - Sum(ISNULL(ITC,0)),   
			DAM =   - Sum(ISNULL(DAM,0))   
		FROM CAD_Audit CADA1 LEFT JOIN Payment_Recovery PR ON CADA1.Claim_No = PR.Claim_no
			INNER JOIN Payment_Types PT ON PR.Payment_Type = PT.Payment_Type
			LEFT OUTER JOIN CAD_Audit CADA2 ON CADA1.Claim_no = CADA2.Claim_No
			JOIN Claims_Officers CO1 on CADA1.claims_officer = CO1.alias
			JOIN Claims_Officers CO2 on CADA2.claims_officer = CO2.alias
		WHERE ISNULL(PT.Is_NotWC,0) = 0 	
			AND PR.Transaction_Date <= @reporting_Date
			AND NOT Exists (SELECT * FROM Estimate_Details ED  
					WHERE ED.Claim_No = PR.Claim_No AND  
						  ED.Type = PR.Estimate_Type AND  
						  ISNULL(ED.Sub_Type,'') = ISNULL(PR.Estimate_SubType,'') ) 
			AND CADA1.id = (SELECT MAX(ID)
							FROM CAD_Audit CADA12
							WHERE CADA12.Claim_no = CADA1.Claim_No
								AND CADA12.Transaction_Date <= @reporting_date)
			AND CADA2.id = (SELECT  max(id)
							FROM CAD_Audit CADA22
							WHERE CADA22.Claim_no = CADA2.Claim_No
								AND CADA22.id < CADA1.id
								AND CADA22.Transaction_Date <= @reporting_Date)
			AND (	
					(CADA1.Date_Claim_Entered BETWEEN @reporting_start AND @reporting_date)
				OR	(ISNULL(CADA1.CLAIM_CLOSED_FLAG, 'N') <> 'Y')
				OR	(CADA1.Date_Claim_Closed BETWEEN @reporting_start AND @reporting_date)
				OR 	(CADA1.Date_Claim_Reopened BETWEEN @reporting_start AND @reporting_date)
				OR 	
					(
						CADA1.transaction_date between @reporting_start and @reporting_date
						AND  LEFT(CO1.grp, 3) = 'RIG'
						AND
						(	LEFT(CO2.grp, 3) <> 'RIG' 
							OR (
								CADA1.transaction_date between @reporting_start and @reporting_date 
								AND (LEFT(CO2.grp, 3) = 'RIG' 
								AND  LEFT(CO1.grp, 3) = 'RIG'
								AND NOT EXISTS (SELECT  id
												FROM CAD_Audit CADA33 join CLAIMS_OFFICERS CO3 ON CADA33.claims_officer = CO3.alias
												WHERE CADA33.Claim_no = CADA1.Claim_No
													AND CADA33.id < CADA1.id
													AND LEFT(CO3.grp, 3) = 'RIG'
													AND datepart(month, CADA33.Transaction_Date) < datepart(month, CADA1.Transaction_Date)))
								)
						)
					)
				)
			--AND CADA1.claim_no = '10204EML           '
		GROUP BY PR.Claim_No, CADA1.id, CADA1.Claim_No, CADA1.transaction_date, CO2.grp, CO1.grp, (CO1.First_Name + ' ' + CO1.Last_Name), CADA1.Claim_Closed_Flag, CADA1.Date_Claim_Entered, CADA1.Date_Claim_Closed, CADA1.Date_Claim_Reopened
	) as tbl
	group by claim_number, transaction_date, Last_Grp, grp, IsTranferredClaim, Claims_Officer, Claim_Closed_Flag, Date_Claim_Entered, Date_Claim_Reopened


	select
		[Group] = dbo.[udf_ExtractGroup](grp),
		Team = t.grp,
		t.Claims_Officer,
		t.Claim_Number,
		Reserve_Total = Incurred_Total - Payment_Total,
		Payment_Total,
		Incurred_Total,
		Number_Of_Open_Claims = case when ISNULL(CLAIM_CLOSED_FLAG, 'N') <> 'Y' then 1 else null end,
		Number_Of_Closed_Claims = case when ISNULL(CLAIM_CLOSED_FLAG, 'N') = 'Y' then 1 else null end,
		Number_Of_New_Claims = case when 
			Date_Claim_Entered BETWEEN @reporting_start AND @reporting_date then 1 else null end,
		Number_Of_Transferred_Claims = IsTranferredClaim,
		Number_Of_Claim_Reopen = case when 
			Date_Claim_reopened BETWEEN @reporting_start AND @reporting_date then 1 else null end
	from #temp t 
	where (@IsAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%'))) 
	order by t.Claim_Number
	
	drop table #temp
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_MonthEndPortfolioSnapshot]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_MonthEndPortfolioSnapshot]  TO [emius]
GO
