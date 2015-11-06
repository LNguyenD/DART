
/****** Object:  StoredProcedure [dbo].[usp_PerformanceRepEarlyContactProgress]    Script Date: 01/10/2012 16:29:11 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_PerformanceRepEarlyContactProgress]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_PerformanceRepEarlyContactProgress]
GO


/****** Object:  StoredProcedure [dbo].[usp_PerformanceRepEarlyContactProgress]    Script Date: 01/10/2012 16:29:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- exec usp_PerformanceRepEarlyContactProgress 2009, 2010, 1,1
CREATE PROCEDURE [dbo].[usp_PerformanceRepEarlyContactProgress] 
	@StartDate datetime, 
	@EndDate datetime,
	@IsAll bit,
	@IsRig bit	
As  
begin

	if ISNULL(@StartDate, '') <> ''
	begin
		create table #temp
		(
			_group varchar(30),
			team varchar(30),
			claim_no varchar(30),  
			cia varchar(100),
			date_claim_received datetime,
			date_significant_injury datetime,
 			date_due_to_complete datetime,
			date_contact_completed datetime
		)
		
		declare @start datetime
		declare @end datetime
					
		-- force to day 1 
		select @start = LEFT(CONVERT(VARCHAR(8), @StartDate, 112), 6) + '01'
			
		-- Set @end to @start + 1 month (if @EndDate is null) 
		-- or day 1 of the next month in @EndDate 

		select @end = DATEADD(mm, 1,  
			(CASE WHEN ISNULL(@EndDate, '') = '' THEN @start ELSE  
				 LEFT(CONVERT(VARCHAR(8), @EndDate, 112), 6) + '01' END))

		insert into #temp
		SELECT
			ID_group = dbo.[udf_ExtractGroup](grp),
			team = co.grp,
			claim_no = cda.claim_no,  
			cia = (co.First_Name + ' ' + co.Last_Name),
			date_claim_received = cada.date_claim_received,
			date_significant_injury = cda.Date_Significant,
 			date_due_to_complete =  
				  dbo.[udf_WorkingDaysAddV2](3, cda.Date_Significant),
			date_contact_completed = ( select MAX(d.EFFECT_DATE)
										from DIARY d 
										where d.EVENT_CLASS = 'IMACONFIN' AND 
										d.Ref_No = cda.claim_no)
		FROM Claim_Detail cd, CAD_AUDIT cada, cd_audit cda 
				LEFT OUTER JOIN CLAIMS_OFFICERS co ON  cda.ima = co.Alias
		WHERE 
			cda.claim_no = cada.claim_no 
			AND cd.claim_number = cda.claim_no 
			AND cd.Fund = 2
			AND cada.id = (SELECT MAX(cada2.id) FROM CAD_Audit cada2 
							WHERE cada2.Claim_no = cada.Claim_no 
								AND cada2.Claim_Liability_Indicator NOT IN (6, 12))	 
			AND cda.id = (	SELECT MAX(cda2.id) FROM cd_audit cda2 
							WHERE cda2.Claim_no = cda.Claim_no 
								AND cda2.Create_Date < @end)
			AND (@IsAll = 1 OR ((@IsRig = 0 AND CO.Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND CO.Grp LIKE 'RIG%'))) 
		
		
		delete from #temp
		where not 
			(date_due_to_complete >= @start and date_due_to_complete < @end	
			or 
			date_contact_completed >= @start and date_contact_completed < @end)

		select *, datename(mm,date_contact_completed) + ' Fail', 1 as 'P/F'
		from #temp 
		where date_contact_completed NOT between date_significant_injury and date_due_to_complete
		UNION ALL
		select *, datename(mm,date_contact_completed) + ' Pass', 2 as 'P/F'
		from #temp 
		where date_contact_completed between date_significant_injury and date_due_to_complete
		order by 'P/F', team, cia

		drop table #temp
	end
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_PerformanceRepEarlyContactProgress]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_PerformanceRepEarlyContactProgress]  TO [emius]
GO


