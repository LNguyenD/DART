/****** Object:  StoredProcedure [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostForMechanism_Occupation_BodyLocation]    Script Date: 03/14/2012 13:16:45 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_TotalNumberOfNewClaimsAndClaimCostForMechanism_Occupation_BodyLocation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostForMechanism_Occupation_BodyLocation]
GO


/****** Object:  StoredProcedure [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostForMechanism_Occupation_BodyLocation]    Script Date: 03/14/2012 13:16:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usp_TotalNumberOfNewClaimsAndClaimCostForMechanism_Occupation_BodyLocation '2009', '1', '2012', '4', ''
CREATE PROCEDURE [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostForMechanism_Occupation_BodyLocation]
	@From_Quarter_Year char(4),
	@From_Quarter_Quarter char(1),
	@To_Quarter_Year char(4),
	@To_Quarter_Quarter char(1),
	@policies varchar(8000)
AS
BEGIN

	SET NOCOUNT ON;
	
	CREATE TABLE #QUARTER_YEAR
	(
		[year] smallint, 
		[quarter] tinyint, 
		[start_date] datetime, 
		end_date datetime
	)
	
	CREATE TABLE #OPEN_CLAIM
	(
		[Quarter] tinyint,
		[Year] smallint,
		Claim_no varchar(30),	
		Claim_Closed_Flag char(1),
		Mechanism_of_Injury int,
		date_of_birth datetime, Date_Of_Injury datetime
	)
	CREATE TABLE #NEW_CLAIM
	(
		[Quarter] tinyint,
		[Year] smallint,
		Claim_no varchar(30),	
		Is_New_Claim Tinyint,
		Mechanism_of_Injury int,
		date_of_birth datetime
	)
	CREATE TABLE #CLAIM_COST
	(
		[Quarter] tinyint,
		[Year] smallint,
		Claim_no varchar(30),	
		Total_Cost money,
		Mechanism_of_Injury int,
		date_of_birth datetime
	)
	CREATE TABLE #MECHANISM
	(
		[QUARTER] varchar(10),
		[YEAR] smallint,
		Mechanism_of_Injury int,
		Claim_Number varchar(30), date_of_birth datetime,
		Age smallint,
		Is_Open_Claim tinyint,
		Is_New_Claim tinyint,
		Total_Cost money
	)
	
	INSERT INTO #QUARTER_YEAR
	SELECT * FROM [dbo].[udf_ListQuarterYear](@From_Quarter_Year, @From_Quarter_Quarter,@To_Quarter_Year, @To_Quarter_Quarter)
	
	declare @start_date datetime
	declare @end_date datetime
	set @start_date =   [dbo].[udf_GetFirstDateByQuarter](@From_Quarter_Year,@From_Quarter_Quarter) -- first day of quarter
	set @end_date = dbo.udf_GetLastDateByQuarter(@To_Quarter_Year,@To_Quarter_Quarter) + '23:59'	-- last day of quarter
	
	CREATE TABLE #POLICY
	(
		value nvarchar(4000)
	)
		
	INSERT INTO #POLICY
	SELECT * FROM dbo.udf_Split(@Policies, ',')
	
	-- OPEN CLAIMS
	INSERT INTO #OPEN_CLAIM
	SELECT
		QY.[Quarter],
		QY.[Year],
		CADA.Claim_no,	
		Claim_Closed_Flag,
		CD.Mechanism_of_Injury,
		CD.date_of_birth, CD.Date_Of_Injury
	FROM CAD_AUDIT CADA JOIN CLAIM_DETAIL CD ON CD.CLAIM_NUMBER = CADA.CLAIM_NO,
		#QUARTER_YEAR QY
	WHERE 
		CD.policy_no COLLATE Latin1_General_CI_AS IN (SELECT * FROM #POLICY) 
		AND CADA.ID = (SELECT MAX(ID) FROM CAD_AUDIT CADA1
						WHERE CADA1.CLAIM_NO = CADA.CLAIM_NO
							AND CADA1.TRANSACTION_DATE <= QY.end_date)
		AND ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') <> 'Y'
		--AND CD.Date_Of_Injury BETWEEN @Start_Date AND @End_Date
    ORDER BY QY.[Year], QY.[Quarter]
    
    -- NEW CLAIMS
    INSERT INTO #NEW_CLAIM
    SELECT QY.[Quarter],
		QY.[Year],
		CAD.CLAIM_NO,
		Is_New_Claim = 1,
		CD.Mechanism_of_Injury,
		CD.date_of_birth
	FROM CLAIM_ACTIVITY_DETAIL CAD JOIN CLAIM_DETAIL CD ON CD.CLAIM_NUMBER = CAD.CLAIM_NO,
		#QUARTER_YEAR QY
	WHERE 
		CD.policy_no COLLATE Latin1_General_CI_AS IN (SELECT * FROM #POLICY) 
		AND CAD.Date_Claim_Entered BETWEEN QY.[start_date] AND QY.end_date
		--AND CD.Date_Of_Injury BETWEEN @Start_Date AND @End_Date
	ORDER BY QY.[Year], QY.[Quarter]
	
	-- CLAIMS COST
	INSERT INTO #CLAIM_COST
	SELECT QY.[Quarter],
		QY.[Year],
		PR.CLAIM_NO,
		Total_Cost = SUM(PR.TRANS_AMOUNT),
		CD.Mechanism_of_Injury,
		CD.date_of_birth
	FROM PAYMENT_RECOVERY PR JOIN CLAIM_DETAIL CD ON CD.CLAIM_NUMBER = PR.CLAIM_NO,
		#QUARTER_YEAR QY
	WHERE 
		CD.policy_no COLLATE Latin1_General_CI_AS IN (SELECT * FROM #POLICY) 
		AND PR.Transaction_Date BETWEEN QY.[start_date] AND QY.end_date
		AND CD.Date_Of_Injury BETWEEN @Start_Date AND @End_Date
	GROUP BY QY.[Quarter], QY.[Year],PR.CLAIM_NO, CD.Mechanism_of_Injury, CD.date_of_birth
	
	-- MECHANISM
    INSERT INTO #MECHANISM
    SELECT [QUARTER] = CASE WHEN #OPEN_CLAIM.[QUARTER] IS NOT NULL THEN #OPEN_CLAIM.[QUARTER]
							ELSE CASE WHEN #NEW_CLAIM.[QUARTER] IS NOT NULL THEN #NEW_CLAIM.[QUARTER]
							ELSE CASE WHEN #CLAIM_COST.[QUARTER] IS NOT NULL THEN #CLAIM_COST.[QUARTER] END END END,
		[YEAR] = CASE WHEN #OPEN_CLAIM.[YEAR] IS NOT NULL THEN #OPEN_CLAIM.[YEAR]
							ELSE CASE WHEN #NEW_CLAIM.[YEAR] IS NOT NULL THEN #NEW_CLAIM.[YEAR]
							ELSE CASE WHEN #CLAIM_COST.[YEAR] IS NOT NULL THEN #CLAIM_COST.[YEAR] END END END,
		
		Mechanism_of_Injury = CASE WHEN #OPEN_CLAIM.Mechanism_of_Injury IS NOT NULL THEN #OPEN_CLAIM.Mechanism_of_Injury
							ELSE CASE WHEN #NEW_CLAIM.Mechanism_of_Injury IS NOT NULL THEN #NEW_CLAIM.Mechanism_of_Injury
							ELSE CASE WHEN #CLAIM_COST.Mechanism_of_Injury IS NOT NULL THEN #CLAIM_COST.Mechanism_of_Injury END END END,
		Claim_Number = CASE WHEN #OPEN_CLAIM.CLAIM_NO IS NOT NULL THEN #OPEN_CLAIM.CLAIM_NO
							ELSE CASE WHEN #NEW_CLAIM.CLAIM_NO IS NOT NULL THEN #NEW_CLAIM.CLAIM_NO
							ELSE CASE WHEN #CLAIM_COST.CLAIM_NO IS NOT NULL THEN #CLAIM_COST.CLAIM_NO END END END,
		date_of_birth = CASE WHEN #OPEN_CLAIM.date_of_birth IS NOT NULL THEN #OPEN_CLAIM.date_of_birth
							ELSE CASE WHEN #NEW_CLAIM.date_of_birth IS NOT NULL THEN #NEW_CLAIM.date_of_birth
							ELSE CASE WHEN #CLAIM_COST.date_of_birth IS NOT NULL THEN #CLAIM_COST.date_of_birth END END END,
		--Age = CONVERT(INT, dbo.udf_CalculateAge(
		--				CASE WHEN #OPEN_CLAIM.date_of_birth IS NOT NULL THEN #OPEN_CLAIM.date_of_birth
		--					ELSE CASE WHEN #NEW_CLAIM.date_of_birth IS NOT NULL THEN #NEW_CLAIM.date_of_birth
		--					ELSE CASE WHEN #CLAIM_COST.date_of_birth IS NOT NULL THEN #CLAIM_COST.date_of_birth END END END, GETDATE())),
		Age = DATEDIFF(YEAR, #OPEN_CLAIM.date_of_birth, GETDATE()),
		Is_Open_Claim = CASE WHEN Claim_Closed_Flag = 'N' THEN 1 ELSE 0 END,
		Is_New_Claim = CASE WHEN Is_New_Claim = 1 THEN 1 ELSE 0 END,
		Total_Cost
	FROM (#OPEN_CLAIM 
			FULL JOIN #NEW_CLAIM ON #OPEN_CLAIM.[QUARTER] = #NEW_CLAIM.[QUARTER] AND #OPEN_CLAIM.[YEAR] = #NEW_CLAIM.[YEAR] AND #OPEN_CLAIM.CLAIM_NO = #NEW_CLAIM.CLAIM_NO COLLATE Latin1_General_CI_AS
			FULL JOIN #CLAIM_COST ON #OPEN_CLAIM.[QUARTER] = #CLAIM_COST.[QUARTER] AND #OPEN_CLAIM.[YEAR] = #CLAIM_COST.[YEAR] AND #OPEN_CLAIM.CLAIM_NO = #CLAIM_COST.CLAIM_NO  COLLATE Latin1_General_CI_AS)
		
	SELECT 
		[Quarter],
		[YEAR],
		[Mechanism_Group],
		Number_Of_New_Claim = SUM(Is_New_Claim),
		Total_Number_Of_Open_Claims = SUM(Is_Open_Claim),
		Total_Cost = SUM(Total_Cost),
		Average_Cost = CASE WHEN SUM(Is_Open_Claim) <> 0 THEN SUM(Total_Cost)/SUM(Is_Open_Claim) END,
		--Average_Age_Of_Injured_Workers = CASE WHEN SUM(Is_Open_Claim) <> 0 THEN SUM(Age)/SUM(Is_Open_Claim) END,
		Average_Age_Of_Injured_Workers = CASE WHEN ISNULL(SUM(Is_Open_Claim), 0) > 0 THEN SUM(Age)/SUM(Is_Open_Claim) END,
		Financial_Year
	FROM
	(	
		SELECT [Quarter] = convert(varchar(4), [YEAR]) + ' Q' + convert(varchar(4), [QUARTER]),
			[YEAR], 
			[Mechanism_Group] = CASE WHEN Mechanism_of_Injury IN (1, 2, 3) THEN 'Falls/Trips/Slips'
								WHEN Mechanism_of_Injury IN (11, 12, 13) THEN 'Hitting object with a part of body'
								WHEN Mechanism_of_Injury IN (21, 22, 23, 24, 25, 26, 27, 28, 29) THEN 'Being hit by moving objects'
								WHEN Mechanism_of_Injury IN (31, 32, 38, 39) THEN 'Sound and Pressure'
								WHEN Mechanism_of_Injury IN (41, 42, 43, 44) THEN 'Body Stressing'
								WHEN Mechanism_of_Injury IN (51, 52, 53, 54, 55, 56, 57, 58, 59) THEN 'Heat, Electricity and other environmental factors'
								WHEN Mechanism_of_Injury IN (61, 62, 63, 64, 69) THEN 'Chemicals and other subtances'
								WHEN Mechanism_of_Injury IN (71, 72, 79) THEN 'Biological factors'
								WHEN Mechanism_of_Injury IN (81, 82, 84, 85, 86, 87, 88) THEN 'Mental Stress'
								WHEN Mechanism_of_Injury IN (91, 92, 93, 98, 99) THEN 'Vehicle incidents and other' 
								ELSE 'Others'END,
			Claim_Number,
			Age,
			Is_Open_Claim,
			Is_New_Claim,
			Total_Cost,
			Financial_Year = case when [QUARTER] = 1 or [QUARTER] = 2 
									then convert(varchar(4),[YEAR] - 1) + '/' + convert(varchar(4),[YEAR])
									else convert(varchar(4),[YEAR]) + '/' + convert(varchar(4),[YEAR] + 1) end
		FROM #MECHANISM
	) AS TBL
	GROUP BY [QUARTER],	[YEAR],	[Mechanism_Group], Financial_Year
	ORDER BY [QUARTER], [Mechanism_Group]
	
	--select * from #NEW_claim
	--select * from #open_claim
	
	--SELECT * FROM #MECHANISM
	--order by [year], [quarter], Claim_Number
			
    DROP TABLE #OPEN_CLAIM
    DROP TABLE #NEW_CLAIM
    DROP TABLE #CLAIM_COST
    DROP TABLE #MECHANISM
    DROP TABLE #QUARTER_YEAR
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostForMechanism_Occupation_BodyLocation]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostForMechanism_Occupation_BodyLocation]  TO [emius]
GO