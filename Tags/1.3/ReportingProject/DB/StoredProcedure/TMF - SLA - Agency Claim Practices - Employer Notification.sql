/****** Object:  StoredProcedure [dbo].[usp_EmployerNotification]    Script Date: 01/30/2012 11:57:23 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_EmployerNotification]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_EmployerNotification]
GO

/****** Object:  StoredProcedure [dbo].[usp_EmployerNotification]    Script Date: 01/30/2012 11:57:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_EmployerNotification]
	@start_date datetime,
	@end_date datetime,
	@IsAll bit,
	@IsRig bit,
	@All_Agencies_in_one bit,
	@Agency varchar(10)
as
begin	
	select @end_date = DATEADD(dd, 1, @end_date)
	select agency_id = ptda.Agency_id,
		[group] = dbo.[udf_ExtractGroup](co.grp),
		Team = co.grp,
		cia = co.First_Name + ' ' + co.Last_Name,
		policy_no = cda.Policy_No,
		claim_no = cda.claim_no,
		date_notice_given = cda.Date_Notice_Given,
		date_notification_received = cada.date_claim_received,
		NumberOfBusinessDays = 
			dbo.udf_NoOfWorkingDaysV2(cda.Date_Notice_Given,  
			   cada.date_claim_received),
		 FirstDay = CASE WHEN  
			dbo.udf_NoOfWorkingDaysV2(cda.Date_Notice_Given,  
			cada.date_claim_received) <= 1 THEN 'Pass' ELSE 'Fail' END,
		 SecondDay = CASE WHEN  
			dbo.udf_NoOfWorkingDaysV2(cda.Date_Notice_Given,  
			   cada.date_claim_received) <= 2 THEN 'Pass' ELSE 'Fail' END
	from POLICY_TERM_DETAIL ptda, cd_audit cda, Claim_Detail cd, 
		CAD_AUDIT cada LEFT OUTER JOIN CLAIMS_OFFICERS co ON  cada.Claims_Officer = co.Alias
	where cda.claim_no = cada.Claim_no 	
	AND cda.Policy_No = ptda.POLICY_NO 
	AND cd.claim_number = cda.claim_no 
	AND cd.Fund = 2
	AND cada.id = (SELECT MAX(cada2.id) FROM CAD_Audit cada2 
			  WHERE cada2.Claim_no = cada.Claim_no 
			AND cada2.Claim_Liability_Indicator <> 6 				    
			AND cada2.date_claim_received >= @start_date
			  AND cada2.date_claim_received < @end_date)
	AND cda.id = (SELECT MAX(cda2.id) FROM cd_audit cda2 
				WHERE cda2.Claim_no = cda.Claim_no 
			AND cda2.Create_Date < @end_date)
	AND (@IsAll = 1 OR ((@IsRig = 0 AND CO.Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND CO.Grp LIKE 'RIG%')))
	AND (
		@All_Agencies_in_one = 0 AND @Agency = PTDA.Agency_id
		OR 
		@All_Agencies_in_one = 1
		)
	order by agency_id, policy_no
	
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_EmployerNotification]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_EmployerNotification]  TO [emius]
GO

