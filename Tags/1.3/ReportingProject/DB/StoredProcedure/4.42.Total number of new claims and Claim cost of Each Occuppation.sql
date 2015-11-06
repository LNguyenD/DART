

/****** Object:  StoredProcedure [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostOfEachOccupation]    Script Date: 03/14/2012 13:16:45 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_TotalNumberOfNewClaimsAndClaimCostOfEachOccupation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostOfEachOccupation]
GO


/****** Object:  StoredProcedure [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostOfEachOccupation]    Script Date: 03/14/2012 13:16:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostOfEachOccupation]  '2009','4','2012','1','10125181'
CREATE PROCEDURE [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostOfEachOccupation]
	@From_Quarter_Year char(4),
	@From_Quarter_Quarter char(1),
	@To_Quarter_Year char(4),
	@To_Quarter_Quarter char(1),
	@policies varchar(8000)
AS
BEGIN

	SET NOCOUNT ON;
	CREATE TABLE #POLICY
	(
		value varchar(200)
	)
	
	declare @start_date datetime
	declare @end_date datetime
	set @start_date =   [dbo].[udf_GetFirstDateByQuarter](@From_Quarter_Year,@From_Quarter_Quarter) -- first day of quarter
	set @end_date = dbo.udf_GetLastDateByQuarter(@To_Quarter_Year,@To_Quarter_Quarter)	-- last day of quarter
	
	INSERT INTO #POLICY
	SELECT * from dbo.udf_Split(@policies, ',')

	CREATE TABLE #OCCUPATION
	(
		[QUARTER] varchar(10),
		[YEAR] smallint,
		Occupation_Group varchar(300),
		Occupation_Sub_Group varchar(300),
		startdate datetime,
		enddate datetime
			
	)
	INSERT INTO #OCCUPATION		
	select  [Quarter] = convert(varchar(4), YEAR(CADA.Transaction_Date)) + ' Q' + convert(varchar(4), DATEPART(quarter, CADA.Transaction_Date))
			,[Year] = YEAR(CADA.Transaction_Date)
			,Occupation_Group =dbo.[udf_GetOccupationGroupDesc](CD.Occupation_Code)
			,Occupation_Sub_Group = dbo.[udf_GetOccupationSubGroupDesc](CD.Occupation_Code)
			,startdate = [dbo].[udf_GetFirstDateByQuarter](YEAR(CADA.Transaction_Date),DATEPART(quarter, CADA.Transaction_Date))
			,enddate = [dbo].[udf_GetLastDateByQuarter](YEAR(CADA.Transaction_Date),DATEPART(quarter, CADA.Transaction_Date))
	
	from CAD_AUDIT CADA left join CLaim_Detail CD on CADA.CLAIM_No = CD.Claim_number

	where Transaction_Date  between @start_date AND @end_date and CD.Policy_No in (select * from #POLICY)

	select OC.QUARTER,OC.YEAR,OC.Occupation_Group,OC.Occupation_Sub_Group 
			,Number_Of_New_Claim= (
				SELECT  count(CAD.Claim_No)
						FROM CLAIM_ACTIVITY_DETAIL CAD
						JOIN CLAIM_DETAIL CD ON CD.CLAIM_NUMBER = CAD.CLAIM_NO
							  LEFT OUTER JOIN CLAIMS_OFFICERS CL ON CL.Alias = CAD.Claims_Officer
						WHERE CD.IS_NULL = 0 AND							  
							  CAD.DATE_CLAIM_ENTERED BETWEEN startdate AND enddate
							  and CD.Policy_No in (select * from #POLICY) 
							  and left(CD.Occupation_Code,1)=LEFT(Occupation_Group,1)
			)			
			,Total_Number_Of_Open_Claims = (
						select count(distinct CADA.Claim_no)
						from CAD_AUDIT CADA left join CLAIM_DETAIL CD on CADA.Claim_no = CD.Claim_Number
						where CADA.ID = (select MAX(id) from CAD_AUDIT CADA_2 where CADA_2.Claim_no = CADA.Claim_no
						and Transaction_Date  <= enddate)
						and isnull(Claim_Closed_Flag,'N') <> 'Y' 
						and CD.Policy_No in (select * from #POLICY) 
						and left(CD.Occupation_Code,1)=LEFT(Occupation_Group,1)
			)
			,Total_Cost = isnull((select SUM(PR.TRANS_AMOUNT)
							FROM PAYMENT_RECOVERY PR
							left join CLAIM_DETAIL CD on PR.Claim_No = CD.Claim_Number
							WHERE PR.Transaction_Date BETWEEN  startdate AND enddate
							AND CD.policy_no in (select * from #POLICY) 
							and left(CD.Occupation_Code,1)=LEFT(Occupation_Group,1)
							),0)		
			,Total_Age= isnull((
						select SUM(CONVERT(INT, dbo.udf_CalculateAge(CD.Date_of_Birth, GETDATE())))
						from CAD_AUDIT CADA left join CLAIM_DETAIL CD on CADA.Claim_no = CD.Claim_Number
						where CADA.ID = (select MAX(id) from CAD_AUDIT CADA_2 where CADA_2.Claim_no = CADA.Claim_no
						and Transaction_Date  between startdate AND enddate)
						and isnull(Claim_Closed_Flag,'N') <> 'Y' 
						and CD.Policy_No in (select * from #POLICY) 
						and left(CD.Occupation_Code,1)=LEFT(Occupation_Group,1)
			),0)
			,Financial_Year = (case when datepart(quarter, enddate) = 1 or datepart(quarter, enddate) = 2 
									then convert(varchar(4),[YEAR] - 1) + '/' + convert(varchar(4),[YEAR] )
									else convert(varchar(4),[YEAR]) + '/' + convert(varchar(4),[YEAR]  + 1) end)
	from #OCCUPATION OC
	group by [Quarter],[Year],Occupation_Group,Occupation_Sub_Group,startdate,enddate
	order by QUARTER,Occupation_Group
	DROP TABLE #OCCUPATION    
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostOfEachOccupation]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_TotalNumberOfNewClaimsAndClaimCostOfEachOccupation]  TO [emius]
GO

