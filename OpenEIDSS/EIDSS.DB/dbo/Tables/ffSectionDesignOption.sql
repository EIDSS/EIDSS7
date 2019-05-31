CREATE TABLE [dbo].[ffSectionDesignOption] (
    [idfSectionDesignOption] BIGINT           NOT NULL,
    [idfsLanguage]           BIGINT           NOT NULL,
    [idfsFormTemplate]       BIGINT           NOT NULL,
    [idfsSection]            BIGINT           NOT NULL,
    [intLeft]                INT              CONSTRAINT [Def_0_1930] DEFAULT ((0)) NULL,
    [intTop]                 INT              CONSTRAINT [Def_0_1931] DEFAULT ((0)) NULL,
    [intWidth]               INT              CONSTRAINT [Def_400_9] DEFAULT ((400)) NOT NULL,
    [intHeight]              INT              CONSTRAINT [Def_400_10] DEFAULT ((400)) NULL,
    [intOrder]               INT              CONSTRAINT [Def_0_1932] DEFAULT ((0)) NULL,
    [intRowStatus]           INT              CONSTRAINT [Def_0_1933] DEFAULT ((0)) NOT NULL,
    [rowguid]                UNIQUEIDENTIFIER CONSTRAINT [newid__1932] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intCaptionHeight]       INT              CONSTRAINT [Def_23_1] DEFAULT ((23)) NOT NULL,
    [strMaintenanceFlag]     NVARCHAR (20)    NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffSectionDesignOption] PRIMARY KEY CLUSTERED ([idfSectionDesignOption] ASC),
    CONSTRAINT [FK_ffSectionDesignOption_ffSectionForTemplate__idfsFormTemplate________________________________________________idfsSection_R_163] FOREIGN KEY ([idfsFormTemplate], [idfsSection]) REFERENCES [dbo].[ffSectionForTemplate] ([idfsFormTemplate], [idfsSection]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffSectionDesignOption_trtBaseReference__idfsLanguage_R_1377] FOREIGN KEY ([idfsLanguage]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffSectionDesignOption_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_ffSectionDesignOption_A_Update] ON [dbo].[ffSectionDesignOption]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSectionDesignOption))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_ffSectionDesignOption_I_Delete] on [dbo].[ffSectionDesignOption]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfSectionDesignOption]) as
		(
			SELECT [idfSectionDesignOption] FROM deleted
			EXCEPT
			SELECT [idfSectionDesignOption] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffSectionDesignOption as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfSectionDesignOption = b.idfSectionDesignOption;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Section design options', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionDesignOption';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Section design option identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionDesignOption', @level2type = N'COLUMN', @level2name = N'idfSectionDesignOption';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Affected language identifier (default - EN)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionDesignOption', @level2type = N'COLUMN', @level2name = N'idfsLanguage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Affected template identifier (null - used by default)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionDesignOption', @level2type = N'COLUMN', @level2name = N'idfsFormTemplate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Section identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionDesignOption', @level2type = N'COLUMN', @level2name = N'idfsSection';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Left indent', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionDesignOption', @level2type = N'COLUMN', @level2name = N'intLeft';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Top indent', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionDesignOption', @level2type = N'COLUMN', @level2name = N'intTop';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Section Width', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionDesignOption', @level2type = N'COLUMN', @level2name = N'intWidth';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Section Height', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionDesignOption', @level2type = N'COLUMN', @level2name = N'intHeight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Order in grid (used only for grid sections)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionDesignOption', @level2type = N'COLUMN', @level2name = N'intOrder';

