/****** Object:  UserDefinedFunction [dbo].[udf_ExtractPaymentGroupFromNames]    Script Date: 04/16/2012 16:06:04 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_ExtractPaymentGroupFromNames]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_ExtractPaymentGroupFromNames]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_ExtractPaymentGroupFromNames]    Script Date: 04/16/2012 16:06:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[udf_ExtractPaymentGroupFromNames](@name varchar(8000))
	returns varchar(8000)
as
begin
	declare @payment_group varchar(8000)
	declare @delimiter nvarchar(2)
	set @delimiter = ','
	set @payment_group = ''
	DECLARE @nextString nvarchar(40)
	DECLARE @pos int	
	SET @name = @name + @delimiter
	SET @pos = charindex(@delimiter, @name)

	WHILE (@pos <> 0)
	BEGIN
	SET @nextString = substring(@name, 1, @pos - 1)
	set @payment_group = 
		@payment_group + case when (LTRIM(RTRIM(@nextString))) = 'Weekly Benefits' then 'WPT, WPP'
								when (LTRIM(RTRIM(@nextString))) = 'Permanent Impairment' then '51'
								when (LTRIM(RTRIM(@nextString))) = 'Medical' then '55'
								when (LTRIM(RTRIM(@nextString))) = 'Common Law' then '57'
								when (LTRIM(RTRIM(@nextString))) = 'Legal - Worker' then 'WK'
								when (LTRIM(RTRIM(@nextString))) = 'Legal – Common law – Insurer' then 'INS7'
								when (LTRIM(RTRIM(@nextString))) = 'Legal - Insurer' then 'IN, INS600, INS6000'
								when (LTRIM(RTRIM(@nextString))) = 'Legal – Common law – Worker' then 'WRK'
								when (LTRIM(RTRIM(@nextString))) = 'Investigation - Medical' then 'IIN101, IIN104, IIN105'
								when (LTRIM(RTRIM(@nextString))) = 'Investigation - Factual / Surveillance' then 'IIN102'
								when (LTRIM(RTRIM(@nextString))) = 'Investigation - S40 assessment' then 'IIN103'
								when (LTRIM(RTRIM(@nextString))) = 'Rehab' then 'OR'
								when (LTRIM(RTRIM(@nextString))) = 'Domestic Assistance' then 'DOA'
								when (LTRIM(RTRIM(@nextString))) = 'Careers' then 'PCA001'
								when (LTRIM(RTRIM(@nextString))) = 'Worker Travel' then 'TRA002'
								when (LTRIM(RTRIM(@nextString))) = 'Commutation' then 'COM001'
								end + ','
	SET @name = substring(@name, @pos + 1, len(@name))
	SET @pos = charindex(@delimiter, @name)
	END 
	
	return @payment_group
end


GO

GRANT  EXECUTE  ON [dbo].[udf_ExtractPaymentGroupFromNames]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_ExtractPaymentGroupFromNames]  TO [emius]
GO