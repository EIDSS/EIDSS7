CREATE TABLE [dbo].[tflVetCaseFiltered] (
    [idfVetCaseFiltered]   BIGINT           NOT NULL,
    [idfVetCase]           BIGINT           NOT NULL,
    [idfSiteGroup]         BIGINT           NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [tflVetCaseFiltered_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtflVetCaseFiltered] PRIMARY KEY CLUSTERED ([idfVetCaseFiltered] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tflVetCaseFiltered_tflSiteGroup__idfSiteGroup] FOREIGN KEY ([idfSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflVetCaseFiltered_tlbVetCase__idfVetCase] FOREIGN KEY ([idfVetCase]) REFERENCES [dbo].[tlbVetCase] ([idfVetCase]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflVetCaseFiltered_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [tflVetCaseFiltered_idfVetCase_idfSiteGroup]
    ON [dbo].[tflVetCaseFiltered]([idfVetCase] ASC, [idfSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflVetCaseFiltered_A_Update] ON [dbo].[tflVetCaseFiltered]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfVetCaseFiltered))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
