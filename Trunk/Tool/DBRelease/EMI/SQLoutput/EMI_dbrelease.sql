---------------------------------------------------------- 
------------------- SchemaChange 
---------------------------------------------------------- 
---------------------------------------------------------- 
------------------- UserDefinedFunction 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_CheckPositiveOrNegative.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_CheckPositiveOrNegative]    Script Date: 02/21/2013 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_CheckPositiveOrNegative]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_CheckPositiveOrNegative]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_CheckPositiveOrNegative]    Script Date: 02/21/2013 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE function [dbo].[udf_CheckPositiveOrNegative](@Is_negative money)
	returns INTEGER
as
BEGIN
	return CASE WHEN  @Is_negative < 0 THEN -1
				ELSE 1
			END

end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_CheckPositiveOrNegative] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_CheckPositiveOrNegative] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_CheckPositiveOrNegative] TO [DART_Role]
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_CheckPositiveOrNegative.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_ExtractMedCertStatus.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_ExtractMedCertStatus]    Script Date: 02/21/2013 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_ExtractMedCertStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_ExtractMedCertStatus]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_ExtractMedCertStatus]    Script Date: 02/21/2013 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_ExtractMedCertStatus](@Med_Cert_Type char)
RETURNS varchar (20) 
AS 
BEGIN
	return (CASE WHEN @Med_Cert_Type = 'T' THEN 'Totally Unfit'
			WHEN @Med_Cert_Type = 'S' THEN 'Suitable Duties'
			WHEN @Med_Cert_Type = 'P' THEN 'No Time Lost'
			WHEN @Med_Cert_Type = 'M' THEN 'Permanently Modified Duties' ELSE 'Pre-Injury Duties' END)
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_ExtractMedCertStatus.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_ExtractMedCertStatus_Code.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_ExtractMedCertStatus_Code]    Script Date: 02/21/2013 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_ExtractMedCertStatus_Code]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_ExtractMedCertStatus_Code]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_ExtractMedCertStatus_Code]    Script Date: 02/21/2013 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_ExtractMedCertStatus_Code](@Med_Cert_Type char)
RETURNS varchar (20) 
AS 
BEGIN
	return (CASE WHEN @Med_Cert_Type = 'T' THEN 'TU'
			WHEN @Med_Cert_Type = 'S' THEN 'SID'
			WHEN @Med_Cert_Type = 'P' THEN 'UNK'
			WHEN @Med_Cert_Type = 'M' THEN 'PMD'
			WHEN @Med_Cert_Type = 'I' THEN 'PID' ELSE 'Nil TL' END)
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus_Code] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus_Code] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_ExtractMedCertStatus_Code] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_ExtractMedCertStatus_Code.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetGatewayStatus_S59A.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetGatewayStatus_S59A') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetGatewayStatus_S59A
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetGatewayStatus_S59A    Script Date: 04/14/2015 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].udf_GetGatewayStatus_S59A(
	@Last_Weekly_Date DATETIME
	,@Date_of_Injury DATETIME
	,@Date_Claim_Received DATETIME
	,@WPI NUMERIC(5,2)
	,@AsAt DATETIME
)
RETURNS VARCHAR(256)
AS
BEGIN
	-- Determine the weekly month lag
	DECLARE @Weekly_Month_Lag int = (case when @Last_Weekly_Date = '1960-01-01'
											then DATEDIFF(MONTH, @Date_Claim_Received, @AsAt)
										else DATEDIFF(MONTH, @Last_Weekly_Date, @AsAt)
									end)
	
	-- Determine the past 12 months from @AsAt (get the end day of month)
	DECLARE @AsAt_Last12Months_End datetime
	SET @AsAt_Last12Months_End = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, DATEADD(m, -12, @AsAt)) + 1, 0))
	
	RETURN (case when @Last_Weekly_Date is not null and @Weekly_Month_Lag >= 13
					then 'S59A_CAP_PASSED'
				when @Last_Weekly_Date is not null and @Weekly_Month_Lag >= 12
					then '1_MTHS_TO_S59A_CAP'
				when @Last_Weekly_Date is not null and @Weekly_Month_Lag >= 11 
					then '2_MTHS_TO_S59A_CAP'
				when @Last_Weekly_Date is not null and @Weekly_Month_Lag >= 10
					then '3_MTHS_TO_S59A_CAP'
				when @Last_Weekly_Date is not null and @Weekly_Month_Lag >= 8
					then '4-5_MTHS_TO_S59A_CAP'
				when @Last_Weekly_Date is null and @Date_of_Injury > @AsAt_Last12Months_End and @WPI <= 20 
					then 'MEO_LT_12_MTHS_0-20_WPI'
				when @Last_Weekly_Date is null AND @Date_of_Injury > @AsAt_Last12Months_End and @WPI > 20 
					then 'MEO_LT_12_MTHS_GT21_WPI'
				when @Last_Weekly_Date is null AND @Date_of_Injury <= @AsAt_Last12Months_End and @WPI <= 20 
					then 'MEO_GT_12_MTHS_0-20_WPI'
				when @Last_Weekly_Date is null AND @Date_of_Injury <= @AsAt_Last12Months_End and @WPI > 20 
					then 'MEO_GT_12_MTHS_GT21_WPI'
				else '1-7MTHS_SINCE_LAST_WEEKLY'
			end)
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].udf_GetGatewayStatus_S59A TO [EMICS]
GRANT  EXECUTE  ON [dbo].udf_GetGatewayStatus_S59A TO [EMIUS]
GRANT  EXECUTE  ON [dbo].udf_GetGatewayStatus_S59A TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetGatewayStatus_S59A.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetIncapWeekForEntitlement.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetIncapWeekForEntitlement]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetIncapWeekForEntitlement]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetIncapWeekForEntitlement]    Script Date: 08/11/2014 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_GetIncapWeekForEntitlement](@IncapWeekStart DATETIME, @IncapWeekEnd DATETIME)    
RETURNS Int As
BEGIN
	DECLARE @NoOfWeeks INT
	SET @NoOfWeeks = ISNULL(DATEDIFF(WEEK, @IncapWeekStart, @IncapWeekEnd), 0)
	
	DECLARE @k INT
	SET @k = -1
			
	DECLARE @i INT
	SET @i = 0
	
	WHILE (@i <= @NoOfWeeks)
	BEGIN
		IF @IncapWeekStart + 7 * @i <= @IncapWeekEnd
		BEGIN
			SET @k = @i
		END
		SET @i = @i + 1
	END
	
	RETURN @k
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

GRANT  EXECUTE  ON [dbo].[udf_GetIncapWeekForEntitlement] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_GetIncapWeekForEntitlement] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_GetIncapWeekForEntitlement] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetIncapWeekForEntitlement.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetLiabilityStatusById.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_GetLiabilityStatusById]    Script Date: 02/21/2013 11:19:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetLiabilityStatusById]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_GetLiabilityStatusById]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_GetLiabilityStatusById]    Script Date: 02/21/2013 11:19:48 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE function [dbo].[udf_GetLiabilityStatusById](@Liability_Status smallint)
	returns nvarchar(256)
as
BEGIN
	return CASE WHEN @Liability_Status = 1 then 'Notification of work related injury'
				WHEN @Liability_Status =2 then 'Liability accepted'
				WHEN @Liability_Status =5 then 'Liability not yet determined'
				WHEN @Liability_Status =6 then 'Administration error'
				WHEN @Liability_Status =7 then 'Liability denied'
				WHEN @Liability_Status =8 then 'Provisional liability accepted - weekly and medical payments'
				WHEN @Liability_Status =9 then 'Reasonable excuse'
				WHEN @Liability_Status =10 then 'Provisional liability discontinued'
				WHEN @Liability_Status =11 then 'Provisional liability accepted - medical only, weekly payments not applicable'
				WHEN @Liability_Status =12 then 'No action after notification'
				ELSE ''
			END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_GetLiabilityStatusById] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_GetLiabilityStatusById] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_GetLiabilityStatusById] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetLiabilityStatusById.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetNCMMActionsNextWeek.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetNCMMActionsNextWeek') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetNCMMActionsNextWeek
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetNCMMActionsNextWeek    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
CREATE function [dbo].udf_GetNCMMActionsNextWeek(@DON smalldatetime, @AsAt datetime)
	returns varchar(256)
as
	BEGIN
		RETURN (case when DATEDIFF(DAY, @DON, @AsAt) / 7 = 2
						then 'Prepare for 3 week Strategic Plan- due next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 5
						then 'Prepare for 6 week Strategic Review (book Internal panel)- panel next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 9
						then 'Prepare for 10 week First Response Review- review due next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 14
						then 'Prepare for 16 Week Internal Panel Review ( book Internal Panel)- panel in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 15
						then 'Prepare for 16 Week Internal Panel Review- panel next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 18
						then 'Prepare 20 Week Tactical Strategy Review -review due  in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 19
						then 'Prepare 20 Week Tactical Strategy Review-  review due next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 24
						then 'Prepare 26 Week Employment Direction Pathway Review ( book internal panel)- panel in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 25
						then 'Prepare 26 Week Employment Direction Pathway Review-panel next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 38
						then 'Prepare 40 Week Tactical Strategy Review-review due in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 39
						then 'Prepare 40 Week Tactical Strategy Review- review due next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 50
						then 'Prepare Employment Direction Determination Review ( book Internal Panel)-panel  in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 51
						then 'Prepare Employment Direction Determination Review-panel next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 63
						then 'Prepare 65 Week Tactical Strategy Review- review due in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 64
						then 'Prepare 65 Week Tactical Strategy Review- review due next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 75
						then 'Start preparing  78 week  Work Capacity Review - review to be completed  in week 76 as preparation for handover'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 77
						then 'Prepare Review for 78 week panel- Panel next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 88
						then 'Prepare 90 Week Work Capacity Review (book internal panel)-panel  in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 89
						then 'Prepare 90 Week Work Capacity Review -panel next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 98
						then 'Prepare 100 week Work Capacity Review- review due in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 99
						then 'Prepare 100 week Work Capacity Review- review due next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 112
						then 'Prepare 114 week Work Capacity Review-review due in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 113
						then 'Prepare 114 week Work Capacity Review- review due next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 130
						then 'Prepare 132 week Internal Panel (Book Internal panel)- panel in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 131
						then 'Prepare 132 week Internal Panel- panel next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 > 132
							and (DATEDIFF(DAY, @DON, @AsAt) / 7 - 132) % 13 = 11
							and CEILING((DATEDIFF(DAY, @DON, @AsAt) / 7 - 132) / 13) % 2 = 0
						then 'Prepare review for  Internal Panel (Book Internal panel)- panel in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 > 132
							and (DATEDIFF(DAY, @DON, @AsAt) / 7 - 132) % 13 = 12
							and CEILING((DATEDIFF(DAY, @DON, @AsAt) / 7 - 132) / 13) % 2 = 0
						then 'Prepare review  for Internal Panel- panel next week'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 > 132
							and (DATEDIFF(DAY, @DON, @AsAt) / 7 - 132) % 13 = 11
							and CEILING((DATEDIFF(DAY, @DON, @AsAt) / 7 - 132) / 13) % 2 <> 0
						then 'Prepare Recovering Independence Quarterly Review-review due in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 > 132
							and (DATEDIFF(DAY, @DON, @AsAt) / 7 - 132) % 13 = 12
							and CEILING((DATEDIFF(DAY, @DON, @AsAt) / 7 - 132) / 13) % 2 <> 0
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
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetNCMMActionsNextWeek.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetNCMMActionsThisWeek.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].udf_GetNCMMActionsThisWeek') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].udf_GetNCMMActionsThisWeek
GO

/****** Object:  UserDefinedFunction [dbo].udf_GetNCMMActionsThisWeek    Script Date: 12/15/2014 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
CREATE function [dbo].udf_GetNCMMActionsThisWeek(@DON smalldatetime, @AsAt datetime)
	returns varchar(256)
as
	BEGIN
		RETURN (case when DATEDIFF(DAY, @DON, @AsAt) / 7 = 2
						then 'First Response Protocol- ensure RTW Plan has been developed'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 3
						then 'Complete 3 week Strategic Plan'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 4
						then 'Treatment Provider Engagement'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 6
						then 'Complete 6 week Strategic Review'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 10
						then 'Complete 10 Week First Response Review'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 16
						then 'Complete 16 Week Internal Panel Review'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 20
						then 'Complete 20 Week Tactical Strategy Review'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 26
						then 'Complete 26 week Employment Direction Pathyway Review (Internal Panel)'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 40
						then 'Complete 40 Week Tactical Strategy Review'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 52
						then 'Complete 52 week  Employment Direction Determination (Internal Panel)'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 65
						then 'Complete 65 Week Tactical Strategy Review'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 76
						then 'Complete 78 week Review in preparation for 78 week panel/handover ( Book Internal Panel)-panel in 2 weeks'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 78
						then 'Complete 78 week Internal Panel Review'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 90
						then 'Complete 90 Week Work Capacity Review (Internal Panel)'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 100
						then 'Complete 100 week Work Capacity Review'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 114
						then 'Complete 114 week Work Capacity Review'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 = 132
						then 'Complete 132 week Internal Panel'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 > 132
							and (DATEDIFF(DAY, @DON, @AsAt) / 7 - 132) % 13 = 0
							and CEILING((DATEDIFF(DAY, @DON, @AsAt) / 7 - 132) / 13) % 2 = 0
						then 'Recovering Independence Internal Panel Review'
					when DATEDIFF(DAY, @DON, @AsAt) / 7 > 132
							and (DATEDIFF(DAY, @DON, @AsAt) / 7 - 132) % 13 = 0
							and CEILING((DATEDIFF(DAY, @DON, @AsAt) / 7 - 132) / 13) % 2 <> 0
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
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_GetNCMMActionsThisWeek.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MaxDay.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_MaxDay]    Script Date: 02/21/2013 11:11:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_MaxDay]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_MaxDay]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_MaxDay]    Script Date: 02/21/2013 11:11:26 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


create function [dbo].[udf_MaxDay](@day1 DATETIME, @day2 DATETIME, @day3 DATETIME)
	returns DATETIME
as
begin
	return CASE WHEN @day1 >= @day2 and @day1 >= @day3 then @day1
				WHEN @day2 >= @day1 and @day2 >= @day3 then @day2
				WHEN @day3 >= @day1 and @day3 >= @day2 then @day3
			END
end

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_MaxDay] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_MaxDay] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_MaxDay] TO [DART_Role]
GO

--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MaxDay.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MaxValue.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_MaxValue]    Script Date: 05/27/2013 14:42:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_MaxValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_MaxValue]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_MaxValue]    Script Date: 05/27/2013 14:42:39 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




CREATE FUNCTION [dbo].[udf_MaxValue](@num1 FLOAT, @num2 FLOAT)  
RETURNS FLOAT As  
BEGIN
	return CASE WHEN  @num1 >= @num2 THEN @num1
				ELSE @num2
			END
END  


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF

GO
GRANT  EXECUTE  ON [dbo].[udf_MaxValue] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_MaxValue] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_MaxValue] TO [DART_Role]
GO


--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MaxValue.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MinDay.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_MinDay]    Script Date: 02/21/2013 11:12:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_MinDay]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_MinDay]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_MinDay]    Script Date: 02/21/2013 11:12:21 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


create function [dbo].[udf_MinDay](@day1 DATETIME, @day2 DATETIME, @day3 DATETIME)
	returns DATETIME
as
begin
	return CASE WHEN @day1 <= @day2 and @day1 <= @day3 then @day1
				WHEN @day2 <= @day1 and @day2 <= @day3 then @day2
				WHEN @day3 <= @day1 and @day3 <= @day2 then @day3
			END
end


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_MinDay] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_MinDay] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_MinDay] TO [DART_Role]
GO


--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MinDay.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MinValue.sql  
--------------------------------  
/****** Object:  UserDefinedFunction [dbo].[udf_MinValue]    Script Date: 05/27/2013 14:43:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_MinValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_MinValue]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_MinValue]    Script Date: 05/27/2013 14:43:37 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




CREATE FUNCTION [dbo].[udf_MinValue](@num1 FLOAT, @num2 FLOAT)  
RETURNS FLOAT As  
BEGIN
	return CASE WHEN  @num1 >= @num2 THEN @num2
				ELSE @num1
			END
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF

GO
GRANT  EXECUTE  ON [dbo].[udf_MinValue] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_MinValue] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_MinValue] TO [DART_Role]
GO
--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_MinValue.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_NoOfDaysWithoutWeekend.sql  
--------------------------------  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_NoOfDaysWithoutWeekend]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_NoOfDaysWithoutWeekend]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_NoOfDaysWithoutWeekend]    Script Date: 02/21/2013 11:08:20 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[udf_NoOfDaysWithoutWeekend](@StartDate DATETIME, @Enddate DATETIME)    
RETURNS Int As    
BEGIN   


return  ((DATEDIFF(dd, @StartDate, @EndDate) + 1)

-(DATEDIFF(wk, @StartDate, @EndDate) * 2)

-(CASE WHEN DATENAME(dw, @StartDate) = 'Sunday' THEN 1 ELSE 0 END)

-(CASE WHEN DATENAME(dw, @EndDate) = 'Saturday' THEN 1 ELSE 0 END))
  
END 


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[udf_NoOfDaysWithoutWeekend] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[udf_NoOfDaysWithoutWeekend] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[udf_NoOfDaysWithoutWeekend] TO [DART_Role]
GO
 --------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\UserDefinedFunction\udf_NoOfDaysWithoutWeekend.sql  
--------------------------------  
---------------------------------------------------------- 
------------------- View 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\View\uv_submitted_Transaction_Payments.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uv_submitted_Transaction_Payments]'))
DROP VIEW [dbo].[uv_submitted_Transaction_Payments]
GO

CREATE VIEW [dbo].[uv_submitted_Transaction_Payments]
AS
SELECT     dbo.Payment_Recovery.Claim_No, dbo.Payment_Recovery.WC_Payment_Type, CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte IS NOT NULL AND 
                      Payment_Recovery.Transaction_date < dbo.CLAIM_PAYMENT_RUN.Authorised_dte THEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte ELSE Payment_Recovery.Transaction_date
                       END AS submitted_trans_date, dbo.Payment_Recovery.Payment_Type, dbo.Payment_Recovery.Trans_Amount, dbo.Payment_Recovery.Adjust_Trans_Flag, 
                      dbo.Payment_Recovery.Reversed, dbo.Payment_Recovery.wc_Tape_Month, dbo.Payment_Recovery.Payment_no, dbo.Payment_Recovery.itc, 
                      dbo.Payment_Recovery.gst, dbo.Payment_Recovery.Period_Start_Date, dbo.Payment_Recovery.Period_End_Date, dbo.Payment_Recovery.Estimate_type, 
                      dbo.Payment_Recovery.dam, CASE WHEN payment_type IN ('13','14', '15', '16','WPT001', 'WPT002','WPT003', 'WPT004','WPT005','WPT006','WPT007'
, 'WPP001','WPP002','WPP003','WPP004', 'WPP005', 'WPP006', 'WPP007','WPP008') THEN 1 ELSE 0 END AS WeeklyPayment
FROM         dbo.Payment_Recovery INNER JOIN
                      dbo.CLAIM_PAYMENT_RUN ON dbo.Payment_Recovery.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
WHERE     (dbo.Payment_Recovery.wc_Tape_Month IS NOT NULL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

GRANT  SELECT  ON [dbo].[uv_submitted_Transaction_Payments] TO [EMICS]
GRANT  SELECT  ON [dbo].[uv_submitted_Transaction_Payments] TO [EMIUS]
GRANT  SELECT  ON [dbo].[uv_submitted_Transaction_Payments] TO [DART_Role]
GO

--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\View\uv_submitted_Transaction_Payments.sql  
--------------------------------  
---------------------------------------------------------- 
------------------- StoredProcedure 
---------------------------------------------------------- 
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_AWC_Index.sql  
--------------------------------  
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_AWC_Index]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_AWC_Index]
GO

CREATE PROCEDURE [dbo].[usp_AWC_Index]
AS
BEGIN
	-- AWC
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_POLICY_TERM_DETAIL_Policy_No_Broker_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_POLICY_TERM_DETAIL_Policy_No_Broker_No] ON [dbo].[POLICY_TERM_DETAIL] 
		(
			[POLICY_NO] ASC,
			[BROKER_NO] ASC
		)
		INCLUDE ( [CELL_NO]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_Medical_Cert_Cancelled_By_Claim_no_Cancelled_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_Medical_Cert_Cancelled_By_Claim_no_Cancelled_Date] ON [dbo].[Medical_Cert] 
		(
			[Cancelled_By] ASC,
			[Claim_no] ASC,
			[Cancelled_Date] ASC
		)
		INCLUDE ( [ID],
		[Date_From],
		[Date_To],
		[Type]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_ESTIMATE_DETAILS_Claim_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_ESTIMATE_DETAILS_Claim_No] ON [dbo].[ESTIMATE_DETAILS] 
		(
			[Claim_No] ASC
		)
		INCLUDE ( [Amount]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CO_Audit_Alias_ID_Officer_ID_Create_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CO_Audit_Alias_ID_Officer_ID_Create_Date] ON [dbo].[CO_Audit] 
		(
			[Alias] ASC,
			[ID] ASC,
			[Officer_ID] ASC,
			[Create_date] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CLAIMS_OFFICERS_Alias_Officer_ID_Active_Grp') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CLAIMS_OFFICERS_Alias_Officer_ID_Active_Grp] ON [dbo].[CLAIMS_OFFICERS] 
		(
			[Alias] ASC,
			[Officer_ID] ASC,
			[active] ASC,
			[grp] ASC
		)
		INCLUDE ( [First_Name],
		[Last_Name]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CLAIM_PAYMENT_RUN_Payment_No_Claim_Number_Authorised_dte') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CLAIM_PAYMENT_RUN_Payment_No_Claim_Number_Authorised_dte] ON [dbo].[CLAIM_PAYMENT_RUN] 
		(
			[Payment_no] ASC,
			[Claim_number] ASC,
			[Authorised_dte] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CLAIM_DETAIL_Date_Created_Claim_Number_Anzsic') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CLAIM_DETAIL_Date_Created_Claim_Number_Anzsic] ON [dbo].[CLAIM_DETAIL] 
		(
			[Date_Created] ASC,
			[Claim_Number] ASC,
			[ANZSIC] ASC
		)
		INCLUDE ( [Policy_No],
		[Renewal_No]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CLAIM_ACTIVITY_DETAIL_Claim_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CLAIM_ACTIVITY_DETAIL_Claim_No] ON [dbo].[CLAIM_ACTIVITY_DETAIL] 
		(
			[Claim_no] ASC
		)
		INCLUDE ( [Claim_Closed_Flag],
		[Claim_Liability_Indicator]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_cd_audit_claim_no_create_date_id') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_cd_audit_claim_no_create_date_id] ON [dbo].[cd_audit] 
		(
			[claim_no] ASC,
			[create_date] ASC,
			[id] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CAD_AUDIT_Claim_no_Transaction_Date_ID') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CAD_AUDIT_Claim_no_Transaction_Date_ID] ON [dbo].[CAD_AUDIT] 
		(
			[Claim_no] ASC,
			[Transaction_Date] ASC,
			[ID] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_BROKER_Broker_No_emi_contact') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_BROKER_Broker_No_emi_contact] ON [dbo].[BROKER] 
		(
			[BROKER_NO] ASC,
			[emi_contact] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_ANZSIC_Code') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_ANZSIC_Code] ON [dbo].[ANZSIC] 
		(
			[CODE] ASC
		)
		INCLUDE ( [ID],
		[DESCRIPTION]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
END
GO

EXEC [dbo].[usp_AWC_Index]--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_AWC_Index.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_CPR_GenerateData_Last3Month.sql  
--------------------------------  

/****** Object:  StoredProcedure [dbo].[usp_CPR_GenerateData_Last3Month]    Script Date: 02/04/2015 14:14:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_GenerateData_Last3Month]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_GenerateData_Last3Month]
GO

Create procedure [dbo].[usp_CPR_GenerateData_Last3Month]
	@System varchar(20)
as
begin	
	
	declare @Reporting_Date_End datetime, @Last3Month_Start datetime, @VarDate datetime, @VarDatePlus1Day datetime	
	
	set @Reporting_Date_End =  DATEADD(dd, DATEDIFF(dd, 0, GETDATE()), -1) + '23:59'
	set @Last3Month_Start = DATEADD(mm,-3, DATEADD(mm, DATEDIFF(MM, 0, GETDATE()), 0)) + '23:59'	
	 
	set @VarDate = @Last3Month_Start		
			
	-- Loop day in last 3 month
	WHILE @VarDate <= @Reporting_Date_End
	BEGIN		
		---- Check if Reporting_Date = @DataFromMonth
		
		set @VarDatePlus1Day = DATEADD(dd, DATEDIFF(dd, 0, @VarDate),1) + '23:59'							
		IF UPPER(@System) = 'TMF'
		BEGIN
			IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[TMF_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))						
				INSERT INTO [Dart].[dbo].[TMF_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @VarDate, 0																													
		END
		ELSE IF UPPER(@System) = 'HEM'
		BEGIN
			IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[HEM_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))			
				INSERT INTO [Dart].[dbo].[HEM_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @VarDate, 0					
		END
		ELSE IF UPPER(@System) = 'EML'
		BEGIN
			IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[EML_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))			
				INSERT INTO [Dart].[dbo].[EML_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @VarDate, 0					
		END
				
		SET @VarDate = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 1) + '23:59'							
	END 
	
end
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_CPR_GenerateData_Last3Month] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_CPR_GenerateData_Last3Month] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_CPR_GenerateData_Last3Month] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_CPR_GenerateData_Last3Month.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_CPR_GenerateData_Last3Year.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_Portfolio_GenerateData]    Script Date: 23/04/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_GenerateData_Last3Year]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_GenerateData_Last3Year]
GO

Create procedure [dbo].[usp_CPR_GenerateData_Last3Year]
	@System varchar(20)
as
begin		
	
	declare @Reporting_Date_End datetime, @Last3Month_Start datetime
		, @Last3Year_Start datetime, @VarDate datetime, @VarDatePlus1Day datetime
	
	set @Reporting_Date_End =  DATEADD(dd, DATEDIFF(dd, 0, GETDATE()), -1) + '23:59'
	set @Last3Month_Start = DATEADD(mm,-3, DATEADD(mm, DATEDIFF(MM, 0, GETDATE()), 0)) + '23:59'
	set @Last3Year_Start =DATEADD(dd,-1,DATEADD(yy,-3, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))) + '23:59'		
	
	set @VarDate = @Last3Year_Start		
	
	WHILE @VarDate < @Last3Month_Start
	BEGIN			
		--set @VarDatePlus1Day = DATEADD(dd, DATEDIFF(dd, 0, @VarDate),1) + '23:59'						
							
		IF UPPER(@System) = 'TMF'
		BEGIN
			IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[TMF_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))									
				INSERT INTO [Dart].[dbo].[TMF_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @VarDate, 0				
		END
		ELSE IF UPPER(@System) = 'HEM'
		BEGIN
			IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[HEM_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))														
				INSERT INTO [Dart].[dbo].[HEM_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @VarDate, 0	
		END
		ELSE IF UPPER(@System) = 'EML'
		BEGIN
			IF NOT EXISTS (SELECT Reporting_Date FROM [Dart].[dbo].[EML_Portfolio] WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @VarDate), 0))										
				INSERT INTO [Dart].[dbo].[EML_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @VarDate, 0
		END	
		set @VarDate = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, DATEADD(dd,10,@VarDate)) + 1, 0)) + '23:59'		
	END		

end
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_CPR_GenerateData_Last3Year] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_CPR_GenerateData_Last3Year] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_CPR_GenerateData_Last3Year] TO [DART_Role]
GO

--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_CPR_GenerateData_Last3Year.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_CPR_Index.sql  
--------------------------------  
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Index]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Index]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Index]
AS
BEGIN
	-- CPR	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_TIME_LOST_DETAIL_Claim_No_ID') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_TIME_LOST_DETAIL_Claim_No_ID] ON [dbo].[TIME_LOST_DETAIL] 
		(
			[Claim_No] ASC,
			[ID] ASC
		)
		INCLUDE ( [RTW_Goal],
		[Deemed_HoursPerWeek]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_PREMIUM_DETAIL_Policy_No_Renewal_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_PREMIUM_DETAIL_Policy_No_Renewal_No] ON [dbo].[PREMIUM_DETAIL] 
		(
			[POLICY_NO] ASC,
			[RENEWAL_NO] ASC
		)
		INCLUDE ( [BTP],
		[WAGES0],
		[Process_Flags]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_POLICY_TERM_DETAIL_Policy_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_POLICY_TERM_DETAIL_Policy_No] ON [dbo].[POLICY_TERM_DETAIL] 
		(
			[POLICY_NO] ASC
		)
		INCLUDE ( [BROKER_NO],
		[LEGAL_NAME]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_Payment_Recovery_Estimate_Type_Claim_No_Transaction_Date_Payment_Type_ID') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_Payment_Recovery_Estimate_Type_Claim_No_Transaction_Date_Payment_Type_ID] ON [dbo].[Payment_Recovery] 
		(
			[Estimate_type] ASC,
			[Claim_No] ASC,
			[Transaction_date] ASC,
			[Payment_Type] ASC,
			[ID] ASC
		)
		INCLUDE ( [Trans_Amount],
		[itc],
		[dam],
		[gst]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_Medical_Cert_Claim_No_Create_Date_Is_Deleted_ID_Date_From') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_Medical_Cert_Claim_No_Create_Date_Is_Deleted_ID_Date_From] ON [dbo].[Medical_Cert] 
		(
			[Claim_no] ASC,
			[create_date] ASC,
			[is_deleted] ASC,
			[ID] ASC,
			[Date_From] ASC
		)
		INCLUDE ( [Type]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_ESTIMATE_DETAILS_Type_Claim_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_ESTIMATE_DETAILS_Type_Claim_No] ON [dbo].[ESTIMATE_DETAILS] 
		(
			[Type] ASC,
			[Claim_No] ASC
		)
		INCLUDE ( [Amount]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CLAIM_DETAIL_Claim_No_Anzsic_Policy_No_Renewal_No_Cost_Code_Cost_Code2_Is_Null') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CLAIM_DETAIL_Claim_No_Anzsic_Policy_No_Renewal_No_Cost_Code_Cost_Code2_Is_Null] ON [dbo].[CLAIM_DETAIL] 
		(
			[Claim_Number] ASC,
			[ANZSIC] ASC,
			[Policy_No] ASC,
			[Renewal_No] ASC,
			[Cost_Code] ASC,
			[Cost_Code2] ASC,
			[is_Null] ASC
		)
		INCLUDE ( [Date_of_Birth],
		[Date_of_Injury],
		[Date_Notice_Given],
		[Given_Names],
		[is_Medical_Only],
		[Last_Names],
		[Mechanism_of_Injury],
		[Nature_of_Injury],
		[Phone_no],
		[Tariff_No],
		[Employee_no],
		[Employment_Terminated_Reason],
		[Fund],
		[Work_Hours]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_cd_bit_audit_ID_Is_NUll_Claim_Number_Create_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_cd_bit_audit_ID_Is_NUll_Claim_Number_Create_Date] ON [dbo].[cd_bit_audit] 
		(
			[id] ASC,
			[is_Null] ASC,
			[Claim_Number] ASC,
			[Create_date] ASC
		)
		INCLUDE ( [is_Time_Lost]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_cd_audit_Id_Fund_Claim_No_Create_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_cd_audit_Id_Fund_Claim_No_Create_Date] ON [dbo].[cd_audit] 
		(
			[id] ASC,
			[fund] ASC,
			[claim_no] ASC,
			[create_date] ASC
		)
		INCLUDE ( [Result_of_Injury_Code]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CAD_AUDIT_Claim_No_ID_Liability_Closed_Flag_CO_Reopened_Transaction_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CAD_AUDIT_Claim_No_ID_Liability_Closed_Flag_CO_Reopened_Transaction_Date] ON [dbo].[CAD_AUDIT] 
		(
			[Claim_no] ASC,
			[ID] ASC,
			[Claim_Liability_Indicator] ASC,
			[Date_Claim_Closed] ASC,
			[Claim_Closed_Flag] ASC,
			[Claims_Officer] ASC,
			[Date_Claim_reopened] ASC,
			[Transaction_Date] ASC
		)
		INCLUDE ( [Work_Status_Code],
		[Date_Claim_Entered],
		[date_claim_received],
		[WPI]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_amendment_exemptions_Claim_No') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_amendment_exemptions_Claim_No] ON [dbo].[amendment_exemptions] 
		(
			[claim_no] ASC
		)
		INCLUDE ( [is_exempt]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_ACTIVITY_DETAIL_AUDIT_Policy_No_Renewal_No_ID_Create_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_ACTIVITY_DETAIL_AUDIT_Policy_No_Renewal_No_ID_Create_Date] ON [dbo].[ACTIVITY_DETAIL_AUDIT] 
		(
			[Policy_No] ASC,
			[Renewal_No] ASC,
			[ID] ASC,
			[CREATE_DATE] ASC
		)
		INCLUDE ( [Tariff]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
END
GO

EXEC [dbo].[usp_CPR_Index]--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_CPR_Index.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_AWC.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [usp_Dashboard_EML_AWC] 2013, 1
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_EML_AWC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_EML_AWC]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_EML_AWC]
      @year int = 2011,
      @month int = 1
AS
BEGIN
	SET NOCOUNT ON
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List		
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP table #AWC_list
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL DROP table #policy
	
	declare @startdate datetime = cast(cast(@year as char(4)) + '/'  + cast(@month as char(2)) + '/01' as datetime)
	declare @enddate datetime  = dateadd(dd, -1, dateadd(mm, 1, @startdate)) + '23:59'
	
	declare @SQL varchar(500)

	--Check temp table existing then drop	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NULL
	BEGIN
		create table #_CLAIM_ESTIMATE_SUMMARY
		(
			CLAIM_NO varCHAR(19)
			,TotalAmount MONEY
		) 
		
		SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
			 
		INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
			SELECT CLAIM_NO, SUM(ISNULL(Amount, 0)) 
			FROM ESTIMATE_DETAILS
			GROUP BY claim_no
	END
	
	CREATE TABLE #_Claim_Detail
	(
		policy_no char(19)
		,Claim_no varchar(19)
		,Claim_Closed_Flag CHAR(1)
		,Claim_Liability_Indicator TINYINT
		,renewal_no INT
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_Detail_'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_Detail(policy_no, Claim_no, Claim_Closed_Flag, Claim_Liability_Indicator)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT INTO #_Claim_Detail
		-- claim detail here
		SELECT  policy_no, 
				Claim_Number,
				Claim_Closed_Flag,
				Claim_Liability_Indicator, 
				Renewal_No
		FROM CLAIM_DETAIL cd INNER JOIN CLAIM_ACTIVITY_DETAIL cad 
			ON rtrim(cd.Claim_Number) =  rtrim(cad.Claim_no)
				AND Date_Created <= @enddate AND Claim_Number <> ''
				LEFT OUTER JOIN amendment_exemptions ae ON cd.Claim_Number = ae.claim_no

	CREATE TABLE #_Claim_List
	(
		Claim_no varchar(19)
		,EXCLUDE BIT
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_List'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_List(Claim_no, EXCLUDE)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #_Claim_List
	SELECT cd.Claim_no
		   ,EXCLUDE = (CASE WHEN (cd.Claim_Liability_Indicator IN (1,6,12)) 
								 OR (cd.Claim_Liability_Indicator IN (4) 
									AND ces.TotalAmount <= 0) 
								 OR (cd.Claim_Closed_Flag = 'Y' AND ces.TotalAmount = 0)  
							   THEN 1 
						   ELSE 0 
					   END)
	FROM #_Claim_Detail cd INNER JOIN #_CLAIM_ESTIMATE_SUMMARY ces 
									  ON cd.Claim_no = ces.CLAIM_NO

	CREATE TABLE #_Claim_list_adjusted
	(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,WC_Payment_Type varchar(8)
		 ,Payment_Type varchar(15)
		 ,Trans_Amount money
	)
	
	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_
				ON [dbo].[#_Claim_list_adjusted] (submitted_trans_date)
				INCLUDE ([Claim_no])'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT  INTO #_Claim_list_adjusted
	SELECT  u.claim_no
			, submitted_trans_date
			, Period_Start_Date
			, Period_End_Date
			, WC_Payment_Type
			, Payment_Type 
			,Trans_Amount = (SELECT SUM(ISNULL(u1.Trans_Amount, 0)) 
								FROM uv_submitted_Transaction_Payments u1
								WHERE u1.Claim_No = u.claim_no 
								and u1.Period_Start_Date = u.Period_Start_Date
								and u1.Period_End_Date = u.Period_End_Date 
								and u1.WC_Payment_Type = u.WC_Payment_Type 
								and u1.Payment_Type = u.payment_type)
	FROM uv_submitted_Transaction_Payments u
	WHERE u.submitted_trans_date = (SELECT min(u1.submitted_trans_date) 
									FROM uv_submitted_Transaction_Payments u1 
									WHERE u1.Claim_No = u.claim_no 
										  and u1.Period_Start_Date = u.Period_Start_Date 
										  and u1.Period_End_Date = u.Period_End_Date 
										  and u1.WC_Payment_Type = u.WC_Payment_Type 
										  and u1.Payment_Type = u.payment_type)
		and u.submitted_trans_date between @startdate and @enddate
		and u.WeeklyPayment = 1
	GROUP BY u.claim_no, submitted_trans_date
			 ,Period_Start_Date, Period_End_Date
			 ,WC_Payment_Type, Payment_Type
	ORDER BY claim_no, payment_type, Period_Start_Date, Period_End_Date


	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_Trans_Amount
				ON [dbo].[#_Claim_list_adjusted] (Trans_Amount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	DELETE FROM #_Claim_list_adjusted WHERE Trans_Amount = 0
	DELETE FROM #_Claim_list_adjusted 
		   WHERE CLAIM_NO in (SELECT cla1.claim_no 
							  FROM #_Claim_list_adjusted cla1 
									inner join #_Claim_List cl on cla1.Claim_no = cl.Claim_no 
												and cl.EXCLUDE = 1)

	CREATE TABLE #AWC_list 
	(
		claim_no varchar (19)
		,date_of_injury datetime
	)
	
	SET @SQL = 'CREATE INDEX pk_AWC_list'+CONVERT(VARCHAR, @@SPID)+' ON #AWC_list(Claim_no,date_of_injury)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #AWC_list
		SELECT DISTINCT rtrim(cla.claim_no),ca.Date_of_Injury 
		FROM #_Claim_list_adjusted cla 
			 INNER JOIN cd_audit ca ON cla.Claim_no = ca.claim_no 
									   AND cla.submitted_trans_date between @startdate and @enddate
									   AND ca.id = (SELECT MAX(id) 
													FROM cd_audit 
													WHERE ca.claim_no = claim_no 
													AND create_date < @enddate)
										AND ca.fund <> 98

	/* create #policy table to store policy info for claim */
	CREATE TABLE #policy
	(
		policyno CHAR(19)
		,renewal_no INT
		,bastarif MONEY
		,wages MONEY
		,const_flag_final int
	)
	
	/* create index for #policy table */
	SET @SQL = 'CREATE INDEX pk_policy_'+CONVERT(VARCHAR, @@SPID)+' ON #policy(policyno, renewal_no)'
	EXEC(@SQL)

	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
			
	INSERT INTO #policy
		SELECT	POLICY_NO
				, RENEWAL_NO
				, BTP					
				, WAGES0
				, Process_Flags					
			FROM dbo.PREMIUM_DETAIL pd
			WHERE EXISTS (SELECT 1 FROM #_Claim_Detail cd where cd.policy_no = pd.POLICY_NO)
			ORDER BY POLICY_NO,RENEWAL_NO
	
	SELECT	Time_ID = @enddate
			,Claim_no = awc_list.Claim_no	
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')
			,awc_list.Date_of_Injury
			,create_date = getdate()
			,cd.policy_no
			,Empl_Size = (CASE WHEN pd.bastarif IS NULL OR pd.const_flag_final IS NULL OR pd.wages IS NULL then 'A - Small'
							  WHEN pd.wages <= 300000 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final = 1 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final <> 1 then 'B - Small-Medium'
							  WHEN pd.wages > 1000000 AND pd.wages <= 5000000 then 'C - Medium'
							  WHEN pd.wages > 5000000 AND pd.wages <= 15000000 AND pd.bastarif <= 100000 then 'C - Medium'
							  WHEN pd.wages > 15000000 then 'D - Large'
							  WHEN pd.wages > 5000000 AND pd.bastarif > 100000 then 'D - Large'
							  ELSE 'A - Small'
						  END)
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			
	FROM	#AWC_list awc_list
			INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = awc_list.claim_no
			LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
			INNER JOIN #_Claim_Detail cd on awc_list.claim_no = cd.Claim_No		
			INNER JOIN cad_audit cada1 on cada1.Claim_No = awc_list.claim_no 
			INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
			LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
          	LEFT JOIN #policy pd on pd.policyno = cd.policy_no and pd.renewal_no = cd.renewal_no 	
          	LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
						left join Broker Br on PTD.Broker_No = Br.Broker_no 
						left join UnderWriters U on  BR.emi_Contact = U.Alias 
						where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no		
			
	WHERE   cada1.id = (SELECT MAX(cada2.id) 
					      FROM  cad_audit cada2 
					      WHERE cada2.claim_no = cada1.claim_no
							    AND cada2.transaction_date <= @enddate) 
			AND coa1.id = (SELECT   MAX(coa2.id) 
						     FROM   CO_audit coa2
						     WHERE  coa2.officer_id = coa1.officer_id
								    AND coa2.create_date <= @enddate)
				  
	--drop all temp table
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail	
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP TABLE #AWC_list
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL DROP table #policy	
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_AWC.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_AWC_GenerateData.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_EML_AWC_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_EML_AWC_GenerateData]
Go
-- For example
-- exec [usp_Dashboard_EML_AWC_GenerateData] 2011, 1
-- this will return all result with time id range from 2011-01-31 23:59 till now

