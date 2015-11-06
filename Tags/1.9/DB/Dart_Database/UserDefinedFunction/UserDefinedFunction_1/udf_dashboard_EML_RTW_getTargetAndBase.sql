/****** Object:  UserDefinedFunction [dbo].[udf_dashboard_EML_RTW_getTargetAndBase]    Script Date: 02/21/2013 11:06:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_dashboard_EML_RTW_getTargetAndBase]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_dashboard_EML_RTW_getTargetAndBase]
GO


/****** Object:  UserDefinedFunction [dbo].[udf_dashboard_EML_RTW_getTargetAndBase]    Script Date: 02/21/2013 11:06:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

create FUNCTION [dbo].[udf_dashboard_EML_RTW_getTargetAndBase](@rem_end datetime, @item varchar(20), @type varchar(20), @value varchar(20), @sub_value varchar(20), @measure int)
	returns FLOAT
as
BEGIN
	Declare @target float,@base float, @count int
	
	SELECT  @target = min(isnull(tb.[Target], 0)),@base = min(isnull(tb.[base], 0)),@count = count(*)
	FROM [EML_RTW_Target_Base] tb 
	WHERE 
	(([Type] = @type AND [Value] = @value)
	OR ([Value] = @value AND @value = 'eml'))
	AND ISNULL([Sub_Value], '') = ISNULL(@sub_value, '')
	AND [Measure] = @measure and Remuneration= (cast(year(@rem_end) AS varchar) 
                      + 'M' + CASE WHEN MONTH(@rem_end) <= 9 THEN '0' ELSE '' END 
                      + cast(month(@rem_end) AS varchar))	
	
	IF @COUNT = 0 OR @target = 0 OR @base = 0
	BEGIN		
		SELECT @target = min(tb.[Target]), @base = min(tb.[base])
		FROM [EML_RTW_Target_Base] tb 
		WHERE [Value] = 'eml'		
		AND [Measure] = @measure and Remuneration= (cast(year(@rem_end) AS varchar) 
                      + 'M' + CASE WHEN MONTH(@rem_end) <= 9 THEN '0' ELSE '' END 
                      + cast(month(@rem_end) AS varchar))						
	END
	
	IF @item = 'target' 
	BEGIN
		RETURN @target
	END 

	IF @item = 'base' 
	BEGIN
		RETURN @base
	END
	RETURN 0
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
