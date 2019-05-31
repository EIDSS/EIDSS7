CREATE TABLE [dbo].[tlbAggrVetCaseMTX] (
    [idfAggrVetCaseMTX]    BIGINT           NOT NULL,
    [idfsSpeciesType]      BIGINT           NOT NULL,
    [idfsDiagnosis]        BIGINT           NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1985] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1988] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfVersion]           BIGINT           NOT NULL,
    [intNumRow]            INT              NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbAggrVetCaseMTX] PRIMARY KEY CLUSTERED ([idfAggrVetCaseMTX] ASC),
    CONSTRAINT [FK_tlbAggrVetCaseMTX_tlbAggrMatrixVersionHeader__idfVersion] FOREIGN KEY ([idfVersion]) REFERENCES [dbo].[tlbAggrMatrixVersionHeader] ([idfVersion]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrVetCaseMTX_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbAggrVetCaseMTX_trtDiagnosis__idfsDiagnosis_R_1617] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrVetCaseMTX_trtSpeciesType__idfsSpeciesType_R_1122] FOREIGN KEY ([idfsSpeciesType]) REFERENCES [dbo].[trtSpeciesType] ([idfsSpeciesType]) NOT FOR REPLICATION
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tlbAggrVetCaseMTX]
    ON [dbo].[tlbAggrVetCaseMTX]([idfsDiagnosis] ASC, [idfsSpeciesType] ASC, [idfVersion] ASC);


GO

CREATE TRIGGER [dbo].[TR_tlbAggrVetCaseMTX_A_Update] ON [dbo].[tlbAggrVetCaseMTX]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfAggrVetCaseMTX))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbAggrVetCaseMTX_I_Delete] on [dbo].[tlbAggrVetCaseMTX]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfAggrVetCaseMTX]) as
		(
			SELECT [idfAggrVetCaseMTX] FROM deleted
			EXCEPT
			SELECT [idfAggrVetCaseMTX] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbAggrVetCaseMTX as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfAggrVetCaseMTX = b.idfAggrVetCaseMTX;

	END

END
