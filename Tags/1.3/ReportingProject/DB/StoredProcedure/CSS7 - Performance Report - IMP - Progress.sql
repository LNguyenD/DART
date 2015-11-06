/****** Object:  StoredProcedure [dbo].[usp_IMPProgress]    Script Date: 01/10/2012 16:33:53 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_IMPProgress]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_IMPProgress]
GO

/****** Object:  StoredProcedure [dbo].[usp_IMPProgress]    Script Date: 01/10/2012 16:33:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- exec usp_IMPProgress 2009, 1, 2010, 1, 1, 0
CREATE proc [dbo].[usp_IMPProgress]
	@From_Year char(4),
	@From_Month	varchar(2),
	@To_Year char(4),
	@To_Month	varchar(2),
	@IsAll bit,
	@IsRig bit
as
begin

	declare @start datetime, @end datetime
	select @start = @From_Month + '/01/' + @From_Year
	select @end = DATEADD(MONTH, 1, @To_Month + '/01/' + @To_Year)
		
	create table #temp
	(
		[Group] varchar(30),
		Team varchar(30),
		CIA varchar(100),
		ClaimNumber varchar(30),
		DateClaimReceived datetime,
		DateSignificantInjury datetime,
		DateDueToComplete datetime,
		DateIMPDeveloped datetime
	)
	
	insert into #temp
	select 
		[Group] = dbo.[udf_ExtractGroup](grp),
		Team = co.grp,
		(co.First_Name + ' ' + co.Last_Name) as CIA,
		ClaimNumber = cda.claim_no,
		DateClaimReceived = cada.date_claim_received,
		DateSignificantInjury = cda.Date_Significant,
		DateDueToComplete = dbo.[udf_WorkingDaysAddV2](15, cda.Date_Significant),
		DateIMPDeveloped = (select IMP1.Developed
							from IMP imp1
							where imp1.Claim_No = cda.claim_no          
								  AND imp1.Plan_No = (select MIN(imp2.Plan_No) 
													from IMP imp2
													where imp2.Claim_No = imp1.claim_no))
	from CAD_AUDIT cada, Claim_Detail cd,
				cd_audit cda LEFT OUTER JOIN CLAIMS_OFFICERS co ON  cda.ima = co.Alias
	where 
		cada.Claim_no = cda.claim_no 
		AND cd.claim_number = cda.claim_no 
		AND cd.Fund = 2		
		AND cada.id = (SELECT MAX(cada2.id) FROM CAD_Audit cada2 
						WHERE cada2.Claim_no = cada.Claim_no 
							-- It will exclude claims with: Liability status 6 &12
							AND cada2.Claim_Liability_Indicator NOT IN (6, 12))	
		AND cda.id = (SELECT MAX(cda2.id) FROM cd_audit cda2 
					  WHERE cda2.Claim_no = cda.Claim_no 
						-- If a claim is marked ‘Non-Significant’
						AND cda2.Date_Significant IS NOT NULL 
						AND cda2.Create_Date < @end)
		AND (@IsAll = 1 OR ((@IsRig = 0 AND CO.Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND CO.Grp LIKE 'RIG%'))) 
					
	delete from #temp
	where not	(	(DateDueToComplete >= @start and DateDueToComplete < @end) 
					or	
					(DateIMPDeveloped >= @start and DateIMPDeveloped < @end)
				)

	select *, datename(mm,DateIMPDeveloped) + ' Fail', 1 as 'P/F'
	from #temp 
	where DateIMPDeveloped not between DateSignificantInjury and  
	   DateDueToComplete
	UNION ALL
	select *, datename(mm,DateIMPDeveloped) + ' Pass', 2 as 'P/F'
	from #temp 
	where DateIMPDeveloped between DateSignificantInjury and 
		  DateDueToComplete
	ORDER BY 'P/F', [Group], Team, CIA

	drop table #temp
end

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_IMPProgress]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_IMPProgress]  TO [emius]
GO

