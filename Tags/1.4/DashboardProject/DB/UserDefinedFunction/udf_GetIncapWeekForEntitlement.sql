IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetIncapWeekForEntitlement]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetIncapWeekForEntitlement]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetIncapWeekForEntitlement]    Script Date: 08/11/2014 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_GetIncapWeekForEntitlement](@IncapWeekStart DATETIME, @IncapWeekEnd DATETIME)    
RETURNS Int As
BEGIN
	DECLARE @NoOfWeeks INT
	SET @NoOfWeeks = ISNULL(DATEDIFF(WEEK, @IncapWeekStart, @IncapWeekEnd), 0)
	
	DECLARE @k INT
	SET @k = -1
			
	DECLARE @i INT
	SET @i = 0
	
	WHILE (@i <= @NoOfWeeks)
	BEGIN
		IF @IncapWeekStart + 7 * @i <= @IncapWeekEnd
		BEGIN
			SET @k = @i
		END
		SET @i = @i + 1
	END
	
	RETURN @k
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

GRANT  EXECUTE  ON [dbo].[udf_GetIncapWeekForEntitlement] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_GetIncapWeekForEntitlement] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_GetIncapWeekForEntitlement] TO [DART_Role]
GO