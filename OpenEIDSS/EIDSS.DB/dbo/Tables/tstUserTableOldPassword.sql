CREATE TABLE [dbo].[tstUserTableOldPassword] (
    [idfUserOldPassword]   BIGINT           NOT NULL,
    [idfUserID]            BIGINT           NOT NULL,
    [datExpiredDate]       DATETIME         NULL,
    [binOldPassword]       VARBINARY (50)   NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2630] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2506] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstUserTableOldPassword] PRIMARY KEY CLUSTERED ([idfUserOldPassword] ASC),
    CONSTRAINT [FK_tstUserTableOldPassword_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstUserTableOldPassword_tstUserTable__idfUserID_R_1730] FOREIGN KEY ([idfUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstUserTableOldPassword_A_Update] ON [dbo].[tstUserTableOldPassword]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF dbo.FN_GBL_TriggersWork ()=1 
	BEGIN
		IF UPDATE(idfUserOldPassword)
		BEGIN
			RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
			ROLLBACK TRANSACTION
		END

	END

END

GO

CREATE TRIGGER [dbo].[TR_tstUserTableOldPassword_I_Delete] ON [dbo].[tstUserTableOldPassword]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		-- Perform logical delete instead of physical delete
		WITH cteOnlyDeletedRecords([idfUserOldPassword]) as
		(
			SELECT [idfUserOldPassword] FROM deleted
			EXCEPT
			SELECT [idfUserOldPassword] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tstUserTableOldPassword as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfUserOldPassword = b.idfUserOldPassword;

	END

END
