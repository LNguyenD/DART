/****** Object:  UserDefinedFunction [dbo].[udf_GetClientReviewNote]    Script Date: 03/08/2012 14:05:31 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_GetClientReviewNote]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_GetClientReviewNote]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetClientReviewNote]    Script Date: 03/08/2012 14:05:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_GetClientReviewNote]
(
	@Claim_no varchar(25)
)
RETURNS varchar(2000)
AS
BEGIN
	declare @textptr varchar(100)

	SELECT @textptr = text_ptr
	FROM pending_events
	where event_group = 'ima'
	and event_class = 'IMAPLANREV'
	and event_type = 'IMAREV'
	and object_type = 'claim'
	and ref_no = @Claim_no

	DECLARE @SQLString NVARCHAR(500)
	DECLARE @Result NVARCHAR(2000)
	Set @Result = ''
	SELECT @Result = @Result + data FROM Clm_Memo WHERE id =  CONVERT(VARCHAR(20), @textptr)
	ORDER BY Page_No
	
	return @Result
	
END

GO

GRANT  EXECUTE  ON [dbo].[udf_GetClientReviewNote]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetClientReviewNote]  TO [emius]
GO
