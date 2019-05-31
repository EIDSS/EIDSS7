CREATE TABLE [dbo].[trtMatrixType] (
    [idfsMatrixType]       BIGINT           NOT NULL,
    [idfsFormType]         BIGINT           NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_trtMatrixType_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__trtMatrixType] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtMatrixType] PRIMARY KEY CLUSTERED ([idfsMatrixType] ASC),
    CONSTRAINT [FK_trtMatrixType_trtBaseReference__idfsFormType] FOREIGN KEY ([idfsFormType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtMatrixType_trtBaseReference__idfsMatrixType] FOREIGN KEY ([idfsMatrixType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtMatrixType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtMatrixType_A_Update] ON [dbo].[trtMatrixType]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfsMatrixType]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
