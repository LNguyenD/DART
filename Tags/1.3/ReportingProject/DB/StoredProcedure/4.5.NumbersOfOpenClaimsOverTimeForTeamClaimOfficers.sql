/****** Object:  StoredProcedure [dbo].[usp_NumbersOfOpenClaimsOverTimeForTeamClaimOfficers]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_NumbersOfOpenClaimsOverTimeForTeamClaimOfficers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_NumbersOfOpenClaimsOverTimeForTeamClaimOfficers]
GO

/****** Object:  StoredProcedure [dbo].[usp_NumbersOfOpenClaimsOverTimeForTeamClaimOfficers]    Script Date: 01/16/2012 08:56:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--execute [usp_NumbersOfOpenClaimsOverTimeForTeamClaimOfficers] '2011','11','2011','12',1,0
create procedure [dbo].[usp_NumbersOfOpenClaimsOverTimeForTeamClaimOfficers]
	@reporting_from_year int,
	@reporting_from_month smallint,	
	@reporting_to_year int,
	@reporting_to_month smallint,	
	@IsAll bit,
	@IsRig bit
as
	begin		
		declare @start_date datetime
		declare @end_date datetime
		
		set @start_date = DATEADD(month,@reporting_from_month-1,DATEADD(year,@reporting_from_year-1900,0))		
		set @end_date = DATEADD(day,-1,DATEADD(month,@reporting_to_month,DATEADD(year,@reporting_to_year-1900,0))) + '23:59'
		
		Create table #TEMP
		(
			Team varchar(50),
			Team_Officer varchar(200),
			Claim_Officer varchar(200),
			Alias varchar(200),			
			[Month] smallint,
			[Year] int
		)
		insert into #TEMP   		
		select  CL.grp as Team
				,Team_Officer = CL.grp + '/' + CL.First_Name + ' ' + CL.Last_Name
				,CL.First_Name + ' ' + CL.Last_Name as Claim_Officer
				,CL.Alias	
				,[Month]=Month(CADA.Transaction_Date)
				,[Year]=Year(CADA.Transaction_Date)
		FROM CAD_AUDIT CADA JOIN CLAIM_DETAIL CD ON CD.CLAIM_NUMBER = CADA.CLAIM_NO
			 LEFT OUTER JOIN CLAIMS_OFFICERS CL (NOLOCK) ON CL.Alias = CADA.Claims_Officer
		
		WHERE CADA.ID = (SELECT MAX(ID) FROM CAD_AUDIT CADA1
							WHERE CADA1.CLAIM_NO = CADA.CLAIM_NO
								AND CADA1.Transaction_Date BETWEEN @Start_Date AND @End_Date)
			AND ISNULL(CADA.CLAIM_CLOSED_FLAG, 'N') <> 'Y'
			AND CADA.Transaction_Date BETWEEN @Start_Date AND @End_Date			
			AND (@IsAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%')))		
		group by CL.grp,Alias,CL.First_Name, CL.Last_Name ,Year(CADA.Transaction_Date),Month(CADA.Transaction_Date)
		
		select * , Year_Month =dbo.udf_GetPrefixHeadingCombinMonthYear('Number of Open Claims',[Month],[Year])
				, Total_Open_Claim=isnull((Select COUNT(claim_no)
									from CAD_AUDIT ca 
									where  (ca.ID = (select MAX(id) from CAD_AUDIT ca2
									  where ca.Claim_no = ca2.Claim_no 
											and ca2.transaction_date <= DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,(convert(varchar,[Month]) +'/' +convert(varchar,[Year])+'/1')))+1,0)))
											and isnull(ca.Claim_Closed_Flag,'N') <> 'Y' 
											and ca.Claims_Officer = TMP.Alias
										)
									 )   ,0)
		from #TEMP	TMP		
		order by [Year],[Month],Team,Claim_Officer	
		drop table #TEMP
	end
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_NumbersOfOpenClaimsOverTimeForTeamClaimOfficers]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_NumbersOfOpenClaimsOverTimeForTeamClaimOfficers]  TO [emius]
GO



