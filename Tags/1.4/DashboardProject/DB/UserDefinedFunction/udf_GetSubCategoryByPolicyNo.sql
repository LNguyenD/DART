IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetSubCategoryByPolicyNo') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetSubCategoryByPolicyNo
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetSubCategoryByPolicyNo    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
--select dbo.udf_GetSubCategoryByPolicyNo('fsdfsdf')
CREATE function [dbo].udf_GetSubCategoryByPolicyNo(@Policy_no char(19))
	returns varchar(256)
as
	BEGIN
		declare @sub_category varchar(256)
		select @sub_category =  sub_category from dbo.TMF_Agencies_Sub_Category where Policy_no = @Policy_no	
		RETURN 	isnull(@sub_category,'Miscellaneous')		
	END 

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


GO
GRANT  EXECUTE  ON [dbo].udf_GetSubCategoryByPolicyNo TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_GetSubCategoryByPolicyNo TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_GetSubCategoryByPolicyNo TO [DART_Role]
GO