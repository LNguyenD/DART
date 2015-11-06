IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_HEM_AWC_Generate_Time_ID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_HEM_AWC_Generate_Time_ID]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_HEM_AWC_Generate_Time_ID]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_HEM_AWC_Generate_Time_ID](@Type varchar(20),@WeeklyType varchar(20))
RETURNS TABLE 
AS
RETURN 
(	
    WITH temp AS
	(
		--SELECT CAST('01/01/' + cast(year(getdate()) AS varchar(4)) + ' 23:59' AS DATETIME) Time_Id
		--UNION ALL
		--SELECT DATEADD(m, 1, Time_Id)
		--FROM temp WHERE Time_Id < CAST('06/01/' + cast(year(getdate())+1 AS varchar(4)) + ' 23:59' AS DATETIME)
		SELECT CAST('01/01/' + cast(year(getdate()) AS varchar(4)) AS DATETIME) Time_Id
		UNION ALL
		SELECT DATEADD(m, 1, Time_Id)
		FROM temp WHERE Time_Id < CAST('06/01/' + cast(year(getdate())+1 AS varchar(4)) AS DATETIME)
	)

	select  [Type] =@Type
			,uv_Unit.Unit
			,uv_Unit.[Primary]
			,WeeklyType = @WeeklyType
			--,Time_Id =temp.Time_Id
			,Time_Id = dateadd(dd, -1, dateadd(mm, 1, temp.Time_Id)) + '23:59'
		    ,Month_Year = LEFT(datename(month, Time_Id), 3) + '-' 
							+ RIGHT(datename(year, Time_Id), 2)
		    ,Actual = 0
		    ,Projection =(select ISNULL(sum(Projection), 0)
								 from dbo.hem_awc_Projections 
								 where [Type] =@WeeklyType 
								 and Unit_Type=@Type 
								 and RTRIM(Unit_Name)=uv_Unit.Unit 
								 and year(Time_Id)=Year(temp.Time_Id) 
								 and month(Time_Id)=month(temp.Time_Id))
	from temp
	cross join
	(
		SELECT  distinct 
			case 
				when @Type = 'hem' then 'HEM'
				when @Type = 'portfolio' then RTRIM(Portfolio)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then RTRIM(Team)
				when @Type = 'am_empl_size' then RTRIM(Empl_Size)
				when @Type = 'portfolio_empl_size' then RTRIM(Empl_Size)
				else dbo.udf_HEM_GetGroupByTeam(Team) end as Unit,
			case 
				when @Type = 'hem' then 'HEM'
				when @Type = 'portfolio' then RTRIM(Portfolio)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then dbo.udf_HEM_GetGroupByTeam(Team)
				when @Type = 'am_empl_size' then RTRIM(Account_Manager)
				when @Type = 'portfolio_empl_size' then RTRIM(Portfolio)
				else dbo.udf_HEM_GetGroupByTeam(Team) end as [Primary]
		FROM   hem_awc 
	) as uv_Unit
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
