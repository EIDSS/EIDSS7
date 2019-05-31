CREATE TABLE [dbo].[tlbPostalCode] (
    [idfPostalCode]        BIGINT           NOT NULL,
    [strPostCode]          NVARCHAR (200)   NOT NULL,
    [idfsSettlement]       BIGINT           NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1999] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2002] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbPostalCode] PRIMARY KEY CLUSTERED ([idfPostalCode] ASC),
    CONSTRAINT [FK_tlbPostalCode_gisSettlement__idfsSettlement_R_17] FOREIGN KEY ([idfsSettlement]) REFERENCES [dbo].[gisSettlement] ([idfsSettlement]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbPostalCode_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [UK_tlbPostalCode] UNIQUE NONCLUSTERED ([strPostCode] ASC, [idfsSettlement] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_tlbPostalCode_A_Update] ON [dbo].[tlbPostalCode]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfPostalCode))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbPostalCode_I_Delete] on [dbo].[tlbPostalCode]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfPostalCode]) as
		(
			SELECT [idfPostalCode] FROM deleted
			EXCEPT
			SELECT [idfPostalCode] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbPostalCode as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfPostalCode = b.idfPostalCode;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Postal Codes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPostalCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Postal code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPostalCode', @level2type = N'COLUMN', @level2name = N'strPostCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Settlement identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPostalCode', @level2type = N'COLUMN', @level2name = N'idfsSettlement';

