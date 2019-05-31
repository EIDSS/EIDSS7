CREATE TABLE [dbo].[tstMandatoryFieldsToCP] (
    [idfMandatoryField]       BIGINT           NOT NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid_tstMandatoryFieldsToCP] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstMandatoryFieldsToCP] PRIMARY KEY CLUSTERED ([idfMandatoryField] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_tstMandatoryFieldsToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstMandatoryFieldsToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstMandatoryFieldsToCP_tstMandatoryFields_idfMandatoryField] FOREIGN KEY ([idfMandatoryField]) REFERENCES [dbo].[tstMandatoryFields] ([idfMandatoryField]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstMandatoryFieldsToCP_A_Update] ON [dbo].[tstMandatoryFieldsToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfMandatoryField]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
