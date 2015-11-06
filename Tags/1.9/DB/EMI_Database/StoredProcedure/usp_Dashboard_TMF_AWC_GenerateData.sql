SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_TMF_AWC_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_TMF_AWC_GenerateData]
Go
-- For example
-- exec [usp_Dashboard_TMF_AWC_GenerateData] 2011, 1
-- this will return all result with time id range from 2011-01-31 23:59 till now

CREATE PROCEDURE [dbo].[usp_Dashboard_TMF_AWC_GenerateData]
	@start_period_year int = 2012,
	@start_period_month int = 10
AS
BEGIN
	SET NOCOUNT ON;
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) 
											+ '/' + CAST(@start_period_month as varchar) 
											+ '/01' as datetime)	
	declare @end_period datetime = getdate()
	
	declare @loop_time int = DATEDIFF(month, @start_period, @end_period)
	declare @i int = @loop_time 
	declare @temp datetime
	declare @SQL varchar(500)

	---delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[TMF_AWC] 
			WHERE Time_ID in (select distinct top 3 Time_ID 
			from [DART].[dbo].[TMF_AWC] order by Time_ID desc)')
	---end delete--	
	
	--Check temp table existing then drop	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL DROP TABLE #_CLAIM_ESTIMATE_SUMMARY
		
	CREATE TABLE #_CLAIM_ESTIMATE_SUMMARY
	(
		CLAIM_NO varCHAR(19)
		,TotalAmount MONEY
	) 
	
	SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		 
	INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
	SELECT CLAIM_NO, SUM(ISNULL(Amount, 0)) FROM ESTIMATE_DETAILS GROUP BY claim_no	
	
	WHILE (@i >= 0)
	BEGIN
		set @temp = DATEADD(mm, @i, @start_period)
		declare @year int = YEAR(@temp)
		declare @month int = MONTH(@temp)
		
		If NOT EXISTS(select 1 from [DART].[dbo].[TMF_AWC] 
							where Year(Time_ID) = @year and
							Month(Time_ID ) = @month)
		   AND cast(CAST(@year as varchar) + '/' +  CAST(@month as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN		
			print @temp
			--DELETE FROM dbo.TMF_AWC WHERE Time_ID = DATEADD(dd, -1, DATEADD(mm, 1, @temp)) + '23:59'
			--INSERT INTO dbo.TMF_AWC EXEC usp_Dashboard_TMF_AWC @year, @month
			INSERT INTO [DART].[dbo].[TMF_AWC] EXEC usp_Dashboard_TMF_AWC @year, @month
			
		END
		set @i = @i - 1
	END
	--drop temp table 	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL drop table #_CLAIM_ESTIMATE_SUMMARY
	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC_GenerateData] TO [DART_Role]
GO