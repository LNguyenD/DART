/****** Object:  UserDefinedFunction [dbo].[udf_IsWeeklyOrWagePayment]    Script Date: 04/05/2012 17:03:44 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_IsWeeklyOrWagePayment]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_IsWeeklyOrWagePayment]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_IsWeeklyOrWagePayment]    Script Date: 04/05/2012 17:03:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_IsWeeklyOrWagePayment]
(
	@Payment_type varchar(8)
)
RETURNS bit
AS
BEGIN

	RETURN CASE WHEN left(@Payment_type, 3) in ('WPP', 'WPT') THEN 1 ELSE 0 END

END

GO



GRANT  CONTROL ON [dbo].[udf_IsWeeklyOrWagePayment]  TO [EMICS]
GO
 
GRANT  CONTROL ON [dbo].[udf_IsWeeklyOrWagePayment]  TO [emius]
GO

