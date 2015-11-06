

/****** Object:  StoredProcedure [dbo].[usp_EstimateTypes_TotalPaid_Overtime]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_EstimateTypes_TotalPaid_Overtime]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_EstimateTypes_TotalPaid_Overtime]
GO

/****** Object:  StoredProcedure [dbo].[usp_EstimateTypes_TotalPaid_Overtime]    Script Date: 01/16/2012 08:56:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- execute [usp_EstimateTypes_TotalPaid_Overtime] '2010','12','2012','4','',1,0
create procedure [dbo].[usp_EstimateTypes_TotalPaid_Overtime]
	@reporting_from_year int,
	@reporting_from_month smallint,	
	@reporting_to_year int,
	@reporting_to_month smallint,	
	@estimate_type varchar(8000),	
	@IsAll bit,
	@IsRIG bit
as
	begin		
		declare @start_date datetime
		declare @end_date datetime
		
		set @start_date = DATEADD(month,@reporting_from_month-1,DATEADD(year,@reporting_from_year-1900,0))		
		set @end_date = DATEADD(day,-1,DATEADD(month,@reporting_to_month,DATEADD(year,@reporting_to_year-1900,0))) + '23:59'
		
		CREATE TABLE #ESTIMATE_TYPE
		(
			value varchar(200)
		)		
		
		INSERT INTO #ESTIMATE_TYPE
		SELECT * from dbo.udf_Split(@estimate_type, ',')
		
		CREATE TABLE #TEMP
		(
			Estimate_ClaimNo varchar(21),
			Estimate_type char(2),
			Estimate_Desc varchar(1024),
			Claim_No char(19),
			[Month] int,
			[Year] int,
			Total_Paid money
		)
		INSERT INTO #TEMP
		select  Estimate_ClaimNo = Estimate_type + ' ' + PR.Claim_No
			,Estimate_type = max(PR.Estimate_type)
			,Estimate_Desc =(SELECT value FROM Control WHERE Type = 'EstCodes' AND Item = PR.Estimate_type)
			,Claim_No = PR.Claim_No			
			,[Month] = Month(CPR.Paid_Date)
			,[Year] = Year(CPR.Paid_Date)					
			,Total_Paid = SUM(Gross) 
		from Payment_Recovery PR 
			LEFT  JOIN Claim_Payment_run CPR ON CPR.Payment_No=PR.Payment_No 
			LEFT JOIN CLAIM_ACTIVITY_DETAIL CAD on PR.Claim_No = CAD.Claim_no
			LEFT JOIN CLAIMS_OFFICERS CL (NOLOCK) ON CL.Alias = CAD.Claims_Officer
			
		where CPR.Paid_Date between @start_date and @end_date		
		AND (@IsAll = 1 OR ((@IsRIG = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND Grp LIKE 'RIG%')))
		and Estimate_type is not null
		and (@estimate_type = '' or (@estimate_type<>'' and Estimate_type in (select * from #ESTIMATE_TYPE)))
		group by Estimate_type,PR.Claim_No,Year(CPR.Paid_Date),Month(CPR.Paid_Date)
		order by [Year],[Month],Estimate_type,PR.Claim_No
		
		SELECT *, Year_Month = dbo.udf_GetPrefixHeadingCombinMonthYear('Paid',[Month],[Year])
		FROM #TEMP
		
		DROP TABLE #TEMP
		drop table #ESTIMATE_TYPE
	end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_EstimateTypes_TotalPaid_Overtime]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_EstimateTypes_TotalPaid_Overtime]  TO [emius]
GO



