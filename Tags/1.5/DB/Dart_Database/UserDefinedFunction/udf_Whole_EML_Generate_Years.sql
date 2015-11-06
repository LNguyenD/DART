IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Whole_EML_Generate_Years]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_Whole_EML_Generate_Years]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_Whole_EML_Generate_Years]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_Whole_EML_Generate_Years](@Type varchar(20))
RETURNS TABLE 
AS
RETURN 
(	
    WITH temp AS
	(
		SELECT CAST(CAST(MONTH(getdate()) as varchar(2)) + '/01/2005 23:59' as Datetime) Time_Id
		UNION ALL
		SELECT DATEADD(YEAR,1, Time_Id)
		FROM temp WHERE year(Time_Id) < YEAR(getdate()) - 1
	)
	select  [UnitType] =@Type
			,uv_Unit.Unit
			,uv_Unit.[Primary]
			,Transaction_Year = temp.Time_Id
		    ,[Type] = 'Actual'
		    ,No_of_Active_Weekly_Claims = 0
	from temp
	cross join
	(
		SELECT  distinct 
			case 
				when @Type = 'eml' then 'EML'
				when @Type = 'employer_size' then RTRIM(Empl_Size)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then RTRIM(Team)
				when @Type = 'am_empl_size' then RTRIM(Empl_Size)
				else RTRIM([Group]) end as Unit,
			case 
				when @Type = 'eml' then 'EML'
				when @Type = 'employer_size' then RTRIM(Empl_Size)
				when @Type = 'account_manager' then RTRIM(Account_Manager)
				when @Type = 'team' then RTRIM([Group])
				when @Type = 'am_empl_size' then RTRIM(Account_Manager)
				else RTRIM([Group]) end as [Primary]
		FROM   eml_awc where RTRIM(Account_Manager) is not null
	) as uv_Unit
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
