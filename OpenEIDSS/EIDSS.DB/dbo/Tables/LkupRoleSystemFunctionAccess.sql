CREATE TABLE [dbo].[LkupRoleSystemFunctionAccess] (
    [RoleID]                    BIGINT           NOT NULL,
    [SystemFunctionID]          BIGINT           NOT NULL,
    [SystemFunctionOperationID] BIGINT           NOT NULL,
    [intRowStatus]              INT              CONSTRAINT [DF__LkupRoleS__intRo__476843A7] DEFAULT ((0)) NOT NULL,
    [AuditCreateUser]           VARCHAR (100)    NOT NULL,
    [AuditCreateDTM]            DATETIME         CONSTRAINT [DF__LkupRoleS__Audit__485C67E0] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]           VARCHAR (100)    NULL,
    [AuditUpdateDTM]            DATETIME         NULL,
    [AccessPermissionID]        BIGINT           NULL,
    [rowguid]                   UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKDefaultRoleAccess] PRIMARY KEY CLUSTERED ([RoleID] ASC, [SystemFunctionID] ASC, [SystemFunctionOperationID] ASC),
    CONSTRAINT [FK_lkupRoleSysFunctionAccess_BaseReference_RoleID] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_lkupRoleSysFunctionAccess_BaseReference_SysFunctionOperationID] FOREIGN KEY ([SystemFunctionOperationID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_lkupRoleSysFunctionAccess_BaseReference_SystemFunction] FOREIGN KEY ([SystemFunctionID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_lkupRoleSysFunctionAccess_trtBaseRef_AccessPermissionID] FOREIGN KEY ([AccessPermissionID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_LkupRoleSystemFunctionAccess_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_LkupRoleSystemFunctionAccess_I_Delete] on [dbo].[LkupRoleSystemFunctionAccess]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([RoleID], [SystemFunctionID], [SystemFunctionOperationID]) as
		(
			SELECT [RoleID], [SystemFunctionID], [SystemFunctionOperationID] FROM deleted
			EXCEPT
			SELECT [RoleID], [SystemFunctionID], [SystemFunctionOperationID] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			AuditUpdateUser = SYSTEM_USER,
			AuditUpdateDTM = GETDATE()
		FROM dbo.[LkupRoleSystemFunctionAccess] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[RoleID] = b.[RoleID]
			AND a.[SystemFunctionID] = b.[SystemFunctionID]
			AND a.[SystemFunctionOperationID] = b.[SystemFunctionOperationID];

	END

END

GO

CREATE TRIGGER [dbo].[TR_LkupRoleSystemFunctionAccess_A_Update] ON [dbo].[LkupRoleSystemFunctionAccess]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(SystemFunctionID) OR UPDATE(SystemFunctionOperationID) OR UPDATE(RoleID)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
