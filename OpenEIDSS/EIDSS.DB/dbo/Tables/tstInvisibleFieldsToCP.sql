CREATE TABLE [dbo].[tstInvisibleFieldsToCP] (
    [idfInvisibleField]       BIGINT           NOT NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstInvisibleFieldsToCP] PRIMARY KEY CLUSTERED ([idfInvisibleField] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_tstInvisibleFieldsToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstInvisibleFieldsToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstInvisibleFieldsToCP_tstInvisibleFields_idfInvisibleField] FOREIGN KEY ([idfInvisibleField]) REFERENCES [dbo].[tstInvisibleFields] ([idfInvisibleField]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstInvisibleFieldsToCP_A_Update] ON [dbo].[tstInvisibleFieldsToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfInvisibleField]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
