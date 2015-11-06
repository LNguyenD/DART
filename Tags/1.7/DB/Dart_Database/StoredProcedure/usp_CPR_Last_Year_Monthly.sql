SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_CPR_Last_Year_Monthly]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_CPR_Last_Year_Monthly]
GO
CREATE PROCEDURE [dbo].[usp_CPR_Last_Year_Monthly]
	@System VARCHAR(10),
    @Type VARCHAR (20),
    @Value VARCHAR (256),
    @Primary VARCHAR (256)
AS
BEGIN
	WITH temp AS
	(
		-- For monthly in one year
		SELECT	DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0) AS Start_Date
				,DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()) + 1, 0)) + '23:59' AS End_Date
				,13 AS iMonth
		UNION ALL
		SELECT DATEADD(m, -1, Start_Date), DATEADD(d, -1, Start_Date) + '23:59', iMonth - 1
		FROM temp WHERE End_Date > DATEADD(m, -11, CONVERT(datetime, CONVERT(char, GETDATE(), 106)))
	)

	SELECT * 
	FROM CPR_Monthly
	WHERE [System] = @System
	AND [Type] = @Type
	AND Value = @Value
	AND [Primary] = @Primary
	AND Start_Date in (SELECT Start_Date FROM temp)
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO