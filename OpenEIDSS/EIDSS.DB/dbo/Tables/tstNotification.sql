CREATE TABLE [dbo].[tstNotification] (
    [idfNotification]               BIGINT           NOT NULL,
    [idfsNotificationObjectType]    BIGINT           NULL,
    [idfsNotificationType]          BIGINT           NULL,
    [idfsTargetSiteType]            BIGINT           NULL,
    [idfUserID]                     BIGINT           NULL,
    [idfNotificationObject]         BIGINT           NULL,
    [idfTargetUserID]               BIGINT           NULL,
    [idfsTargetSite]                BIGINT           NULL,
    [idfsSite]                      BIGINT           CONSTRAINT [Def_fnSiteID_tstNotification] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [datCreationDate]               DATETIME         NOT NULL,
    [datEnteringDate]               DATETIME         NULL,
    [strPayload]                    TEXT             NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [newid__2031] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [datModificationForArchiveDate] DATETIME         CONSTRAINT [tstNotification_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstNotification] PRIMARY KEY CLUSTERED ([idfNotification] ASC),
    CONSTRAINT [FK_tstNotification_trtBaseReference__idfsNotificationObjectType_R_1307] FOREIGN KEY ([idfsNotificationObjectType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNotification_trtBaseReference__idfsNotificationType_R_1306] FOREIGN KEY ([idfsNotificationType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNotification_trtBaseReference__idfsTargetSiteType_R_1304] FOREIGN KEY ([idfsTargetSiteType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNotification_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstNotification_tstSite__idfsSite_R_1035] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNotification_tstSite__idfsTargetSite_R_688] FOREIGN KEY ([idfsTargetSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNotification_tstUserTable__idfTargetUserID_R_720] FOREIGN KEY ([idfTargetUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNotification_tstUserTable__idfUserID_R_793] FOREIGN KEY ([idfUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_tstNotification_I_Delete] on [dbo].[tstNotification]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfNotification]) as
		(
			SELECT [idfNotification] FROM deleted
			EXCEPT
			SELECT [idfNotification] FROM inserted
		)

		UPDATE a
		SET datEnteringDate = GETDATE(),
			datModificationForArchiveDate = GETDATE()
		FROM dbo.tstNotification as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfNotification = b.idfNotification;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tstNotification_A_Update] ON [dbo].[tstNotification]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1)
	BEGIN
		IF UPDATE(idfNotification)
		BEGIN
			RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
			ROLLBACK TRANSACTION
		END

		ELSE
		BEGIN
			UPDATE a
			SET datModificationForArchiveDate = GETDATE()
			FROM dbo.tstNotification AS a 
			INNER JOIN inserted AS b ON a.idfNotification = b.idfNotification
	
		END
	
	END

END


GO


-- =============================================
-- Author:		Romasheva Svetlana
-- Create date: May 19 2014  2:46PM
-- Description:	Trigger for correct problems 
--              with replication and checkin in the same time
-- =============================================
CREATE TRIGGER [dbo].[trtNotificationReplicationUp] 
   ON  [dbo].[tstNotification]
   for INSERT
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON;
	
	declare @FilterListedRecordsOnly bit = 0
	-- get value of global option FilterListedRecordsOnly 
	if exists (select * from tstGlobalSiteOptions tgso where tgso.strName = 'FilterListedRecordsOnly' and tgso.strValue = '1')
		set @FilterListedRecordsOnly = 1 
	else 
		set @FilterListedRecordsOnly = 0
	
	if @FilterListedRecordsOnly = 0 
	begin
		--DECLARE @context VARCHAR(50)
		--SET @context = dbo.fnGetContext()

		delete  nID
		from  dbo.tflNewID as nID
			inner join inserted as ins
			on   ins.idfNotification = nID.idfKey1
		where  nID.strTableName = 'tflNotificationFiltered'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  
				'tflNotificationFiltered', 
				ins.idfNotification, 
				sg.idfSiteGroup
		from  inserted as ins
			inner join dbo.tflSiteToSiteGroup as stsg
			on   stsg.idfsSite = ins.idfsSite
			
			inner join dbo.tflSiteGroup sg
			on	sg.idfSiteGroup = stsg.idfSiteGroup
				and sg.idfsRayon is null
				and sg.idfsCentralSite is null
				and sg.intRowStatus = 0
				
			left join dbo.tflNotificationFiltered as btf
			on  btf.idfNotification = ins.idfNotification
				and btf.idfSiteGroup = sg.idfSiteGroup
		where  btf.idfNotificationFiltered is null

		insert into dbo.tflNotificationFiltered
			(
				idfNotificationFiltered, 
				idfNotification, 
				idfSiteGroup
			)
		select 
				nID.NewID, 
				ins.idfNotification, 
				nID.idfKey2
		from  inserted as ins
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflNotificationFiltered'
				and nID.idfKey1 = ins.idfNotification
				and nID.idfKey2 is not null
			left join dbo.tflNotificationFiltered as btf
			on   btf.idfNotificationFiltered = nID.NewID
		where  btf.idfNotificationFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join inserted as ins
			on   ins.idfNotification = nID.idfKey1
		where  nID.strTableName = 'tflNotificationFiltered'
	end

	SET NOCOUNT OFF;
END
				
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Notifications', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotification';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Notification identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotification', @level2type = N'COLUMN', @level2name = N'idfNotification';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Notification object type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotification', @level2type = N'COLUMN', @level2name = N'idfsNotificationObjectType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'User identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotification', @level2type = N'COLUMN', @level2name = N'idfUserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Notification object identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotification', @level2type = N'COLUMN', @level2name = N'idfNotificationObject';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Notification target user identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotification', @level2type = N'COLUMN', @level2name = N'idfTargetUserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Notification target site identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotification', @level2type = N'COLUMN', @level2name = N'idfsTargetSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotification', @level2type = N'COLUMN', @level2name = N'idfsSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Notification creation date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotification', @level2type = N'COLUMN', @level2name = N'datCreationDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Notification entering date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotification', @level2type = N'COLUMN', @level2name = N'datEnteringDate';

