
/****** Object:  StoredProcedure [dbo].[usp_MonthlyAverageGrossPaidforPaymentGroup]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_MonthlyAverageGrossPaidforPaymentGroup]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_MonthlyAverageGrossPaidforPaymentGroup]
GO

/****** Object:  StoredProcedure [dbo].[usp_MonthlyAverageGrossPaidforPaymentGroup]    Script Date: 01/16/2012 08:56:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- execute [usp_MonthlyAverageGrossPaidforPaymentGroup] 2009 ,2,1,0
-- execute [usp_MonthlyAverageGrossPaidforPaymentGroup] 2011 ,12,true,false
create procedure [dbo].[usp_MonthlyAverageGrossPaidforPaymentGroup]
	@reporting_year smallint,
	@reporting_month smallint,	
	@IsAll bit,
	@IsRIG bit
as
	begin
		
			
		Create Table #PAYMENT
		(
			[Year] int,
			[Month] tinyint,			
			Payment_Group varchar(50),
			Claim_no varchar(30),
			payment_no bigint,
			payment_type varchar(10),
			transaction_date datetime,
			gross money
		)	
		
		insert into #PAYMENT		
		Select  [YEAR] = YEAR(PR.Transaction_date)
			,[MONTH] = MONTH(PR.Transaction_date)
			,Payment_Group =dbo.[udf_ExtractPaymentGroup](PR.Payment_Type,'')
			,PR.claim_no, payment_no, payment_type,PR.transaction_date, gross
		from payment_recovery PR Left join CLAIM_ACTIVITY_DETAIL CAD on PR.Claim_No=CAD.Claim_no
			LEFT JOIN CLAIMS_OFFICERS CO ON CO.ALIAS = CAD.Claims_Officer
		where  
				(     
				     LEFT(Payment_Type,3) IN('WPT','WPP')
				     OR PR.Estimate_type IN ('51','55','57')
				     OR left(PR.PAYMENT_TYPE,3) IN ('WPT','WPP','WRK','DOA','IN0','IN1','IN5','IN7','IN8')
				     OR PR.PAYMENT_TYPE IN ('PCA001','TRA002','COM001','INS6000','IIN101','IIN104','IIN105','IIN102','IIN103')
				     or left(Payment_Type,2) in('WK','OR')
				     or left(Payment_Type,4) ='INS7'
				)
			AND (@IsAll = 1 OR ((@IsRIG = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND Grp LIKE 'RIG%'))) 
			AND year(PR.Transaction_date)=@reporting_year  AND month(PR.Transaction_date)=@reporting_month

insert into #PAYMENT
		Select  [YEAR] = YEAR(PR.Transaction_date)
			,[MONTH] = MONTH(PR.Transaction_date)
			,Payment_Group =dbo.[udf_ExtractPaymentGroup]('',PR.Estimate_type)
			,PR.claim_no, payment_no, payment_type,PR.transaction_date, gross
		from payment_recovery PR Left join CLAIM_ACTIVITY_DETAIL CAD on PR.Claim_No=CAD.Claim_no
			LEFT JOIN CLAIMS_OFFICERS CO ON CO.ALIAS = CAD.Claims_Officer
		where  
				(     
				     LEFT(Payment_Type,3) IN('WPT','WPP')
				     OR PR.Estimate_type IN ('51','55','57')
				     OR left(PR.PAYMENT_TYPE,3) IN ('WPT','WPP','WRK','DOA','IN0','IN1','IN5','IN7','IN8')
				     OR PR.PAYMENT_TYPE IN ('PCA001','TRA002','COM001','INS6000','IIN101','IIN104','IIN105','IIN102','IIN103')
				     or left(Payment_Type,2) in('WK','OR')
				     or left(Payment_Type,4) ='INS7'
				)
			AND (@IsAll = 1 OR ((@IsRIG = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND Grp LIKE 'RIG%'))) 
			AND year(PR.Transaction_date)=@reporting_year  AND month(PR.Transaction_date)=@reporting_month
			
			
 select 	[Year] =[YEAR]
				,[Month] =[MONTH]
				,Payment_Group = P.Payment_Group
				,Gross = SUM(Gross)
				,Total_Number_Of_Claims_With_Payment =COUNT(distinct Claim_no)
				,Total_Number_Of_Open_Claim =(
					select count(distinct P1.Claim_no)
					from #PAYMENT P1 
					where P1.Payment_Group = P.Payment_Group  
					and P1.Claim_no in (
							Select claim_no from CAD_AUDIT ca 
							where ca.ID = (select MAX(id) from CAD_AUDIT ca2
								where ca.Claim_no = ca2.Claim_no	
                                   and ca2.transaction_date <= DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,(convert(varchar,@reporting_month) +'/' +convert(varchar,@reporting_year)+'/1')))+1,0)
                                   )                                   )
							and isnull(ca.Claim_Closed_Flag,'N' ) <> 'Y'
					)   
				)									
		from #PAYMENT P
		where Payment_Group <> 'UNKNOWN'
		group by [Year],[Month],P.Payment_Group
		order by P.Payment_Group
		
		DROP TABLE #PAYMENT					
	end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_MonthlyAverageGrossPaidforPaymentGroup]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_MonthlyAverageGrossPaidforPaymentGroup]  TO [emius]
GO



