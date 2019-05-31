CREATE TABLE [dbo].[ffParameterFixedPresetValue] (
    [idfsParameterFixedPresetValue] BIGINT           NOT NULL,
    [idfsParameterType]             BIGINT           NULL,
    [intRowStatus]                  INT              CONSTRAINT [Def_0_1921] DEFAULT ((0)) NOT NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [newid__1924] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffParameterFixedPresetValue] PRIMARY KEY CLUSTERED ([idfsParameterFixedPresetValue] ASC),
    CONSTRAINT [FK_ffParameterFixedPresetValue_ffParameterType__idfsParameterType_R_925] FOREIGN KEY ([idfsParameterType]) REFERENCES [dbo].[ffParameterType] ([idfsParameterType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterFixedPresetValue_trtBaseReference__idfsParameterFixedPresetValue_R_1398] FOREIGN KEY ([idfsParameterFixedPresetValue]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterFixedPresetValue_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_ffParameterFixedPresetValue_A_Update] ON [dbo].[ffParameterFixedPresetValue]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN

	IF(dbo.FN_GBL_TriggersWork ()=1) AND (UPDATE(idfsParameterFixedPresetValue))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_ffParameterFixedPresetValue_I_Delete] on [dbo].[ffParameterFixedPresetValue]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsParameterFixedPresetValue]) as
		(
			SELECT [idfsParameterFixedPresetValue] FROM deleted
			EXCEPT
			SELECT [idfsParameterFixedPresetValue] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffParameterFixedPresetValue as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsParameterFixedPresetValue = b.idfsParameterFixedPresetValue;


		WITH cteOnlyDeletedRecords([idfsParameterFixedPresetValue]) as
		(
			SELECT [idfsParameterFixedPresetValue] FROM deleted
			EXCEPT
			SELECT [idfsParameterFixedPresetValue] FROM inserted
		)
		
		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsParameterFixedPresetValue;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Translated value identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterFixedPresetValue', @level2type = N'COLUMN', @level2name = N'idfsParameterFixedPresetValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterFixedPresetValue', @level2type = N'COLUMN', @level2name = N'idfsParameterType';

