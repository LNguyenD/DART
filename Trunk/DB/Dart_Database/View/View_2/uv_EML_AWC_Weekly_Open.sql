SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_EML_AWC_Weekly_Open')
	DROP VIEW [dbo].[uv_EML_AWC_Weekly_Open]
GO
CREATE VIEW [dbo].[uv_EML_AWC_Weekly_Open] 
AS
	select * from [dbo].[uv_EML_AWC_Weekly_Open_1_2] 
	union select * from [dbo].[uv_EML_AWC_Weekly_Open_3_5]
	union select * from [dbo].[uv_EML_AWC_Weekly_Open_5_Plus]
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
