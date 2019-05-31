CREATE TABLE [dbo].[tasSearchFieldToPersonalDataGroup] (
    [idfsSearchField]      BIGINT           NOT NULL,
    [idfPersonalDataGroup] BIGINT           NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid_tasSearchFieldToPersonalDataGroup] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasSearchFieldToPersonalDataGroup] PRIMARY KEY CLUSTERED ([idfsSearchField] ASC, [idfPersonalDataGroup] ASC),
    CONSTRAINT [FK_tasSearchFieldToPersonalDataGroup_tasSearchField_idfsSearchField] FOREIGN KEY ([idfsSearchField]) REFERENCES [dbo].[tasSearchField] ([idfsSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchFieldToPersonalDataGroup_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tasSearchFieldToPersonalDataGroup_tstPersonalDataGroup_idfPersonalDataGroup] FOREIGN KEY ([idfPersonalDataGroup]) REFERENCES [dbo].[tstPersonalDataGroup] ([idfPersonalDataGroup]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tasSearchFieldToPersonalDataGroup_A_Update] ON [dbo].[tasSearchFieldToPersonalDataGroup]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsSearchField) OR UPDATE(idfPersonalDataGroup)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
