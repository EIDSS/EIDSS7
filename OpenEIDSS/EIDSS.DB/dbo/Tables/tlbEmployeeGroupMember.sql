CREATE TABLE [dbo].[tlbEmployeeGroupMember] (
    [idfEmployeeGroup]     BIGINT           NOT NULL,
    [idfEmployee]          BIGINT           NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1995] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1998] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tlbEmployeeGroupMember] PRIMARY KEY CLUSTERED ([idfEmployeeGroup] ASC, [idfEmployee] ASC),
    CONSTRAINT [FK_tlbEmployeeGroupMember_tlbEmployee__idfEmployee_R_1668] FOREIGN KEY ([idfEmployee]) REFERENCES [dbo].[tlbEmployee] ([idfEmployee]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbEmployeeGroupMember_tlbEmployeeGroup__idfEmployeeGroup_R_1465] FOREIGN KEY ([idfEmployeeGroup]) REFERENCES [dbo].[tlbEmployeeGroup] ([idfEmployeeGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbEmployeeGroupMember_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tlbEmployeeGroupMember_A_Update] ON [dbo].[tlbEmployeeGroupMember]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfEmployee) OR UPDATE(idfEmployeeGroup)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbEmployeeGroupMember_I_Delete] on [dbo].[tlbEmployeeGroupMember]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfEmployee], [idfEmployeeGroup]) as
		(
			SELECT [idfEmployee], [idfEmployeeGroup] FROM deleted
			EXCEPT
			SELECT [idfEmployee], [idfEmployeeGroup] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbEmployeeGroupMember as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfEmployee = b.idfEmployee
			AND a.idfEmployeeGroup = b.idfEmployeeGroup;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Employee Group Members', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbEmployeeGroupMember';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Group identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbEmployeeGroupMember', @level2type = N'COLUMN', @level2name = N'idfEmployeeGroup';

