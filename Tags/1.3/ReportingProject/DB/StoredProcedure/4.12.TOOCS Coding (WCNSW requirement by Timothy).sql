

/****** Object:  StoredProcedure [dbo].[usp_TOOCSCoding]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_TOOCSCoding]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_TOOCSCoding]
GO

/****** Object:  StoredProcedure [dbo].[usp_TOOCSCoding]    Script Date: 01/16/2012 08:56:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec usp_TOOCSCoding '1/1/2009', '1/1/2012', 1, 0
create procedure [dbo].[usp_TOOCSCoding]
	@start_date datetime,
	@end_date datetime,	
	@IsAll bit,
	@IsRig bit
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
				,CD.Date_of_Birth
				,CAD.Date_Claim_Entered
				,Injury_Description = CD.Injury_comment
				,CD.Injury_Comment_How
				,CD.Location_of_Injury
				,LD.[Description] as Location_of_Injury_Desc
				,CD.Nature_of_Injury
				,Nature_of_Injury_Desc =IJ.Description
				,CD.Mechanism_of_Injury
				,MD.[Description] as Mechanism_of_Injury_Desc
				,CD.Agency_of_Accident
				,(select top 1 [Description] from AGENCY_DESC where Code=CD.Agency_of_Accident and [version]=CD.TOOCS_Version) as Agency_of_Accident_Desc
				,CD.Agency_of_Injury
				,(select top 1 [Description] from AGENCY_DESC where Code=CD.Agency_of_Injury and [version]=CD.TOOCS_Version) as Agency_of_Injury_Desc
				,CD.Accident_Location_Code
				,CD.Accident_Location_Desc
				,CD.Street_Address as worker_address
				,CD.Result_of_Injury_code
				,[dbo].[udf_Get_Result_Of_Injury_Code](CD.Result_of_Injury_code) as Result_Of_Injury_Code_Desc		
		
		from	CLAIM_DETAIL CD  (NOLOCK) 
				INNER JOIN  CLAIM_ACTIVITY_DETAIL  CAD  (NOLOCK) ON CAD.CLAIM_NO =CD.CLAIM_NUMBER
				LEFT OUTER JOIN CLAIMS_OFFICERS CL (NOLOCK) ON CL.Alias = CAD.Claims_Officer				
				LEFT OUTER JOIN LOCATION_DESC LD (NOLOCK) on CD.Location_of_Injury = LD.Code and CD.TOOCS_Version=LD.[version]
				LEFT OUTER JOIN MECHANISM_DESC MD (NOLOCK) on CD.Mechanism_of_Injury = MD.Code and CD.TOOCS_Version=MD.[version]	
				LEFT JOIN INJURY IJ (NOLOCK) ON CD.Nature_ID=IJ.ID
		where Date_Claim_Entered between @start_date and  @end_date and CAD.Claim_Liability_Indicator <> 6
		AND (@isAll = 1 OR ((@IsRig = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRig = 1 AND Grp LIKE 'RIG%')))
		order by [group],Claim_Officer
	end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_TOOCSCoding]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_TOOCSCoding]  TO [emius]
GO



