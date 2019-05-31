CREATE TABLE [dbo].[tlbFreezer] (
    [idfFreezer]           BIGINT           NOT NULL,
    [idfsStorageType]      BIGINT           NULL,
    [idfsSite]             BIGINT           CONSTRAINT [Def_fnSiteID_tlbFreezer] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [strFreezerName]       NVARCHAR (200)   NULL,
    [strNote]              NVARCHAR (200)   NULL,
    [strBarcode]           NVARCHAR (200)   NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1970] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1974] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [LocBuildingName]      VARCHAR (200)    NULL,
    [LocRoom]              VARCHAR (200)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbFreezer] PRIMARY KEY CLUSTERED ([idfFreezer] ASC),
    CONSTRAINT [FK_tlbFreezer_trtBaseReference__idfsStorageType_R_1256] FOREIGN KEY ([idfsStorageType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFreezer_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbFreezer_tstSite__idfsSite_R_236] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tlbFreezer_A_Update] ON [dbo].[tlbFreezer]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfFreezer))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbFreezer_I_Delete] on [dbo].[tlbFreezer]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfFreezer]) as
		(
			SELECT [idfFreezer] FROM deleted
			EXCEPT
			SELECT [idfFreezer] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbFreezer as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfFreezer = b.idfFreezer;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Freezers', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFreezer';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Storage type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFreezer', @level2type = N'COLUMN', @level2name = N'idfsStorageType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFreezer', @level2type = N'COLUMN', @level2name = N'idfsSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Storage name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFreezer', @level2type = N'COLUMN', @level2name = N'strFreezerName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Storage notes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFreezer', @level2type = N'COLUMN', @level2name = N'strNote';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Barcode (alphanumeric inventory code)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFreezer', @level2type = N'COLUMN', @level2name = N'strBarcode';