CREATE PROCEDURE [dbo].[usp_Dashboard_EML_AWC_GenerateData]
	@start_period_year int = 2012,
	@start_period_month int = 10
AS
BEGIN	
	SET NOCOUNT ON;
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) + '/' + CAST(@start_period_month as varchar) + '/01' as datetime)
	declare @end_period datetime = getdate()
	
	declare @loop_time int = DATEDIFF(month, @start_period, @end_period)
	declare @i int = @loop_time 
	declare @temp datetime
	declare @SQL varchar(500)

	---delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[EML_AWC] 
			WHERE Time_ID in (select distinct top 3 Time_ID 
			from [DART].[dbo].[EML_AWC] order by Time_ID desc)')
	---end delete--	

	--Check temp table existing then drop	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL DROP TABLE #_CLAIM_ESTIMATE_SUMMARY
		
	create table #_CLAIM_ESTIMATE_SUMMARY
	(
		CLAIM_NO varCHAR(19),
		TotalAmount MONEY
	) 
	
	SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		 
	INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
		select CLAIM_NO, SUM(ISNULL(Amount, 0))
		from ESTIMATE_DETAILS
		group by claim_no
	WHILE (@i >= 0)
	BEGIN
		set @temp = DATEADD(mm, @i, @start_period)
		declare @year int = YEAR(@temp)
		declare @month int = MONTH(@temp)
		
		If NOT EXISTS(select 1 from [DART].[dbo].[EML_AWC] 
							where Year(Time_ID) = @year and
							Month(Time_ID ) = @month)
		   AND cast(CAST(@year as varchar) + '/' +  CAST(@month as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN		
			print @temp
			--DELETE FROM dbo.EML_AWC where Time_ID = DATEADD(dd, -1, DATEADD(mm, 1, @temp)) + '23:59'
			--INSERT INTO dbo.EML_AWC exec usp_Dashboard_EML_AWC @year, @month
			INSERT INTO [Dart].[dbo].[EML_AWC] exec usp_Dashboard_EML_AWC @year, @month			
		END
		SET @i = @i - 1
	END
	
	--drop temp table
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL drop table #_CLAIM_ESTIMATE_SUMMARY	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_AWC_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_AWC_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_RTW.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_EML_RTW]    Script Date: 12/26/2013 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--  exec [usp_Dashboard_EML_RTW] 2013, 6, 12
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_EML_RTW]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_EML_RTW]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_EML_RTW]
	@yy int,
	@mm int,
	@RollingMonth int, -- 1, 3, 6, 12
	@AsAt datetime
AS
BEGIN
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL DROP TABLE #measures
	
	declare @SQL varchar(500)
	
	declare @measure_month_13 int
	declare @measure_month_26 int
	declare @measure_month_52 int
	declare @measure_month_78 int
	declare @measure_month_104 int
	
	declare @remuneration_start datetime
	declare @remuneration_end datetime
	
	declare @transaction_lag_remuneration_start datetime
	declare @transaction_lag_remuneration_end datetime
	
	declare @paystartdt datetime
	
	declare @transaction_lag int	
	
	set @measure_month_13 = 3	-- 13weeks = 3
	set @measure_month_26 = 6	-- 26weeks = 6
	set @measure_month_52 = 12  -- 52weeks = 12
	set @measure_month_78 = 18  -- 78weeks = 18
	set @measure_month_104 = 24 -- 104weeks = 24
	
	set @transaction_lag = 3 -- for EML
	
	set @remuneration_end = cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
	set @remuneration_start = DATEADD(mm,-@RollingMonth, @remuneration_end)
	
	set @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'
	
	set @transaction_lag_remuneration_start = DATEADD(mm, @transaction_lag, @remuneration_start)
	set @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
	
	set @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_Start))
	
	IF OBJECT_ID('tempdb..#claim') IS NULL
	BEGIN
		/* create #claim table to store claim detail info */
		CREATE TABLE #claim
		(
			claim CHAR(19)
			,policyno CHAR(19)
			,renewal_no INT
			,hrswrkwk numeric(5,2)
			,injdate datetime
			,_13WEEKS_ DATETIME
			,_26WEEKS_ DATETIME
			,_52WEEKS_ DATETIME
			,_78WEEKS_ DATETIME
			,_104WEEKS_ DATETIME
			,DAYS13 int
			,DAYS26 int
			,DAYS52 int
			,DAYS78 int
			,DAYS104 int
			,DAYS13_PRD int
			,DAYS26_PRD int
			,DAYS52_PRD int
			,DAYS78_PRD int
			,DAYS104_PRD int
		)	

		/* create index for #claim table */
		SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(claim, policyno, injdate)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #claim
			SELECT	cd.Claim_Number
					, cda.Policy_No
					, Renewal_No
					, cd.Work_Hours
					, cd.Date_of_Injury
					
					-- calculate 13 weeks from date of injury
					, _13WEEKS_ = dateadd(mm, @measure_month_13, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 26 weeks from date of injury
					, _26WEEKS_ = dateadd(mm, @measure_month_26, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 52 weeks from date of injury
					, _52WEEKS_ = dateadd(mm, @measure_month_52, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 78 weeks from date of injury
					, _78WEEKS_ = dateadd(mm, @measure_month_78, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 104 weeks from date of injury
					, _104WEEKS_ = dateadd(mm, @measure_month_104, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					, DAYS13 = 0
					, DAYS26 = 0
					, DAYS52 = 0
					, DAYS78 = 0
					, DAYS104 = 0
					
					,DAYS13_PRD = 0
					,DAYS26_PRD = 0
					,DAYS52_PRD = 0
					,DAYS78_PRD = 0
					,DAYS104_PRD = 0
			FROM dbo.CLAIM_DETAIL cd INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
				AND isnull(cd.Claim_Number,'') <> ''
				AND cd.Date_of_Injury >= @paystartdt
				AND cda.id = (select max(id) 
								from cd_audit cda1 
								where cda1.claim_no = cd.claim_number
									and cda1.create_date < @remuneration_end)
			/* exclude Serious Claims */
			WHERE cd.claim_number COLLATE Latin1_General_CI_AS not in (select Claim_no from [Dart].[dbo].[EML_SIW])
	END
		
	UPDATE #claim
		-- calculate days off work between 13 weeks and date of injury
		SET	DAYS13 = dbo.udf_NoOfDaysWithoutWeekend(injdate, _13WEEKS_) 
				+ (case when datepart(dw,injdate) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 26 weeks and date of injury
		,DAYS26 = dbo.udf_NoOfDaysWithoutWeekend(injdate, _26WEEKS_) 
				+ (case when datepart(dw,injdate) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 52 weeks and date of injury
		,DAYS52 = dbo.udf_NoOfDaysWithoutWeekend(_26WEEKS_, _52WEEKS_) 
				+ (case when datepart(dw,_26WEEKS_) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 78 weeks and date of injury
		,DAYS78 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _78WEEKS_) 
				+ (case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 104 weeks and date of injury
		,DAYS104 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _104WEEKS_) 
				+ (case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end)
		
		/* calculate days off work between MAX(date of injury, remuneration start) 
			and MIN(13 weeks, remuneration end) */
		,	DAYS13_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(injdate, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(injdate, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS26_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(injdate, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(injdate, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS52_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS78_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS104_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end

	
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NULL
	BEGIN
		/* create #rtw_raworig temp table to store transaction data */
		CREATE TABLE #rtw_raworig_temp
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)
			 ,adjflag varchar(1)
			 ,payamt money
			 ,payment_no int
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)

		/* create index for #rtw_raworig_temp table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_temp_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_temp(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #rtw_raworig_temp
		SELECT  pr.Claim_No
				, CONVERT(varchar(10), pr.Transaction_date, 120)
				,pr.WC_Payment_Type
				,rtw_paytype=  (CASE WHEN wc_payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004') 
										THEN 'TI'
									 WHEN wc_payment_type IN ('13', 'WPP001', 'WPP003') 
										THEN 'S38'
									 WHEN wc_payment_type IN ('16', 'WPP002', 'WPP004') 
										THEN 'S40'
									 WHEN wc_payment_type IN ('WPT005', 'WPT006', 'WPT007') 
										THEN 'NOWORKCAP'
									 WHEN wc_payment_type IN ('WPP005', 'WPP006', 'WPP007', 'WPP008') 
										THEN 'WORKCAP' 
								END)
				,Adjust_Trans_Flag
				,Trans_Amount
				,pr.Payment_no
				,Period_Start_Date
				,Period_End_Date
				,pr.hours_per_week
				,hrs_total = (isnull(WC_MINUTES, 0) / 60.0)
								 + isnull(WC_HOURS, 0)
								 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
				,isnull(Rate, 0)
		FROM dbo.Payment_Recovery pr
				INNER JOIN dbo.CLAIM_PAYMENT_RUN
						   ON pr.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
				INNER JOIN #claim cl on pr.Claim_No = cl.claim
		WHERE	Transaction_date >= @paystartdt
				AND Transaction_date <= @AsAt
				AND wc_Tape_Month IS NOT NULL 
				AND LEFT(wc_Tape_Month, 4) <= @yy
				AND wc_Tape_Month <= CONVERT(int, 
										CONVERT(varchar(8), @transaction_lag_remuneration_end,112))
				AND wc_payment_type IN ('WPT001', 'WPT003', 'WPT002'
										 ,'WPT004', 'WPP001', 'WPP003'
										 ,'WPP002', 'WPP004','WPT005'
										 ,'WPT006', 'WPT007', 'WPP005'
										 ,'WPP006', 'WPP007', 'WPP008'
										 ,'13', '14', '15', '16')
										 
		/* Adjust DET weekly field */
	
		SELECT distinct claim, ppstart, ppend, paytype, DET_weekly = max(DET_weekly) 
			INTO #summary
			FROM #rtw_raworig_temp
		GROUP BY claim,
				ppstart, 
				ppend, 
				paytype		

		UPDATE #rtw_raworig_temp 
			SET DET_weekly = su.DET_weekly
			FROM #summary su
			WHERE	#rtw_raworig_temp.claim = su.claim
					AND #rtw_raworig_temp.ppstart = su.ppstart
					AND #rtw_raworig_temp.ppend = su.ppend
					AND #rtw_raworig_temp.paytype = su.paytype
		
		/* end of adjusting DET weekly field */	
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NULL
	BEGIN
		/* create #rtw_raworig table to store transaction data after summarizing step #1 */
		CREATE TABLE #rtw_raworig
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised trasactions by claim, paydate, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig
		SELECT  claim
				,paydate
				,paytype
				,rtw_paytype
				,payamt = (SELECT SUM(payamt)
								FROM #rtw_raworig_temp rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(hrs_total)
								FROM #rtw_raworig_temp rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig_temp rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig_temp rtw
		GROUP BY claim,
				paydate,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
				
		/*	
		Records with payment amount and hours paid for total incapacity are both zero are removed.
		*/
		DELETE FROM #rtw_raworig WHERE hrs_total = 0 and payamt = 0
		
		/*	
			Records with a negative payment amount, but positive hours paid for total incapacity
				have their hours paid changed to be negative.
		*/
		UPDATE #rtw_raworig SET hrs_total = -hrs_total 
			WHERE hrs_total > 0 AND payamt < 0			
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NULL
	BEGIN
		/* create #rtw_raworig_2 table to store transaction data after summarizing for step #2 */
		CREATE TABLE #rtw_raworig_2
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig_2 table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_2_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_2(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised trasactions by claim, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig_2
		SELECT  claim
				,paydate = (SELECT MIN(paydate) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim										
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,rtw_paytype
				,payamt = (SELECT SUM(payamt)
								FROM #rtw_raworig rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(hrs_total)
								FROM #rtw_raworig rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig rtw
		GROUP BY claim,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
				
		/*	
		- Records with payment amount equal to zero are removed;
		- Records associated with payments of pre-reform benefits (s36, s37, s38, s40) with hours
		paid for partial incapacity and hours paid for total incapacity both equal to zero are
		removed;
		*/
		DELETE FROM #rtw_raworig_2 WHERE payamt = 0 or (hrs_total = 0 
			and rtw_paytype in ('TI', 'S38', 'S40'))
	END
	
	IF OBJECT_ID('tempdb..#policy') IS NULL
	BEGIN
		/* create #policy table to store policy info for claim */
		CREATE TABLE #policy
		(
			policyno CHAR(19)
			,renewal_no INT
			,bastarif MONEY
			,wages MONEY
			,const_flag_final int
		)
		
		/* create index for #policy table */
		SET @SQL = 'CREATE INDEX pk_policy_'+CONVERT(VARCHAR, @@SPID)+' ON #policy(policyno, renewal_no)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #policy
			SELECT	POLICY_NO
					, RENEWAL_NO
					, BTP					
					, WAGES0
					, Process_Flags					
				FROM dbo.PREMIUM_DETAIL pd
				WHERE EXISTS (SELECT 1 FROM #claim cd where cd.policyno = pd.POLICY_NO)
				ORDER BY POLICY_NO,RENEWAL_NO
	END
	
	/* create #measures table that contains all of necessary columns 
		for calculating RTW measures */
	CREATE TABLE #measures
	(
		claim CHAR(19)
		,policyno CHAR(19)
		,injdate datetime
		,paytype varchar(9)
		,ppstart datetime
		,ppend datetime
		,payamt money
		,hrs_per_week_adjusted numeric(5,2)
		,weeks_paid_adjusted float
		,hrs_total numeric(14,3)
		,DET_weekly money
		,days_for_TI int
		,LT_TI float
		,LT_S38 float
		,LT_S40 float
		,LT_NWC float
		,LT_WC float
		,empl_size varchar(256)
		,CAP_CUR_13 float	
		,CAP_PRE_13 float	
		,DAYS13_TRANS float
		,DAYS13_TRANS_PRIOR float
		,LT13_TRANS FLOAT
		,LT13_TRANS_PRIOR FLOAT
		,LT13 FLOAT
		,CAP_CUR_26 float	
		,CAP_PRE_26 float	
		,DAYS26_TRANS float
		,DAYS26_TRANS_PRIOR float
		,LT26_TRANS FLOAT
		,LT26_TRANS_PRIOR FLOAT
		,LT26 FLOAT
		,CAP_CUR_52 float
		,CAP_PRE_52 float
		,DAYS52_TRANS float	
		,DAYS52_TRANS_PRIOR float	
		,LT52_TRANS FLOAT	
		,LT52_TRANS_PRIOR FLOAT	
		,LT52 FLOAT
		,CAP_CUR_78 float
		,CAP_PRE_78 float
		,DAYS78_TRANS float	
		,DAYS78_TRANS_PRIOR float	
		,LT78_TRANS FLOAT	
		,LT78_TRANS_PRIOR FLOAT	
		,LT78 FLOAT
		,CAP_CUR_104 float
		,CAP_PRE_104 float
		,DAYS104_TRANS float	
		,DAYS104_TRANS_PRIOR float	
		,LT104_TRANS FLOAT	
		,LT104_TRANS_PRIOR FLOAT	
		,LT104 FLOAT
		,include_13 bit
		,include_26 bit
		,include_52 bit
		,include_78 bit
		,include_104 bit
		,include_13_trans bit
		,include_26_trans bit
		,include_52_trans bit
		,include_78_trans bit
		,include_104_trans bit
		,Total_LT FLOAT
		,_13WEEKS_ DATETIME
		,_26WEEKS_ DATETIME
		,_52WEEKS_ DATETIME
		,_78WEEKS_ DATETIME
		,_104WEEKS_ DATETIME
		,DAYS13_PRD_CALC int
		,DAYS26_PRD_CALC int
		,DAYS52_PRD_CALC int
		,DAYS78_PRD_CALC int
		,DAYS104_PRD_CALC int
		,DAYS13_CALC int
		,DAYS26_CALC int
		,DAYS52_CALC int
		,DAYS78_CALC int
		,DAYS104_CALC int
	)
	 
	/* create index for #measures table */
	SET @SQL = 'CREATE INDEX pk_measures_' + CONVERT(VARCHAR, @@SPID) + ' ON #measures(claim,policyno,injdate)'
	EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #measures
	SELECT DISTINCT 
			pr.Claim
			,cd.policyno
			,injdate
			,pr.rtw_paytype
			,pr.ppstart
			,pr.ppend
			,pr.payamt
			
			-- adjust hours worked per week to be a minimum of 1 and a maximum of 40;
			,hrs_per_week_adjusted = dbo.udf_MinValue(40
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  )
			,weeks_paid_adjusted = 1.0 
									* pr.hrs_total 
									/ nullif(dbo.udf_MinValue(40 
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1 
																else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															end)
														), 0)
			,pr.hrs_total
			,pr.DET_weekly
			
			-- calculate total incapacity days off work
			,days_for_TI = (case when rtw_paytype = 'TI'
										and datepart(dw,pr.ppstart) IN (1,7)
										and datepart(dw,pr.ppend) IN(1,7) 
										and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
									then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
								when pr.ppstart = pr.ppend 
									then 1 
								else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
							end)
							
			-- calculate days off work for pre-reform claims - Total incapacity payment
			,LT_TI = (CASE when	rtw_paytype = 'TI'
								and dbo.udf_MinValue(40 
												   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															 then cd.hrswrkwk 
														  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1
															 then 1 
														  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													 end
													 )
													) >= 35 
								then 1.0 
									 * (pr.hrs_total* 5)
									 / nullif(dbo.udf_MinValue(40
													   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ),0) 
									* dbo.udf_CheckPositiveOrNegative(pr.payamt)
						 when rtw_paytype = 'TI' 
							  and dbo.udf_MinValue(40 
												  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk
														when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1  
														else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													end)
												 ) < 35 
							then 1.0 
								 * (pr.hrs_total * 5 /37.5)
								 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
						else 0 
					END)
					
			-- calculate days off work for pre-reform claims - Section 38 payment
			,LT_S38 = (CASE when rtw_paytype = 'S38'
								 and (case when pr.ppstart = pr.ppend 
												then 1 
										   else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									 end) = 0 
								then 0
							when rtw_paytype = 'S38' 
								 and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													 ) >= 35 
								then 1.0
									 *(case when  rtw_paytype = 'TI' 
													and datepart(dw,pr.ppstart) IN(1,7) 
													and datepart(dw,pr.ppend) IN(1,7) 
													and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
												 then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
											  when pr.ppstart = pr.ppend 
												then 1 
											  else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
										 end) 
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
							when rtw_paytype = 'S38' 
								 and dbo.udf_MinValue(40
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35  
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													) > 0 
								then 1.0
									 *(case	when rtw_paytype = 'TI' 
												 and datepart(dw,pr.ppstart) IN(1,7) 
												 and datepart(dw,pr.ppend) IN(1,7) 
												 and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
											  then DATEDIFF(day,pr.ppstart,pr.ppend) + 1
											when pr.ppstart = pr.ppend 
											  then 1 
											else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									  end)
									  * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									  * dbo.udf_MinValue(40
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1
																else isnull(cd.hrswrkwk,pr.hrs_per_week)
															end)
														 )
									  /37.5
										
							else 0 
					END)
					
			-- calculate days off work for pre-reform claims - Section 40 payment
			,LT_S40 = (CASE when rtw_paytype = 'S40'
								and (case when pr.ppstart = pr.ppend 
												then 1 
										  else
												dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									end) = 0 
								then 0
							when rtw_paytype = 'S40'
								 and dbo.udf_MinValue(40
													  , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
												      ) >= 35 
								then 1.0
									 *(case when  rtw_paytype = 'TI' 
												 and datepart(dw,pr.ppstart) IN(1,7) 
												 and datepart(dw,pr.ppend) IN(1,7) 
												 and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
											 then DATEDIFF(day,pr.ppstart,pr.ppend) + 1
										   when pr.ppstart = pr.ppend 
											 then 1 
										   else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									 end)
									 * 0.75
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
							when rtw_paytype = 'S40' 
								 and dbo.udf_MinValue(40
													 , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) end)
														) < 35
								then 1.0
									 *(case when		rtw_paytype = 'TI' 
													and datepart(dw,pr.ppstart) IN(1,7) 
													and datepart(dw,pr.ppend) IN(1,7) 
													and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
												then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
											when pr.ppstart = pr.ppend 
												then 1 
											else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									   end)
									   * 0.75 
									   * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									   * dbo.udf_MinValue(40
														  , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
																  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															 end)
															)
										/37.5
								else 0 
						END)
						
			-- calculate days off work for post reform claims - no current work capacity
			,LT_NWC = (CASE when rtw_paytype = 'NOWORKCAP' 
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													  end)
													  ) >= 35 
								then 1.0 * (pr.payamt* 5)/ nullif(pr.DET_weekly,0)
							when rtw_paytype = 'NOWORKCAP' 
								 and dbo.udf_MinValue(40 
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35 
								then 1.0 
									 * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									 * 5
									 *dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														  end)
														  )
								else 0 
						END)
						
			-- calculate days off work for post reform claims - current work capacity
			,LT_WC = (CASE when rtw_paytype = 'WORKCAP'
								  and dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1 
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														 end)
														) >= 35 
								 then 1.0 * (pr.payamt* 5) / nullif(pr.DET_weekly,0)
							  when rtw_paytype = 'WORKCAP' 
								  and dbo.udf_MinValue(40 
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ) < 35 
								 then 1.0 
									  * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									  * 5
									  *dbo.udf_MinValue(40
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
																else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															end)
														   )
							  else 0 
						END)
						
			/*  determine employer size: Small, Small-Medium, Medium or Large */
			
			-- set default to Small when missing policy data;
			,EMPL_SIZE = (CASE WHEN pd.bastarif IS NULL OR pd.const_flag_final IS NULL OR pd.wages IS NULL then 'A - Small'
							  WHEN pd.wages <= 300000 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final = 1 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final <> 1 then 'B - Small-Medium'
							  WHEN pd.wages > 1000000 AND pd.wages <= 5000000 then 'C - Medium'
							  WHEN pd.wages > 5000000 AND pd.wages <= 15000000 AND pd.bastarif <= 100000 then 'C - Medium'
							  WHEN pd.wages > 15000000 then 'D - Large'
							  WHEN pd.wages > 5000000 AND pd.bastarif > 100000 then 'D - Large'
							  ELSE 'A - Small'
						 END)
			/*  determine employer size: A, B, C or D */
						 
			/* 13 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate),
													dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End, '2222/01/01')
													) + case when DATEPART(dw,injdate) not in (1,7) 
																then 1 
															else 0 
														end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate),
													dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
													) +	case when DATEPART(dw,injdate) not in (1,7) 
																then 1 
															else 0 
														end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS13_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _13WEEKS_)
										and paydate <= @transaction_lag_remuneration_end 
									then case when dbo.udf_MinDay(@remuneration_End,
															DATEADD(dd, -1, _13WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _13WEEKS_), ppend))
																		) +	case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0 
																			end
										else dbo.udf_MaxValue(0, 
												dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
													dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), ppend))) 
									end
								else 0 
							end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS13_TRANS_PRIOR = case when ppstart < @remuneration_start
											and paydate < DATEADD(MM, @Transaction_lag, _13WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
										then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
															DATEADD(dd, -1, _13WEEKS_), ppend) >= ppstart 
													then dbo.udf_MaxValue(0, 
																dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																		dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																				DATEADD(dd, -1, _13WEEKS_), ppend))
																			) + case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					when rtw_paytype = 'TI' 
																						and DATEPART(dw,ppstart) in (1,7) 
																						and DATEPART(dw,ppend) in (1,7) 
																						and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0 
																				end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _13WEEKS_), ppend)
																					)
															) 
										end
									else 0 
								end
			,LT13_TRANS = 0
			,LT13_TRANS_PRIOR = 0
			,LT13 = 0
			
			/* 13 weeks */
			
			/* 26 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), 
															@remuneration_End, '2222/01/01')
														) + case when DATEPART(dw,injdate) not in (1,7) 
																	then 1 
																else 0 
															end)		
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
														dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), 
																DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
															) + case when DATEPART(dw,injdate) not in (1,7) 
																		then 1 
																	else 0 
																end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS26_TRANS = case when ppstart <= @remuneration_end 
									and paydate < DATEADD(MM, @Transaction_lag, _26WEEKS_)
									and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
														DATEADD(dd, -1, _26WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _26WEEKS_), ppend)
																				)
																		) + case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					 then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0 
																			end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(@remuneration_End, 
																	DATEADD(dd, -1, _26WEEKS_), ppend))) 
										end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS26_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _26WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _26WEEKS_), ppend) >= ppstart 
															then dbo.udf_MaxValue(0, 
																		dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																				dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																						DATEADD(dd, -1, _26WEEKS_), ppend)
																										)
																				) + case when DATEPART(dw,ppstart) not in (1,7) 
																							then 1
																						 when rtw_paytype = 'TI' 
																							and DATEPART(dw,ppstart) in (1,7) 
																							and DATEPART(dw,ppend) in (1,7) 
																							and DATEDIFF(DD,ppstart, ppend) <= 1
																							then 1 + DATEDIFF(DD,ppstart, ppend) 
																						else 0 
																					end
									
											else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _26WEEKS_), ppend)
																					)
																)
										end
									else 0 
								end
			,LT26_TRANS = 0
			,LT26_TRANS_PRIOR = 0
			,LT26 = 0
			
			/* 26 weeks */
			
			/* 52 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS52_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _52WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _52WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _52WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0
												end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(@remuneration_End, 
																	DATEADD(dd, -1, _52WEEKS_), ppend))) 
									end
								else 0 
							end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS52_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _52WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
										then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
															DATEADD(dd, -1, _52WEEKS_), ppend) >= ppstart 
													then dbo.udf_MaxValue(0, 
																dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																		dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																				DATEADD(dd, -1, _52WEEKS_), ppend)
																								)
																		) + case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				 when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0
																			end
												else dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																			DATEADD(dd, -1, _52WEEKS_), ppend)
																							)
																	) 
											end
										else 0
									end
			,LT52_TRANS = 0	
			,LT52_TRANS_PRIOR = 0	
			,LT52 = 0
			
			/* 52 weeks */
			
			/* 78 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS78_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _78WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _78WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _78WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0 
																		end
											else dbo.udf_MaxValue(0, 
														dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																dbo.udf_MinDay(@remuneration_End, 
																		DATEADD(dd, -1, _78WEEKS_), ppend))) 
											end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS78_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _78WEEKS_)
											and paydate <= @transaction_lag_remuneration_start								
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _78WEEKS_), ppend) >= ppstart 
														then dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, 
																					@remuneration_Start), 
																					DATEADD(dd, -1, _78WEEKS_), ppend)
																							)
																			) + case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					 when rtw_paytype = 'TI' 
																							and DATEPART(dw,ppstart) in (1,7) 
																							and DATEPART(dw,ppend) in (1,7) 
																							and DATEDIFF(DD,ppstart, ppend) <= 1
																						then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0 
																				end
														else dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																					DATEADD(dd, -1, _78WEEKS_), ppend)
																									)
																			) 
													end
											else 0 
									end
			,LT78_TRANS = 0	
			,LT78_TRANS_PRIOR = 0
			,LT78 = 0
			
			/* 78 weeks */
			
			/* 104 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS104_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _104WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _104WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _104WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0
																		end
												else dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _104WEEKS_), ppend))) 
										end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS104_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _104WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _104WEEKS_), ppend) >= ppstart 
														then dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, 
																					@remuneration_Start), 
																					DATEADD(dd, -1, _104WEEKS_), ppend)
																									)
																			) +	case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					 when rtw_paytype = 'TI' and DATEPART(dw,ppstart) in (1,7) 
																						and DATEPART(dw,ppend) in (1,7) 
																						and DATEDIFF(DD,ppstart, ppend) <= 1
																						then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0
																				end
											else dbo.udf_MaxValue(0, 
														dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																dbo.udf_MinDay(DATEADD(dd, -1, 
																		@remuneration_Start), 
																		DATEADD(dd, -1, _104WEEKS_), ppend)
																					)
																)
											end
									else 0
								end
			,LT104_TRANS = 0
			,LT104_TRANS_PRIOR = 0
			,LT104 = 0
			
			/* 104 weeks */
			
			/* flags determine transaction's incapacity periods is lied within 13, 26, 52, 78, 104 weeks injury or not */
			,include_13 = (case when (injdate between @remuneration_Start and @remuneration_End) 
									or (_13WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  injdate and _13WEEKS_) 
									or (@remuneration_End between  injdate and _13WEEKS_) 
									then 1 
								else 0 
						  end)
			,include_26 = (case when (injdate between @remuneration_Start and @remuneration_End) 
									or (_26WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  injdate and _26WEEKS_) 
									or (@remuneration_End between  injdate and _26WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_52 = (case when (_26WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _26WEEKS_ and _52WEEKS_) 
									or (@remuneration_End between  _26WEEKS_ and _52WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_78 = (case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_78WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _52WEEKS_ and _78WEEKS_) 
									or (@remuneration_End between  _52WEEKS_ and _78WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_104 = (case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_104WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _52WEEKS_ and _104WEEKS_) 
									or (@remuneration_End between  _52WEEKS_ and _104WEEKS_) 
									then 1 
								 else 0 
							end)
			
			/* flags determine transaction is included in the 13, 26, 52, 78, 104 week measures or not */
			,include_13_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _13WEEKS_) 
											   and pr.paydate <= @transaction_lag_remuneration_end 	
											   then 1 
										  else 0 
									end)
			,include_26_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _26WEEKS_) 
										   and pr.paydate <= @transaction_lag_remuneration_end	
										  then 1 
									  else 0 
								end)
			,include_52_trans = (case when  pr.paydate <  DATEADD(MM, @Transaction_lag, _52WEEKS_) 
											and pr.paydate <= @transaction_lag_remuneration_end 	
										  then 1 
									  else 0 
								end)
			,include_78_trans = (case when  pr.paydate <  DATEADD(MM, @Transaction_lag, _78WEEKS_) 
												and pr.paydate <= @transaction_lag_remuneration_end 	
											  then 1 
										   else 0 
									 end)
			,include_104_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _104WEEKS_) 
											and pr.paydate <= @transaction_lag_remuneration_end 	
											then 1 
										else 0 
								  end)
			
			,Total_LT = 0
			,_13WEEKS_
			,_26WEEKS_
			,_52WEEKS_
			,_78WEEKS_
			,_104WEEKS_
			
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(13 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS13_PRD_CALC = DAYS13_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(26 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS26_PRD_CALC = DAYS26_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(52 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS52_PRD_CALC = DAYS52_PRD 
											
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(78 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS78_PRD_CALC = DAYS78_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(104 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS104_PRD_CALC = DAYS104_PRD 
											  
			/* recalculate days off work between 13 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS13_CALC = DAYS13 
									 
			/* recalculate days off work between 26 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS26_CALC = DAYS26 
									 
			/* recalculate days off work between 52 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS52_CALC = DAYS52 
									 
			/* recalculate days off work between 78 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS78_CALC = DAYS78 
									 
			/* recalculate days off work between 104 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS104_CALC = DAYS104 
	FROM #claim cd INNER JOIN #rtw_raworig_2 pr ON cd.Claim = pr.Claim
				   LEFT JOIN  #policy pd ON pd.policyno = cd.policyno
											AND pd.renewal_no = cd.renewal_no
											AND PR.ppstart <= @remuneration_end

	/* update LT_TRANS and LT_TRANS_PRIOR */
	UPDATE #measures
		SET LT13_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS13_TRANS / nullif(days_for_TI,0)
					    end)
			,LT13_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									else 1.0 
										 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
										 * DAYS13_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT26_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0 
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS26_TRANS / nullif(days_for_TI,0)
							end)
			,LT26_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS26_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT52_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS52_TRANS / nullif(days_for_TI,0)
						   end)
			,LT52_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS52_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT78_TRANS = (case when days_for_TI = 0 then 0 
								else 1.0 
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC)
									 * DAYS78_TRANS / nullif(days_for_TI,0)
						   end)
			,LT78_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
										    * DAYS78_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT104_TRANS = (case when days_for_TI = 0 
									then 0 
								 else 1.0
									  * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									  * DAYS104_TRANS / nullif(days_for_TI,0)
							end)
			,LT104_TRANS_PRIOR = (case when days_for_TI = 0 
											then 0 
									   else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS104_TRANS_PRIOR / nullif(days_for_TI,0)
								 end)
			,Total_LT = (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC)
						* (case when ppend <= @remuneration_end or days_for_TI = 0 
									 then 1
								when ppstart > @remuneration_end 
									 then 0
								else 1.0 
									 * dbo.udf_NoOfDaysWithoutWeekend(ppstart, @remuneration_end) 
									 / nullif(days_for_TI,0)
						  end)

	/* end of updating LT_TRANS and LT_TRANS_PRIOR */
	
	/* delete small transactions */

	/* small transactions with $2 per day for S40 and WC payments */
	DELETE FROM #measures WHERE (CASE WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted >= 35 
											AND (1.0 * payamt / nullif(days_for_TI,0)) < 2 
										THEN 1
									 WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted < 35 
											AND (1.0 * payamt / nullif(((days_for_TI*hrs_per_week_adjusted)/37.5),0)) < 2 
										THEN 1 
									 WHEN paytype in ('S40') AND days_for_TI = 0 
											AND LT_S40 <> 0 AND (1.0 * payamt / nullif(LT_S40,0)) < 2  
										THEN 1
									 WHEN paytype in ('WORKCAP') AND LT_WC <> 0 AND (1.0 * payamt / nullif(LT_WC,0)) < 2 
										THEN 1
									 ELSE 0
								  END = 1)

	/* other small transactions with payment amount < $20 per day */
	DELETE FROM #measures WHERE (CASE WHEN  paytype in ('S38','TI','NOWORKCAP') 
										    and (LT_TI + LT_S38 + LT_NWC) <> 0 
										    and (1.0 * payamt / nullif((LT_TI + LT_S38 + LT_NWC),0)) < 20 
										  THEN 1
									  ELSE 0
								 END = 1)
	/* end delete small transactions */
	
	/* Extract claims 13 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @measure_month_13
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL(UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 13
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag

	FROM (
			SELECT rtrim(cla.claim) as Claim_no
					,cla.injdate
					,cla.policyno
					,round(dbo.udf_MinValue(sum(cla.LT13_TRANS), 
									avg(CAP_CUR_13)) - dbo.udf_MinValue(sum(cla.LT13_TRANS_PRIOR), 
																AVG(CAP_PRE_13)), 10) as LT					
					,round(dbo.udf_MinValue(1, 1.0 * DAYS13_PRD_CALC / nullif(DAYS13_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_13WEEKS_
			FROM #measures cla 
			WHERE cla.include_13 = 1 and cla.include_13_trans = 1
			GROUP BY cla.claim,policyno,
					cla.injdate,
					_13WEEKS_,
					DAYS13_PRD_CALC, 
					DAYS13_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 
					and round(sum(LT13_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
				  left join Broker Br on PTD.Broker_No = Br.Broker_no 
				  left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._13WEEKS_,
						  @remuneration_end, cd._13WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._13WEEKS_,
						  @remuneration_end, cd._13WEEKS_))
		
	UNION ALL
	
	/* Extract claims 26 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_26
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL ( UPPER(coa1.First_Name+' '+ coa1.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 26
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag

	FROM (
			SELECT rtrim(cla.claim) as Claim_no
				,cla.injdate
				,cla.policyno
				,round(dbo.udf_MinValue(sum(cla.LT26_TRANS), 
								avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), 
															AVG(CAP_PRE_26)), 10) as LT				
				,round(dbo.udf_MinValue(1, 1.0 * DAYS26_PRD_CALC / nullif(DAYS26_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_26WEEKS_
			FROM #measures cla 
			where cla.include_26 = 1 and cla.include_26_trans = 1
			GROUP BY cla.claim,
					policyno,
					cla.injdate,
					_26WEEKS_,
					DAYS26_PRD_CALC,
					DAYS26_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 
						and round(sum(LT26_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_no = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
	
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2
						WHERE cada2.claim_no = cada1.claim_no
							and cada2.transaction_date <= dbo.udf_MinDay(cd._26WEEKS_,
						  @remuneration_end, cd._26WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._26WEEKS_,
						  @remuneration_end, cd._26WEEKS_))
		
	UNION ALL
	
	/* Extract claims 52 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_52
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL ( UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 52
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag

	FROM (
			SELECT	rtrim(cla.claim) as Claim_no	
					,cla.injdate	
					,cla.policyno	
					,	(round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
										avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																AVG(CAP_PRE_52)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT26_TRANS), 
										avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), 
																AVG(CAP_PRE_26)), 10))
					) as LT						
					,round(dbo.udf_MinValue(1, 1.0 * DAYS52_PRD_CALC / nullif(DAYS52_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_52WEEKS_
			FROM #measures cla
			WHERE cla.include_52 = 1 and cla.include_52_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.injdate,
					_52WEEKS_,
					DAYS52_PRD_CALC, 
					DAYS52_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT52_TRANS),10) > 5	
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._52WEEKS_,
						  @remuneration_end, cd._52WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._52WEEKS_,
						  @remuneration_end, cd._52WEEKS_))
		
	UNION ALL
	
	/* Extract claims 78 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_78
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL ( UPPER(coa1.First_Name+' '+ coa1.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 78
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no
					,cla.injdate	
					,cla.policyno	
					,	(round(dbo.udf_MinValue(sum(cla.LT78_TRANS), 
													avg(CAP_CUR_78)) - dbo.udf_MinValue(sum(cla.LT78_TRANS_PRIOR), 
																							AVG(CAP_PRE_78)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
													avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																							AVG(CAP_PRE_52)), 10))
					) as LT
					,round(dbo.udf_MinValue(1, 1.0 * DAYS78_PRD_CALC / nullif(DAYS78_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_78WEEKS_
			FROM #measures cla
			WHERE cla.include_78 = 1 and cla.include_78_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.injdate,
					_78WEEKS_, 
					DAYS78_PRD_CALC, 
					DAYS78_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT78_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no	
		
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._78WEEKS_,
						  @remuneration_end, cd._78WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._78WEEKS_,
						  @remuneration_end, cd._78WEEKS_))
					
	UNION ALL
	
	/* Extract claims 104 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_104
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL(UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 104
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To	
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no
				,cla.injdate	
				,cla.policyno	
				,	(round(dbo.udf_MinValue(sum(cla.LT104_TRANS), 
									avg(CAP_CUR_104)) - dbo.udf_MinValue(sum(cla.LT104_TRANS_PRIOR), 
																AVG(CAP_PRE_104)), 10)
					- round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
									avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																AVG(CAP_PRE_52)), 10)
				) as LT					
				,round(dbo.udf_MinValue(1, 1.0 * DAYS104_PRD_CALC / nullif(DAYS104_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_104WEEKS_
			FROM #measures cla 
			WHERE cla.include_104 = 1 and cla.include_104_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.injdate,
					_104WEEKS_, 
					DAYS104_PRD_CALC, 
					DAYS104_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT104_TRANS),10) > 5		
		) as cd 
		
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no	
		
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._104WEEKS_,
						  @remuneration_end, cd._104WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._104WEEKS_,
						  @remuneration_end, cd._104WEEKS_))
		
	/* drop all temp table */
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL drop table #measures	
	/* end drop all temp table */
