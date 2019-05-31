CREATE TABLE [dbo].[UserAccess] (
    [UserAccessUID]             BIGINT           NOT NULL,
    [UserEmployeeID]            BIGINT           NOT NULL,
    [OnSite]                    BIGINT           NULL,
    [SystemFunctionID]          BIGINT           NOT NULL,
    [SystemFunctionOperationID] BIGINT           NULL,
    [AccessPermissionID]        BIGINT           NULL,
    [intRowStatus]              INT              CONSTRAINT [Def_UserAccess_intRowStatus] DEFAULT ((0)) NULL,
    [AuditCreateUser]           VARCHAR (100)    NOT NULL,
    [AuditCreateDTM]            DATETIME         CONSTRAINT [DF__UserAcces__Audit__7253FA03] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]           VARCHAR (100)    NULL,
    [AuditUpdateDTM]            DATETIME         NULL,
    [rowguid]                   UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKUserAccessUID] PRIMARY KEY CLUSTERED ([UserAccessUID] ASC),
    CONSTRAINT [FK_UserAccess_BaseRef_AccessPermission] FOREIGN KEY ([AccessPermissionID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_UserAccess_BaseRef_SysFunctionID] FOREIGN KEY ([SystemFunctionID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_UserAccess_BaseReference_OperaionID] FOREIGN KEY ([SystemFunctionOperationID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_UserAccess_tlbEmployee_EmpID] FOREIGN KEY ([UserEmployeeID]) REFERENCES [dbo].[tlbEmployee] ([idfEmployee]),
    CONSTRAINT [FK_UserAccess_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_UserAccess_tstSite_OnSite] FOREIGN KEY ([OnSite]) REFERENCES [dbo].[tstSite] ([idfsSite]),
    CONSTRAINT [XAK1UserAccessUID] UNIQUE NONCLUSTERED ([UserEmployeeID] ASC, [SystemFunctionID] ASC, [SystemFunctionOperationID] ASC, [AccessPermissionID] ASC, [intRowStatus] ASC, [OnSite] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_UserAccess_A_Update] ON [dbo].[UserAccess]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([UserAccessUID]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
