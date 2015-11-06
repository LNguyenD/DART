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
	RETURN (case @Med_Cert_Type
				when 'A' then 'Pre injury duties'
				when 'F' then 'Fit'
				when 'P' then 'Partial'
				when 'U' then 'Totally unfit'
				else ''
			end)
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO