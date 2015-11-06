/****** Object:  StoredProcedure [dbo].[usp_TotalNumberOfOpenClaims]    Script Date: 04/19/2012 05:23:34 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_TotalNumberOfOpenClaims]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_TotalNumberOfOpenClaims]
GO

/****** Object:  StoredProcedure [dbo].[usp_TotalNumberOfOpenClaims]    Script Date: 04/19/2012 05:23:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_TotalNumberOfOpenClaims] 
	@Start_Date datetime,
	@End_Date datetime,
	@IsAll bit,
	@IsRig bit
AS
BEGIN
	SET NOCOUNT ON;
	
	
							
	CREATE TABLE #TEMP
	(
		Agency varchar(300),
		Employer_Name varchar(175),
		Number_Of_Employee int,
		Claim_Number varchar(30),
		Date_Of_Injury Datetime,
		Date_Significant_Injured datetime,
		Date_Claim_Entered datetime,
		Age_Of_Claim_In_Weeks  decimal(10, 2),
		--Medical_Certificate_Type varchar(40),
		--MC_ID int,
		[Group] varchar(10),
		Team varchar(10),
		Claims_Officer varchar(75),
		IMA_Officer varchar(75),
		Open_Claims tinyint,
		New_Claims tinyint,
		Notifications tinyint,
		Closed_Claims tinyint,
		Re_opens tinyint,
		Manager_File_Review_Completed tinyint
	)
	
	DECLARE @Reporting_start datetime
	SET @Start_Date = LEFT(CONVERT(VARCHAR(8), @Start_Date, 112), 6) + '01'
	SET @End_Date = convert(datetime, convert(char, @End_Date, 106)) + '23:59'
	
	INSERT INTO #TEMP
	SELECT Agency = PTD.Agency_id,
		Employer_Name = PTD.legal_name,
		Number_Of_Employee = CD.Workplace_Size,
		Claim_Number = CD.Claim_number,
		Date_Of_Injury = CD.Date_of_Injury,
		Date_Significant_Injured = CD.Date_Significant,
		Date_Claim_Entered = CAD.Date_Claim_Entered,
		Age_Of_Claim_In_Weeks  = DATEDIFF(DAY, CADA.Date_Claim_Entered, @End_Date )/7.0,
		--Medical_Certificate_Type = CASE WHEN MC.TYPE = 'I' THEN 'Pre-injury duties'
		--	WHEN MC.TYPE = 'S' THEN 'Suitable duties'
		--	WHEN MC.TYPE = 'T' THEN 'Totally unfit'
		--	WHEN MC.TYPE = 'M' THEN 'Permanently Modified duties'
		--	WHEN MC.TYPE = 'P' THEN 'No time lost' END,
		--MC_ID = MC.ID,
		[Group] = dbo.[udf_ExtractGroup](co.grp),
		Team = co.grp,
		Claims_Officer = co.First_Name + ' ' + co.Last_Name,
		IMA_Officer = co1.First_Name + ' ' + co1.Last_Name,
		Open_Claims = CASE WHEN ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') = 'N' THEN 1 ELSE 0 END,
		New_Claims = CASE WHEN CADA.DATE_CLAIM_ENTERED BETWEEN @Start_Date AND @End_Date THEN 1 ELSE 0 END,
		Notifications = CASE WHEN CADA.DATE_CLAIM_RECEIVED BETWEEN @Start_Date AND @End_Date THEN 1 ELSE 0 END,
		Closed_Claims = CASE WHEN ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') <> 'N' THEN 1 ELSE 0 END,
		Re_opens = CASE WHEN CADA.DATE_CLAIM_REOPENED BETWEEN @Start_Date AND @End_Date THEN 1 ELSE 0 END,
		Manager_File_Review_Completed = CASE WHEN EXISTS (SELECT REVIEW_NO 
															FROM FILE_REVIEW_HEADER 
															WHERE COMPLETED_DATE BETWEEN @Start_Date AND @End_Date
																AND Claim_no = CD.CLAIM_NUMBER)
												THEN 1 ELSE 0 END
	FROM CAD_AUDIT CADA
		JOIN CLAIM_DETAIL CD  ON CD.Claim_number = CADA.Claim_no
		LEFT JOIN CLAIM_ACTIVITY_DETAIL CAD ON CAD.CLAIM_NO = CADA.CLAIM_NO
		LEFT JOIN POLICY_TERM_DETAIL PTD ON CD.Policy_no = PTD.Policy_no
		LEFT JOIN CLAIMS_OFFICERS CO ON CAD.Claims_Officer = CO.Alias
		LEFT JOIN CLAIMS_OFFICERS CO1 ON CD.IMA = CO1.Alias
		--JOIN MEDICAL_CERT MC ON MC.Claim_no = CADA.Claim_no
	WHERE
		CADA.ID = (SELECT MAX(ID)
			FROM CAD_Audit CADA1
			WHERE CADA.Claim_no = CADA1.Claim_no
				AND CADA1.transaction_date <= @End_Date)
		AND ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') = 'N'
		--AND MC.ID = (SELECT top 1 ID
		--				FROM MEDICAL_CERT MC1
		--				WHERE MC1.Claim_no = MC.Claim_no AND MC1.is_deleted = 0
		--				ORDER BY Date_To DESC, create_date ASC)
		AND (@IsAll = 1 OR ((@IsRig = 0 AND CO.Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND CO.Grp LIKE 'RIG%'))) 
		
	CREATE TABLE #TempMC
	(
		Claim_no varchar(19),
		Medical_Certificate_Type varchar(40),
		ID int		
	)
	insert into #TempMC
	select Claim_no = MC.Claim_no,
			Medical_Certificate_Type = CASE WHEN MC.Type = 'I' THEN 'Pre-injury duties'
													WHEN MC.Type = 'S' THEN 'Suitable duties'
													WHEN MC.Type = 'T' THEN 'Totally unfit'
													WHEN MC.Type = 'M' THEN 'Permanently Modified duties'
													WHEN MC.Type = 'P' THEN 'No time lost' END,
			ID = MC.ID
	from #TEMP LEFT JOIN Medical_Cert MC ON MC.Claim_no = #TEMP.Claim_Number
	where MC.ID = (SELECT top 1 ID
					FROM MEDICAL_CERT MC2
					WHERE MC2.Claim_no = #TEMP.Claim_Number AND MC2.is_deleted = 0
					ORDER BY Date_To DESC, Date_From DESC)
			
	SELECT #Temp.*, Medical_Certificate_Type = #TempMC.Medical_Certificate_Type, MC_ID = #TempMC.ID,
		Age_Group = case when Age_Of_Claim_In_Weeks >= 0 and Age_Of_Claim_In_Weeks < 12 then '0-12 weeks'
						when Age_Of_Claim_In_Weeks >= 12 and Age_Of_Claim_In_Weeks < 26 then '12-26 weeks'
						when Age_Of_Claim_In_Weeks >= 26 and Age_Of_Claim_In_Weeks < 52 then '26-52 weeks'
						when Age_Of_Claim_In_Weeks >= 52 and Age_Of_Claim_In_Weeks < 78 then '52-78 weeks'
						when Age_Of_Claim_In_Weeks >= 78 and Age_Of_Claim_In_Weeks < 104 then '78-104 weeks'
						when Age_Of_Claim_In_Weeks >= 104 then 'above 104 weeks +' end
	FROM #Temp LEFT JOIN #TempMC ON #TEMP.Claim_Number = #TempMC.Claim_no
	ORDER BY #Temp.Claim_Number
	
	DROP TABLE #TEMP
END

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_TotalNumberOfOpenClaims]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_TotalNumberOfOpenClaims]  TO [emius]
GO

-- exec [usp_TotalNumberOfOpenClaims] '20111201', '20111231', 1, 1
