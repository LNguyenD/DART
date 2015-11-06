/****** Object:  UserDefinedFunction [dbo].[udf_NoOfWorkingDays]    Script Date: 03/16/2012 10:26:02 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_NoOfWorkingDays]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_NoOfWorkingDays]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_NoOfWorkingDays]    Script Date: 03/16/2012 10:26:02 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



/*==================================================================================
NAME:		udf_NoOfWorkingDays
STATUS:		
AUTHOR:		RH1
DATE:		14/06/06
DESCRIPTION:Calculates the number of working days between two dates
INPUT:		Startdate, Enddate
OUTPUT:		Number of Working Days between the two input dates
------------------------------------------------------------------------------------
CHANGE HISTORY
------------------------------------------------------------------------------------
Modify   By:RH1
Modify Date:14/06/06
Description:Previously this function went through a loop to test each individual day
			between the two input dates to determine whether it was a public holiday
			or a weekend (ie finding only working days). For larger date ranges the
			loop took too long.

			I have re-written it so the loop only runs for the remainding days
			(not part of a FULL week) then calculated the full weeks in one query.
			This works well for all date ranges including very large ones.			
==================================================================================*/



CREATE FUNCTION [dbo].[udf_NoOfWorkingDays](@StartDate DATETIME, @Enddate DATETIME)  
RETURNS Int As  
BEGIN  

DECLARE @Tempdate DATETIME, @TempDays INT, @workingdays INT

IF @StartDate > @EndDate BEGIN  -- Swap Dates around if @StartDate > @EndDate
 SELECT @Tempdate = @EndDate
 SELECT @EndDate=@StartDate  
 SELECT @StartDate=@TempDate  
END  

SELECT @workingdays = 0, @Tempdate = @Startdate
SELECT @TempDays = (7 - (DATEPART(dw, @StartDate) - Datepart(dw, @Enddate))) 
					- ((7 - (DATEPART(dw, @StartDate) - Datepart(dw, @Enddate)))/7*7) -- Calculates the remainding days 

WHILE @StartDate <= DATEADD(d, @TempDays, @TempDate) BEGIN  -- Determines if remainding days are weekdays
 IF DatePart(dw,@StartDate) > 1 AND DatePart(dw,@StartDate) < 7 BEGIN  
  SELECT @WorkingDays=@WorkingDays + 1  
 END  
 SELECT @StartDate=DateAdd(dd,1,@StartDate)  
END  

SELECT	@workingdays = (DATEDIFF ( d, @Tempdate, @enddate) /7*5) -- Calculates ALL other weekdays minues Public Hols.
		- (SELECT count(*) FROM public_hols where date between @Tempdate AND @EndDate AND datepart(dw, date) BETWEEN 2 and 6)
		+ @workingdays
SELECT @WorkingDays = @WorkingDays - 1
RETURN @WorkingDays  

END
GO



GRANT  CONTROL ON [dbo].[udf_NoOfWorkingDays]  TO [EMICS]
GO
 
GRANT  CONTROL ON [dbo].[udf_NoOfWorkingDays]  TO [emius]
GO


