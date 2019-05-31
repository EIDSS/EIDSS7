CREATE TABLE [dbo].[tstPersonalDataGroupToCP] (
    [idfPersonalDataGroup]    BIGINT           NOT NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid_tstPersonalDataGroupToCP] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstPersonalDataGroupToCP] PRIMARY KEY CLUSTERED ([idfPersonalDataGroup] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_tstPersonalDataGroupToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstPersonalDataGroupToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstPersonalDataGroupToCP_tstPersonalDataGroup_idfPersonalDataGroup] FOREIGN KEY ([idfPersonalDataGroup]) REFERENCES [dbo].[tstPersonalDataGroup] ([idfPersonalDataGroup]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstPersonalDataGroupToCP_A_Update] ON [dbo].[tstPersonalDataGroupToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfPersonalDataGroup]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
