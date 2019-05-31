CREATE TABLE [dbo].[tlbFreezerSubdivision] (
    [idfSubdivision]       BIGINT           NOT NULL,
    [idfsSubdivisionType]  BIGINT           NULL,
    [idfFreezer]           BIGINT           NOT NULL,
    [idfParentSubdivision] BIGINT           NULL,
    [idfsSite]             BIGINT           CONSTRAINT [Def_fnSiteID_tlbFreezerSubdivision] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [strBarcode]           NVARCHAR (200)   NULL,
    [strNameChars]         NVARCHAR (200)   NULL,
    [strNote]              NVARCHAR (200)   NULL,
    [intCapacity]          INT              NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1971] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1975] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [BoxSizeID]            BIGINT           NULL,
    [BoxPlaceAvailability] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbFreezerSubdivision] PRIMARY KEY CLUSTERED ([idfSubdivision] ASC),
    CONSTRAINT [FK_FreezerSubdivision_BaseRef_BoxSizeID] FOREIGN KEY ([BoxSizeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbFreezerSubdivision_tlbFreezer__idfFreezer_R_902] FOREIGN KEY ([idfFreezer]) REFERENCES [dbo].[tlbFreezer] ([idfFreezer]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFreezerSubdivision_tlbFreezerSubdivision__idfParentSubdivision_R_904] FOREIGN KEY ([idfParentSubdivision]) REFERENCES [dbo].[tlbFreezerSubdivision] ([idfSubdivision]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFreezerSubdivision_trtBaseReference__idfsSubdivisionType_R_1257] FOREIGN KEY ([idfsSubdivisionType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFreezerSubdivision_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbFreezerSubdivision_tstSite__idfsSite_R_908] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tlbFreezerSubdivision_A_Update] ON [dbo].[tlbFreezerSubdivision]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSubdivision))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbFreezerSubdivision_I_Delete] on [dbo].[tlbFreezerSubdivision]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfSubdivision]) as
		(
			SELECT [idfSubdivision] FROM deleted
			EXCEPT
			SELECT [idfSubdivision] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbFreezerSubdivision as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfSubdivision = b.idfSubdivision;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Freezer Subdivisions', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFreezerSubdivision';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Freezer subdivision type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFreezerSubdivision', @level2type = N'COLUMN', @level2name = N'idfsSubdivisionType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFreezerSubdivision', @level2type = N'COLUMN', @level2name = N'idfsSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Subdivision Barcode (alphanumeric inventory code)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFreezerSubdivision', @level2type = N'COLUMN', @level2name = N'strBarcode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Subdivision name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFreezerSubdivision', @level2type = N'COLUMN', @level2name = N'strNameChars';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Subdivision notes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFreezerSubdivision', @level2type = N'COLUMN', @level2name = N'strNote';

