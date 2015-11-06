/****** Object:  UserDefinedFunction [dbo].[udf_IsWagePayment]    Script Date: 04/06/2012 08:46:09 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_IsWagePayment]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_IsWagePayment]
GO


/****** Object:  UserDefinedFunction [dbo].[udf_IsWagePayment]    Script Date: 04/06/2012 08:46:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_IsWagePayment]
(
	@Payment_type varchar(8)
)
RETURNS bit
AS
BEGIN

	RETURN CASE WHEN left(@Payment_type, 3) in ('WPP', 'WPT') THEN 1 ELSE 0 END

END

GO


GRANT  CONTROL ON [dbo].[udf_IsWagePayment]  TO [EMICS]
GO
 
GRANT  CONTROL ON [dbo].[udf_IsWagePayment]  TO [emius]
GO



