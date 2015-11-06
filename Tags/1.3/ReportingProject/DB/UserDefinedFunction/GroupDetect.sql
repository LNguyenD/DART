IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_GroupDetect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GroupDetect]
GO


/****** Object:  StoredProcedure [dbo].[usp_GroupDetect]    Script Date: 01/18/2012 10:08:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[usp_GroupDetect]	
	@UserName varchar(20)	
as	
	begin
		declare @UserName_team_name varchar(20), @is_RIG bit
		select @UserName_team_name = (select top 1 grp from claims_officers where alias = @UserName)
		select convert(nvarchar(20),(case when left(@UserName_team_name, 3) = 'RIG' then 1 else 0 end)) as IsRIG		
	end
	
	GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GroupDetect]  TO [EMICS]
GO
 
GRANT  EXECUTE  ON [dbo].[usp_GroupDetect]  TO [emius]
GO








