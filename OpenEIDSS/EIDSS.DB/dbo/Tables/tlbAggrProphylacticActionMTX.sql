CREATE TABLE [dbo].[tlbAggrProphylacticActionMTX] (
    [idfAggrProphylacticActionMTX] BIGINT           NOT NULL,
    [idfsSpeciesType]              BIGINT           NOT NULL,
    [idfsDiagnosis]                BIGINT           NOT NULL,
    [idfsProphilacticAction]       BIGINT           NOT NULL,
    [intRowStatus]                 INT              CONSTRAINT [Def_0_1984] DEFAULT ((0)) NOT NULL,
    [rowguid]                      UNIQUEIDENTIFIER CONSTRAINT [newid__1987] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfVersion]                   BIGINT           NOT NULL,
    [intNumRow]                    INT              NULL,
    [strMaintenanceFlag]           NVARCHAR (20)    NULL,
    [strReservedAttribute]         NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbAggrProphylacticActionMTX] PRIMARY KEY CLUSTERED ([idfAggrProphylacticActionMTX] ASC),
    CONSTRAINT [FK_tlbAggrProphylacticActionMTX_tlbAggrMatrixVersionHeader__idfVersion] FOREIGN KEY ([idfVersion]) REFERENCES [dbo].[tlbAggrMatrixVersionHeader] ([idfVersion]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrProphylacticActionMTX_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbAggrProphylacticActionMTX_trtDiagnosis__idfsDiagnosis_R_1615] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrProphylacticActionMTX_trtProphilacticAction__idfsProphilacticAction_R_1614] FOREIGN KEY ([idfsProphilacticAction]) REFERENCES [dbo].[trtProphilacticAction] ([idfsProphilacticAction]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrProphylacticActionMTX_trtSpeciesType__idfsSpeciesType_R_1119] FOREIGN KEY ([idfsSpeciesType]) REFERENCES [dbo].[trtSpeciesType] ([idfsSpeciesType]) NOT FOR REPLICATION
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tlbAggrProphylacticActionMTX]
    ON [dbo].[tlbAggrProphylacticActionMTX]([idfsDiagnosis] ASC, [idfsProphilacticAction] ASC, [idfsSpeciesType] ASC, [idfVersion] ASC);


GO


CREATE TRIGGER [dbo].[TR_tlbAggrProphylacticActionMTX_I_Delete] on [dbo].[tlbAggrProphylacticActionMTX]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfAggrProphylacticActionMTX]) as
		(
			SELECT [idfAggrProphylacticActionMTX] FROM deleted
			EXCEPT
			SELECT [idfAggrProphylacticActionMTX] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbAggrProphylacticActionMTX as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfAggrProphylacticActionMTX = b.idfAggrProphylacticActionMTX;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbAggrProphylacticActionMTX_A_Update] ON [dbo].[tlbAggrProphylacticActionMTX]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfAggrProphylacticActionMTX))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
