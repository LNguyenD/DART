

/****** Object:  UserDefinedFunction [dbo].[udf_IsTheSameQuarter]    Script Date: 12/30/2011 09:44:54 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_IsTheSameQuarter]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_IsTheSameQuarter]
GO



/****** Object:  UserDefinedFunction [dbo].[udf_IsTheSameQuarter]    Script Date: 12/30/2011 09:44:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[udf_IsTheSameQuarter](@d1 datetime ,@d2 datetime)
	returns bit
as
begin
	if (DATEPART(YEAR, @d1) = DATEPART(YEAR, @d2)
		and DATEPART(QUARTER, @d1) = DATEPART(QUARTER, @d2)) 
		return 1
	return 0
end
GO

GRANT  CONTROL ON [dbo].[udf_IsTheSameQuarter]  TO [EMICS]
GO
 
GRANT  CONTROL ON [dbo].[udf_IsTheSameQuarter]  TO [emius]
GO


