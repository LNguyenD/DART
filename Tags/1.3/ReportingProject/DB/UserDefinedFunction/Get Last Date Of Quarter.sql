

/****** Object:  UserDefinedFunction [dbo].[udf_GetLastDateOfQuarter]    Script Date: 12/29/2011 10:29:42 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_GetLastDateOfQuarter]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_GetLastDateOfQuarter]
GO



/****** Object:  UserDefinedFunction [dbo].[udf_GetLastDateOfQuarter]    Script Date: 12/29/2011 10:29:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_GetLastDateOfQuarter] (@date DATETIME) 
RETURNS DATETIME
AS
BEGIN
RETURN CONVERT(DATETIME, dateadd(qq, datediff(qq,0,@date)+1,-1)) + '23:59'
END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetLastDateOfQuarter]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetLastDateOfQuarter]  TO [emius]
GO


