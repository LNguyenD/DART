/****** Object:  StoredProcedure [dbo].[sp_ArrangeLevel_Role]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_ArrangeLevel_Role]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_ArrangeLevel_Role]
GO

/****** Object:  StoredProcedure [dbo].[sp_ArrangeLevel_Role]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.usp_GetPaymntFlgCommonLaw    Script Date: 1/17/04 12:27:14 PM ******/
create PROC [dbo].[sp_ArrangeLevel_Role](@data varchar(500),@updatedby int)
AS	
	DECLARE @Item varchar(20)	
	begin try
	BEGIN TRANSACTION trans	
		
		DECLARE cur CURSOR FOR 			
			with cte as
			(
				select 0 a, 1 b
				union all
				select b, charindex(',', @data, b) + len(',')
				from cte
				where b > a
			)
			select substring(@data,a,
			case when b > len(',') then b-a-len(',') else len(@data) - a + 1 end) value      
			from cte where a >0					
		OPEN cur
		FETCH NEXT FROM cur	INTO @Item
		WHILE @@FETCH_STATUS = 0
			BEGIN				
				update Organisation_Levels
				set sort = Convert(int,SUBSTRING(@Item,CHARINDEX('|', @Item)+1,LEN(@Item))),UpdatedBy=@updatedby 
				where LevelId = CONVERT(int,SUBSTRING(@Item, 1, CHARINDEX('|', @Item)-1))
				FETCH NEXT FROM cur INTO @Item  
			END
		CLOSE cur
		DEALLOCATE cur
		COMMIT TRANSACTION trans		
	end try
	begin catch
		ROLLBACK TRANSACTION trans		
	end catch;	