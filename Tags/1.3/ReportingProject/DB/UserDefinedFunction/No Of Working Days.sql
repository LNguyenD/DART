
/****** Object:  UserDefinedFunction [dbo].[udf_NoOfWorkingDaysV2]    Script Date: 02/01/2012 09:09:48 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_NoOfWorkingDaysV2]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_NoOfWorkingDaysV2]
GO



/****** Object:  UserDefinedFunction [dbo].[udf_NoOfWorkingDaysV2]    Script Date: 02/01/2012 09:09:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE FUNCTION [dbo].[udf_NoOfWorkingDaysV2](@StartDate DATETIME, @Enddate DATETIME)  
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
	IF @workingdays > 0 BEGIN
		SELECT @WorkingDays = @WorkingDays - 1
	END
	RETURN @WorkingDays  

END
 

GO


GRANT  CONTROL ON [dbo].[udf_NoOfWorkingDaysV2]  TO [EMICS]
GO
 
GRANT  CONTROL ON [dbo].[udf_NoOfWorkingDaysV2]  TO [emius]
GO