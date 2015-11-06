/****** Object:  UserDefinedFunction [dbo].[udf_ExtractMedCertStatus]    Script Date: 02/21/2013 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_ExtractMedCertStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_ExtractMedCertStatus]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_ExtractMedCertStatus]    Script Date: 02/21/2013 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_ExtractMedCertStatus](@Med_Cert_Type char)
RETURNS varchar (20) 
AS 
BEGIN
	return (CASE WHEN @Med_Cert_Type = 'T' THEN 'Totally Unfit'
			WHEN @Med_Cert_Type = 'S' THEN 'Suitable Duties'
			WHEN @Med_Cert_Type = 'P' THEN 'No Time Lost'
			WHEN @Med_Cert_Type = 'M' THEN 'Permanently Modified Duties' ELSE 'Pre-Injury Duties' END)
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus] TO [DART_Role]
GO