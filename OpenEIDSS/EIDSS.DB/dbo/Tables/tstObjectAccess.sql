CREATE TABLE [dbo].[tstObjectAccess] (
    [idfObjectAccess]      BIGINT           NOT NULL,
    [idfsObjectOperation]  BIGINT           NULL,
    [idfsObjectType]       BIGINT           NULL,
    [idfsObjectID]         BIGINT           NULL,
    [idfActor]             BIGINT           NOT NULL,
    [idfsOnSite]           BIGINT           NULL,
    [intPermission]        INT              NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2029] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2033] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstObjectAccess] PRIMARY KEY CLUSTERED ([idfObjectAccess] ASC),
    CONSTRAINT [FK_tstObjectAccess_tlbEmployee__idfActor_R_1618] FOREIGN KEY ([idfActor]) REFERENCES [dbo].[tlbEmployee] ([idfEmployee]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstObjectAccess_trtBaseReference__idfsObjectOperation_R_1586] FOREIGN KEY ([idfsObjectOperation]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstObjectAccess_trtBaseReference__idfsObjectType_R_1580] FOREIGN KEY ([idfsObjectType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstObjectAccess_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstObjectAccess_tstSite__idfsOnSite_R_951] FOREIGN KEY ([idfsOnSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_tstObjectAccess_idfsOnSiteidfActor]
    ON [dbo].[tstObjectAccess]([idfActor] ASC, [idfsOnSite] ASC);


GO



CREATE TRIGGER [dbo].[TR_tstObjectAccess_I_Delete] on [dbo].[tstObjectAccess]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfObjectAccess]) as
		(
			SELECT [idfObjectAccess] FROM deleted
			EXCEPT
			SELECT [idfObjectAccess] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tstObjectAccess as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfObjectAccess = b.idfObjectAccess;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tstObjectAccess_A_Update] ON [dbo].[tstObjectAccess]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF dbo.FN_GBL_TriggersWork ()=1 
	BEGIN
		IF UPDATE(idfObjectAccess)
		BEGIN
			RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
			ROLLBACK TRANSACTION
		END

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Object access', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstObjectAccess';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Object Operation identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstObjectAccess', @level2type = N'COLUMN', @level2name = N'idfsObjectOperation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Object Type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstObjectAccess', @level2type = N'COLUMN', @level2name = N'idfsObjectType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Object identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstObjectAccess', @level2type = N'COLUMN', @level2name = N'idfsObjectID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Actor identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstObjectAccess', @level2type = N'COLUMN', @level2name = N'idfActor';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstObjectAccess', @level2type = N'COLUMN', @level2name = N'idfsOnSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Permission (0/1)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstObjectAccess', @level2type = N'COLUMN', @level2name = N'intPermission';

