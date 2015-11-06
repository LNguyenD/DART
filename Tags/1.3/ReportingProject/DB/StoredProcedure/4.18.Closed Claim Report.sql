IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_ClosedClaimsReport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_ClosedClaimsReport]
GO


/****** Object:  StoredProcedure [dbo].[usp_ClosedClaimsReport]    Script Date: 01/18/2012 13:56:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--execute [usp_ClosedClaimsReport] '12/01/2011','02/3/2012 23:59',1,0
Create procedure [dbo].[usp_ClosedClaimsReport]
	@start_date datetime,
	@end_date datetime,	
	@IsAll bit,
	@IsRIG bit
as
	begin
		set @start_date =convert(datetime, convert(char, @start_date, 106)) 
		set @end_date =convert(datetime, convert(char, @end_date, 106)) + '23:59'		
		
		SELECT	  [Group] = dbo.[udf_ExtractGroup](CL.grp)
                  ,Team = CL.grp
                  ,Claim_Officer = CL.First_Name + ' '+ CL.Last_Name
                  ,CAD.Claim_No
                  ,worker_name =ISNULL(CD.given_names,'') +' '+ ISNULL(CD.last_names,'')
                  ,CAD.Date_Claim_Closed
                  ,Re_opened=(CASE WHEN CAD.Date_Claim_reopened BETWEEN DateAdd(m, -2, CAD.Date_Claim_Closed) AND CAD.Date_Claim_Closed THEN 'Yes' ELSE 'No' END)
                  ,CAD.Date_Claim_reopened
				  ,Reopen_Reason_Desc = (CASE WHEN CAD.Date_Claim_reopened IS NULL THEN '' ELSE [dbo].[udf_GetReOpenReasonDesc](CAD.Reopen_Reason) END)
                  
        FROM CLAIM_ACTIVITY_DETAIL CAD
                  JOIN CLAIM_DETAIL CD (NOLOCK) ON CD.Claim_Number = CAD.Claim_no
                  LEFT OUTER JOIN CLAIMS_OFFICERS CL (NOLOCK) ON CL.Alias = CAD.Claims_Officer
                  
        WHERE Date_Claim_Closed BETWEEN @start_date AND @end_date
				  AND (@isAll = 1 OR ((@IsRIG = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND Grp LIKE 'RIG%')))
			
		ORDER BY [Group],[Team],[Claim_Officer],CAD.Claim_No			
	end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_ClosedClaimsReport]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_ClosedClaimsReport]  TO [emius]
GO