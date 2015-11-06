IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_TMF_GetGroupByTeam') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_TMF_GetGroupByTeam
GO

/****** Object:  UserDefinedFunction [dbo].udf_TMF_GetGroupByTeam    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].udf_TMF_GetGroupByTeam(@Team varchar(20))
	returns varchar(20)	 
AS
	BEGIN
		DECLARE @strReturn varchar(20)
		
		IF RTRIM(ISNULL(@Team, '')) = ''
		BEGIN
			SET @strReturn = 'Miscellaneous'
		END
		ELSE
		BEGIN
			SET @strReturn= REPLACE(@Team,'tmf','')
		END
			
		SELECT @strReturn =(case when PATINDEX('%[A-Z]%',@strReturn) >=2 
									then SUBSTRING(@strReturn,1,PATINDEX('%[A-Z]%',@strReturn)-1)
		ELSE @strReturn end)
		
		RETURN (case when PATINDEX('%[A-Z]%',@strReturn) <1
					then RTRIM(@strReturn) else 'Miscellaneous' 
				end)
	END 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO