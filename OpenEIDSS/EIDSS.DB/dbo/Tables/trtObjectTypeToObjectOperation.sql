CREATE TABLE [dbo].[trtObjectTypeToObjectOperation] (
    [idfsObjectType]       BIGINT           NOT NULL,
    [idfsObjectOperation]  BIGINT           NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2017] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtObjectTypeToObjectOperation] PRIMARY KEY CLUSTERED ([idfsObjectType] ASC, [idfsObjectOperation] ASC),
    CONSTRAINT [FK_trtObjectTypeToObjectOperation_trtBaseReference__idfsObjectOperation_R_1620] FOREIGN KEY ([idfsObjectOperation]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtObjectTypeToObjectOperation_trtBaseReference__idfsObjectType_R_1619] FOREIGN KEY ([idfsObjectType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtObjectTypeToObjectOperation_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtObjectTypeToObjectOperation_A_Update] ON [dbo].[trtObjectTypeToObjectOperation]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfsObjectType]) OR UPDATE([idfsObjectOperation])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Links between object type and available operation', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtObjectTypeToObjectOperation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Object Type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtObjectTypeToObjectOperation', @level2type = N'COLUMN', @level2name = N'idfsObjectType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Object Operation identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtObjectTypeToObjectOperation', @level2type = N'COLUMN', @level2name = N'idfsObjectOperation';

