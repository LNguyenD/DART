/****** Object:  UserDefinedFunction [dbo].[udf_GetMechanismGroup]    Script Date: 12/29/2011 09:31:35 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_GetMechanismGroup]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_GetMechanismGroup]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetMechanismGroup]    Script Date: 12/29/2011 09:31:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[udf_GetMechanismGroup](@Mechanism_of_Injury tinyint)
	returns varchar(300)
as
begin
	return 
			CASE WHEN @Mechanism_of_Injury IN (1, 2, 3) THEN 'Falls/Trips/Slips'
				WHEN @Mechanism_of_Injury IN (11, 12, 13) THEN 'Hitting object with a part ob body'
				WHEN @Mechanism_of_Injury IN (21, 22, 23, 24, 25, 26, 27, 28, 29) THEN 'Being hit by moving objects'
				WHEN @Mechanism_of_Injury IN (31, 32, 38, 39) THEN 'Sound and Pressure'
				WHEN @Mechanism_of_Injury IN (41, 42, 43, 44) THEN 'Body Stressing'
				WHEN @Mechanism_of_Injury IN (51, 52, 53, 54, 55, 56, 57, 58, 59) THEN 'Heat, Electricity and other environmental factors'
				WHEN @Mechanism_of_Injury IN (61, 62, 63, 64, 69) THEN 'Checmicals and other subtances'
				WHEN @Mechanism_of_Injury IN (71, 72, 79) THEN 'Biological factors'
				WHEN @Mechanism_of_Injury IN (81, 82, 84, 85, 86, 87, 88) THEN 'Mental Stess'
				WHEN @Mechanism_of_Injury IN (91, 92, 93, 98, 99) THEN 'Vehicle incidents and other' 
			END			
end

GO

GRANT  EXECUTE  ON [dbo].[udf_GetMechanismGroup]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[udf_GetMechanismGroup]  TO [emius]
GO