IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_RehabReferral]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_RehabReferral]
GO


/****** Object:  StoredProcedure [dbo].[usp_RehabReferral]    Script Date: 01/18/2012 13:56:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--execute [usp_RehabReferral] '10/01/2011','10/31/2011 23:59',1,0
Create procedure [dbo].[usp_RehabReferral]
	@start_date datetime,
	@end_date datetime,	
	@IsAll bit,
	@IsRIG bit
as
	begin
		set @start_date =convert(datetime, convert(char, @start_date, 106)) 
		set @end_date =convert(datetime, convert(char, @end_date, 106)) + '23:59'		
		SELECT [Group] = dbo.[udf_ExtractGroup](CL.grp)
                        ,Team = CL.grp
                        ,Claim_Officer = CL.First_Name + ' ' + CL.Last_Name
                        ,RD.Claim_no           
                        ,Date_Referred
                        ,Creditor_Number = CR.Creditor_No 
                        ,Creditor_Name = CR.Name 
                        ,Service_Description = SR.Description
 
      FROM rehabilitation_detail RD
                  JOIN creditors CR ON CR.Creditor_No = RD.Provider_Code
                  JOIN service SR ON SR.ID = RD.Service_Code
                 LEFT OUTER JOIN claim_activity_detail CAD (NOLOCK) ON RD.claim_no = CAD.claim_no
                 LEFT OUTER JOIN claims_officers CL (NOLOCK) ON CL.Alias = CAD.Claims_Officer 
 
            WHERE rd.cancelled_by IS NULL
                  AND rd.date_referred BETWEEN  @start_date 
                  AND @end_date 
                  AND rd.type = '2'                                
                  AND (@IsAll = 1 OR ((@IsRIG = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND Grp LIKE 'RIG%')))           
                 ORDER BY [Group],Team,Claim_Officer,Creditor_Name,Creditor_Number,RD.claim_no,Date_Referred      
                  
	end
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_RehabReferral]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_RehabReferral]  TO [emius]
GO