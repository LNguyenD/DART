/****** Object:  StoredProcedure [dbo].[usp_GetPaymentGroups]    Script Date: 03/12/2012 16:44:34 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_GetPaymentGroups]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_GetPaymentGroups]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetPaymentGroups]    Script Date: 03/12/2012 16:44:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetPaymentGroups]
AS
BEGIN
	SET NOCOUNT ON;

	--CREATE VIEW viewPaymentGroupWithNull AS
	--SELECT 'abc' AS Payment_Group, 'abc' AS Name
	--UNION ALL	
	--SELECT distinct PaymentGroup = Payment_Group, 
	--		Name = case when left(PT.Payment_Type, 3) in ('WPT', 'WPP') then Payment_Group + ' - ' + 'Weekly Benefits'								
	--					when left(PT.Payment_Type, 2) = 'IN' or pt.payment_type = 'INS600' then Payment_Group + ' - ' + 'Legal - Insurer'
	--					when left(PT.Payment_Type, 2) = 'WK' then Payment_Group + ' - ' + 'Legal - Worker'
	--					when left(PT.Payment_Type, 3) = 'WRK' then Payment_Group + ' - ' + 'Legal - Common law - Worker'
	--					when left(PT.Payment_Type, 4) = 'INS7' then Payment_Group + ' - ' + 'Legal - Common law - Insurer'
	--					when PT.Payment_Type in ('IIN101', 'IIN104', 'IIN105') then Payment_Group + ' - ' + 'Investigation - Medical'
	--					when PT.Payment_Type = 'IIN102' then Payment_Group + ' - ' + 'Investigation - Factual / Surveillance'
	--					when PT.Payment_Type = 'IIN103' then Payment_Group + ' - ' + 'Investigation - S40 assessment'
	--					when left(PT.Payment_Type, 2) = 'OR' then Payment_Group + ' - ' + 'Rehab'
	--					when left(PT.Payment_Type, 3) = 'DOA' then Payment_Group + ' - ' + 'Domestic Assistance'
	--					when PT.Payment_Type = 'PCA001' then Payment_Group + ' - ' + 'Careers'
	--					when PT.Payment_Type = 'TRA002' then Payment_Group + ' - ' + 'Worker Travel'
	--					when PT.Payment_Type = 'COM001' then Payment_Group + ' - ' + 'Commutation'	end
								
	--FROM PAYMENT_TYPES PT
	--WHERE PT.Payment_Type in ('PCA001', 'TRA002', 'COM001', 'IIN101', 'IIN102', 'IIN103', 'IIN104', 'IIN105')
	--		OR left(PT.Payment_Type, 2) in ('IN', 'WK', 'OR')
	--		OR left(PT.Payment_Type, 3) in ('WPT', 'WPP', 'WRK', 'DOA')
	--UNION
	--SELECT  distinct PaymentGroup = Payment_Group, 
	--		Name = case when Estimate_type = '51' then Payment_Group + ' - ' + 'Permanent Impairment'
	--					when Estimate_type = '55' then Payment_Group + ' - ' + 'Medical'
	--					when Estimate_type = '57' then Payment_Group + ' - ' + 'Common Law' end
	--FROM PAYMENT_TYPES PT JOIN Payment_Recovery PR ON PR.Payment_Type = PT.Payment_Type
	--WHERE Estimate_type in ('51', '55', '57')		
	
	
	create table #Temp
	(		
		Name varchar(50)
	)
	insert into #Temp values('Careers')
	insert into #Temp values('Common Law')
	insert into #Temp values('Commutation')
	insert into #Temp values('Domestic Assistance')
	insert into #Temp values('Investigation - Factual / Surveillance')
	insert into #Temp values('Investigation - Medical')	
	insert into #Temp values('Investigation - S40 assessment')	
	insert into #Temp values('Legal - Common law - Insurer')
	insert into #Temp values('Legal - Common law - Worker')
	insert into #Temp values('Legal - Insurer')
	insert into #Temp values('Legal - Worker')	
	insert into #Temp values('Medical')
	insert into #Temp values('Permanent Impairment')
	insert into #Temp values('Rehab')
	insert into #Temp values('Weekly Benefits')
	insert into #Temp values('Worker Travel')
				
	select * from #Temp	
	
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetPaymentGroups]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetPaymentGroups]  TO [emius]
GO

--exec usp_GetPaymentGroups


