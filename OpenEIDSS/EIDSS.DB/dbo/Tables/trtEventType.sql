CREATE TABLE [dbo].[trtEventType] (
    [idfsEventTypeID]       BIGINT           NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__2013] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]          INT              DEFAULT ((0)) NOT NULL,
    [blnSubscription]       BIT              NULL,
    [blnDisplayInLog]       BIT              NULL,
    [idfsEventSubscription] BIGINT           NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtEventType] PRIMARY KEY CLUSTERED ([idfsEventTypeID] ASC),
    CONSTRAINT [FK_trtEventType_trtBaseReference__idfsEventSubscription] FOREIGN KEY ([idfsEventSubscription]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtEventType_trtBaseReference__idfsEventTypeID_R_663] FOREIGN KEY ([idfsEventTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtEventType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtEventType_A_Update] ON [dbo].[trtEventType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsEventTypeID))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtEventType_I_Delete] on [dbo].[trtEventType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsEventTypeID]) as
		(
			SELECT [idfsEventTypeID] FROM deleted
			EXCEPT
			SELECT [idfsEventTypeID] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtEventType as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsEventTypeID = b.idfsEventTypeID;


		WITH cteOnlyDeletedRecords([idfsEventTypeID]) as
		(
			SELECT [idfsEventTypeID] FROM deleted
			EXCEPT
			SELECT [idfsEventTypeID] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsEventTypeID;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Event types', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtEventType';

