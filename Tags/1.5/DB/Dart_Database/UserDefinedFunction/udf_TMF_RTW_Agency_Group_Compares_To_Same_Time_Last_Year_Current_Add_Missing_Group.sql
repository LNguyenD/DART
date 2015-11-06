IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group]    Script Date: 12/30/2013 17:12:04 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_TMF_RTW_Agency_Group_Compares_To_Same_Time_Last_Year_Current_Add_Missing_Group]()
RETURNS TABLE 
AS
RETURN 
(	
    select * from 
	(
	select Month_period = 1
	union select Month_period =3
	union select Month_period =6
	union select Month_period =12
	) as tmp1
	cross join
	(

	select Measure_months =13
	union select Measure_months =26
	union select Measure_months =52
	union select Measure_months =78
	union select Measure_months =104) as tmp2

	cross join
	(
	select [type]='group'  ,Agency_Group  ='4' ,LT=0,WGT  =0   ,AVGDURN   =0   ,[Target] = 0
	union select [type]='group'  ,Agency_Group  ='6' ,LT=0,WGT  =0   ,AVGDURN   =0   ,[Target] = 0
	union select [type]='group'  ,Agency_Group  ='9' ,LT=0,WGT  =0   ,AVGDURN   =0   ,[Target] = 0
	) as tmp3
)

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
