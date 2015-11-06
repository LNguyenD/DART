/****** Object:  UserDefinedFunction [dbo].[udf_GetAccidentLocationDesc]    Script Date: 04/16/2012 15:59:32 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_GetAccidentLocationDesc]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_GetAccidentLocationDesc]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetAccidentLocationDesc]    Script Date: 04/16/2012 15:59:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create function [dbo].[udf_GetAccidentLocationDesc](@Code tinyint)
	returns nvarchar(256)
as
begin
return 
	CASE @Code
		When 0 then	 ''
		When 1 then	 'Normal Workplace'
		When 2 then  'Other Private Workplace'
		When 3 then	 'Construction site'
		When 4 then	 'Public thoroughfares'
		When 5 then	 'Moving transport'
		When 99 then  'Other'	
		When -1 then			
			char(9)+'0'+'/'
			+'Nomal Workplace 1'+'/'
			+'Other Private Workplace 2 /'
			+'Construction site 3 /'
			+'Public thoroughfares 4 /'
			+'Moving transport 5 /'
			+'Other 99'			
		ELSE  '' 
	END
end

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetAccidentLocationDesc]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetAccidentLocationDesc]  TO [emius]
GO
