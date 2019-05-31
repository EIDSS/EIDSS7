CREATE TABLE [dbo].[gisReferenceType] (
    [idfsGISReferenceType]    BIGINT           NOT NULL,
    [strGISReferenceTypeCode] NVARCHAR (36)    NULL,
    [strGISReferenceTypeName] NVARCHAR (200)   NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid__1934] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]            INT              DEFAULT ((0)) NOT NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisReferenceType] PRIMARY KEY CLUSTERED ([idfsGISReferenceType] ASC),
    CONSTRAINT [FK_gisReferenceType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_gisReferenceType_A_Update] ON [dbo].[gisReferenceType]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsGISReferenceType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_gisReferenceType_I_Delete] on [dbo].[gisReferenceType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsGISReferenceType]) as
		(
			SELECT [idfsGISReferenceType] FROM deleted
			EXCEPT
			SELECT [idfsGISReferenceType] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.gisReferenceType as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsGISReferenceType = b.idfsGISReferenceType;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'GIS Reference types', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisReferenceType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'GIS reference type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisReferenceType', @level2type = N'COLUMN', @level2name = N'idfsGISReferenceType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Legacy GIS reference type string identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisReferenceType', @level2type = N'COLUMN', @level2name = N'strGISReferenceTypeCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'GIS reference type name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisReferenceType', @level2type = N'COLUMN', @level2name = N'strGISReferenceTypeName';

