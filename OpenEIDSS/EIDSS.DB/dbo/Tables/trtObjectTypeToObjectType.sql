CREATE TABLE [dbo].[trtObjectTypeToObjectType] (
    [idfsParentObjectType]  BIGINT           NOT NULL,
    [idfsRelatedObjectType] BIGINT           NOT NULL,
    [idfsStatus]            BIGINT           NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__2018] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtObjectTypeToObjectType] PRIMARY KEY CLUSTERED ([idfsParentObjectType] ASC, [idfsRelatedObjectType] ASC),
    CONSTRAINT [FK_trtObjectTypeToObjectType_trtBaseReference__idfsParentObjectType_R_1621] FOREIGN KEY ([idfsParentObjectType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtObjectTypeToObjectType_trtBaseReference__idfsRelatedObjectType_R_1622] FOREIGN KEY ([idfsRelatedObjectType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtObjectTypeToObjectType_trtBaseReference__idfsStatus_R_1623] FOREIGN KEY ([idfsStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtObjectTypeToObjectType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtObjectTypeToObjectType_A_Update] ON [dbo].[trtObjectTypeToObjectType]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfsParentObjectType]) OR UPDATE([idfsRelatedObjectType])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Links between object types', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtObjectTypeToObjectType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parent object type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtObjectTypeToObjectType', @level2type = N'COLUMN', @level2name = N'idfsParentObjectType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Child object type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtObjectTypeToObjectType', @level2type = N'COLUMN', @level2name = N'idfsRelatedObjectType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Status identifier ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtObjectTypeToObjectType', @level2type = N'COLUMN', @level2name = N'idfsStatus';

