CREATE TABLE [dbo].[trtBaseReferenceToCP] (
    [idfsBaseReference]       BIGINT           NOT NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [intHACode]               INT              NULL,
    [intOrder]                INT              NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [trtBaseReferenceToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtBaseReferenceToCP] PRIMARY KEY CLUSTERED ([idfsBaseReference] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtBaseReferenceToCP_trtBaseReference__idfsBaseReference] FOREIGN KEY ([idfsBaseReference]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtBaseReferenceToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtBaseReferenceToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtBaseReferenceToCP_A_Update] ON [dbo].[trtBaseReferenceToCP]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsBaseReference) OR UPDATE(idfCustomizationPackage)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Base Reference links to country ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtBaseReferenceToCP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Base reference value identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtBaseReferenceToCP', @level2type = N'COLUMN', @level2name = N'idfsBaseReference';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtBaseReferenceToCP', @level2type = N'COLUMN', @level2name = N'idfCustomizationPackage';

