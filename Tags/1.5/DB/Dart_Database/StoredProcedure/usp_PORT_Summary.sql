SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[usp_PORT_Summary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[usp_PORT_Summary]
GO

CREATE PROCEDURE [dbo].[usp_PORT_Summary]
(
	@System VARCHAR(10)
	,@Type VARCHAR(20)
	,@Value NVARCHAR(256)
	,@SubValue NVARCHAR(256)
	,@Start_Date DATETIME
	,@End_Date DATETIME
	,@Claim_Liability_Indicator NVARCHAR(256)
	,@Psychological_Claims VARCHAR(10)
	,@Inactive_Claims VARCHAR(10)
	,@Medically_Discharged VARCHAR(10)
	,@Exempt_From_Reform VARCHAR(10)
	,@Reactivation VARCHAR(10)
)
AS
BEGIN
	IF @Value =  'all'
	BEGIN
		EXEC('EXEC usp_PORT_Agency_Group_Summary ''' + @System + ''',''' + @Type + ''',''' + @Start_Date + ''',''' + @End_Date 
			+ ''',''' + @Claim_Liability_Indicator + ''',''' + @Psychological_Claims + ''',''' + @Inactive_Claims
			+ ''',''' + @Medically_Discharged + ''',''' + @Exempt_From_Reform + ''',''' + @Reactivation + '''')
	END
	ELSE
	BEGIN
		IF @SubValue  = 'all'
		BEGIN
			EXEC('EXEC usp_PORT_Sub_Team_Summary ''' + @System + ''',''' + @Type + ''',''' + @Value + ''',''' + @Start_Date + ''',''' + @End_Date 
				+ ''',''' + @Claim_Liability_Indicator + ''',''' + @Psychological_Claims + ''',''' + @Inactive_Claims
				+ ''',''' + @Medically_Discharged + ''',''' + @Exempt_From_Reform + ''',''' + @Reactivation + '''')
		END
		ELSE
		BEGIN
			EXEC('EXEC usp_PORT_ClaimOfficer_Summary ''' + @System + ''',''' + @Type + ''',''' + @Value + ''',''' + @SubValue + ''',''' + @Start_Date + ''',''' + @End_Date 
				+ ''',''' + @Claim_Liability_Indicator + ''',''' + @Psychological_Claims + ''',''' + @Inactive_Claims
				+ ''',''' + @Medically_Discharged + ''',''' + @Exempt_From_Reform + ''',''' + @Reactivation + '''')
		END
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO