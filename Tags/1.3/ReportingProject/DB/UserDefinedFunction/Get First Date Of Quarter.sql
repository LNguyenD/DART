

/****** Object:  UserDefinedFunction [dbo].[udf_GetFirstDateOfQuarter]    Script Date: 12/29/2011 10:29:12 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_GetFirstDateOfQuarter]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_GetFirstDateOfQuarter]
GO


/****** Object:  UserDefinedFunction [dbo].[udf_GetFirstDateOfQuarter]    Script Date: 12/29/2011 10:29:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_GetFirstDateOfQuarter] (@date DATETIME) 
RETURNS DATETIME
AS
BEGIN
RETURN CONVERT(varchar(30), dateadd(qq, datediff(qq,0, @date),0))
END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetFirstDateOfQuarter]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetFirstDateOfQuarter]  TO [emius]
GO