END--------------------------------  
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_RTW] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_RTW] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_RTW] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_RTW_GenerateData.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_EML_RTW_GenerateData]    Script Date: 12/26/2013 14:40:33 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_EML_RTW_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_EML_RTW_GenerateData]
GO

-- For example
-- exec [usp_Dashboard_EML_RTW_GenerateData] 2013, 6
CREATE PROCEDURE [dbo].[usp_Dashboard_EML_RTW_GenerateData]
	@start_period_year int = 2010,
	@start_period_month int = 11	
AS
BEGIN
	SET NOCOUNT ON;
	declare @SQL varchar(500)
	
	declare @measure_month_13 int
	declare @measure_month_26 int
	declare @measure_month_52 int
	declare @measure_month_78 int
	declare @measure_month_104 int
	
	declare @AsAt datetime
	declare @remuneration_start datetime
	declare @remuneration_end datetime
	
	declare @transaction_lag_remuneration_end datetime
	
	declare @paystartdt datetime
	declare @transaction_lag int	
	
	set @measure_month_13 = 3	-- 13weeks = 3
	set @measure_month_26 = 6	-- 26weeks = 6
	set @measure_month_52 = 12  -- 52weeks = 12
	set @measure_month_78 = 18  -- 78weeks = 18
	set @measure_month_104 = 24 -- 104weeks = 24	
	
	set @transaction_lag = 3 -- for EML
	
	---delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[EML_RTW] 
			WHERE remuneration_end in (select distinct top '+@transaction_lag+' remuneration_end 
			from [DART].[dbo].[EML_RTW] order by remuneration_end desc)')
	---end delete--
	
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) + '/' 
										+ CAST(@start_period_month as varchar) + '/01' as datetime)
	declare @end_period datetime = DATEADD(MM, 0, getdate())
	
	declare @loop_time int = datediff(month, @start_period, @end_period)
	declare @i int = @loop_time
	declare @yy int
	declare @mm int
	declare @temp datetime
	
	-- Check temp table existing then drop
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL drop table #claim
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP TABLE #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP TABLE #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP TABLE #rtw_raworig_2
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL drop table #policy
	-- Check temp table existing then drop
	
	/* create #claim table to store claim detail info */
	CREATE TABLE #claim
	(
		claim CHAR(19)
		,policyno CHAR(19)
		,renewal_no INT
		,hrswrkwk numeric(5,2)
		,injdate datetime
		,_13WEEKS_ DATETIME
		,_26WEEKS_ DATETIME
		,_52WEEKS_ DATETIME
		,_78WEEKS_ DATETIME
		,_104WEEKS_ DATETIME
		,DAYS13 int
		,DAYS26 int
		,DAYS52 int
		,DAYS78 int
		,DAYS104 int
		,DAYS13_PRD int
		,DAYS26_PRD int
		,DAYS52_PRD int
		,DAYS78_PRD int
		,DAYS104_PRD int
	)	

	/* create index for #claim table */
	SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(claim, policyno, injdate)'
	EXEC(@SQL)

	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #rtw_raworig temp table to store transaction data */
	CREATE TABLE #rtw_raworig_temp
	(
		 claim varchar(19)
		 ,paydate datetime
		 ,paytype varchar(15)
		 ,rtw_paytype varchar(9)
		 ,adjflag varchar(1)
		 ,payamt money
		 ,payment_no int
		 ,ppstart datetime
		 ,ppend datetime
		 ,hrs_per_week numeric(5,2)
		 ,hrs_total numeric(14,3)
		 ,DET_weekly money
	)

	/* create index for #rtw_raworig_temp table */
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_temp_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_temp(claim, payment_no)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	/* create #rtw_raworig table to store transaction data after summarizing step #1 */
	CREATE TABLE #rtw_raworig
	(
		 claim varchar(19)
		 ,paydate datetime
		 ,paytype varchar(15)
		 ,rtw_paytype varchar(9)
		 ,payamt money
		 ,ppstart datetime
		 ,ppend datetime
		 ,hrs_per_week numeric(5,2)
		 ,hrs_total numeric(14,3)
		 ,DET_weekly money
	)	
	
	/* create index for #rtw_raworig table */
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig(claim, rtw_paytype, paydate)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #rtw_raworig_2 table to store transaction data after summarizing for step #2 */
	CREATE TABLE #rtw_raworig_2
	(
		 claim varchar(19)
		 ,paydate datetime
		 ,rtw_paytype varchar(9)
		 ,payamt money
		 ,ppstart datetime
		 ,ppend datetime
		 ,hrs_per_week numeric(5,2)
		 ,hrs_total numeric(14,3)
		 ,DET_weekly money
	)	
	
	/* create index for #rtw_raworig_2 table */
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_2_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_2(claim, rtw_paytype, paydate)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #policy table to store policy info for claim */
	CREATE TABLE #policy
	(
		policyno CHAR(19)
		,renewal_no INT
		,bastarif MONEY
		,wages MONEY
		,const_flag_final int
	)
	
	/* create index for #policy table */
	SET @SQL = 'CREATE INDEX pk_policy_'+CONVERT(VARCHAR, @@SPID)+' ON #policy(policyno, renewal_no)'
	EXEC(@SQL)

	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	WHILE (@i) >= 0
	BEGIN	
		set @temp = dateadd(mm, @i, @start_period)
		set @yy = year(@temp)
		set @mm = month(@temp)
		
		/* delete all data in the temp tables */
		delete from #claim
		delete from #rtw_raworig_temp
		delete from #rtw_raworig
		delete from #rtw_raworig_2
		delete from #policy
		IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP TABLE #summary
		
		set @remuneration_end = cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
		set @remuneration_start = DATEADD(mm,-12, @remuneration_end) -- get max rolling month = 12
		--set @AsAt = DATEADD(dd, -1, DATEADD(mm, 1, @remuneration_end)) + '23:59'
		
		set @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'		
		set @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
		
		-- use transaction flag = 3
		set @AsAt = @transaction_lag_remuneration_end
		
		set @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_Start))
		
		If NOT EXISTS(select 1 from [DART].[dbo].[EML_RTW] 
							where Year(remuneration_end ) = Year(@remuneration_end) and
							Month(remuneration_end ) = Month(@remuneration_end))
			AND cast(CAST(year(@remuneration_end) as varchar) + '/' +  CAST(month(@remuneration_end) as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN	
		
			print cast(YEAR(@remuneration_end) as varchar) + ' and ' + cast(MONTH(@remuneration_end) as varchar)
			print 'Start to delete data in EML_RTW table first...'
			--delete from dbo.EML_RTW
			--	   where Year(Remuneration_End) = Year(@remuneration_end)
			--			 and Month(Remuneration_End) = Month(@remuneration_end)
			
			/* retrieve claim detail info */
			INSERT INTO #claim
				SELECT	cd.Claim_Number
						, cda.Policy_No
						, Renewal_No
						, cd.Work_Hours
						, cd.Date_of_Injury
						
						-- calculate 13 weeks from date of injury
						, _13WEEKS_ = dateadd(mm, @measure_month_13, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 26 weeks from date of injury
						, _26WEEKS_ = dateadd(mm, @measure_month_26, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 52 weeks from date of injury
						, _52WEEKS_ = dateadd(mm, @measure_month_52, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 78 weeks from date of injury
						, _78WEEKS_ = dateadd(mm, @measure_month_78, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 104 weeks from date of injury
						, _104WEEKS_ = dateadd(mm, @measure_month_104, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						, DAYS13 = 0
						, DAYS26 = 0
						, DAYS52 = 0
						, DAYS78 = 0
						, DAYS104 = 0
						
						,DAYS13_PRD = 0
						,DAYS26_PRD = 0
						,DAYS52_PRD = 0
						,DAYS78_PRD = 0
						,DAYS104_PRD = 0
				FROM dbo.CLAIM_DETAIL cd INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
					AND isnull(cd.Claim_Number,'') <> ''
					AND cd.Date_of_Injury >= @paystartdt
					AND cda.id = (select max(id) 
									from cd_audit cda1 
									where cda1.claim_no = cd.claim_number 
										and cda1.create_date < @remuneration_end)
				/* exclude Serious Claims */
				WHERE cd.claim_number COLLATE Latin1_General_CI_AS not in (select Claim_no from [Dart].[dbo].[EML_SIW])
			
			/* retrieve transactions data */
			INSERT INTO #rtw_raworig_temp
			SELECT  pr.Claim_No
					, CONVERT(varchar(10), pr.Transaction_date, 120)
					,pr.WC_Payment_Type
					,rtw_paytype=  (CASE WHEN wc_payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004') 
											THEN 'TI'
										 WHEN wc_payment_type IN ('13', 'WPP001', 'WPP003') 
											THEN 'S38'
										 WHEN wc_payment_type IN ('16', 'WPP002', 'WPP004') 
											THEN 'S40'
										 WHEN wc_payment_type IN ('WPT005', 'WPT006', 'WPT007') 
											THEN 'NOWORKCAP'
										 WHEN wc_payment_type IN ('WPP005', 'WPP006', 'WPP007', 'WPP008') 
											THEN 'WORKCAP' 
									END)
					,Adjust_Trans_Flag
					,Trans_Amount
					,pr.Payment_no
					,Period_Start_Date
					,Period_End_Date
					,pr.hours_per_week
					,hrs_total = (isnull(WC_MINUTES, 0) / 60.0)
									 + isnull(WC_HOURS, 0)
									 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
					,isnull(Rate, 0)
			FROM dbo.Payment_Recovery pr
					INNER JOIN dbo.CLAIM_PAYMENT_RUN
							   ON pr.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
					INNER JOIN #claim cl on pr.Claim_No = cl.claim
			WHERE	Transaction_date >= @paystartdt
					AND Transaction_date <= @AsAt
					AND wc_Tape_Month IS NOT NULL 
					AND LEFT(wc_Tape_Month, 4) <= @yy
					AND wc_Tape_Month <= CONVERT(int, 
											CONVERT(varchar(8), @transaction_lag_remuneration_end,112))
					AND wc_payment_type IN ('WPT001', 'WPT003', 'WPT002'
											 ,'WPT004', 'WPP001', 'WPP003'
											 ,'WPP002', 'WPP004','WPT005'
											 ,'WPT006', 'WPT007', 'WPP005'
											 ,'WPP006', 'WPP007', 'WPP008'
											 ,'13', '14', '15', '16')
											 
			/* Adjust DET weekly field */
			SELECT distinct claim, ppstart, ppend, paytype, DET_weekly = max(DET_weekly) 
				INTO #summary
				FROM #rtw_raworig_temp
			GROUP BY claim,
					ppstart, 
					ppend, 
					paytype		

			UPDATE #rtw_raworig_temp 
				SET DET_weekly = su.DET_weekly
				FROM #summary su
				WHERE	#rtw_raworig_temp.claim = su.claim
						AND #rtw_raworig_temp.ppstart = su.ppstart
						AND #rtw_raworig_temp.ppend = su.ppend
						AND #rtw_raworig_temp.paytype = su.paytype		
			/* end of adjusting DET weekly field */
			
			/* summarised transactions by claim, paydate, paytype, ppstart, ppend */
			INSERT INTO #rtw_raworig
			SELECT  claim
					,paydate
					,paytype
					,rtw_paytype
					,payamt = (SELECT SUM(payamt)
									FROM #rtw_raworig_temp rtw1 
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paydate = rtw.paydate
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart 
											and rtw1.ppend = rtw.ppend)							
					,ppstart
					,ppend
					,hrs_per_week
					,hrs_total = (SELECT SUM(hrs_total)
									FROM #rtw_raworig_temp rtw1
									WHERE rtw1.claim = rtw.claim 
											and rtw1.paydate = rtw.paydate
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
					,DET_weekly = (SELECT MAX(DET_weekly) 
									FROM #rtw_raworig_temp rtw1
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paydate = rtw.paydate
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
			FROM #rtw_raworig_temp rtw
			GROUP BY claim,
					paydate,
					paytype,
					rtw_paytype,
					ppstart,
					ppend,
					hrs_per_week
					
			/*	
			Records with payment amount and hours paid for total incapacity are both zero are removed.
			*/
			DELETE FROM #rtw_raworig WHERE hrs_total = 0 and payamt = 0
			
			/*	
				Records with a negative payment amount, but positive hours paid for total incapacity
					have their hours paid changed to be negative.
			*/
			UPDATE #rtw_raworig SET hrs_total = -hrs_total 
				WHERE hrs_total > 0 AND payamt < 0
				
			/* summarised trasactions by claim, paytype, ppstart, ppend */
			INSERT INTO #rtw_raworig_2
			SELECT  claim
					,paydate = (SELECT MIN(paydate) 
									FROM #rtw_raworig rtw1
									WHERE	rtw1.claim = rtw.claim										
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
					,rtw_paytype
					,payamt = (SELECT SUM(payamt)
									FROM #rtw_raworig rtw1 
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart 
											and rtw1.ppend = rtw.ppend)							
					,ppstart
					,ppend
					,hrs_per_week
					,hrs_total = (SELECT SUM(hrs_total)
									FROM #rtw_raworig rtw1
									WHERE rtw1.claim = rtw.claim 
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
					,DET_weekly = (SELECT MAX(DET_weekly) 
									FROM #rtw_raworig rtw1
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
			FROM #rtw_raworig rtw
			GROUP BY claim,
					paytype,
					rtw_paytype,
					ppstart,
					ppend,
					hrs_per_week
					
			/*	
			- Records with payment amount equal to zero are removed;
			- Records associated with payments of pre-reform benefits (s36, s37, s38, s40) with hours
			paid for partial incapacity and hours paid for total incapacity both equal to zero are
			removed;
			*/
			DELETE FROM #rtw_raworig_2 WHERE payamt = 0 or (hrs_total = 0 
				and rtw_paytype in ('TI', 'S38', 'S40'))
				
			/* retrieve claim policy info */
			INSERT INTO #policy
				SELECT	POLICY_NO
						, RENEWAL_NO
						, BTP					
						, WAGES0
						, Process_Flags					
					FROM dbo.PREMIUM_DETAIL pd
					WHERE EXISTS (SELECT 1 FROM #claim cd where cd.policyno = pd.POLICY_NO)
					ORDER BY POLICY_NO,RENEWAL_NO
			
			print 'Start to insert data to EML_RTW table...'
			--INSERT INTO dbo.EML_RTW EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 12, @AsAt
			--INSERT INTO dbo.EML_RTW EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 6, @AsAt
			--INSERT INTO dbo.EML_RTW EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 3, @AsAt
			--INSERT INTO dbo.EML_RTW EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 1, @AsAt
			
			INSERT INTO [Dart].[dbo].[EML_RTW]  EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 12, @AsAt
			INSERT INTO [Dart].[dbo].[EML_RTW]  EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 6, @AsAt
			INSERT INTO [Dart].[dbo].[EML_RTW]  EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 3, @AsAt
			INSERT INTO [Dart].[dbo].[EML_RTW]  EXEC [dbo].[usp_Dashboard_EML_RTW] @yy, @mm, 1, @AsAt
			
		END
		set @i = @i - 1
	END
	
	-- drop all temp tables
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL drop table #claim
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP TABLE #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP TABLE #summary
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP TABLE #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP TABLE #rtw_raworig_2
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL drop table #policy
	
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_RTW_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_RTW_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_EML_RTW_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_EML_RTW_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_GenerateData_Master.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_GenerateData_Master]    Script Date: 23/04/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_GenerateData_Master]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_GenerateData_Master]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_GenerateData_Master]
	@System varchar(20)
AS
BEGIN
	-- Setup period in generating data for RTW and AWC
	DECLARE @start_period_year int = 2010
	DECLARE @start_period_month int = 9
	
	-- Setup cut-off date in generating data for Portfolio
	DECLARE @AsAt datetime = null
	
	-- First date of current month
	-- Just run RTW from day 10th of month
	DECLARE @firstDateOfMonth datetime = DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)	
	
	IF UPPER(@System) = 'TMF'
		BEGIN
			-- Just run RTW from day 10th of month
			IF DATEDIFF(DD,@firstDateOfMonth,GETDATE()) >= 9
			BEGIN				
				EXEC usp_Dashboard_TMF_RTW_GenerateData @start_period_year , @start_period_month
				EXEC [Dart].[dbo].[usp_Dashboard_TMF_RTW_AddTargetAndBase_GenerateData]
			END			
			
			EXEC usp_Dashboard_TMF_AWC_GenerateData @start_period_year , @start_period_month			
		END
	ELSE IF UPPER(@System) = 'EML' 
		BEGIN
			-- Just run RTW from day 10th of month
			IF DATEDIFF(DD,@firstDateOfMonth,GETDATE()) >= 9
			BEGIN				
				EXEC usp_Dashboard_EML_RTW_GenerateData @start_period_year , @start_period_month
				EXEC [Dart].[dbo].[usp_Dashboard_EML_RTW_AddTargetAndBase_GenerateData]
			END			
			
			EXEC usp_Dashboard_EML_AWC_GenerateData @start_period_year , @start_period_month			
		END
	ELSE
		BEGIN
			-- Just run RTW from day 10th of month
			IF DATEDIFF(DD,@firstDateOfMonth,GETDATE()) >= 9
			BEGIN				
				EXEC usp_Dashboard_HEM_RTW_GenerateData @start_period_year , @start_period_month
				EXEC [Dart].[dbo].[usp_Dashboard_HEM_RTW_AddTargetAndBase_GenerateData]
			END			
			
			EXEC usp_Dashboard_HEM_AWC_GenerateData @start_period_year , @start_period_month			
		END	
	
	EXEC usp_Dashboard_Portfolio_GenerateData @System,@AsAt
	EXEC usp_CPR_GenerateData_Last3Month @System
	EXEC usp_CPR_GenerateData_Last3Year @System
	
	DECLARE @LastYearDate datetime = DATEADD(WEEK,-52,GETDATE())
	DECLARE @LastYear int = YEAR(@LastYearDate)
	DECLARE @LastYearMonth int = MONTH(@LastYearDate)
	EXEC [Dart].[dbo].[usp_CPR_Monthly_GenerateData] @LastYear, @LastYearMonth
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_GenerateData_Master] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_GenerateData_Master] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_GenerateData_Master] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_GenerateData_Master.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_AWC.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [usp_Dashboard_HEM_AWC] 2013, 1
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_HEM_AWC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_HEM_AWC]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_HEM_AWC]
      @year int = 2011,
      @month int = 1
AS
BEGIN
	SET NOCOUNT ON
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List		
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP table #AWC_list
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL DROP table #policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL DROP table #activity_detail_audit
	
	declare @startdate datetime = cast(cast(@year as char(4)) + '/'  + cast(@month as char(2)) + '/01' as datetime)
	declare @enddate datetime  = dateadd(dd, -1, dateadd(mm, 1, @startdate)) + '23:59'
	
	declare @SQL varchar(500)

	--Check temp table existing then drop	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NULL
	BEGIN
		create table #_CLAIM_ESTIMATE_SUMMARY
		(
			CLAIM_NO varCHAR(19)
			,TotalAmount MONEY
		) 
		
		SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
			 
		INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
			SELECT CLAIM_NO, SUM(ISNULL(Amount, 0))
			FROM ESTIMATE_DETAILS
			GROUP BY claim_no
	END
	
	CREATE TABLE #_Claim_Detail
	(
		policy_no char(19)
		,Claim_no varchar(19)
		,Claim_Closed_Flag CHAR(1)
		,Claim_Liability_Indicator TINYINT
		,renewal_no INT
		,anzsic varchar(255)
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_Detail_'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_Detail(policy_no, Claim_no, Claim_Closed_Flag, Claim_Liability_Indicator)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT INTO #_Claim_Detail
		-- claim detail here
		SELECT  policy_no, 
				Claim_Number,
				Claim_Closed_Flag,
				Claim_Liability_Indicator, 
				Renewal_No,
				anz.DESCRIPTION
		FROM CLAIM_DETAIL cd INNER JOIN CLAIM_ACTIVITY_DETAIL cad 
			ON rtrim(cd.Claim_Number) =  rtrim(cad.Claim_no)
				AND Date_Created <= @enddate AND Claim_Number <> ''
			LEFT OUTER JOIN amendment_exemptions ae ON cd.Claim_Number = ae.claim_no
			LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE
		WHERE ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2 
											WHERE anz2.CODE = anz.CODE),1)

	CREATE TABLE #_Claim_List
	(
		Claim_no varchar(19)
		,EXCLUDE BIT
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_List'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_List(Claim_no, EXCLUDE)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #_Claim_List
	SELECT cd.Claim_no
		   ,EXCLUDE = (CASE WHEN (cd.Claim_Liability_Indicator IN (1,6,12)) 
								 OR (cd.Claim_Liability_Indicator IN (4) 
									AND ces.TotalAmount <= 0) 
								 OR (cd.Claim_Closed_Flag = 'Y' AND ces.TotalAmount = 0)  
							   THEN 1 
						   ELSE 0 
					   END)
	FROM #_Claim_Detail cd INNER JOIN #_CLAIM_ESTIMATE_SUMMARY ces 
									  ON cd.Claim_no = ces.CLAIM_NO

	CREATE TABLE #_Claim_list_adjusted
	(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,WC_Payment_Type varchar(8)
		 ,Payment_Type varchar(15)
		 ,Trans_Amount money
	)
	
	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_
				ON [dbo].[#_Claim_list_adjusted] (submitted_trans_date)
				INCLUDE ([Claim_no])'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT  INTO #_Claim_list_adjusted
	SELECT  u.claim_no
			, submitted_trans_date
			, Period_Start_Date
			, Period_End_Date
			, WC_Payment_Type
			, Payment_Type 
			,Trans_Amount = (SELECT SUM(ISNULL(u1.Trans_Amount, 0))
								FROM uv_submitted_Transaction_Payments u1
								WHERE u1.Claim_No = u.claim_no
								and u1.Period_Start_Date = u.Period_Start_Date
								and u1.Period_End_Date = u.Period_End_Date
								and u1.WC_Payment_Type = u.WC_Payment_Type
								and u1.Payment_Type = u.payment_type)
	FROM uv_submitted_Transaction_Payments u
	WHERE u.submitted_trans_date = (SELECT min(u1.submitted_trans_date) 
									FROM uv_submitted_Transaction_Payments u1 
									WHERE u1.Claim_No = u.claim_no 
										  and u1.Period_Start_Date = u.Period_Start_Date 
										  and u1.Period_End_Date = u.Period_End_Date 
										  and u1.WC_Payment_Type = u.WC_Payment_Type 
										  and u1.Payment_Type = u.payment_type)
		and u.submitted_trans_date between @startdate and @enddate
		and u.WeeklyPayment = 1
	GROUP BY u.claim_no, submitted_trans_date
			 ,Period_Start_Date, Period_End_Date
			 ,WC_Payment_Type, Payment_Type
	ORDER BY claim_no, payment_type, Period_Start_Date, Period_End_Date


	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_Trans_Amount
				ON [dbo].[#_Claim_list_adjusted] (Trans_Amount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	DELETE FROM #_Claim_list_adjusted WHERE Trans_Amount = 0
	DELETE FROM #_Claim_list_adjusted 
		   WHERE CLAIM_NO in (SELECT cla1.claim_no 
							  FROM #_Claim_list_adjusted cla1 
									inner join #_Claim_List cl on cla1.Claim_no = cl.Claim_no 
												and cl.EXCLUDE = 1)

	CREATE TABLE #AWC_list 
	(
		claim_no varchar (19)
		,date_of_injury datetime
	)
	
	SET @SQL = 'CREATE INDEX pk_AWC_list'+CONVERT(VARCHAR, @@SPID)+' ON #AWC_list(Claim_no,date_of_injury)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #AWC_list
		SELECT DISTINCT rtrim(cla.claim_no),ca.Date_of_Injury 
		FROM #_Claim_list_adjusted cla 
			 INNER JOIN cd_audit ca ON cla.Claim_no = ca.claim_no 
									   AND cla.submitted_trans_date between @startdate and @enddate
									   AND ca.id = (SELECT MAX(id) 
													FROM cd_audit 
													WHERE ca.claim_no = claim_no 
													AND create_date < @enddate)
										AND ca.fund <> 98

	/* create #policy table to store policy info for claim */
	CREATE TABLE #policy
	(
		policyno CHAR(19)
		,renewal_no INT
		,bastarif MONEY
		,wages MONEY
		,const_flag_final int
	)
	
	/* create index for #policy table */
	SET @SQL = 'CREATE INDEX pk_policy_'+CONVERT(VARCHAR, @@SPID)+' ON #policy(policyno, renewal_no)'
	EXEC(@SQL)

	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
			
	INSERT INTO #policy
		SELECT	POLICY_NO
				, RENEWAL_NO
				, BTP					
				, WAGES0
				, Process_Flags					
			FROM dbo.PREMIUM_DETAIL pd
			WHERE EXISTS (SELECT 1 FROM #_Claim_Detail cd where cd.policy_no = pd.POLICY_NO)
			ORDER BY POLICY_NO,RENEWAL_NO
			
	/* create #activity_detail_audit table to store policy info for claim */
	CREATE TABLE #activity_detail_audit
	(
		policyno CHAR(19)
		,renewal_no INT
		,tariff INT
		,wages_shifts MONEY
	)
	
	/* create index for #activity_detail_audit table */
	SET @SQL = 'CREATE INDEX pk_activity_detail_audit_'+CONVERT(VARCHAR, @@SPID)
		+' ON #activity_detail_audit(policyno, renewal_no, tariff)'
	EXEC(@SQL)

	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
			
	INSERT INTO #activity_detail_audit
		SELECT Policy_No, Renewal_No, Tariff, SUM(ISNULL(Wages_Shifts, 0))
			FROM ACTIVITY_DETAIL_AUDIT ada
			GROUP BY Policy_No, Renewal_No, Tariff
			HAVING EXISTS (SELECT 1 FROM #_Claim_Detail cd where cd.policy_no = ada.Policy_No)
	
	SELECT	Time_ID = @enddate
			,Claim_no = awc_list.Claim_no
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')
			,awc_list.Date_of_Injury
			,create_date = getdate()
			,cd.policy_no
			,Empl_Size = (CASE WHEN pd.bastarif IS NULL OR pd.const_flag_final IS NULL OR pd.wages IS NULL then 'A - Small'
							  WHEN pd.wages <= 300000 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final = 1 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final <> 1 then 'B - Small-Medium'
							  WHEN pd.wages > 1000000 AND pd.wages <= 5000000 then 'C - Medium'
							  WHEN pd.wages > 5000000 AND pd.wages <= 15000000 AND pd.bastarif <= 100000 then 'C - Medium'
							  WHEN pd.wages > 15000000 then 'D - Large'
							  WHEN pd.wages > 5000000 AND pd.bastarif > 100000 then 'D - Large'
							  ELSE 'A - Small'
						  END)
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			
			-- retrieve portfolio info
			,Portfolio = case when isnull(cd.anzsic,'')<>''
								then
									case when UPPER(cd.anzsic) = 'ACCOMMODATION' 
											or UPPER(cd.anzsic) = 'PUBS, TAVERNS AND BARS' 
											or UPPER(cd.anzsic) = 'CLUBS (HOSPITALITY)' then cd.anzsic
										else 'Other'
									end
								else
									case when LEFT(ada.tariff, 1) = '1' and LEN(ada.tariff) = 7
											then 
												case when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '571000'
													then 'Accommodation'
												when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '572000'
													then 'Pubs, Taverns and Bars'
												when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '574000'
													then 'Clubs'
												else 'Other'
											end
										else 
											case when ada.tariff = 571000 then 'Accommodation'
												when ada.tariff = 572000 then 'Pubs, Taverns and Bars'
												when ada.tariff = 574000 then 'Clubs'
												else 'Other'
											end
									end
							end
		
	FROM	#AWC_list awc_list
			INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = awc_list.claim_no
			LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
			INNER JOIN #_Claim_Detail cd on awc_list.claim_no = cd.Claim_No		
			INNER JOIN cad_audit cada1 on cada1.Claim_No = awc_list.claim_no 
			INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
			LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
          	LEFT JOIN #policy pd on pd.policyno = cd.policy_no and pd.renewal_no = cd.renewal_no 	
          	LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number 
          				FROM CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
							left join Broker Br on PTD.Broker_No = Br.Broker_no 
							left join UnderWriters U on  BR.emi_Contact = U.Alias 
						where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no	
			
			-- for retrieving cell number info
			LEFT JOIN (SELECT CELL_NO, claim_number
						FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
						on cno.Claim_Number = cd.Claim_no
						
			-- for retrieving WIC info
			LEFT JOIN #activity_detail_audit ada 
				ON ada.policyno = cd.policy_no AND ada.renewal_no = cd.renewal_no
					
	WHERE   cada1.id = (SELECT MAX(cada2.id) 
					      FROM  cad_audit cada2 
					      WHERE cada2.claim_no = cada1.claim_no
							    AND cada2.transaction_date <= @enddate) 
			AND coa1.id = (SELECT   MAX(coa2.id) 
						     FROM   CO_audit coa2
						     WHERE  coa2.officer_id = coa1.officer_id
								    AND coa2.create_date <= @enddate)
			AND ada.wages_shifts = (SELECT MAX(ada2.wages_shifts) 
									FROM #activity_detail_audit ada2
									WHERE ada2.policyno = ada.policyno
										AND ada2.renewal_no = ada.renewal_no)
				  
	--drop all temp table
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail	
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP TABLE #AWC_list
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL DROP table #policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL DROP table #activity_detail_audit
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_AWC] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_AWC] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_AWC] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_AWC.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_AWC_GenerateData.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_HEM_AWC_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_HEM_AWC_GenerateData]
Go
-- For example
-- exec [usp_Dashboard_HEM_AWC_GenerateData] 2011, 1
-- this will return all result with time id range from 2011-01-31 23:59 till now

CREATE PROCEDURE [dbo].[usp_Dashboard_HEM_AWC_GenerateData]
	@start_period_year int = 2012,
	@start_period_month int = 10
AS
BEGIN	
	SET NOCOUNT ON;
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) + '/' + CAST(@start_period_month as varchar) + '/01' as datetime)
	declare @end_period datetime = getdate()
	
	declare @loop_time int = DATEDIFF(month, @start_period, @end_period)
	declare @i int = @loop_time 
	declare @temp datetime
	declare @SQL varchar(500)

	---delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[HEM_AWC] 
			WHERE Time_ID in (select distinct top 3 Time_ID 
			from [DART].[dbo].[HEM_AWC] order by Time_ID desc)')
	---end delete--	
	
	--Check temp table existing then drop	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL DROP TABLE #_CLAIM_ESTIMATE_SUMMARY
		
	create table #_CLAIM_ESTIMATE_SUMMARY
	(
		CLAIM_NO varCHAR(19),
		TotalAmount MONEY
	) 
	
	SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		 
	INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
		select CLAIM_NO, SUM(ISNULL(Amount, 0))
		from ESTIMATE_DETAILS
		group by claim_no
	WHILE (@i >= 0)
	BEGIN
		set @temp = DATEADD(mm, @i, @start_period)
		declare @year int = YEAR(@temp)
		declare @month int = MONTH(@temp)
		
		If NOT EXISTS(select 1 from [DART].[dbo].[HEM_AWC] 
							where Year(Time_ID) = @year and
							Month(Time_ID ) = @month)
		   AND cast(CAST(@year as varchar) + '/' +  CAST(@month as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN		
			print @temp
			--delete from dbo.HEM_AWC where Time_ID = DATEADD(dd, -1, DATEADD(mm, 1, @temp)) + '23:59'
			--insert into dbo.HEM_AWC exec usp_Dashboard_HEM_AWC @year, @month
			INSERT INTO [DART].[dbo].[HEM_AWC] exec usp_Dashboard_HEM_AWC @year, @month
		END
		set @i = @i - 1
	END
	
	--drop temp table
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL drop table #_CLAIM_ESTIMATE_SUMMARY	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_AWC_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_AWC_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_AWC_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_AWC_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_HEM_RTW]    Script Date: 12/26/2013 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--  exec [usp_Dashboard_HEM_RTW] 2013, 6, 12
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_HEM_RTW]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_HEM_RTW]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_HEM_RTW]
	@yy int,
	@mm int,
	@RollingMonth int, -- 1, 3, 6, 12
	@AsAt datetime
