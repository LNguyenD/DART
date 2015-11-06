

/****** Object:  StoredProcedure [dbo].[usp_TOOCSCoding]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_Depuration]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_Depuration]
GO

/****** Object:  StoredProcedure [dbo].[usp_TOOCSCoding]    Script Date: 01/16/2012 08:56:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec usp_Depuration '1/1/2009', '1/1/2012', 1, 0
create procedure [dbo].[usp_Depuration]
	@start_date datetime,
	@end_date datetime,	
	@IsAll bit,
	@IsRIG bit
as
	begin
		set @start_date =convert(datetime, convert(char, @start_date, 106)) 
		set @end_date =convert(datetime, convert(char, @end_date, 106)) + '23:59'		
		
		select  dbo.[udf_ExtractGroup](CL.grp) as [group]
				,CL.grp as team
				,CL.First_Name + ' ' + CL.Last_Name as Claim_Officer
				,CD.claim_number
				,CAD.Claim_Closed_Flag
				,CAD.Date_Claim_Closed
				,CD.Date_of_Injury
				,CD.Date_of_Birth,CAD.Date_Claim_Entered
				,ISNULL(cd.given_names,'') +' '+ ISNULL(cd.last_names,'') as worker_name
				,CD.Street_Address as worker_address
				,CD.Injury_comment as Injury_Description
				,CD.Injury_Comment_How
				,CD.Location_of_Injury
				,CD.Nature_of_Injury
				,CD.Mechanism_of_Injury
				,CD.Agency_of_Accident
				,CD.Agency_of_Injury
				,CD.Result_of_Injury_code
				,CD.Occupation_Code
				,CD.ANZSIC
				,CD.Tariff_No
				,CAD.Claim_Liability_Indicator
				,CD.Date_Deceased
				,CD.Duty_Status_Code
				,PTD.legal_name as employer_name
				,CAD.Date_Claim_Lodged as Date_Claim_Made
				,CD.Shared_Claim_Code
				,CD.Accident_Location_Code
				,Accident_Location_Desc = dbo.[udf_GetAccidentLocationDesc](CD.Accident_Location_Code)
				,(case CD.Nature_of_Injury when 835 then 1 else 0 end) as Aids
				,(case CD.Result_of_Injury_code when 1 then 1 else 0 end) as Death_Fatality
				,(case CD.Nature_of_Injury when 910 then 1 else 0 end) as Stress
				,(case CD.Result_of_Injury_code when 2 then 1 else 0 end) as Result_of_Injury_Code_2		
		from CLAIM_DETAIL CD  (NOLOCK) 
			INNER JOIN  CLAIM_ACTIVITY_DETAIL  CAD  (NOLOCK) ON CAD.CLAIM_NO =CD.CLAIM_NUMBER
			LEFT OUTER JOIN CLAIMS_OFFICERS CL (NOLOCK) ON CL.Alias = CAD.Claims_Officer					
			LEFT OUTER JOIN policy_term_detail PTD  (NOLOCK) on CD.policy_no = PTD.policy_no
		where Date_Claim_Entered between @start_date and @end_date and CAD.Claim_Liability_Indicator <> 6
			and (Nature_of_Injury in (910,835) or Result_of_Injury_code in (1,2)) 	
			AND (@IsAll = 1 OR ((@IsRIG = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND Grp LIKE 'RIG%'))) 
		order by [group],Claim_Officer				
	end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_Depuration]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_Depuration]  TO [emius]
GO


