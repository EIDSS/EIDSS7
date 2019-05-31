CREATE TABLE [dbo].[tflSiteGroupRelation] (
    [idfSiteGroupRelation] BIGINT           NOT NULL,
    [idfSenderSiteGroup]   BIGINT           NOT NULL,
    [idfReceiverSiteGroup] BIGINT           NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [tflSiteGroupRelation_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtflSiteGroupRelation] PRIMARY KEY CLUSTERED ([idfSiteGroupRelation] ASC),
    CONSTRAINT [FK_tflSiteGroupRelation_tflSiteGroup_idfReceiverSite] FOREIGN KEY ([idfReceiverSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflSiteGroupRelation_tflSiteGroup_idfsSenderSiteGroup] FOREIGN KEY ([idfSenderSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflSiteGroupRelation_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tflSiteGroupRelation_idfSenderSiteGroup_idfReceiverSiteGroup]
    ON [dbo].[tflSiteGroupRelation]([idfSenderSiteGroup] ASC, [idfReceiverSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflSiteGroupRelation_A_Update] ON [dbo].[tflSiteGroupRelation]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSiteGroupRelation))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
