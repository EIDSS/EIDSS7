CREATE TABLE [dbo].[tlbAggrDiagnosticActionMTX] (
    [idfAggrDiagnosticActionMTX] BIGINT           NOT NULL,
    [idfsSpeciesType]            BIGINT           NOT NULL,
    [idfsDiagnosis]              BIGINT           NOT NULL,
    [idfsDiagnosticAction]       BIGINT           NOT NULL,
    [intRowStatus]               INT              CONSTRAINT [Def_0_1982] DEFAULT ((0)) NOT NULL,
    [rowguid]                    UNIQUEIDENTIFIER CONSTRAINT [newid__1985] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfVersion]                 BIGINT           NOT NULL,
    [intNumRow]                  INT              NULL,
    [strMaintenanceFlag]         NVARCHAR (20)    NULL,
    [strReservedAttribute]       NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbAggrDiagnosticActionMTX] PRIMARY KEY CLUSTERED ([idfAggrDiagnosticActionMTX] ASC),
    CONSTRAINT [FK_tlbAggrDiagnosticActionMTX_tlbAggrMatrixVersionHeader__idfVersion] FOREIGN KEY ([idfVersion]) REFERENCES [dbo].[tlbAggrMatrixVersionHeader] ([idfVersion]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrDiagnosticActionMTX_trtBaseReference__idfsDiagnosticAction_R_1117] FOREIGN KEY ([idfsDiagnosticAction]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrDiagnosticActionMTX_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbAggrDiagnosticActionMTX_trtDiagnosis__idfsDiagnosis_R_1616] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrDiagnosticActionMTX_trtSpeciesType__idfsSpeciesType_R_1116] FOREIGN KEY ([idfsSpeciesType]) REFERENCES [dbo].[trtSpeciesType] ([idfsSpeciesType]) NOT FOR REPLICATION
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tlbAggrDiagnosticActionMTX]
    ON [dbo].[tlbAggrDiagnosticActionMTX]([idfsDiagnosis] ASC, [idfsDiagnosticAction] ASC, [idfsSpeciesType] ASC, [idfVersion] ASC);


GO


CREATE TRIGGER [dbo].[TR_tlbAggrDiagnosticActionMTX_I_Delete] on [dbo].[tlbAggrDiagnosticActionMTX]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfAggrDiagnosticActionMTX]) as
		(
			SELECT [idfAggrDiagnosticActionMTX] FROM deleted
			EXCEPT
			SELECT [idfAggrDiagnosticActionMTX] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbAggrDiagnosticActionMTX as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfAggrDiagnosticActionMTX = b.idfAggrDiagnosticActionMTX;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbAggrDiagnosticActionMTX_A_Update] ON [dbo].[tlbAggrDiagnosticActionMTX]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfAggrDiagnosticActionMTX))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
