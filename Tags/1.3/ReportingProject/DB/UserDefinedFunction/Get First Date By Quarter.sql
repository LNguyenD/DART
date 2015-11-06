

/****** Object:  UserDefinedFunction [dbo].[udf_GetFirstDateByQuarter]    Script Date: 12/29/2011 10:29:12 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_GetFirstDateByQuarter]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_GetFirstDateByQuarter]
GO


/****** Object:  UserDefinedFunction [dbo].[udf_GetFirstDateByQuarter]    Script Date: 12/29/2011 10:29:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[udf_GetFirstDateByQuarter] (@year char(4),@quarter char(1)) 
RETURNS DATETIME
AS
BEGIN
	Return DATEADD(quarter,(@year-1900)*4+@quarter-1,0)
END
GO


GRANT  EXECUTE  ON [dbo].[udf_GetFirstDateByQuarter]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetFirstDateByQuarter]  TO [emius]
GO



