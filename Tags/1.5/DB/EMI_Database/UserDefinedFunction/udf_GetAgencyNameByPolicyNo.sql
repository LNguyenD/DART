IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetAgencyNameByPolicyNo') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetAgencyNameByPolicyNo
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetAgencyNameByPolicyNo    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
--select dbo.udf_GetAgencyNameByPolicyNo('gdfgdfg')
CREATE function [dbo].udf_GetAgencyNameByPolicyNo(@Policy_no char(19))
	returns char(20)
as
begin
	declare @AgencyName char(20)
	select @AgencyName =  AgencyName from dbo.TMF_Agencies_Sub_Category where Policy_no = @Policy_no	
	RETURN 	rtrim(isnull(@AgencyName,'Miscellaneous'))	
end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


GO
GRANT  EXECUTE  ON [dbo].udf_GetAgencyNameByPolicyNo TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_GetAgencyNameByPolicyNo TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_GetAgencyNameByPolicyNo TO [DART_Role]
GO