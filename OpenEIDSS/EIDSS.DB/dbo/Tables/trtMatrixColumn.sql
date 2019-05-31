CREATE TABLE [dbo].[trtMatrixColumn] (
    [idfsMatrixColumn]     BIGINT           NOT NULL,
    [idfsMatrixType]       BIGINT           NOT NULL,
    [intColumnOrder]       INT              CONSTRAINT [Def_0_trtMatrixColumn_intColumnOrder] DEFAULT ((0)) NOT NULL,
    [intWidth]             INT              CONSTRAINT [Def_0_trtMatrixColumn_intWidth] DEFAULT ((0)) NOT NULL,
    [idfsParameterType]    BIGINT           NOT NULL,
    [idfsEditor]           BIGINT           NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_trtMatrixColumn_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__trtMatrixColumn] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtMatrixColumn] PRIMARY KEY CLUSTERED ([idfsMatrixColumn] ASC),
    CONSTRAINT [FK_trtMatrixColumn_trtBaseReference__idfsEditor] FOREIGN KEY ([idfsEditor]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtMatrixColumn_trtBaseReference__idfsMatrixColumn] FOREIGN KEY ([idfsMatrixColumn]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtMatrixColumn_trtBaseReference__idfsParameterType] FOREIGN KEY ([idfsParameterType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtMatrixColumn_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtMatrixColumn_trtMatrixType__idfsMatrixType] FOREIGN KEY ([idfsMatrixType]) REFERENCES [dbo].[trtMatrixType] ([idfsMatrixType]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtMatrixColumn_A_Update] ON [dbo].[trtMatrixColumn]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfsMatrixColumn]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
