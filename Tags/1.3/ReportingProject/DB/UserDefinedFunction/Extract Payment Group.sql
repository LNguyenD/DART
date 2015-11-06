/****** Object:  UserDefinedFunction [dbo].[udf_ExtractPaymentGroup]    Script Date: 04/16/2012 16:06:04 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_ExtractPaymentGroup]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_ExtractPaymentGroup]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_ExtractPaymentGroup]    Script Date: 04/16/2012 16:06:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[udf_ExtractPaymentGroup](@pay_type varchar(50), @est_type varchar(50))
	returns varchar(300)
as
BEGIN

	return case	when left(@pay_type, 3) in ('WPT', 'WPP') then 'Weekly Benefits'
		        when left(@pay_type, 4) = 'INS7' THEN 'Legal - Common law - Insurer'
	            when @est_type = 57 then 'Common Law'
	            when @est_type = 51 then 'Permanent Impairment'
				when @est_type = 55 then 'Medical'
				when left(@pay_type,3) in ('IN0','IN1','IN5','IN7','IN8')OR @pay_type='INS6000' then 'Legal - Insurer'
				when left(@pay_type, 2) = 'WK' then 'Legal - Worker'
				when left(@pay_type, 3) = 'WRK' then 'Legal - Common law - Worker'
				when @pay_type in ('IIN101', 'IIN104', 'IIN105') then 'Investigation - Medical'
				when @pay_type = 'IIN102' then 'Investigation - Factual / Surveillance'
				when @pay_type = 'IIN103' then 'Investigation - S40 assessment'
				when left(@pay_type,2) = 'OR' then 'Rehab'
				when left(@pay_type,3) = 'DOA' then 'Domestic Assistance'
				when @pay_type = 'PCA001' then 'Carers'
				when @pay_type = 'TRA002' then 'Worker Travel'
				when @pay_type = 'COM001' then 'Commutation'
			   
				else 'UNKNOWN' END		
end
GO

GRANT  EXECUTE  ON [dbo].[udf_ExtractPaymentGroup]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_ExtractPaymentGroup]  TO [emius]
GO
