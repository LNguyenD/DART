/****** Object:  UserDefinedFunction [dbo].[udf_GetReOpenReasonDesc]    Script Date: 12/29/2011 09:31:00 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_GetReOpenReasonDesc]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_GetReOpenReasonDesc]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetReOpenReasonDesc]    Script Date: 12/29/2011 09:31:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[udf_GetReOpenReasonDesc](@ReasonCode smallint)
	returns nvarchar(200)
as
begin
	return (
	CASE @ReasonCode 
		when 0
			then   '0 Not applicable - claim has not been re-opened'
		when 1
			then '1 Recurrence of original injury'
		when 2
			then  '2 Further paymnts / recov(incl. paymnts under prov.liab)'
		when 3
			then '3 Litigation'
		when 4
			then  '4 Claim administration purposes'
		when 5
			then '5 Prov.liability discontinued, claim subsequently lodged'
		when 6
			then '6 Reasonable excuse given, claim subsequently lodged'				
		ELSE
			 ''
	END 
	)
end
GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetReOpenReasonDesc]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetReOpenReasonDesc]  TO [emius]
GO