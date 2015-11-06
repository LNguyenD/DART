
/****** Object:  StoredProcedure [dbo].[usp_SLADeterminingLiabilityComunication]    Script Date: 01/10/2012 16:39:43 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_SLADeterminingLiabilityComunication]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_SLADeterminingLiabilityComunication]
GO

/****** Object:  StoredProcedure [dbo].[usp_SLADeterminingLiabilityComunication]    Script Date: 01/10/2012 16:39:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_SLADeterminingLiabilityComunication]
@StartDate	datetime,
@EndDate	datetime
as
begin
create table #temp
(
	AgencyID varchar(30),
	[Group] varchar(30),
	Team varchar(30),
	CIA varchar(100),
	ClaimNumber varchar(30),
	PolicyNumber varchar(30),
	DateRecurrenceReceived datetime,
	DateRecurrenceDulyMade datetime,
	DateRecurrenceLiabilityDecisionDue datetime,
	DateOfDecision datetime
)
declare @end_date datetime
select @end_date = DATEADD(dd, 1, @end_date)

insert into #temp
select
	AgencyID = pdta.Agency_ID,
	[Group] = CASE WHEN LEFT(grp, 3) IN ('RIG','TMF') THEN substring(grp, 1, 4) ELSE LEFT(grp,1) END,
	Team = coa.grp,
	(coa.First_Name + ' ' + coa.Last_Name) as CIA,
	ClaimNumber = cda.claim_no,
	PolicyNumber = cd.Policy_No,
	DateRecurrenceReceived = '', -- NOT FOUND
	DateRecurrenceDulyMade = '', -- NOT FOUND
	DateRecurrenceLiabilityDecisionDue = DATEADD(day, 21, GETDATE()), -- dummy DateRecurrenceDulyMade = GETDATE()
	DateOfDecision = '' -- NOT FOUND

from cd_audit cda, CLAIM_DETAIL cd, PTD_AUDIT pdta,
CAD_AUDIT cada LEFT OUTER JOIN CO_Audit coa ON 
         (cada.Claims_Officer = coa.Alias 
           and coa.id = (select max(coa2.id) from CO_Audit coa2 
		where coa2.alias = coa.Alias 
		and coa2.create_date < @EndDate))
where 
cd.is_Null <> 1
AND cd.Fund = 2
AND cda.claim_no = cd.Claim_Number
AND cada.Claim_no = cd.Claim_Number
AND cda.Policy_No = pdta.Policy_no 
AND cd.policy_no = pdta.Policy_no
AND cada.id = (SELECT MAX(cada2.id) FROM CAD_Audit cada2        
           WHERE cada2.Claim_no = cada.Claim_no 			  	     AND cada2.Claim_Liability_Indicator <> 12)
AND pdta.id = (SELECT MAX(ptda2.id) FROM PTD_AUDIT ptda2 
     WHERE ptda2.policy_no = pdta.policy_no 
     AND ptda2.Create_Date < @EndDate) 
AND cda.id = (SELECT MAX(cda2.id) FROM cd_audit cda2 
          WHERE cda2.Claim_no = cda.Claim_no 
    AND cda2.Nature_of_Injury <> 250				         
    AND cda2.Create_Date < @EndDate)

delete from #temp
where not (DateOfDecision >= @StartDate and DateOfDecision < @EndDate or
DateRecurrenceLiabilityDecisionDue >= @StartDate and DateRecurrenceLiabilityDecisionDue < @EndDate)

select *, datename(MM, DateOfDecision) + ' Fail', 1 as 'P/F'
from #temp
where DateOfDecision > DateRecurrenceLiabilityDecisionDue
UNION ALL
select *, datename(MM, DateOfDecision) + ' Pass', 2 as 'P/F'
from #temp
where DateOfDecision <= DateRecurrenceLiabilityDecisionDue
ORDER BY [Group], Team, CIA

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_SLADeterminingLiabilityComunication]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_SLADeterminingLiabilityComunication]  TO [emius]
GO