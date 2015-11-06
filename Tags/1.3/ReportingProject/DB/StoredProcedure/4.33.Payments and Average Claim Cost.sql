
/****** Object:  StoredProcedure [dbo].[usp_PaymentsAndAverageClaimCost]    Script Date: 03/12/2012 10:46:44 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_PaymentsAndAverageClaimCost]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_PaymentsAndAverageClaimCost]
GO

/****** Object:  StoredProcedure [dbo].[usp_PaymentsAndAverageClaimCost]    Script Date: 03/12/2012 10:46:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usp_PaymentsAndAverageClaimCost '1/1/2012', 1, 0

CREATE PROCEDURE [dbo].[usp_PaymentsAndAverageClaimCost] 
	@Reporting_date datetime,
	@IsAll bit,
	@IsRig bit
AS
BEGIN

	SET NOCOUNT ON;
	
	CREATE TABLE #Temp
	(
		Agency varchar(300),
		Employer_Name varchar(175),
		Claim_Number varchar(30),
		Date_Of_Injury Datetime,
		Age_Of_Claim_In_Weeks  decimal(10, 2),
		Medical_Certificate_Type varchar(40),
		[Group] varchar(10),
		Team varchar(10),
		Claims_Officer varchar(75),
		IMA_Officer varchar(75),
		Work_Status_Code smallint,
		Cost_centre int,
		Bodily_Location smallint,
		Nature_of_Injury smallint,
		Mechanism_of_Injury smallint,
		Agency_of_Accident smallint,
		Agency_of_Injury smallint,
		Number_Of_Open_Claim smallint,
		Paid_This_Month money,
		Total_Paid money ,  					
		Incurred Money ,  
		Date_Ceased_Work datetime,
		Date_Resumed_Work datetime,
		Number_Of_Date_Off_Work smallint,
		Date_Last_Payment datetime
	)
	
	DECLARE @Reporting_start datetime
	SET @Reporting_start = LEFT(CONVERT(VARCHAR(8), @Reporting_date, 112), 6) + '01'
	SET @Reporting_date = convert(datetime, convert(char, @Reporting_date, 106)) + '23:59'
	
	
	DECLARE @ETExclude varchar(1024)
	SELECT @ETExclude = Value FROM Control WHERE type = 'PARAMETERS' AND Item = 'ETCostOfClmExclude'

	INSERT into #Temp
    SELECT Agency = PTD.Agency_id,
		Employer_Name = PTD.legal_name,
		Claim_Number = CD.Claim_number,
		Date_Of_Injury = CD.Date_of_Injury,
		Age_Of_Claim_In_Weeks  = DATEDIFF(DAY, CADA.Date_Claim_Entered, @Reporting_date )/7.0,
		Medical_Certificate_Type = CASE WHEN MC.TYPE = 'I' THEN 'Pre-injury duties'
			WHEN MC.TYPE = 'S' THEN 'Suitable duties'
			WHEN MC.TYPE = 'T' THEN 'Totally unfit'
			WHEN MC.TYPE = 'M' THEN 'Permanently Modified duties'
			WHEN MC.TYPE = 'P' THEN 'No time lost' END,
		[Group] = dbo.[udf_ExtractGroup](co.grp),
		Team = co.grp,
		Claims_Officer = co.First_Name + ' ' + co.Last_Name,
		IMA_Officer = co1.First_Name + ' ' + co1.Last_Name,
		CADA.Work_Status_Code,
		CD.Cost_centre,
		Bodily_Location = CD.Location_Of_Injury,
		CD.Nature_of_Injury,
		CD.Mechanism_of_Injury,
		CD.Agency_of_Accident,
		CD.Agency_of_Injury,
		Number_Of_Open_Claim = 1,
		Paid_This_Month =  ISNULL((SELECT SUM(ISNULL(TRANS_AMOUNT, 0)  - ISNULL(DAM,0) - ISNULL(ITC,0))
                                    FROM PAYMENT_RECOVERY PR 
                                    WHERE CHARINDEX('*'+RTRIM(ESTIMATE_TYPE)+'*', @ETExclude ) = 0 AND
                                    ESTIMATE_TYPE < '70' AND pr.claim_no = cd.Claim_Number
                                    AND PR.transaction_date BETWEEN @Reporting_start and @Reporting_date ),0),
		Total_Paid = ISNULL((SELECT SUM(Trans_amount - ISNULL(DAM,0) - ISNULL(ITC,0))  
                             FROM  PAYMENT_RECOVERY  
                             WHERE CHARINDEX('*'+RTRIM(ESTIMATE_TYPE)+'*', @ETExclude) = 0 AND
                                        ESTIMATE_TYPE < '70' AND
                                        PAYMENT_RECOVERY.Transaction_Date <= @Reporting_date
                                        AND PAYMENT_RECOVERY.Claim_No = cd.Claim_Number ),0),
		Incurred = dbo.udf_GetIncurredAdj(cd.Date_of_Injury, ISNULL(cd.Commencement_Date,'1900/01/01'),
                    ISNULL((SELECT SUM(Amount)
                                FROM  Estimate_Details
                                WHERE Type <> '72'
                                AND Estimate_details.Claim_no = cd.Claim_Number
                                AND Estimate_details.Transaction_Date <= @Reporting_date ),0.0000),
                    dbo.udf_CalculateExcess(CD.Claim_number, @Reporting_date)) ,
		Date_Ceased_Work = (SELECT MIN(date_ceased_work)
			FROM TIME_LOST_DETAIL TLD
			WHERE TLD.Claim_no = CD.claim_number
				AND TLD.is_deleted = 0),
		Date_Resumed_Work = (SELECT MAX(Date_Resumed_Work)
			FROM TIME_LOST_DETAIL TLD
			WHERE TLD.Claim_no = CD.claim_number
				AND TLD.is_deleted = 0),
		Number_Of_Date_Off_Work = (SELECT SUM(ISNULL(PR.WEEKS_PAID, 0) * 5) + SUM(ISNULL(PR.DAYS_PAID, 0))
									FROM CLAIM_PAYMENT_RUN CPR JOIN Payment_Recovery PR ON PR.CLAIM_NO = CPR.Claim_number AND PR.payment_no = cpr.payment_no
									WHERE PR.CLAIM_NO = CD.CLAIM_NUMBER
										AND PR.Transaction_date <= @Reporting_date),
		Date_Last_Payment = (SELECT MAX(Paid_Date)
							FROM CLAIM_PAYMENT_RUN CPR
							WHERE CPR.CLAIM_NUMBER = CD.CLAIM_NUMBER
								AND CPR.Paid_Date <= @Reporting_date)
    FROM CLAIM_DETAIL CD JOIN CAD_AUDIT CADA ON CD.Claim_number = CADA.Claim_no
			JOIN POLICY_TERM_DETAIL PTD ON CD.Policy_no = PTD.Policy_no
			JOIN CLAIMS_OFFICERS CO ON CADA.Claims_Officer = CO.Alias
			JOIN CLAIMS_OFFICERS CO1 ON CD.IMA = CO1.Alias
			JOIN MEDICAL_CERT MC ON MC.Claim_no = CADA.Claim_no
	WHERE 
		CADA.ID = (SELECT MAX(ID)
			FROM CAD_Audit CADA1
			WHERE CADA.Claim_no = CADA1.Claim_no
				AND CADA1.transaction_date <= @Reporting_date)
		AND ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') <> 'Y'
		AND MC.ID = (SELECT MAX(ID)
			FROM MEDICAL_CERT MC1
			WHERE MC1.Claim_no = MC.Claim_no)
		AND (@IsAll = 1 OR ((@IsRig = 0 AND CO.Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND CO.Grp LIKE 'RIG%'))) 
	

	SELECT #Temp.*,
		Age_Group = case when Age_Of_Claim_In_Weeks >= 0 and Age_Of_Claim_In_Weeks < 12 then '0-12 weeks'
						when Age_Of_Claim_In_Weeks >= 12 and Age_Of_Claim_In_Weeks < 26 then '12-26 weeks'
						when Age_Of_Claim_In_Weeks >= 26 and Age_Of_Claim_In_Weeks < 52 then '26-52 weeks'
						when Age_Of_Claim_In_Weeks >= 52 and Age_Of_Claim_In_Weeks < 78 then '52-7812 weeks'
						when Age_Of_Claim_In_Weeks >= 78 and Age_Of_Claim_In_Weeks < 104 then '78-104 weeks'
						when Age_Of_Claim_In_Weeks >= 104 then 'above 104 weeks +' end,
		Estimate = Incurred - Total_paid
	FROM #Temp
	ORDER BY #Temp.Claim_Number
	
	
	DROP TABLE #Temp
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_PaymentsAndAverageClaimCost]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_PaymentsAndAverageClaimCost]  TO [emius]
GO


