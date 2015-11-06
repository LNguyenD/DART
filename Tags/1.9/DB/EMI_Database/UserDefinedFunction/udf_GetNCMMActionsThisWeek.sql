IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetNCMMActionsThisWeek') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetNCMMActionsThisWeek
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetNCMMActionsThisWeek    Script Date: 12/15/2014 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
CREATE function [dbo].udf_GetNCMMActionsThisWeek(@WeeksIn int)
	RETURNS VARCHAR(256)
AS
BEGIN
	RETURN (case when @WeeksIn = 1
					then '7 Day Action plan- due by 7 calendar days from date of notification (in line with liability decision due date)'
				when @WeeksIn = 2
					then 'First Response Protocol- ensure RTW Plan has been developed'
				when @WeeksIn = 3
					then '3 Week Strategic Plan-due'
				when @WeeksIn = 4
					then 'Treatment Provider Engagement'
				when @WeeksIn = 6
					then '6 Week Strategy Review- due'
				when @WeeksIn = 10
					then '10 Week First Response Review-due'
				when @WeeksIn = 16
					then '16 Week Internal Panel -due'
				when @WeeksIn = 20
					then '20 Week Tactical Strategy Review- due'
				when @WeeksIn = 26
					then '26 Week Employment Direction Pathyway Review (Internal Panel)-due'
				when @WeeksIn = 40
					then '40 Week Tactical Strategy Review- due'
				when @WeeksIn = 52
					then '52 Week  Employment Direction Determination (Internal Panel)-due'
				when @WeeksIn = 65
					then '65 Week Tactical Strategy Review- due'
				when @WeeksIn = 76
					then 'Complete 78 week Review in preparation for 78 week panel/handover ( Book Internal Panel)-panel in 2 weeks'
				when @WeeksIn = 78
					then '78 week Internal Panel -due'
				when @WeeksIn = 90
					then '90 Week Work Capacity Review (Internal Panel)-due'
				when @WeeksIn = 100
					then '100 week Work Capacity Review-due'
				when @WeeksIn = 114
					then '114 week Work Capacity Review-due'
				when @WeeksIn = 132
					then '132 week Internal Panel-due'
				when @WeeksIn > 132 and (@WeeksIn - 132) % 13 = 0 and CEILING((@WeeksIn - 132) / 13.0) % 2 = 0
					then 'Recovering Independence Internal Panel Review-due'
				when @WeeksIn > 132 and (@WeeksIn - 132) % 13 = 0 and CEILING((@WeeksIn - 132) / 13.0) % 2 <> 0
					then 'Recovering Independence Quarterly Review-due'
				else ''
			end)
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].udf_GetNCMMActionsThisWeek TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_GetNCMMActionsThisWeek TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_GetNCMMActionsThisWeek TO [DART_Role]
GO