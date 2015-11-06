

/****** Object:  StoredProcedure [dbo].[NoMedicalCertificateCoverageForWagePeriodPaid]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_NoMedicalCertificateCoverageForWagePeriodPaid]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_NoMedicalCertificateCoverageForWagePeriodPaid]
GO

/****** Object:  StoredProcedure [dbo].[NoMedicalCertificateCoverageForWagePeriodPaid]    Script Date: 01/16/2012 08:56:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--execute [usp_NoMedicalCertificateCoverageForWagePeriodPaid] '12/1/2008','12/31/2012',1,0

create procedure [dbo].[usp_NoMedicalCertificateCoverageForWagePeriodPaid]
	@start_date datetime,
	@end_date datetime,	
	@IsAll bit,
	@IsRig bit
as
	begin		
		set @start_date =convert(datetime, convert(char, @start_date, 106)) 
		set @end_date =convert(datetime, convert(char, @end_date, 106)) + '23:59'	
		Create table #TEMP
		(
			[Group] varchar(50),
			Team varchar(50),
			Claim_Officer varchar(300),
			Claim_no char(30),
			Claim_Closed_Flag char(1),
			Date_Claim_Closed smalldatetime,
			Payment_no int,
			Date_Payment_Entered smalldatetime,
			Period_Start_Date smalldatetime,
			Period_End_Date smalldatetime,
			Wage_Payment_Type_Code varchar(30),
			Wage_Payment_Type_Description varchar(200),
			Last_Medical_Certificate_Period_Recorded_From_Date smalldatetime,
			Last_Medical_Certificate_Period_Recorded_To_Date smalldatetime,
			Date_Medical_Certificate_Entered smalldatetime,
			Medical_Certificate_Fitness_Code char(1),
			Medical_Fitness_Description varchar(200)
		)
		insert into #TEMP
		SELECT  dbo.[udf_ExtractGroup](CL.grp) as [Group]
				,CL.grp as Team				
				,CL.First_Name + ' ' + CL.Last_Name as Claim_Officer
				,CAD.Claim_no
				,CAD.Claim_Closed_Flag
				,CAD.Date_Claim_Closed				
				,PM.Payment_no				
				,Date_Payment_Entered = PM.Transaction_date
				,PM.Period_Start_Date	
				,PM.Period_End_Date
				,Wage_Payment_Type_Code = PM.Payment_Type
				,Wage_Payment_Type_Description =(case when PM.Payment_Type in ('WPT001','WPT003')  then 'Section 36 Totally incapacity first 26 weeks' else 'Section 37 Totally incapacity after 26 weeks' end)
				
				,Last_Medical_Certificate_Period_Recorded_From_Date =
							(SELECT Date_From
							FROM medical_cert
							WHERE CONVERT(VARCHAR(8), DATE_TO,112) + CONVERT(VARCHAR(10), ID) = (SELECT MAX(CONVERT(VARCHAR(8), DATE_TO,112) + CONVERT(VARCHAR(10), ID))
                        FROM medical_cert WHERE claim_no = CD.Claim_Number AND Is_Deleted = 0 AND Cancelled_Date IS NULL))
				,Last_Medical_Certificate_Period_Recorded_To_Date =(
								SELECT  Date_To
								FROM medical_cert
								WHERE CONVERT(VARCHAR(8), DATE_TO,112) + CONVERT(VARCHAR(10), ID) = (SELECT MAX(CONVERT(VARCHAR(8), DATE_TO,112) + CONVERT(VARCHAR(10), ID))
                        FROM medical_cert WHERE claim_no = CD.Claim_Number AND Is_Deleted = 0 AND Cancelled_Date IS NULL))
				,Date_Medical_Certificate_Entered =(
						SELECT Received_Date
							FROM medical_cert
							WHERE CONVERT(VARCHAR(8), DATE_TO,112) + CONVERT(VARCHAR(10), ID) = (SELECT MAX(CONVERT(VARCHAR(8), DATE_TO,112) + CONVERT(VARCHAR(10), ID))
                        FROM medical_cert WHERE claim_no = CD.Claim_Number AND Is_Deleted = 0 AND Cancelled_Date IS NULL))
				,Medical_Certificate_Fitness_Code = (
						SELECT (CASE WHEN Type = 'I' THEN 1
									 WHEN Type = 'S' THEN 2
									 WHEN Type = 'T' THEN 3
									 WHEN Type = 'M' THEN 4
									 ELSE 0 END)           
						FROM medical_cert
						WHERE CONVERT(VARCHAR(8), DATE_TO,112) + CONVERT(VARCHAR(10), ID) = (SELECT MAX(CONVERT(VARCHAR(8), DATE_TO,112) + CONVERT(VARCHAR(10), ID))
                        FROM medical_cert WHERE claim_no = CD.Claim_Number AND Is_Deleted = 0 AND Cancelled_Date IS NULL))
				,Medical_Fitness_Description =(
						SELECT (CASE WHEN Type = 'I' THEN 'Pre-Injury Duties'
									 WHEN Type = 'S' THEN 'Suitable Duties'
									 WHEN Type = 'T' THEN 'Totally Unfit'
									 WHEN Type = 'M' THEN 'Permanently Modified Duties'
									 ELSE 'NA' END)        
						FROM medical_cert
						WHERE CONVERT(VARCHAR(8), DATE_TO,112) + CONVERT(VARCHAR(10), ID) = (SELECT MAX(CONVERT(VARCHAR(8), DATE_TO,112) + CONVERT(VARCHAR(10), ID))
                        FROM medical_cert WHERE claim_no = CD.Claim_Number AND Is_Deleted = 0 AND Cancelled_Date IS NULL))
		FROM CLAIM_DETAIL CD LEFT JOIN CLAIM_ACTIVITY_DETAIL CAD ON CD.CLAIM_NUMBER = CAD.CLAIM_NO
			 LEFT OUTER JOIN CLAIMS_OFFICERS CL (NOLOCK) ON CL.Alias = CAD.Claims_Officer	
			 LEFT JOIN Payment_Recovery PM on CD.Claim_Number =PM.Claim_No
			 
		WHERE  Payment_Type in ('WPT001','WPT002','WPT003','WPT004')	
			 And  PM.Transaction_date =
			 (select top 1 Transaction_Date from Payment_Recovery PR where PR.Claim_No = CD.Claim_Number
			   and Period_Start_Date is not null and Period_End_Date is not null  order by Transaction_Date asc) 
			 And PM.Transaction_date between @start_date and @end_date
			 AND (@IsAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%')))			
		order by Team,Claim_Officer		
		
		select *
				,Period_Of_No_Medical_Coverage_From_Date = 
				(case when exists(select top 1 Transaction_date from Payment_Recovery  where Claim_no = #TEMP.Claim_no
					and Transaction_date >#TEMP.Period_End_Date) then DATEADD(day,1,#TEMP.Period_End_Date) else NULL end
				)
				,Period_Of_No_Medical_Coverage_To_Date = 
				(case when exists(select top 1 Transaction_date from Payment_Recovery  where Claim_no = #TEMP.Claim_no
					and Transaction_date >#TEMP.Period_End_Date order by Transaction_date desc) then 
					(select top 1 Transaction_date from Payment_Recovery  where Claim_no = #TEMP.Claim_no
					and Transaction_date >#TEMP.Period_End_Date order by Transaction_date desc) 
					else NULL end
				)
				,Days_between_Last_Medical_Cert_End_Date_and_Payment_To_Date= DATEDIFF(DAY, Period_End_Date, Last_Medical_Certificate_Period_Recorded_To_Date)
		from #TEMP 	order by Team,Claim_Officer		
		
		drop table #TEMP
	end
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_NoMedicalCertificateCoverageForWagePeriodPaid]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_NoMedicalCertificateCoverageForWagePeriodPaid]  TO [emius]
GO



