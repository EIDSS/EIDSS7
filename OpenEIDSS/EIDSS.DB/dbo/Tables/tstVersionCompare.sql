CREATE TABLE [dbo].[tstVersionCompare] (
    [strModuleName]        VARCHAR (50)     NOT NULL,
    [strModuleVersion]     VARCHAR (50)     NOT NULL,
    [strDatabaseVersion]   VARCHAR (50)     NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2036] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstVersionCompare] PRIMARY KEY CLUSTERED ([strModuleName] ASC, [strModuleVersion] ASC, [strDatabaseVersion] ASC),
    CONSTRAINT [FK_tstVersionCompare_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tstVersionCompare_A_Update] ON [dbo].[tstVersionCompare]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([strModuleName]) OR UPDATE([strModuleVersion]) OR UPDATE([strDatabaseVersion])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Valid Version pairs (db/client)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstVersionCompare';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Module name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstVersionCompare', @level2type = N'COLUMN', @level2name = N'strModuleName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Module version', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstVersionCompare', @level2type = N'COLUMN', @level2name = N'strModuleVersion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Database version', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstVersionCompare', @level2type = N'COLUMN', @level2name = N'strDatabaseVersion';

