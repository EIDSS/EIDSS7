CREATE TABLE [dbo].[gisWKBSettlement] (
    [idfsGeoObject]        BIGINT           NOT NULL,
    [population]           BIGINT           NULL,
    [admstatus]            INT              NULL,
    [HumanPopulation]      INT              NULL,
    [geomShape]            [sys].[geometry] NULL,
    [intElevation]         INT              NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKwkbSettlement] PRIMARY KEY CLUSTERED ([idfsGeoObject] ASC),
    CONSTRAINT [FK__gisWKBSet__idfsG__322DFAF6] FOREIGN KEY ([idfsGeoObject]) REFERENCES [dbo].[gisSettlement] ([idfsSettlement]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisWKBSettlement_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE SPATIAL INDEX [IX_gisWKBSettlement_geomShape]
    ON [dbo].[gisWKBSettlement] ([geomShape])
    USING GEOMETRY_GRID
    WITH  (
            BOUNDING_BOX = (XMAX = 9686790, XMIN = 2466790, YMAX = 7434550, YMIN = 3439800),
            GRIDS = (LEVEL_1 = MEDIUM, LEVEL_2 = MEDIUM, LEVEL_3 = MEDIUM, LEVEL_4 = MEDIUM)
          );


GO

CREATE TRIGGER [dbo].[TR_gisWKBSettlement_A_Update] ON [dbo].[gisWKBSettlement]
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
