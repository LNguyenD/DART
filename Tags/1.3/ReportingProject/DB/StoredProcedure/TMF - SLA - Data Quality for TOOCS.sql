
/****** Object:  StoredProcedure [dbo].[usp_TOOCSDataQuality]    Script Date: 01/30/2012 11:54:16 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_TOOCSDataQuality]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_TOOCSDataQuality]
GO


/****** Object:  StoredProcedure [dbo].[usp_TOOCSDataQuality]    Script Date: 01/30/2012 11:54:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_TOOCSDataQuality]
	@ReportDate datetime,
	@IsAll bit,
	@IsRig bit
as
begin
		
	declare	@StartDate datetime
			,@EndDate datetime

	-- Subtract one year then add one day 
	select @StartDate = DATEADD(dd, 1, DATEADD(yy, -1, @ReportDate))
	-- Subtract two months and add one day
	select @EndDate = DATEADD(dd, 1, DATEADD(mm, -2, @ReportDate))

	select
		[Group] = dbo.[udf_ExtractGroup](grp),  
		Team = co.grp,
		CIA = (co.First_Name + ' ' + co.Last_Name),
		ClaimNumber = cda.claim_no,
		AgencyID = ptda.Agency_id,
		PolicyNumber = cda.Policy_No,
		DateClaimEntered = cada.Date_Claim_Entered,
		LocationOfInjury = CASE WHEN cda.Location_of_Injury = 900 THEN '900' ELSE 'N/A' END,
		NatureOfInjury = CASE WHEN cda.Nature_of_Injury IN (190, 930) THEN CONVERT(VARCHAR, cda.Nature_of_Injury) ELSE 'N/A' END,
		MechanismOfInjury = CASE WHEN cda.Mechanism_of_Injury = 99 THEN '99' ELSE 'N/A' END,
		BreakdownAgency = CASE WHEN cda.Agency_of_accident = 999 THEN '999' ELSE 'N/A' END,
		InjuryAgency = CASE WHEN cd.Agency_of_Injury = 999 THEN '999' ELSE 'N/A' END

	from  cd_audit cda, CLAIM_DETAIL cd, PTD_AUDIT ptda, 
			CAD_AUDIT cada LEFT OUTER JOIN CLAIMS_OFFICERS co ON  cada.Claims_Officer = co.Alias
	where
		cda.claim_no = cd.Claim_Number
		AND cada.Claim_no = cd.Claim_Number
		AND cda.Policy_No = ptda.Policy_no 
		AND cd.policy_no = ptda.Policy_no
		AND cd.Fund = 2
		AND cada.id = (	SELECT MAX(cada2.id) FROM CAD_Audit cada2 
						WHERE cada2.Claim_no = cada.Claim_no 
							AND ISNULL(cada2.Claim_Closed_Flag, 'N') = 'N'
							AND cada2.Claim_Liability_Indicator <> 6 				
							AND cada2.Date_Claim_Entered >= @StartDate
							AND cada2.Date_Claim_Entered < @EndDate)
		AND ptda.id = (	SELECT MAX(ptda2.id) FROM PTD_AUDIT ptda2 
						WHERE  ptda2.policy_no = ptda.policy_no 
							AND ptda2.Create_Date < @EndDate)
		AND cda.id = (	SELECT MAX(cda2.id) FROM cd_audit cda2 
						WHERE cda2.Claim_no = cda.Claim_no 
							AND cda2.Create_Date < @EndDate)
		AND (@IsAll = 1 OR ((@IsRig = 0 AND CO.Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND CO.Grp LIKE 'RIG%'))) 	
	order by [Group], Team, CIA
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_TOOCSDataQuality]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_TOOCSDataQuality]  TO [emius]
GO


