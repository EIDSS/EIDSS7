CREATE TABLE [dbo].[gisWKBForest] (
    [idfsGeoObject]        BIGINT           NOT NULL,
    [geomShape]            [sys].[geometry] NULL,
    [idfsCountry]          BIGINT           NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisWKBForest] PRIMARY KEY CLUSTERED ([idfsGeoObject] ASC),
    CONSTRAINT [FK_gisWKBForest_gisCountry] FOREIGN KEY ([idfsCountry]) REFERENCES [dbo].[gisCountry] ([idfsCountry]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisWKBForest_gisOtherBaseReference] FOREIGN KEY ([idfsGeoObject]) REFERENCES [dbo].[gisOtherBaseReference] ([idfsGISOtherBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisWKBForest_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE SPATIAL INDEX [IX_gisWKBForest_geomShape]
    ON [dbo].[gisWKBForest] ([geomShape])
    USING GEOMETRY_GRID
    WITH  (
            BOUNDING_BOX = (XMAX = 9205300, XMIN = 2467150, YMAX = 7391230, YMIN = 4752400),
            GRIDS = (LEVEL_1 = MEDIUM, LEVEL_2 = MEDIUM, LEVEL_3 = MEDIUM, LEVEL_4 = MEDIUM)
          );


GO

CREATE TRIGGER [dbo].[TR_gisWKBForest_A_Update] ON [dbo].[gisWKBForest]
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
