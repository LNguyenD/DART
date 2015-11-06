/****** Object:  StoredProcedure [dbo].[usp_GetAllCreditors]    Script Date: 03/12/2012 16:44:34 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_GetAllCreditors]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_GetAllCreditors]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllCreditors]    Script Date: 03/12/2012 16:44:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetAllCreditors]
	@Name varchar(150) = '',
	@ABN float = 0,
	@WCProviderCode varchar(20) = '',
	@HCNo char(8) = '',
	@ClaimNumber varchar(30) = ''
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Sql varchar(8000)
	SET @Sql = 
	case when @ClaimNumber is null or @ClaimNumber = '' 
	then 
		'select CreditorNo = CR.Creditor_no, Name = CR.Name, ABN = CR.ABN, AKA = CR.AKA, 
					WCProviderCode = CR.WC_Provider_Code, HCNo = CR.HC_Number
			from uvCREDITOR CR'
	else 'select CreditorNo = CR.Creditor_no, Name = CR.Name, ABN = CR.ABN, AKA = CR.AKA, 
					WCProviderCode = CR.WC_Provider_Code, HCNo = CR.HC_Number
			from uvPAYMENT_RECOVERY PR JOIN uvCREDITOR CR on CR.cid = PR.cid
			where Claim_No = ''' + @ClaimNumber + ''''
			
	end
	set @Sql = @Sql + case when @ClaimNumber is null or @ClaimNumber = '' then ' where CR.is_deleted <> 1 AND CR.Inactive <> 1'
							else ' AND CR.is_deleted <> 1 AND CR.Inactive <> 1' end
				+ case when @Name is null or @Name = '' then '' else ' AND (Name like ''%' + @Name + '%'' OR AKA like ''%' + @Name + '%'')' end
				+ case when @ABN is null or @ABN = 0 then '' else 'AND ABN = ' + convert(varchar, @ABN) end
				+ case when @WCProviderCode is null or @WCProviderCode = '' then '' else ' AND WC_Provider_Code like ''%' + @WCProviderCode + '%''' end
				+ case when @HCNo is null or @HCNo = '' then '' else ' AND HC_Number like ''%' + @HCNo + '%''' end
	--print @Sql		
	EXEC (@Sql)
	
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetAllCreditors]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetAllCreditors]  TO [emius]
GO

--exec usp_GetAllCreditors  '', 0, '', '', '44880eml'

