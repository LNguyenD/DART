/****** Object:  UserDefinedFunction [dbo].[udf_BuildFinancialList]    Script Date: 03/26/2012 10:33:45 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[udf_BuildFinancialList]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[udf_BuildFinancialList]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_BuildFinancialList]    Script Date: 03/26/2012 10:33:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from udf_BuildFinancialList(2012,5) order by Year_Period
CREATE FUNCTION [dbo].[udf_BuildFinancialList]
(
	@Current_Year smallint,
	@Metric	smallint
)
RETURNS 
@Financial_Years TABLE 
(
	Year_Period varchar(9)
)
AS
BEGIN
	Declare @selected_Year smallint
	set @selected_Year = @Current_Year
	WHILE @selected_Year >= @Current_Year -@Metric 
		BEGIN
			INSERT INTO @Financial_Years VALUES (convert(varchar,(@selected_Year-2)) +'/' + convert(varchar,(@selected_Year-1)))	
			set @selected_Year = @selected_Year -1	
		END
	RETURN 
END

GO

GRANT  CONTROL  ON [dbo].[udf_BuildFinancialList]  TO [EMICS]
GO

GRANT  CONTROL  ON [dbo].[udf_BuildFinancialList]  TO [EMIUS]
GO