AS
BEGIN
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL DROP TABLE #measures
	
	declare @SQL varchar(500)
	
	declare @measure_month_13 int
	declare @measure_month_26 int
	declare @measure_month_52 int
	declare @measure_month_78 int
	declare @measure_month_104 int
	
	declare @remuneration_start datetime
	declare @remuneration_end datetime
	
	declare @transaction_lag_remuneration_start datetime
	declare @transaction_lag_remuneration_end datetime
	
	declare @paystartdt datetime
	
	declare @transaction_lag int	
	
	set @measure_month_13 = 3	-- 13weeks = 3
	set @measure_month_26 = 6	-- 26weeks = 6
	set @measure_month_52 = 12  -- 52weeks = 12
	set @measure_month_78 = 18  -- 78weeks = 18
	set @measure_month_104 = 24 -- 104weeks = 24
	
	set @transaction_lag = 3 -- for HEM
	
	set @remuneration_end = cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
	set @remuneration_start = DATEADD(mm,-@RollingMonth, @remuneration_end)
	
	set @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'
	
	set @transaction_lag_remuneration_start = DATEADD(mm, @transaction_lag, @remuneration_start)
	set @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
	
	set @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_Start))
	
	IF OBJECT_ID('tempdb..#claim') IS NULL
	BEGIN
		/* create #claim table to store claim detail info */
		CREATE TABLE #claim
		(
			claim CHAR(19)
			,policyno CHAR(19)
			,renewal_no INT
			,anzsic varchar(255)
			,hrswrkwk numeric(5,2)
			,injdate datetime
			,_13WEEKS_ DATETIME
			,_26WEEKS_ DATETIME
			,_52WEEKS_ DATETIME
			,_78WEEKS_ DATETIME
			,_104WEEKS_ DATETIME
			,DAYS13 int
			,DAYS26 int
			,DAYS52 int
			,DAYS78 int
			,DAYS104 int
			,DAYS13_PRD int
			,DAYS26_PRD int
			,DAYS52_PRD int
			,DAYS78_PRD int
			,DAYS104_PRD int
		)	

		/* create index for #claim table */
		SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(claim, policyno, injdate)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #claim
			SELECT	cd.Claim_Number
					, cda.Policy_No
					, Renewal_No
					, anz.DESCRIPTION
					, cd.Work_Hours
					, cd.Date_of_Injury
					
					-- calculate 13 weeks from date of injury
					, _13WEEKS_ = dateadd(mm, @measure_month_13, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 26 weeks from date of injury
					, _26WEEKS_ = dateadd(mm, @measure_month_26, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 52 weeks from date of injury
					, _52WEEKS_ = dateadd(mm, @measure_month_52, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 78 weeks from date of injury
					, _78WEEKS_ = dateadd(mm, @measure_month_78, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					-- calculate 104 weeks from date of injury
					, _104WEEKS_ = dateadd(mm, @measure_month_104, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
					
					, DAYS13 = 0
					, DAYS26 = 0
					, DAYS52 = 0
					, DAYS78 = 0
					, DAYS104 = 0
					
					,DAYS13_PRD = 0
					,DAYS26_PRD = 0
					,DAYS52_PRD = 0
					,DAYS78_PRD = 0
					,DAYS104_PRD = 0
			FROM dbo.CLAIM_DETAIL cd INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
				AND isnull(cd.Claim_Number,'') <> ''
				AND cd.Date_of_Injury >= @paystartdt
				AND cda.id = (select max(id) 
								from cd_audit cda1 
								where cda1.claim_no = cd.claim_number 
									and cda1.create_date < @remuneration_end)
				LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE
			WHERE ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2 
														WHERE anz2.CODE = anz.CODE), 1)
	END
		
	UPDATE #claim
		-- calculate days off work between 13 weeks and date of injury
		SET	DAYS13 = dbo.udf_NoOfDaysWithoutWeekend(injdate, _13WEEKS_) 
				+ (case when datepart(dw,injdate) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 26 weeks and date of injury
		,DAYS26 = dbo.udf_NoOfDaysWithoutWeekend(injdate, _26WEEKS_) 
				+ (case when datepart(dw,injdate) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 52 weeks and date of injury
		,DAYS52 = dbo.udf_NoOfDaysWithoutWeekend(_26WEEKS_, _52WEEKS_) 
				+ (case when datepart(dw,_26WEEKS_) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 78 weeks and date of injury
		,DAYS78 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _78WEEKS_) 
				+ (case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end)
		
		-- calculate days off work between 104 weeks and date of injury
		,DAYS104 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _104WEEKS_) 
				+ (case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end)
		
		/* calculate days off work between MAX(date of injury, remuneration start) 
			and MIN(13 weeks, remuneration end) */
		,	DAYS13_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(injdate, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(injdate, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS26_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(injdate, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(injdate, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS52_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS78_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
		,	DAYS104_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), @remuneration_End,'2222/01/01'))
						+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
	
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NULL
	BEGIN
		/* create #rtw_raworig temp table to store transaction data */
		CREATE TABLE #rtw_raworig_temp
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)
			 ,adjflag varchar(1)
			 ,payamt money
			 ,payment_no int
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)

		/* create index for #rtw_raworig_temp table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_temp_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_temp(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #rtw_raworig_temp
		SELECT  pr.Claim_No
				, CONVERT(varchar(10), pr.Transaction_date, 120)
				,pr.WC_Payment_Type
				,rtw_paytype=  (CASE WHEN wc_payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004') 
										THEN 'TI'
									 WHEN wc_payment_type IN ('13', 'WPP001', 'WPP003') 
										THEN 'S38'
									 WHEN wc_payment_type IN ('16', 'WPP002', 'WPP004') 
										THEN 'S40'
									 WHEN wc_payment_type IN ('WPT005', 'WPT006', 'WPT007') 
										THEN 'NOWORKCAP'
									 WHEN wc_payment_type IN ('WPP005', 'WPP006', 'WPP007', 'WPP008') 
										THEN 'WORKCAP' 
								END)
				,Adjust_Trans_Flag
				,Trans_Amount
				,pr.Payment_no
				,Period_Start_Date
				,Period_End_Date
				,pr.hours_per_week
				,hrs_total = (isnull(WC_MINUTES, 0) / 60.0)
								 + isnull(WC_HOURS, 0)
								 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
				,isnull(Rate, 0)
		FROM dbo.Payment_Recovery pr
				INNER JOIN dbo.CLAIM_PAYMENT_RUN
						   ON pr.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
				INNER JOIN #claim cl on pr.Claim_No = cl.claim
		WHERE	Transaction_date >= @paystartdt
				AND Transaction_date <= @AsAt
				AND wc_Tape_Month IS NOT NULL 
				AND LEFT(wc_Tape_Month, 4) <= @yy
				AND wc_Tape_Month <= CONVERT(int, 
										CONVERT(varchar(8), @transaction_lag_remuneration_end,112))
				AND wc_payment_type IN ('WPT001', 'WPT003', 'WPT002'
										 ,'WPT004', 'WPP001', 'WPP003'
										 ,'WPP002', 'WPP004','WPT005'
										 ,'WPT006', 'WPT007', 'WPP005'
										 ,'WPP006', 'WPP007', 'WPP008'
										 ,'13', '14', '15', '16')
										 
		/* Adjust DET weekly field */
	
		SELECT distinct claim, ppstart, ppend, paytype, DET_weekly = max(DET_weekly) 
			INTO #summary
			FROM #rtw_raworig_temp
		GROUP BY claim,
				ppstart, 
				ppend, 
				paytype		

		UPDATE #rtw_raworig_temp 
			SET DET_weekly = su.DET_weekly
			FROM #summary su
			WHERE	#rtw_raworig_temp.claim = su.claim
					AND #rtw_raworig_temp.ppstart = su.ppstart
					AND #rtw_raworig_temp.ppend = su.ppend
					AND #rtw_raworig_temp.paytype = su.paytype
		
		/* end of adjusting DET weekly field */	
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NULL
	BEGIN
		/* create #rtw_raworig table to store transaction data after summarizing step #1 */
		CREATE TABLE #rtw_raworig
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised trasactions by claim, paydate, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig
		SELECT  claim
				,paydate
				,paytype
				,rtw_paytype
				,payamt = (SELECT SUM(payamt)
								FROM #rtw_raworig_temp rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(hrs_total)
								FROM #rtw_raworig_temp rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig_temp rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig_temp rtw
		GROUP BY claim,
				paydate,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
				
		/*	
		Records with payment amount and hours paid for total incapacity are both zero are removed.
		*/
		DELETE FROM #rtw_raworig WHERE hrs_total = 0 and payamt = 0
		
		/*	
			Records with a negative payment amount, but positive hours paid for total incapacity
				have their hours paid changed to be negative.
		*/
		UPDATE #rtw_raworig SET hrs_total = -hrs_total 
			WHERE hrs_total > 0 AND payamt < 0			
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NULL
	BEGIN
		/* create #rtw_raworig_2 table to store transaction data after summarizing for step #2 */
		CREATE TABLE #rtw_raworig_2
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig_2 table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_2_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_2(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised trasactions by claim, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig_2
		SELECT  claim
				,paydate = (SELECT MIN(paydate) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim										
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,rtw_paytype
				,payamt = (SELECT SUM(payamt)
								FROM #rtw_raworig rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(hrs_total)
								FROM #rtw_raworig rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig rtw
		GROUP BY claim,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
				
		/*	
		- Records with payment amount equal to zero are removed;
		- Records associated with payments of pre-reform benefits (s36, s37, s38, s40) with hours
		paid for partial incapacity and hours paid for total incapacity both equal to zero are
		removed;
		*/
		DELETE FROM #rtw_raworig_2 WHERE payamt = 0 or (hrs_total = 0 
			and rtw_paytype in ('TI', 'S38', 'S40'))
	END
	
	IF OBJECT_ID('tempdb..#policy') IS NULL
	BEGIN
		/* create #policy table to store policy info for claim */
		CREATE TABLE #policy
		(
			policyno CHAR(19)
			,renewal_no INT
			,bastarif MONEY
			,wages MONEY
			,const_flag_final int
		)
		
		/* create index for #policy table */
		SET @SQL = 'CREATE INDEX pk_policy_'+CONVERT(VARCHAR, @@SPID)+' ON #policy(policyno, renewal_no)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #policy
			SELECT	POLICY_NO
					, RENEWAL_NO
					, BTP					
					, WAGES0
					, Process_Flags					
				FROM dbo.PREMIUM_DETAIL pd
				WHERE EXISTS (SELECT 1 FROM #claim cd where cd.policyno = pd.POLICY_NO)
				ORDER BY POLICY_NO,RENEWAL_NO
	END
	
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NULL
	BEGIN
		/* create #activity_detail_audit table to store policy info for claim */
		CREATE TABLE #activity_detail_audit
		(
			policyno CHAR(19)
			,renewal_no INT
			,tariff INT
			,wages_shifts MONEY
		)
		
		/* create index for #activity_detail_audit table */
		SET @SQL = 'CREATE INDEX pk_activity_detail_audit_'+CONVERT(VARCHAR, @@SPID)
			+' ON #activity_detail_audit(policyno, renewal_no, tariff)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
				
		INSERT INTO #activity_detail_audit
			SELECT Policy_No, Renewal_No, Tariff, SUM(ISNULL(Wages_Shifts, 0))
				FROM ACTIVITY_DETAIL_AUDIT ada
				GROUP BY Policy_No, Renewal_No, Tariff
				HAVING EXISTS (SELECT 1 FROM #claim cd where cd.policyno = ada.Policy_No)
	END
	
	/* create #measures table that contains all of necessary columns 
		for calculating RTW measures */
	CREATE TABLE #measures
	(
		claim CHAR(19)
		,policyno CHAR(19)
		,portfolio varchar(256)
		,injdate datetime
		,paytype varchar(9)
		,ppstart datetime
		,ppend datetime
		,payamt money
		,hrs_per_week_adjusted numeric(5,2)
		,weeks_paid_adjusted float
		,hrs_total numeric(14,3)
		,DET_weekly money
		,days_for_TI int
		,LT_TI float
		,LT_S38 float
		,LT_S40 float
		,LT_NWC float
		,LT_WC float
		,empl_size varchar(256)
		,CAP_CUR_13 float	
		,CAP_PRE_13 float	
		,DAYS13_TRANS float
		,DAYS13_TRANS_PRIOR float
		,LT13_TRANS FLOAT
		,LT13_TRANS_PRIOR FLOAT
		,LT13 FLOAT
		,CAP_CUR_26 float	
		,CAP_PRE_26 float	
		,DAYS26_TRANS float
		,DAYS26_TRANS_PRIOR float
		,LT26_TRANS FLOAT
		,LT26_TRANS_PRIOR FLOAT
		,LT26 FLOAT
		,CAP_CUR_52 float
		,CAP_PRE_52 float
		,DAYS52_TRANS float	
		,DAYS52_TRANS_PRIOR float	
		,LT52_TRANS FLOAT	
		,LT52_TRANS_PRIOR FLOAT	
		,LT52 FLOAT
		,CAP_CUR_78 float
		,CAP_PRE_78 float
		,DAYS78_TRANS float	
		,DAYS78_TRANS_PRIOR float	
		,LT78_TRANS FLOAT	
		,LT78_TRANS_PRIOR FLOAT	
		,LT78 FLOAT
		,CAP_CUR_104 float
		,CAP_PRE_104 float
		,DAYS104_TRANS float	
		,DAYS104_TRANS_PRIOR float	
		,LT104_TRANS FLOAT	
		,LT104_TRANS_PRIOR FLOAT	
		,LT104 FLOAT
		,include_13 bit
		,include_26 bit
		,include_52 bit
		,include_78 bit
		,include_104 bit
		,include_13_trans bit
		,include_26_trans bit
		,include_52_trans bit
		,include_78_trans bit
		,include_104_trans bit
		,Total_LT FLOAT
		,_13WEEKS_ DATETIME
		,_26WEEKS_ DATETIME
		,_52WEEKS_ DATETIME
		,_78WEEKS_ DATETIME
		,_104WEEKS_ DATETIME
		,DAYS13_PRD_CALC int
		,DAYS26_PRD_CALC int
		,DAYS52_PRD_CALC int
		,DAYS78_PRD_CALC int
		,DAYS104_PRD_CALC int
		,DAYS13_CALC int
		,DAYS26_CALC int
		,DAYS52_CALC int
		,DAYS78_CALC int
		,DAYS104_CALC int
	)
	 
	/* create index for #measures table */
	SET @SQL = 'CREATE INDEX pk_measures_' + CONVERT(VARCHAR, @@SPID) + ' ON #measures(claim,policyno,injdate)'
	EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #measures
	SELECT DISTINCT 
			pr.Claim
			,cd.policyno
			,portfolio = case when isnull(cd.anzsic,'')<>''
								then
									case when UPPER(cd.anzsic) = 'ACCOMMODATION' 
											or UPPER(cd.anzsic) = 'PUBS, TAVERNS AND BARS' 
											or UPPER(cd.anzsic) = 'CLUBS (HOSPITALITY)' then cd.anzsic
										else 'Other'
									end
								else
									case when LEFT(ada.tariff, 1) = '1' and LEN(ada.tariff) = 7
											then 
												case when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '571000'
													then 'Accommodation'
												when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '572000'
													then 'Pubs, Taverns and Bars'
												when SUBSTRING(CAST(ada.tariff as CHAR(7)), 2, 6) = '574000'
													then 'Clubs'
												else 'Other'
											end
										else 
											case when ada.tariff = 571000 then 'Accommodation'
												when ada.tariff = 572000 then 'Pubs, Taverns and Bars'
												when ada.tariff = 574000 then 'Clubs'
												else 'Other'
											end
									end
							end
			,injdate
			,pr.rtw_paytype
			,pr.ppstart
			,pr.ppend
			,pr.payamt
			
			-- adjust hours worked per week to be a minimum of 1 and a maximum of 40;
			,hrs_per_week_adjusted = dbo.udf_MinValue(40
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  )
			,weeks_paid_adjusted = 1.0 
									* pr.hrs_total 
									/ nullif(dbo.udf_MinValue(40 
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1 
																else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															end)
														),0)
			,pr.hrs_total
			,pr.DET_weekly
			
			-- calculate total incapacity days off work
			,days_for_TI = (case when rtw_paytype = 'TI'
										and datepart(dw,pr.ppstart) IN (1,7)
										and datepart(dw,pr.ppend) IN(1,7) 
										and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
									then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
								when pr.ppstart = pr.ppend 
									then 1 
								else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
							end)
							
			-- calculate days off work for pre-reform claims - Total incapacity payment
			,LT_TI = (CASE when	rtw_paytype = 'TI'
								and dbo.udf_MinValue(40 
												   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															 then cd.hrswrkwk 
														  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1
															 then 1 
														  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													 end
													 )
													) >= 35 
								then 1.0 
									 * (pr.hrs_total* 5)
									 / nullif(dbo.udf_MinValue(40
													   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ),0) 
									* dbo.udf_CheckPositiveOrNegative(pr.payamt)
						 when rtw_paytype = 'TI' 
							  and dbo.udf_MinValue(40 
												  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk
														when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1  
														else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													end)
												 ) < 35 
							then 1.0 
								 * (pr.hrs_total * 5 / 37.5)
								 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
						else 0 
					END)
					
			-- calculate days off work for pre-reform claims - Section 38 payment
			,LT_S38 = (CASE when rtw_paytype = 'S38'
								 and (case when pr.ppstart = pr.ppend 
												then 1 
										   else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									 end) = 0 
								then 0
							when rtw_paytype = 'S38' 
								 and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													 ) >= 35 
								then 1.0
									 *(case when  rtw_paytype = 'TI' 
													and datepart(dw,pr.ppstart) IN(1,7) 
													and datepart(dw,pr.ppend) IN(1,7) 
													and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
												 then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
											  when pr.ppstart = pr.ppend 
												then 1 
											  else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
										 end) 
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
							when rtw_paytype = 'S38' 
								 and dbo.udf_MinValue(40
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35  
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													) > 0 
								then 1.0
									 *(case	when rtw_paytype = 'TI' 
												 and datepart(dw,pr.ppstart) IN(1,7) 
												 and datepart(dw,pr.ppend) IN(1,7) 
												 and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
											  then DATEDIFF(day,pr.ppstart,pr.ppend) + 1
											when pr.ppstart = pr.ppend 
											  then 1 
											else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									  end)
									  * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									  * dbo.udf_MinValue(40
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1
																else isnull(cd.hrswrkwk,pr.hrs_per_week)
															end)
														 )
									  / 37.5
										
							else 0 
					END)
					
			-- calculate days off work for pre-reform claims - Section 40 payment
			,LT_S40 = (CASE when rtw_paytype = 'S40'
								and (case when pr.ppstart = pr.ppend 
												then 1 
										  else
												dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									end) = 0 
								then 0
							when rtw_paytype = 'S40'
								 and dbo.udf_MinValue(40
													  , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
												      ) >= 35 
								then 1.0
									 *(case when  rtw_paytype = 'TI' 
												 and datepart(dw,pr.ppstart) IN(1,7) 
												 and datepart(dw,pr.ppend) IN(1,7) 
												 and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
											 then DATEDIFF(day,pr.ppstart,pr.ppend) + 1
										   when pr.ppstart = pr.ppend 
											 then 1 
										   else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									 end)
									 * 0.75
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
							when rtw_paytype = 'S40' 
								 and dbo.udf_MinValue(40
													 , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) end)
														) < 35
								then 1.0
									 *(case when		rtw_paytype = 'TI' 
													and datepart(dw,pr.ppstart) IN(1,7) 
													and datepart(dw,pr.ppend) IN(1,7) 
													and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
												then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
											when pr.ppstart = pr.ppend 
												then 1 
											else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									   end)
									   * 0.75 
									   * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									   * dbo.udf_MinValue(40
														  , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
																  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															 end)
															)
										/ 37.5
								else 0 
						END)
						
			-- calculate days off work for post reform claims - no current work capacity
			,LT_NWC = (CASE when rtw_paytype = 'NOWORKCAP' 
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													  end)
													  ) >= 35 
								then 1.0 * (pr.payamt* 5) / nullif(pr.DET_weekly,0)
							when rtw_paytype = 'NOWORKCAP' 
								 and dbo.udf_MinValue(40 
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35 
								then 1.0 
									 * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									 * 5
									 * dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														  end)
														  )
								else 0 
						END)
						
			-- calculate days off work for post reform claims - current work capacity
			,LT_WC = (CASE when rtw_paytype = 'WORKCAP'
								  and dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1 
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														 end)
														) >= 35 
								 then 1.0 * (pr.payamt* 5) / nullif(pr.DET_weekly,0)
							  when rtw_paytype = 'WORKCAP' 
								  and dbo.udf_MinValue(40 
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ) < 35 
								 then 1.0 
									  * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									  *5
									  *dbo.udf_MinValue(40
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
																else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															end)
														   )
							  else 0 
						END)
						
			/*  determine employer size: Small, Smal-Medium, Medium or Large */
			
			-- set default to Small when missing policy data;
			,EMPL_SIZE = (CASE WHEN pd.bastarif IS NULL OR pd.const_flag_final IS NULL OR pd.wages IS NULL then 'A - Small'
							  WHEN pd.wages <= 300000 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final = 1 then 'A - Small'
							  WHEN pd.wages > 300000 AND pd.wages <= 1000000 AND pd.const_flag_final <> 1 then 'B - Small-Medium'
							  WHEN pd.wages > 1000000 AND pd.wages <= 5000000 then 'C - Medium'
							  WHEN pd.wages > 5000000 AND pd.wages <= 15000000 AND pd.bastarif <= 100000 then 'C - Medium'
							  WHEN pd.wages > 15000000 then 'D - Large'
							  WHEN pd.wages > 5000000 AND pd.bastarif > 100000 then 'D - Large'
							  ELSE 'A - Small'
						  END)
			/*  determine employer size: Small, Smal-Medium, Medium or Large */
						 
			/* 13 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate),
													dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End, '2222/01/01')
													) + case when DATEPART(dw,injdate) not in (1,7) 
																then 1 
															else 0 
														end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate),
													dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
													) +	case when DATEPART(dw,injdate) not in (1,7) 
																then 1 
															else 0 
														end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS13_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _13WEEKS_)
										and paydate <= @transaction_lag_remuneration_end 
									then case when dbo.udf_MinDay(@remuneration_End,
															DATEADD(dd, -1, _13WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _13WEEKS_), ppend))
																		) +	case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0 
																			end
										else dbo.udf_MaxValue(0, 
												dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
													dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), ppend))) 
									end
								else 0 
							end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS13_TRANS_PRIOR = case when ppstart < @remuneration_start
											and paydate < DATEADD(MM, @Transaction_lag, _13WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
										then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
															DATEADD(dd, -1, _13WEEKS_), ppend) >= ppstart 
													then dbo.udf_MaxValue(0, 
																dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																		dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																				DATEADD(dd, -1, _13WEEKS_), ppend))
																			) + case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					when rtw_paytype = 'TI' 
																						and DATEPART(dw,ppstart) in (1,7) 
																						and DATEPART(dw,ppend) in (1,7) 
																						and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0 
																				end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _13WEEKS_), ppend)
																					)
															) 
										end
									else 0 
								end
			,LT13_TRANS = 0
			,LT13_TRANS_PRIOR = 0
			,LT13 = 0
			
			/* 13 weeks */
			
			/* 26 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), 
															@remuneration_End, '2222/01/01')
														) + case when DATEPART(dw,injdate) not in (1,7) 
																	then 1 
																else 0 
															end)		
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
														dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), 
																DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
															) + case when DATEPART(dw,injdate) not in (1,7) 
																		then 1 
																	else 0 
																end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS26_TRANS = case when ppstart <= @remuneration_end 
									and paydate < DATEADD(MM, @Transaction_lag, _26WEEKS_)
									and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
														DATEADD(dd, -1, _26WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _26WEEKS_), ppend)
																				)
																		) + case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					 then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0 
																			end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(@remuneration_End, 
																	DATEADD(dd, -1, _26WEEKS_), ppend))) 
										end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS26_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _26WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _26WEEKS_), ppend) >= ppstart 
															then dbo.udf_MaxValue(0, 
																		dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																				dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																						DATEADD(dd, -1, _26WEEKS_), ppend)
																										)
																				) + case when DATEPART(dw,ppstart) not in (1,7) 
																							then 1
																						 when rtw_paytype = 'TI' 
																							and DATEPART(dw,ppstart) in (1,7) 
																							and DATEPART(dw,ppend) in (1,7) 
																							and DATEDIFF(DD,ppstart, ppend) <= 1
																							then 1 + DATEDIFF(DD,ppstart, ppend) 
																						else 0 
																					end
									
											else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _26WEEKS_), ppend)
																					)
																)
										end
									else 0 
								end
			,LT26_TRANS = 0
			,LT26_TRANS_PRIOR = 0
			,LT26 = 0
			
			/* 26 weeks */
			
			/* 52 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS52_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _52WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _52WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _52WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0
												end
										else dbo.udf_MaxValue(0, 
													dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
															dbo.udf_MinDay(@remuneration_End, 
																	DATEADD(dd, -1, _52WEEKS_), ppend))) 
									end
								else 0 
							end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS52_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _52WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
										then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
															DATEADD(dd, -1, _52WEEKS_), ppend) >= ppstart 
													then dbo.udf_MaxValue(0, 
																dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																		dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																				DATEADD(dd, -1, _52WEEKS_), ppend)
																								)
																		) + case when DATEPART(dw,ppstart) not in (1,7) 
																					then 1
																				 when rtw_paytype = 'TI' 
																					and DATEPART(dw,ppstart) in (1,7) 
																					and DATEPART(dw,ppend) in (1,7) 
																					and DATEDIFF(DD,ppstart, ppend) <= 1
																					then 1 + DATEDIFF(DD,ppstart, ppend) 
																				else 0
																			end
												else dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																			DATEADD(dd, -1, _52WEEKS_), ppend)
																							)
																	) 
											end
										else 0
									end
			,LT52_TRANS = 0	
			,LT52_TRANS_PRIOR = 0	
			,LT52 = 0
			
			/* 52 weeks */
			
			/* 78 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) +	case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS78_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _78WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _78WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _78WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0 
																		end
											else dbo.udf_MaxValue(0, 
														dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																dbo.udf_MinDay(@remuneration_End, 
																		DATEADD(dd, -1, _78WEEKS_), ppend))) 
											end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS78_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _78WEEKS_)
											and paydate <= @transaction_lag_remuneration_start								
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _78WEEKS_), ppend) >= ppstart 
														then dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, 
																					@remuneration_Start), 
																					DATEADD(dd, -1, _78WEEKS_), ppend)
																							)
																			) + case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					 when rtw_paytype = 'TI' 
																							and DATEPART(dw,ppstart) in (1,7) 
																							and DATEPART(dw,ppend) in (1,7) 
																							and DATEDIFF(DD,ppstart, ppend) <= 1
																						then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0 
																				end
														else dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																					DATEADD(dd, -1, _78WEEKS_), ppend)
																									)
																			) 
													end
											else 0 
									end
			,LT78_TRANS = 0	
			,LT78_TRANS_PRIOR = 0
			,LT78 = 0
			
			/* 78 weeks */
			
			/* 104 weeks */
			
			-- caps applied to measure, compare with remuneration end as threshold
			,CAP_CUR_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), 
															@remuneration_End, '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- caps applied to measure, compare with remuneration start as threshold
			,CAP_PRE_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, injdate), 
													dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), 
															DATEADD(dd, -1, @remuneration_Start), '2222/01/01')
																			) + case when DATEPART(dw,injdate) not in (1,7) 
																						then 1 
																					else 0 
																				end)
			
			-- determine days off work between payment period start and end dates, compare with remuneration end as threshold
			,DAYS104_TRANS = case when ppstart <= @remuneration_end 
										and paydate < DATEADD(MM, @Transaction_lag, _104WEEKS_)
										and paydate <= @transaction_lag_remuneration_end
									then case when dbo.udf_MinDay(@remuneration_End, 
															DATEADD(dd, -1, _104WEEKS_), ppend) >= ppstart 
												then dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _104WEEKS_), ppend)
																							)
																	) +	case when DATEPART(dw,ppstart) not in (1,7) 
																				then 1
																			 when rtw_paytype = 'TI' 
																				and DATEPART(dw,ppstart) in (1,7) 
																				and DATEPART(dw,ppend) in (1,7) 
																				and DATEDIFF(DD,ppstart, ppend) <= 1
																				then 1 + DATEDIFF(DD,ppstart, ppend) 
																			else 0
																		end
												else dbo.udf_MaxValue(0, 
															dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																	dbo.udf_MinDay(@remuneration_End, 
																			DATEADD(dd, -1, _104WEEKS_), ppend))) 
										end
									else 0
								end
			
			-- determine days off work between payment period start and end dates, compare with remuneration start as threshold
			,DAYS104_TRANS_PRIOR = case when ppstart < @remuneration_start 
											and paydate < DATEADD(MM, @Transaction_lag, _104WEEKS_)
											and paydate <= @transaction_lag_remuneration_start
											then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), 
																	DATEADD(dd, -1, _104WEEKS_), ppend) >= ppstart 
														then dbo.udf_MaxValue(0, 
																	dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																			dbo.udf_MinDay(DATEADD(dd, -1, 
																					@remuneration_Start), 
																					DATEADD(dd, -1, _104WEEKS_), ppend)
																									)
																			) +	case when DATEPART(dw,ppstart) not in (1,7) 
																						then 1
																					 when rtw_paytype = 'TI' and DATEPART(dw,ppstart) in (1,7) 
																						and DATEPART(dw,ppend) in (1,7) 
																						and DATEDIFF(DD,ppstart, ppend) <= 1
																						then 1 + DATEDIFF(DD,ppstart, ppend) 
																					else 0
																				end
											else dbo.udf_MaxValue(0, 
														dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,ppstart), 
																dbo.udf_MinDay(DATEADD(dd, -1, 
																		@remuneration_Start), 
																		DATEADD(dd, -1, _104WEEKS_), ppend)
																					)
																)
											end
									else 0
								end
			,LT104_TRANS = 0
			,LT104_TRANS_PRIOR = 0
			,LT104 = 0
			
			/* 104 weeks */
			
			/* flags determine transaction's incapacity periods is lied within 13, 26, 52, 78, 104 weeks injury or not */
			,include_13 = (case when (injdate between @remuneration_Start and @remuneration_End) 
									or (_13WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  injdate and _13WEEKS_) 
									or (@remuneration_End between  injdate and _13WEEKS_) 
									then 1 
								else 0 
						  end)
			,include_26 = (case when (injdate between @remuneration_Start and @remuneration_End) 
									or (_26WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  injdate and _26WEEKS_) 
									or (@remuneration_End between  injdate and _26WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_52 = (case when (_26WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _26WEEKS_ and _52WEEKS_) 
									or (@remuneration_End between  _26WEEKS_ and _52WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_78 = (case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_78WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _52WEEKS_ and _78WEEKS_) 
									or (@remuneration_End between  _52WEEKS_ and _78WEEKS_) 
									then 1 
								else 0 
						   end)
			,include_104 = (case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (_104WEEKS_ between @remuneration_Start and @remuneration_End) 
									or (@remuneration_Start between  _52WEEKS_ and _104WEEKS_) 
									or (@remuneration_End between  _52WEEKS_ and _104WEEKS_) 
									then 1 
								 else 0 
							end)
			
			/* flags determine transaction is included in the 13, 26, 52, 78, 104 week measures or not */
			,include_13_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _13WEEKS_) 
											   and pr.paydate <= @transaction_lag_remuneration_end 	
											   then 1 
										  else 0 
									end)
			,include_26_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _26WEEKS_) 
										   and pr.paydate <= @transaction_lag_remuneration_end	
										  then 1 
									  else 0 
								end)
			,include_52_trans = (case when  pr.paydate <  DATEADD(MM, @Transaction_lag, _52WEEKS_) 
											and pr.paydate <= @transaction_lag_remuneration_end 	
										  then 1 
									  else 0 
								end)
			,include_78_trans = (case when  pr.paydate <  DATEADD(MM, @Transaction_lag, _78WEEKS_) 
												and pr.paydate <= @transaction_lag_remuneration_end 	
											  then 1 
										   else 0 
									 end)
			,include_104_trans = (case when pr.paydate <  DATEADD(MM, @Transaction_lag, _104WEEKS_) 
											and pr.paydate <= @transaction_lag_remuneration_end 	
											then 1 
										else 0 
								  end)
			
			,Total_LT = 0
			,_13WEEKS_
			,_26WEEKS_
			,_52WEEKS_
			,_78WEEKS_
			,_104WEEKS_
			
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(13 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS13_PRD_CALC = DAYS13_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(26 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS26_PRD_CALC = DAYS26_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(52 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS52_PRD_CALC = DAYS52_PRD 
											
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(78 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS78_PRD_CALC = DAYS78_PRD 
											 
			/* recalculate days off work between MAX(date of injury, remuneration start) 
				and MIN(104 weeks, remuneration end): exclude Saturday or Sunday at right threshold */
			,DAYS104_PRD_CALC = DAYS104_PRD 
											  
			/* recalculate days off work between 13 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS13_CALC = DAYS13 
									 
			/* recalculate days off work between 26 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS26_CALC = DAYS26 
									 
			/* recalculate days off work between 52 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS52_CALC = DAYS52 
									 
			/* recalculate days off work between 78 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS78_CALC = DAYS78 
									 
			/* recalculate days off work between 104 weeks and date of injury: 
				exclude Saturday or Sunday at right threshold */
			,DAYS104_CALC = DAYS104
	FROM #claim cd INNER JOIN #rtw_raworig_2 pr ON cd.Claim = pr.Claim
				   LEFT JOIN  #policy pd ON pd.policyno = cd.policyno
											AND pd.renewal_no = cd.renewal_no
											AND PR.ppstart <= @remuneration_end
					LEFT JOIN #activity_detail_audit ada
							ON ada.policyno = cd.policyno AND ada.renewal_no = cd.renewal_no
	WHERE ada.wages_shifts = (SELECT MAX(ada2.wages_shifts) 
									FROM #activity_detail_audit ada2
									WHERE ada2.policyno = ada.policyno
										AND ada2.renewal_no = ada.renewal_no)

	/* update LT_TRANS and LT_TRANS_PRIOR */
	UPDATE #measures
		SET LT13_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS13_TRANS / nullif(days_for_TI,0)
					    end)
			,LT13_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									else 1.0 
										 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
										 * DAYS13_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT26_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0 
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS26_TRANS / nullif(days_for_TI,0)
							end)
			,LT26_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS26_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT52_TRANS = (case when days_for_TI = 0 
									then 0 
								else 1.0
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									 * DAYS52_TRANS / nullif(days_for_TI,0)
						   end)
			,LT52_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS52_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT78_TRANS = (case when days_for_TI = 0 then 0 
								else 1.0 
									 * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC)
									 * DAYS78_TRANS / nullif(days_for_TI,0)
						   end)
			,LT78_TRANS_PRIOR = (case when days_for_TI = 0 
										then 0 
									  else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
										    * DAYS78_TRANS_PRIOR / nullif(days_for_TI,0)
								end)
			,LT104_TRANS = (case when days_for_TI = 0 
									then 0 
								 else 1.0
									  * (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
									  * DAYS104_TRANS / nullif(days_for_TI,0)
							end)
			,LT104_TRANS_PRIOR = (case when days_for_TI = 0 
											then 0 
									   else 1.0 
											* (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC) 
											* DAYS104_TRANS_PRIOR / nullif(days_for_TI,0)
								 end)
			,Total_LT = (LT_S38 + LT_S40 + LT_TI + LT_NWC + LT_WC)
						* (case when ppend <= @remuneration_end or days_for_TI = 0 
									 then 1
								when ppstart > @remuneration_end 
									 then 0
								else 1.0 
									 * dbo.udf_NoOfDaysWithoutWeekend(ppstart, @remuneration_end) 
									 / nullif(days_for_TI,0)
						  end)

	/* end of updating LT_TRANS and LT_TRANS_PRIOR */
	
	/* delete small transactions */

	/* small transactions with $2 per day for S40 and WC payments */
	DELETE FROM #measures WHERE (CASE WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted >= 35 
											AND (1.0 * payamt / nullif(days_for_TI,0)) < 2 
										THEN 1
									 WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted < 35 
											AND (1.0 * payamt / ((days_for_TI*hrs_per_week_adjusted)/37.5)) < 2 
										THEN 1 
									 WHEN paytype in ('S40') AND days_for_TI = 0 
											AND LT_S40 <> 0 AND (1.0 * payamt / nullif(LT_S40,0)) < 2  
										THEN 1
									 WHEN paytype in ('WORKCAP') AND LT_WC <> 0 AND (1.0 * payamt / nullif(LT_WC,0)) < 2 
										THEN 1
									 ELSE 0
								  END = 1)

	/* other small transactions with payment amount < $20 per day */
	DELETE FROM #measures WHERE (CASE WHEN  paytype in ('S38','TI','NOWORKCAP') 
										    and (LT_TI + LT_S38 + LT_NWC) <> 0 
										    and (1.0 * payamt / nullif((LT_TI + LT_S38 + LT_NWC),0)) < 20
										  THEN 1
									  ELSE 0
								 END = 1)
	/* end delete small transactions */
	
	/* Extract claims 13 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @measure_month_13
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL(UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 13
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
				
	FROM (
			SELECT rtrim(cla.claim) as Claim_no
					,cla.injdate
					,cla.policyno
					,cla.portfolio
					,round(dbo.udf_MinValue(sum(cla.LT13_TRANS), 
									avg(CAP_CUR_13)) - dbo.udf_MinValue(sum(cla.LT13_TRANS_PRIOR), 
																AVG(CAP_PRE_13)), 10) as LT					
					,round(dbo.udf_MinValue(1, 1.0 * DAYS13_PRD_CALC / nullif(DAYS13_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_13WEEKS_
			FROM #measures cla 
			WHERE cla.include_13 = 1 and cla.include_13_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_13WEEKS_,
					DAYS13_PRD_CALC, 
					DAYS13_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 
					and round(sum(LT13_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
				  left join Broker Br on PTD.Broker_No = Br.Broker_no 
				  left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
		
	WHERE cada1.id = (SELECT MAX(cada2.id)
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._13WEEKS_,
						  @remuneration_end, cd._13WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._13WEEKS_,
						  @remuneration_end, cd._13WEEKS_))
		
	UNION ALL
	
	/* Extract claims 26 weeks from #measures table and some additional tables */
	--select  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_26
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL ( UPPER(coa1.First_Name+' '+ coa1.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 26
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag

	FROM (
			SELECT rtrim(cla.claim) as Claim_no
				,cla.injdate
				,cla.policyno
				,cla.portfolio
				,round(dbo.udf_MinValue(sum(cla.LT26_TRANS), 
								avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), 
															AVG(CAP_PRE_26)), 10) as LT				
				,round(dbo.udf_MinValue(1, 1.0 * DAYS26_PRD_CALC / nullif(DAYS26_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_26WEEKS_
			FROM #measures cla 
			where cla.include_26 = 1 and cla.include_26_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_26WEEKS_,
					DAYS26_PRD_CALC,
					DAYS26_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 
						and round(sum(LT26_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_no = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
      			
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2
						WHERE cada2.claim_no = cada1.claim_no
							and cada2.transaction_date <= dbo.udf_MinDay(cd._26WEEKS_,
						  @remuneration_end, cd._26WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._26WEEKS_,
						  @remuneration_end, cd._26WEEKS_))
		
	UNION ALL
	
	/* Extract claims 52 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_52
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL ( UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 52
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no	
					,cla.injdate	
					,cla.policyno
					,cla.portfolio
					,	(round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
										avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																AVG(CAP_PRE_52)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT26_TRANS), 
										avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), 
																AVG(CAP_PRE_26)), 10))
					) as LT						
					,round(dbo.udf_MinValue(1, 1.0 * DAYS52_PRD_CALC / nullif(DAYS52_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_52WEEKS_
			FROM #measures cla
			WHERE cla.include_52 = 1 and cla.include_52_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_52WEEKS_,
					DAYS52_PRD_CALC, 
					DAYS52_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT52_TRANS),10) > 5	
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
		
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._52WEEKS_,
						  @remuneration_end, cd._52WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._52WEEKS_,
						  @remuneration_end, cd._52WEEKS_))
		
	UNION ALL
	
	/* Extract claims 78 weeks from #measures table and some additional tables */
	--SELECT  'Remuneration_Start' = dateadd(mm, 1, @remuneration_start)
	--		,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_78
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL ( UPPER(coa1.First_Name+' '+ coa1.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 78
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no
					,cla.injdate	
					,cla.policyno	
					,cla.portfolio
					,	(round(dbo.udf_MinValue(sum(cla.LT78_TRANS), 
													avg(CAP_CUR_78)) - dbo.udf_MinValue(sum(cla.LT78_TRANS_PRIOR), 
																							AVG(CAP_PRE_78)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
													avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																							AVG(CAP_PRE_52)), 10))
					) as LT
					,round(dbo.udf_MinValue(1, 1.0 * DAYS78_PRD_CALC / nullif(DAYS78_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_78WEEKS_
			FROM #measures cla
			WHERE cla.include_78 = 1 and cla.include_78_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_78WEEKS_, 
					DAYS78_PRD_CALC, 
					DAYS78_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT78_TRANS),10) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no			
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
	
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._78WEEKS_,
						  @remuneration_end, cd._78WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._78WEEKS_,
						  @remuneration_end, cd._78WEEKS_))
					
	UNION ALL
	
	/* Extract claims 104 weeks from #measures table and some additional tables */
	--SELECT  Remuneration_Start = dateadd(mm, 1, @remuneration_start)
	--		,Remuneration_End = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0, @remuneration_end) 
	--			+ @Transaction_lag - 1, 0)) + '23:59'
	SELECT  'Remuneration_Start' = @remuneration_start
			,'Remuneration_End' = @remuneration_end
			,Measure_months = @Measure_month_104
			,Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' 
							OR NOT EXISTS (select distinct grp 
											from claims_officers 
											where active = 1 and len(rtrim(ltrim(grp))) > 0 
												  and grp like co.Grp+'%')
							THEN 'Miscellaneous'
						ELSE RTRIM(UPPER(co.Grp))
					END
			,Case_manager = ISNULL(UPPER(coa1.First_Name + ' ' + coa1.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.injdate
			,cd.policyno
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 104
			,Cert_Type = case when mc.TYPE = 'P' then 'No Time Lost' 
						      when mc.TYPE = 'T' then 'Totally Unfit'
							  when mc.TYPE = 'S' then 'Suitable Duties'
							  when mc.TYPE = 'I' then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' then 'Permanently Modified Duties'
							  else 'Invalid type' end
			,Med_cert_From = mc.Date_From
			,Med_cert_To = mc.Date_To	
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			,cno.CELL_NO as Cell_no
			,cd.portfolio
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.policyno and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
	FROM (
			SELECT	rtrim(cla.claim) as Claim_no
				,cla.injdate	
				,cla.policyno	
				,cla.portfolio
				,	(round(dbo.udf_MinValue(sum(cla.LT104_TRANS), 
									avg(CAP_CUR_104)) - dbo.udf_MinValue(sum(cla.LT104_TRANS_PRIOR), 
																AVG(CAP_PRE_104)), 10)
					- round(dbo.udf_MinValue(sum(cla.LT52_TRANS), 
									avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), 
																AVG(CAP_PRE_52)), 10)
				) as LT					
				,round(dbo.udf_MinValue(1, 1.0 * DAYS104_PRD_CALC / nullif(DAYS104_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_104WEEKS_
			FROM #measures cla 
			WHERE cla.include_104 = 1 and cla.include_104_trans = 1
			GROUP BY cla.claim,
					cla.policyno,
					cla.portfolio,
					cla.injdate,
					_104WEEKS_, 
					DAYS104_PRD_CALC, 
					DAYS104_CALC, 
					cla.EMPL_SIZE
			HAVING round(SUM(total_LT),10) > 5 and round(sum(LT104_TRANS),10) > 5		
		) as cd 
		
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		LEFT JOIN CLAIMS_OFFICERS co ON cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type], Date_From, Date_To
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number from CLAIM_DETAIL cld left join POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
					left join Broker Br on PTD.Broker_No = Br.Broker_no 
					left join UnderWriters U on  BR.emi_Contact = U.Alias 
					where U.is_Active =1 AND U.is_EMLContact = 1 ) as acm on acm.claim_number = cd.claim_no		
		
		-- for retrieving cell number info
		LEFT JOIN (SELECT CELL_NO, claim_number
					FROM CLAIM_DETAIL cld inner join POLICY_TERM_DETAIL ptd on cld.Policy_No = ptd.POLICY_NO) as cno
					on cno.Claim_Number = cd.Claim_no
	
	WHERE cada1.id = (SELECT MAX(cada2.id) 
						FROM cad_audit cada2 
						WHERE cada2.claim_no = cada1.claim_no 
							and cada2.transaction_date <= dbo.udf_MinDay(cd._104WEEKS_,
						  @remuneration_end, cd._104WEEKS_))
		AND coa1.id = (SELECT MAX(coa2.id)
						  FROM CO_audit coa2
						  WHERE coa2.officer_id = coa1.officer_id 
						  and coa2.create_date < dbo.udf_MinDay(cd._104WEEKS_,
						  @remuneration_end, cd._104WEEKS_))
		
	/* drop all temp table */
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL drop table #measures	
	/* end drop all temp table */
END--------------------------------  
-- END of D:\Projects\DbReleaseTool\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Projects\DbReleaseTool\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW_AddTargetAndBase.sql  
--------------------------------  
SET ANSI_NULLS OFF

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW_GenerateData.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_HEM_RTW_GenerateData]    Script Date: 12/26/2013 14:40:33 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_HEM_RTW_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_HEM_RTW_GenerateData]
GO

-- For example
-- exec [usp_Dashboard_HEM_RTW_GenerateData] 2013, 6
CREATE PROCEDURE [dbo].[usp_Dashboard_HEM_RTW_GenerateData]
	@start_period_year int = 2010,
	@start_period_month int = 11	
AS
BEGIN
	SET NOCOUNT ON;
	declare @SQL varchar(500)
	
	declare @measure_month_13 int
	declare @measure_month_26 int
	declare @measure_month_52 int
	declare @measure_month_78 int
	declare @measure_month_104 int
	
	declare @AsAt datetime
	declare @remuneration_start datetime
	declare @remuneration_end datetime
	
	declare @transaction_lag_remuneration_end datetime
	
	declare @paystartdt datetime
	declare @transaction_lag int	
	
	set @measure_month_13 = 3	-- 13weeks = 3
	set @measure_month_26 = 6	-- 26weeks = 6
	set @measure_month_52 = 12  -- 52weeks = 12
	set @measure_month_78 = 18  -- 78weeks = 18
	set @measure_month_104 = 24 -- 104weeks = 24	
	
	set @transaction_lag = 3 -- for HEM
	
	---delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[HEM_RTW] 
			WHERE remuneration_end in (select distinct top '+@transaction_lag+' remuneration_end 
			from [DART].[dbo].[HEM_RTW] order by remuneration_end desc)')
	---end delete--
	
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) + '/' 
										+ CAST(@start_period_month as varchar) + '/01' as datetime)
	declare @end_period datetime = DATEADD(MM, 0, getdate())
	
	declare @loop_time int = datediff(month, @start_period, @end_period)
	declare @i int = @loop_time
	declare @yy int
	declare @mm int
	declare @temp datetime
	
	-- Check temp table existing then drop
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL drop table #claim
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP TABLE #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP TABLE #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP TABLE #rtw_raworig_2
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL drop table #policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL DROP table #activity_detail_audit
	-- Check temp table existing then drop
	
	/* create #claim table to store claim detail info */
	CREATE TABLE #claim
	(
		claim CHAR(19)
		,policyno CHAR(19)
		,renewal_no INT
		,anzsic varchar(255)
		,hrswrkwk numeric(5,2)
		,injdate datetime
		,_13WEEKS_ DATETIME
		,_26WEEKS_ DATETIME
		,_52WEEKS_ DATETIME
		,_78WEEKS_ DATETIME
		,_104WEEKS_ DATETIME
		,DAYS13 int
		,DAYS26 int
		,DAYS52 int
		,DAYS78 int
		,DAYS104 int
		,DAYS13_PRD int
		,DAYS26_PRD int
		,DAYS52_PRD int
		,DAYS78_PRD int
		,DAYS104_PRD int
	)	

	/* create index for #claim table */
	SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID)
		+ ' ON #claim(claim, policyno, injdate)'
	EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #rtw_raworig temp table to store transaction data */
	CREATE TABLE #rtw_raworig_temp
	(
		 claim varchar(19)
		 ,paydate datetime
		 ,paytype varchar(15)
		 ,rtw_paytype varchar(9)
		 ,adjflag varchar(1)
		 ,payamt money
		 ,payment_no int
		 ,ppstart datetime
		 ,ppend datetime
		 ,hrs_per_week numeric(5,2)
		 ,hrs_total numeric(14,3)
		 ,DET_weekly money
	)

	/* create index for #rtw_raworig_temp table */
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_temp_' + CONVERT(VARCHAR, @@SPID) 
		+ ' ON #rtw_raworig_temp(claim, payment_no)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	/* create #rtw_raworig table to store transaction data after summarizing step #1 */
	CREATE TABLE #rtw_raworig
	(
		 claim varchar(19)
		 ,paydate datetime
		 ,paytype varchar(15)
		 ,rtw_paytype varchar(9)
		 ,payamt money
		 ,ppstart datetime
		 ,ppend datetime
		 ,hrs_per_week numeric(5,2)
		 ,hrs_total numeric(14,3)
		 ,DET_weekly money
	)	
	
	/* create index for #rtw_raworig table */
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_' + CONVERT(VARCHAR, @@SPID) 
		+ ' ON #rtw_raworig(claim, rtw_paytype, paydate)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #rtw_raworig_2 table to store transaction data after summarizing for step #2 */
	CREATE TABLE #rtw_raworig_2
	(
		 claim varchar(19)
		 ,paydate datetime
		 ,rtw_paytype varchar(9)
		 ,payamt money
		 ,ppstart datetime
		 ,ppend datetime
		 ,hrs_per_week numeric(5,2)
		 ,hrs_total numeric(14,3)
		 ,DET_weekly money
	)	
	
	/* create index for #rtw_raworig_2 table */
	SET @SQL = 'CREATE INDEX pk_rtw_raworig_2_' + CONVERT(VARCHAR, @@SPID)
		+ ' ON #rtw_raworig_2(claim, rtw_paytype, paydate)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #policy table to store policy info for claim */
	CREATE TABLE #policy
	(
		policyno CHAR(19)
		,renewal_no INT
		,bastarif MONEY
		,wages MONEY
		,const_flag_final int
	)
	
	/* create index for #policy table */
	SET @SQL = 'CREATE INDEX pk_policy_' + CONVERT(VARCHAR, @@SPID)
		+ ' ON #policy(policyno, renewal_no)'
	EXEC(@SQL)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	/* create #activity_detail_audit table to store policy info for claim */
	CREATE TABLE #activity_detail_audit
	(
		policyno CHAR(19)
		,renewal_no INT
		,tariff INT
		,wages_shifts MONEY
	)
	
	/* create index for #activity_detail_audit table */
	SET @SQL = 'CREATE INDEX pk_activity_detail_audit_' + CONVERT(VARCHAR, @@SPID)
		+ ' ON #activity_detail_audit(policyno, renewal_no, tariff)'
	EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	WHILE (@i) >= 0
	BEGIN	
		set @temp = dateadd(mm, @i, @start_period)
		set @yy = year(@temp)
		set @mm = month(@temp)
		
		/* delete all data in the temp tables */
		delete from #claim
		delete from #rtw_raworig_temp
		delete from #rtw_raworig
		delete from #rtw_raworig_2
		delete from #policy
		delete from #activity_detail_audit
		IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP TABLE #summary
		
		set @remuneration_end = cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
		set @remuneration_start = DATEADD(mm,-12, @remuneration_end) -- get max rolling month = 12
		--set @AsAt = DATEADD(dd, -1, DATEADD(mm, 1, @remuneration_end)) + '23:59'
		
		set @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'		
		set @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
		
		-- use transaction flag = 3
		set @AsAt = @transaction_lag_remuneration_end
		
		set @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_Start))
		
		
		If NOT EXISTS(select 1 from [DART].[dbo].[HEM_RTW] 
							where YEAR(remuneration_end) = YEAR(@remuneration_end) and
							MONTH(remuneration_end) = MONTH(@remuneration_end))
			AND cast(CAST(year(@remuneration_end) as varchar) + '/' +  CAST(month(@remuneration_end) as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN		
			print cast(YEAR(@remuneration_end) as varchar) + ' and ' + cast(MONTH(@remuneration_end) as varchar)
			print 'Start to delete data in HEM_RTW table first...'
			--delete from dbo.HEM_RTW
			--	   where year(Remuneration_End) = YEAR(@remuneration_end) 
			--			 and MONTH(Remuneration_End) = MONTH(@remuneration_end)
			
			/* retrieve claim detail info */
			INSERT INTO #claim
				SELECT	cd.Claim_Number
						, cda.Policy_No
						, Renewal_No
						, anz.DESCRIPTION
						, cd.Work_Hours
						, cd.Date_of_Injury
						
						-- calculate 13 weeks from date of injury
						, _13WEEKS_ = dateadd(mm, @measure_month_13, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 26 weeks from date of injury
						, _26WEEKS_ = dateadd(mm, @measure_month_26, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 52 weeks from date of injury
						, _52WEEKS_ = dateadd(mm, @measure_month_52, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 78 weeks from date of injury
						, _78WEEKS_ = dateadd(mm, @measure_month_78, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						-- calculate 104 weeks from date of injury
						, _104WEEKS_ = dateadd(mm, @measure_month_104, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))
						
						, DAYS13 = 0
						, DAYS26 = 0
						, DAYS52 = 0
						, DAYS78 = 0
						, DAYS104 = 0
						
						,DAYS13_PRD = 0
						,DAYS26_PRD = 0
						,DAYS52_PRD = 0
						,DAYS78_PRD = 0
						,DAYS104_PRD = 0
				FROM dbo.CLAIM_DETAIL cd INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
					AND isnull(cd.Claim_Number,'') <> ''
					AND cd.Date_of_Injury >= @paystartdt
					AND cda.id = (select max(id) 
									from cd_audit cda1 
									where cda1.claim_no = cd.claim_number 
										and cda1.create_date < @remuneration_end)
					LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE
				WHERE ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2 
														WHERE anz2.CODE = anz.CODE), 1)
			
			/* retrieve transactions data */
			INSERT INTO #rtw_raworig_temp
			SELECT  pr.Claim_No
					, CONVERT(varchar(10), pr.Transaction_date, 120)
					,pr.WC_Payment_Type
					,rtw_paytype=  (CASE WHEN wc_payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004') 
											THEN 'TI'
										 WHEN wc_payment_type IN ('13', 'WPP001', 'WPP003') 
											THEN 'S38'
										 WHEN wc_payment_type IN ('16', 'WPP002', 'WPP004') 
											THEN 'S40'
										 WHEN wc_payment_type IN ('WPT005', 'WPT006', 'WPT007') 
											THEN 'NOWORKCAP'
										 WHEN wc_payment_type IN ('WPP005', 'WPP006', 'WPP007', 'WPP008') 
											THEN 'WORKCAP' 
									END)
					,Adjust_Trans_Flag
					,Trans_Amount
					,pr.Payment_no
					,Period_Start_Date
					,Period_End_Date
					,pr.hours_per_week
					,hrs_total = (isnull(WC_MINUTES, 0) / 60.0)
									 + isnull(WC_HOURS, 0)
									 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
					,isnull(Rate, 0)
			FROM dbo.Payment_Recovery pr
					INNER JOIN dbo.CLAIM_PAYMENT_RUN
							   ON pr.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
					INNER JOIN #claim cl on pr.Claim_No = cl.claim
			WHERE	Transaction_date >= @paystartdt
					AND Transaction_date <= @AsAt
					AND wc_Tape_Month IS NOT NULL 
					AND LEFT(wc_Tape_Month, 4) <= @yy
					AND wc_Tape_Month <= CONVERT(int, 
											CONVERT(varchar(8), @transaction_lag_remuneration_end,112))
					AND wc_payment_type IN ('WPT001', 'WPT003', 'WPT002'
											 ,'WPT004', 'WPP001', 'WPP003'
											 ,'WPP002', 'WPP004','WPT005'
											 ,'WPT006', 'WPT007', 'WPP005'
											 ,'WPP006', 'WPP007', 'WPP008'
											 ,'13', '14', '15', '16')
											 
			/* Adjust DET weekly field */
			SELECT distinct claim, ppstart, ppend, paytype, DET_weekly = max(DET_weekly) 
				INTO #summary
				FROM #rtw_raworig_temp
			GROUP BY claim,
					ppstart, 
					ppend, 
					paytype		

			UPDATE #rtw_raworig_temp 
				SET DET_weekly = su.DET_weekly
				FROM #summary su
				WHERE	#rtw_raworig_temp.claim = su.claim
						AND #rtw_raworig_temp.ppstart = su.ppstart
						AND #rtw_raworig_temp.ppend = su.ppend
						AND #rtw_raworig_temp.paytype = su.paytype		
			/* end of adjusting DET weekly field */
			
			/* summarised transactions by claim, paydate, paytype, ppstart, ppend */
			INSERT INTO #rtw_raworig
			SELECT  claim
					,paydate
					,paytype
					,rtw_paytype
					,payamt = (SELECT SUM(payamt)
									FROM #rtw_raworig_temp rtw1 
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paydate = rtw.paydate
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart 
											and rtw1.ppend = rtw.ppend)							
					,ppstart
					,ppend
					,hrs_per_week
					,hrs_total = (SELECT SUM(hrs_total)
									FROM #rtw_raworig_temp rtw1
									WHERE rtw1.claim = rtw.claim 
											and rtw1.paydate = rtw.paydate
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
					,DET_weekly = (SELECT MAX(DET_weekly) 
									FROM #rtw_raworig_temp rtw1
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paydate = rtw.paydate
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
			FROM #rtw_raworig_temp rtw
			GROUP BY claim,
					paydate,
					paytype,
					rtw_paytype,
					ppstart,
					ppend,
					hrs_per_week
					
			/*	
			Records with payment amount and hours paid for total incapacity are both zero are removed.
			*/
			DELETE FROM #rtw_raworig WHERE hrs_total = 0 and payamt = 0
			
			/*	
				Records with a negative payment amount, but positive hours paid for total incapacity
					have their hours paid changed to be negative.
			*/
			UPDATE #rtw_raworig SET hrs_total = -hrs_total 
				WHERE hrs_total > 0 AND payamt < 0
				
			/* summarised trasactions by claim, paytype, ppstart, ppend */
			INSERT INTO #rtw_raworig_2
			SELECT  claim
					,paydate = (SELECT MIN(paydate) 
									FROM #rtw_raworig rtw1
									WHERE	rtw1.claim = rtw.claim										
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
					,rtw_paytype
					,payamt = (SELECT SUM(payamt)
									FROM #rtw_raworig rtw1 
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart 
											and rtw1.ppend = rtw.ppend)							
					,ppstart
					,ppend
					,hrs_per_week
					,hrs_total = (SELECT SUM(hrs_total)
									FROM #rtw_raworig rtw1
									WHERE rtw1.claim = rtw.claim 
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
					,DET_weekly = (SELECT MAX(DET_weekly) 
									FROM #rtw_raworig rtw1
									WHERE	rtw1.claim = rtw.claim 
											and rtw1.paytype = rtw.paytype
											and rtw1.ppstart = rtw.ppstart
											and rtw1.ppend = rtw.ppend)
			FROM #rtw_raworig rtw
			GROUP BY claim,
					paytype,
					rtw_paytype,
					ppstart,
					ppend,
					hrs_per_week
					
			/*	
			- Records with payment amount equal to zero are removed;
			- Records associated with payments of pre-reform benefits (s36, s37, s38, s40) with hours
			paid for partial incapacity and hours paid for total incapacity both equal to zero are
			removed;
			*/
			DELETE FROM #rtw_raworig_2 WHERE payamt = 0 or (hrs_total = 0 
				and rtw_paytype in ('TI', 'S38', 'S40'))
				
			/* retrieve claim policy info */
			INSERT INTO #policy
				SELECT	POLICY_NO
						, RENEWAL_NO
						, BTP					
						, WAGES0
						, Process_Flags					
					FROM dbo.PREMIUM_DETAIL pd
					WHERE EXISTS (SELECT 1 FROM #claim cd where cd.policyno = pd.POLICY_NO)
					ORDER BY POLICY_NO,RENEWAL_NO
				
			/* retrieve activity detail audit info */
			INSERT INTO #activity_detail_audit
				SELECT Policy_No, Renewal_No, Tariff, SUM(ISNULL(Wages_Shifts, 0))
					FROM ACTIVITY_DETAIL_AUDIT ada
					GROUP BY Policy_No, Renewal_No, Tariff
					HAVING EXISTS (SELECT 1 FROM #claim cd where cd.policyno = ada.Policy_No)
			
			print 'Start to insert data to HEM_RTW table...'
			
			--INSERT INTO dbo.HEM_RTW EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 12, @AsAt
			--INSERT INTO dbo.HEM_RTW EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 6, @AsAt
			--INSERT INTO dbo.HEM_RTW EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 3, @AsAt
			--INSERT INTO dbo.HEM_RTW EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 1, @AsAt
			
			INSERT INTO [Dart].[dbo].[HEM_RTW] EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 12, @AsAt
			INSERT INTO [Dart].[dbo].[HEM_RTW] EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 6, @AsAt
			INSERT INTO [Dart].[dbo].[HEM_RTW] EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 3, @AsAt
			INSERT INTO [Dart].[dbo].[HEM_RTW] EXEC [dbo].[usp_Dashboard_HEM_RTW] @yy, @mm, 1, @AsAt			
			
		END
		SET @i = @i - 1
	END	
	
	-- drop all temp tables
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL drop table #claim
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP TABLE #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP TABLE #summary
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP TABLE #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP TABLE #rtw_raworig_2
	IF OBJECT_ID('tempdb..#policy') IS NOT NULL drop table #policy
	IF OBJECT_ID('tempdb..#activity_detail_audit') IS NOT NULL drop table #activity_detail_audit
	
END

SET ANSI_NULLS OFF

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_HEM_RTW_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_HEM_RTW_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_Portfolio.sql  
--------------------------------  
--exec usp_Dashboard_Portfolio_GenerateData 'EML','2014-03-31 23:59'
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_Portfolio]    Script Date: 27/03/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_Portfolio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_Portfolio]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_Portfolio]
	@System varchar(20),
	@AsAt datetime,
	@Is_Last_Month bit
AS
BEGIN
	SET NOCOUNT ON
	
	/* Drop all temp tables first */
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL DROP table #claim
	IF OBJECT_ID('tempdb..#WCA_EFFECTIVE') IS NOT NULL DROP table #WCA_EFFECTIVE
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL
	IF OBJECT_ID('tempdb..#_incap_date') IS NOT NULL DROP table #_incap_date
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL_2') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL_2
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT') IS NOT NULL DROP table #_WEEKLY_PAYMENT
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP table #rtw_raworig_temp
	IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP table #summary
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP table #rtw_raworig
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP table #rtw_raworig_2
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL DROP table #measures
	
	DECLARE @Start_Date datetime
	DECLARE @Reporting_Date datetime
	SET @Reporting_Date = DATEADD(d, DATEDIFF(d, 0, @AsAt), 0) + '23:59'
	
	-- determine if this is generating data process for last month or not
	IF @Is_Last_Month = 1
	BEGIN
		SET @AsAt = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1) + '23:59' -- get the end of last month as input parameter	
		SET @Start_Date = DATEADD(mm, DATEDIFF(mm,0,@AsAt), 0)
	END
	ELSE
	BEGIN
		SET @AsAt = DATEADD(d, DATEDIFF(d, 0, @AsAt), 0) + '23:59'
		SET @Start_Date = DATEADD(week,-2,DATEADD(d, DATEDIFF(d, 0, @AsAt), 0))
	END
	
	-- previous 1 week from @AsAt
	DECLARE @AsAt_Prev_1_Week datetime
	SET @AsAt_Prev_1_Week = DATEADD(WEEK, -1, @AsAt)
	
	-- previous 2 weeks from @AsAt
	DECLARE @AsAt_Prev_2_Week datetime
	SET @AsAt_Prev_2_Week = DATEADD(WEEK, -2, @AsAt)
	
	-- previous 3 weeks from @AsAt
	DECLARE @AsAt_Prev_3_Week datetime
	SET @AsAt_Prev_3_Week = DATEADD(WEEK, -3, @AsAt)
	
	-- previous 4 weeks from @AsAt
	DECLARE @AsAt_Prev_4_Week datetime
	SET @AsAt_Prev_4_Week = DATEADD(WEEK, -4, @AsAt)
	
	-- next week from @AsAt
	DECLARE @AsAt_Next_Week datetime
	SET @AsAt_Next_Week = DATEADD(WEEK, 1, @AsAt)
	
	-- end day of next week from @AsAt
	DECLARE @AsAt_Next_Week_End datetime
	SET @AsAt_Next_Week_End = DATEADD(wk, 1, DATEADD(dd, 7-(DATEPART(dw, @AsAt)), @AsAt))
	
	DECLARE @_curr_fiscal_yr datetime
	SET @_curr_fiscal_yr = case when MONTH(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) <= 6 
									then CAST(YEAR(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) AS varchar(5)) + '-06-30'
								else CAST(YEAR(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) +1 AS varchar(5)) + '-06-30'	  
							end	
	
	-- FOR EXTRACTING RTW_IMPACTING & CALCULATING ENTITLEMENT WEEKS
	DECLARE @SQL varchar(500)
	
	DECLARE @remuneration_start datetime
	DECLARE @remuneration_end datetime
	
	DECLARE @transaction_lag_remuneration_end datetime
	DECLARE @paystartdt datetime
	
	DECLARE @transaction_lag int
	SET @transaction_lag = 3
	
	DECLARE @RTW_start_date datetime
	SET @RTW_start_date = DATEADD(YY, -3, @AsAt)
	
	SET @remuneration_end = cast(CAST(YEAR(@AsAt) as varchar) + '/' +  CAST(MONTH(@AsAt) as varchar) + '/01' as datetime)
	SET @remuneration_start = DATEADD(mm,-3, @remuneration_end)
	SET @remuneration_end = DATEADD(dd, -1, @remuneration_end) + '23:59'
	
	SET @transaction_lag_remuneration_end = DATEADD(mm, @transaction_lag, @remuneration_end)
	
	SET @paystartdt = DATEADD(mm, -@transaction_lag, DATEADD(YY, -2, @remuneration_start))
	
	IF OBJECT_ID('tempdb..#claim') IS NULL
	BEGIN
		/* create #claim table to store claim detail info */
		CREATE TABLE #claim
		(
			claim CHAR(19)
			,hrswrkwk numeric(5,2)
			,Claim_Closed_Flag char(1)
			,Fund tinyint
			,Agency_id char(10)
			,Claims_Officer varchar(10)
			,is_exempt bit
			,ANZSIC varchar(4)
			,Policy_No char(19)
			,Renewal_No tinyint
			,Cost_Code char(16)
			,Cost_Code2 char(16)
			,Tariff_No int
			,Given_Names varchar(40)
			,Last_Names varchar(40)
			,Employee_no varchar(19)
			,Phone_no varchar(20)
			,Date_of_Birth datetime
			,Date_Notice_Given smalldatetime
			,Mechanism_of_Injury tinyint
			,Nature_of_Injury smallint
			,Employment_Terminated_Reason tinyint
			,Is_Medical_Only bit
			,date_of_injury datetime
			,Claim_Liability_Indicator tinyint
			,WPI numeric(5,2)
			,Work_Status_Code tinyint
			,Result_of_Injury_Code tinyint
			,date_claim_received datetime
			,date_claim_entered datetime
			,date_claim_closed datetime
			,date_claim_reopened datetime
			--,last_weekly_date datetime
		)	

		/* create index for #claim table */
		SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(claim)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #claim
			SELECT	cd.Claim_Number
					,cd.Work_Hours
					,cada.Claim_Closed_Flag
					,cd.Fund
					,ptda.Agency_id
					,cada.Claims_Officer
					,ade.is_exempt
					,cd.ANZSIC
					,cd.Policy_No
					,cd.Renewal_No
					,cd.Cost_Code
					,cd.Cost_Code2
					,cd.Tariff_No
					,cd.Given_Names
					,cd.Last_Names
					,cd.Employee_no
					,cd.Phone_no
					,cd.Date_of_Birth
					,cd.Date_Notice_Given
					,cd.Mechanism_of_Injury
					,cd.Nature_of_Injury
					,cd.Employment_Terminated_Reason
					,cd.Is_Medical_Only
					,cd.Date_of_Injury
					,cada.Claim_Liability_Indicator
					,cada.WPI
					,cada.Work_Status_Code
					,cda.Result_of_Injury_Code
					,cada.date_claim_received
					,cada.Date_Claim_Entered
					,cada.Date_Claim_Closed
					,cada.Date_Claim_reopened
					--,last_weekly_date = (select MAX(Period_End_Date) from Payment_Recovery pr
					--						where pr.Claim_no = cd.Claim_Number
					--							and pr.Reversed = 0
					--							and pr.Period_End_Date is not null
					--							and exists(SELECT VALUE FROM [CONTROL]
					--											WHERE [TYPE] = 'PTYPELIST' and ITEM = 'WEEKLYPAYMENT'
					--												and VALUE LIKE '%' + pr.Payment_Type + '%')
					--							and pr.Transaction_Date <= @AsAt
					--							and pr.wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
					--										,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
					--										,'13','14','15','16'))
			FROM dbo.CLAIM_DETAIL cd 
				LEFT JOIN amendment_exemptions ade on cd.Claim_Number = ade.claim_no 
				LEFT JOIN ptd_audit ptda ON cd.Policy_No = ptda.Policy_No
					AND ptda.id = (SELECT MAX(ptda2.id) 
									FROM ptd_audit ptda2
									WHERE ptda2.policy_no = ptda.policy_no
										  AND ptda2.create_date <= @transaction_lag_remuneration_end)
				INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number
					AND cda.id = (SELECT max(id)
									FROM cd_audit cda1 
									WHERE cda1.claim_no = cd.claim_number
										and cda1.create_date <= @AsAt)
					AND cda.fund not in (1, 3, 98, 99)
				INNER JOIN CAD_AUDIT cada on cada.claim_no = cd.Claim_Number
					AND cada.id = (SELECT MAX(id)
									FROM CAD_AUDIT cada1
									WHERE cada1.Claim_no = cada.Claim_no
										AND cada1.Transaction_Date <= @AsAt)
					AND cada.Claim_Liability_Indicator <> '6'
				AND isnull(cd.Claim_Number,'') <> ''
				AND cd.Fund <> 98
				AND (cada.Claim_Closed_Flag <> 'Y' OR cd.Last_Secure_Date >= DATEADD(YY, -1, DATEADD(d, DATEDIFF(d, 0, @AsAt), 0)))
	END
	
	IF OBJECT_ID('tempdb..#WCA_EFFECTIVE') IS NULL
	BEGIN
		CREATE TABLE #WCA_EFFECTIVE
		(
			claim varchar(19)
			,hrswrkwk numeric(5,2)
			,date_claim_received datetime
			,effective_date datetime
			,Agency_id char(10)
			,is_exempt bit
		)
		
		/* create index for #WCA_EFFECTIVE table */
		SET @SQL = 'CREATE INDEX pk_WCA_EFFECTIVE_' + CONVERT(VARCHAR, @@SPID) + ' ON #WCA_EFFECTIVE(claim)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		/* Find transition date to new calculation */
		INSERT INTO #WCA_EFFECTIVE
			SELECT cd.claim
					,cd.hrswrkwk
					,date_claim_received = case when cd.date_claim_received is null
													then cd.Date_Claim_Entered 
												else cd.date_claim_received
											end
											
					/* First effective date for transition to new calculation for accruing entitlement weeks */
					,effective_date = (SELECT MIN(EFFECTIVE_DATE)
											FROM WORK_CAPACITY_ASSESSMENT
											WHERE CLAIM_NO = cd.claim
												AND EFFECTIVE_DATE is not null)
					,cd.Agency_id
					,cd.is_exempt
				FROM #claim cd
				WHERE cd.Claim_Closed_Flag = 'N'	/* open claims only */
					AND cd.Fund in (2, 4)			/* post 1987 claims only */
	END
	
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NULL
	BEGIN
		CREATE TABLE #_WEEKLY_PAYMENT_ALL
		(
			 claim varchar(19)
			 ,payment_no int
			 ,trans_date datetime
			 ,ppstart datetime
			 ,ppend datetime
			 ,payamt money
			 ,wc_Hours smallint
			 ,wc_Minutes smallint
			 ,hours_per_week numeric(4,2)
			 ,wc_payment_type varchar(15)
			 ,date_claim_received datetime
			 ,Agency_id char(10)
			 ,is_exempt bit
			 ,effective_date datetime
			 ,weeks_paid_old float
			 ,incap_week_start datetime
			 ,incap_week_end datetime
			 ,incap_week_start_new datetime
			 ,incap_week_end_new datetime
			 ,trans_amount_prop money
			 ,calc_method char(3)
			 ,latest_paydate datetime
			 ,latest_paydate_prev datetime
		)

		/* create index for #_WEEKLY_PAYMENT_ALL table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_ALL_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #_WEEKLY_PAYMENT_ALL(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #_WEEKLY_PAYMENT_ALL
		SELECT  pr.Claim_No
				,pr.Payment_no
				,Transaction_date
				,ppstart = case when wca_effect.effective_date > Period_Start_Date and effective_date <= Period_End_Date
									then wca_effect.effective_date
								else Period_Start_Date
							end
				,Period_End_Date
				,payamt = case when (Period_Start_Date is not null OR Period_End_Date is not null)
									AND wca_effect.effective_date > Period_Start_Date and effective_date <= Period_End_Date
									then (Trans_Amount * (DATEDIFF(DAY, wca_effect.effective_date, Period_End_Date) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
										+ (Trans_Amount * (DATEDIFF(DAY, Period_Start_Date, DATEADD(dd, -1, wca_effect.effective_date)) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
								else Trans_Amount
							end
				,wc_Hours = case when (Period_Start_Date is not null OR Period_End_Date is not null)
									AND wca_effect.effective_date > Period_Start_Date and effective_date <= Period_End_Date
									then (wc_Hours * (DATEDIFF(DAY, wca_effect.effective_date, Period_End_Date) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
										+ (wc_Hours * (DATEDIFF(DAY, Period_Start_Date, DATEADD(dd, -1, wca_effect.effective_date)) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
								else wc_Hours
							end
				,wc_Minutes = case when (Period_Start_Date is not null OR Period_End_Date is not null)
									AND wca_effect.effective_date > Period_Start_Date and effective_date <= Period_End_Date
									then (wc_Minutes * (DATEDIFF(DAY, wca_effect.effective_date, Period_End_Date) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
										+ (wc_Minutes * (DATEDIFF(DAY, Period_Start_Date, DATEADD(dd, -1, wca_effect.effective_date)) + 1) / (DATEDIFF(DAY, Period_Start_Date, Period_End_Date) + 1))
								else wc_Minutes
							end
				,hours_per_week = case when pr.hours_per_week < 1
											then wca_effect.hrswrkwk
										else pr.hours_per_week
									end
				,pr.WC_Payment_Type
				,wca_effect.date_claim_received
				,wca_effect.Agency_id
				,wca_effect.is_exempt
				,wca_effect.effective_date
				,weeks_paid_old = null
											
				/* NEW FORMULA */
				,incap_week_start = null
				,incap_week_end = null
				,incap_week_start_new = null
				,incap_week_end_new = null
				,trans_amount_prop = null
				,calc_method = null
				,latest_paydate = (SELECT MAX(Transaction_date)
										FROM dbo.Payment_Recovery pr1
										WHERE pr1.Claim_No = pr.Claim_No
											AND pr1.Transaction_date <= @AsAt
											AND wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
															,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
															,'13','14','15','16'))
				,latest_paydate_prev = null
		FROM dbo.Payment_Recovery pr
				INNER JOIN #WCA_EFFECTIVE wca_effect on pr.Claim_No = wca_effect.claim
		WHERE	Transaction_date <= @AsAt
				AND wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
								,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
								,'13','14','15','16')
				
				/* Data Cleansing 1: remove reversed claims */
				AND ABS(Trans_Amount) > 1
	END
	
	/* Drop unused temp table: #WCA_EFFECTIVE */
	IF OBJECT_ID('tempdb..#WCA_EFFECTIVE') IS NOT NULL DROP table #WCA_EFFECTIVE
	
	IF OBJECT_ID('tempdb..#_incap_date') IS NULL
	BEGIN
		CREATE TABLE #_incap_date
		(
			claim varchar(19),
			incapacity_date datetime
		)
		
		/* create index for #_incap_date table */
		SET @SQL = 'CREATE INDEX pk_incap_date_' + CONVERT(VARCHAR, @@SPID)
			+ ' ON #_incap_date(claim)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		/* Get incapacity date for new calculations */
		INSERT INTO #_incap_date
		SELECT	claim, incapacity_date = MIN(ppstart)
			FROM #_WEEKLY_PAYMENT_ALL
			WHERE date_claim_received >= '2012-10-01'
			GROUP BY claim
			
		/* Get incapacity date for old calculations */
		INSERT INTO #_incap_date
		SELECT	claim, incapacity_date = MIN(ppstart)
			FROM #_WEEKLY_PAYMENT_ALL
			WHERE wc_payment_type in ('WPT005','WPT006','WPT007','WPP005','WPP006','WPP007','WPP008')
				AND payamt > 0
				AND ppstart >= effective_date
				AND date_claim_received < '2012-10-01'
			GROUP BY claim
	END
	
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL_2') IS NULL
	BEGIN
		CREATE TABLE #_WEEKLY_PAYMENT_ALL_2
		(
			 claim varchar(19)
			 ,payment_no int
			 ,trans_date datetime
			 ,ppstart datetime
			 ,ppend datetime
			 ,payamt money
			 ,wc_Hours smallint
			 ,wc_Minutes smallint
			 ,hours_per_week numeric(4,2)
			 ,wc_payment_type varchar(15)
			 ,date_claim_received datetime
			 ,Agency_id char(10)
			 ,is_exempt bit
			 ,effective_date datetime
			 ,weeks_paid_old float
			 ,incap_week_start datetime
			 ,incap_week_end datetime
			 ,incap_week_start_new datetime
			 ,incap_week_end_new datetime
			 ,trans_amount_prop money
			 ,calc_method char(3)
			 ,latest_paydate datetime
			 ,latest_paydate_prev datetime
			 ,incapacity_date datetime
		)

		/* create index for #_WEEKLY_PAYMENT_ALL_2 table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_ALL_2_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #_WEEKLY_PAYMENT_ALL_2(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		/* For new calculations */
		INSERT INTO #_WEEKLY_PAYMENT_ALL_2
		SELECT	wpa.claim
				,payment_no
				,trans_date = (SELECT MAX(trans_date)
									FROM #_WEEKLY_PAYMENT_ALL wpa1
									WHERE	wpa1.claim = wpa.claim
											and wpa1.ppstart = wpa.ppstart
											and wpa1.ppend = wpa.ppend)
				,ppstart
				,ppend
				,payamt = (SELECT SUM(ISNULL(payamt,0))
								FROM #_WEEKLY_PAYMENT_ALL wpa1
								WHERE	wpa1.claim = wpa.claim
										and wpa1.ppstart = wpa.ppstart
										and wpa1.ppend = wpa.ppend)
				,wc_Hours = (SELECT SUM(ISNULL(wc_Hours,0))
								FROM #_WEEKLY_PAYMENT_ALL wpa1
								WHERE	wpa1.claim = wpa.claim
										and wpa1.ppstart = wpa.ppstart
										and wpa1.ppend = wpa.ppend)
				,wc_Minutes = (SELECT SUM(ISNULL(wc_Minutes,0))
									FROM #_WEEKLY_PAYMENT_ALL wpa1
									WHERE	wpa1.claim = wpa.claim
											and wpa1.ppstart = wpa.ppstart
											and wpa1.ppend = wpa.ppend)
				,hours_per_week
				,wc_payment_type = (SELECT TOP 1 wc_payment_type
										FROM #_WEEKLY_PAYMENT_ALL wpa1
										WHERE	wpa1.claim = wpa.claim
												and wpa1.ppstart = wpa.ppstart
												and wpa1.ppend = wpa.ppend)
				,date_claim_received
				,Agency_id
				,is_exempt
				,effective_date
				,weeks_paid_old
				,incap_week_start
				,incap_week_end
				,incap_week_start_new
				,incap_week_end_new
				,trans_amount_prop
				,calc_method
				,latest_paydate
				,latest_paydate_prev
				,incap.incapacity_date
			FROM #_WEEKLY_PAYMENT_ALL wpa LEFT JOIN #_incap_date incap ON incap.claim = wpa.claim
			WHERE date_claim_received >= '2012-10-01'
			GROUP BY wpa.claim
					,payment_no
					,ppstart 
					,ppend
					,hours_per_week
					,date_claim_received
					,Agency_id
					,is_exempt
					,effective_date
					,weeks_paid_old
					,incap_week_start
					,incap_week_end
					,incap_week_start_new
					,incap_week_end_new
					,trans_amount_prop
					,calc_method
					,latest_paydate
					,latest_paydate_prev
					,incap.incapacity_date
		
		/* Records belong to new calculations with payment amount or hours paid equal to zero are removed */
		DELETE FROM #_WEEKLY_PAYMENT_ALL_2 WHERE payamt = 0 or wc_Hours = 0
		
		/* For old calculations */
		INSERT INTO #_WEEKLY_PAYMENT_ALL_2
		SELECT wpa.*, incap.incapacity_date
			FROM #_WEEKLY_PAYMENT_ALL wpa LEFT JOIN #_incap_date incap ON incap.claim = wpa.claim
			WHERE date_claim_received < '2012-10-01'
			
		/* Drop unused temp tables: #_WEEKLY_PAYMENT_ALL, #_incap_date */
		IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL
		IF OBJECT_ID('tempdb..#_incap_date') IS NOT NULL DROP table #_incap_date
			
		UPDATE #_WEEKLY_PAYMENT_ALL_2
			SET calc_method =
					/* for exempted emergency services claims, old method is used */
					case when UPPER(@System) = 'TMF' and Agency_id in ('10250', '10255', '10355', '10405') and is_exempt = 1
							then 'OLD'
						/* for new claims, new method is applied from the first period start date of a correct positive new payment */
						when date_claim_received >= '2012-10-01'
							then
								case when ppstart >= incapacity_date
										then 'NEW'
									else 'OLD'
								end
						else 
							/* for existing recepients, new method is applied from the latter of effective date and first correct new code */
							case when effective_date is null
									then 'OLD'
								when ppstart >= incapacity_date
									then 'NEW'
								else 'OLD'
							end
					end
			
		/* OLD FORMULA */
		
		UPDATE #_WEEKLY_PAYMENT_ALL_2 SET weeks_paid_old = ISNULL((ISNULL(wc_Hours, 0) + ISNULL(wc_Minutes, 0)/60)
										/ (case when hours_per_week < 1
													then 37.5
												else hours_per_week
											end), 0)
			WHERE calc_method = 'OLD'
		
		/* NEW FORMULA */
		
		/* align payments into incapacity weeks */
		UPDATE #_WEEKLY_PAYMENT_ALL_2
			SET incap_week_start = case when ppstart is not null
											then
												case when datepart(dw,incapacity_date) > datepart(dw,ppstart)
													then dateadd(wk, -1, dateadd(dd, -(datepart(dw, ppstart)-1), ppstart))
															+ datepart(dw,incapacity_date) - 1
													else dateadd(dd, -(datepart(dw, ppstart)-1), ppstart)
															+ datepart(dw,incapacity_date) - 1
												end
										else null
									end
				,incap_week_end = case when ppend is not null
											then
												case when datepart(dw,incapacity_date) > datepart(dw,ppend)
														then dateadd(dd, -(datepart(dw, ppend)-1), ppend)
																+ datepart(dw,incapacity_date) - 2
													else dateadd(wk, 1, dateadd(dd, -(datepart(dw, ppend)-1), ppend)) 
															+ datepart(dw,incapacity_date) - 2
												end
										else null
									end
			WHERE calc_method = 'NEW'
				AND incapacity_date is not null
				AND wc_payment_type in ('WPT005','WPT006','WPT007','WPP005','WPP006','WPP007','WPP008')
		
		/* break down payments into incapacity weeks */
		UPDATE #_WEEKLY_PAYMENT_ALL_2
			SET incap_week_start_new = incap_week_start + 7 * dbo.udf_GetIncapWeekForEntitlement(incap_week_start, incap_week_end)
				,incap_week_end_new = incap_week_start + 7 * dbo.udf_GetIncapWeekForEntitlement(incap_week_start, incap_week_end) + 6
			WHERE calc_method = 'NEW'
				AND dbo.udf_GetIncapWeekForEntitlement(incap_week_start, incap_week_end) <> -1
			
		/* determine the payment date before the latest payment date */
		UPDATE #_WEEKLY_PAYMENT_ALL_2
			SET latest_paydate_prev = (SELECT MAX(Transaction_date)
											FROM dbo.Payment_Recovery pr1
											WHERE pr1.Claim_No = claim
												AND pr1.Transaction_date < latest_paydate
												AND wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
																,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
																,'13','14','15','16'))
				,trans_amount_prop = (DATEDIFF(DAY, dbo.udf_MaxDay(ppstart,incap_week_start_new,'1900/01/01'), 
					dbo.udf_MinDay(ppend, incap_week_end_new, '2222/01/01')) + 1)/((DATEDIFF(DAY, ppstart, ppend) + 1) * 1.0) * payamt
			WHERE calc_method = 'NEW'
	END
	
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT') IS NULL
	BEGIN
		CREATE TABLE #_WEEKLY_PAYMENT
		(
			 claim varchar(19)
			 ,payment_no int
			 ,incapacity_start datetime
			 ,incapacity_end datetime
			 ,weeks_paid_old float
			 ,weeks_paid_new float
		)

		/* create index for #_WEEKLY_PAYMENT table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #_WEEKLY_PAYMENT(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #_WEEKLY_PAYMENT
		SELECT  claim
				,payment_no
				,case when calc_method = 'OLD'
						then ppstart
					else incap_week_start_new
				end
				,case when calc_method = 'OLD'
						then ppend
					else incap_week_end_new
				end
				,case when calc_method = 'OLD'
						then weeks_paid_old
					else 0
				end
				,case when calc_method = 'NEW'
						then 1
					else 0
				end
		FROM #_WEEKLY_PAYMENT_ALL_2
		WHERE calc_method = 'OLD'
			
			/* Data Cleansing 2: remove negative adjustments */
			OR (calc_method = 'NEW' AND trans_amount_prop > 1)
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NULL
	BEGIN
		/* create #rtw_raworig temp table to store transaction data */
		CREATE TABLE #rtw_raworig_temp
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)			 
			 ,payamt money
			 ,payment_no int
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)

		/* create index for #rtw_raworig_temp table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_temp_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_temp(claim, payment_no)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #rtw_raworig_temp
		SELECT  pr.Claim_No
				, CONVERT(varchar(10), pr.Transaction_date, 120)
				,pr.WC_Payment_Type
				,rtw_paytype=  (CASE WHEN wc_payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004') 
										THEN 'TI'
									 WHEN wc_payment_type IN ('13', 'WPP001', 'WPP003') 
										THEN 'S38'
									 WHEN wc_payment_type IN ('16', 'WPP002', 'WPP004') 
										THEN 'S40'
									 WHEN wc_payment_type IN ('WPT005', 'WPT006', 'WPT007') 
										THEN 'NOWORKCAP'
									 WHEN wc_payment_type IN ('WPP005', 'WPP006', 'WPP007', 'WPP008') 
										THEN 'WORKCAP' 
								END)
				,Trans_Amount
				,pr.Payment_no
				,Period_Start_Date
				,Period_End_Date
				,pr.hours_per_week
				,hrs_total = (isnull(WC_MINUTES, 0) / 60.0)
								 + isnull(WC_HOURS, 0)
								 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
				,isnull(Rate, 0)
		FROM dbo.Payment_Recovery pr
				INNER JOIN dbo.CLAIM_PAYMENT_RUN
						   ON pr.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
				INNER JOIN #claim cl on pr.Claim_No = cl.claim
		WHERE	Transaction_date >= @paystartdt
				AND cl.Date_of_Injury >= @paystartdt
				AND Transaction_date <= @AsAt
				AND Adjust_Trans_Flag = 'N'
				AND wc_Tape_Month IS NOT NULL
				AND LEFT(wc_Tape_Month, 4) <= YEAR(@AsAt)
				AND wc_Tape_Month <= CONVERT(int, CONVERT(varchar(8), @transaction_lag_remuneration_end,112))
				AND wc_payment_type IN ('WPT001','WPT002','WPT003','WPT004','WPT005','WPT006','WPT007'
										,'WPP001','WPP002','WPP003', 'WPP004','WPP005','WPP006','WPP007','WPP008'
										,'13','14','15','16')
										 
		/* Adjust DET weekly field */
		IF OBJECT_ID('tempdb..#summary') IS NULL
		BEGIN
			CREATE TABLE #summary
			(
				 claim varchar(19)
				 ,ppstart datetime
				 ,ppend datetime			 
				 ,paytype varchar(15)			 		 
				 ,DET_weekly money
			)
		END
		
		INSERT INTO #summary
		SELECT distinct claim, ppstart, ppend, paytype, DET_weekly = max(DET_weekly)
			FROM #rtw_raworig_temp
		GROUP BY claim,
				ppstart,
				ppend,
				paytype

		UPDATE #rtw_raworig_temp 
			SET DET_weekly = su.DET_weekly
			FROM #summary su
			WHERE	#rtw_raworig_temp.claim = su.claim
					AND #rtw_raworig_temp.ppstart = su.ppstart
					AND #rtw_raworig_temp.ppend = su.ppend
					AND #rtw_raworig_temp.paytype = su.paytype
		
		/* end of adjusting DET weekly field */
		
		/* Drop unused temp table: #summary */
		IF OBJECT_ID('tempdb..#summary') IS NOT NULL DROP table #summary
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig') IS NULL
	BEGIN
		/* create #rtw_raworig table to store transaction data after summarizing step #1 */
		CREATE TABLE #rtw_raworig
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,paytype varchar(15)
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised trasactions by claim, paydate, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig
		SELECT  claim
				,paydate
				,paytype
				,rtw_paytype
				,payamt = (SELECT SUM(ISNULL(payamt,0))
								FROM #rtw_raworig_temp rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(ISNULL(hrs_total,0))
								FROM #rtw_raworig_temp rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig_temp rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paydate = rtw.paydate
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig_temp rtw
		GROUP BY claim,
				paydate,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
		
		/* Drop unused temp table: #rtw_raworig_temp */
		IF OBJECT_ID('tempdb..#rtw_raworig_temp') IS NOT NULL DROP table #rtw_raworig_temp
				
		/* Records with payment amount and hours paid for total incapacity are both zero are removed */
		DELETE FROM #rtw_raworig WHERE hrs_total = 0 and payamt = 0
		
		/* Records with a negative payment amount, but positive hours paid for total incapacity
				have their hours paid changed to be negative. */
		UPDATE #rtw_raworig SET hrs_total = -hrs_total
			WHERE hrs_total > 0 AND payamt < 0
	END
	
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NULL
	BEGIN
		/* create #rtw_raworig_2 table to store transaction data after summarizing for step #2 */
		CREATE TABLE #rtw_raworig_2
		(
			 claim varchar(19)
			 ,paydate datetime
			 ,rtw_paytype varchar(9)
			 ,payamt money
			 ,ppstart datetime
			 ,ppend datetime
			 ,hrs_per_week numeric(5,2)
			 ,hrs_total numeric(14,3)
			 ,DET_weekly money
		)	
		
		/* create index for #rtw_raworig_2 table */
		SET @SQL = 'CREATE INDEX pk_rtw_raworig_2_' + CONVERT(VARCHAR, @@SPID) + ' ON #rtw_raworig_2(claim, rtw_paytype, paydate)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END		
		
		/* summarised transactions by claim, paytype, ppstart, ppend */
		INSERT INTO #rtw_raworig_2
		SELECT  claim
				,paydate = (SELECT MIN(paydate) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim										
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,rtw_paytype
				,payamt = (SELECT SUM(ISNULL(payamt,0))
								FROM #rtw_raworig rtw1 
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart 
										and rtw1.ppend = rtw.ppend)							
				,ppstart
				,ppend
				,hrs_per_week
				,hrs_total = (SELECT SUM(ISNULL(hrs_total,0))
								FROM #rtw_raworig rtw1
								WHERE rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
				,DET_weekly = (SELECT MAX(DET_weekly) 
								FROM #rtw_raworig rtw1
								WHERE	rtw1.claim = rtw.claim 
										and rtw1.paytype = rtw.paytype
										and rtw1.ppstart = rtw.ppstart
										and rtw1.ppend = rtw.ppend)
		FROM #rtw_raworig rtw
		GROUP BY claim,
				paytype,
				rtw_paytype,
				ppstart,
				ppend,
				hrs_per_week
			
		/* Drop unused temp table: #rtw_raworig */
		IF OBJECT_ID('tempdb..#rtw_raworig') IS NOT NULL DROP table #rtw_raworig
				
		/*
		- Records with payment amount equal to zero are removed;
		- Records associated with payments of pre-reform benefits (s36, s37, s38, s40) with hours
		paid for partial incapacity and hours paid for total incapacity both equal to zero are
		removed; */
		DELETE FROM #rtw_raworig_2 WHERE payamt = 0 or (hrs_total = 0 
			and rtw_paytype in ('TI', 'S38', 'S40'))
	END
	
	/* create #measures table that */
	CREATE TABLE #measures
	(
		claim CHAR(19)
		,paytype varchar(9)
		,payamt money
		,hrs_per_week_adjusted numeric(5,2)
		,days_for_TI int
		,LT_TI float
		,LT_S38 float
		,LT_S40 float
		,LT_NWC float
		,LT_WC float
	)
	
	INSERT INTO #measures
	SELECT DISTINCT 
			pr.Claim
			,pr.rtw_paytype
			,pr.payamt
			
			-- adjust hours worked per week to be a minimum of 1 and a maximum of 40;
			,hrs_per_week_adjusted = dbo.udf_MinValue(40
											  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0
														then cd.hrswrkwk 
													 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
														then 1  
													 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
												end)
											  )
			
			-- calculate total incapacity days off work
			,days_for_TI = (case when rtw_paytype = 'TI'
										and datepart(dw,pr.ppstart) IN (1,7)
										and datepart(dw,pr.ppend) IN(1,7) 
										and DATEDIFF(day,pr.ppstart,pr.ppend) <=1
									then DATEDIFF(day,pr.ppstart,pr.ppend) + 1					
								when pr.ppstart = pr.ppend 
									then 1 
								else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
							end)
						
			-- calculate days off work for pre-reform claims - Total incapacity payment
			,LT_TI = (CASE when	rtw_paytype = 'TI'
								and dbo.udf_MinValue(40 
												   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															 then cd.hrswrkwk 
														  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1
															 then 1 
														  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													 end
													 )
													) >= 35 
								then 1.0 
									 * (pr.hrs_total* 5)
									 / nullif(dbo.udf_MinValue(40
													   ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ),0) 
									* dbo.udf_CheckPositiveOrNegative(pr.payamt)
						 when rtw_paytype = 'TI' 
							  and dbo.udf_MinValue(40 
												  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk
														when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1  
														else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													end)
												 ) < 35 
							then 1.0 
								 * (pr.hrs_total * 5 /37.5)
								 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
						else 0 
					END)
					
			-- calculate days off work for pre-reform claims - Section 38 payment
			,LT_S38 = (CASE when rtw_paytype = 'S38'
								 and (case when pr.ppstart = pr.ppend 
												then 1 
										   else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									 end) = 0 
								then 0
							when rtw_paytype = 'S38' 
								 and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													 ) >= 35 
								then 1.0 * (case when pr.ppstart = pr.ppend
													then 1
												else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
											end)
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
							when rtw_paytype = 'S38'
								 and dbo.udf_MinValue(40
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35  
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													) > 0 
								then 1.0 * (case when pr.ppstart = pr.ppend
													then 1
												else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
											end)
									  * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									  * dbo.udf_MinValue(40
												 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk 
														when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1
														else isnull(cd.hrswrkwk,pr.hrs_per_week)
													end)
												 )
									  /37.5
										
							else 0
					END)
					
			-- calculate days off work for pre-reform claims - Section 40 payment
			,LT_S40 = (CASE when rtw_paytype = 'S40'
								and (case when pr.ppstart = pr.ppend 
												then 1 
										  else
												dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
									end) = 0 
								then 0
							when rtw_paytype = 'S40'
								 and dbo.udf_MinValue(40
													  , (case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
															  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
												      ) >= 35 
								then 1.0 * (case when pr.ppstart = pr.ppend
													then 1
												else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
											end)
									 * 0.75
									 * dbo.udf_CheckPositiveOrNegative(pr.payamt)
							when rtw_paytype = 'S40' 
								 and dbo.udf_MinValue(40
											 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
														then cd.hrswrkwk 
													 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
														then 1  
													 else isnull(cd.hrswrkwk,pr.hrs_per_week) end)
												) < 35
								then 1.0 * (case when pr.ppstart = pr.ppend
													then 1
												else dbo.udf_NoOfDaysWithoutWeekend(pr.ppstart,pr.ppend)
											end)
									   * 0.75 
									   * dbo.udf_CheckPositiveOrNegative(pr.payamt) 
									   * dbo.udf_MinValue(40
												  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
															then cd.hrswrkwk 
														  when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
															then 1  
														  else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													 end)
													)
										/37.5
								else 0
						END)
						
			-- calculate days off work for post reform claims - no current work capacity
			,LT_NWC = (CASE when rtw_paytype = 'NOWORKCAP' 
								and dbo.udf_MinValue(40
													 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1 
															else isnull(cd.hrswrkwk,pr.hrs_per_week) 
													  end)
													  ) >= 35 
								then 1.0 * (pr.payamt* 5)/ nullif(pr.DET_weekly,0)
							when rtw_paytype = 'NOWORKCAP' 
								 and dbo.udf_MinValue(40 
													  ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																then cd.hrswrkwk 
															 when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																then 1  
															 else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													  ) < 35 
								then 1.0 
									 * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									 * 5
									 *dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														  end)
														  )
								else 0 
						END)
						
			-- calculate days off work for post reform claims - current work capacity
			,LT_WC = (CASE when rtw_paytype = 'WORKCAP'
								  and dbo.udf_MinValue(40
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1 
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														 end)
														) >= 35 
								 then 1.0 * (pr.payamt* 5) / nullif(pr.DET_weekly,0)
							  when rtw_paytype = 'WORKCAP' 
								  and dbo.udf_MinValue(40 
														,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																   then cd.hrswrkwk 
															   when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																   then 1  
															   else isnull(cd.hrswrkwk,pr.hrs_per_week) 
														end)
													   ) < 35 
								 then 1.0 
									  * (pr.payamt / nullif(pr.DET_weekly,0) / 37.5)
									  * 5
									  *dbo.udf_MinValue(40
														 ,(case when isnull(isnull(cd.hrswrkwk,pr.hrs_per_week),0) = 0 
																	then cd.hrswrkwk 
																when isnull(cd.hrswrkwk,pr.hrs_per_week) < 1 
																	then 1  
																else isnull(cd.hrswrkwk,pr.hrs_per_week) 
															end)
														   )
							  else 0 
						END)
	FROM #claim cd INNER JOIN #rtw_raworig_2 pr ON cd.Claim = pr.Claim
	WHERE cd.Date_of_Injury >= @paystartdt
	
	/* Drop unused temp table: #rtw_raworig_2 */
	IF OBJECT_ID('tempdb..#rtw_raworig_2') IS NOT NULL DROP table #rtw_raworig_2
	
	/* delete small transactions */

	/* small transactions with $2 per day for S40 and WC payments */
	DELETE FROM #measures WHERE (CASE WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted >= 35 
											AND (1.0 * payamt / nullif(days_for_TI,0)) < 2 
										THEN 1
									 WHEN paytype in ('S40') AND days_for_TI <> 0 
											AND hrs_per_week_adjusted < 35 
											AND (1.0 * payamt / nullif(((days_for_TI*hrs_per_week_adjusted)/37.5),0)) < 2 
										THEN 1 
									 WHEN paytype in ('S40') AND days_for_TI = 0 
											AND LT_S40 <> 0 AND (1.0 * payamt / nullif(LT_S40,0)) < 2  
										THEN 1
									 WHEN paytype in ('WORKCAP') AND LT_WC <> 0 AND (1.0 * payamt / nullif(LT_WC,0)) < 2 
										THEN 1
									 ELSE 0
								  END = 1)

	/* other small transactions with payment amount < $20 per day */
	DELETE FROM #measures WHERE (CASE WHEN  paytype in ('S38','TI','NOWORKCAP') 
										    and (LT_TI + LT_S38 + LT_NWC) <> 0 
										    and (1.0 * payamt / nullif((LT_TI + LT_S38 + LT_NWC),0)) < 20 
										  THEN 1
									  ELSE 0
								 END = 1)
	/* end delete small transactions */
	
	SELECT	Team = CASE WHEN RTRIM(ISNULL(co.Grp, '')) = '' THEN 'Miscellaneous' ELSE RTRIM(UPPER(co.Grp)) END			
			,Case_Manager = ISNULL(UPPER(co.First_Name + ' ' + co.Last_Name), 'Miscellaneous')
			,Policy_No = cd.policy_no
			,EMPL_SIZE = (CASE WHEN pd.BTP IS NULL OR pd.Process_Flags IS NULL OR pd.WAGES0 IS NULL then 'A - Small'
							  WHEN pd.WAGES0 <= 300000 then 'A - Small'
							  WHEN pd.WAGES0 > 300000 AND pd.WAGES0 <= 1000000 AND pd.Process_Flags = 1 then 'A - Small'
							  WHEN pd.WAGES0 > 300000 AND pd.WAGES0 <= 1000000 AND pd.Process_Flags <> 1 then 'B - Small-Medium'
							  WHEN pd.WAGES0 > 1000000 AND pd.WAGES0 <= 5000000 then 'C - Medium'
							  WHEN pd.WAGES0 > 5000000 AND pd.WAGES0 <= 15000000 AND pd.BTP <= 100000 then 'C - Medium'
							  WHEN pd.WAGES0 > 15000000 then 'D - Large'
							  WHEN pd.WAGES0 > 5000000 AND pd.BTP > 100000 then 'D - Large'
							  ELSE 'A - Small'
						  END)
			,Account_Manager = isnull(acm.account_manager,'Miscellaneous')
			
			-- retrieve portfolio info
			,Portfolio = case when ISNULL(anz.DESCRIPTION,'')<>''
								then
									case when UPPER(anz.DESCRIPTION) = 'ACCOMMODATION' 
											or UPPER(anz.DESCRIPTION) = 'PUBS, TAVERNS AND BARS'
											or UPPER(anz.DESCRIPTION) = 'CLUBS (HOSPITALITY)' then anz.DESCRIPTION
										else 'Other'
									end
								else
									case when LEFT(ada.Tariff, 1) = '1' and LEN(ada.Tariff) = 7
											then 
												case when SUBSTRING(CAST(ada.Tariff as CHAR(7)), 2, 6) = '571000'
													then 'Accommodation'
												when SUBSTRING(CAST(ada.Tariff as CHAR(7)), 2, 6) = '572000'
													then 'Pubs, Taverns and Bars'
												when SUBSTRING(CAST(ada.Tariff as CHAR(7)), 2, 6) = '574000'
													then 'Clubs (Hospitality)'
												else 'Other'
											end
										else 
											case when ada.Tariff = 571000 then 'Accommodation'
												when ada.Tariff = 572000 then 'Pubs, Taverns and Bars'
												when ada.Tariff = 574000 then 'Clubs (Hospitality)'
												else 'Other'
											end
									end
							end
			,Reporting_Date = @Reporting_Date
			,Claim_No = cd.claim
			,WIC_Code = cd.Tariff_No
			,Company_Name = ISNULL((select LEGAL_NAME from POLICY_TERM_DETAIL ptd where ptd.POLICY_NO = pd.POLICY_NO),cd.policy_no)
			,Worker_Name = cd.Given_Names + ', ' + cd.Last_Names
			,Employee_Number = cd.Employee_no
			,Worker_Phone_Number = cd.Phone_no
			,Claims_Officer_Name = co.First_Name + ' ' + co.Last_Name
			,Date_of_Birth = cd.Date_of_Birth
			,Date_of_Injury = cd.Date_of_Injury
			,Date_Of_Notification = cd.date_claim_received
			,Notification_Lag = case when cd.Date_of_Injury IS NULL then -1
									 else
										(case when ISNULL(DATEDIFF(day,cd.Date_of_Injury, cd.Date_Notice_Given), 0) < 0
												then 0
											else ISNULL(DATEDIFF(day,cd.Date_of_Injury, cd.Date_Notice_Given), 0)
										end)
								end
			,Entered_Lag = DATEDIFF(day,cd.date_claim_received, cd.date_claim_entered)
			,Claim_Liability_Indicator_Group = dbo.udf_GetLiabilityStatusById(cd.Claim_Liability_Indicator)
			,Investigation_Incurred = (select SUM(ed.Amount)
											from ESTIMATE_DETAILS ed 
											where ed.[Type] = '62' and ed.Claim_No = cd.claim)
			,Total_Paid = (select ISNULL(SUM(pr.Trans_Amount),0) -
									ISNULL(SUM(pr.itc),0) -
									ISNULL(SUM(pr.dam),0) +
									ISNULL(SUM(pr.gst),0)
									from Payment_Recovery pr
									where pr.Claim_No = cd.claim
										and Transaction_Date <= @AsAt)
			,Is_Time_Lost = cdba.is_Time_Lost
			,Claim_Closed_Flag = cd.Claim_Closed_Flag
			,Date_Claim_Entered = cd.Date_Claim_Entered
			,Date_Claim_Closed = cd.Date_Claim_Closed
			,Date_Claim_Received = cd.date_claim_received
			,Date_Claim_Reopened = cd.Date_Claim_reopened
			,Result_Of_Injury_Code = cd.Result_of_Injury_Code
			,WPI = cd.WPI
			,Common_Law = case when (select SUM(ed1.Amount) 
										from ESTIMATE_DETAILS ed1 
										where cd.claim = ed1.Claim_No and ed1.[Type] = '57') > 0 
									then 1
							   else 0
						  end
			,Total_Recoveries = (select ISNULL(SUM(pr.Trans_Amount),0) 
									from Payment_Recovery pr 
									where pr.Claim_No = cd.claim and pr.Estimate_type = '76') +
										(select ISNULL(SUM(pr.Trans_Amount),0) 
											from Payment_Recovery pr 
											where pr.Claim_No = cd.claim
												and pr.Estimate_type in ('70','71','72','73','74','75','77'))			
			,Is_Working = 	case when cd.Work_Status_Code in (1,2,3,4,14) then 1
								 when cd.Work_Status_Code in (5,6,7,8,9) then 0
							end
			,Physio_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
								where claim_no=cd.claim
									and (payment_type='05' or payment_type like 'pta%' or payment_type like 'ptx%')
									and estimate_type='55'
									and pr.Transaction_Date < @AsAt
							)
			,Chiro_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
								where claim_no=cd.claim
									and (payment_type='06' or payment_type like 'cha%' or payment_type like 'chx%')
									and estimate_type='55'
									and pr.Transaction_Date < @AsAt
							)
			,Massage_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
								where claim_no=cd.claim
									and (payment_type like 'rma%' or payment_type like 'rmx%')
									and estimate_type='55'
									and pr.Transaction_Date < @AsAt
								)	
			,Osteopathy_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
									where claim_no=cd.claim
										and (payment_type like 'osa%' or payment_type like 'osx%')
										and estimate_type='55'
										and pr.Transaction_Date < @AsAt
								)
			,Acupuncture_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
									where claim_no=cd.claim
										and (payment_type like 'ott001')
										and estimate_type='55'
										and pr.Transaction_Date < @AsAt
								)
			,Create_Date = getdate()
			,Is_Stress = case when cd.Mechanism_of_Injury in (81,82,84,85,86,87,88)
								OR cd.Nature_of_Injury in (910,702,703,704,705,706,707,718,719)
								then 1
							else 0
						  end
			,Is_Inactive_Claims = case when
									(select ISNULL(SUM(pr.Trans_Amount),0) -
										ISNULL(SUM(pr.itc),0) -
										ISNULL(SUM(pr.dam),0)
										from Payment_Recovery pr
										where pr.Claim_No = cd.claim
											and Transaction_Date <= @AsAt
											and Transaction_Date >= DATEADD(MM, -3, @AsAt)) = 0
											then 1
										else 0
									end
			,Is_Medically_Discharged = case when cd.Employment_Terminated_Reason = 2 then 1
											else 0
									   end
			,Is_Exempt = cd.is_exempt
			,Is_Reactive = case when exists (select distinct claim
												from #_WEEKLY_PAYMENT_ALL_2 wp
												where wp.claim = cd.claim
													and trans_date >= @paystartdt
													and latest_paydate_prev is not null
													and DATEDIFF(MONTH, latest_paydate_prev, latest_paydate) > 3)
									then 1
								else 0
							end
			,Is_Medical_Only = cd.Is_Medical_Only
			,Is_D_D = case when cd.Employment_Terminated_Reason = 2
									then 1
								else 0
							end
			,NCMM_Actions_This_Week = (case when cd.Claim_Closed_Flag = 'Y'
												then ''
											else
												dbo.udf_GetNCMMActionsThisWeek(cd.date_claim_received, @AsAt_Next_Week_End)
										end)
			,NCMM_Actions_Next_Week = (case when cd.Claim_Closed_Flag = 'Y'
												then ''
											else
												dbo.udf_GetNCMMActionsNextWeek(cd.date_claim_received, @AsAt_Next_Week_End)
										end)
			,HoursPerWeek = ISNULL(tld.Deemed_HoursPerWeek, 0)
			,Is_Industrial_Deafness = case when cd.Nature_of_Injury in (152,250,312,389,771)
												then 1
											else 0
										end
			,Rehab_Paid = (select SUM(Trans_amount) from Payment_Recovery pr
									where claim_no=cd.claim
										and (payment_type like 'or%' or payment_type = '04')
										and Transaction_Date <= @AsAt
										and Transaction_Date >= DATEADD(MM, -3, @AsAt)
							)
			,Action_Required = case when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) in (2,3,4,5,6,9,10,14,15,16,18,19,20,
																					 24,25,26,38,39,40,50,51,52,63,64,65,
																					 75,77,76,78,88,89,90,98,99,100,112,113,
																					 114,130,131,132) 
									  OR (DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) -132) % 13 = 0
										  AND CEILING((DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) -132) % 13 = 0
										  AND CEILING((DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0)
									  OR (DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) -132) % 13 = 11
										  AND CEILING((DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) -132) % 13 = 12
										  AND CEILING((DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) -132) % 13 = 11
										  AND CEILING((DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0)
									  OR (DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) -132) % 13 = 12
										  AND CEILING((DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0) then 'Y'
									else 'N'
							   end
			,RTW_Impacting = case when measure.LT > 5 and cd.Date_of_Injury between @RTW_start_date and @AsAt
									then 'Y'
								else 'N'
							end
			,Weeks_In = DATEDIFF(week,cd.date_claim_received,@AsAt_Next_Week_End)
			,Weeks_Band = case when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 0 and 12 then 'A.0-12 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 13 and 18 then 'B.13-18 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 19 and 22 then 'C.19-22 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 23 and 26 then 'D.23-26 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 27 and 34 then 'E.27-34 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 35 and 48 then 'F.35-48 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 48 and 52 then 'G.48-52 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 53 and 60 then 'H.53-60 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 61 and 76 then 'I.61-76 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 77 and 90 then 'J.77-90 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 91 and 100 then 'K.91-100 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 101 and 117 then 'L.101-117 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) between 118 and 130 then 'M.118-130 WK'
							   when DATEDIFF(week,cd.date_claim_received, @AsAt_Next_Week_End) > 130 then 'N.130+ WK'
						  end
			,Hindsight = case when cd.Date_of_Injury > DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-36,@_curr_fiscal_yr)) + 1, 0))
								 and  cd.Date_of_Injury <= DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-24,@_curr_fiscal_yr)) + 1, 0)) 
								 then '3 years'
							  when cd.Date_of_Injury > DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-60,@_curr_fiscal_yr)) + 1, 0))
								 and  cd.Date_of_Injury <= DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-48,@_curr_fiscal_yr)) + 1, 0)) 
								 then '5 years'
							  else ''
						 end
			,Active_Weekly = case when (Select ISNULL(SUM(pr.Trans_Amount),0) -
													ISNULL(SUM(pr.itc),0) -
													ISNULL(SUM(pr.dam),0)as amount
													from Payment_Recovery pr
													where pr.Claim_No = cd.claim
														and Transaction_Date <= @AsAt
														and Transaction_Date >= DATEADD(MM, -3, @AsAt)
														and pr.Estimate_type = '50') <> 0 
										then 'Y'
								  else 'N'
							 end
			,Active_Medical = case when (Select ISNULL(SUM(pr.Trans_Amount),0) -
													ISNULL(SUM(pr.itc),0) -
													ISNULL(SUM(pr.dam),0)as amount
													from Payment_Recovery pr
													where pr.Claim_No = cd.claim
														and Transaction_Date <= @AsAt
														and Transaction_Date >= DATEADD(MM, -3, @AsAt)
														and pr.Estimate_type = '55') <> 0 
										then 'Y'
								  else 'N'
							 end					  
			,Cost_Code = cd.Cost_Code
			,Cost_Code2 = cd.Cost_Code2
			,CC_Injury = (select top 1 Name from cost_code where policy_no =cd.Policy_No and short_name =cd.cost_code)
			,CC_Current = case when (select top 1 Name from cost_code where policy_no =cd.Policy_No and short_name =cd.cost_code2) is null 
									then (select top 1 Name from cost_code where policy_no =cd.Policy_No and short_name =cd.cost_code)
							   else (select top 1 Name from cost_code where policy_no =cd.Policy_No and short_name =cd.cost_code2)
						  end
			,Med_Cert_Status_This_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cd.claim))
			,Med_Cert_Status_Next_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Next_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cd.claim))
			,Capacity = (select case when temp.RTW_Goal = 2 then 'Partial Capacity'
									when temp.RTW_Goal = 3 then 'Full Capacity'
									else 'No Capacity'
							   end
						from (select RTW_Goal from TIME_LOST_DETAIL 
							  where ID = (select MAX(ID) from TIME_LOST_DETAIL 
									      where Claim_no = cd.claim)) as temp)
			,Entitlement_Weeks = (select SUM(weeks_paid_old + weeks_paid_new)
									from #_WEEKLY_PAYMENT
									where claim = cd.claim
									group by claim)
			,Med_Cert_Status_Prev_1_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Prev_1_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cd.claim))
			,Med_Cert_Status_Prev_2_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Prev_2_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cd.claim))
			,Med_Cert_Status_Prev_3_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Prev_3_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cd.claim))
			,Med_Cert_Status_Prev_4_Week = dbo.udf_ExtractMedCertStatus_Code(
									(select [Type] from Medical_Cert MC 
										where MC.ID = (select top 1 ID
															from Medical_Cert MC1
															where MC1.Claim_no = MC.Claim_no
																	and MC1.is_deleted <> 1
																	and MC1.create_date < @AsAt_Prev_4_Week
															order by MC1.Date_From desc, MC1.create_date desc, MC1.ID desc
														)
											and MC.Claim_no = cd.claim))
			,Is_Last_Month = @Is_Last_Month
			
			,IsPreClosed = (case when exists(SELECT * FROM CAD_AUDIT CADA_pre
										WHERE CADA_pre.Claim_no = cd.claim
											AND CADA_pre.Claim_Closed_Flag = 'Y'
											AND CADA_pre.id = (SELECT MAX(ID) FROM CAD_AUDIT CADA2
																  WHERE CADA2.CLAIM_NO = CADA_pre.CLAIM_NO
																		AND CADA2.Transaction_Date <= @Start_Date))
									then 1
								else 0
							end)
			,IsPreOpened = (case when (exists(SELECT * FROM CAD_AUDIT CADA_pre
										WHERE CADA_pre.Claim_no = cd.claim
											AND CADA_pre.Claim_Closed_Flag = 'N'
											AND CADA_pre.id = (SELECT MAX(ID) FROM CAD_AUDIT CADA2
																  WHERE CADA2.CLAIM_NO = CADA_pre.CLAIM_NO
																		AND CADA2.Transaction_Date <= @Start_Date)) 
							or ISNULL(cd.date_claim_entered, cd.date_claim_received) > @Start_Date)
									then 1
								else 0
							end)
			--,Gateway_Status = dbo.udf_GetGatewayStatus_S59A(cd.last_weekly_date, cd.Date_of_Injury, cd.Date_Claim_Received, cd.WPI, @AsAt)
	FROM	#claim cd
			LEFT JOIN (SELECT rtrim(claim) as Claim_no,
							round(SUM(LT_TI + LT_S38 + LT_S40 + LT_NWC + LT_WC),10) as LT
						FROM #measures
						GROUP BY claim
					) as measure on cd.claim = measure.Claim_no
			LEFT JOIN ANZSIC anz on cd.ANZSIC = anz.CODE
			INNER JOIN cd_bit_audit cdba on cdba.Claim_Number = cd.claim
				AND cdba.id = (SELECT MAX(cdba2.id)
							  FROM cd_bit_audit cdba2
							  WHERE cdba2.Claim_Number = cdba.Claim_Number
								AND cdba2.Create_date <= @AsAt)
				AND cdba.is_Null = 0
			
			-- for retrieving Group, Team, Case_Manager
			LEFT JOIN CLAIMS_OFFICERS co ON cd.Claims_Officer = co.Alias
			
			-- for retrieving EMPL_SIZE
          	LEFT JOIN PREMIUM_DETAIL pd on pd.POLICY_NO = cd.policy_no and pd.RENEWAL_NO = cd.renewal_no 
          	LEFT JOIN ACTIVITY_DETAIL_AUDIT ada
				ON pd.POLICY_NO = ada.Policy_No and pd.RENEWAL_NO = ada.Renewal_No	
          	
          	-- for retrieving Account_Manager
          	LEFT JOIN (SELECT U.First_Name + ' ' + U.SurName as account_manager, claim_number 
          					FROM CLAIM_DETAIL cld 
          						LEFT JOIN POLICY_TERM_DETAIL PTD on cld.Policy_No = ptd.POLICY_NO
								LEFT JOIN Broker Br on PTD.Broker_No = Br.Broker_no 
								LEFT JOIN UnderWriters U on BR.emi_Contact = U.Alias 
							WHERE U.is_Active = 1 AND U.is_EMLContact = 1 ) as acm 
				ON acm.claim_number = cd.claim
			
			-- for retrieving Deemed Hours Per Week
			LEFT JOIN TIME_LOST_DETAIL tld on cd.claim = tld.claim_no
	WHERE	ISNULL(anz.ID, 1) = ISNULL((SELECT MAX(ID) FROM ANZSIC anz2 
												WHERE anz2.CODE = anz.CODE),1)
			AND ISNULL(ada.ID, 1) =
						ISNULL((SELECT TOP 1 ID
									FROM ACTIVITY_DETAIL_AUDIT ada2
									WHERE ada.Policy_No = ada2.Policy_No
										AND ada.Renewal_No = ada2.Renewal_No
									ORDER BY Policy_No, Renewal_No, CREATE_DATE desc, ID desc), 1)
			AND ISNULL(tld.id, 1) = ISNULL((SELECT MAX(tld2.id)
											  FROM TIME_LOST_DETAIL tld2
											  WHERE tld2.claim_no = tld.claim_no), 1)
											  
	/* Drop remaining temp tables */
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL DROP table #claim
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL_2') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL_2
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT') IS NOT NULL DROP table #_WEEKLY_PAYMENT
	IF OBJECT_ID('tempdb..#measures') IS NOT NULL DROP table #measures
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_Portfolio.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_Portfolio_GenerateData.sql  
--------------------------------  
/****** Object:  StoredProcedure [dbo].[usp_Dashboard_Portfolio_GenerateData]    Script Date: 23/04/2014 14:31:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_Portfolio_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_Portfolio_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_Portfolio_GenerateData]
	@System varchar(20),
	@AsAt datetime = null
AS
BEGIN
	IF OBJECT_ID('tempdb..#month_periods') IS NOT NULL DROP TABLE #month_periods
	-- Use Year flag is 3
	DECLARE @year_flag int = 3
	
	-- Determine last {@year_flag} years
	DECLARE @DataFromYear datetime = CAST(YEAR(GETDATE()) - @year_flag as varchar(5)) + '-01-01'
	
	-- Keep previous 1 month from {@DataFromYear}
	SET @DataFromYear = DATEADD(M, DATEDIFF(m, 0, @DataFromYear), -1) + '23:59'
	
	-- Use Month flag is 3
	DECLARE @month_flag int = 3
	
	-- Determine last {@month_flag} months
	DECLARE @DataFromMonth datetime = DATEADD(M, -3,DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1)) + '23:59'
	
	-- Determine the month periods between {@DataFromYear} and {@DataFromMonth}
	;WITH month_periods AS
	(
		SELECT	DATEADD(m, DATEDIFF(m, 0, @DataFromYear), 0) AS bMonth
				,DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @DataFromYear) + 1, 0)) + '23:59' AS eMonth
		UNION ALL
		SELECT	DATEADD(m, 1, bMonth)
				,DATEADD(dd, -1, DATEADD(m, 2, bMonth)) + '23:59'
		FROM month_periods WHERE eMonth < @DataFromMonth
	)
	SELECT eMonth INTO #month_periods FROM month_periods
	
	IF @AsAt is null		
		SET @AsAt = DATEADD(dd, DATEDIFF(dd, 0, GETDATE()), -1) + '23:59'
	ELSE		
		SET @AsAt = DATEADD(dd, DATEDIFF(dd, 0, @AsAt), -1) + '23:59'
	
	IF UPPER(@System) = 'TMF'
	BEGIN		
		DELETE [Dart].[dbo].[TMF_Portfolio]	WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @AsAt), 0)
		INSERT INTO [Dart].[dbo].[TMF_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 1
		INSERT INTO [Dart].[dbo].[TMF_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 0
		
		-- Cleaning up data: delete the monthly data before the latest Reporting_Date
		DELETE FROM [Dart].[dbo].[TMF_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 1
			AND Reporting_Date <> (select MAX(Reporting_Date) from [Dart].[dbo].[TMF_Portfolio])
			
		/* Cleaning up data:
		- Delete the daily data that generated before {@DataFromMonth}
		- But keep daily data for days that meet conditions:
			+ Is the end of each month.
			+ In month periods from {@DataFromYear} to {@DataFromMonth} 
		For other days, delete them */
		DELETE FROM [Dart].[dbo].[TMF_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 0
			AND Reporting_Date <= @DataFromMonth
			AND Reporting_Date NOT IN (SELECT eMonth FROM #month_periods)
	END
	ELSE IF UPPER(@System) = 'EML'
	BEGIN
		DELETE [Dart].[dbo].[EML_Portfolio]	WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @AsAt), 0)
		INSERT INTO [Dart].[dbo].[EML_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 1		
		INSERT INTO [Dart].[dbo].[EML_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 0
		
		-- Cleaning up data: delete the monthly data before the latest Reporting_Date
		DELETE FROM [Dart].[dbo].[EML_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 1
			AND Reporting_Date <> (select MAX(Reporting_Date) from [Dart].[dbo].[EML_Portfolio])
			
		/* Cleaning up data:
		- Delete the daily data that generated before {@DataFromMonth}
		- But keep daily data for days that meet conditions:
			+ Is the end of each month.
			+ In month periods from {@DataFromYear} to {@DataFromMonth} 
		For other days, delete them */
		DELETE FROM [Dart].[dbo].[EML_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 0
			AND Reporting_Date <= @DataFromMonth
			AND Reporting_Date NOT IN (SELECT eMonth FROM #month_periods)
	END
	ELSE IF UPPER(@System) = 'HEM'
	BEGIN
		DELETE [Dart].[dbo].[HEM_Portfolio]	WHERE DATEADD(dd, DATEDIFF(dd, 0, Reporting_Date), 0) = DATEADD(dd, DATEDIFF(dd, 0, @AsAt), 0)
		INSERT INTO [Dart].[dbo].[HEM_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 1	
		INSERT INTO [Dart].[dbo].[HEM_Portfolio] EXEC [dbo].[usp_Dashboard_Portfolio] @System, @AsAt, 0
		
		-- Cleaning up data: delete the monthly data before the latest Reporting_Date
		DELETE FROM [Dart].[dbo].[HEM_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 1
			AND Reporting_Date <> (select MAX(Reporting_Date) from [Dart].[dbo].[HEM_Portfolio])
			
		/* Cleaning up data:
		- Delete the daily data that generated before {@DataFromMonth}
		- But keep daily data for days that meet conditions:
			+ Is the end of each month.
			+ In month periods from {@DataFromYear} to {@DataFromMonth} 
		For other days, delete them */
		DELETE FROM [Dart].[dbo].[HEM_Portfolio] WHERE ISNULL(Is_Last_Month, 0) = 0
			AND Reporting_Date <= @DataFromMonth
			AND Reporting_Date NOT IN (SELECT eMonth FROM #month_periods)
	END
	
	-- Delete temp tables
	IF OBJECT_ID('tempdb..#month_periods') IS NOT NULL DROP TABLE #month_periods
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_Portfolio_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_Portfolio_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_AWC.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
-- execute [usp_Dashboard_TMF_AWC] 2013, 1
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_TMF_AWC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_TMF_AWC]
GO

create PROCEDURE [dbo].[usp_Dashboard_TMF_AWC]
      @year int = 2013,
      @month int = 1
AS
BEGIN
	SET NOCOUNT ON
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List		
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP table #AWC_list
	
	declare @startdate datetime = cast(cast(@year as char(4)) + '/'  + cast(@month as char(2)) + '/01' as datetime)
	declare @enddate datetime  = dateadd(dd, -1, dateadd(mm, 1, @startdate)) + '23:59'
	
	declare @SQL varchar(500)

	--Check temp table existing then drop
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NULL
	BEGIN
		create table #_CLAIM_ESTIMATE_SUMMARY
		(
			CLAIM_NO varCHAR(19)
			,TotalAmount MONEY
		) 
		
		SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
			EXEC(@SQL)
		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
			 
		INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
		SELECT CLAIM_NO, SUM(ISNULL(Amount, 0))
		FROM ESTIMATE_DETAILS
		GROUP BY claim_no
	END
	
	CREATE TABLE #_Claim_Detail
	(
		policy_no char(19)
		,Claim_no varchar(19)
		,Claim_Closed_Flag CHAR(1)
		,Claim_Liability_Indicator TINYINT
		,renewal_no INT
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_Detail_'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_Detail(policy_no, Claim_no, Claim_Closed_Flag, Claim_Liability_Indicator)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT INTO #_Claim_Detail
		-- claim detail here
		SELECT  policy_no, 
				Claim_Number,
				Claim_Closed_Flag,
				Claim_Liability_Indicator, 
				Renewal_No
		FROM CLAIM_DETAIL cd INNER JOIN CLAIM_ACTIVITY_DETAIL cad 
			ON rtrim(cd.Claim_Number) =  rtrim(cad.Claim_no)
				AND Date_Created <= @enddate AND Claim_Number <> ''
				LEFT OUTER JOIN amendment_exemptions ae ON cd.Claim_Number = ae.claim_no

	CREATE TABLE #_Claim_List
	(
		Claim_no varchar(19)
		,EXCLUDE BIT
	)
	
	SET @SQL = 'CREATE INDEX pk_Claim_List'+CONVERT(VARCHAR, @@SPID)+' ON #_Claim_List(Claim_no, EXCLUDE)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #_Claim_List
		SELECT cd.Claim_no
			   ,EXCLUDE = (CASE WHEN (cd.Claim_Liability_Indicator IN (1,6,12)) 
									 OR (cd.Claim_Liability_Indicator IN (4) 
										AND ces.TotalAmount <= 0) 
									 OR (cd.Claim_Closed_Flag = 'Y' AND ces.TotalAmount = 0)  
								   THEN 1 
							   ELSE 0 
						   END)
		FROM #_Claim_Detail cd INNER JOIN #_CLAIM_ESTIMATE_SUMMARY ces 
										  ON cd.Claim_no = ces.CLAIM_NO

	CREATE TABLE #_Claim_list_adjusted
	(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,WC_Payment_Type varchar(8)
		 ,Payment_Type varchar(15)
		 ,Trans_Amount money
	)
	
	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_
				ON [dbo].[#_Claim_list_adjusted] (submitted_trans_date)
				INCLUDE ([Claim_no])'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	INSERT  INTO #_Claim_list_adjusted
	SELECT  u.claim_no
			, submitted_trans_date
			, Period_Start_Date
			, Period_End_Date
			, WC_Payment_Type
			, Payment_Type 
			, Trans_Amount = (SELECT SUM(ISNULL(u1.Trans_Amount, 0))
								FROM uv_submitted_Transaction_Payments u1 
								WHERE u1.Claim_No = u.claim_no 
								and u1.Period_Start_Date = u.Period_Start_Date
								and u1.Period_End_Date = u.Period_End_Date 
								and u1.WC_Payment_Type = u.WC_Payment_Type 
								and u1.Payment_Type = u.payment_type)
	FROM uv_submitted_Transaction_Payments u
	WHERE u.submitted_trans_date = (SELECT min(u1.submitted_trans_date) 
									FROM uv_submitted_Transaction_Payments u1 
									WHERE u1.Claim_No = u.claim_no 
										  and u1.Period_Start_Date = u.Period_Start_Date 
										  and u1.Period_End_Date = u.Period_End_Date 
										  and u1.WC_Payment_Type = u.WC_Payment_Type 
										  and u1.Payment_Type = u.payment_type)
		and u.submitted_trans_date between @startdate and @enddate
		and u.WeeklyPayment = 1
	GROUP BY u.claim_no, submitted_trans_date
			 ,Period_Start_Date, Period_End_Date
			 ,WC_Payment_Type, Payment_Type
	ORDER BY claim_no, payment_type, Period_Start_Date, Period_End_Date

	SET @SQL = 'CREATE NONCLUSTERED INDEX pk_Claim_List_submitted_trans_date_Trans_Amount
				ON [dbo].[#_Claim_list_adjusted] (Trans_Amount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	DELETE FROM #_Claim_list_adjusted WHERE Trans_Amount = 0
	DELETE FROM #_Claim_list_adjusted 
		   WHERE CLAIM_NO in (SELECT cla1.claim_no 
							  FROM #_Claim_list_adjusted cla1 
									inner join #_Claim_List cl on cla1.Claim_no = cl.Claim_no 
												and cl.EXCLUDE = 1)

	CREATE TABLE #AWC_list 
	(
		claim_no varchar (19)
		,date_of_injury datetime
	)
	
	SET @SQL = 'CREATE INDEX pk_AWC_list'+CONVERT(VARCHAR, @@SPID)+' ON #AWC_list(Claim_no,date_of_injury)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	INSERT INTO #AWC_list
		SELECT DISTINCT rtrim(cla.claim_no),ca.Date_of_Injury 
		FROM #_Claim_list_adjusted cla 
			 INNER JOIN cd_audit ca ON cla.Claim_no = ca.claim_no 
									   AND cla.submitted_trans_date between @startdate and @enddate
									   AND ca.id = (SELECT MAX(id) 
													FROM cd_audit 
													WHERE ca.claim_no = claim_no 
													AND create_date < @enddate)
										AND ca.fund <> 98
	
	SELECT	Time_ID = @enddate
			,Claim_no = awc_list.Claim_no
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' THEN 'Miscellaneous' ELSE rtrim(UPPER(co.Grp)) END
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')
			,awc_list.Date_of_Injury
			,create_date = getdate()	
			,cd.policy_no
			,Empl_Size = ''
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
		
	FROM	#AWC_list awc_list
			INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = awc_list.claim_no
			INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
			INNER JOIN #_Claim_Detail cd on awc_list.claim_no = cd.Claim_No		
			INNER JOIN cad_audit cada1 on cada1.Claim_No = awc_list.claim_no 
			INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
			LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
			LEFT JOIN (SELECT item,value FROM [control] ctra1 WHERE type = 'GroupLevel') ctra1 
          			ON (CHARINDEX('*'+co.grp+'*',ctra1.value)) <> 0
          	
	WHERE   cada1.id = (SELECT MAX(cada2.id) 
					      FROM  cad_audit cada2 
					      WHERE cada2.claim_no = cada1.claim_no
							    AND cada2.transaction_date <= @enddate) 
			AND coa1.id = (SELECT   MAX(coa2.id) 
						     FROM   CO_audit coa2
						     WHERE  coa2.officer_id = coa1.officer_id
								    AND coa2.create_date <= @enddate)
			
	--drop all temp table
	IF OBJECT_ID('tempdb..#_Claim_list_adjusted') IS NOT NULL DROP TABLE #_Claim_list_adjusted
	IF OBJECT_ID('tempdb..#_Claim_Detail') IS NOT NULL DROP TABLE #_Claim_Detail	
	IF OBJECT_ID('tempdb..#_Claim_List') IS NOT NULL DROP TABLE #_Claim_List
	IF OBJECT_ID('tempdb..#AWC_list') IS NOT NULL DROP TABLE #AWC_list
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_AWC.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_AWC_GenerateData.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_TMF_AWC_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_TMF_AWC_GenerateData]
Go
-- For example
-- exec [usp_Dashboard_TMF_AWC_GenerateData] 2011, 1
-- this will return all result with time id range from 2011-01-31 23:59 till now

CREATE PROCEDURE [dbo].[usp_Dashboard_TMF_AWC_GenerateData]
	@start_period_year int = 2012,
	@start_period_month int = 10
AS
BEGIN
	SET NOCOUNT ON;
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) 
											+ '/' + CAST(@start_period_month as varchar) 
											+ '/01' as datetime)	
	declare @end_period datetime = getdate()
	
	declare @loop_time int = DATEDIFF(month, @start_period, @end_period)
	declare @i int = @loop_time 
	declare @temp datetime
	declare @SQL varchar(500)

	---delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[TMF_AWC] 
			WHERE Time_ID in (select distinct top 3 Time_ID 
			from [DART].[dbo].[TMF_AWC] order by Time_ID desc)')
	---end delete--	
	
	--Check temp table existing then drop	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL DROP TABLE #_CLAIM_ESTIMATE_SUMMARY
		
	CREATE TABLE #_CLAIM_ESTIMATE_SUMMARY
	(
		CLAIM_NO varCHAR(19)
		,TotalAmount MONEY
	) 
	
	SET @SQL = 'CREATE INDEX pk_CLAIM_ESTIMATE_SUMMARY'+CONVERT(VARCHAR, @@SPID)+' ON #_CLAIM_ESTIMATE_SUMMARY(CLAIM_NO, TotalAmount)'
		EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		 
	INSERT INTO #_CLAIM_ESTIMATE_SUMMARY
	SELECT CLAIM_NO, SUM(ISNULL(Amount, 0)) FROM ESTIMATE_DETAILS GROUP BY claim_no	
	
	WHILE (@i >= 0)
	BEGIN
		set @temp = DATEADD(mm, @i, @start_period)
		declare @year int = YEAR(@temp)
		declare @month int = MONTH(@temp)
		
		If NOT EXISTS(select 1 from [DART].[dbo].[TMF_AWC] 
							where Year(Time_ID) = @year and
							Month(Time_ID ) = @month)
		   AND cast(CAST(@year as varchar) + '/' +  CAST(@month as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN		
			print @temp
			--DELETE FROM dbo.TMF_AWC WHERE Time_ID = DATEADD(dd, -1, DATEADD(mm, 1, @temp)) + '23:59'
			--INSERT INTO dbo.TMF_AWC EXEC usp_Dashboard_TMF_AWC @year, @month
			INSERT INTO [DART].[dbo].[TMF_AWC] EXEC usp_Dashboard_TMF_AWC @year, @month
			
		END
		set @i = @i - 1
	END
	--drop temp table 	
	IF OBJECT_ID('tempdb..#_CLAIM_ESTIMATE_SUMMARY') IS NOT NULL drop table #_CLAIM_ESTIMATE_SUMMARY
	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_AWC_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_AWC_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_RTW.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
--  exec [usp_Dashboard_TMF_RTW] 2013, 3, 12 -- 2011M12
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_TMF_RTW]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_TMF_RTW]
GO

CREATE PROCEDURE [dbo].[usp_Dashboard_TMF_RTW]
	@yy int,
	@mm int,
	@RollingMonth int -- 1, 3, 6, 12
AS
BEGIN
	SET NOCOUNT ON;	
	IF OBJECT_ID('tempdb..#Tem_ClaimDetail') IS NOT NULL DROP TABLE #Tem_ClaimDetail
	IF OBJECT_ID('tempdb..#TEMP_MEASURES') IS NOT NULL DROP TABLE #TEMP_MEASURES		
	IF OBJECT_ID('tempdb..#TEMP_PREMIUM_DETAIL') IS NOT NULL DROP table #TEMP_PREMIUM_DETAIL
	
	declare @Measure_month_13 int
	declare @Measure_month_26 int
	declare @Measure_month_52 int
	declare @Measure_month_78 int
	declare @Measure_month_104 int
	declare @transaction_Start datetime
	declare @date_of_injury_Start datetime
	declare @remuneration_Start datetime
	declare @remuneration_End datetime
	declare @Transaction_lag int
	declare @Transaction_lag_Remuneration_End datetime
	declare @Transaction_lag_Remuneration_Start datetime

	set @Measure_month_13 =3  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Measure_month_26 =6  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Measure_month_52 =12  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Measure_month_78 =18  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Measure_month_104 =24  -- 13weeks = 3, 26weeks = 6, 52weeks = 12, 78weeks = 18, 104weeks = 24
	set @Transaction_lag = 3 --for only TMF	

	set @remuneration_End = DATEADD(mm, -@Transaction_lag + 1, cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime))
	set @remuneration_Start = DATEADD(mm,-@RollingMonth, @remuneration_End)
	set @remuneration_End = DATEADD(dd, -1, @remuneration_End) + '23:59'
	set @Transaction_lag_Remuneration_End = DATEADD(MM, @Transaction_lag, @remuneration_End)
	set @Transaction_lag_Remuneration_Start =DATEADD(MM, @Transaction_lag, @remuneration_Start)
	
	
	set @transaction_Start = DATEADD(YY, -3, @remuneration_Start) -- 2 years plus month lag is enough but 3 years for sure

	print 'remuneration Start = ' + cast(@remuneration_Start as varchar)
	print 'remuneration End = ' + cast(@remuneration_End as varchar)
	print 'Transaction_lag = ' + cast(@Transaction_lag as varchar)
	declare @SQL varchar(500)
	
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery_Temp') IS NULL
	BEGIN
		CREATE TABLE #uv_TMF_RTW_Payment_Recovery_Temp
		(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,Payment_Type varchar(15)
		 ,RTW_Payment_Type varchar(3)
		 ,Trans_Amount money
		 ,Payment_no int
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,hours_per_week numeric(5,2)
		 ,HOURS_WC numeric(14,3)
		)

		SET @SQL = 'CREATE INDEX pk_uv_TMF_RTW_Payment_Recovery_Temp_'+CONVERT(VARCHAR, @@SPID)+' ON #uv_TMF_RTW_Payment_Recovery_Temp(Claim_No, Payment_no)'
			EXEC(@SQL)
		IF @@ERROR <>0
			BEGIN
				ROLLBACK TRAN
				RETURN
			END
				
		-- Insert into temptable filter S38, S40, TI
		insert into #uv_TMF_RTW_Payment_Recovery_Temp
		SELECT     dbo.Payment_Recovery.Claim_No, CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte IS NOT NULL 
							  THEN CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte <= CONVERT(datetime, CAST(dbo.Payment_Recovery.wc_Tape_Month AS varchar), 120) 
							  THEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte ELSE dbo.Payment_Recovery.Transaction_date END ELSE CASE WHEN dbo.claim_payment_run.Paid_Date IS NOT NULL
							   THEN dbo.claim_payment_run.Paid_Date ELSE dbo.Payment_Recovery.Transaction_date END END AS submitted_trans_date, 
							  dbo.Payment_Recovery.Payment_Type, CASE WHEN payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004', 'WPT005', 'WPT006', 'WPT007') 
							  THEN 'TI' WHEN payment_type IN ('16', 'WPP002', 'WPP004', 'WPP005', 'WPP006', 'WPP007', 'WPP008') THEN 'S40' WHEN payment_type IN ('13', 'WPP001', 
							  'WPP003') THEN 'S38' END AS RTW_Payment_Type, dbo.Payment_Recovery.Trans_Amount, dbo.Payment_Recovery.Payment_no, dbo.Payment_Recovery.Period_Start_Date, 
							  dbo.Payment_Recovery.Period_End_Date, ISNULL(dbo.Payment_Recovery.hours_per_week, 0) AS hours_per_week, 
							  CASE WHEN Trans_Amount < 0 AND ((isnull(WC_MINUTES, 0) / 60.0) + isnull(WC_HOURS, 0) 
							  + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)) > 0 THEN - (((isnull(WC_MINUTES, 0) / 60.0) + isnull(WC_HOURS, 0) 
							  + isnull(WC_WEEKS * HOURS_PER_WEEK, 0))) ELSE ((isnull(WC_MINUTES, 0) / 60.0) + isnull(WC_HOURS, 0) + isnull(WC_WEEKS * HOURS_PER_WEEK, 
							  0)) END AS HOURS_WC
		FROM         dbo.Payment_Recovery INNER JOIN
							  dbo.CLAIM_PAYMENT_RUN ON dbo.Payment_Recovery.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
							  and
			 (dbo.Payment_Recovery.wc_Tape_Month IS NOT NULL and LEFT(dbo.Payment_Recovery.wc_Tape_Month, 4) <= @yy) AND (dbo.Payment_Recovery.Transaction_date >= @transaction_Start) AND 
							  (dbo.Payment_Recovery.Payment_Type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003', 'WPT004', 'WPT005', 'WPT006', 'WPT007', '16', 'WPP002', 'WPP004', 
							  'WPP005', 'WPP006', 'WPP007', 'WPP008', '13', 'WPP001', 'WPP003'))
		-- End Insert into temptable filter S38, S40, TI
	END
	
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery') IS NULL
	BEGIN
		CREATE TABLE #uv_TMF_RTW_Payment_Recovery
		(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,RTW_Payment_Type varchar(3)
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,hours_per_week numeric(5,2)
		 ,HOURS_WC numeric(14,3)
		 ,Trans_Amount money 
		)

		SET @SQL = 'CREATE INDEX pk_uv_TMF_RTW_Payment_Recovery_'+CONVERT(VARCHAR, @@SPID)+' ON #uv_TMF_RTW_Payment_Recovery(Claim_no, RTW_Payment_Type, submitted_trans_date)'
			EXEC(@SQL)
		IF @@ERROR <>0
			BEGIN
				ROLLBACK TRAN
				RETURN
			END	
		--Insert into temp table after combine transaction--
		insert into #uv_TMF_RTW_Payment_Recovery
		select claim_no, submitted_trans_date, RTW_Payment_Type, Period_Start_Date, Period_End_Date, hours_per_week
				,HOURS_WC = (select SUM(hours_WC) from #uv_TMF_RTW_Payment_Recovery_Temp cla1 where cla1.Claim_No = cla.Claim_No and cla1.RTW_Payment_Type = cla.RTW_Payment_Type and cla1.Period_End_Date = cla.Period_End_Date and cla1.Period_Start_Date = cla.Period_Start_Date  and Period_Start_Date <= @remuneration_End)
				,trans_amount = (select SUM(trans_amount) from #uv_TMF_RTW_Payment_Recovery_Temp cla1 where cla1.Claim_No = cla.Claim_No and cla1.RTW_Payment_Type = cla.RTW_Payment_Type and cla1.Period_End_Date = cla.Period_End_Date and cla1.Period_Start_Date = cla.Period_Start_Date and Period_Start_Date <= @remuneration_End)
		from #uv_TMF_RTW_Payment_Recovery_Temp cla 
		where submitted_trans_date = (select min(cla1.submitted_trans_date) 
					from #uv_TMF_RTW_Payment_Recovery_Temp cla1 
					where cla1.Claim_No = cla.Claim_No 
					and cla1.RTW_Payment_Type = cla.RTW_Payment_Type 
					and cla1.Period_End_Date = cla.Period_End_Date 
					and cla1.Period_Start_Date = cla.Period_Start_Date 
					and Period_Start_Date <= @remuneration_End)
		group by claim_no, submitted_trans_date, RTW_Payment_Type, Period_Start_Date, Period_End_Date, hours_per_week
		--End Insert into temp table after combine transaction--
	END
	
	--Delete reversed transactions--
	delete from #uv_TMF_RTW_Payment_Recovery where (HOURS_WC = 0 and RTW_Payment_Type = 'TI') or Trans_amount = 0
	--End Delete reversed transactions--

	CREATE TABLE #Tem_ClaimDetail
	(
	   Claim_Number CHAR(19)
	   ,Policy_No CHAR(19)
	   ,Renewal_No INT
	   ,Date_of_Injury DATETIME
	   ,Work_Hours NUMERIC(5,2) 
	   ,_13WEEKS_ DATETIME
	   ,_26WEEKS_ DATETIME
	   ,_52WEEKS_ DATETIME
	   ,_78WEEKS_ DATETIME
	   ,_104WEEKS_ DATETIME
	   ,DAYS13 int
	   ,DAYS26 int
	   ,DAYS52 int
	   ,DAYS78 int
	   ,DAYS104 int
	   ,DAYS13_PRD int
	   ,DAYS26_PRD int
	   ,DAYS52_PRD int
	   ,DAYS78_PRD int
	   ,DAYS104_PRD int
	)	

	SET @SQL = 'CREATE INDEX pk_Tem_ClaimDetail_Temp_'+CONVERT(VARCHAR, @@SPID)+' ON #Tem_ClaimDetail(Claim_Number, Policy_No, Date_of_Injury)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		 
		INSERT INTO #Tem_ClaimDetail
		SELECT cd.Claim_Number,cda.Policy_No, Renewal_No,cd.Date_of_Injury,cd.Work_Hours		
				, _13WEEKS_ = dateadd(mm, @Measure_month_13, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))	
				, _26WEEKS_ = dateadd(mm, @Measure_month_26, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))			
				, _52WEEKS_ = dateadd(mm, @Measure_month_52, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))			
				, _78WEEKS_ = dateadd(mm, @Measure_month_78, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))			
				, _104WEEKS_ = dateadd(mm, @Measure_month_104, dateadd(dd, datediff(dd,0, cda.Date_of_Injury), 0))			
				, DAYS13 = 0
				, DAYS26 = 0
				, DAYS52 = 0
				, DAYS78 = 0
				, DAYS104 = 0
				,DAYS13_PRD = 0
				,DAYS26_PRD = 0
				,DAYS52_PRD = 0
				,DAYS78_PRD = 0
				,DAYS104_PRD = 0
			FROM dbo.CLAIM_DETAIL cd INNER JOIN cd_audit cda on cda.claim_no = cd.claim_number 
			AND cda.Fund <> 98
			AND isnull(cd.Claim_Number,'') <> ''
			AND cd.Date_of_Injury >= @transaction_Start
			AND cda.id = (select max(id) from cd_audit cda1 where cda1.claim_no = cd.claim_number and cda1.create_date < @Transaction_lag_Remuneration_End)
	update #Tem_ClaimDetail set DAYS13 = dbo.udf_NoOfDaysWithoutWeekend(Date_of_Injury, _13WEEKS_) + case when datepart(dw,Date_of_Injury) not IN(1,7) then 1 else 0 end
							,   DAYS26 = dbo.udf_NoOfDaysWithoutWeekend(Date_of_Injury, _26WEEKS_) + case when datepart(dw,Date_of_Injury) not IN(1,7) then 1 else 0 end
							,   DAYS52 = dbo.udf_NoOfDaysWithoutWeekend(_26WEEKS_, _52WEEKS_) + case when datepart(dw,_26WEEKS_) not IN(1,7) then 1 else 0 end
							,   DAYS78 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _78WEEKS_) + case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end
							,   DAYS104 = dbo.udf_NoOfDaysWithoutWeekend(_52WEEKS_, _104WEEKS_) + case when datepart(dw,_52WEEKS_) not IN(1,7) then 1 else 0 end
							,	DAYS13_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(Date_of_Injury, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(Date_of_Injury, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
							,	DAYS26_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(Date_of_Injury, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(Date_of_Injury, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
							,	DAYS52_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_26WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
							,	DAYS78_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end
							,	DAYS104_PRD = dbo.udf_NoOfDaysWithoutWeekend(dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start,'1900/01/01'),dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), @remuneration_End,'2222/01/01'))
											+ case when @RollingMonth <> 1 and datepart(dw, dbo.udf_MaxDay(_52WEEKS_, @remuneration_Start, '1900/01/01')) not IN(1,7) then 1 else 0 end

	CREATE TABLE #TEMP_PREMIUM_DETAIL
		(
		POLICY_NO CHAR(19),
		WAGES0 MONEY,
		BTP MONEY,
		RENEWAL_NO INT
		)
		
		
		SET @SQL = 'CREATE INDEX pk_TEMP_PREMIUM_DETAIL_Temp_'+CONVERT(VARCHAR, @@SPID)+' ON #TEMP_PREMIUM_DETAIL(POLICY_NO, RENEWAL_NO)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
	INSERT INTO #TEMP_PREMIUM_DETAIL
		SELECT POLICY_NO,WAGES0,BTP,RENEWAL_NO
				FROM PREMIUM_DETAIL pd
				WHERE EXISTS (SELECT 1 FROM #Tem_ClaimDetail cd where cd.policy_no = pd.POLICY_NO)
				ORDER BY POLICY_NO,RENEWAL_NO


	create table #TEMP_MEASURES
	 (
		Claim_No CHAR(19)	
		,Policy_No VARCHAR(19)	
		,Date_of_Injury DATETIME
		,Period_Start_Date DATETIME
		,Period_End_Date DATETIME
		,PaymentType varchar(3)
		,LT_S38 FLOAT
		,LT_S40 FLOAT
		,LT_TI FLOAT
		,Trans_Amount MONEY
		,hours_per_week_adjusted float	
		,Weeks_Paid_adjusted float	
		,CAP_CUR_13 float	
		,CAP_PRE_13 float	
		,DAYS13_TRANS float
		,DAYS13_TRANS_PRIOR float
		,LT13_TRANS FLOAT
		,LT13_TRANS_PRIOR FLOAT
		,LT13 FLOAT
		,CAP_CUR_26 float	
		,CAP_PRE_26 float	
		,DAYS26_TRANS float
		,DAYS26_TRANS_PRIOR float
		,LT26_TRANS FLOAT
		,LT26_TRANS_PRIOR FLOAT
		,LT26 FLOAT
		,CAP_CUR_52 float
		,CAP_PRE_52 float
		,DAYS52_TRANS float	
		,DAYS52_TRANS_PRIOR float	
		,LT52_TRANS FLOAT	
		,LT52_TRANS_PRIOR FLOAT	
		,LT52 FLOAT
		,CAP_CUR_78 float
		,CAP_PRE_78 float
		,DAYS78_TRANS float	
		,DAYS78_TRANS_PRIOR float	
		,LT78_TRANS FLOAT	
		,LT78_TRANS_PRIOR FLOAT	
		,LT78 FLOAT
		,CAP_CUR_104 float
		,CAP_PRE_104 float
		,DAYS104_TRANS float	
		,DAYS104_TRANS_PRIOR float	
		,LT104_TRANS FLOAT	
		,LT104_TRANS_PRIOR FLOAT	
		,LT104 FLOAT
		,include_13 bit
		,include_26 bit
		,include_52 bit
		,include_78 bit
		,include_104 bit
		,include_13_trans bit
		,include_26_trans bit
		,include_52_trans bit
		,include_78_trans bit
		,include_104_trans bit
		,Total_LT FLOAT	
		,[DAYS] int
		,_13WEEKS_ DATETIME
		,_26WEEKS_ DATETIME
		,_52WEEKS_ DATETIME
		,_78WEEKS_ DATETIME
		,_104WEEKS_ DATETIME
		,EMPL_SIZE varchar(256)
		,DAYS13_PRD_CALC int
		,DAYS26_PRD_CALC int
		,DAYS52_PRD_CALC int
		,DAYS78_PRD_CALC int
		,DAYS104_PRD_CALC int
		,DAYS13_CALC int
		,DAYS26_CALC int
		,DAYS52_CALC int
		,DAYS78_CALC int
		,DAYS104_CALC int
	 )
	 SET @SQL = 'CREATE INDEX pk_TEMP_MEASURES_'+CONVERT(VARCHAR, @@SPID)+' ON #TEMP_MEASURES(Claim_no,Policy_No, Date_of_Injury)'
		EXEC(@SQL)
	IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
			
	insert into #TEMP_MEASURES
	SELECT distinct pr.Claim_No, cd.Policy_No,Date_of_Injury
			,pr.Period_Start_Date
			,pr.Period_End_Date
			,RTW_Payment_Type
			,LT_S38 = case when RTW_Payment_Type = 'S38' and (case when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end) = 0 then 0
								when RTW_Payment_Type = 'S38' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) >= 35 
									then 1.0*case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end * dbo.udf_CheckPositiveOrNegative(Trans_Amount) 
								when RTW_Payment_Type = 'S38' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) < 35  and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) > 0 
									then 1.0*case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end * dbo.udf_CheckPositiveOrNegative(Trans_Amount) * (dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end))/37.5)
								else 0 END
			,LT_S40 = case when RTW_Payment_Type = 'S40' and 
			
			(case when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
									end) = 0 then 0
								when RTW_Payment_Type = 'S40' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) >= 35 
									then 1.0*case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end * 0.75 * dbo.udf_CheckPositiveOrNegative(Trans_Amount) 
								when RTW_Payment_Type = 'S40' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) < 35
									then 1.0*case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end* 0.75 * dbo.udf_CheckPositiveOrNegative(Trans_Amount) * (dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end))/37.5)
								else 0 END
			,LT_TI =  case when RTW_Payment_Type = 'TI' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) >= 35 
									then 1.0 * (pr.HOURS_WC* 5 ) / nullif(dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)),0) * dbo.udf_CheckPositiveOrNegative(Trans_Amount)
								 when RTW_Payment_Type = 'TI' and dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)) < 35 
									then 1.0 * (pr.HOURS_WC * 5 / 37.5)* dbo.udf_CheckPositiveOrNegative(Trans_Amount)	
								else 0 END 
			,Trans_Amount
			,hours_per_week_adjusted = dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end))		
			,Weeks_Paid_adjusted = 1.0 * pr.HOURS_WC / nullif(dbo.udf_MinValue(40, (case when isnull(isnull(cd.Work_Hours,pr.hours_per_week),0) = 0 then cd.Work_Hours when isnull(cd.Work_Hours,pr.hours_per_week) < 1 then 1  else isnull(cd.Work_Hours,pr.hours_per_week) end)),0)
			------13 weeks-------
			,CAP_CUR_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)		
			,CAP_PRE_13 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _13WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			
			,DAYS13_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _13WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _13WEEKS_), Period_End_Date))) end
									
									else 0 end		
			,DAYS13_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _13WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _13WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _13WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _13WEEKS_), Period_End_Date))) end
									
									else 0 end		
			,LT13_TRANS = 0
			,LT13_TRANS_PRIOR = 0
			,LT13 = 0
			------26 weeks-------
			,CAP_CUR_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)		
			,CAP_PRE_26 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _26WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			
			,DAYS26_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _26WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _26WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _26WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _26WEEKS_), Period_End_Date))) end
									
									else 0 end		
			,DAYS26_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _26WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _26WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _26WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _26WEEKS_), Period_End_Date))) end
									
									else 0 end		
			,LT26_TRANS = 0
			,LT26_TRANS_PRIOR = 0
			,LT26 = 0
			------52 weeks-------
			,CAP_CUR_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,CAP_PRE_52 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _52WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,DAYS52_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _52WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _52WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _52WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _52WEEKS_), Period_End_Date))) end
									
									else 0 end
			,DAYS52_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _52WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _52WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _52WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _52WEEKS_), Period_End_Date))) end
									
									else 0 end
			,LT52_TRANS = 0
			,LT52_TRANS_PRIOR = 0
			,LT52 = 0
			------ 78 weeks-------
			,CAP_CUR_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,CAP_PRE_78 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _78WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,DAYS78_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _78WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _78WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _78WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _78WEEKS_), Period_End_Date))) end
									
									else 0 end
			,DAYS78_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _78WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _78WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _78WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _78WEEKS_), Period_End_Date))) end
									
									else 0 end
			,LT78_TRANS = 0
			,LT78_TRANS_PRIOR = 0
			,LT78 = 0
			------ 104 weeks-------
			,CAP_CUR_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), @remuneration_End, '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,CAP_PRE_104 = dbo.udf_MaxValue(0,dbo.udf_NoOfDaysWithoutWeekend(DATEADD(dd, 1, Date_of_Injury), dbo.udf_MinDay(DATEADD(dd, -1, _104WEEKS_), DATEADD(dd, -1, @remuneration_Start), '2222/01/01')) + 
							case when DATEPART(dw,Date_of_Injury) not in (1,7) then 1 else 0 end)
			,DAYS104_TRANS = case when submitted_trans_date <= @Transaction_lag_Remuneration_End and submitted_trans_date < DATEADD(MM, @Transaction_lag, _104WEEKS_ )
									then case when dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _104WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _104WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(@remuneration_End, DATEADD(dd, -1, _104WEEKS_), Period_End_Date))) end
									
									else 0 end
			,DAYS104_TRANS_PRIOR = case when submitted_trans_date < @Transaction_lag_Remuneration_Start and submitted_trans_date < DATEADD(MM, @Transaction_lag, _104WEEKS_ )								
									then case when dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _104WEEKS_), Period_End_Date) >= Period_Start_Date then 
									dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _104WEEKS_), Period_End_Date))) + 
									case when DATEPART(dw,Period_Start_Date) not in (1,7) then 1
										 when RTW_Payment_Type = 'TI' and DATEPART(dw,Period_Start_Date) in (1,7) and DATEPART(dw,Period_End_Date) in (1,7) and DATEDIFF(DD,Period_Start_Date, Period_End_Date) <= 1
										 then 1 + DATEDIFF(DD,Period_Start_Date, Period_End_Date) else 0 end									 
									
									else dbo.udf_MaxValue(0, dbo.udf_NoOfDaysWithoutWeekend(dateadd(dd,1,Period_Start_Date), dbo.udf_MinDay(DATEADD(dd, -1, @remuneration_Start), DATEADD(dd, -1, _104WEEKS_), Period_End_Date))) end
									
									else 0 end
			,LT104_TRANS = 0
			,LT104_TRANS_PRIOR = 0
			,LT104 = 0
			,include_13_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _13WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_26_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _26WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_52_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _52WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_78_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _78WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_104_trans = case when submitted_trans_date <  DATEADD(MM, @Transaction_lag, _104WEEKS_) and submitted_trans_date <= DATEADD(MM, @Transaction_lag, @remuneration_End) 	then 1 else 0 end
			,include_13 = case when (Date_of_Injury between @remuneration_Start and @remuneration_End) or (_13WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  Date_of_Injury and _13WEEKS_) or (@remuneration_End between  Date_of_Injury and _13WEEKS_) then 1 else 0 end
			,include_26 = case when (Date_of_Injury between @remuneration_Start and @remuneration_End) or (_26WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  Date_of_Injury and _26WEEKS_) or (@remuneration_End between  Date_of_Injury and _26WEEKS_) then 1 else 0 end
			,include_52 = case when (_26WEEKS_ between @remuneration_Start and @remuneration_End) or (_52WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  _26WEEKS_ and _52WEEKS_) or (@remuneration_End between  _26WEEKS_ and _52WEEKS_) then 1 else 0 end
			,include_78 = case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) or (_78WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  _52WEEKS_ and _78WEEKS_) or (@remuneration_End between  _52WEEKS_ and _78WEEKS_) then 1 else 0 end
			,include_104 = case when (_52WEEKS_ between @remuneration_Start and @remuneration_End) or (_104WEEKS_ between @remuneration_Start and @remuneration_End) or (@remuneration_Start between  _52WEEKS_ and _104WEEKS_) or (@remuneration_End between  _52WEEKS_ and _104WEEKS_) then 1 else 0 end		
			,Total_LT = 0			
			,[DAYS] = case when RTW_Payment_Type = 'TI' and datepart(dw,period_start_date) IN(1,7) and datepart(dw,period_end_date) IN(1,7) and DATEDIFF(day,period_start_date,period_end_date) <=1
									then DATEDIFF(day,period_start_date,period_end_date) + 1					
								when period_start_date = period_end_date then 1 else 
									dbo.udf_NoOfDaysWithoutWeekend(period_start_date,period_end_date)
								end
			,_13WEEKS_
			,_26WEEKS_ 
			,_52WEEKS_ 
			,_78WEEKS_ 
			,_104WEEKS_
			,EMPL_SIZE = CASE WHEN pd.BTP > 500000 then 'L' 
							 WHEN pd.BTP < 10000 or pd.WAGES0 < 300000 THEN 'S' 
							 ELSE 'M' end 								 
			,DAYS13_PRD_CALC = DAYS13_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_13WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS26_PRD_CALC = DAYS26_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_26WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS52_PRD_CALC = DAYS52_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_52WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS78_PRD_CALC = DAYS78_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_78WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS104_PRD_CALC = DAYS104_PRD + case when  DATEPART(dw, dbo.udf_MinDay(_104WEEKS_, @remuneration_End,'2222/01/01')) not in (1, 7)  then -1 else 0 end
			,DAYS13_CALC = DAYS13 + case when  DATEPART(dw,_13WEEKS_) not in (1, 7)  then -1 else 0 end
			,DAYS26_CALC = DAYS26 + case when  DATEPART(dw,_26WEEKS_) not in (1, 7)  then -1 else 0 end
			,DAYS52_CALC = DAYS52 + case when  DATEPART(dw,_52WEEKS_) not in (1, 7)  then -1 else 0 end
			,DAYS78_CALC = DAYS78 + case when  DATEPART(dw,_78WEEKS_) not in (1, 7)  then -1 else 0 end
			,DAYS104_CALC = DAYS104 + case when  DATEPART(dw,_104WEEKS_) not in (1, 7)  then -1 else 0 end		

		  FROM #Tem_ClaimDetail cd INNER JOIN #uv_TMF_RTW_Payment_Recovery pr ON cd.Claim_Number = pr.Claim_No		
				LEFT JOIN #TEMP_PREMIUM_DETAIL pd ON pd.POLICY_NO = cd.Policy_No AND pd.RENEWAL_NO = cd.Renewal_No
			AND PR.Period_Start_Date <= @remuneration_End						

	-- Update LT_TRANS and LT_TRANS_PRIOR
	update #TEMP_MEASURES set LT13_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS13_TRANS / nullif([DAYS],0)
											end
							,LT13_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS13_TRANS_PRIOR / nullif([DAYS],0)
											end 
							,LT26_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS26_TRANS / nullif([DAYS],0)
											end
							,LT26_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS26_TRANS_PRIOR / nullif([DAYS],0)
											end
							,LT52_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS52_TRANS / nullif([DAYS],0)
											end
							,LT52_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS52_TRANS_PRIOR / nullif([DAYS],0)
											end
							,LT78_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS78_TRANS / nullif([DAYS],0)
											end
							,LT78_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS78_TRANS_PRIOR / nullif([DAYS],0)
											end
							,LT104_TRANS = case when [DAYS] = 0 then 0 else					
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS104_TRANS / nullif([DAYS],0)
											end
							,LT104_TRANS_PRIOR = case when [DAYS] = 0 then 0 else
											1.0 * (LT_S38 + LT_S40 + LT_TI) * DAYS104_TRANS_PRIOR / nullif([DAYS],0)
											end
							,Total_LT = (LT_S38 + LT_S40 + LT_TI) 
										* case when Period_End_Date <= @remuneration_End or [DAYS]=0 then 1 
												when Period_Start_Date > @remuneration_End then 0
											else 1.0 * dbo.udf_NoOfDaysWithoutWeekend(Period_Start_Date, @remuneration_End) / nullif([DAYS],0)
											end						

	-- End update LT_TRANS and LT_TRANS_PRIOR

	--Delete small transactions
	DELETE FROM #TEMP_MEASURES WHERE (
		CASE WHEN PaymentType in ('S40') and [DAYS] <> 0 AND hours_per_week_adjusted >=35 and (1.0 * Trans_Amount / nullif([DAYS],0)) < 2 then 1
			 WHEN PaymentType in ('S40') and [DAYS] <> 0 AND hours_per_week_adjusted < 35 and (1.0 * Trans_Amount / nullif((([DAYS]*hours_per_week_adjusted) / 37.5),0)) < 2   then 1 
			 WHEN PaymentType in ('S40') and [DAYS] = 0 AND LT_S40 <> 0 and (1.0 * Trans_Amount / nullif(LT_S40,0)) < 2 then 1
		ELSE 0
		END = 1)
		
	DELETE FROM #TEMP_MEASURES WHERE (
		CASE WHEN PaymentType in ('S38','TI') and (LT_TI + LT_S38) <> 0 and (1.0 * Trans_Amount / nullif((LT_TI + LT_S38),0)) < 20 then 1
		ELSE 0
		END = 1)
	--End Delete small transactions


	SET @SQL = 'CREATE NONCLUSTERED INDEX Pk_TEMP_MEASURES
				ON [dbo].[#TEMP_MEASURES] ([include_104],[include_104_trans])
				INCLUDE ([Claim_No],[Policy_No],[Date_of_Injury],[CAP_CUR_52],[CAP_PRE_52],[LT52_TRANS],[LT52_TRANS_PRIOR],[CAP_CUR_104],[CAP_PRE_104],[LT104_TRANS],[LT104_TRANS_PRIOR],[Total_LT],[_52WEEKS_],[_104WEEKS_],[EMPL_SIZE],[DAYS104_PRD_CALC],[DAYS104_CALC], [Weeks_Paid_adjusted])'
		EXEC(@SQL)
	IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
	
	-------List Claims 13 weeks----
	select  'Remuneration_Start' = @Transaction_lag_Remuneration_Start
			,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_13
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 13
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
			
	from (
			SELECT rtrim(cla.claim_no) as Claim_no
					,cla.Date_of_Injury
					,cla.Policy_No	
					,round(dbo.udf_MinValue(sum(cla.LT13_TRANS), avg(CAP_CUR_13)) - dbo.udf_MinValue(sum(cla.LT13_TRANS_PRIOR), AVG(CAP_PRE_13)), 10) as LT										
					,round(dbo.udf_MinValue(1, 1.0 * DAYS13_PRD_CALC / nullif(DAYS13_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_13WEEKS_
			FROM #TEMP_MEASURES cla where cla.include_13 = 1 and cla.include_13_trans = 1
			GROUP BY cla.claim_no,Policy_No,cla.Date_of_Injury,_13WEEKS_,DAYS13_PRD_CALC, DAYS13_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT13_TRANS),2) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
		
		
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
					
	union all
	--List Claims 26 weeks--
	select  'Remuneration_Start' = @Transaction_lag_Remuneration_Start
			,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_26
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 26
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
			
	from (
			SELECT rtrim(cla.claim_no) as Claim_no
				,cla.Date_of_Injury
				,cla.Policy_No
				,round(dbo.udf_MinValue(sum(cla.LT26_TRANS), avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), AVG(CAP_PRE_26)), 10) as LT								
				,round(dbo.udf_MinValue(1, 1.0 * DAYS26_PRD_CALC / nullif(DAYS26_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_26WEEKS_
			FROM #TEMP_MEASURES cla where cla.include_26 = 1 and cla.include_26_trans = 1
			GROUP BY cla.claim_no,Policy_No,cla.Date_of_Injury,_26WEEKS_,DAYS26_PRD_CALC, DAYS26_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT26_TRANS),2) > 5
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null ), '')		
		
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
		
	union all
	---List Claims 52 weeks----
	select  'Remuneration_Start' = @Transaction_lag_Remuneration_Start
			,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_52
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 52
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
			
	from (
			SELECT	rtrim(cla.claim_no) as Claim_no	
					,cla.Date_of_Injury	
					,cla.Policy_No	
					,	(round(dbo.udf_MinValue(sum(cla.LT52_TRANS), avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), AVG(CAP_PRE_52)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT26_TRANS), avg(CAP_CUR_26)) - dbo.udf_MinValue(sum(cla.LT26_TRANS_PRIOR), AVG(CAP_PRE_26)), 10))
					) as LT											
					,round(dbo.udf_MinValue(1, 1.0 * DAYS52_PRD_CALC / nullif(DAYS52_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_52WEEKS_
			FROM #TEMP_MEASURES cla 
			WHERE cla.include_52 = 1 and cla.include_52_trans = 1
			GROUP BY cla.claim_no,cla.Policy_No,cla.Date_of_Injury,_52WEEKS_,DAYS52_PRD_CALC, DAYS52_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT52_TRANS),2) > 5	
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no		
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')		
		
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)

	union all
	---List Claims 78 weeks----
	select  'Remuneration_Start' = @Transaction_lag_Remuneration_Start
			,'Remuneration_End' = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_78
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 78
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
			
	from (
			SELECT	rtrim(cla.claim_no) as Claim_no	
					,cla.Date_of_Injury	
					,cla.Policy_No	
					,	(round(dbo.udf_MinValue(sum(cla.LT78_TRANS), avg(CAP_CUR_78)) - dbo.udf_MinValue(sum(cla.LT78_TRANS_PRIOR), AVG(CAP_PRE_78)), 10)
						- (round(dbo.udf_MinValue(sum(cla.LT52_TRANS), avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), AVG(CAP_PRE_52)), 10))
					) as LT												
					,round(dbo.udf_MinValue(1, 1.0 * DAYS78_PRD_CALC / nullif(DAYS78_CALC,0)), 10) as WGT
					,cla.EMPL_SIZE
					,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
					,_78WEEKS_
			FROM #TEMP_MEASURES cla 
			WHERE cla.include_78 = 1 and cla.include_78_trans = 1
			GROUP BY cla.claim_no,cla.Policy_No,cla.Date_of_Injury,_78WEEKS_, DAYS78_PRD_CALC, DAYS78_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT78_TRANS),2) > 5	
		) as cd 
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no		
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')		
		
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)
		
	union all
	---List Claims 104 weeks----
	select  Remuneration_Start = @Transaction_lag_Remuneration_Start
			,Remuneration_End = dateadd(dd, -1, dateadd(mm, DATEDIFF(mm, 0,@remuneration_end) + @Transaction_lag + 1,0)) + '23:59'
			,Measure_months = @Measure_month_104
			,Team = CASE WHEN rtrim(isnull(co.Grp,''))='' then 'Miscellaneous' else rtrim(UPPER(co.Grp)) end
			,Case_manager = ISNULL ( UPPER(co.First_Name+' '+ co.Last_Name), 'Miscellaneous')
			,cd.Claim_no
			,cd.Date_of_Injury
			,cd.Policy_No
			,cd.LT
			,cd.WGT
			,cd.EMPL_SIZE
			,cd.Weeks_Paid
			,create_date = getdate()
			,Measure = 104
			,Cert_Type = case when mc.TYPE = 'P' 
								then 'No Time Lost' 
						      when mc.TYPE = 'T' 
								then 'Totally Unfit'
							  when mc.TYPE = 'S' 
								then 'Suitable Duties'
							  when mc.TYPE = 'I' 
								then 'Pre-Injury Duties'
							  when mc.TYPE = 'M' 
								then 'Permanently Modified Duties'
							  else 'Invalid type' 
						 end
			,Med_cert_From = mc.Med_cert_From
			,Med_cert_To = mc.Med_cert_To
			,Account_Manager = ''
			,Cell_no = NULL
			,Portfolio = ''
			,Stress =case when cdd.MECHANISM_OF_INJURY  in (81,82,84,85,86,87,88) or cdd.nature_of_injury in (910,702,703,704,705,706,707,718,719) then 'Y' else 'N' end
			,Liability_Status = dbo.[udf_GetLiabilityStatusById](cad.Claim_Liability_Indicator)
			,cost_code = (select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code)
			,cost_code2=(select top 1 name from cost_code where policy_no =cd.Policy_No and short_name =cdd.cost_code2)
			,Claim_Closed_flag = cad.Claim_Closed_flag
					
	from (
			SELECT	rtrim(cla.claim_no) as Claim_no	
				,cla.Date_of_Injury	
				,cla.Policy_No	
				,	(round(dbo.udf_MinValue(sum(cla.LT104_TRANS), avg(CAP_CUR_104)) - dbo.udf_MinValue(sum(cla.LT104_TRANS_PRIOR), AVG(CAP_PRE_104)), 10)
					- round(dbo.udf_MinValue(sum(cla.LT52_TRANS), avg(CAP_CUR_52)) - dbo.udf_MinValue(sum(cla.LT52_TRANS_PRIOR), AVG(CAP_PRE_52)), 10)
				) as LT
				,round(dbo.udf_MinValue(1, 1.0 * DAYS104_PRD_CALC / nullif(DAYS104_CALC,0)), 10) as WGT
				,cla.EMPL_SIZE
				,sum(cla.Weeks_Paid_adjusted) as Weeks_Paid
				,_104WEEKS_
			FROM #TEMP_MEASURES cla 
			WHERE cla.include_104 = 1 and cla.include_104_trans = 1
			GROUP BY cla.claim_no,cla.Policy_No,cla.Date_of_Injury,_104WEEKS_, DAYS104_PRD_CALC, DAYS104_CALC, cla.EMPL_SIZE
			HAVING round(SUM(total_LT),2) > 5 and round(sum(LT104_TRANS),2) > 5		
		) as cd 
		
		INNER JOIN CLAIM_ACTIVITY_DETAIL cad on cad.Claim_No = cd.claim_no		
		INNER JOIN Claim_Detail cdd on cad.Claim_No = cdd.claim_number
		INNER JOIN CLAIMS_OFFICERS CO on cad.Claims_Officer = co.Alias
		INNER JOIN cad_audit cada1 on cada1.Claim_No = cd.claim_no
		INNER JOIN CO_audit coa1 on cada1.Claims_Officer = coa1.Alias
		LEFT JOIN (SELECT id, create_date, Claim_no, [Type],Med_cert_From=Date_From,Med_cert_To=Date_To 
							FROM Medical_Cert) mc 
								ON  mc.Claim_no = cd.claim_no 
									AND mc.id = ISNULL((SELECT MAX(mc1.id) 
															FROM	Medical_Cert mc1
															WHERE	mc1.Claim_no = mc.Claim_no
																	AND mc1.cancelled_date is null 
																	AND mc1.cancelled_by is null), '')
	WHERE cada1.id = (SELECT MAX(cada2.id) FROM cad_audit cada2 
				WHERE cada2.claim_no = cada1.claim_no 
				and cada2.transaction_date <= @Transaction_lag_Remuneration_End)
		AND coa1.id = (SELECT MAX(coa2.id) FROM CO_audit coa2
				WHERE coa2.officer_id = coa1.officer_id 
				and coa2.create_date < @Transaction_lag_Remuneration_End)

	--Drop all temp table--
	/*
	drop table #uv_TMF_RTW_Payment_Recovery
	drop table #uv_TMF_RTW_Payment_Recovery_Temp
	*/
	IF OBJECT_ID('tempdb..#Tem_ClaimDetail') IS NOT NULL drop table #Tem_ClaimDetail
	IF OBJECT_ID('tempdb..#TEMP_PREMIUM_DETAIL') IS NOT NULL drop table #TEMP_PREMIUM_DETAIL
	IF OBJECT_ID('tempdb..#TEMP_MEASURES') IS NOT NULL drop table #TEMP_MEASURES	
	--End Drop all temp table--

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_RTW.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_RTW_GenerateData.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
 
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_Dashboard_TMF_RTW_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_Dashboard_TMF_RTW_GenerateData]
GO
-- For example
-- exec [usp_Dashboard_TMF_RTW_GenerateData] 2012, 1
-- this will return all result from 2011/01/01 till now
CREATE PROCEDURE [dbo].[usp_Dashboard_TMF_RTW_GenerateData]
	@start_period_year int = 2010,
	@start_period_month int = 9
