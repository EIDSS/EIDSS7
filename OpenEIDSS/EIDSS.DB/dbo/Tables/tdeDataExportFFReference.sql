CREATE TABLE [dbo].[tdeDataExportFFReference] (
    [idfsParameter]           BIGINT           NOT NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [strType]                 NVARCHAR (128)   NOT NULL,
    [strAlias]                NVARCHAR (128)   NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtdeDataExportFFReference] PRIMARY KEY CLUSTERED ([idfsParameter] ASC, [idfCustomizationPackage] ASC, [strType] ASC, [strAlias] ASC),
    CONSTRAINT [FK_tdeDataExportFFReference_ffParameter__idfsParameter] FOREIGN KEY ([idfsParameter]) REFERENCES [dbo].[ffParameter] ([idfsParameter]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tdeDataExportFFReference_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tdeDataExportFFReference_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tdeDataExportFFReference_A_Update] ON [dbo].[tdeDataExportFFReference]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsParameter) OR UPDATE(idfCustomizationPackage) OR UPDATE(strType) OR UPDATE(strAlias)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
