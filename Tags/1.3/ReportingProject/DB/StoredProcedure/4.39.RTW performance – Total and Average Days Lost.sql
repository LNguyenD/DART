/****** Object:  StoredProcedure [dbo].[usp_RTWPerformanceTotalAndAverageDaysLost]    Script Date: 03/16/2012 15:32:56 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_RTWPerformanceTotalAndAverageDaysLost]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_RTWPerformanceTotalAndAverageDaysLost]
GO

/****** Object:  StoredProcedure [dbo].[usp_RTWPerformanceTotalAndAverageDaysLost]    Script Date: 03/16/2012 15:32:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- EXEC usp_RTWPerformanceTotalAndAverageDaysLost '2009', '1', '2012', '4', '' 
CREATE PROCEDURE [dbo].[usp_RTWPerformanceTotalAndAverageDaysLost]
	@From_Quarter_Year char(4),
	@From_Quarter_Quarter char(1),
	@To_Quarter_Year char(4),
	@To_Quarter_Quarter char(1),
	@Policies varchar(8000)
AS
BEGIN
	SET NOCOUNT ON;
	CREATE TABLE #QUARTER_YEAR
	(
		[year] smallint, 
		[quarter] SMALLINT, 
		[start_date] datetime, 
		end_date datetime
	)
	CREATE TABLE #PAYMENT
	(
		CLAIM_NO VARCHAR(30),
		END_DATE DATETIME,
		[YEAR] SMALLINT, 
		[QUARTER] SMALLINT,
		Day_Lost SMALLINT,
		Payment_Group VARCHAR(30)
	)
	
	CREATE TABLE #QUARTER_PAYMENT
	(
		[Year] int,
		[Quarter] SMALLINT,
		Payment_Group varchar(30),
		Total_Number_Of_Open_Claims int,
		Total_Days_Lost int,
		Average_Days_Lost decimal(10, 2)
	)
	
	CREATE TABLE #TRANFORMED_PAYMENT
	(
		
		[Quarter] varchar(12),
		Total_Days_Lost_For_Section_36 int,
		Average_Days_Lost_For_Section_36 decimal(10, 2),
		Total_Number_Of_Open_Claims_For_Section_36 int,
		Total_Days_Lost_For_Section_37 int,
		Average_Days_Lost_For_Section_37 decimal(10, 2),
		Total_Number_Of_Open_Claims_For_Section_37 int,
		Total_Days_Lost_For_Section_38 int,
		Average_Days_Lost_For_Section_38 decimal(10, 2),
		Total_Number_Of_Open_Claims_For_Section_38 int,
		Total_Days_Lost_For_Section_40 int,
		Average_Days_Lost_For_Section_40 decimal(10, 2),
		Total_Number_Of_Open_Claims_For_Section_40 int,
		Total_Days_Lost_For_Others int,
		Average_Days_Lost_For_Others decimal(10, 2),
		Total_Number_Of_Open_Claims_For_Others int,
		[Year] int,
		Financial_Year varchar(16)
	)
	
	CREATE TABLE #TEMP
	(
		[Quarter] char(8),
		Total_Days_Lost_For_Section_36 smallint,
		Average_Days_Lost_For_Section_36 decimal(10, 2),
		Total_Number_Of_Open_Claims_For_Section_36 smallint,
			
		Total_Days_Lost_For_Section_37 smallint,
		Average_Days_Lost_For_Section_37 decimal(10, 2),
		Total_Number_Of_Open_Claims_For_Section_37 smallint,
			
		Total_Days_Lost_For_Section_38 smallint,
		Average_Days_Lost_For_Section_38 decimal(10, 2),
		Total_Number_Of_Open_Claims_For_Section_38 smallint,
			
		Total_Days_Lost_For_Section_40 smallint,
		Average_Days_Lost_For_Section_40 decimal(10, 2),
		Total_Number_Of_Open_Claims_For_Section_40 smallint,
			
		Total_Days_Lost_For_Total_Incapacity smallint,
		Average_Days_Lost_For_Total_Incapacity decimal(10, 2),
		Total_Number_Of_Open_Claims_For_Total_Incapacity smallint,
		
		Total_Days_Lost_For_Partial_Incapacity smallint,
		Average_Days_Lost_For_Partial_Incapacity decimal(10, 2),
		Total_Number_Of_Open_Claims_For_Partial_Incapacity smallint,
		
		Total_Days_Lost_For_Weekly_Benefits smallint,
		Average_Days_Lost_For_Weekly_Benefits decimal(10, 2),
		Total_Number_Of_Open_Claims_For_Weekly_Benefits smallint,
		
		Total_Days_Lost smallint,
		Average_Days_Lost decimal(10, 2),
		Total_Number_Of_Open_Claims smallint,
			
		[YEAR] smallint,
		Financial_Year char(10)
	)
	CREATE TABLE #POLICY
	(
		value nvarchar(4000)
	)
	
	declare @start_date datetime
	declare @end_date datetime
	set @start_date =   [dbo].[udf_GetFirstDateByQuarter](@From_Quarter_Year,@From_Quarter_Quarter) -- first day of quarter
	set @end_date = dbo.udf_GetLastDateByQuarter(@To_Quarter_Year,@To_Quarter_Quarter) + '23:59'	-- last day of quarter

	
	INSERT INTO #POLICY
	SELECT * FROM dbo.udf_Split(@Policies, ',')
	
	INSERT INTO #QUARTER_YEAR
	SELECT * FROM [dbo].[udf_ListQuarterYear](@From_Quarter_Year, @From_Quarter_Quarter,@To_Quarter_Year, @To_Quarter_Quarter)
	
	INSERT INTO #PAYMENT
	SELECT 
		CLAIM_NO = CASE WHEN ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') = 'N' THEN CADA.CLAIM_NO ELSE NULL END, 
		QY.END_DATE,
		QY.[YEAR] ,
		QY.[QUARTER],
		Day_Lost = ISNULL((convert(SMALLINT,substring(isnull(cd.work_days, '1111100'),1,1)) + convert(SMALLINT,substring(isnull(cd.work_days, '1111100'),2,1)) +
					convert(SMALLINT,substring(isnull(cd.work_days, '1111100'),3,1)) + convert(SMALLINT,substring(isnull(cd.work_days, '1111100'),4,1)) +
					convert(SMALLINT,substring(isnull(cd.work_days, '1111100'),5,1)) + convert(SMALLINT,substring(isnull(cd.work_days, '1111100'),6,1)) +
					convert(SMALLINT,substring(isnull(cd.work_days, '1111100'),7,1))) * ISNULL(PR.WEEKS_PAID, 0) + ISNULL(PR.DAYS_PAID, 0), 0) ,
		Payment_Group = CASE WHEN PR.PAYMENT_TYPE IN ('WPT001', 'WPT003') THEN 'Section 36'
							WHEN PR.PAYMENT_TYPE IN ('WPT002', 'WPT004') THEN 'Section 37'
							WHEN PR.PAYMENT_TYPE IN ('WPP001', 'WPP003') THEN 'Section 38'
							WHEN PR.PAYMENT_TYPE IN ('WPP002', 'WPP004') THEN 'Section 40'
							ELSE 'OTHERS' 
							END
	FROM CAD_AUDIT CADA JOIN CLAIM_DETAIL CD ON CD.CLAIM_NUMBER = CADA.CLAIM_NO
		LEFT JOIN PAYMENT_RECOVERY PR ON PR.CLAIM_NO = CD.CLAIM_NUMBER,
		#QUARTER_YEAR QY
	WHERE 
		CD.policy_no COLLATE Latin1_General_CI_AS IN (SELECT * FROM #POLICY) 
		AND CADA.ID = (SELECT MAX(ID) FROM CAD_AUDIT CADA1
						WHERE CADA1.CLAIM_NO = CADA.CLAIM_NO
							AND CADA1.TRANSACTION_DATE <= QY.END_DATE)
		AND PR.TRANSACTION_DATE BETWEEN QY.[START_DATE] AND QY.END_DATE
		
		
		
	INSERT INTO #QUARTER_PAYMENT
	SELECT [YEAR], [QUARTER],
		PAYMENT_GROUP,
		Total_Number_Of_Open_Claims = COUNT(DISTINCT CLAIM_NO),
		Total_Days_Lost = SUM(Day_Lost),
		Average_Days_Lost = CASE WHEN COUNT(DISTINCT CLAIM_NO) <> 0 THEN convert(decimal(10, 2), SUM(Day_Lost)) / convert(decimal(10, 2), COUNT(DISTINCT CLAIM_NO)) END
	FROM #PAYMENT P
	GROUP BY [YEAR], [QUARTER], PAYMENT_GROUP
	UNION
	SELECT [YEAR], [QUARTER],
		PAYMENT_GROUP = 'Totally incapacity',
		Total_Number_Of_Open_Claims = COUNT(DISTINCT CLAIM_NO),
		Total_Days_Lost = SUM(Day_Lost),
		Average_Days_Lost= CASE WHEN COUNT(DISTINCT CLAIM_NO) <> 0 THEN convert(decimal(10, 2), SUM(Day_Lost)) / convert(decimal(10, 2), COUNT(DISTINCT CLAIM_NO)) END
	FROM #PAYMENT
	WHERE PAYMENT_GROUP IN ('Section 36', 'Section 37')
	GROUP BY [YEAR], [QUARTER]
	UNION
	SELECT [YEAR], [QUARTER],
		PAYMENT_GROUP = 'Partial incapacity',
		Total_Number_Of_Open_Claims = COUNT(DISTINCT CLAIM_NO),
		Total_Days_Lost = SUM(Day_Lost),
		Average_Days_Lost= CASE WHEN COUNT(DISTINCT CLAIM_NO) <> 0 THEN convert(decimal(10, 2), SUM(Day_Lost)) / convert(decimal(10, 2), COUNT(DISTINCT CLAIM_NO)) END
	FROM #PAYMENT
	WHERE PAYMENT_GROUP IN ('Section 38', 'Section 40')
	GROUP BY [YEAR], [QUARTER]
	UNION
	SELECT [YEAR], [QUARTER],
		PAYMENT_GROUP = 'Weekly Benefits',
		Total_Number_Of_Open_Claims = COUNT(DISTINCT CLAIM_NO),
		Total_Days_Lost = SUM(Day_Lost),
		Average_Days_Lost= CASE WHEN COUNT(DISTINCT CLAIM_NO) <> 0 THEN convert(decimal(10, 2), SUM(Day_Lost)) / convert(decimal(10, 2), COUNT(DISTINCT CLAIM_NO)) END
	FROM #PAYMENT
	WHERE PAYMENT_GROUP <> 'OTHERS'
	GROUP BY [YEAR], [QUARTER]
	UNION
	SELECT [YEAR], [QUARTER],
		PAYMENT_GROUP = 'All',
		Total_Number_Of_Open_Claims = (SELECT COUNT(DISTINCT CLAIM_NO) FROM CAD_AUDIT CADA JOIN CLAIM_DETAIL CD ON CD.CLAIM_NUMBER = CADA.CLAIM_NO
										WHERE CADA.ID = (SELECT MAX(ID) FROM CAD_AUDIT CADA1
														WHERE CADA1.CLAIM_NO = CADA.CLAIM_NO
															AND CADA1.TRANSACTION_DATE <= MIN(END_DATE))
											AND CD.policy_no COLLATE Latin1_General_CI_AS IN (SELECT * FROM #POLICY) 
											AND ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') = 'N'
											AND CADA.TRANSACTION_DATE BETWEEN @START_DATE AND @END_DATE),
		Total_Days_Lost = SUM(Day_Lost),
		Average_Days_Lost = NULL
	FROM #PAYMENT
	GROUP BY [YEAR], [QUARTER]
	
	UPDATE #QUARTER_PAYMENT
	SET Average_Days_Lost = CASE WHEN Total_Number_Of_Open_Claims > 0 THEN convert(decimal(10, 2), Total_Days_Lost)/convert(decimal(10, 2), Total_Number_Of_Open_Claims) END
	WHERE PAYMENT_GROUP = 'All'
		
	
	INSERT INTO #TEMP
	SELECT [Quarter] = CONVERT(varchar(4), QY.[YEAR]) + ' Q' + CONVERT(varchar(4), QY.[QUARTER]),
		Total_Days_Lost_For_Section_36 = ISNULL((SELECT Total_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Section 36'), 0),
		Average_Days_Lost_For_Section_36 = ISNULL((SELECT Average_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Section 36'), 0),
		Total_Number_Of_Open_Claims_For_Section_36 = ISNULL((SELECT Total_Number_Of_Open_Claims FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Section 36'), 0),
			
		Total_Days_Lost_For_Section_37 = ISNULL((SELECT Total_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Section 37'), 0),
		Average_Days_Lost_For_Section_37 = ISNULL((SELECT Average_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Section 37'), 0),
		Total_Number_Of_Open_Claims_For_Section_37 = ISNULL((SELECT Total_Number_Of_Open_Claims FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Section 37'), 0),
			
		Total_Days_Lost_For_Section_38 = ISNULL((SELECT Total_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Section 38'), 0),
		Average_Days_Lost_For_Section_38 = ISNULL((SELECT Average_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Section 38'), 0),
		Total_Number_Of_Open_Claims_For_Section_38 = ISNULL((SELECT Total_Number_Of_Open_Claims FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Section 38'), 0),
			
		Total_Days_Lost_For_Section_40 = ISNULL((SELECT Total_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Section 40'), 0),
		Average_Days_Lost_For_Section_40 = ISNULL((SELECT Average_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Section 40'), 0),
		Total_Number_Of_Open_Claims_For_Section_40 = ISNULL((SELECT Total_Number_Of_Open_Claims FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Section 40'), 0),
			
		Total_Days_Lost_For_Total_Incapacity = ISNULL((SELECT Total_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Totally incapacity'), 0),
		Average_Days_Lost_For_Total_Incapacity = ISNULL((SELECT Average_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Totally incapacity'), 0),
		Total_Number_Of_Open_Claims_For_Total_Incapacity = ISNULL((SELECT Total_Number_Of_Open_Claims FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Totally incapacity'), 0),
		
		Total_Days_Lost_For_Partial_Incapacity = ISNULL((SELECT Total_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Partial incapacity'), 0),
		Average_Days_Lost_For_Partial_Incapacity = ISNULL((SELECT Average_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Partial incapacity'), 0),
		Total_Number_Of_Open_Claims_For_Partial_Incapacity = ISNULL((SELECT Total_Number_Of_Open_Claims FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Partial incapacity'), 0),
		
		Total_Days_Lost_For_Weekly_Benefits = ISNULL((SELECT Total_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Weekly Benefits'), 0),
		Average_Days_Lost_For_Weekly_Benefits = ISNULL((SELECT Average_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Weekly Benefits'), 0),
		Total_Number_Of_Open_Claims_For_Weekly_Benefits = ISNULL((SELECT Total_Number_Of_Open_Claims FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'Weekly Benefits'), 0),
		
		Total_Days_Lost = ISNULL((SELECT Total_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'All'), 0),
		Average_Days_Lost = ISNULL((SELECT Average_Days_Lost FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'All'), 0),
		Total_Number_Of_Open_Claims = ISNULL((SELECT Total_Number_Of_Open_Claims FROM #QUARTER_PAYMENT P 
			WHERE P.[YEAR] = QY.[YEAR] AND P.[QUARTER] = QY.[QUARTER] AND P.PAYMENT_GROUP = 'All'), 0),
			
		QY.[YEAR],
		Financial_Year = case when QY.[QUARTER] = 1 or QY.[QUARTER] = 2 
									then convert(varchar(4),QY.[YEAR] - 1) + '/' + convert(varchar(4),QY.[YEAR])
							else convert(varchar(4),QY.[YEAR]) + '/' + convert(varchar(4),QY.[YEAR] + 1) end
	FROM #QUARTER_YEAR QY
	
	DELETE FROM #TEMP
	WHERE Total_Days_Lost = 0
		AND Total_Number_Of_Open_Claims = 0
	
	
	
	SELECT * FROM #TEMP
	
	
	DROP TABLE #PAYMENT
	DROP TABLE #QUARTER_YEAR
	DROP TABLE #QUARTER_PAYMENT
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_RTWPerformanceTotalAndAverageDaysLost]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_RTWPerformanceTotalAndAverageDaysLost]  TO [emius]
GO


