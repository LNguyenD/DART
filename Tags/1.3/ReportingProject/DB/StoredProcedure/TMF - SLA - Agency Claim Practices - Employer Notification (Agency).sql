/****** Object:  StoredProcedure [dbo].[usp_EmployerNotification_Agency]    Script Date: 02/23/2012 14:48:14 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_EmployerNotification_Agency]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_EmployerNotification_Agency]
GO

/****** Object:  StoredProcedure [dbo].[usp_EmployerNotification_Agency]    Script Date: 02/23/2012 14:48:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE procedure [dbo].[usp_EmployerNotification_Agency]
	@start_date datetime,
	@end_date datetime,
	@IsAll bit,
	@IsRig bit
as
begin
	SET NOCOUNT ON

	select @end_date = DATEADD(dd, 1, @end_date)
	
	select distinct ptda.Agency_id
		
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
	order by agency_id

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_EmployerNotification_Agency]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_EmployerNotification_Agency]  TO [emius]
GO



