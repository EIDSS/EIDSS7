CREATE TABLE [dbo].[ffSectionForTemplate] (
    [idfsFormTemplate]     BIGINT           NOT NULL,
    [idfsSection]          BIGINT           NOT NULL,
    [blnFreeze]            BIT              CONSTRAINT [Def_0_1928] DEFAULT ((0)) NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1929] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1931] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffSectionForTemplate] PRIMARY KEY CLUSTERED ([idfsFormTemplate] ASC, [idfsSection] ASC),
    CONSTRAINT [FK_ffSectionForTemplate_ffFormTemplate__idfsFormTemplate_R_1400] FOREIGN KEY ([idfsFormTemplate]) REFERENCES [dbo].[ffFormTemplate] ([idfsFormTemplate]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffSectionForTemplate_ffSection__idfsSection_R_1399] FOREIGN KEY ([idfsSection]) REFERENCES [dbo].[ffSection] ([idfsSection]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffSectionForTemplate_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_ffSectionForTemplate]
    ON [dbo].[ffSectionForTemplate]([intRowStatus] ASC, [idfsFormTemplate] ASC, [idfsSection] ASC)
    INCLUDE([blnFreeze]);


GO

CREATE TRIGGER [dbo].[TR_ffSectionForTemplate_A_Update] ON [dbo].[ffSectionForTemplate]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsFormTemplate) OR UPDATE(idfsSection)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_ffSectionForTemplate_I_Delete] on [dbo].[ffSectionForTemplate]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsFormTemplate], [idfsSection]) as
		(
			SELECT [idfsFormTemplate], [idfsSection] FROM deleted
			EXCEPT
			SELECT [idfsFormTemplate], [idfsSection] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffSectionForTemplate as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsFormTemplate = b.idfsFormTemplate
			AND a.idfsSection = b.idfsSection;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Sections for template', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionForTemplate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionForTemplate', @level2type = N'COLUMN', @level2name = N'idfsFormTemplate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Section identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionForTemplate', @level2type = N'COLUMN', @level2name = N'idfsSection';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Flag - Is Freezed (used only for Grid Sections)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionForTemplate', @level2type = N'COLUMN', @level2name = N'blnFreeze';

