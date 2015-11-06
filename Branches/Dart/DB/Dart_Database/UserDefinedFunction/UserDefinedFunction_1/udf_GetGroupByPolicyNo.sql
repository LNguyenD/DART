IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetGroupByPolicyNo') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetGroupByPolicyNo
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetGroupByPolicyNo    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
--select dbo.udf_GetGroupByPolicyNo('fsdfsdf')
CREATE function [dbo].udf_GetGroupByPolicyNo(@Policy_no char(19))
	returns varchar(20)	 
AS
	BEGIN
		declare @Group char(20)
		select @Group =  [Group] from dbo.TMF_Agencies_Sub_Category where Policy_no = @Policy_no	
		RETURN 	rtrim(isnull(@Group,'Miscellaneous'))		
	END 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


GO
