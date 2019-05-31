CREATE TABLE [dbo].[trtBaseReferenceAttributeToCP] (
    [idfBaseReferenceAttribute] BIGINT           NOT NULL,
    [idfCustomizationPackage]   BIGINT           NOT NULL,
    [rowguid]                   UNIQUEIDENTIFIER CONSTRAINT [trtBaseReferenceAttributeToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]        NVARCHAR (20)    NULL,
    [strReservedAttribute]      NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtBaseReferenceAttributeToCP] PRIMARY KEY CLUSTERED ([idfBaseReferenceAttribute] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtBaseReferenceAttributeToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtBaseReferenceAttributeToCP_trtBaseReferenceAttribute__idfsBaseReference] FOREIGN KEY ([idfBaseReferenceAttribute]) REFERENCES [dbo].[trtBaseReferenceAttribute] ([idfBaseReferenceAttribute]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtBaseReferenceAttributeToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtBaseReferenceAttributeToCP_A_Update] ON [dbo].[trtBaseReferenceAttributeToCP]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfBaseReferenceAttribute) OR UPDATE(idfCustomizationPackage)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
