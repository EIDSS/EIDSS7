CREATE TABLE [dbo].[gisDistrictSubdistrict] (
    [idfsGeoObject]        BIGINT           NOT NULL,
    [idfsParent]           BIGINT           NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisDistrictSubdistrict] PRIMARY KEY CLUSTERED ([idfsGeoObject] ASC),
    CONSTRAINT [FK_gisDistrictSubdistrict_gisRayon__idfsGeoObject] FOREIGN KEY ([idfsGeoObject]) REFERENCES [dbo].[gisRayon] ([idfsRayon]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisDistrictSubdistrict_gisRayon__idfsParent] FOREIGN KEY ([idfsParent]) REFERENCES [dbo].[gisRayon] ([idfsRayon]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisDistrictSubdistrict_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_gisDistrictSubdistrict_A_Update] ON [dbo].[gisDistrictSubdistrict]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsGeoObject))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
