/****** Object:  StoredProcedure [dbo].[PRO_SetSubscriptonStatus]    Script Date: 01/03/2012 13:56:21 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[PRO_SetSubscriptonStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PRO_SetSubscriptonStatus]
GO

/****** Object:  StoredProcedure [dbo].[PRO_SetSubscriptonStatus]    Script Date: 01/03/2012 13:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[PRO_SetSubscriptonStatus]
	@SubID varchar(50),
	@Status smallint
as
begin
	declare @scheduleID varchar(50)
	update Subscriptions
	set [Status] = @Status,
		@scheduleID = ScheduleID
	where SubscriptionID = @SubID
	select @scheduleID
end
GO
