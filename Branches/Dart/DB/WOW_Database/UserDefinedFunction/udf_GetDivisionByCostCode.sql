/****** Object:  UserDefinedFunction [dbo].[udf_GetDivisionByCostCode]    Script Date: 07/21/2015 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetDivisionByCostCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetDivisionByCostCode]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetDivisionByCostCode]    Script Date: 07/21/2015 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_GetDivisionByCostCode](@CostCode varchar(20))
	RETURNS nvarchar(256)
AS
BEGIN
	RETURN (case @CostCode
				when '1.SMKT' then 'Supermarkets' 
				when '2.SC' then 'Logistics'
				when '3.BIGW' then 'BIG W'
				when '4.DSE' then 'Dick Smith'
				when '5.LIQUOR' then 'BWS'
				when '6.PETROL' then 'Petrol'
				when '7.CORP' then 'Corporate'
				when '8.DANM' then 'Dan M'
				when 'ALH' then 'ALH'
				else 'Miscellaneous'
			end)
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO