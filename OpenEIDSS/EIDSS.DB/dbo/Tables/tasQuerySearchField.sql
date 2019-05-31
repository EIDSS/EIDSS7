CREATE TABLE [dbo].[tasQuerySearchField] (
    [idfQuerySearchField]  BIGINT           NOT NULL,
    [idfQuerySearchObject] BIGINT           NOT NULL,
    [blnShow]              BIT              CONSTRAINT [Def_0___2709] DEFAULT ((0)) NULL,
    [idfsSearchField]      BIGINT           NOT NULL,
    [idfsParameter]        BIGINT           NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasQuerySearchField] PRIMARY KEY CLUSTERED ([idfQuerySearchField] ASC),
    CONSTRAINT [FK_tasQuerySearchField_ffParameter__idfsParameter_R_1353] FOREIGN KEY ([idfsParameter]) REFERENCES [dbo].[ffParameter] ([idfsParameter]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasQuerySearchField_tasQuerySearchObject__idfQuerySearchObject_R_1351] FOREIGN KEY ([idfQuerySearchObject]) REFERENCES [dbo].[tasQuerySearchObject] ([idfQuerySearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasQuerySearchField_tasSearchFieldList__idfsSearchField_R_1352] FOREIGN KEY ([idfsSearchField]) REFERENCES [dbo].[tasSearchField] ([idfsSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasQuerySearchField_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasQuerySearchField_A_Update] ON [dbo].[tasQuerySearchField]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfQuerySearchField))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Query Search Fields', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tasQuerySearchField';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Field identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tasQuerySearchField', @level2type = N'COLUMN', @level2name = N'idfsSearchField';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Flex-form parameter identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tasQuerySearchField', @level2type = N'COLUMN', @level2name = N'idfsParameter';

