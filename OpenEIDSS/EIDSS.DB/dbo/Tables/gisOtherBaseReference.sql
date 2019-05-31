CREATE TABLE [dbo].[gisOtherBaseReference] (
    [idfsGISOtherBaseReference] BIGINT           NOT NULL,
    [idfsGISReferenceType]      BIGINT           NOT NULL,
    [strDefault]                NVARCHAR (200)   NULL,
    [intOrder]                  INT              NULL,
    [rowguid]                   UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisOtherBaseReference] PRIMARY KEY CLUSTERED ([idfsGISOtherBaseReference] ASC),
    CONSTRAINT [FK_gisOtherBaseReference_gisReferenceType__idfsGISReferenceType_R_1678] FOREIGN KEY ([idfsGISReferenceType]) REFERENCES [dbo].[gisReferenceType] ([idfsGISReferenceType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisOtherBaseReference_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_gisOtherBaseReference_A_Update] ON [dbo].[gisOtherBaseReference]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsGISOtherBaseReference))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
