
/****** Object:  StoredProcedure [dbo].[usp_CurrentClaimPortfolio]    Script Date: 03/05/2012 22:37:33 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_CurrentClaimPortfolio]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_CurrentClaimPortfolio]
GO

/****** Object:  StoredProcedure [dbo].[usp_CurrentClaimPortfolio]    Script Date: 03/14/2012 22:37:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_CurrentClaimPortfolio] 
	@Reporting_date datetime,
	@IsAll bit,
	@IsRig bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @Reporting_date = convert(datetime, convert(char,  @Reporting_date, 106)) + '23:59'			  
	
	Create Table #TempCADA
	(
		Claim_no char(19),
		Work_Status_Code tinyint,
		Claims_Officer varchar(10)
	)
	Insert into #TempCADA
	Select Claim_no, Work_Status_Code, Claims_Officer
	From CAD_AUDIT CADA 
	Where CADA.ID = (SELECT MAX(ID)
							FROM CAD_AUDIT 
							WHERE CAD_AUDIT.Claim_no = CADA.Claim_no									
									AND CAD_AUDIT.Transaction_Date <= @Reporting_date)
	AND	isnull(CADA.CLAIM_CLOSED_FLAG,'N') <> 'Y'
	
	
	Create Table #TempPR
	(
		Claim_no char(19),
		Payment_no int, 
		Trans_Amount money,
		itc money,
		dam money,
		Payment_type varchar(15),
		Period_End_Date smalldatetime,
		Transaction_date smalldatetime,
		Estimate_type char(2),
		Work_Status_Code tinyint
	)
	Insert into #TempPR
	Select PR.Claim_No, PR.Payment_no, Trans_Amount, itc, dam, Payment_Type, Period_End_Date, Transaction_date, Estimate_type, Work_Status_Code
	From Payment_Recovery PR JOIN #TempCADA ON PR.Claim_No = #TempCADA.Claim_no
	WHERE PR.Transaction_date <= @Reporting_date
			
	CREATE TABLE #TempED
	(
		Claim_No varchar(19),
		Reserve money,
		ITC money
	)
	INSERT INTO #TempED
	SELECT Claim_No, ISNULL(Sum(ESTIMATE_DETAILS.Amount) 						- ISNULL((SELECT Sum(Trans_amount - ISNULL(ITC,0) - ISNULL(DAM,0)) 									FROM PAYMENT_RECOVERY 									WHERE PAYMENT_RECOVERY.Claim_No = ESTIMATE_DETAILS.Claim_No ),0) ,0),
				ISNULL(Sum(ESTIMATE_DETAILS.ITC) , 0) 
				- isnull((SELECT Sum(ISNULL(ITC,0)) 						FROM PAYMENT_RECOVERY 						WHERE PAYMENT_RECOVERY.Claim_No = ESTIMATE_DETAILS.Claim_No ),0)
	FROM ESTIMATE_DETAILS
	WHERE ESTIMATE_DETAILS.Transaction_Date <= @Reporting_date
	GROUP BY ESTIMATE_DETAILS.Claim_No
	
	
	CREATE TABLE #Temp
	(
		[Group] varchar(20),
		Team varchar(10),
		Claims_Officer varchar(80),
		Claim_Number char(19),
		Worker_Name varchar(80),
		Date_of_Birth smalldatetime,
		Age int,
		Date_of_Injury smalldatetime,
		Location_of_Injury smallint,
		[Version] tinyint, 
		--Injury_Location varchar(255),
		Injury_Nature varchar(255), 
		Work_Status_Code tinyint,
		Last_IMP_Date smalldatetime,
		Weeks_Paid_S36 money,
		Weeks_Paid_S37 money,
		Weeks_Paid_S38 money,
		Weeks_Paid_S40 money,
		Last_Wage_Payment_Type varchar(15),
		Paid_To smalldatetime,
		Current_Wage_Rate smallmoney,
		Total_Medical_Spend money,		
		Last_Medical_Payment smalldatetime,
		Temp_Incurred money,		
		--Temp_Reserve money,
		Wages_Reserve money
	)
	INSERT INTO #Temp
	SELECT [Group] = dbo.[udf_ExtractGroup](grp),  
		Team = CO.grp,
		Claims_Officer = (CO.First_Name + ' ' + CO.Last_Name),		
		Claim_Number = CD.Claim_Number,
		Worker_Name = ISNULL(CD.given_names,'') + ' ' + ISNULL(CD.last_names,''),
		Date_of_Birth = CD.Date_of_Birth,
		Age = DateDiff(yyyy, CD.Date_of_Birth, @Reporting_date),
		Date_of_Injury = CD.Date_of_Injury,
		Location_of_Injury = CD.Location_of_Injury,
		[Version] = CD.TOOCS_Version, 
		--Injury_Location = LD.Description,
		Injury_Nature = IJ.Description,
		Work_Status_Code = CADA.Work_Status_Code,
		--Last_Current_Medical_Certification = CASE WHEN MC.Type = 'I' THEN 'Pre-injury duties'
		--											WHEN MC.Type = 'S' THEN 'Suitable duties'
		--											WHEN MC.Type = 'T' THEN 'Totally unfit'
		--											WHEN MC.Type = 'M' THEN 'Permanently Modified duties'
		--											WHEN MC.Type = 'P' THEN 'No time lost' END,
		--Prior_Medical_Certification = CASE WHEN MC2.Type = 'I' THEN 'Pre-injury duties'
		--									WHEN MC2.Type = 'S' THEN 'Suitable duties'
		--									WHEN MC2.Type = 'T' THEN 'Totally unfit'
		--									WHEN MC2.Type = 'M' THEN 'Permanently Modified duties'
		--									WHEN MC2.Type = 'P' THEN 'No time lost' END,
		Last_IMP_Date = (SELECT MAX(DI.EFFECT_DATE)
							FROM DIARY DI
							WHERE DI.EVENT_CLASS = 'IMAPLANDEV'
									AND DI.REF_NO = CD.Claim_Number),
		Weeks_Paid_S36 = isnull((SELECT Sum(Trans_amount)   
									FROM  #TempPR
									WHERE #TempPR.Claim_no = CD.Claim_Number 
											AND (#TempPR.Payment_Type in ('WPT001', 'WPT003'))),0),
		Weeks_Paid_S37 = isnull((SELECT Sum(Trans_amount)   
									FROM  #TempPR
									WHERE #TempPR.Claim_no = CD.Claim_Number 
											AND (#TempPR.Payment_Type in ('WPT002', 'WPT004'))),0),
		Weeks_Paid_S38 = isnull((SELECT Sum(Trans_amount)   
									FROM  #TempPR
									WHERE #TempPR.Claim_no = CD.Claim_Number 
											AND (#TempPR.Payment_Type in ('WPP001', 'WPP003'))),0),
		Weeks_Paid_S40 = isnull((SELECT Sum(Trans_amount)   
									FROM  #TempPR
									WHERE #TempPR.Claim_No = CD.Claim_Number 
											AND (#TempPR.Payment_Type in ('WPP002', 'WPP004'))),0),					
		Last_Wage_Payment_Type = isnull((Select top 1 Payment_Type
											From #TempPR
											Where #TempPR.Claim_no = CD.Claim_Number 	
													AND LEFT(Payment_Type, 3) in ('WPP', 'WPT')		
											Order by Transaction_date desc), ''),
		Paid_To = isnull((Select max(Period_End_Date) 
							From #TempPR
							Where #TempPR.Claim_no = CD.Claim_Number
									AND LEFT(Payment_Type, 3) in ('WPP', 'WPT')), null),
		Current_Wage_Rate = CD.Weekly_Wage,
		Total_Medical_Spend = isnull((SELECT Sum(Trans_amount)   
										FROM  #TempPR
										WHERE Estimate_type = '55'
												AND #TempPR.Claim_no = CD.Claim_Number),0),
		Last_Medical_Payment = isnull((Select MAX(Transaction_date)
										From #TempPR
										Where #TempPR.Claim_no = CD.Claim_Number 
											AND Estimate_type = '55'), null),
		Temp_Incurred = ISNULL((SELECT SUM(Amount)
							FROM ESTIMATE_DETAILS
							WHERE ESTIMATE_DETAILS.Transaction_Date <= @Reporting_date 
									AND ESTIMATE_DETAILS.Claim_No = CD.Claim_Number), 0) 
					+ ISNULL((SELECT SUM(ISNULL(ITC,0)) + SUM(ISNULL(DAM,0))
								FROM  #TempPR
								WHERE #TempPR.Claim_No = CD.Claim_Number),0),
		--Temp_Reserve = ISNULL((SELECT SUM(Amount)
		--					FROM ESTIMATE_DETAILS
		--					WHERE ESTIMATE_DETAILS.Transaction_Date <= @Reporting_date 
		--							AND ESTIMATE_DETAILS.Claim_No = CD.Claim_Number), 0) 
		--			- ISNULL((SELECT SUM(Trans_amount - ISNULL(DAM,0) - ISNULL(ITC,0))  
		--						FROM #TempPR
		--						WHERE #TempPR.Claim_No = CD.Claim_Number), 0), 
		Wages_Reserve = ISNULL((SELECT SUM(Amount)
							FROM ESTIMATE_DETAILS
							WHERE ESTIMATE_DETAILS.Transaction_Date <= @Reporting_date 
									AND ESTIMATE_DETAILS.Type = '50'
									AND ESTIMATE_DETAILS.Claim_No = CD.Claim_Number), 0) 
						- ISNULL((SELECT SUM(Trans_amount - ISNULL(DAM,0) - ISNULL(ITC,0))  
									FROM  #TempPR
									WHERE #TempPR.Estimate_type = '50'
											AND #TempPR.Claim_No = CD.Claim_Number),0)
    FROM #TempCADA CADA LEFT JOIN CLAIMS_OFFICERS CO ON CADA.Claims_Officer = CO.Alias	
		LEFT JOIN CLAIM_DETAIL CD ON CADA.Claim_no = CD.Claim_Number
		LEFT JOIN Injury IJ ON IJ.ID = CD.Nature_ID
		--LEFT JOIN LOCATION_DESC LD ON LD.Code = CD.Location_of_Injury	
		--LEFT JOIN Medical_Cert MC ON MC.Claim_no = CD.Claim_Number		
		--LEFT JOIN Medical_Cert MC2 ON MC2.Claim_no = CD.Claim_Number		
		
	WHERE --MC.ID = (SELECT top 1 ID
			--				FROM MEDICAL_CERT MC1
			--				WHERE MC1.Claim_no = CD.Claim_Number
			--				ORDER BY Date_From DESC)
			--AND MC2.ID = (SELECT  TOP 1 ID
			--				FROM MEDICAL_CERT MC3
			--				WHERE MC3.Claim_no = CD.Claim_Number AND MC3.ID <> MC.ID
			--				ORDER BY Date_From DESC)	
											
			 --LD.Version = CD.TOOCS_Version			
			 (@IsAll = 1 OR ((@IsRig = 0 AND grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND grp LIKE 'RIG%')))	
	
	CREATE TABLE #TempMC
	(
		Claim_no varchar(19),
		Last_Current_Medical_Certification varchar(40),
		Prior_Medical_Certification varchar(40)
	)
	insert into #TempMC
	select #Temp.Claim_Number, Last_Current_Medical_Certification = CASE WHEN MC.Type = 'I' THEN 'Pre-injury duties'
													WHEN MC.Type = 'S' THEN 'Suitable duties'
													WHEN MC.Type = 'T' THEN 'Totally unfit'
													WHEN MC.Type = 'M' THEN 'Permanently Modified duties'
													WHEN MC.Type = 'P' THEN 'No time lost' END,
		Prior_Medical_Certification = CASE WHEN MC1.Type = 'I' THEN 'Pre-injury duties'
											WHEN MC1.Type = 'S' THEN 'Suitable duties'
											WHEN MC1.Type = 'T' THEN 'Totally unfit'
											WHEN MC1.Type = 'M' THEN 'Permanently Modified duties'
											WHEN MC1.Type = 'P' THEN 'No time lost' END
	from #Temp left join Medical_Cert MC ON MC.Claim_no = #Temp.Claim_Number		
			LEFT JOIN Medical_Cert MC1 ON MC1.Claim_no = #Temp.Claim_Number		
	where #Temp.Claim_Number IS NOT NULL 
			AND	MC.ID = (SELECT top 1 ID
							FROM MEDICAL_CERT MC2
							WHERE MC2.Claim_no = #Temp.Claim_Number AND MC2.is_deleted = 0
							ORDER BY Date_To DESC)
			AND MC1.ID = (SELECT  TOP 1 ID
							FROM MEDICAL_CERT MC3
							WHERE MC3.Claim_no = #Temp.Claim_Number AND MC3.ID <> MC.ID AND MC3.is_deleted = 0
							ORDER BY Date_To DESC)			
	
	
	SELECT #Temp.*, Incurred = Temp_Incurred, Reserve = #TempED.Reserve + #TempED.ITC, Injury_Location = LD.Description, #TempMC.Last_Current_Medical_Certification, #TempMC.Prior_Medical_Certification
	FROM #Temp LEFT JOIN LOCATION_DESC LD ON #Temp.Location_of_Injury = LD.Code and #Temp.[Version] = LD.[version]
			LEFT JOIN #TempMC on #Temp.Claim_Number = #TempMC.Claim_no
			LEFT JOIN #TempED on #Temp.Claim_Number = #TempED.Claim_No
	WHERE #Temp.Claim_Number IS NOT NULL			
	ORDER BY [Group], Team, Claims_Officer, Claim_Number
	
			
	DROP TABLE #TempPR
	DROP TABLE #TempCADA
	DROP TABLE #TempMC
	DROP TABLE #TempED
END

GO

GRANT  EXECUTE  ON [dbo].[usp_CurrentClaimPortfolio]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_CurrentClaimPortfolio]  TO [emius]
GO

--exec usp_CurrentClaimPortfolio '12/31/2011', 1, 1

