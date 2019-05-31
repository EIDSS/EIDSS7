CREATE TABLE [dbo].[tasSearchFieldToFFParameter] (
    [idfSearchFieldToFFParameter] BIGINT           NOT NULL,
    [idfsSearchField]             BIGINT           NOT NULL,
    [idfsParameter]               BIGINT           NOT NULL,
    [rowguid]                     UNIQUEIDENTIFIER CONSTRAINT [newid_tasSearchFieldToFFParameter] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strReservedAttribute]        NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]          BIGINT           NULL,
    [SourceSystemKeyValue]        NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasSearchFieldToFFParameter] PRIMARY KEY CLUSTERED ([idfSearchFieldToFFParameter] ASC),
    CONSTRAINT [FK_tasSearchFieldToFFParameter_ffParameter_idfsParameter] FOREIGN KEY ([idfsParameter]) REFERENCES [dbo].[ffParameter] ([idfsParameter]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchFieldToFFParameter_tasSearchField_idfsSearchField] FOREIGN KEY ([idfsSearchField]) REFERENCES [dbo].[tasSearchField] ([idfsSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchFieldToFFParameter_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasSearchFieldToFFParameter_A_Update] ON [dbo].[tasSearchFieldToFFParameter]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSearchFieldToFFParameter))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
