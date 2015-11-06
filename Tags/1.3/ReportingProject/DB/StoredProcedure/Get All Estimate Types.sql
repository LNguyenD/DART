/****** Object:  StoredProcedure [dbo].[usp_GetAllEstimateTypes]    Script Date: 03/12/2012 16:44:34 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_GetAllEstimateTypes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_GetAllEstimateTypes]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllEstimateTypes]    Script Date: 03/12/2012 16:44:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetAllEstimateTypes]
	@ClaimNumber varchar(30) =''
AS
BEGIN
	DECLARE @Sql varchar(8000)
	SET @Sql = (Case when @ClaimNumber is null or @ClaimNumber = '' then 
	'SELECT EstimateType = Estimate_type FROM [ESTIMATE_TYPES]'
	Else 'SELECT distinct EstimateType = Estimate_type
		FROM Payment_Recovery
		WHERE Claim_No = ''' + @ClaimNumber + '''' END)
	--print @Sql
	EXEC (@Sql)
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetAllEstimateTypes]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetAllEstimateTypes]  TO [emius]
GO
