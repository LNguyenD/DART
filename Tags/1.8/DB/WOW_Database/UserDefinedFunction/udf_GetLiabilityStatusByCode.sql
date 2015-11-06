/****** Object:  UserDefinedFunction [dbo].[udf_GetLiabilityStatusByCode]    Script Date: 07/27/2015 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetLiabilityStatusByCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetLiabilityStatusByCode]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetLiabilityStatusByCode]    Script Date: 07/27/2015 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_GetLiabilityStatusByCode](@Code varchar(5))
	RETURNS nvarchar(256)
AS
BEGIN
	RETURN (case @Code
				when 'ACPOR' then 'Liability accepted - Originally Rejected'
				when 'ACPTD' then 'Liability accepted'
				when 'ADERR' then 'Administration error'
				when 'LDENY' then 'Liability denied'
				when 'LDYOA' then 'Liability denied - Originally Accepted'
				when 'NOACT' then 'No action after notification'
				when 'NOTDT' then 'Liability not yet determined'
				when 'NOTFY' then 'Notification of work related injury'
				when 'PAMO' then 'Provisional liability accepted - medical only, weekly payments not applicable'
				when 'PAWM' then 'Provisional liability accepted - weekly and medical payments'
				when 'PDISC' then 'Provisional liability discontinued'
				when 'REXCS' then 'Reasonable excuse'
				else ''
			end)
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO