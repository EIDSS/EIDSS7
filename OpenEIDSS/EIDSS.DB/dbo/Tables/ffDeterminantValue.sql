CREATE TABLE [dbo].[ffDeterminantValue] (
    [idfDeterminantValue]  BIGINT           NOT NULL,
    [idfsFormTemplate]     BIGINT           NOT NULL,
    [idfsBaseReference]    BIGINT           NULL,
    [idfsGISBaseReference] BIGINT           NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2466] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2430] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffDeterminantValue] PRIMARY KEY CLUSTERED ([idfDeterminantValue] ASC),
    CONSTRAINT [FK_ffDeterminantValue_gisBaseReference__idfsGISBaseReference_R_1670] FOREIGN KEY ([idfsGISBaseReference]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffDeterminantValue_trtBaseReference__idfsBaseReference_R_949] FOREIGN KEY ([idfsBaseReference]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffDeterminantValue_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_FFormControlValue_FFormTemplate] FOREIGN KEY ([idfsFormTemplate]) REFERENCES [dbo].[ffFormTemplate] ([idfsFormTemplate]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_ffDeterminantValue_A_Update] on [dbo].[ffDeterminantValue]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDeterminantValue))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_ffDeterminantValue_I_Delete] on [dbo].[ffDeterminantValue]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfDeterminantValue]) as
		(
			SELECT [idfDeterminantValue] FROM deleted
			EXCEPT
			SELECT [idfDeterminantValue] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffDeterminantValue as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfDeterminantValue = b.idfDeterminantValue;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Determinant Values', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDeterminantValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDeterminantValue', @level2type = N'COLUMN', @level2name = N'idfsFormTemplate';

