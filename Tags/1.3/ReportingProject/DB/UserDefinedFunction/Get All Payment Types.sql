/****** Object:  StoredProcedure [dbo].[usp_GetAllPaymentTypes]    Script Date: 03/12/2012 16:44:34 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_GetAllPaymentTypes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_GetAllPaymentTypes]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllPaymentTypes]    Script Date: 03/12/2012 16:44:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetAllPaymentTypes]
	@PaymentType varchar(15),
	@Description varchar(100),
	@ClaimNumber varchar(30)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Sql varchar(8000)
	SET @Sql = 
	case when @ClaimNumber is null or @ClaimNumber = '' 
	then 
		'select Type = PT.Payment_Type, Description = PD.Description
			from uvPAYMENT_TYPE PT JOIN uvPAYMENT_DESCRIPTION PD on PT.Payment_Type = PD.Payment_Type'
	else 'select distinct Type = PT.Payment_Type, Description = PD.Description
			from uvPAYMENT_RECOVERY PR JOIN uvPAYMENT_TYPE PT on PT.Payment_Type = PR.Payment_Type
				JOIN Payment_Description PD on PT.Payment_Type = PD.Payment_Type
			where Claim_No = ''' + @ClaimNumber + ''''
			
	end
	set @Sql = @Sql + case when @ClaimNumber is null or @ClaimNumber = '' then ' where PT.Active_From_Date < GETDATE()
                                    AND (PT.Active_To_Date is null OR PT.Active_To_Date >= GETDATE()) '
							else ' AND PT.Active_From_Date < GETDATE()
                                    AND (PT.Active_To_Date is null OR PT.Active_To_Date >= GETDATE())' end
				+ case when @PaymentType is null or @PaymentType = '' then '' else ' AND PT.Payment_Type like ''%' + @PaymentType + '%''' end				
				+ case when @Description is null or @Description = '' then '' else ' AND PD.Description like ''%' + @Description + '%''' end				
	EXEC (@Sql)	
	--PRINT @Sql
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetAllPaymentTypes]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetAllPaymentTypes]  TO [emius]
GO



--exec usp_GetAllPaymentTypes '', '', '00001502/01122'

