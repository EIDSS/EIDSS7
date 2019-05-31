CREATE TABLE [dbo].[tlbStreet] (
    [idfStreet]            BIGINT           NOT NULL,
    [strStreetName]        NVARCHAR (200)   NOT NULL,
    [idfsSettlement]       BIGINT           NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2002] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2005] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbStreet] PRIMARY KEY CLUSTERED ([idfStreet] ASC),
    CONSTRAINT [FK_tlbStreet_gisSettlement__idfsSettlement_R_16] FOREIGN KEY ([idfsSettlement]) REFERENCES [dbo].[gisSettlement] ([idfsSettlement]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbStreet_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [UK_tlbStreet] UNIQUE NONCLUSTERED ([strStreetName] ASC, [idfsSettlement] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_tlbStreet_A_Update] ON [dbo].[tlbStreet]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfStreet))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO



CREATE TRIGGER [dbo].[TR_tlbStreet_I_Delete] on [dbo].[tlbStreet]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfStreet]) as
		(
			SELECT [idfStreet] FROM deleted
			EXCEPT
			SELECT [idfStreet] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbStreet as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfStreet = b.idfStreet;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Streets', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbStreet';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Street name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbStreet', @level2type = N'COLUMN', @level2name = N'strStreetName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Settlement identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbStreet', @level2type = N'COLUMN', @level2name = N'idfsSettlement';

