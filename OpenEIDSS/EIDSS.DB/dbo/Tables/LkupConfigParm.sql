CREATE TABLE [dbo].[LkupConfigParm] (
    [ConfigParmNameID]     BIGINT           NOT NULL,
    [ConfigParmValue]      VARCHAR (MAX)    NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_LkupConfigParm_intRowStatus] DEFAULT ((0)) NOT NULL,
    [AuditCreateUser]      VARCHAR (100)    CONSTRAINT [DF__LkupConfi__Audit__302643F3] DEFAULT (user_name()) NOT NULL,
    [AuditCreateDTM]       DATETIME         CONSTRAINT [DF__LkupConfi__Audit__311A682C] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]      VARCHAR (100)    CONSTRAINT [DF__LkupConfi__Audit__320E8C65] DEFAULT (user_name()) NOT NULL,
    [AuditUpdateDTM]       DATETIME         CONSTRAINT [DF__LkupConfi__Audit__3302B09E] DEFAULT (getdate()) NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKLkupConfigParm] PRIMARY KEY CLUSTERED ([ConfigParmNameID] ASC),
    CONSTRAINT [FK_LkupConfigParm_trtBaseReference_idfsBaseReference] FOREIGN KEY ([ConfigParmNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_LkupConfigParm_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_LkupConfigParm_A_Update] ON [dbo].[LkupConfigParm]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(ConfigParmNameID))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_LkupConfigParm_I_Delete] on [dbo].[LkupConfigParm]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([ConfigParmNameID]) as
		(
			SELECT [ConfigParmNameID] FROM deleted
			EXCEPT
			SELECT [ConfigParmNameID] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			AuditUpdateUser = SYSTEM_USER,
			AuditUpdateDTM = GETDATE()
		FROM dbo.[LkupConfigParm] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[ConfigParmNameID] = b.[ConfigParmNameID];


		WITH cteOnlyDeletedRows([ConfigParmNameID]) as
		(
			SELECT [ConfigParmNameID] FROM deleted
			EXCEPT
			SELECT [ConfigParmNameID] FROM inserted
		)

		DELETE a
		FROM dbo.[trtBaseReference] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[idfsBaseReference] = b.[ConfigParmNameID];

	END

END
