CREATE TABLE [dbo].[tflHumanCaseFiltered] (
    [idfHumanCaseFiltered] BIGINT           NOT NULL,
    [idfHumanCase]         BIGINT           NOT NULL,
    [idfSiteGroup]         BIGINT           NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [tflHumanCaseFiltered_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtflHumanCaseFiltered] PRIMARY KEY CLUSTERED ([idfHumanCaseFiltered] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tflHumanCaseFiltered_tflSiteGroup__idfSiteGroup] FOREIGN KEY ([idfSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflHumanCaseFiltered_tlbHumanCase__idfHumanCase] FOREIGN KEY ([idfHumanCase]) REFERENCES [dbo].[tlbHumanCase] ([idfHumanCase]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflHumanCaseFiltered_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [tflHumanCaseFiltered_idfHumanCase_idfSiteGroup]
    ON [dbo].[tflHumanCaseFiltered]([idfHumanCase] ASC, [idfSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflHumanCaseFiltered_A_Update] ON [dbo].[tflHumanCaseFiltered]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfHumanCaseFiltered))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
