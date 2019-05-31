CREATE TABLE [dbo].[gisMetadata] (
    [strLayer]             NVARCHAR (256)   NOT NULL,
    [strLayerType]         NVARCHAR (256)   NULL,
    [strProjection]        NVARCHAR (256)   NULL,
    [intFeatureCount]      INT              NULL,
    [intLayerClass]        INT              CONSTRAINT [DF_gisMetadata_intLayerClass] DEFAULT ((2)) NOT NULL,
    [strAlias]             NVARCHAR (256)   NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisMetadata] PRIMARY KEY CLUSTERED ([strLayer] ASC),
    CONSTRAINT [FK_gisMetadata_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_gisMetadata_A_Update] ON [dbo].[gisMetadata]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(strLayer))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
