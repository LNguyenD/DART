/****** Object:  StoredProcedure [dbo].[usp_HEMUpdateEstimateAtScheduledReviewPoints]    Script Date: 04/04/2012 16:45:36 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_HEMUpdateEstimateAtScheduledReviewPoints]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_HEMUpdateEstimateAtScheduledReviewPoints]
GO

/****** Object:  StoredProcedure [dbo].[usp_HEMUpdateEstimateAtScheduledReviewPoints]    Script Date: 04/04/2012 16:45:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--exec [usp_HEMUpdateEstimateAtScheduledReviewPoints] 2011, 10, 12
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_HEMUpdateEstimateAtScheduledReviewPoints]
	@Year char(4),
	@Month	varchar(2),
	@Weeks_Review_Point smallint
AS
BEGIN
	SET NOCOUNT ON;
	
	CREATE TABLE #TEMP
	(
		Reporting_Month datetime,
		Claim_Number varchar(30),   
		Claims_Officer varchar(60),   
		Team varchar(15),
		Date_Significant_Injury datetime,
		From_Date datetime,
		To_Date datetime,
		Date_Estimate_Updated datetime
	)
	
	declare @start datetime, @end datetime
	select @start = @Month + '/01/' + @Year
	select @end = DATEADD(MONTH, 1, @start)
	
	DECLARE @ExcludeDateClaimClose varchar(50)
	SET @ExcludeDateClaimClose = (SELECT [CONTROL].VALUE FROM [CONTROL] WHERE TYPE='constants' and ITEM = 'DateClaimClosed')
		
	INSERT INTO #TEMP
	SELECT 
		Reporting_Month = @start,
		Claim_Number = CD.Claim_number,   
		Claims_Officer = CO.First_Name + ' ' + CO.Last_Name,   
		Team = CO.grp,
		Date_Significant_Injury = CD.Date_Significant,
		From_Date = DATEADD(dd, 0, DATEDIFF(dd, 0, DATEADD(WEEK, @Weeks_Review_Point - 2, CD.Date_Significant))),
		To_Date = DATEADD(dd, 0, DATEDIFF(dd, 0, DATEADD(WEEK, @Weeks_Review_Point + 2, CD.Date_Significant))),
		Date_Estimate_Updated = ( select DATEADD(dd, 0, DATEDIFF(dd, 0, MIN(ESTIMATE_DETAILS.Transaction_date))) 
									from ESTIMATE_DETAILS 
									WHERE CD.Claim_number = ESTIMATE_DETAILS.Claim_No
										AND ESTIMATE_DETAILS.AMOUNT <> 0
										AND ESTIMATE_DETAILS.Transaction_date >= DATEADD(WEEK, @Weeks_Review_Point - 2, CD.Date_Significant))
	FROM CLAIM_DETAIL CD JOIN CLAIM_ACTIVITY_DETAIL CAD ON CAD.Claim_no = CD.CLAIM_NUMBER
			LEFT JOIN CLAIMS_OFFICERS CO ON CO.ALIAS = CAD.Claims_Officer
	WHERE
		-- EXCLUDE null claim
		CD.Is_null <> 1
		-- EXCLUDE Claims which are closed before October 2010
		AND (IsNull(CAD.Date_Claim_Closed, 0) = 0 or (CAD.Date_Claim_Closed >= CONVERT(Datetime, @ExcludeDateClaimClose )))
		-- Date Significant Injury in specified month					
		AND MONTH(DATEADD(WEEK, @Weeks_Review_Point + 2, CD.Date_Significant)) =  @Month
		AND YEAR(DATEADD(WEEK, @Weeks_Review_Point + 2 , CD.Date_Significant)) =  @Year 	
	SELECT *,
		Pass_Count = case when Date_Estimate_Updated between From_Date and To_Date then 1 else 0 end,
		Fail_Count = case when Date_Estimate_Updated is null OR Date_Estimate_Updated not between From_Date and To_Date then 1 else 0 end,
		Total_Number_Of_Claim = 1
	FROM #TEMP
	ORDER BY CLAIM_NUMBER
	
	DROP TABLE #TEMP
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_HEMUpdateEstimateAtScheduledReviewPoints]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_HEMUpdateEstimateAtScheduledReviewPoints]  TO [emius]
GO


