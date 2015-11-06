SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_PORT_Raw]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_PORT_Raw]
GO

CREATE PROCEDURE [dbo].[usp_PORT_Raw]
(
	@System VARCHAR(10)	
	,@End_Date DATETIME
)
AS
BEGIN
	select * from [uv_PORT] 
		where Reporting_Date =  (select top 1 Reporting_Date from [uv_PORT]
									where CONVERT(datetime,  Reporting_Date, 101) 
										>= CONVERT(datetime, @End_Date, 101) AND [system]=@System order by Reporting_Date)
		AND [system]=@System
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO