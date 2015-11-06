/****** Object:  UserDefinedFunction [dbo].[udf_ExtractGroup]    Script Date: 12/29/2011 09:31:00 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_ExtractGroup]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_ExtractGroup]
GO


/****** Object:  UserDefinedFunction [dbo].[udf_ExtractGroup]    Script Date: 12/29/2011 09:31:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[udf_ExtractGroup](@grp varchar(20))
	returns varchar(20)
as
begin
	return CASE WHEN LEFT(@grp, 1) IN ('1', '2', 'G', 'N', 'P') and @grp <> 'NoGroup' THEN LEFT(@grp, 1)
				WHEN LEFT(@grp, 3) IN ('SET') THEN LEFT(@grp, 3)
				WHEN LEFT(@grp, 4) IN ('RIG1', 'RIG4', 'RIG5', 'RIG6', 'RIG7', 'TMF1', 'TMF2', 'TMF3', 'TMF4', 'TMF5', 'TMF6', 'TMF7', 'TMF8') THEN LEFT(@grp, 4)
				WHEN @grp = 'HEM' then 'HEM'
				WHEN @grp = 'HEM1' then 'HEM1'
				ELSE 'OTHERS'
			END
end
GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[udf_ExtractGroup]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_ExtractGroup]  TO [emius]
GO