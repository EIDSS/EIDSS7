CREATE TABLE [dbo].[gisWKBRayon] (
    [idfsGeoObject]          BIGINT           NOT NULL,
    [HumanPopulation]        INT              NULL,
    [HumanPopulationDensity] FLOAT (53)       NULL,
    [Sheep]                  INT              NULL,
    [Goat]                   INT              NULL,
    [Horse]                  INT              NULL,
    [Donkey]                 INT              NULL,
    [Pig]                    INT              NULL,
    [Dog]                    INT              NULL,
    [Poultry]                INT              NULL,
    [LiveStock]              INT              NULL,
    [Area]                   FLOAT (53)       NULL,
    [geomShape]              [sys].[geometry] NULL,
    [rowguid]                UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKwkbRayon] PRIMARY KEY CLUSTERED ([idfsGeoObject] ASC),
    CONSTRAINT [FK__gisWKBRay__idfsG__35FE8BDA] FOREIGN KEY ([idfsGeoObject]) REFERENCES [dbo].[gisRayon] ([idfsRayon]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisWKBRayon_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE SPATIAL INDEX [IX_gisWKBRayon_geomShape]
    ON [dbo].[gisWKBRayon] ([geomShape])
    USING GEOMETRY_GRID
    WITH  (
            BOUNDING_BOX = (XMAX = 9719690, XMIN = 2464440, YMAX = 7448050, YMIN = 3383440),
            GRIDS = (LEVEL_1 = MEDIUM, LEVEL_2 = MEDIUM, LEVEL_3 = MEDIUM, LEVEL_4 = MEDIUM)
          );


GO

CREATE TRIGGER [dbo].[TR_gisWKBRayon_A_Update] ON [dbo].[gisWKBRayon]
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
