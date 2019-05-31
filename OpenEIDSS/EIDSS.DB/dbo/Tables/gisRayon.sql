CREATE TABLE [dbo].[gisRayon] (
    [idfsRayon]            BIGINT           NOT NULL,
    [idfsRegion]           BIGINT           NOT NULL,
    [idfsCountry]          BIGINT           NOT NULL,
    [strHASC]              NVARCHAR (6)     NOT NULL,
    [strCode]              NVARCHAR (200)   NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1938] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisRayon] PRIMARY KEY CLUSTERED ([idfsRayon] ASC),
    CONSTRAINT [FK_gisRayon_gisBaseReference__idfsRayon_R_1636] FOREIGN KEY ([idfsRayon]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisRayon_gisCountry__idfsCountry_R_233] FOREIGN KEY ([idfsCountry]) REFERENCES [dbo].[gisCountry] ([idfsCountry]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisRayon_gisRegion__idfsRegion_R_121] FOREIGN KEY ([idfsRegion]) REFERENCES [dbo].[gisRegion] ([idfsRegion]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisRayon_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_gisRayon_I_Delete] on [dbo].[gisRayon]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsRayon]) as
		(
			SELECT [idfsRayon] FROM deleted
			EXCEPT
			SELECT [idfsRayon] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.gisRayon as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsRayon = b.idfsRayon;


		WITH cteOnlyDeletedRecords([idfsRayon]) as
		(
			SELECT [idfsRayon] FROM deleted
			EXCEPT
			SELECT [idfsRayon] FROM inserted
		)
		
		DELETE a
		FROM dbo.gisBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsGISBaseReference = b.idfsRayon;

	END

END

GO

CREATE TRIGGER [dbo].[TR_gisRayon_A_Update] ON [dbo].[gisRayon]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsRayon))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Rayons', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisRayon';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Rayon identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisRayon', @level2type = N'COLUMN', @level2name = N'idfsRayon';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Region identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisRayon', @level2type = N'COLUMN', @level2name = N'idfsRegion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisRayon', @level2type = N'COLUMN', @level2name = N'idfsCountry';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Rayon HASC code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisRayon', @level2type = N'COLUMN', @level2name = N'strHASC';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisRayon', @level2type = N'COLUMN', @level2name = N'strCode';

