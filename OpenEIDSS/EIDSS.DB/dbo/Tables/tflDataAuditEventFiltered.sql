CREATE TABLE [dbo].[tflDataAuditEventFiltered] (
    [idfDataAuditEventFiltered] BIGINT           NOT NULL,
    [idfDataAuditEvent]         BIGINT           NOT NULL,
    [idfSiteGroup]              BIGINT           NOT NULL,
    [rowguid]                   UNIQUEIDENTIFIER CONSTRAINT [newid__2563] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtflDataAuditEventFiltered] PRIMARY KEY CLUSTERED ([idfDataAuditEventFiltered] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tflDataAuditEventFiltered_tauDataAuditEvent__idfDataAuditEvent_R_1830] FOREIGN KEY ([idfDataAuditEvent]) REFERENCES [dbo].[tauDataAuditEvent] ([idfDataAuditEvent]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflDataAuditEventFiltered_tflSiteGroup__idfSiteGroup] FOREIGN KEY ([idfSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflDataAuditEventFiltered_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [tflDataAuditEventFiltered_idfDataAuditEvent_idfSiteGroup]
    ON [dbo].[tflDataAuditEventFiltered]([idfDataAuditEvent] ASC, [idfSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflDataAuditEventFiltered_A_Update] ON [dbo].[tflDataAuditEventFiltered]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDataAuditEventFiltered))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
