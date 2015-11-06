SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uv_submitted_Transaction_Payments]'))
DROP VIEW [dbo].[uv_submitted_Transaction_Payments]
GO

CREATE VIEW [dbo].[uv_submitted_Transaction_Payments]
AS
SELECT     dbo.Payment_Recovery.Claim_No, dbo.Payment_Recovery.WC_Payment_Type, CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte IS NOT NULL AND 
                      Payment_Recovery.Transaction_date < dbo.CLAIM_PAYMENT_RUN.Authorised_dte THEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte ELSE Payment_Recovery.Transaction_date
                       END AS submitted_trans_date, dbo.Payment_Recovery.Payment_Type, dbo.Payment_Recovery.Trans_Amount, dbo.Payment_Recovery.Adjust_Trans_Flag, 
                      dbo.Payment_Recovery.Reversed, dbo.Payment_Recovery.wc_Tape_Month, dbo.Payment_Recovery.Payment_no, dbo.Payment_Recovery.itc, 
                      dbo.Payment_Recovery.gst, dbo.Payment_Recovery.Period_Start_Date, dbo.Payment_Recovery.Period_End_Date, dbo.Payment_Recovery.Estimate_type, 
                      dbo.Payment_Recovery.dam, CASE WHEN payment_type IN ('13','14', '15', '16','WPT001', 'WPT002','WPT003', 'WPT004','WPT005','WPT006','WPT007'
, 'WPP001','WPP002','WPP003','WPP004', 'WPP005', 'WPP006', 'WPP007','WPP008') THEN 1 ELSE 0 END AS WeeklyPayment
FROM         dbo.Payment_Recovery INNER JOIN
                      dbo.CLAIM_PAYMENT_RUN ON dbo.Payment_Recovery.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
WHERE     (dbo.Payment_Recovery.wc_Tape_Month IS NOT NULL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

GRANT  SELECT  ON [dbo].[uv_submitted_Transaction_Payments] TO [EMICS]
GRANT  SELECT  ON [dbo].[uv_submitted_Transaction_Payments] TO [EMIUS]
GRANT  SELECT  ON [dbo].[uv_submitted_Transaction_Payments] TO [DART_Role]
GO

