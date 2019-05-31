CREATE TABLE [dbo].[gisWKBDistrictReady] (
    [oid]                  INT              IDENTITY (1, 1) NOT NULL,
    [idfsGeoObject]        BIGINT           NOT NULL,
    [Ratio]                INT              NOT NULL,
    [geomShape_3857]       [sys].[geometry] NULL,
    [geomShape_4326]       [sys].[geometry] NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK__gisWKBDi__C2FFCF1354A99B0D] PRIMARY KEY CLUSTERED ([oid] ASC),
    CONSTRAINT [FK_gisWKBDistrictReady_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_gisWKBDistrictReady_A_Update] ON [dbo].[gisWKBDistrictReady]
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
