/****** Object:  StoredProcedure [dbo].[PRO_SetScheduleType]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[PRO_SetScheduleType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_SetScheduleType]
GO

/****** Object:  StoredProcedure [dbo].[PRO_SetScheduleType]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery1.sql|0|0|C:\Users\Administrator.ASWLAP08\AppData\Local\Temp\~vs2B93.sql
create proc [dbo].[PRO_SetScheduleType]
	@SubID varchar(50),
	@ScheduleType smallint
as
begin
	update Subscriptions
	set ScheduleType = @ScheduleType
	where SubscriptionID = @SubID
end
GO
