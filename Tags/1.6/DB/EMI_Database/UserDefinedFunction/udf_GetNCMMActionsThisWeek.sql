IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetNCMMActionsThisWeek') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetNCMMActionsThisWeek
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetNCMMActionsThisWeek    Script Date: 12/15/2014 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
CREATE function [dbo].udf_GetNCMMActionsThisWeek(@Date_of_Notification smalldatetime, @AsAt datetime)
	returns varchar(256)
as
	BEGIN
		RETURN (case when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 2
						then 'First Response Protocol- ensure RTW Plan has been developed'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 3
						then 'Complete 3 week Strategic Plan'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 4
						then 'Treatment Provider Engagement'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 6
						then 'Complete 6 week Strategic Review'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 10
						then 'Complete 10 Week First Response Review'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 16
						then 'Complete 16 Week Internal Panel Review'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 20
						then 'Complete 20 Week Tactical Strategy Review'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 26
						then 'Complete 26 week Employment Direction Pathyway Review (Internal Panel)'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 40
						then 'Complete 40 Week Tactical Strategy Review'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 52
						then 'Complete 52 week  Employment Direction Determination (Internal Panel)'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 65
						then 'Complete 65 Week Tactical Strategy Review'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 76
						then 'Complete 78 week Review in preparation for 78 week panel/handover ( Book Internal Panel)-panel in 2 weeks'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 78
						then 'Complete 78 week Internal Panel Review'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 90
						then 'Complete 90 Week Work Capacity Review (Internal Panel)'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 100
						then 'Complete 100 week Work Capacity Review'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 114
						then 'Complete 114 week Work Capacity Review'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 = 132
						then 'Complete 132 week Internal Panel'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 > 132
							and (DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 - 132) % 13 = 0
							and CEILING((DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 - 132) / 13) % 2 = 0
						then 'Recovering Independence Internal Panel Review'
					when DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 > 132
							and (DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 - 132) % 13 = 0
							and CEILING((DATEDIFF(DAY, @Date_of_Notification, @AsAt) / 7 - 132) / 13) % 2 <> 0
						then 'Recovering Independence Quarterly Review'
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