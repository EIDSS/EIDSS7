CREATE TABLE [dbo].[tlbEmployeeGroup] (
    [idfEmployeeGroup]      BIGINT           NOT NULL,
    [idfsEmployeeGroupName] BIGINT           NULL,
    [idfsSite]              BIGINT           CONSTRAINT [Def_fnSiteID_tlbEmployeeGroup] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [strName]               NVARCHAR (200)   NULL,
    [strDescription]        NVARCHAR (200)   NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__1997] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]          INT              DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbEmployeeGroup] PRIMARY KEY CLUSTERED ([idfEmployeeGroup] ASC),
    CONSTRAINT [FK_tlbEmployeeGroup_tlbEmployee__idfEmployeeGroup_R_832] FOREIGN KEY ([idfEmployeeGroup]) REFERENCES [dbo].[tlbEmployee] ([idfEmployee]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbEmployeeGroup_trtBaseReference__idfsEmployeeGroupName_R_1014] FOREIGN KEY ([idfsEmployeeGroupName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbEmployeeGroup_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbEmployeeGroup_tstSite__idfsSite_R_1018] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tlbEmployeeGroup_A_Update] ON [dbo].[tlbEmployeeGroup]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfEmployeeGroup))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbEmployeeGroup_I_Delete] on [dbo].[tlbEmployeeGroup]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfEmployeeGroup]) as
		(
			SELECT [idfEmployeeGroup] FROM deleted
			EXCEPT
			SELECT [idfEmployeeGroup] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbEmployeeGroup as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfEmployeeGroup = b.idfEmployeeGroup;


		WITH cteOnlyDeletedRecords([idfEmployeeGroup]) as
		(
			SELECT [idfEmployeeGroup] FROM deleted
			EXCEPT
			SELECT [idfEmployeeGroup] FROM inserted
		)
		
		DELETE a
		FROM dbo.tlbEmployee as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfEmployee = b.idfEmployeeGroup;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Employee Groups', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbEmployeeGroup';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Group identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbEmployeeGroup', @level2type = N'COLUMN', @level2name = N'idfEmployeeGroup';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Translated Group name identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbEmployeeGroup', @level2type = N'COLUMN', @level2name = N'idfsEmployeeGroupName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbEmployeeGroup', @level2type = N'COLUMN', @level2name = N'idfsSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Group name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbEmployeeGroup', @level2type = N'COLUMN', @level2name = N'strName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Group description', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbEmployeeGroup', @level2type = N'COLUMN', @level2name = N'strDescription';

