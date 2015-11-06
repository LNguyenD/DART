/****** Object:  StoredProcedure [dbo].[usp_GetAllPaymentGroups]    Script Date: 03/12/2012 16:44:34 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_GetAllPaymentGroups]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_GetAllPaymentGroups]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllPaymentGroups]    Script Date: 03/12/2012 16:44:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetAllPaymentGroups]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT distinct PaymentGroup = Payment_Group, 
			Name = case when left(PT.Payment_Type, 3) in ('WPT', 'WPP') then 'Weekly Benefits'								
						when left(PT.Payment_Type, 2) = 'IN' or pr.payment_type = 'INS600' then 'Legal - Insurer'
						when left(PT.Payment_Type, 2) = 'WK' then 'Legal - Worker'
						when left(PT.Payment_Type, 3) = 'WRK' then 'Legal - Common law - Worker'
						when left(PT.Payment_Type, 4) = 'INS7' then 'Legal - Common law - Insurer'
						when PT.Payment_Type in ('IIN101', 'IIN104', 'IIN105') then 'Investigation - Medical'
						when PT.Payment_Type = 'IIN102' then 'Investigation - Factual / Surveillance'
						when PT.Payment_Type = 'IIN103' then 'Investigation - S40 assessment'
						when left(PT.Payment_Type, 2) = 'OR' then 'Rehab'
						when left(PT.Payment_Type, 3) = 'DOA' then 'Domestic Assistance'
						when PT.Payment_Type = 'PCA001' then 'Carers'
						when PT.Payment_Type = 'TRA002' then 'Worker Travel'
						when PT.Payment_Type = 'COM001' then 'Commutation'
						when Estimate_type = '51' then 'Permanent Impairment'
						when Estimate_type = '55' then 'Medical'
						when Estimate_type = '57' then 'Common Law' end
								
	FROM PAYMENT_TYPES PT JOIN Payment_Recovery PR ON PR.Payment_Type = PT.Payment_Type
	WHERE PT.Payment_Type in ('PCA001', 'TRA002', 'COM001', 'IIN101', 'IIN102', 'IIN103', 'IIN104', 'IIN105')
			OR left(PT.Payment_Type, 2) in ('IN', 'WK', 'OR')
			OR left(PT.Payment_Type, 3) in ('WPT', 'WPP', 'WRK', 'DOA')
			OR Estimate_type in ('51', '55', '57')
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetAllPaymentGroups]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetAllPaymentGroups]  TO [emius]
GO




