CREATE TABLE [dbo].[tflNotificationFiltered] (
    [idfNotificationFiltered] BIGINT           NOT NULL,
    [idfNotification]         BIGINT           NOT NULL,
    [idfSiteGroup]            BIGINT           NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid__2567] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtflNotificationFiltered] PRIMARY KEY CLUSTERED ([idfNotificationFiltered] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tflNotificationFiltered_tflSiteGroup__idfSiteGroup] FOREIGN KEY ([idfSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflNotificationFiltered_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tflNotificationFiltered_tstNotification__idfNotification_R_1825] FOREIGN KEY ([idfNotification]) REFERENCES [dbo].[tstNotification] ([idfNotification]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [tflNotificationFiltered_idfNotification_idfSiteGroup]
    ON [dbo].[tflNotificationFiltered]([idfNotification] ASC, [idfSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflNotificationFiltered_A_Update] ON [dbo].[tflNotificationFiltered]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfNotificationFiltered))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
