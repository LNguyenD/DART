IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_TMF_GetGroupByTeam') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_TMF_GetGroupByTeam
GO

/****** Object:  UserDefinedFunction [dbo].udf_TMF_GetGroupByTeam    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
--select dbo.udf_TMF_GetGroupByTeam('fsdfsdf')
CREATE function [dbo].udf_TMF_GetGroupByTeam(@Team varchar(20))
	returns varchar(20)	 
AS
	BEGIN
		declare @strReturn varchar(20)
		
		if RTRIM(ISNULL(@Team, '')) = ''
			begin
				set @strReturn = 'Miscellaneous'
			end
		else
			begin
				set @strReturn= replace(@Team,'tmf','')
			end
		select @strReturn =(case when PATINDEX('%[A-Z]%',@strReturn) >=2 
					then substring(@strReturn,1,PATINDEX('%[A-Z]%',@strReturn)-1)
		else @strReturn end)		
	
		
		RETURN 	(case when PATINDEX('%[A-Z]%',@strReturn) <1
					then @strReturn
				else 'Miscellaneous' end)	
	END 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


GO
GRANT  EXECUTE  ON [dbo].udf_TMF_GetGroupByTeam TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_TMF_GetGroupByTeam TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_TMF_GetGroupByTeam TO [DART_Role]
GO