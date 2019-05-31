CREATE TABLE [dbo].[trtHACodeList] (
    [intHACode]            BIGINT           NOT NULL,
    [idfsCodeName]         BIGINT           NULL,
    [strNote]              NVARCHAR (200)   NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2014] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtHACodeList] PRIMARY KEY CLUSTERED ([intHACode] ASC),
    CONSTRAINT [FK_trtHACodeList_trtBaseReference__idfsCodeName_R_674] FOREIGN KEY ([idfsCodeName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtHACodeList_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtHACodeList_A_Update] ON [dbo].[trtHACodeList]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(intHACode))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtHACodeList_I_Delete] on [dbo].[trtHACodeList]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([intHACode]) as
		(
			SELECT [intHACode] FROM deleted
			EXCEPT
			SELECT [intHACode] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtHACodeList as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.intHACode = b.intHACode;

	END

END
