/****** Object:  StoredProcedure [dbo].[usp_ResultofInjury]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_ResultofInjury]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_ResultofInjury]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec usp_ResultofInjury '1/1/2012', 1, 0
Create procedure [dbo].[usp_ResultofInjury]
	@reporting_date  datetime,	
	@IsAll bit,
	@IsRIG bit
as	
	begin
		set @reporting_date =convert(datetime, convert(char, @reporting_date, 106)) + '23:59'		
		--create temp table
		Create table #ESTIMATE_DETAILS_TEMP
		(
			ID int,
			Claim_No char(19),
			Amount 	money	
		)
		insert into #ESTIMATE_DETAILS_TEMP 
		select ID, Claim_No,Amount from ESTIMATE_DETAILS  where Type in (51,53)
		
		Create table #PAYMENT_RECOVERY_TEMP
		(
			ID int,
			Claim_No char(19),
			TRANS_AMOUNT money,
			payment_no char(19),
			transaction_date datetime		
		)
		insert into #PAYMENT_RECOVERY_TEMP 
		select ID, Claim_No,TRANS_AMOUNT,payment_no,transaction_date from PAYMENT_RECOVERY  where Payment_Type in ('wpi001','wpi002')
		
		
		Create table #PAYMENT_RECOVERY_TEMP_1
		(
			ID int,
			Claim_No char(19),
			TRANS_AMOUNT money,
			payment_no char(19),
			transaction_date datetime		
		)
		insert into #PAYMENT_RECOVERY_TEMP_1 
		select ID, Claim_No,TRANS_AMOUNT,payment_no,transaction_date from PAYMENT_RECOVERY  where Estimate_type in (51,53)
				
		select  dbo.[udf_ExtractGroup](CL.grp) as [group]
				,CL.grp as team
				,CL.First_Name + ' ' + CL.Last_Name as Claim_Officer
				,CD.claim_number
				,CAD.Claim_Closed_Flag
				,CAD.Date_Claim_Closed
				,CD.Date_of_Injury
				,CAD.Date_Claim_Entered
				,CD.Nature_of_Injury
				,Nature_of_Injury_Desc = IJ.Description
				,CD.Result_of_Injury_code
				,Result_Of_Injury_Code_Desc =dbo.[udf_Get_Result_Of_Injury_Code](CD.Result_of_Injury_code)
				,Amount_Paid=isnull((SELECT SUM(TRANS_AMOUNT) FROM  #PAYMENT_RECOVERY_TEMP PR  (NOLOCK) where PR.Claim_No COLLATE DATABASE_DEFAULT=CD.Claim_Number COLLATE DATABASE_DEFAULT),0)
				,Estimate_Amount=isnull((SELECT SUM(Amount) FROM  #ESTIMATE_DETAILS_TEMP ED  where ED.Claim_No COLLATE DATABASE_DEFAULT=CD.CLAIM_Number COLLATE DATABASE_DEFAULT),0)
		
		from CLAIM_DETAIL CD  (NOLOCK) 
				INNER JOIN  CLAIM_ACTIVITY_DETAIL  CAD  (NOLOCK) ON CAD.CLAIM_NO =CD.CLAIM_NUMBER
				LEFT OUTER JOIN CLAIMS_OFFICERS CL (NOLOCK) ON CL.Alias = CAD.Claims_Officer		
				LEFT JOIN INJURY IJ (NOLOCK) ON CD.Nature_ID=IJ.ID				
		where CD.Date_of_Injury <= @reporting_date
		and
			(
				((CD.Result_of_Injury_code in (2,3)) and not exists(select ID FROM  #PAYMENT_RECOVERY_TEMP_1  (NOLOCK) where Claim_No COLLATE DATABASE_DEFAULT=CD.Claim_Number COLLATE DATABASE_DEFAULT))
				or (CD.Result_of_Injury_code = 4 and exists(select ID FROM  #PAYMENT_RECOVERY_TEMP_1  (NOLOCK) where Claim_No COLLATE DATABASE_DEFAULT=CD.Claim_Number COLLATE DATABASE_DEFAULT))
				or (CD.Result_of_Injury_code = 4 and exists(select id from #PAYMENT_RECOVERY_TEMP (NOLOCK) where Claim_No COLLATE DATABASE_DEFAULT =CD.Claim_Number COLLATE DATABASE_DEFAULT))				
			)
			and not 
			(CD.Result_of_Injury_code = 4 and isnull((SELECT SUM(TRANS_AMOUNT) FROM  #PAYMENT_RECOVERY_TEMP PR  (NOLOCK) where PR.Claim_No COLLATE DATABASE_DEFAULT=CD.Claim_Number COLLATE DATABASE_DEFAULT),0)=0 and 
			isnull((SELECT SUM(Amount) FROM  #ESTIMATE_DETAILS_TEMP ED  where ED.Claim_No COLLATE DATABASE_DEFAULT=CD.CLAIM_Number COLLATE DATABASE_DEFAULT),0)=0)
			and not (CD.Result_of_Injury_code = 3 and CAD.Claim_Closed_Flag='Y' and CD.Nature_of_Injury in(250,771))
			and not (
				(CD.Result_of_Injury_code in (2,3)) 
				and exists(select top 1 ID from #PAYMENT_RECOVERY_TEMP PR (NOLOCK) INNER JOIN Claim_Payment_Run CPR ON  PR.Payment_no = CPR.Payment_no  where CPR.Claim_number=CD.Claim_Number  and PR.Transaction_date<=@reporting_date)
				) 
		AND (@IsAll = 1 OR ((@IsRIG = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND Grp LIKE 'RIG%'))) 		
		order by [group],Claim_Officer
			
		
		drop table #ESTIMATE_DETAILS_TEMP
		drop table #PAYMENT_RECOVERY_TEMP
		drop table #PAYMENT_RECOVERY_TEMP_1
	end
	
	GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_ResultofInjury]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_ResultofInjury]  TO [emius]
GO