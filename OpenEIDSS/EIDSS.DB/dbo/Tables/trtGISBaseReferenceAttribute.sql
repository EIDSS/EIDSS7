CREATE TABLE [dbo].[trtGISBaseReferenceAttribute] (
    [idfGISBaseReferenceAttribute] BIGINT           NOT NULL,
    [idfsGISBaseReference]         BIGINT           NOT NULL,
    [idfAttributeType]             BIGINT           NOT NULL,
    [varValue]                     SQL_VARIANT      NULL,
    [rowguid]                      UNIQUEIDENTIFIER CONSTRAINT [trtGISBaseReferenceAttribute__newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]           NVARCHAR (20)    NULL,
    [strReservedAttribute]         NVARCHAR (MAX)   NULL,
    [strAttributeItem]             NVARCHAR (2000)  NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtGISBaseReferenceAttribute] PRIMARY KEY CLUSTERED ([idfGISBaseReferenceAttribute] ASC),
    CONSTRAINT [FK_trtGISBaseReferenceAttribute_gisBaseReference__idfsGISBaseReference] FOREIGN KEY ([idfsGISBaseReference]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtGISBaseReferenceAttribute_trtAttributeType__idfAttributeType] FOREIGN KEY ([idfAttributeType]) REFERENCES [dbo].[trtAttributeType] ([idfAttributeType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtGISBaseReferenceAttribute_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtGISBaseReferenceAttribute_A_Update] ON [dbo].[trtGISBaseReferenceAttribute]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfGISBaseReferenceAttribute]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
