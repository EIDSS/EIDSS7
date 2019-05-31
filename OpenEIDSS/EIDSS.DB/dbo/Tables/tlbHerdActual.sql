CREATE TABLE [dbo].[tlbHerdActual] (
    [idfHerdActual]        BIGINT           NOT NULL,
    [idfFarmActual]        BIGINT           NULL,
    [strHerdCode]          NVARCHAR (200)   NULL,
    [intSickAnimalQty]     INT              NULL,
    [intTotalAnimalQty]    INT              NULL,
    [intDeadAnimalQty]     INT              NULL,
    [strNote]              NVARCHAR (2000)  NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__20842] DEFAULT (newid()) ROWGUIDCOL NULL,
    [intRowStatus]         INT              CONSTRAINT [tlbHerdActual_intRowStatus] DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbHerdActual] PRIMARY KEY CLUSTERED ([idfHerdActual] ASC),
    CONSTRAINT [FK_tlbHerdActual_tlbFarmActual__idfFarmActual_R_1480] FOREIGN KEY ([idfFarmActual]) REFERENCES [dbo].[tlbFarmActual] ([idfFarmActual]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHerdActual_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_tlbHerdActual_I_Delete] on [dbo].[tlbHerdActual]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfHerdActual]) as
		(
			SELECT [idfHerdActual] FROM deleted
			EXCEPT
			SELECT [idfHerdActual] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbHerdActual as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfHerdActual = b.idfHerdActual;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbHerdActual_A_Update] ON [dbo].[tlbHerdActual]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfHerdActual))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Heards', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHerdActual';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'HerdActual identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHerdActual', @level2type = N'COLUMN', @level2name = N'idfHerdActual';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Farm identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHerdActual', @level2type = N'COLUMN', @level2name = N'idfFarmActual';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Herd code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHerdActual', @level2type = N'COLUMN', @level2name = N'strHerdCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Total animal quantity', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHerdActual', @level2type = N'COLUMN', @level2name = N'intTotalAnimalQty';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dead animal quantity', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHerdActual', @level2type = N'COLUMN', @level2name = N'intDeadAnimalQty';

