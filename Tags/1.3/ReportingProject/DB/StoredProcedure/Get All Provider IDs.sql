/****** Object:  StoredProcedure [dbo].[usp_GetAllProviderIDs]    Script Date: 03/12/2012 16:44:34 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_GetAllProvider]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[usp_GetAllProvider]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllProvider]    Script Date: 03/12/2012 16:44:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetAllProvider]
	@Name varchar(100),
	@ClaimNumber varchar(30)
AS
BEGIN
	DECLARE @Sql varchar(8000)
	SET @Sql = 
	case when @ClaimNumber is null or @ClaimNumber = '' 
	then 
		'select WCRegNo = wc_reg_no, FirstName = firstname, LastName = lastname, Type = type,	
						OrganisationName = organisation_name
			from uvPROVIDER'
	else 'select distinct WCRegNo = wc_reg_no, FirstName = firstname, LastName = lastname, Type = type,	
						OrganisationName = organisation_name
			from uvPAYMENT_RECOVERY PR JOIN uvPROVIDER p on PR.wc_service_provider_id = p.wc_reg_no				
			where Claim_No = ''' + @ClaimNumber + ''''
			
	end
	set @Sql = @Sql + case when @ClaimNumber is null or @ClaimNumber = '' then ' where is_deleted <> 1'
							else ' AND is_deleted <> 1' end
				+ case when @Name is null or @Name = '' then '' else ' AND (lastname like ''%' + @Name + '%'' OR organisation_name like ''%' + @Name + '%'')' end								
	EXEC (@Sql)	
	--print @Sql
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetAllProvider]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GetAllProvider]  TO [emius]
GO


--exec usp_GetAllProvider 'kim', ''

