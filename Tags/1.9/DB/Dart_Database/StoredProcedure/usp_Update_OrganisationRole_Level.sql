/****** Object:  StoredProcedure [dbo].[usp_Update_OrganisationRole_Level]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[usp_Update_OrganisationRole_Level]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Update_OrganisationRole_Level]
GO

/****** Object:  StoredProcedure [dbo].[usp_Update_OrganisationRole_Level]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.usp_GetPaymntFlgCommonLaw    Script Date: 1/17/04 12:27:14 PM ******/
create PROC [dbo].[usp_Update_OrganisationRole_Level](@roleid bigint ,@levelid bigint,@updatedby int)
AS	
	update Organisation_Roles 
	set UpdatedBy = @updatedby
	,LevelId = @levelid
	where Organisation_RoleId = @roleid
GO
