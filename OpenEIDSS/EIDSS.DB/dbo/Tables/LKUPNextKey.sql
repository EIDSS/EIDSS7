CREATE TABLE [dbo].[LKUPNextKey] (
    [TableName]            VARCHAR (500)    NOT NULL,
    [LastUsedKey]          BIGINT           NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_LkupNextKey_intRowStatus] DEFAULT ((0)) NOT NULL,
    [AuditCreateUser]      VARCHAR (100)    CONSTRAINT [DF__LkupNextK__Audit__355EA205] DEFAULT (user_name()) NOT NULL,
    [AuditCreateDTM]       DATETIME         CONSTRAINT [DF__LkupNextK__Audit__3652C63E] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]      VARCHAR (100)    CONSTRAINT [DF__LkupNextK__Audit__3746EA77] DEFAULT (user_name()) NOT NULL,
    [AuditUpdateDTM]       DATETIME         CONSTRAINT [DF__LkupNextK__Audit__383B0EB0] DEFAULT (getdate()) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [LkupNextKey_Tablename] PRIMARY KEY CLUSTERED ([TableName] ASC),
    CONSTRAINT [FK_LKUPNextKey_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_LKUPNextKey_A_Update] ON [dbo].[LKUPNextKey]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(TableName))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_LkupNextKey_I_Delete] on [dbo].[LkupNextKey]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([TableName]) as
		(
			SELECT [TableName] FROM deleted
			EXCEPT
			SELECT [TableName] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			AuditUpdateUser = SYSTEM_USER,
			AuditUpdateDTM = GETDATE()
		FROM dbo.[LkupNextKey] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[TableName] = b.[TableName];

	END

END
