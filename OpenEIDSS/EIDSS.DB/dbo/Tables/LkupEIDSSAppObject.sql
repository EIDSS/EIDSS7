CREATE TABLE [dbo].[LkupEIDSSAppObject] (
    [AppObjectNameID]      BIGINT           NOT NULL,
    [AppObjectTypeID]      BIGINT           NOT NULL,
    [PageName]             VARCHAR (100)    NULL,
    [RelatedEIDSSMenuID]   BIGINT           NULL,
    [ExceptionControlList] VARCHAR (MAX)    NULL,
    [DisplayOrder]         INT              NULL,
    [IsOpenInNewWindow]    VARCHAR (1)      NULL,
    [AppModuleGroupList]   VARCHAR (100)    NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_LkupEIDSSAppObject_intRowStatus] DEFAULT ((0)) NULL,
    [AuditCreateUser]      VARCHAR (100)    CONSTRAINT [DF__LkupEIDSS__Audit__793601BC] DEFAULT ('SYSTEM') NOT NULL,
    [AuditCreateDTM]       DATETIME         CONSTRAINT [DF__LkupEIDSS__Audit__7A2A25F5] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]      VARCHAR (100)    NULL,
    [AuditUpdateDTM]       DATETIME         NULL,
    [PageLink]             VARCHAR (MAX)    NULL,
    [PageTitleID]          BIGINT           NULL,
    [ObjectImage]          VARBINARY (1)    NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKEIDSS_Menu_Options] PRIMARY KEY CLUSTERED ([AppObjectNameID] ASC),
    CONSTRAINT [FK_AppObj_EIDSSMenu_MenuID] FOREIGN KEY ([RelatedEIDSSMenuID]) REFERENCES [dbo].[LkupEIDSSMenu] ([EIDSSMenuID]),
    CONSTRAINT [FK_AppObj_ObjName] FOREIGN KEY ([AppObjectNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_AppObj_ObjType] FOREIGN KEY ([AppObjectTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_AppObj_PageToolTip] FOREIGN KEY ([PageTitleID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_LkupEIDSSAppObject_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_LkupEIDSSAppObject_A_Update] ON [dbo].[LkupEIDSSAppObject]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(AppObjectNameID))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_LkupEIDSSAppObject_I_Delete] on [dbo].[LkupEIDSSAppObject]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([AppObjectNameID]) as
		(
			SELECT [AppObjectNameID] FROM deleted
			EXCEPT
			SELECT [AppObjectNameID] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			AuditUpdateUser = SYSTEM_USER,
			AuditUpdateDTM = GETDATE()
		FROM dbo.[LkupEIDSSAppObject] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[AppObjectNameID] = b.[AppObjectNameID];


		WITH cteOnlyDeletedRows([AppObjectNameID]) as
		(
			SELECT [AppObjectNameID] FROM deleted
			EXCEPT
			SELECT [AppObjectNameID] FROM inserted
		)

		DELETE a
		FROM dbo.[trtBaseReference] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[idfsBaseReference] = b.[AppObjectNameID];
	END

END
