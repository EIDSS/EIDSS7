CREATE TABLE [dbo].[tlbSpeciesActual] (
    [idfSpeciesActual]     BIGINT           NOT NULL,
    [idfsSpeciesType]      BIGINT           NOT NULL,
    [idfHerdActual]        BIGINT           NULL,
    [datStartOfSignsDate]  DATETIME         NULL,
    [strAverageAge]        NVARCHAR (200)   NULL,
    [intSickAnimalQty]     INT              NULL,
    [intTotalAnimalQty]    INT              NULL,
    [intDeadAnimalQty]     INT              NULL,
    [strNote]              NVARCHAR (2000)  NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__20862] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [tlbSpeciesActual_intRowStatus] DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbSpeciesActual] PRIMARY KEY CLUSTERED ([idfSpeciesActual] ASC),
    CONSTRAINT [FK_tlbSpeciesActual_tlbHerdActual__idfHerdActual_R_1479] FOREIGN KEY ([idfHerdActual]) REFERENCES [dbo].[tlbHerdActual] ([idfHerdActual]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbSpeciesActual_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbSpeciesActual_trtSpeciesType__idfsSpeciesType_R_1651] FOREIGN KEY ([idfsSpeciesType]) REFERENCES [dbo].[trtSpeciesType] ([idfsSpeciesType]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_tlbSpeciesActual_I_Delete] on [dbo].[tlbSpeciesActual]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfSpeciesActual]) as
		(
			SELECT [idfSpeciesActual] FROM deleted
			EXCEPT
			SELECT [idfSpeciesActual] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbSpeciesActual as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfSpeciesActual = b.idfSpeciesActual;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbSpeciesActual_A_Update] ON [dbo].[tlbSpeciesActual]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSpeciesActual))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
