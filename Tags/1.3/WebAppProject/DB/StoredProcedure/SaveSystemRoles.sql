/****** Object:  StoredProcedure [dbo].[sp_SaveSystemRoles]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SaveSystemRoles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_SaveSystemRoles]
GO

/****** Object:  StoredProcedure [dbo].[sp_SaveSystemRoles]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.usp_GetPaymntFlgCommonLaw    Script Date: 1/17/04 12:27:14 PM ******/
create PROC [dbo].[sp_SaveSystemRoles](@System_RoleId bigint,@Name varchar(256),@Description nvarchar(500),@SystemRoles varchar(500),@UpdatedBy int)
AS	
	DECLARE @Item varchar(20)	
	begin try
	BEGIN TRANSACTION trans
	
		if(exists(select top 1 System_RoleId from System_Roles where System_RoleId=@System_RoleId))
			begin
				update System_Roles set Name=@Name,[Description] =@Description where System_RoleId =@System_RoleId			
				delete from System_Role_Permissions where System_RoleId = @System_RoleId
			end 
		else
			begin
				insert into System_Roles(Name,[Description]) values(@Name,@Description)	
				select @System_RoleId =SCOPE_IDENTITY()
			end 
		
		DECLARE cur CURSOR FOR 			
			with cte as
			(
				select 0 a, 1 b
				union all
				select b, charindex(',', @SystemRoles, b) + len(',')
				from cte
				where b > a
			)
			select substring(@SystemRoles,a,
			case when b > len(',') then b-a-len(',') else len(@SystemRoles) - a + 1 end) value      
			from cte where a >0					
		OPEN cur
		FETCH NEXT FROM cur	INTO @Item
		WHILE @@FETCH_STATUS = 0
			BEGIN				
				insert into System_Role_Permissions(System_RoleId,System_PermissionId,PermissionId,[Status],UpdatedBy) 
				values(@System_RoleId,Convert(bigint,SUBSTRING(@Item, 1,CHARINDEX('_', @Item) - 1)),Convert(bigint,SUBSTRING(@Item, CHARINDEX('_', @Item)+1,CHARINDEX('_', @Item) - 1)),1,@UpdatedBy)				
				FETCH NEXT FROM cur INTO @Item  
			END
		CLOSE cur
		DEALLOCATE cur
		COMMIT TRANSACTION trans
		select 1
	end try
	begin catch
		ROLLBACK TRANSACTION trans
		select -1
	end catch;	