CREATE TABLE [dbo].[trtReferenceType] (
    [idfsReferenceType]    BIGINT           NOT NULL,
    [strReferenceTypeCode] NVARCHAR (36)    NULL,
    [strReferenceTypeName] NVARCHAR (200)   NULL,
    [intStandard]          INT              NOT NULL,
    [idfMinID]             BIGINT           NOT NULL,
    [idfMaxID]             BIGINT           NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1910] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              DEFAULT ((0)) NOT NULL,
    [intHACodeMask]        BIGINT           NULL,
    [intDefaultHACode]     BIGINT           NULL,
    [strEditorName]        NVARCHAR (100)   NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtReferenceType] PRIMARY KEY CLUSTERED ([idfsReferenceType] ASC),
    CONSTRAINT [FK_trtReferenceType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_trtReferenceType_I_Delete] on [dbo].[trtReferenceType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN
		
		WITH cteOnlyDeletedRecords([idfsReferenceType]) as
		(
			SELECT [idfsReferenceType] FROM deleted
			EXCEPT
			SELECT [idfsReferenceType] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtReferenceType as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsReferenceType = b.idfsReferenceType;


		WITH cteOnlyDeletedRecords([idfsReferenceType]) as
		(
			SELECT [idfsReferenceType] FROM deleted
			EXCEPT
			SELECT [idfsReferenceType] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsReferenceType;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtReferenceType_A_Update] ON [dbo].[trtReferenceType]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfsReferenceType]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Reference types', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtReferenceType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Reference type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtReferenceType', @level2type = N'COLUMN', @level2name = N'idfsReferenceType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Reference type code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtReferenceType', @level2type = N'COLUMN', @level2name = N'strReferenceTypeCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Reference type name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtReferenceType', @level2type = N'COLUMN', @level2name = N'strReferenceTypeName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Minimum identifier value reserved ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtReferenceType', @level2type = N'COLUMN', @level2name = N'idfMinID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Maximum identifier value reserved ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtReferenceType', @level2type = N'COLUMN', @level2name = N'idfMaxID';

