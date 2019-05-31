CREATE TABLE [dbo].[ffParameterForFunction] (
    [idfParameterForFunction] BIGINT           NOT NULL,
    [idfsParameter]           BIGINT           NOT NULL,
    [idfsFormTemplate]        BIGINT           NOT NULL,
    [idfsRule]                BIGINT           NOT NULL,
    [intOrder]                INT              NULL,
    [intRowStatus]            INT              CONSTRAINT [Def_0_2038] DEFAULT ((0)) NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid__2041] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffParameterForFunction] PRIMARY KEY CLUSTERED ([idfParameterForFunction] ASC),
    CONSTRAINT [FK_ffParameterForFunction_ffParameterForTemplate__idfsParameter___________________________________________________idfsFormTempla] FOREIGN KEY ([idfsParameter], [idfsFormTemplate]) REFERENCES [dbo].[ffParameterForTemplate] ([idfsParameter], [idfsFormTemplate]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterForFunction_ffRule__idfsRule_R_1647] FOREIGN KEY ([idfsRule]) REFERENCES [dbo].[ffRule] ([idfsRule]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterForFunction_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_ffParameterForFunction_A_Update] ON [dbo].[ffParameterForFunction]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1) AND (UPDATE(idfParameterForFunction))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END


END

GO


CREATE TRIGGER [dbo].[TR_ffParameterForFunction_I_Delete] on [dbo].[ffParameterForFunction]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfParameterForFunction]) as
		(
			SELECT [idfParameterForFunction] FROM deleted
			EXCEPT
			SELECT [idfParameterForFunction] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffParameterForFunction as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfParameterForFunction = b.idfParameterForFunction;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameters for function', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterForFunction';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Paramenter identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterForFunction', @level2type = N'COLUMN', @level2name = N'idfsParameter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterForFunction', @level2type = N'COLUMN', @level2name = N'idfsFormTemplate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Order in function', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterForFunction', @level2type = N'COLUMN', @level2name = N'intOrder';

