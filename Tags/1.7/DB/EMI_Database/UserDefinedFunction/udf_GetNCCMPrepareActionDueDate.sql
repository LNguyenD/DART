IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetNCCMPrepareActionDueDate') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].udf_GetNCCMPrepareActionDueDate
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetNCCMPrepareActionDueDate    Script Date: 04/20/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].udf_GetNCCMPrepareActionDueDate(@WeeksIn int, @Date_Claim_Received datetime)
	RETURNS DATETIME
AS
BEGIN
	RETURN (case when @WeeksIn = 2 then DATEADD(week, 3, @Date_Claim_Received)
				when @WeeksIn = 5 then DATEADD(week, 6, @Date_Claim_Received)
				when @WeeksIn = 9 then DATEADD(week, 10, @Date_Claim_Received)
				when @WeeksIn = 14 then DATEADD(week, 16, @Date_Claim_Received)
				when @WeeksIn = 15 then DATEADD(week, 16, @Date_Claim_Received)
				when @WeeksIn = 18 then DATEADD(week, 20, @Date_Claim_Received)
				when @WeeksIn = 19 then DATEADD(week, 20, @Date_Claim_Received)
				when @WeeksIn = 24 then DATEADD(week, 26, @Date_Claim_Received)
				when @WeeksIn = 25 then DATEADD(week, 26, @Date_Claim_Received)
				when @WeeksIn = 38 then DATEADD(week, 40, @Date_Claim_Received)
				when @WeeksIn = 39 then DATEADD(week, 40, @Date_Claim_Received)
				when @WeeksIn = 50 then DATEADD(week, 52, @Date_Claim_Received)
				when @WeeksIn = 51 then DATEADD(week, 52, @Date_Claim_Received)
				when @WeeksIn = 63 then DATEADD(week, 65, @Date_Claim_Received)
				when @WeeksIn = 64 then DATEADD(week, 65, @Date_Claim_Received)
				when @WeeksIn = 75 then DATEADD(week, 78, @Date_Claim_Received)
				when @WeeksIn = 77 then DATEADD(week, 78, @Date_Claim_Received)
				when @WeeksIn = 88 then DATEADD(week, 90, @Date_Claim_Received)
				when @WeeksIn = 89 then DATEADD(week, 90, @Date_Claim_Received)
				when @WeeksIn = 98 then DATEADD(week, 100, @Date_Claim_Received)
				when @WeeksIn = 99 then DATEADD(week, 100, @Date_Claim_Received)
				when @WeeksIn = 112 then DATEADD(week, 114, @Date_Claim_Received)
				when @WeeksIn = 113 then DATEADD(week, 114, @Date_Claim_Received)
				when @WeeksIn = 130 then DATEADD(week, 132, @Date_Claim_Received)
				when @WeeksIn = 131 then DATEADD(week, 132, @Date_Claim_Received)
				when @WeeksIn > 132 and (@WeeksIn - 132) % 13 = 11 then DATEADD(week, @WeeksIn + 2, @Date_Claim_Received)
				when @WeeksIn > 132 and (@WeeksIn - 132) % 13 = 12 then DATEADD(week, @WeeksIn + 1, @Date_Claim_Received)
				else null
			end)
END 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

GRANT  EXECUTE  ON [dbo].udf_GetNCCMPrepareActionDueDate TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_GetNCCMPrepareActionDueDate TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_GetNCCMPrepareActionDueDate TO [DART_Role]
GO