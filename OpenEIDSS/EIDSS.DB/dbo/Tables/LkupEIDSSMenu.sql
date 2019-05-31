CREATE TABLE [dbo].[LkupEIDSSMenu] (
    [EIDSSMenuID]          BIGINT           NOT NULL,
    [EIDSSParentMenuID]    BIGINT           NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_LkupEIDSSMenu_intRowStatus] DEFAULT ((0)) NULL,
    [AuditCreateUser]      VARCHAR (100)    CONSTRAINT [DF__LkupEIDSS__Audit__2FC71C97] DEFAULT ('SYSTEM') NOT NULL,
    [AuditCreateDTM]       DATETIME         CONSTRAINT [DF__LkupEIDSS__Audit__30BB40D0] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]      VARCHAR (100)    NULL,
    [AuditUpdateDTM]       DATETIME         NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKLkupEIDSSMenu] PRIMARY KEY CLUSTERED ([EIDSSMenuID] ASC),
    CONSTRAINT [FK_LkupEIDSSMenu_BaseRef_MenuID] FOREIGN KEY ([EIDSSMenuID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_LkupEIDSSMenu_BaseRef_ParentMenuID] FOREIGN KEY ([EIDSSParentMenuID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_LkupEIDSSMenu_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_LkupEIDSSMenu_I_Delete] on [dbo].[LkupEIDSSMenu]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([EIDSSMenuID]) as
		(
			SELECT [EIDSSMenuID] FROM deleted
			EXCEPT
			SELECT [EIDSSMenuID] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			AuditUpdateUser = SYSTEM_USER,
			AuditUpdateDTM = GETDATE()
		FROM dbo.[LkupEIDSSMenu] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[EIDSSMenuID] = b.[EIDSSMenuID];


		WITH cteOnlyDeletedRows([EIDSSMenuID]) as
		(
			SELECT [EIDSSMenuID] FROM deleted
			EXCEPT
			SELECT [EIDSSMenuID] FROM inserted
		)

		DELETE a
		FROM dbo.[trtBaseReference] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[idfsBaseReference] = b.[EIDSSMenuID];

	END

END

GO

CREATE TRIGGER [dbo].[TR_LkupEIDSSMenu_A_Update] ON [dbo].[LkupEIDSSMenu]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(EIDSSMenuID))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
