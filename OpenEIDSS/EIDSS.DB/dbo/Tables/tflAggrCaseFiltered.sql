CREATE TABLE [dbo].[tflAggrCaseFiltered] (
    [idfAggrCaseFiltered]  BIGINT           NOT NULL,
    [idfAggrCase]          BIGINT           NOT NULL,
    [idfSiteGroup]         BIGINT           NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2560] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    PRIMARY KEY CLUSTERED ([idfAggrCaseFiltered] ASC),
    CONSTRAINT [FK_tflAggrCaseFiltered_tflSiteGroup__idfSiteGroup] FOREIGN KEY ([idfSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflAggrCaseFiltered_tlbAggrCase__idfAggrCase] FOREIGN KEY ([idfAggrCase]) REFERENCES [dbo].[tlbAggrCase] ([idfAggrCase]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflAggrCaseFiltered_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_tflAggrCaseFiltered_idfAggrCase_idfSiteGroup]
    ON [dbo].[tflAggrCaseFiltered]([idfAggrCase] ASC, [idfSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflAggrCaseFiltered_A_Update] ON [dbo].[tflAggrCaseFiltered]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfAggrCaseFiltered))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
