CREATE TABLE [dbo].[gisBaseReference] (
    [idfsGISBaseReference] BIGINT           NOT NULL,
    [idfsGISReferenceType] BIGINT           NOT NULL,
    [strBaseReferenceCode] VARCHAR (36)     NULL,
    [strDefault]           NVARCHAR (200)   NULL,
    [intOrder]             INT              NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1935] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisBaseReference] PRIMARY KEY CLUSTERED ([idfsGISBaseReference] ASC),
    CONSTRAINT [FK_gisBaseReference_gisReferenceType__idfsGISReferenceType_R_1632] FOREIGN KEY ([idfsGISReferenceType]) REFERENCES [dbo].[gisReferenceType] ([idfsGISReferenceType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisBaseReference_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_gisBaseReference_RS1]
    ON [dbo].[gisBaseReference]([idfsGISReferenceType] ASC)
    INCLUDE([strDefault]);


GO


CREATE TRIGGER [dbo].[TR_gisBaseReference_I_Delete] on [dbo].[gisBaseReference]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsGISBaseReference]) as
		(
			SELECT [idfsGISBaseReference] FROM deleted
			EXCEPT
			SELECT [idfsGISBaseReference] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.gisBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsGISBaseReference = b.idfsGISBaseReference;

	END

END

GO

CREATE TRIGGER [dbo].[TR_gisBaseReference_A_Update] ON [dbo].[gisBaseReference]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsGISBaseReference))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Base Reference table for GIS reference values', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisBaseReference';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'GIS reference value identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisBaseReference', @level2type = N'COLUMN', @level2name = N'idfsGISBaseReference';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'GIS reference type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisBaseReference', @level2type = N'COLUMN', @level2name = N'idfsGISReferenceType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Legacy string identifier for value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisBaseReference', @level2type = N'COLUMN', @level2name = N'strBaseReferenceCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Default value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisBaseReference', @level2type = N'COLUMN', @level2name = N'strDefault';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Order in lists/lookups', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisBaseReference', @level2type = N'COLUMN', @level2name = N'intOrder';

