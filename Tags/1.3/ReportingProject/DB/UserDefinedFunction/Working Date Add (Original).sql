
/****** Object:  UserDefinedFunction [dbo].[udf_WorkingDaysAdd]    Script Date: 03/16/2012 10:27:35 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_WorkingDaysAdd]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_WorkingDaysAdd]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_WorkingDaysAdd]    Script Date: 03/16/2012 10:27:35 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



/*==================================================================================  
NAME:  udf_WorkingDaysAdd  
STATUS:    
AUTHOR:  RH1  
DATE:  05/07/06  
DESCRIPTION:Adds a number of working days to a specific date  
INPUT:  Working Days to Add, Enddate  
OUTPUT:  New Date with Working Days Added  
------------------------------------------------------------------------------------  
CHANGE HISTORY  
------------------------------------------------------------------------------------  
Modify   By:RH1  
Modify Date:14/06/06  
Description:Previously this function went through a loop to test each individual day,  
   from the date entered for the amount of working days entered, to   
   determine whether it was a public holiday or a weekend (ie Adding only   
   working days). For larger date ranges the loop took too long.  
   
   I have re-written it so the loop only runs for a small portion of the   
   working days to be added and not all each and every day. This is now  
   much quicker for small or large amounts of working days.     
==================================================================================*/  
   
  
CREATE FUNCTION [dbo].[udf_WorkingDaysAdd](@days INT, @Startdate DATETIME)
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
 IF DatePart(dw,@StartDate) > 1 AND DatePart(dw,@StartDate) < 7 AND @StartDate NOT IN (SELECT  date FROM public_hols) BEGIN    
  SELECT @Days=@Days - 1    
 END    
END    

RETURN @StartDate
END           
   

GO

 
GRANT  CONTROL  ON [dbo].[udf_WorkingDaysAdd]  TO [EMICS]
GO
 
GRANT  CONTROL  ON [dbo].[udf_WorkingDaysAdd]  TO [emius]
GO



