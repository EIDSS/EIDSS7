CREATE TABLE [dbo].[ffParameterDesignOption] (
    [idfParameterDesignOption] BIGINT           NOT NULL,
    [idfsParameter]            BIGINT           NOT NULL,
    [idfsLanguage]             BIGINT           NOT NULL,
    [idfsFormTemplate]         BIGINT           NULL,
    [intLeft]                  INT              CONSTRAINT [Def_0_1915] DEFAULT ((0)) NOT NULL,
    [intTop]                   INT              CONSTRAINT [Def_0_1916] DEFAULT ((0)) NOT NULL,
    [intWidth]                 INT              CONSTRAINT [Def_200_9] DEFAULT ((200)) NOT NULL,
    [intHeight]                INT              CONSTRAINT [Def_200_10] DEFAULT ((200)) NOT NULL,
    [intScheme]                INT              CONSTRAINT [Def_0_1917] DEFAULT ((0)) NOT NULL,
    [intLabelSize]             INT              CONSTRAINT [Def_100_5] DEFAULT ((100)) NOT NULL,
    [intOrder]                 INT              CONSTRAINT [Def_0_1918] DEFAULT ((0)) NOT NULL,
    [intRowStatus]             INT              CONSTRAINT [Def_0_1919] DEFAULT ((0)) NOT NULL,
    [rowguid]                  UNIQUEIDENTIFIER CONSTRAINT [newid__1922] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]       NVARCHAR (20)    NULL,
    [SourceSystemNameID]       BIGINT           NULL,
    [SourceSystemKeyValue]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffParameterDesignOption] PRIMARY KEY CLUSTERED ([idfParameterDesignOption] ASC),
    CONSTRAINT [FK_ffParameterDesignOption_ffFormTemplate__idfsFormTemplate_R_1361] FOREIGN KEY ([idfsFormTemplate]) REFERENCES [dbo].[ffFormTemplate] ([idfsFormTemplate]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterDesignOption_ffParameter__idfsParameter_R_1360] FOREIGN KEY ([idfsParameter]) REFERENCES [dbo].[ffParameter] ([idfsParameter]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterDesignOption_trtBaseReference__idfsLanguage_R_1381] FOREIGN KEY ([idfsLanguage]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterDesignOption_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_ParametrDesignOptions]
    ON [dbo].[ffParameterDesignOption]([idfsParameter] ASC, [idfsLanguage] ASC, [idfsFormTemplate] ASC, [intRowStatus] ASC);


GO


CREATE TRIGGER [dbo].[TR_ffParameterDesignOption_I_Delete] on [dbo].[ffParameterDesignOption]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfParameterDesignOption]) as
		(
			SELECT [idfParameterDesignOption] FROM deleted
			EXCEPT
			SELECT [idfParameterDesignOption] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffParameterDesignOption as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfParameterDesignOption = b.idfParameterDesignOption;

	END

END

GO

CREATE TRIGGER [dbo].[TR_ffParameterDesignOption_A_Update] ON [dbo].[ffParameterDesignOption]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1) AND (UPDATE(idfParameterDesignOption))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter Design Options', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterDesignOption';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter design option identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterDesignOption', @level2type = N'COLUMN', @level2name = N'idfParameterDesignOption';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterDesignOption', @level2type = N'COLUMN', @level2name = N'idfsParameter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Affected language identifier (default - EN)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterDesignOption', @level2type = N'COLUMN', @level2name = N'idfsLanguage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Affected template identifier (null - used by default)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterDesignOption', @level2type = N'COLUMN', @level2name = N'idfsFormTemplate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Left indent', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterDesignOption', @level2type = N'COLUMN', @level2name = N'intLeft';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Top indent', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterDesignOption', @level2type = N'COLUMN', @level2name = N'intTop';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Width', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterDesignOption', @level2type = N'COLUMN', @level2name = N'intWidth';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Height', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterDesignOption', @level2type = N'COLUMN', @level2name = N'intHeight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Label is on the (0 - left, 1 - right, 2 - top, 3- bottom)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterDesignOption', @level2type = N'COLUMN', @level2name = N'intScheme';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Label size', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterDesignOption', @level2type = N'COLUMN', @level2name = N'intLabelSize';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Order in grid (used only for grid sections)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterDesignOption', @level2type = N'COLUMN', @level2name = N'intOrder';

