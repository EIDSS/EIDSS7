CREATE TABLE [dbo].[tlbSpecies] (
    [idfSpecies]           BIGINT           NOT NULL,
    [idfSpeciesActual]     BIGINT           NULL,
    [idfsSpeciesType]      BIGINT           NOT NULL,
    [idfHerd]              BIGINT           NULL,
    [idfObservation]       BIGINT           NULL,
    [datStartOfSignsDate]  DATETIME         NULL,
    [strAverageAge]        NVARCHAR (200)   NULL,
    [intSickAnimalQty]     INT              NULL,
    [intTotalAnimalQty]    INT              NULL,
    [intDeadAnimalQty]     INT              NULL,
    [strNote]              NVARCHAR (2000)  NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2086] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [tlbSpecies_intRowStatus] DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbSpecies] PRIMARY KEY CLUSTERED ([idfSpecies] ASC),
    CONSTRAINT [FK_tlbSpecies_tlbHerd__idfHerd_R_1479] FOREIGN KEY ([idfHerd]) REFERENCES [dbo].[tlbHerd] ([idfHerd]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbSpecies_tlbObservation__idfObservation_R_1474] FOREIGN KEY ([idfObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbSpecies_tlbSpeciesActual] FOREIGN KEY ([idfSpeciesActual]) REFERENCES [dbo].[tlbSpeciesActual] ([idfSpeciesActual]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbSpecies_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbSpecies_trtSpeciesType__idfsSpeciesType_R_1651] FOREIGN KEY ([idfsSpeciesType]) REFERENCES [dbo].[trtSpeciesType] ([idfsSpeciesType]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_tlbSpecies_SS]
    ON [dbo].[tlbSpecies]([idfSpecies] ASC, [idfsSpeciesType] ASC);


GO

CREATE TRIGGER [dbo].[TR_tlbSpecies_A_Update] ON [dbo].[tlbSpecies]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSpecies))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbSpecies_I_Delete] on [dbo].[tlbSpecies]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfSpecies]) as
		(
			SELECT [idfSpecies] FROM deleted
			EXCEPT
			SELECT [idfSpecies] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbSpecies as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfSpecies = b.idfSpecies;

	END

END
