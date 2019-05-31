CREATE TABLE [dbo].[ffSection] (
    [idfsSection]          BIGINT           NOT NULL,
    [idfsParentSection]    BIGINT           NULL,
    [idfsFormType]         BIGINT           NOT NULL,
    [intOrder]             INT              CONSTRAINT [Def_0_1896] DEFAULT ((0)) NOT NULL,
    [blnGrid]              BIT              CONSTRAINT [Def_0_1897] DEFAULT ((0)) NOT NULL,
    [blnFixedRowSet]       BIT              CONSTRAINT [Def_0_1898] DEFAULT ((0)) NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1899] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1913] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfsMatrixType]       BIGINT           NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffSection] PRIMARY KEY CLUSTERED ([idfsSection] ASC),
    CONSTRAINT [FK_ffSection_ffSection__idfsParentSection_R_1362] FOREIGN KEY ([idfsParentSection]) REFERENCES [dbo].[ffSection] ([idfsSection]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffSection_trtBaseReference__idfsFormType_R_1659] FOREIGN KEY ([idfsFormType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffSection_trtBaseReference__idfsSection_R_1378] FOREIGN KEY ([idfsSection]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffSection_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_ffSection_trtMatrixType__idfsMatrixType] FOREIGN KEY ([idfsMatrixType]) REFERENCES [dbo].[trtMatrixType] ([idfsMatrixType]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_ffSection]
    ON [dbo].[ffSection]([intRowStatus] ASC, [idfsParentSection] ASC);


GO

CREATE TRIGGER [dbo].[TR_ffSection_A_Update] ON [dbo].[ffSection]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsSection))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_ffSection_I_Delete] on [dbo].[ffSection]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsSection]) as
		(
			SELECT [idfsSection] FROM deleted
			EXCEPT
			SELECT [idfsSection] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffSection as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsSection = b.idfsSection;


		WITH cteOnlyDeletedRecords([idfsSection]) as
		(
			SELECT [idfsSection] FROM deleted
			EXCEPT
			SELECT [idfsSection] FROM inserted
		)
		
		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsSection;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Sections', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSection';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Section identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSection', @level2type = N'COLUMN', @level2name = N'idfsSection';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parent section identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSection', @level2type = N'COLUMN', @level2name = N'idfsParentSection';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSection', @level2type = N'COLUMN', @level2name = N'idfsFormType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Order in tree/list', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSection', @level2type = N'COLUMN', @level2name = N'intOrder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Flag - Is Grid section', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSection', @level2type = N'COLUMN', @level2name = N'blnGrid';