AS
BEGIN
	
	SET NOCOUNT ON;
	declare @transaction_Start datetime
	declare @remuneration_Start datetime
	declare @remuneration_End datetime
	declare @Transaction_lag int
	declare @SQL varchar(500)
	set @Transaction_lag = 3 --for only TMF	
	
	-----delete last transaction lag number months in dart db---	
	exec('DELETE FROM [DART].[dbo].[TMF_RTW] 
			WHERE remuneration_end in (select distinct top '+@transaction_lag+' remuneration_end 
			from [DART].[dbo].[TMF_RTW] order by remuneration_end desc)')
	-----end delete--	
	
	declare @start_period datetime = CAST(CAST(@start_period_year as varchar) 
											+ '/' + CAST(@start_period_month as varchar) 
											+ '/01' as datetime)
	
	declare @end_period datetime = getdate()
	declare @loop_time int = datediff(month, @start_period, @end_period)
	declare @i int = @loop_time
	declare @yy int
	declare @mm int
	declare @temp datetime
	
	--Check temp table existing then drop
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery_Temp') IS NOT NULL DROP TABLE #uv_TMF_RTW_Payment_Recovery_Temp
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery') IS NOT NULL DROP TABLE #uv_TMF_RTW_Payment_Recovery
	--Check temp table existing then drop
	
	--create temp table 
	CREATE TABLE #uv_TMF_RTW_Payment_Recovery_Temp
	(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,Payment_Type varchar(15)
		 ,RTW_Payment_Type varchar(3)
		 ,Trans_Amount money
		 ,Payment_no int
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,hours_per_week numeric(5,2)
		 ,HOURS_WC numeric(14,3)
	)
	SET @SQL = 'CREATE INDEX pk_uv_TMF_RTW_Payment_Recovery_Temp_'+CONVERT(VARCHAR, @@SPID)+' ON #uv_TMF_RTW_Payment_Recovery_Temp(Claim_No, Payment_no)'
			EXEC(@SQL)
	IF @@ERROR <>0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
		
	CREATE TABLE #uv_TMF_RTW_Payment_Recovery
	(
		 Claim_no varchar(19)
		 ,submitted_trans_date datetime
		 ,RTW_Payment_Type varchar(3)
		 ,Period_Start_Date datetime
		 ,Period_End_Date datetime
		 ,hours_per_week numeric(5,2)
		 ,HOURS_WC numeric(14,3)
		 ,Trans_Amount money 
	)
	SET @SQL = 'CREATE INDEX pk_uv_TMF_RTW_Payment_Recovery_'+CONVERT(VARCHAR, @@SPID)+' ON #uv_TMF_RTW_Payment_Recovery(Claim_no, RTW_Payment_Type, submitted_trans_date)'
		EXEC(@SQL)
	IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END	
	--end create temp table 
		
	WHILE (@i) >= 0
	BEGIN	
		set @temp = dateadd(mm, @i, @start_period)
		set @yy = year(@temp)
		set @mm = MONTH(@temp)			
		
		If NOT EXISTS(select 1 from [DART].[dbo].[TMF_RTW] 
							where Year(remuneration_end) = @yy and
							Month(remuneration_end ) = @mm)
			
			AND cast(CAST(@yy as varchar) + '/' +  CAST(@mm as varchar) + '/01' as datetime)
				< cast(CAST(year(getdate()) as varchar) + '/' +  CAST(month(getdate()) as varchar) + '/01' as datetime)
		BEGIN	
			print cast(@yy as varchar) + ' and ' + cast(@mm as varchar)				
			print '--------------------delete first'
			
			--DELETE FROM  dbo.TMF_RTW 
			--	   WHERE Year(Remuneration_End) = @yy 
			--			 and Month(Remuneration_End) = @mm
			
			--delete data of temp table 		
			DELETE FROM #uv_TMF_RTW_Payment_Recovery_Temp
			DELETE FROM #uv_TMF_RTW_Payment_Recovery
			
			set @remuneration_End = DATEADD(mm
											, -@Transaction_lag + 1
											, CAST(CAST(@yy as varchar) 
														+ '/' 
														+  CAST(@mm as varchar) 
														+ '/01' as datetime))
			set @remuneration_Start = DATEADD(mm,-12, @remuneration_End)
			set @transaction_Start = DATEADD(YY, -3, @remuneration_Start) -- 2 years plus month lag is enough but 3 years for sure
						
			-- Insert into temptable filter S38, S40, TI
			INSERT	INTO #uv_TMF_RTW_Payment_Recovery_Temp
			SELECT  dbo.Payment_Recovery.Claim_No
					,submitted_trans_date=(CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte IS NOT NULL THEN						   
											   CASE WHEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte <= CONVERT(datetime, CAST(dbo.Payment_Recovery.wc_Tape_Month AS varchar), 120) 
														THEN dbo.CLAIM_PAYMENT_RUN.Authorised_dte 
													 ELSE dbo.Payment_Recovery.Transaction_date 
												END 
										  ELSE 
												CASE WHEN dbo.claim_payment_run.Paid_Date IS NOT NULL
														 THEN dbo.claim_payment_run.Paid_Date 
													 ELSE dbo.Payment_Recovery.Transaction_date 
												END 
										  END)
					,dbo.Payment_Recovery.Payment_Type
					,RTW_Payment_Type = (CASE WHEN payment_type IN ('14', '15', 'WPT001', 'WPT002', 'WPT003'
															,'WPT004', 'WPT005', 'WPT006', 'WPT007') 
												  THEN 'TI' 
											  WHEN payment_type IN ('16', 'WPP002', 'WPP004', 'WPP005'
															,'WPP006', 'WPP007', 'WPP008') 
												  THEN 'S40' 
											  WHEN payment_type IN ('13', 'WPP001','WPP003') 
												  THEN 'S38' 
										 END)
				   , dbo.Payment_Recovery.Trans_Amount
				   , dbo.Payment_Recovery.Payment_no
				   , dbo.Payment_Recovery.Period_Start_Date
				   , dbo.Payment_Recovery.Period_End_Date
				   , hours_per_week = ISNULL(dbo.Payment_Recovery.hours_per_week, 0) 
				   ,HOURS_WC = (CASE  WHEN Trans_Amount < 0 AND ( (isnull(WC_MINUTES, 0) / 60.0) 
																 + isnull(WC_HOURS, 0) 
																 + isnull(WC_WEEKS * HOURS_PER_WEEK, 0)
																) > 0 
										 THEN - ((isnull(WC_MINUTES, 0) / 60.0) 
													+ isnull(WC_HOURS, 0) 
													+ isnull(WC_WEEKS * HOURS_PER_WEEK, 0)) 
									  ELSE  ((isnull(WC_MINUTES, 0) / 60.0) 
											 + isnull(WC_HOURS, 0) 
											 + isnull(WC_WEEKS * HOURS_PER_WEEK,0))
								END)
			FROM         dbo.Payment_Recovery 
							INNER JOIN  dbo.CLAIM_PAYMENT_RUN 
								ON dbo.Payment_Recovery.Payment_no = dbo.CLAIM_PAYMENT_RUN.Payment_no
								 AND (dbo.Payment_Recovery.wc_Tape_Month IS NOT NULL 
									  AND LEFT(dbo.Payment_Recovery.wc_Tape_Month, 4) <= @yy) 
								 AND (dbo.Payment_Recovery.Transaction_date >= @transaction_Start) 
								 AND (dbo.Payment_Recovery.Payment_Type IN ('14', '15', 'WPT001', 'WPT002'
																			,'WPT003', 'WPT004', 'WPT005'
																			, 'WPT006', 'WPT007', '16'
																			, 'WPP002', 'WPP004','WPP005'
																			, 'WPP006', 'WPP007', 'WPP008'
																			, '13', 'WPP001', 'WPP003'))
			-- End Insert into temptable filter S38, S40, TI
			
			--Insert into temp table after combine transaction--
			INSERT INTO #uv_TMF_RTW_Payment_Recovery
			SELECT  claim_no
					, submitted_trans_date
					, RTW_Payment_Type
					, Period_Start_Date
					, Period_End_Date
					, hours_per_week
					, HOURS_WC = (SELECT SUM(hours_WC) 
									FROM   #uv_TMF_RTW_Payment_Recovery_Temp cla1 
									WHERE  cla1.Claim_No = cla.Claim_No 
										   and cla1.RTW_Payment_Type = cla.RTW_Payment_Type 
										   and cla1.Period_End_Date = cla.Period_End_Date 
										   and cla1.Period_Start_Date = cla.Period_Start_Date  
										   and Period_Start_Date <= @remuneration_End)
					, trans_amount = (SELECT SUM(trans_amount) 
										FROM #uv_TMF_RTW_Payment_Recovery_Temp cla1 
										WHERE cla1.Claim_No = cla.Claim_No 
										and cla1.RTW_Payment_Type = cla.RTW_Payment_Type 
										and cla1.Period_End_Date = cla.Period_End_Date 
										and cla1.Period_Start_Date = cla.Period_Start_Date
										and Period_Start_Date <= @remuneration_End)
			FROM #uv_TMF_RTW_Payment_Recovery_Temp cla 
			WHERE submitted_trans_date = (SELECT   min(cla1.submitted_trans_date) 
											FROM   #uv_TMF_RTW_Payment_Recovery_Temp cla1 
											WHERE  cla1.Claim_No = cla.Claim_No 
												   and cla1.RTW_Payment_Type = cla.RTW_Payment_Type 
												   and cla1.Period_End_Date = cla.Period_End_Date 
												   and cla1.Period_Start_Date = cla.Period_Start_Date 
												   and Period_Start_Date <= @remuneration_End)
			GROUP BY claim_no, submitted_trans_date, RTW_Payment_Type, Period_Start_Date, Period_End_Date, hours_per_week
			--End Insert into temp table after combine transaction--		
			--
			
			print '--------------------then insert'
			
			--INSERT INTO [TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 12
			--INSERT INTO [TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 6
			--INSERT INTO [TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 3
			--INSERT INTO [TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 1	
			
			INSERT INTO [Dart].[dbo].[TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 12
			INSERT INTO [Dart].[dbo].[TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 6
			INSERT INTO [Dart].[dbo].[TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 3
			INSERT INTO [Dart].[dbo].[TMF_RTW]  EXEC [dbo].[usp_Dashboard_TMF_RTW] @yy, @mm, 1			
			
			END
			SET @i = @i - 1 	   
		END	
	
	--drop all temp table 
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery') IS NOT NULL drop table #uv_TMF_RTW_Payment_Recovery
	IF OBJECT_ID('tempdb..#uv_TMF_RTW_Payment_Recovery_Temp') IS NOT NULL drop table #uv_TMF_RTW_Payment_Recovery_Temp
	
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW_GenerateData] TO [EMICS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW_GenerateData] TO [EMIUS]
GRANT  EXECUTE  ON [dbo].[usp_Dashboard_TMF_RTW_GenerateData] TO [DART_Role]
GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_Dashboard_TMF_RTW_GenerateData.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_RTW_Index.sql  
--------------------------------  
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_RTW_Index]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_RTW_Index]
GO

CREATE PROCEDURE [dbo].[usp_RTW_Index]
AS
BEGIN
	-- RTW
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_Payment_Recovery_Transaction_Date_Wc_Tape_Month_Payment_Type') 	
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_Payment_Recovery_Transaction_Date_Wc_Tape_Month_Payment_Type] ON [dbo].[Payment_Recovery]([Transaction_date],[wc_Tape_Month],[Payment_Type]) 
		INCLUDE ([Claim_No],[Payment_no],[Trans_Amount],[hours_per_week],[Period_Start_Date],[Period_End_Date],[wc_Hours],[wc_Minutes],[wc_Weeks])	
	END	
	
	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CLAIM_DETAIL_Claim_Number_DOI_Date_of_Injury_Anzsic') 
	BEGIN		
		CREATE NONCLUSTERED INDEX [idx_CLAIM_DETAIL_Claim_Number_DOI_Date_of_Injury_Anzsic] ON [dbo].[CLAIM_DETAIL] 
		(
			[Claim_Number] ASC,
			[Date_of_Injury] ASC,
			[ANZSIC] ASC
		)
		INCLUDE ( [Renewal_No],
		[Work_Hours]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_cd_audit_claim_no') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_cd_audit_claim_no] ON [dbo].[cd_audit] 
		(
			[claim_no] ASC
		)
		INCLUDE ( [id],
		[Date_of_Injury],
		[Policy_No]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_CAD_AUDIT_Claim_no_ID_Claim_Officer_Transaction_Date') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_CAD_AUDIT_Claim_no_ID_Claim_Officer_Transaction_Date] ON [dbo].[CAD_AUDIT] 
		(
			[Claim_no] ASC,
			[ID] ASC,
			[Claims_Officer] ASC,
			[Transaction_Date] ASC
		)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END	

	IF NOT EXISTS (SELECT name FROM sys.indexes  WHERE name = N'idx_ACTIVITY_DETAIL_AUDIT_Policy_No_Renewal_No_Tariff') 
	BEGIN
		CREATE NONCLUSTERED INDEX [idx_ACTIVITY_DETAIL_AUDIT_Policy_No_Renewal_No_Tariff] ON [dbo].[ACTIVITY_DETAIL_AUDIT] 
		(
			[Policy_No] ASC,
			[Renewal_No] ASC,
			[Tariff] ASC
		)
		INCLUDE ( [Wages_Shifts]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	END
END
GO

IF DATEDIFF(DD,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0),GETDATE()) >= 9
BEGIN
	EXEC [dbo].[usp_RTW_Index]
END--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_RTW_Index.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_WOW_Dashboard_Portfolio.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_WOW_Dashboard_Portfolio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_WOW_Dashboard_Portfolio]
GO

CREATE PROCEDURE [dbo].[usp_WOW_Dashboard_Portfolio]
	@AsAt datetime,
	@Is_Last_Month bit
AS
BEGIN
	SET NOCOUNT ON
	
	/* Drop all temp tables first */
	IF OBJECT_ID('tempdb..#claim') IS NOT NULL DROP table #claim
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NOT NULL DROP table #_WEEKLY_PAYMENT_ALL
	
	DECLARE @Reporting_Date datetime
	SET @Reporting_Date = convert(datetime, convert(char, GETDATE(), 106)) + '23:59'
	
	SET @AsAt = convert(datetime, convert(char, @AsAt, 106))
	
	-- determine if this is generating data process for last month or not
	IF @Is_Last_Month = 1
		SET @AsAt = DATEADD(m, DATEDIFF(m, 0, GETDATE()), -1)	-- get the end of last month as input parameter
	
	DECLARE @_curr_fiscal_yr datetime
	SET @_curr_fiscal_yr = case when MONTH(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) <= 6 
									then CAST(YEAR(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) AS varchar(5)) + '-06-30'
								else CAST(YEAR(DATEADD(d,-1,DATEADD(WEEK, DATEDIFF(WEEK, 0, @AsAt), 0))) +1 AS varchar(5)) + '-06-30'	  
							end
	
	DECLARE @SQL varchar(500)
	
	-- end day of next week from @AsAt
	DECLARE @AsAt_Next_Week_End datetime
	SET @AsAt_Next_Week_End = DATEADD(wk, 1, DATEADD(dd, 7-(DATEPART(dw, @AsAt)), @AsAt))
	
	IF OBJECT_ID('tempdb..#claim') IS NULL
	BEGIN
		/* create #claim table to store claim detail info */
		CREATE TABLE #claim
		(
			claim CHAR(19)
			,claim_status varchar(1)
			,date_of_injury datetime
			,date_claim_opened datetime
			,date_claim_closed datetime
			,date_claim_received datetime
			,date_claim_reopened datetime
		)	

		/* create index for #claim table */
		SET @SQL = 'CREATE INDEX pk_claim_' + CONVERT(VARCHAR, @@SPID) + ' ON #claim(claim)'
		EXEC(@SQL)

		IF @@ERROR <>0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		INSERT INTO #claim
			SELECT	cd.Claim
					,cd.ClaimStatus
					,cd.InjuryDate
					,cd.DateOpened
					,cd.DateClosed
					,cd.DateReceived
					,cd.DateReopened
			FROM dbo.AccData cd
			WHERE cd.Claim <> ''
	END
	
	IF OBJECT_ID('tempdb..#_WEEKLY_PAYMENT_ALL') IS NULL
	BEGIN
		CREATE TABLE #_WEEKLY_PAYMENT_ALL
		(
			payment_no int
			,claim varchar(19)
			,trans_date datetime
			,payamt money
			,payment_type int
		)

		/* create index for #_WEEKLY_PAYMENT_ALL table */
		SET @SQL = 'CREATE INDEX pk_WEEKLY_PAYMENT_ALL_' + CONVERT(VARCHAR, @@SPID) 
			+ ' ON #_WEEKLY_PAYMENT_ALL(payment_no)'
			EXEC(@SQL)
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		
		INSERT INTO #_WEEKLY_PAYMENT_ALL
		SELECT  InvoiceID
				,pr.Claim
				,InvoiceDate
				,InvoiceAmount
				,PaymentType
		FROM Invceacc pr INNER JOIN #claim cd on pr.Claim = cd.claim
		WHERE	InvoiceDate <= @AsAt
				
				/* remove reversed claims */
				AND ABS(InvoiceAmount) > 1
	END
	
	SELECT	Case_Manager = UPPER(per.FullName)
			,Reporting_Date = @Reporting_Date
			,Claim_No = cd.Claim
			,Company_Name = cl.ClientName
			,Worker_Name = cd.FirstNames + ', ' + cd.SurName
			,Employee_Number = cd.EmployeeNo
			,Worker_Phone_Number = cd.WorkPhone
			,Date_of_Birth = cd.DOB
			,Date_of_Injury = cd.InjuryDate
			,Total_Paid = (select SUM(pr.InvoiceAmount) + SUM(pr.AmountExGST)
								from Invceacc pr
								where pr.Claim = cd.Claim
									and InvoiceDate <= @AsAt)
			,Date_Claim_Closed = cd.DateClosed
			,Date_Claim_Received = cd.DateReceived
			,Date_Claim_Reopened = cd.DateReopened
			,Result_Of_Injury_Code = cd.InjuryCode
			,Create_Date = getdate()
			,NCMM_Actions_This_Week = (case when cd.ClaimStatus = 'C'
												then ''
											else
												(case when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 2
														then 'First Response Protocol- ensure RTW Plan has been developed'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 3
														then 'Complete 3 week Strategic Plan'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 4
														then 'Treatment Provider Engagement'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 6
														then 'Complete 6 week Strategic Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 10
														then 'Complete 10 Week First Response Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 16
														then 'Complete 16 Week Internal Panel Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 20
														then 'Complete 20 Week Tactical Strategy Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 26
														then 'Complete 26 week Employment Direction Pathyway Review (Internal Panel)'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 40
														then 'Complete 40 Week Tactical Strategy Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 52
														then 'Complete 52 week  Employment Direction Determination (Internal Panel)'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 65
														then 'Complete 65 Week Tactical Strategy Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 76
														then 'Complete 78 week Review in preparation for 78 week panel/handover ( Book Internal Panel)-panel in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 78
														then 'Complete 78 week Internal Panel Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 90
														then 'Complete 90 Week Work Capacity Review (Internal Panel)'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 100
														then 'Complete 100 week Work Capacity Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 114
														then 'Complete 114 week Work Capacity Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 132
														then 'Complete 132 week Internal Panel'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) % 13 = 0
															and CEILING((DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 = 0
														then 'Recovering Independence Internal Panel Review'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) % 13 = 0
															and CEILING((DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 <> 0
														then 'Recovering Independence Quarterly Review'
													else ''
												end)
										end)
			,NCMM_Actions_Next_Week = (case when cd.ClaimStatus = 'C'
												then ''
											else
												(case when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 2
														then 'Prepare for 3 week Strategic Plan- due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 5
														then 'Prepare for 6 week Strategic Review (book Internal panel)- panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 9
														then 'Prepare for 10 week First Response Review- review due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 14
														then 'Prepare for 16 Week Internal Panel Review ( book Internal Panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 15
														then 'Prepare for 16 Week Internal Panel Review- panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 18
														then 'Prepare 20 Week Tactical Strategy Review -review due  in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 19
														then 'Prepare 20 Week Tactical Strategy Review-  review due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 24
														then 'Prepare 26 Week Employment Direction Pathway Review ( book internal panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 25
														then 'Prepare 26 Week Employment Direction Pathway Review-panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 38
														then 'Prepare 40 Week Tactical Strategy Review-review due in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 39
														then 'Prepare 40 Week Tactical Strategy Review- review due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 50
														then 'Prepare Employment Direction Determination Review ( book Internal Panel)-panel  in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 51
														then 'Prepare Employment Direction Determination Review-panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 63
														then 'Prepare 65 Week Tactical Strategy Review- review due in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 64
														then 'Prepare 65 Week Tactical Strategy Review- review due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 75
														then 'Start preparing  78 week  Work Capacity Review - review to be completed  in week 76 as preparation for handover'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 77
														then 'Prepare Review for 78 week panel- Panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 88
														then 'Prepare 90 Week Work Capacity Review (book internal panel)-panel  in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 89
														then 'Prepare 90 Week Work Capacity Review -panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 98
														then 'Prepare 100 week Work Capacity Review- review due in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 99
														then 'Prepare 100 week Work Capacity Review- review due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 112
														then 'Prepare 114 week Work Capacity Review-review due in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 113
														then 'Prepare 114 week Work Capacity Review- review due next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 130
														then 'Prepare 132 week Internal Panel (Book Internal panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 = 131
														then 'Prepare 132 week Internal Panel- panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) % 13 = 11
															and CEILING((DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 = 0
														then 'Prepare review for  Internal Panel (Book Internal panel)- panel in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) % 13 = 12
															and CEILING((DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 = 0
														then 'Prepare review  for Internal Panel- panel next week'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) % 13 = 11
															and CEILING((DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 <> 0
														then 'Prepare Recovering Independence Quarterly Review-review due in 2 weeks'
													when DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 > 132
															and (DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) % 13 = 12
															and CEILING((DATEDIFF(DAY, cd.InjuryDate, @AsAt_Next_Week_End) / 7 - 132) / 13) % 2 <> 0
														then 'Prepare Recovering Independence Quarterly Review- review due next week'
													else ''
												end)
										end)
			,Action_Required = case when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) in (2,3,4,5,6,9,10,14,15,16,18,19,20,
																					 24,25,26,38,39,40,50,51,52,63,64,65,
																					 75,77,76,78,88,89,90,98,99,100,112,113,
																					 114,130,131,132) 
									  OR (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) -132) % 13 = 0
										  AND CEILING((DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) -132) % 13 = 0
										  AND CEILING((DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0)
									  OR (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) -132) % 13 = 11
										  AND CEILING((DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) -132) % 13 = 12
										  AND CEILING((DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) - 132) / 13) % 2 = 0)
									  OR (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) -132) % 13 = 11
										  AND CEILING((DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0)
									  OR (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 132 
										  AND (DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) -132) % 13 = 12
										  AND CEILING((DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) - 132) / 13) % 2 <> 0) then 'Y'
									else 'N'
							   end
			,Weeks_In = DATEDIFF(week,cd.InjuryDate,@AsAt_Next_Week_End)
			,Weeks_Band = case when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 0 and 12 then 'A.0-12 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 13 and 18 then 'B.13-18 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 19 and 22 then 'C.19-22 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 23 and 26 then 'D.23-26 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 27 and 34 then 'E.27-34 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 35 and 48 then 'F.35-48 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 48 and 52 then 'G.48-52 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 53 and 60 then 'H.53-60 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 61 and 76 then 'I.61-76 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 77 and 90 then 'J.77-90 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 91 and 100 then 'K.91-100 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 101 and 117 then 'L.101-117 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) between 118 and 130 then 'M.118-130 WK'
							   when DATEDIFF(week,cd.InjuryDate, @AsAt_Next_Week_End) > 130 then 'N.130+ WK'
						  end
			,Hindsight = case when cd.InjuryDate > DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-36,@_curr_fiscal_yr)) + 1, 0))
								 and  cd.InjuryDate <= DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-24,@_curr_fiscal_yr)) + 1, 0)) 
								 then '3 years'
							  when cd.InjuryDate > DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-60,@_curr_fiscal_yr)) + 1, 0))
								 and  cd.InjuryDate <= DATEADD(day, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-48,@_curr_fiscal_yr)) + 1, 0)) 
								 then '5 years'
							  else ''
						 end
			,Is_Last_Month = @Is_Last_Month
	FROM	AccData cd
	
			-- for getting case manager
			LEFT JOIN Permissn per on per.UserID = cd.CaseManagerID
			
			-- for getting company
			LEFT JOIN Clients cl on cl.ID = cd.ClientID
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_WOW_Dashboard_Portfolio.sql  
--------------------------------  
  
