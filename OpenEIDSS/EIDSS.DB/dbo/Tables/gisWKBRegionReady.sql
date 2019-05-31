CREATE TABLE [dbo].[gisWKBRegionReady] (
    [oid]                  INT              IDENTITY (1, 1) NOT NULL,
    [idfsGeoObject]        BIGINT           NOT NULL,
    [Ratio]                INT              NOT NULL,
    [geomShape_3857]       [sys].[geometry] NULL,
    [geomShape_4326]       [sys].[geometry] NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    PRIMARY KEY CLUSTERED ([oid] ASC),
    CONSTRAINT [FK_gisWKBRegionReady_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_gisWKBRegionReady_A_Update] ON [dbo].[gisWKBRegionReady]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(oid))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
