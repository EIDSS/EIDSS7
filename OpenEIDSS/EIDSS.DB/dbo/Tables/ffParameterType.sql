CREATE TABLE [dbo].[ffParameterType] (
    [idfsParameterType]    BIGINT           NOT NULL,
    [idfsReferenceType]    BIGINT           NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1912] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1920] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffParameterType] PRIMARY KEY CLUSTERED ([idfsParameterType] ASC),
    CONSTRAINT [FK_ffParameterType_trtBaseReference__idfsParameterType_R_1395] FOREIGN KEY ([idfsParameterType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_ffParameterType_trtReferenceType__idfsReferenceType_R_927] FOREIGN KEY ([idfsReferenceType]) REFERENCES [dbo].[trtReferenceType] ([idfsReferenceType]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_ffParameterType_A_Update] ON [dbo].[ffParameterType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1) AND (UPDATE(idfsParameterType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_ffParameterType_I_Delete] on [dbo].[ffParameterType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsParameterType]) as
		(
			SELECT [idfsParameterType] FROM deleted
			EXCEPT
			SELECT [idfsParameterType] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffParameterType as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsParameterType = b.idfsParameterType;


		WITH cteOnlyDeletedRecords([idfsParameterType]) as
		(
			SELECT [idfsParameterType] FROM deleted
			EXCEPT
			SELECT [idfsParameterType] FROM inserted
		)
		
		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsParameterType;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter types', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterType', @level2type = N'COLUMN', @level2name = N'idfsParameterType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Reference type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterType', @level2type = N'COLUMN', @level2name = N'idfsReferenceType';

