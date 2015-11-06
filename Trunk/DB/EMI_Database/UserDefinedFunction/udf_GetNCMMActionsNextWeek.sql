IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetNCMMActionsNextWeek') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetNCMMActionsNextWeek
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetNCMMActionsNextWeek    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
CREATE function [dbo].udf_GetNCMMActionsNextWeek(@WeeksIn int)
	RETURNS VARCHAR(256)
AS
BEGIN
	RETURN (case when @WeeksIn = 2
					then 'Prepare for 3 week Strategic Plan- due next week'
				when @WeeksIn = 5
					then 'Prepare for 6 week Strategic Review (book Internal panel)- panel next week'
				when @WeeksIn = 9
					then 'Prepare for 10 week First Response Review- review due next week'
				when @WeeksIn = 14
					then 'Prepare for 16 Week Internal Panel Review ( book Internal Panel)- panel in 2 weeks'
				when @WeeksIn = 15
					then 'Prepare for 16 Week Internal Panel Review- panel next week'
				when @WeeksIn = 18
					then 'Prepare 20 Week Tactical Strategy Review -review due  in 2 weeks'
				when @WeeksIn = 19
					then 'Prepare 20 Week Tactical Strategy Review-  review due next week'
				when @WeeksIn = 24
					then 'Prepare 26 Week Employment Direction Pathway Review ( book internal panel)- panel in 2 weeks'
				when @WeeksIn = 25
					then 'Prepare 26 Week Employment Direction Pathway Review-panel next week'
				when @WeeksIn = 38
					then 'Prepare 40 Week Tactical Strategy Review-review due in 2 weeks'
				when @WeeksIn = 39
					then 'Prepare 40 Week Tactical Strategy Review- review due next week'
				when @WeeksIn = 50
					then 'Prepare Employment Direction Determination Review ( book Internal Panel)-panel  in 2 weeks'
				when @WeeksIn = 51
					then 'Prepare Employment Direction Determination Review-panel next week'
				when @WeeksIn = 63
					then 'Prepare 65 Week Tactical Strategy Review- review due in 2 weeks'
				when @WeeksIn = 64
					then 'Prepare 65 Week Tactical Strategy Review- review due next week'
				when @WeeksIn = 75
					then 'Start preparing  78 week  Work Capacity Review - review to be completed  in week 76 as preparation for handover'
				when @WeeksIn = 77
					then 'Prepare Review for 78 week panel- Panel next week'
				when @WeeksIn = 88
					then 'Prepare 90 Week Work Capacity Review (book internal panel)-panel  in 2 weeks'
				when @WeeksIn = 89
					then 'Prepare 90 Week Work Capacity Review -panel next week'
				when @WeeksIn = 98
					then 'Prepare 100 week Work Capacity Review- review due in 2 weeks'
				when @WeeksIn = 99
					then 'Prepare 100 week Work Capacity Review- review due next week'
				when @WeeksIn = 112
					then 'Prepare 114 week Work Capacity Review-review due in 2 weeks'
				when @WeeksIn = 113
					then 'Prepare 114 week Work Capacity Review- review due next week'
				when @WeeksIn = 130
					then 'Prepare 132 week Internal Panel (Book Internal panel)- panel in 2 weeks'
				when @WeeksIn = 131
					then 'Prepare 132 week Internal Panel- panel next week'
				when @WeeksIn > 132 and (@WeeksIn - 132) % 13 = 11 and CEILING((@WeeksIn - 132) / 13.0) % 2 = 0
					then 'Prepare review for  Internal Panel (Book Internal panel)- panel in 2 weeks'
				when @WeeksIn > 132 and (@WeeksIn - 132) % 13 = 12 and CEILING((@WeeksIn - 132) / 13.0) % 2 = 0
					then 'Prepare review  for Internal Panel- panel next week'
				when @WeeksIn > 132	and (@WeeksIn - 132) % 13 = 11 and CEILING((@WeeksIn - 132) / 13.0) % 2 <> 0
					then 'Prepare Recovering Independence Quarterly Review-review due in 2 weeks'
				when @WeeksIn > 132 and (@WeeksIn - 132) % 13 = 12 and CEILING((@WeeksIn - 132) / 13.0) % 2 <> 0
					then 'Prepare Recovering Independence Quarterly Review- review due next week'
				else ''
			end)	
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].udf_GetNCMMActionsNextWeek TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_GetNCMMActionsNextWeek TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_GetNCMMActionsNextWeek TO [DART_Role]
GO