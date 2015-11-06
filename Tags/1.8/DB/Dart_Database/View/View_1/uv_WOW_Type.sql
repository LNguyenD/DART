SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(select * FROM sys.views where name = 'uv_WOW_Type')
	DROP VIEW [dbo].[uv_WOW_Type]
GO
CREATE VIEW [dbo].[uv_WOW_Type] 
AS
	select [Type]='state', [Value] = 'NSW'
	UNION ALL                             
	select [Type]='state', [Value] = 'VIC'
	UNION ALL                             
	select [Type]='state', [Value] = 'TAS'
	UNION ALL                             
	select [Type]='state', [Value] = 'SA'
	UNION ALL                             
	select [Type]='state', [Value] = 'NT'
	UNION ALL                             
	select [Type]='state', [Value] = 'QLD'
	UNION ALL                             
	select [Type]='state', [Value] = 'WA'
	UNION ALL                             
	select [Type]='group', [Value] = 'Group - NSW'
	UNION ALL                             
	select [Type]='group', [Value] = 'Group - VIC'
	UNION ALL                             
	select [Type]='group', [Value] = 'Group - TAS'
	UNION ALL                             
	select [Type]='group', [Value] = 'Group - SA'
	UNION ALL                             
	select [Type]='group', [Value] = 'Group - NT'
	UNION ALL                             
	select [Type]='group', [Value] = 'Group - QLD'
	UNION ALL                             
	select [Type]='group', [Value] = 'Group - WA'
	UNION ALL
	select [Type]='division', [Value] = 'Supermarkets'
	UNION ALL
	select [Type]='division', [Value] = 'Logistics'
	UNION ALL
	select [Type]='division', [Value] = 'BIG W'
	UNION ALL
	select [Type]='division', [Value] = 'Dick Smith'
	UNION ALL
	select [Type]='division', [Value] = 'Petrol'
	UNION ALL
	select [Type]='division', [Value] = 'BWS'
	UNION ALL
	select [Type]='division', [Value] = 'Dan M'
	UNION ALL
	select [Type]='division', [Value] = 'Corporate'
	UNION ALL
	select [Type]='division', [Value] = 'Miscellaneous'
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO