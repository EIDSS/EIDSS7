CREATE TABLE [dbo].[ffParameterForTemplate] (
    [idfsParameter]        BIGINT           NOT NULL,
    [idfsFormTemplate]     BIGINT           NOT NULL,
    [idfsEditMode]         BIGINT           NULL,
    [blnFreeze]            BIT              CONSTRAINT [Def_0_2480] DEFAULT ((0)) NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1922] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1925] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffParameterForTemplate] PRIMARY KEY CLUSTERED ([idfsParameter] ASC, [idfsFormTemplate] ASC),
    CONSTRAINT [FK_ffParameterForTemplate_ffFormTemplate__idfsFormTemplate_R_91] FOREIGN KEY ([idfsFormTemplate]) REFERENCES [dbo].[ffFormTemplate] ([idfsFormTemplate]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterForTemplate_ffParameter__idfsParameter_R_2] FOREIGN KEY ([idfsParameter]) REFERENCES [dbo].[ffParameter] ([idfsParameter]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterForTemplate_trtBaseReference__idfsEditMode_R_1388] FOREIGN KEY ([idfsEditMode]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterForTemplate_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_ParametrForTemplate]
    ON [dbo].[ffParameterForTemplate]([intRowStatus] ASC, [idfsParameter] ASC, [idfsFormTemplate] ASC)
    INCLUDE([idfsEditMode], [blnFreeze]);


GO

CREATE TRIGGER [dbo].[TR_ffParameterForTemplate_A_Update] ON [dbo].[ffParameterForTemplate]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	
	IF(dbo.FN_GBL_TriggersWork ()=1) AND (UPDATE(idfsFormTemplate) OR UPDATE(idfsParameter))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_ffParameterForTemplate_I_Delete] on [dbo].[ffParameterForTemplate]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsFormTemplate], [idfsParameter]) as
		(
			SELECT [idfsFormTemplate], [idfsParameter] FROM deleted
			EXCEPT
			SELECT [idfsFormTemplate], [idfsParameter] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffParameterForTemplate as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsFormTemplate = b.idfsFormTemplate
			AND a.idfsParameter = b.idfsParameter;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameters for template', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterForTemplate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterForTemplate', @level2type = N'COLUMN', @level2name = N'idfsParameter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterForTemplate', @level2type = N'COLUMN', @level2name = N'idfsFormTemplate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Edit mode identifier (read-only/mandatory/…)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterForTemplate', @level2type = N'COLUMN', @level2name = N'idfsEditMode';

