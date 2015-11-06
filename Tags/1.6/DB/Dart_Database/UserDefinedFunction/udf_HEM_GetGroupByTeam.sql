IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_HEM_GetGroupByTeam') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].udf_HEM_GetGroupByTeam
GO

/****** Object:  UserDefinedFunction [dbo].udf_HEM_GetGroupByTeam    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].udf_HEM_GetGroupByTeam(@Team varchar(20))
	returns varchar(20)	 
AS
	BEGIN
		RETURN CASE WHEN (RTRIM(ISNULL(@Team,''))='') OR @Team NOT LIKE 'hosp%'
						THEN 'Miscellaneous'
				WHEN PATINDEX('HEM%', @Team) = 0 
					THEN Left(UPPER(RTRIM(@Team)), 1) + Right(LOWER(RTRIM(@Team)), LEN(RTRIM(@Team))-1)
				ELSE SUBSTRING(Left(UPPER(RTRIM(@Team)), 1) + Right(LOWER(RTRIM(@Team)), LEN(RTRIM(@Team))-1), 1, 
						CASE WHEN PATINDEX('%[A-Z]%', SUBSTRING(RTRIM(@Team), 4, LEN(RTRIM(@Team)) - 3)) > 0 
								THEN (PATINDEX('%[A-Z]%', SUBSTRING(RTRIM(@Team), 4, LEN(RTRIM(@Team)) - 3)) + 2) 
							ELSE LEN(RTRIM(@Team))
						END)
				END
	END 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO