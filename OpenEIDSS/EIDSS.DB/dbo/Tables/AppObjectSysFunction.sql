CREATE TABLE [dbo].[AppObjectSysFunction] (
    [AppObjectNameID]      BIGINT           NOT NULL,
    [SystemFunctionID]     BIGINT           NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_AppObjectSysFunction_intRowStatus] DEFAULT ((0)) NULL,
    [AuditCreateUser]      VARCHAR (100)    CONSTRAINT [DF__AppObject__Audit__00D72384] DEFAULT ('SYSTEM') NOT NULL,
    [AuditCreateDTM]       DATETIME         CONSTRAINT [DF__AppObject__Audit__01CB47BD] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]      VARCHAR (100)    NULL,
    [AuditUpdateDTM]       DATETIME         NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKAppObjectSystemFunction] PRIMARY KEY CLUSTERED ([AppObjectNameID] ASC, [SystemFunctionID] ASC),
    CONSTRAINT [FK_AppObjectSysFunction_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_AppObjSysFunction_AppObj_AppObjectNameID] FOREIGN KEY ([AppObjectNameID]) REFERENCES [dbo].[LkupEIDSSAppObject] ([AppObjectNameID]),
    CONSTRAINT [FK_AppObjSysFunction_BaseReference_SysFunctionID] FOREIGN KEY ([SystemFunctionID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_AppObjectSysFunction_A_Update] ON [dbo].[AppObjectSysFunction]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE(AppObjectNameID) OR UPDATE(SystemFunctionID)))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO


CREATE TRIGGER [dbo].[TR_AppObjectSysFunction_I_Delete] on [dbo].[AppObjectSysFunction]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([AppObjectNameID], [SystemFunctionID]) as
		(
			SELECT [AppObjectNameID], [SystemFunctionID] FROM deleted
			EXCEPT
			SELECT [AppObjectNameID], [SystemFunctionID] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			AuditUpdateUser = SYSTEM_USER,
			AuditUpdateDTM = GETDATE()
		FROM dbo.AppObjectSysFunction as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.AppObjectNameID = b.AppObjectNameID
			AND a.SystemFunctionID = b.SystemFunctionID;

	END

END
