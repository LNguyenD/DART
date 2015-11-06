IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_NoOfDaysWithoutWeekend]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_NoOfDaysWithoutWeekend]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_NoOfDaysWithoutWeekend]    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_NoOfDaysWithoutWeekend](@StartDate DATETIME, @Enddate DATETIME)    
RETURNS Int As    
BEGIN   


return  ((DATEDIFF(dd, @StartDate, @EndDate) + 1)

-(DATEDIFF(wk, @StartDate, @EndDate) * 2)

-(CASE WHEN DATENAME(dw, @StartDate) = 'Sunday' THEN 1 ELSE 0 END)

-(CASE WHEN DATENAME(dw, @EndDate) = 'Saturday' THEN 1 ELSE 0 END))
  
END 


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_NoOfDaysWithoutWeekend] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_NoOfDaysWithoutWeekend] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_NoOfDaysWithoutWeekend] TO [DART_Role]
GO
 