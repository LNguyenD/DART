/****** Object:  StoredProcedure [dbo].[usp_Dashboard_Portfolio_GenerateData]    Script Date: 23/04/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_GenerateData_Last3Year]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_GenerateData_Last3Year]
GO

Create procedure [dbo].[usp_CPR_GenerateData_Last3Year]
	@System varchar(20)
as
begin		
	
	declare @Reporting_Date_End datetime, @Last3Month_Start datetime
		, @Last3Year_Start datetime, @VarDate datetime, @VarDatePlus1Day datetime
	
	set @Reporting_Date_End =  DATEADD(dd, DATEDIFF(dd, 0, GETDATE()), -1) + '23:59'
	set @Last3Month_Start = DATEADD(mm,-3, DATEADD(mm, DATEDIFF(MM, 0, GETDATE()), 0)) + '23:59'
	set @Last3Year_Start =DATEADD(dd,-1,DATEADD(yy,-3, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))) + '23:59'		
	
	set @VarDate = @Last3Year_Start		
	
	WHILE @VarDate < @Last3Month_Start
	BEGIN			
		--set @VarDatePlus1Day = DATEADD(dd, DATEDIFF(dd, 0, @VarDate),1) + '23:59'						
							
		IF UPPER(@System) = 'TMF'
		BEGIN
			IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[TMF_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))									
				INSERT INTO [Dart].[dbo].[TMF_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @VarDate, 0				
		END
		ELSE IF UPPER(@System) = 'HEM'
		BEGIN
			IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[HEM_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))														
				INSERT INTO [Dart].[dbo].[HEM_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @VarDate, 0	
		END
		ELSE IF UPPER(@System) = 'EML'
		BEGIN
			IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[EML_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))										
				INSERT INTO [Dart].[dbo].[EML_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @VarDate, 0
		END	
		set @VarDate = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, DATEADD(dd,10,@VarDate)) + 1, 0)) + '23:59'		
	END		

end
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_CPR_GenerateData_Last3Year] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_CPR_GenerateData_Last3Year] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_CPR_GenerateData_Last3Year] TO [DART_Role]
GO

