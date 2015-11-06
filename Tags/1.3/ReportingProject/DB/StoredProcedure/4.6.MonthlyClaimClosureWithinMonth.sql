

/****** Object:  StoredProcedure [dbo].[usp_MonthlyClaimClosureWithinMonth]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_MonthlyClaimClosureWithinMonth]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_MonthlyClaimClosureWithinMonth]
GO

/****** Object:  StoredProcedure [dbo].[usp_MonthlyClaimClosureWithinMonth]    Script Date: 01/16/2012 08:56:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--execute [usp_MonthlyClaimClosureWithinMonth] '2011','12',1,0
create procedure [dbo].[usp_MonthlyClaimClosureWithinMonth]
	@reporting_year int,
	@reporting_month smallint,	
	@IsAll bit,
	@IsRig bit
as
	begin		
		declare @start_date datetime
		declare @end_date datetime
		
		set @start_date = DATEADD(month,@reporting_month-1,DATEADD(year,@reporting_year-1900,0))		
		set @end_date = DATEADD(day,-1,DATEADD(month,@reporting_month,DATEADD(year,@reporting_year-1900,0))) + '23:59'
		
		Create table #TEMP
		(
			Reporting_Month varchar(7),
			[Group] varchar(50),
			Team varchar(50),
			Claim_Officer varchar(100),
			Claim_no varchar(25),
			Worker_Name varchar(200),
			Date_Claim_Closed datetime,
			OPC char(1)
		)
		
		insert into #TEMP		
		select  Reporting_Month=convert(varchar,@reporting_year) + ' ' + case when @reporting_month <=9 then ('0' + convert(varchar,@reporting_month)) else convert(varchar,@reporting_month) end
				,dbo.[udf_ExtractGroup](CL.grp) as [Group]
				,CL.grp as Team				
				,CL.First_Name + ' ' + CL.Last_Name as Claim_Officer
				,CADA.Claim_no
				,Worker_Name = ISNULL(CD.given_names,'') +' '+ ISNULL(CD.last_names,'')
				,CADA.Date_Claim_Closed				
				,OPC =(Case when 
				(exists(select top 1 CADA_2.Claim_no from CAD_AUDIT CADA_2 where CADA_2.Claim_no = CADA.Claim_no and Date_Claim_Closed< CADA.Date_Claim_Closed and isnull(CADA_2.Date_Claim_Closed,'')<>'' and isnull(CADA_2.Date_Claim_reopened,'')<>'' 
				))
				and (exists(select top 1 Paid_Date from Claim_Payment_run CPR 
					where CPR.Claim_Number= CADA.Claim_no and Paid_Date<CADA.Date_Claim_Closed )) then 'Y' else 'N' end)
				
		FROM CAD_AUDIT CADA JOIN CLAIM_DETAIL CD ON CD.CLAIM_NUMBER = CADA.CLAIM_NO
			 LEFT OUTER JOIN CLAIMS_OFFICERS CL (NOLOCK) ON CL.Alias = CADA.Claims_Officer			
		WHERE CADA.ID = (SELECT MAX(ID) FROM CAD_AUDIT CADA1
							WHERE CADA1.CLAIM_NO = CADA.CLAIM_NO
								AND CADA1.Transaction_Date BETWEEN @Start_Date AND @End_Date)	
			
			AND CADA.Date_Claim_Closed BETWEEN @Start_Date AND @End_Date			
			AND (@IsAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%')))			
		order by Team,Claim_Officer,Claim_no	
		
		select * 
				,Date_Claim_Closed_prev = (Case OPC when 'N' then NULL else 
				(select top 1 Date_Claim_Closed from CAD_AUDIT CADA_1 
					where  CADA_1.Claim_no=#TEMP.Claim_no and
					Date_Claim_Closed< #TEMP.Date_Claim_Closed and
					isnull(CADA_1.Date_Claim_Closed,'')<>'' and isnull(CADA_1.Date_Claim_reopened,'')<>'' order by Date_Claim_Closed desc) 
				end)
				,Date_Claim_Reopened_prev = (Case OPC when 'N' then NULL else 
				(	select top 1 Date_Claim_reopened from CAD_AUDIT CADA_2 
					where Date_Claim_Closed< #TEMP.Date_Claim_Closed  and CADA_2.Claim_No= #TEMP.Claim_no 
					and isnull(CADA_2.Date_Claim_Closed,'')<>'' and isnull(CADA_2.Date_Claim_reopened,'')<>'' order by Date_Claim_reopened desc) 
				end)
				,Paid_Date_prev = (Case OPC when 'N' then NULL else 
				(select top 1 Paid_Date from  Claim_Payment_run CPR 
						where CPR.Claim_number= #TEMP.Claim_no 
						and Paid_Date<#TEMP.Date_Claim_Closed order by Paid_Date desc)
				end)
		from #TEMP
		order by Team,Claim_Officer,Claim_no		
		DROP TABLE #TEMP
	end
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_MonthlyClaimClosureWithinMonth]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_MonthlyClaimClosureWithinMonth]  TO [emius]
GO



