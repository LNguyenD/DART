

/****** Object:  StoredProcedure [dbo].[usp_TotalNumberofOpenClaimsandTotalPaidfor_MechanismGroup_Occupation]    Script Date: 03/14/2012 13:16:45 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_TotalNumberofOpenClaimsandTotalPaidfor_MechanismGroup_Occupation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_TotalNumberofOpenClaimsandTotalPaidfor_MechanismGroup_Occupation]
GO


/****** Object:  StoredProcedure [dbo].[usp_TotalNumberofOpenClaimsandTotalPaidfor_MechanismGroup_Occupation]    Script Date: 03/14/2012 13:16:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [dbo].[usp_TotalNumberofOpenClaimsandTotalPaidfor_MechanismGroup_Occupation]  '01/01/2001','04/30/2012','10125181'
-- execute [dbo].[usp_TotalNumberofOpenClaimsandTotalPaidfor_MechanismGroup_Occupation]  '04/01/1990','12/31/2011','10125181'
CREATE PROCEDURE [dbo].[usp_TotalNumberofOpenClaimsandTotalPaidfor_MechanismGroup_Occupation]
	@start_date datetime,
	@end_date datetime,
	@policies varchar(8000)
AS
BEGIN
	set @start_date =convert(datetime, convert(char, @start_date, 106)) 
	set @end_date =convert(datetime, convert(char, @end_date, 106)) + '23:59'
	
	SET NOCOUNT ON;	
	
	CREATE TABLE #OPEN_CLAIM
	(		
		Claim_no varchar(30)
	)	
	
	INSERT INTO #OPEN_CLAIM
		select distinct CADA.Claim_no
		from CAD_AUDIT CADA left join CLAIM_DETAIL CD on CADA.Claim_no = CD.Claim_Number
		where CADA.ID = (select MAX(id) from CAD_AUDIT CADA_2 where CADA_2.Claim_no = CADA.Claim_no
		and Transaction_Date  between @start_date AND @end_date)
		and isnull(Claim_Closed_Flag,'N') <> 'Y' 
		and CD.Policy_No in (SELECT * from dbo.udf_Split(@policies, ','))	
    
    SELECT  CD.Claim_Number,
			Occupation_Desc=(CASE WHEN CD.ASCO_ID = NULL THEN 
									(select top 1 Description from ASCO_DESC where Code=CD.Occupation_Code)
								 ELSE 
									(select top 1 Description from ASCO where id=CD.Asco_id)
								 END
								 )
			,Mechanism_Group=dbo.[udf_GetMechanismGroup]((CD.Mechanism_of_Injury)),			
			Total_Number_Of_Open_Claims =1,		
			Total_Cost = isnull((select SUM(PR.TRANS_AMOUNT) from PAYMENT_RECOVERY PR WHERE PR.Transaction_Date BETWEEN @start_date AND @end_date and PR.Claim_No = OC.Claim_no),0.0)
	FROM  #OPEN_CLAIM OC Left join CLAIM_DETAIL CD 	on OC.Claim_no = CD.Claim_Number	
		
    DROP TABLE #OPEN_CLAIM 
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_TotalNumberofOpenClaimsandTotalPaidfor_MechanismGroup_Occupation]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_TotalNumberofOpenClaimsandTotalPaidfor_MechanismGroup_Occupation]  TO [emius]
GO
