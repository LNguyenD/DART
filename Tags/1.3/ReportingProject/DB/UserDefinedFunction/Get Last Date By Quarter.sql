

/****** Object:  UserDefinedFunction [dbo].[udf_GetLastDateByQuarter]    Script Date: 12/29/2011 10:29:12 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_GetLastDateByQuarter]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_GetLastDateByQuarter]
GO


/****** Object:  UserDefinedFunction [dbo].[udf_GetLastDateByQuarter]    Script Date: 12/29/2011 10:29:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[udf_GetLastDateByQuarter] (@year char(4),@quarter char(1)) 
RETURNS DATETIME
AS
BEGIN
	RETURN (DATEADD(quarter,(@year-1900)*4+@quarter,0)-1) + '23:59'
END
GO


GRANT  EXECUTE  ON [dbo].[udf_GetLastDateByQuarter]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetLastDateByQuarter]  TO [emius]
GO




