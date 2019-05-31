CREATE TABLE [dbo].[ffDeterminantType] (
    [idfDeterminantType]   BIGINT           NOT NULL,
    [idfsReferenceType]    BIGINT           NULL,
    [idfsGISReferenceType] BIGINT           NULL,
    [idfsFormType]         BIGINT           NOT NULL,
    [intOrder]             INT              CONSTRAINT [Def_0_2463] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2428] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffDeterminantType] PRIMARY KEY CLUSTERED ([idfDeterminantType] ASC),
    CONSTRAINT [FK_ffDeterminantType_gisReferenceType__idfsGISReferenceType_R_1669] FOREIGN KEY ([idfsGISReferenceType]) REFERENCES [dbo].[gisReferenceType] ([idfsGISReferenceType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffDeterminantType_trtBaseReference__idfsFormType_R_1660] FOREIGN KEY ([idfsFormType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffDeterminantType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_ffDeterminantType_trtReferenceType__idfsReferenceType_R_950] FOREIGN KEY ([idfsReferenceType]) REFERENCES [dbo].[trtReferenceType] ([idfsReferenceType]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_ffDeterminantType_A_Update] on [dbo].[ffDeterminantType]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDeterminantType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Determinant Type', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDeterminantType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Reference type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDeterminantType', @level2type = N'COLUMN', @level2name = N'idfsReferenceType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDeterminantType', @level2type = N'COLUMN', @level2name = N'idfsFormType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Order number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDeterminantType', @level2type = N'COLUMN', @level2name = N'intOrder';

