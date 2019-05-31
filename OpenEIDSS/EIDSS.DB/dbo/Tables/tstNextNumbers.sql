CREATE TABLE [dbo].[tstNextNumbers] (
    [idfsNumberName]          BIGINT           NOT NULL,
    [strDocumentName]         NVARCHAR (200)   NULL,
    [strPrefix]               NVARCHAR (50)    NULL,
    [strSuffix]               NVARCHAR (50)    NULL,
    [intYear]                 INT              NULL,
    [intNumberValue]          BIGINT           NULL,
    [intMinNumberLength]      INT              NULL,
    [blnUsePrefix]            BIT              CONSTRAINT [Def_0___2721] DEFAULT ((0)) NULL,
    [blnUseSiteID]            BIT              CONSTRAINT [Def_0___2722] DEFAULT ((0)) NULL,
    [blnUseYear]              BIT              CONSTRAINT [Def_0___2723] DEFAULT ((0)) NULL,
    [blnUseHACSCodeSite]      BIT              CONSTRAINT [Def_0___2728] DEFAULT ((0)) NULL,
    [blnUseAlphaNumericValue] BIT              CONSTRAINT [Def_0___2729] DEFAULT ((0)) NULL,
    [rowguid]                 UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstNextNumbers] PRIMARY KEY CLUSTERED ([idfsNumberName] ASC),
    CONSTRAINT [FK_tstNextNumbers_trtBaseReference__idfsNumberName_R_930] FOREIGN KEY ([idfsNumberName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNextNumbers_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tstNextNumbers_A_Update] ON [dbo].[tstNextNumbers]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfsNumberName]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Next ID Creation rules', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Numbering rule identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers', @level2type = N'COLUMN', @level2name = N'idfsNumberName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Document name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers', @level2type = N'COLUMN', @level2name = N'strDocumentName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Prefix', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers', @level2type = N'COLUMN', @level2name = N'strPrefix';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Suffix', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers', @level2type = N'COLUMN', @level2name = N'strSuffix';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Year', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers', @level2type = N'COLUMN', @level2name = N'intYear';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Number value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers', @level2type = N'COLUMN', @level2name = N'intNumberValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Minimum number length', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers', @level2type = N'COLUMN', @level2name = N'intMinNumberLength';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Use prefix (true/false)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers', @level2type = N'COLUMN', @level2name = N'blnUsePrefix';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Use site ID (true/false)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers', @level2type = N'COLUMN', @level2name = N'blnUseSiteID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Use year (true/false)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers', @level2type = N'COLUMN', @level2name = N'blnUseYear';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Use HASC code (true/false)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers', @level2type = N'COLUMN', @level2name = N'blnUseHACSCodeSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Use alphanumeric (true/false)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNextNumbers', @level2type = N'COLUMN', @level2name = N'blnUseAlphaNumericValue';

