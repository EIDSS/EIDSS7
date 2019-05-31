CREATE TABLE [dbo].[tlbHerd] (
    [idfHerd]              BIGINT           NOT NULL,
    [idfHerdActual]        BIGINT           NULL,
    [idfFarm]              BIGINT           NULL,
    [strHerdCode]          NVARCHAR (200)   NULL,
    [intSickAnimalQty]     INT              NULL,
    [intTotalAnimalQty]    INT              NULL,
    [intDeadAnimalQty]     INT              NULL,
    [strNote]              NVARCHAR (2000)  NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2084] DEFAULT (newid()) ROWGUIDCOL NULL,
    [intRowStatus]         INT              CONSTRAINT [tlbHerd_intRowStatus] DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbHerd] PRIMARY KEY CLUSTERED ([idfHerd] ASC),
    CONSTRAINT [FK_tlbHerd_tlbFarm__idfFarm_R_1480] FOREIGN KEY ([idfFarm]) REFERENCES [dbo].[tlbFarm] ([idfFarm]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHerd_tlbHerdActual] FOREIGN KEY ([idfHerdActual]) REFERENCES [dbo].[tlbHerdActual] ([idfHerdActual]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHerd_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_tlbHerd_I_Delete] on [dbo].[tlbHerd]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfHerd]) as
		(
			SELECT [idfHerd] FROM deleted
			EXCEPT
			SELECT [idfHerd] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbHerd as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfHerd = b.idfHerd;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbHerd_A_Update] ON [dbo].[tlbHerd]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfHerd))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Heards', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHerd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Herd identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHerd', @level2type = N'COLUMN', @level2name = N'idfHerd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Farm identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHerd', @level2type = N'COLUMN', @level2name = N'idfFarm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Herd code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHerd', @level2type = N'COLUMN', @level2name = N'strHerdCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Total animal quantity', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHerd', @level2type = N'COLUMN', @level2name = N'intTotalAnimalQty';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Dead animal quantity', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHerd', @level2type = N'COLUMN', @level2name = N'intDeadAnimalQty';

