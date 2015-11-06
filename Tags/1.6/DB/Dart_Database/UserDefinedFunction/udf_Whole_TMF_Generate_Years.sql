IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Whole_TMF_Generate_Years]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_Whole_TMF_Generate_Years]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_Whole_TMF_Generate_Years]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_Whole_TMF_Generate_Years](@Type varchar(20))
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
			,Transaction_Date = temp.Time_Id
		    ,[Type] = 'Actual'
		    ,No_of_Active_Weekly_Claims = 0
	from temp
	cross join
	(
		SELECT  distinct 
		case
			when @Type = 'tmf' then 'TMF' 
			when @Type = 'agency' then RTRIM(ISNULL(sub.AgencyName,'Miscellaneous'))
			when @Type = 'sub_category' then RTRIM(ISNULL(sub.Sub_Category,'Miscellaneous'))
			when @Type = 'team' then RTRIM(Team)
			else dbo.udf_TMF_GetGroupByTeam(Team) end as Unit,
		case 
			when @Type = 'tmf' then 'TMF'
			when @Type = 'agency' then RTRIM(ISNULL(sub.AgencyName,'Miscellaneous'))
			when @Type = 'sub_category' then RTRIM(ISNULL(sub.AgencyName,'Miscellaneous'))
			when @Type = 'team' then dbo.udf_TMF_GetGroupByTeam(Team)
			else dbo.udf_TMF_GetGroupByTeam(Team) end as [Primary]
		from TMF_AWC awc left join TMF_Agencies_Sub_Category sub on awc.POLICY_NO = sub.POLICY_NO
	) as uv_Unit	
)
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO