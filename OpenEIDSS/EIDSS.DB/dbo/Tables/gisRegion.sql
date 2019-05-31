CREATE TABLE [dbo].[gisRegion] (
    [idfsRegion]           BIGINT           NOT NULL,
    [idfsCountry]          BIGINT           NOT NULL,
    [strHASC]              NVARCHAR (6)     NOT NULL,
    [strCode]              NVARCHAR (200)   NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1937] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisRegion] PRIMARY KEY CLUSTERED ([idfsRegion] ASC),
    CONSTRAINT [FK_gisRegion_gisBaseReference__idfsRegion_R_1635] FOREIGN KEY ([idfsRegion]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisRegion_gisCountry__idfsCountry_R_232] FOREIGN KEY ([idfsCountry]) REFERENCES [dbo].[gisCountry] ([idfsCountry]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisRegion_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_gisRegion_I_Delete] on [dbo].[gisRegion]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsRegion]) as
		(
			SELECT [idfsRegion] FROM deleted
			EXCEPT
			SELECT [idfsRegion] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.gisRegion as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsRegion = b.idfsRegion;


		WITH cteOnlyDeletedRecords([idfsRegion]) as
		(
			SELECT [idfsRegion] FROM deleted
			EXCEPT
			SELECT [idfsRegion] FROM inserted
		)
		
		DELETE a
		FROM dbo.gisBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsGISBaseReference = b.idfsRegion;

	END

END

GO

CREATE TRIGGER [dbo].[TR_gisRegion_A_Update] ON [dbo].[gisRegion]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsRegion))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Regions', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisRegion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Region identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisRegion', @level2type = N'COLUMN', @level2name = N'idfsRegion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisRegion', @level2type = N'COLUMN', @level2name = N'idfsCountry';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Region HASC code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisRegion', @level2type = N'COLUMN', @level2name = N'strHASC';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisRegion', @level2type = N'COLUMN', @level2name = N'strCode';

