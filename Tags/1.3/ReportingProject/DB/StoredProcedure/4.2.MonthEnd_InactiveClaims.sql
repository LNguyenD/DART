

/****** Object:  StoredProcedure [dbo].[usp_MonthEnd_InactiveClaims]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_MonthEnd_InactiveClaims]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_MonthEnd_InactiveClaims]
GO

/****** Object:  StoredProcedure [dbo].[usp_MonthEnd_InactiveClaims]    Script Date: 01/16/2012 08:56:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--execute [usp_MonthEnd_InactiveClaims] '12/31/2011',1,0
CREATE PROCEDURE [dbo].[usp_MonthEnd_InactiveClaims]
      @reporting_date DATETIME,    
      @IsAll BIT,
      @IsRIG BIT
AS
      DECLARE @start_date DATETIME
      DECLARE @end_date DATETIME
      SET @start_date = CONVERT(DATETIME, CONVERT(CHAR, DATEADD(DAY, -90, @reporting_date), 106))
      SET @end_date = CONVERT(DATETIME, CONVERT(CHAR, @reporting_date, 106)) + '23:59'   
     
      BEGIN
           
            SELECT  dbo.[udf_ExtractGroup](CL.grp) AS [group]
                        ,CL.grp AS team
                        ,CL.First_Name + ' ' + CL.Last_Name AS Claim_Officer
                        ,CAD.Claim_no
                        ,Paid_Date = CONVERT(DATETIME,null)
                        ,Payment_Number_Of_Last_Payment = null
            INTO #TEMP
            FROM  CAD_AUDIT CAD 
            LEFT OUTER JOIN CLAIMS_OFFICERS CL (NOLOCK) ON CL.Alias = CAD.Claims_Officer     
			join CLAIM_DETAIL CD ON CAD.Claim_no = CD.Claim_Number
			where CAD.ID = (select MAX(id) from CAD_AUDIT ca2    
			where CAD.Claim_no = ca2.Claim_no  and ca2.transaction_date <= @reporting_date)
									and isnull(CAD.Claim_Closed_Flag,'N') <> 'Y'  
			AND CD.is_Null='0'
			and CAD.Claim_no not in (
				Select distinct claim_no
				from payment_recovery where  transaction_date between @start_date and @end_date and reversed = '0'
				and ( adjust_trans_flag  = 'n'  or adjust_trans_flag = ''    )
			)               
            
            AND (@IsAll = 1 OR ((@IsRIG = 0 AND Grp NOT LIKE 'RIG%') OR (@IsRIG = 1 AND Grp LIKE 'RIG%')))           
			
            CREATE TABLE #TEMP2
            (
                  id INTEGER identity,
                  claim_no VARCHAR(19),
                  Payment_no INTEGER,
                  drawn_date DATETIME,
                  paid_date DATETIME,
                  net_amt MONEY
            )
           
            INSERT INTO #TEMP2 (claim_no, Payment_no, drawn_date, paid_date, net_amt)
            SELECT  Claim_no = pr.claim_no,
                   Payment_no = PR.Payment_no,
                   Drawn_date = MAX(CPR.Drawn_date),
                   Paid_Date = MAX(CPR.Paid_Date),
                   net_amt = SUM(Net_amt)
            FROM #TEMP JOIN PAYMENT_Recovery PR ON #TEMP.claim_no = pr.claim_no
                  LEFT OUTER JOIN Claim_Payment_run CPR ON CPR.Payment_No = PR.Payment_No
            WHERE PR.Claim_no = #TEMP.claim_no
            GROUP by pr.claim_no, PR.Payment_no
            ORDER BY pr.claim_no, MAX(CPR.Drawn_date) desc, PR.Payment_no asc         
			
 
            UPDATE #TEMP
            SET Paid_Date = #TEMP2.paid_date,
                Payment_Number_Of_Last_Payment = #TEMP2.Payment_no
            FROM #TEMP2 JOIN (
                      SELECT a.claim_no, id = MIN(a.id)
                      FROM #TEMP2 AS a
                        INNER JOIN #TEMP2 AS b ON (a.Claim_no = b.Claim_no)
                      GROUP BY a.claim_no
                  ) x ON x.id = #TEMP2.id
            WHERE #TEMP.claim_no = x.claim_no
           
            DROP TABLE #TEMP2
 
            SELECT * FROM #TEMP
            ORDER BY [group],[team],Claim_Officer
 
            DROP TABLE #TEMP
      END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_MonthEnd_InactiveClaims]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_MonthEnd_InactiveClaims]  TO [emius]
GO



