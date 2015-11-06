/****** Object:  UserDefinedFunction [dbo].[udf_GetOccupationGroupDesc]    Script Date: 12/29/2011 09:31:35 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_GetOccupationGroupDesc]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_GetOccupationGroupDesc]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetOccupationGroupDesc]    Script Date: 12/29/2011 09:31:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[udf_GetOccupationGroupDesc](@occupation_code varchar(50))
	returns varchar(300)
as
begin
	return CASE WHEN @occupation_code like '1%' THEN '1 MANAGERS'
				WHEN @occupation_code like '2%' THEN '2 PROFESSIONALS'
				WHEN @occupation_code like '3%' THEN '3 TECHNICIANS AND TRADES WORKERS'
				WHEN @occupation_code like '4%' THEN '4 COMMUNITY AND PERSONAL SERVICE WORKERS'
				WHEN @occupation_code like '5%' THEN '5 CLERICAL AND ADMINISTRATIVE WORKERS'
				WHEN @occupation_code like '6%' THEN '6 SALES WORKERS'
				WHEN @occupation_code like '7%' THEN '7 MACHINERY OPERATORS AND DRIVERS'
				WHEN @occupation_code like '8%' THEN '8 LABOURERS' 
				WHEN @occupation_code like '9%' THEN '9 Others' 
			END
end

GO
GRANT  EXECUTE  ON [dbo].[udf_GetOccupationGroupDesc]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetOccupationGroupDesc]  TO [emius]
GO