CREATE TABLE [dbo].[ffParameter] (
    [idfsParameter]        BIGINT           NOT NULL,
    [idfsSection]          BIGINT           NULL,
    [idfsParameterCaption] BIGINT           NULL,
    [idfsParameterType]    BIGINT           NULL,
    [idfsFormType]         BIGINT           NOT NULL,
    [idfsEditor]           BIGINT           NULL,
    [strNote]              NVARCHAR (1000)  NULL,
    [intOrder]             INT              CONSTRAINT [Def_0_2078] DEFAULT ((0)) NOT NULL,
    [intHACode]            INT              NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2079] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2080] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffParameter] PRIMARY KEY CLUSTERED ([idfsParameter] ASC),
    CONSTRAINT [FK_ffParameter_ffParameterType__idfsParameterType_R_21] FOREIGN KEY ([idfsParameterType]) REFERENCES [dbo].[ffParameterType] ([idfsParameterType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameter_ffSection__idfsSection_R_1380] FOREIGN KEY ([idfsSection]) REFERENCES [dbo].[ffSection] ([idfsSection]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameter_trtBaseReference__idfsEditor_R_1387] FOREIGN KEY ([idfsEditor]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameter_trtBaseReference__idfsFormType_R_1658] FOREIGN KEY ([idfsFormType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameter_trtBaseReference__idfsParameter_R_1382] FOREIGN KEY ([idfsParameter]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameter_trtBaseReference__idfsParameterCaption_R_1383] FOREIGN KEY ([idfsParameterCaption]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameter_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_ffParameter]
    ON [dbo].[ffParameter]([intRowStatus] ASC, [idfsSection] ASC);


GO

CREATE TRIGGER [dbo].[TR_ffParameter_A_Update] on [dbo].[ffParameter]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1) AND (UPDATE(idfsParameter))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_ffParameter_I_Delete] on [dbo].[ffParameter]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsParameter]) as
		(
			SELECT [idfsParameter] FROM deleted
			EXCEPT
			SELECT [idfsParameter] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffParameter as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsParameter = b.idfsParameter;


		WITH cteOnlyDeletedRecords([idfsParameter]) as
		(
			SELECT [idfsParameter] FROM deleted
			EXCEPT
			SELECT [idfsParameter] FROM inserted
		)
		
		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsParameter;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameters', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameter', @level2type = N'COLUMN', @level2name = N'idfsParameter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Containing Section identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameter', @level2type = N'COLUMN', @level2name = N'idfsSection';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter caption identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameter', @level2type = N'COLUMN', @level2name = N'idfsParameterCaption';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameter', @level2type = N'COLUMN', @level2name = N'idfsParameterType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter form type identifier (can be used only in a template of this type)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameter', @level2type = N'COLUMN', @level2name = N'idfsFormType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Editor type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameter', @level2type = N'COLUMN', @level2name = N'idfsEditor';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter notes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameter', @level2type = N'COLUMN', @level2name = N'strNote';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Order in the section', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameter', @level2type = N'COLUMN', @level2name = N'intOrder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Human/Animal code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameter', @level2type = N'COLUMN', @level2name = N'intHACode';

