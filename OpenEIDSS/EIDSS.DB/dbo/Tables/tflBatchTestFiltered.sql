CREATE TABLE [dbo].[tflBatchTestFiltered] (
    [idfBatchTestFiltered] BIGINT           NOT NULL,
    [idfBatchTest]         BIGINT           NOT NULL,
    [idfSiteGroup]         BIGINT           NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [tflBatchTestFiltered_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtflBatchTestFiltered] PRIMARY KEY CLUSTERED ([idfBatchTestFiltered] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tflBatchTestFiltered_tflSiteGroup] FOREIGN KEY ([idfSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflBatchTestFiltered_tlbBatchTest] FOREIGN KEY ([idfBatchTest]) REFERENCES [dbo].[tlbBatchTest] ([idfBatchTest]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflBatchTestFiltered_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [tflBatchTestFiltered_idfBatchTest_idfSiteGroup]
    ON [dbo].[tflBatchTestFiltered]([idfBatchTest] ASC, [idfSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflBatchTestFiltered_A_Update] ON [dbo].[tflBatchTestFiltered]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfBatchTestFiltered))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
