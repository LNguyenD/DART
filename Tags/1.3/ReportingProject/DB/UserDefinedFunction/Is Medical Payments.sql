/****** Object:  UserDefinedFunction [dbo].[udf_IsMedicalPayment]    Script Date: 04/06/2012 08:46:09 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_IsMedicalPayment]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_IsMedicalPayment]
GO


/****** Object:  UserDefinedFunction [dbo].[udf_IsMedicalPayment]    Script Date: 04/06/2012 08:46:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_IsMedicalPayment]
(
	@Payment_type varchar(8)
)
RETURNS bit
AS
BEGIN

	RETURN CASE WHEN left(@Payment_type, 3) in ('CHA', 'CHX', 'DEN', 'EPA', 'HVM', 'OPT', 'OSA', 
												'OSX', 'OTT', 'PTA', 'PTX','RMA', 'RMX',
												 'WCO') 
						or @Payment_type in (	'AID001', 'COU001', 'DOA001', 'DOA002', 'MOB001', 'NUR001', 
												'OAD001', 'OAS001', 'OSA002',  'PCA001',
												'PHS001', '') THEN 1 ELSE 0 END

END

GO

GRANT  CONTROL ON [dbo].[udf_IsMedicalPayment]  TO [EMICS]
GO
 
GRANT  CONTROL ON [dbo].[udf_IsMedicalPayment]  TO [emius]
GO