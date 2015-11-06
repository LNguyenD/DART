IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_HEMClaimInjuryManagementReviewTemplate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_HEMClaimInjuryManagementReviewTemplate]
GO


/****** Object:  StoredProcedure [dbo].[usp_HEMClaimInjuryManagementReviewTemplate]    Script Date: 01/18/2012 13:56:42 ******/
CREATE ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC usp_HEMClaimInjuryManagementReviewTemplate 1
ALTER procedure [dbo].[usp_HEMClaimInjuryManagementReviewTemplate]
	@review_week_required int
as
	begin		
		Declare @ExcludeDateClaimClose varchar(50)
		SET @ExcludeDateClaimClose = (Select [CONTROL].VALUE FROM [CONTROL] WHERE TYPE='constants' and ITEM = 'DateClaimClosed')
		
		select  dbo.[udf_ExtractGroup](CL.grp) as [group]
				,CL.grp as team
				,CL.First_Name + ' ' + CL.Last_Name as claim_officer
				,CD.claim_number
				,ISNULL(CD.given_names,'') +' '+ ISNULL(CD.last_names,'') as worker_name
				,PTD.legal_name as employer_name
				,CD.Date_of_Birth
				,CAD.claim_liability_indicator as liability_status
				,CD.Date_Significant
				,CD.Date_of_Injury
		
		from CLAIM_DETAIL cd  (NOLOCK) 
		INNER JOIN  CLAIM_ACTIVITY_DETAIL  CAD  (NOLOCK) ON CAD.CLAIM_NO =CD.CLAIM_NUMBER
		LEFT OUTER JOIN CLAIMS_OFFICERS CL ON CL.Alias = CAD.Claims_Officer
		LEFT OUTER JOIN policy_term_detail PTD  (NOLOCK) on CD.policy_no = PTD.policy_no			
		
		where DATEDIFF(day,CD.Date_Significant ,GETDATE())/7 = @review_week_required -1 and CD.is_Rehab =1
		and isnull(CAD.Claim_Closed_Flag,'N') <> 'Y' 
		and isnull(CAD.Date_Claim_Closed,getdate()) >= CONVERT(Datetime,ISNULL(@ExcludeDateClaimClose,GETDATE()))					
	end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_HEMClaimInjuryManagementReviewTemplate]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_HEMClaimInjuryManagementReviewTemplate]  TO [emius]
GO

