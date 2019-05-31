CREATE TABLE [dbo].[gisSettlement] (
    [idfsSettlement]        BIGINT           NOT NULL,
    [idfsSettlementType]    BIGINT           NOT NULL,
    [idfsCountry]           BIGINT           NOT NULL,
    [idfsRegion]            BIGINT           NOT NULL,
    [idfsRayon]             BIGINT           NOT NULL,
    [strSettlementCode]     NVARCHAR (200)   NULL,
    [dblLongitude]          FLOAT (53)       NULL,
    [dblLatitude]           FLOAT (53)       NULL,
    [blnIsCustomSettlement] BIT              CONSTRAINT [Def_0_2667] DEFAULT ((0)) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__1939] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]          INT              DEFAULT ((0)) NOT NULL,
    [intElevation]          INT              NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisSettlement] PRIMARY KEY CLUSTERED ([idfsSettlement] ASC),
    CONSTRAINT [FK_gisSettlement_gisBaseReference__idfsSettlement_R_1637] FOREIGN KEY ([idfsSettlement]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisSettlement_gisBaseReference__idfsSettlementType_R_1638] FOREIGN KEY ([idfsSettlementType]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisSettlement_gisCountry__idfsCountry_R_7] FOREIGN KEY ([idfsCountry]) REFERENCES [dbo].[gisCountry] ([idfsCountry]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisSettlement_gisRayon__idfsRayon_R_9] FOREIGN KEY ([idfsRayon]) REFERENCES [dbo].[gisRayon] ([idfsRayon]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisSettlement_gisRegion__idfsRegion_R_8] FOREIGN KEY ([idfsRegion]) REFERENCES [dbo].[gisRegion] ([idfsRegion]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisSettlement_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_gisSettlement_A_Update] ON [dbo].[gisSettlement]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsSettlement))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_gisSettlement_I_Delete] on [dbo].[gisSettlement]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsSettlement]) as
		(
			SELECT [idfsSettlement] FROM deleted
			EXCEPT
			SELECT [idfsSettlement] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.gisSettlement as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsSettlement = b.idfsSettlement;


		WITH cteOnlyDeletedRecords([idfsSettlement]) as
		(
			SELECT [idfsSettlement] FROM deleted
			EXCEPT
			SELECT [idfsSettlement] FROM inserted
		)
		
		DELETE a
		FROM dbo.gisBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsGISBaseReference = b.idfsSettlement;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Settlements', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisSettlement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Settlement identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisSettlement', @level2type = N'COLUMN', @level2name = N'idfsSettlement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Settlement type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisSettlement', @level2type = N'COLUMN', @level2name = N'idfsSettlementType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisSettlement', @level2type = N'COLUMN', @level2name = N'idfsCountry';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Region identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisSettlement', @level2type = N'COLUMN', @level2name = N'idfsRegion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Rayon identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisSettlement', @level2type = N'COLUMN', @level2name = N'idfsRayon';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Longitude', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisSettlement', @level2type = N'COLUMN', @level2name = N'dblLongitude';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Latitude', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisSettlement', @level2type = N'COLUMN', @level2name = N'dblLatitude';