--------------------------------  
-- D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_WOW_Dashboard_Portfolio_GenerateData.sql  
--------------------------------  
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_WOW_Dashboard_Portfolio_GenerateData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_WOW_Dashboard_Portfolio_GenerateData]
GO

CREATE PROCEDURE [dbo].[usp_WOW_Dashboard_Portfolio_GenerateData]
	@AsAt datetime = null
AS
BEGIN
	SET NOCOUNT ON
	if @AsAt is null
		SET @AsAt = GETDATE()
		
	BEGIN		
		DELETE [Dart].[dbo].[WOW_Portfolio]	WHERE convert(datetime, convert(char, Reporting_Date, 106)) = convert(datetime, convert(char, GETDATE(), 106))
		INSERT INTO [Dart].[dbo].[WOW_Portfolio] EXEC [dbo].[usp_WOW_Dashboard_Portfolio] @AsAt, 1
		INSERT INTO [Dart].[dbo].[WOW_Portfolio] EXEC [dbo].[usp_WOW_Dashboard_Portfolio] @AsAt, 0
	END	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO--------------------------------  
-- END of D:\Work\Project\Dart\Branches\Dart\Tool\DBRelease\EMI\tmpChange\StoredProcedure\usp_WOW_Dashboard_Portfolio_GenerateData.sql  
--------------------------------  
