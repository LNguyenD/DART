
/****** Object:  StoredProcedure [dbo].[usp_TOOCSCoding]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_RecoveryReport]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_RecoveryReport]
GO

/****** Object:  StoredProcedure [dbo].[usp_TOOCSCoding]    Script Date: 01/16/2012 08:56:05 ******/
-- execute usp_RecoveryReport '03/31/1998',1,0
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[usp_RecoveryReport]
	@reporting_date  datetime,	
	@IsAll bit,
	@IsRIG bit
as
	begin		
		set @reporting_date =convert(datetime, convert(char, @reporting_date, 106)) + '23:59'	
		
		Create table #RecoveryTemp
		(			
			claim_number char(19),
			Estimate_Type int,			
			Reserve float,
			Incurred float,
			Payment float,
			Pcent_Recovery float						
		)
		insert into #RecoveryTemp 
		
		SELECT  ESTIMATE_DETAILS.Claim_No as claim_number,     
					 ESTIMATE_DETAILS.Type,         
					 Reserve = ISNULL(Sum(ESTIMATE_DETAILS.Amount) - 
											ISNULL((SELECT Sum(Trans_amount - ISNULL(ITC,0) - ISNULL(DAM,0) )   
															FROM  PAYMENT_RECOVERY   
															WHERE PAYMENT_RECOVERY.Estimate_Type = ESTIMATE_DETAILS.Type  AND   
															PAYMENT_RECOVERY.Transaction_date <=@reporting_date
													 AND ISNULL( PAYMENT_RECOVERY.Estimate_SubType,'') = ISNULL(ESTIMATE_DETAILS.Sub_Type,'') AND
																	PAYMENT_RECOVERY.Claim_No = ESTIMATE_DETAILS.Claim_No ),0)   ,0),
					 Incurred = ISNULL((sum(ESTIMATE_DETAILS.Amount + ESTIMATE_DETAILS.itc + ESTIMATE_DETAILS.dam)),0),
					 Payments = isnull((SELECT Sum(Trans_amount)   
								 FROM  PAYMENT_RECOVERY   
								 WHERE PAYMENT_RECOVERY.Estimate_Type = ESTIMATE_DETAILS.Type  AND   
								 PAYMENT_RECOVERY.Transaction_date <=@reporting_date
								 AND ISNULL( PAYMENT_RECOVERY.Estimate_SubType,'') = ISNULL(ESTIMATE_DETAILS.Sub_Type,'') AND
									   PAYMENT_RECOVERY.Claim_No = ESTIMATE_DETAILS.Claim_No ),0) ,  
									   
					 Pcent_Recovery = isnull((SELECT Pcent_Recovery  
									   FROM ESTIMATE_DETAILS ED1  
									   WHERE ID = (SELECT Max(id)  
                                       FROM ESTIMATE_DETAILS ED2
                                       WHERE ED2.Type = ESTIMATE_DETAILS.Type AND  
										 ISNULL(ED2.Sub_Type,'') = ISNULL(ESTIMATE_DETAILS.Sub_Type,'')  AND
                                             ED2.Claim_No = ESTIMATE_DETAILS.Claim_No) AND  
                                 ED1.Type = ESTIMATE_DETAILS.Type AND  
                                 ED1.Claim_No = ESTIMATE_DETAILS.Claim_No),0)  
                    
		
			FROM ESTIMATE_DETAILS   
		   WHERE   ESTIMATE_DETAILS.Type in (73, 74, 75, 76, 77) and ESTIMATE_DETAILS.Transaction_date <=@reporting_date
		GROUP BY ESTIMATE_DETAILS.Claim_no,  ESTIMATE_DETAILS.Type, ISNULL(ESTIMATE_DETAILS.Sub_Type,'') ,ESTIMATE_DETAILS.Type  + ISNULL(ESTIMATE_DETAILS.Sub_Type,'') 

		
		SELECT #RecoveryTemp.*,pcent_Estimate_recovery =isnull(CLAIM_ACTIVITY_DETAIL.pcent_Estimate_recovery,0) from #RecoveryTemp   
			INNER JOIN  CLAIM_ACTIVITY_DETAIL  (NOLOCK) ON CLAIM_ACTIVITY_DETAIL.CLAIM_NO =#RecoveryTemp.claim_number
			LEFT OUTER JOIN CLAIMS_OFFICERS  (NOLOCK) ON CLAIMS_OFFICERS.Alias = CLAIM_ACTIVITY_DETAIL.Claims_Officer  
		where Reserve <> 0 and Isnull(CLAIM_ACTIVITY_DETAIL.Claim_closed_flag,'N')<>'Y'		
			AND (@IsAll = 1 OR ((@IsRIG = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND Grp LIKE 'RIG%'))) 	
		
		drop table #RecoveryTemp
	end
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_RecoveryReport]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_RecoveryReport]  TO [emius]
GO


