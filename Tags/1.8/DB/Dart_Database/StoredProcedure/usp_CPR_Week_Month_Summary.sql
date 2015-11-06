SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Week_Month_Summary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Week_Month_Summary]
GO

CREATE PROCEDURE [dbo].[usp_CPR_Week_Month_Summary]
(
	@System VARCHAR(10)			-- TMF, EML, HEM
	,@Type VARCHAR(20)
	,@PeriodType VARCHAR(20)	-- last_two_weeks, last_month
)
AS
BEGIN
	EXEC usp_CPR_Summary @System, @Type, 'all', 'all', '1990-01-01', '1990-01-01', 'all', 'all', 'all', 'all', 'all', 'all', @PeriodType
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO