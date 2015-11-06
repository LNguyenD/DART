/****** Object:  UserDefinedFunction [dbo].[udf_WorkingDaysAddV2]    Script Date: 03/16/2012 10:28:10 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_WorkingDaysAddV2]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_WorkingDaysAddV2]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_WorkingDaysAddV2]    Script Date: 03/16/2012 10:28:10 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
  
CREATE FUNCTION [dbo].[udf_WorkingDaysAddV2](@days INT, @Startdate DATETIME)
RETURNS DateTime As    
BEGIN    

DECLARE @Step INT

IF @Days = 0 or @Startdate is null BEGIN
 RETURN @StartDate
END

SELECT @Step = @Days
SELECT @Days = SQRT(@Days * @Days)
SELECT @Step = (@Step / @Days)

WHILE @Days > 0 BEGIN    
 SELECT @StartDate=DateAdd(dd,@Step,@StartDate)    
 IF DatePart(dw,@StartDate) > 1 AND DatePart(dw,@StartDate) < 7 AND DATEADD(dd, DATEDIFF(dd, 0, @StartDate), 0) NOT IN (SELECT  date FROM public_hols) BEGIN    
  SELECT @Days=@Days - 1    
 END    
END    

RETURN @StartDate
END           
   
GO

 
GRANT  CONTROL  ON [dbo].[udf_WorkingDaysAddV2]  TO [EMICS]
GO
 
GRANT  CONTROL  ON [dbo].[udf_WorkingDaysAddV2]  TO [emius]
GO


