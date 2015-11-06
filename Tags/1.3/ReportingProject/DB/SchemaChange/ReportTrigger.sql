/****** Object:  Trigger [tr_Reports]    Script Date: 04/14/2012 05:40:23 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_Reports]'))
DROP TRIGGER [dbo].[tr_Reports]
GO

/****** Object:  Trigger [dbo].[tr_Reports]    Script Date: 04/14/2012 05:40:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Trigger dbo.tr_Activity_Detail_ui    Script Date: 1/17/04 1:47:00 PM ******/

CREATE TRIGGER [dbo].[tr_Reports]
ON [dbo].[Reports]

FOR UPDATE,INSERT,DELETE
AS
	Declare @Action as varchar(16)
	if exists(select ReportId from inserted) and not exists(select ReportId from deleted) --insert	
		set @Action ='Add'
	else if exists(select ReportId from inserted) and  exists(select ReportId from deleted) --update
		begin
			set @Action ='Update'
			
			DECLARE @newStatus smallint
			DECLARE @oldStatus smallint
			
			SET @newStatus = (SELECT top 1 [Status] FROM Inserted)
			SET @oldStatus = (SELECT top 1  [Status] FROM Deleted)
			IF @oldStatus != @newStatus and @newStatus =3
			 BEGIN
				insert into Reports_Audit(ReportId,CategoryId,Name,ShortName,Url,[Status],Action_Type,Action_Date,Action_Owner)
				select ReportId,CategoryId,Name,ShortName,Url,[Status],'Delete',GETDATE(),UpdatedBy from inserted u
			 END
		end
	insert into Reports_Audit(ReportId,CategoryId,Name,ShortName,Url,[Status],Action_Type,Action_Date,Action_Owner)
	select ReportId,CategoryId,Name,ShortName,Url,[Status],@Action,GETDATE(),UpdatedBy from inserted u 
RETURN


GO


