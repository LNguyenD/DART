/****** Object:  UserDefinedFunction [dbo].[udf_ExtractMedCertStatus_Code]    Script Date: 02/21/2013 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_ExtractMedCertStatus_Code]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_ExtractMedCertStatus_Code]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_ExtractMedCertStatus_Code]    Script Date: 02/21/2013 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_ExtractMedCertStatus_Code](@Med_Cert_Type char)
RETURNS varchar (20) 
AS 
BEGIN
	return (CASE WHEN @Med_Cert_Type = 'T' THEN 'TU'
			WHEN @Med_Cert_Type = 'S' THEN 'SID'
			WHEN @Med_Cert_Type = 'P' THEN 'UNK'
			WHEN @Med_Cert_Type = 'M' THEN 'PMD'
			WHEN @Med_Cert_Type = 'I' THEN 'PID' ELSE 'Nil TL' END)
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus_Code] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus_Code] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus_Code] TO [DART_Role]
GO