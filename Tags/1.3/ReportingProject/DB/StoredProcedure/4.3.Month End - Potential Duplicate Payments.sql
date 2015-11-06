

/****** Object:  StoredProcedure [dbo].[usp_MonthEndPotentialDuplicatePayments]    Script Date: 01/11/2012 15:23:03 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_MonthEndPotentialDuplicatePayments]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_MonthEndPotentialDuplicatePayments]
GO


/****** Object:  StoredProcedure [dbo].[usp_MonthEndPotentialDuplicatePayments]    Script Date: 01/11/2012 15:23:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_MonthEndPotentialDuplicatePayments] 
	@Reporting_Month_End datetime,
	@IsAll bit,
	@IsRig bit
as
begin
	SET @Reporting_Month_End = convert(datetime, convert(char, @Reporting_Month_End, 106)) + '23:59'
	CREATE TABLE #WAGE_PAYMENT
	(
		[Group] varchar(10),
		Team varchar(20),
		Claims_Officer varchar(200),
		Paid_Date datetime,
		Drawn_Date datetime,
		Id int,
		Claim_no varchar(30),
		Payment_no varchar(30),
		Gross money,
		Payment_Type varchar(10),
		Period_Start_Date datetime,
		Period_End_Date datetime,
		Date_Of_Service datetime
	)
	CREATE TABLE #NONE_WAGE_PAYMENT
	(
		[Group] varchar(10),
		Team varchar(20),
		Claims_Officer varchar(200),
		Paid_Date datetime,
		Drawn_Date datetime,
		Id int,
		Claim_no varchar(30),
		Payment_no varchar(30),
		Gross money,
		Payment_Type varchar(10),
		Period_Start_Date datetime,
		Period_End_Date datetime,
		Date_Of_Service datetime
	)
	
	INSERT INTO #WAGE_PAYMENT
	SELECT 
		[Group] = dbo.udf_ExtractGroup(CO.grp),
		Team = CO.grp,
		Claims_Officer = co.First_Name + ' ' + CO.Last_Name,
		CPR.Paid_Date,
		CPR.Drawn_date,
		PR.ID,
		PR.CLAIM_NO,
		PR.PAYMENT_NO,
		PR.GROSS,
		PR.PAYMENT_TYPE,
		PR.PERIOD_START_DATE,
		PR.PERIOD_END_DATE,
		PR.DATE_OF_SERVICE
	FROM PAYMENT_RECOVERY PR JOIN CLAIM_PAYMENT_RUN CPR ON CPR.Payment_no = PR.PAYMENT_NO
		JOIN CLAIM_ACTIVITY_DETAIL CAD ON CAD.CLAIM_NO = PR.CLAIM_NO
		JOIN CLAIMS_OFFICERS CO ON CO.ALIAS = CAD.CLAIMS_OFFICER
	WHERE PR.REVERSED <> 1
		AND PR.TRANSACTION_DATE <= @Reporting_Month_End
		AND (@IsAll = 1 OR ((@IsRig = 0 AND CO.Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND CO.Grp LIKE 'RIG%')))
		AND PR.payment_type in ('WPT001', 'WPT002', 'WPP001', 'WPP002')
		
	INSERT INTO #NONE_WAGE_PAYMENT
	SELECT 
		[Group] = dbo.udf_ExtractGroup(CO.grp),
		Team = CO.grp,
		Claims_Officer = co.First_Name + ' ' + CO.Last_Name,
		CPR.Paid_Date,
		CPR.Drawn_date,
		PR.ID,
		PR.CLAIM_NO,
		PR.PAYMENT_NO,
		PR.GROSS,
		PR.PAYMENT_TYPE,
		PR.PERIOD_START_DATE,
		PR.PERIOD_END_DATE,
		PR.DATE_OF_SERVICE
	FROM PAYMENT_RECOVERY PR JOIN CLAIM_PAYMENT_RUN CPR ON CPR.Payment_no = PR.PAYMENT_NO
		JOIN CLAIM_ACTIVITY_DETAIL CAD ON CAD.CLAIM_NO = PR.CLAIM_NO
		JOIN CLAIMS_OFFICERS CO ON CO.ALIAS = CAD.CLAIMS_OFFICER
	WHERE PR.REVERSED <> 1
		AND PR.TRANSACTION_DATE <= @Reporting_Month_End
		AND (@IsAll = 1 OR ((@IsRig = 0 AND CO.Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND CO.Grp LIKE 'RIG%')))
		AND PR.payment_type NOT IN ('WPT001', 'WPT002', 'WPP001', 'WPP002')
	
	
	

	SELECT
		P1.[Group],
		[Team] = P1.Team,
		P1.Claims_Officer,
		Claim_Number = P1.Claim_No,
		O_Payment_Number = P1.Payment_No, 
		O_Paid_Date = P1.Paid_Date, 
		O_Drawn_Date = P1.Drawn_Date, 
		O_Gross_Payment_Amount = P1.Gross,
		O_Payment_Type = P1.Payment_Type, 
		O_Period_From = P1.PERIOD_START_DATE,
		O_Period_To = P1.PERIOD_END_DATE,
		O_Date_of_Service = NULL,
		P_Payment_Number = P2.Payment_No,
		P_Paid_Date = P2.Paid_Date,
		P_Drawn_Date = P2.Drawn_Date, 
		P_Gross_Payment_Amount = P2.Gross, 
		P_Payment_Type = P2.Payment_Type, 
		P_Period_From = P2.PERIOD_START_DATE,
		P_Period_To = P2.PERIOD_END_DATE,
		P_Date_of_Service = NULL
	FROM #WAGE_PAYMENT P1 JOIN #WAGE_PAYMENT P2 ON P2.CLAIM_NO = P1.CLAIM_NO
	WHERE
		P1.Payment_No <> P2.Payment_No
		and P1.id < P2.id
		and
		(
			P1.PERIOD_START_DATE = P2.PERIOD_START_DATE
			and P1.PERIOD_END_DATE = P2.PERIOD_END_DATE				
		)
	
	UNION ALL
	
	SELECT
		P1.[Group],
		[Team] = P1.Team,
		P1.Claims_Officer,
		Claim_Number = P1.Claim_No,
		O_Payment_Number = P1.Payment_No, 
		O_Paid_Date = P1.Paid_Date, 
		O_Drawn_Date = P1.Drawn_Date, 
		O_Gross_Payment_Amount = P1.Gross,
		O_Payment_Type = P1.Payment_Type, 
		O_Period_From = NULL,
		O_Period_To = NULL,
		O_Date_of_Service = P1.Date_of_Service,
		P_Payment_Number = P2.Payment_No,
		P_Paid_Date = P2.Paid_Date,
		P_Drawn_Date = P2.Drawn_Date, 
		P_Gross_Payment_Amount = P2.Gross, 
		P_Payment_Type = P2.Payment_Type, 
		P_Period_From = NULL,
		P_Period_To = NULL,
		P_Date_of_Service = P2.Date_of_Service
	FROM #NONE_WAGE_PAYMENT P1 JOIN #NONE_WAGE_PAYMENT P2 ON P2.CLAIM_NO = P1.CLAIM_NO
	WHERE
		P1.Payment_No <> P2.Payment_No
		and P1.id < P2.id
		and
		(
			P1.date_of_service = P2.date_of_service
			and P1.payment_type = P2.payment_type
			and P1.Gross = P2.Gross				
		)
	ORDER BY [TEAM], Claim_Number
	
	
	drop table #WAGE_PAYMENT
	drop table #NONE_WAGE_PAYMENT
end
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_MonthEndPotentialDuplicatePayments]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_MonthEndPotentialDuplicatePayments]  TO [emius]
GO


