CREATE TABLE [dbo].[tasSearchFieldsWithRelatedValues] (
    [idfSearchFieldsWithRelatedValues] BIGINT           NOT NULL,
    [idfsSearchField]                  BIGINT           NOT NULL,
    [idfsRelatedSearchField]           BIGINT           NOT NULL,
    [strLookupAttribute]               VARCHAR (200)    NOT NULL,
    [rowguid]                          UNIQUEIDENTIFIER CONSTRAINT [newid__tasSearchFieldsWithRelatedValues] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strReservedAttribute]             NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]               BIGINT           NULL,
    [SourceSystemKeyValue]             NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasSearchFieldsWithRelatedValues] PRIMARY KEY CLUSTERED ([idfSearchFieldsWithRelatedValues] ASC),
    CONSTRAINT [FK_tasSearchFieldsWithRelatedValues_tasSearchField__idfsRelatedSearchField] FOREIGN KEY ([idfsRelatedSearchField]) REFERENCES [dbo].[tasSearchField] ([idfsSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchFieldsWithRelatedValues_tasSearchField__idfsSearchField] FOREIGN KEY ([idfsSearchField]) REFERENCES [dbo].[tasSearchField] ([idfsSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchFieldsWithRelatedValues_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [UK_tasSearchFieldsWithRelatedValues__idfsSearchField_idfsRelatedSearchField] UNIQUE NONCLUSTERED ([idfsSearchField] ASC, [idfsRelatedSearchField] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_tasSearchFieldsWithRelatedValues_A_Update] ON [dbo].[tasSearchFieldsWithRelatedValues]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSearchFieldsWithRelatedValues))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
