/****** Object:  UserDefinedFunction [dbo].[udf_Get_Result_Of_Injury_Code]    Script Date: 01/16/2012 13:39:52 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_Get_Result_Of_Injury_Code]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_Get_Result_Of_Injury_Code]
GO

SET ANSI_NULLS ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[udf_Get_Result_Of_Injury_Code](@result_of_injury_code tinyint)
	returns varchar(50)
as
begin
return (CASE WHEN  @result_of_injury_code = 1 THEN 'Death'
		 WHEN  @result_of_injury_code = 2 THEN 'Permanent Total Disability'
		 WHEN  @result_of_injury_code = 3 THEN 'Permanent Partial  Disability'
		 WHEN  @result_of_injury_code = 4 THEN 'Temporary Disability' END)
end

GO
GRANT  EXECUTE  ON [dbo].[udf_Get_Result_Of_Injury_Code]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_Get_Result_Of_Injury_Code]  TO [emius]
GO