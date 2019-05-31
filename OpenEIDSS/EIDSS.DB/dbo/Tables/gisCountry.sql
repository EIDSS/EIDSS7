CREATE TABLE [dbo].[gisCountry] (
    [idfsCountry]          BIGINT           NOT NULL,
    [strHASC]              NVARCHAR (6)     NOT NULL,
    [strCode]              NVARCHAR (200)   NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1936] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisCountry] PRIMARY KEY CLUSTERED ([idfsCountry] ASC),
    CONSTRAINT [FK_gisCountry_gisBaseReference__idfsCountry_R_1634] FOREIGN KEY ([idfsCountry]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisCountry_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_gisCountry_I_Delete] on [dbo].[gisCountry]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsCountry]) as
		(
			SELECT [idfsCountry] FROM deleted
			EXCEPT
			SELECT [idfsCountry] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.gisCountry as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsCountry = b.idfsCountry;


		WITH cteOnlyDeletedRecords([idfsCountry]) as
		(
			SELECT [idfsCountry] FROM deleted
			EXCEPT
			SELECT [idfsCountry] FROM inserted
		)
		
		DELETE a
		FROM dbo.gisBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsGISBaseReference = b.idfsCountry;

	END

END

GO

CREATE TRIGGER [dbo].[TR_gisCountry_A_Update] ON [dbo].[gisCountry]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsCountry))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Countries', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisCountry';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisCountry', @level2type = N'COLUMN', @level2name = N'idfsCountry';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Country HASC code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisCountry', @level2type = N'COLUMN', @level2name = N'strHASC';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisCountry', @level2type = N'COLUMN', @level2name = N'strCode';

