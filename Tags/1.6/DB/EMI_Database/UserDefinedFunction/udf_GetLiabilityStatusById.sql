/****** Object:  UserDefinedFunction [dbo].[udf_GetLiabilityStatusById]    Script Date: 02/21/2013 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetLiabilityStatusById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetLiabilityStatusById]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetLiabilityStatusById]    Script Date: 02/21/2013 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_GetLiabilityStatusById](@Liability_Status smallint)
	returns nvarchar(256)
as
BEGIN
	return CASE WHEN @Liability_Status = 1 then 'Notification of work related injury'
				WHEN @Liability_Status =2 then 'Liability accepted'
				WHEN @Liability_Status =5 then 'Liability not yet determined'
				WHEN @Liability_Status =6 then 'Administration error'
				WHEN @Liability_Status =7 then 'Liability denied'
				WHEN @Liability_Status =8 then 'Provisional liability accepted - weekly and medical payments'
				WHEN @Liability_Status =9 then 'Reasonable excuse'
				WHEN @Liability_Status =10 then 'Provisional liability discontinued'
				WHEN @Liability_Status =11 then 'Provisional liability accepted - medical only, weekly payments not applicable'
				WHEN @Liability_Status =12 then 'No action after notification'
				ELSE ''
			END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_GetLiabilityStatusById] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_GetLiabilityStatusById] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_GetLiabilityStatusById] TO [DART_Role]
GO