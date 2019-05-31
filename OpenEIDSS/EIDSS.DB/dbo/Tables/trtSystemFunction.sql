CREATE TABLE [dbo].[trtSystemFunction] (
    [idfsSystemFunction]   BIGINT           NOT NULL,
    [idfsObjectType]       BIGINT           NULL,
    [intNumber]            INT              NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2023] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtSystemFunction] PRIMARY KEY CLUSTERED ([idfsSystemFunction] ASC),
    CONSTRAINT [FK_trtSystemFunction_trtBaseReference__idfsObjectType_R_1581] FOREIGN KEY ([idfsObjectType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSystemFunction_trtBaseReference__idfsSystemFunction_R_1038] FOREIGN KEY ([idfsSystemFunction]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSystemFunction_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_trtSystemFunction_I_Delete] on [dbo].[trtSystemFunction]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([idfsSystemFunction]) as
		(
			SELECT [idfsSystemFunction] FROM deleted
			EXCEPT
			SELECT [idfsSystemFunction] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtSystemFunction as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfsSystemFunction = b.idfsSystemFunction;

	
		WITH cteOnlyDeletedRows([idfsSystemFunction]) as
		(
			SELECT [idfsSystemFunction] FROM deleted
			EXCEPT
			SELECT [idfsSystemFunction] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfsBaseReference = b.idfsSystemFunction;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtSystemFunction_A_Update] ON [dbo].[trtSystemFunction]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsSystemFunction))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
