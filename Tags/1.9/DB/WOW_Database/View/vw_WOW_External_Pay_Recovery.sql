SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Dustin (DART)
-- CREATE date: 07/31/2015 10:00:00
-- Description:	SQL View to retrieve the external payments information
-- =============================================
IF EXISTS(SELECT * FROM sys.views WHERE name = 'vw_WOW_External_Pay_Recovery')
	DROP VIEW [dbo].[vw_WOW_External_Pay_Recovery]
GO
	CREATE VIEW [dbo].[vw_WOW_External_Pay_Recovery]
	AS
    SELECT	INV.CLAIM AS CLAIM_NO,
			2 AS FUND,
			INV.INVOICEID AS PAYMENT_NO,
			INV.REFERENCE2 AS PAYEE_NAME,
			INV.CHEQUENUMBER AS CHEQUE_NO,
			INV.ApprovedDate AS AUTHORISED_DTE , 
			INV.DatePaid AS PAID_DTE,  
			'N' AS    ADJUST_TRANS_FLAG,
			INV.INVOICEAMOUNT AS TRANS_AMOUNT,
			INV.INVOICEAMOUNT AS GROSS,
			INV.INVOICEAMOUNT AS NET_AMT, 
			SI.ESTIMATETYPE AS ESTIMATE_TYPE,
			SI.SiCategoryId AS SICATEGORYID,
			SI.SiCode AS SICODE,
			SI.IsRecovery AS ISRECOVERY,
			(CASE WHEN INV.DateCancelled = NULL THEN 0 ELSE 1 END) AS REVERSED,
			INV.SubmissionDate AS WC_TAPE_MONTH,			
			CASE WHEN ISI.ITC = NULL THEN 0 ELSE ISI.ITC END AS ITC,0 AS DAM,
			INV.INVOICEAMOUNT - INV.AMOUNTEXGST AS GST,
			INV.PaymentType AS PAYMENT_TYPE, 
			ISI.SUBMISSIONCODE AS WC_PAYMENT_TYPE,
			INV.InvoiceDate AS TRANSACTION_DTE, 
			NULL AS PERIOD_START_DTE, 
			NULL AS PERIOD_END_DTE, 
			ISI.TREATMENTDATE AS DTE_OF_SERVICE, 
			INV.InvoiceDate AS INVOICE_DTE, 
			1 AS CELL_NO,
			INV.INVOICEAMOUNT AS PAID
    FROM	Invceacc AS INV
			LEFT JOIN InvoiceServiceItems AS ISI ON ISI.InvoiceId = INV.InvoiceID
			LEFT JOIN vw_Shared_ServiceItems AS SI ON ISI.ServiceItemId = SI.ServiceItemId
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO