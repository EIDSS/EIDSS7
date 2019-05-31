CREATE TABLE [dbo].[trtBaseReferenceAttribute] (
    [idfBaseReferenceAttribute] BIGINT           NOT NULL,
    [idfsBaseReference]         BIGINT           NOT NULL,
    [idfAttributeType]          BIGINT           NOT NULL,
    [varValue]                  SQL_VARIANT      NULL,
    [rowguid]                   UNIQUEIDENTIFIER CONSTRAINT [trtBaseReferenceAttribute__newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]        NVARCHAR (20)    NULL,
    [strReservedAttribute]      NVARCHAR (MAX)   NULL,
    [strAttributeItem]          NVARCHAR (2000)  NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtBaseReferenceAttribute] PRIMARY KEY CLUSTERED ([idfBaseReferenceAttribute] ASC),
    CONSTRAINT [FK_trtBaseReferenceAttribute_trtAttributeType__idfAttributeType] FOREIGN KEY ([idfAttributeType]) REFERENCES [dbo].[trtAttributeType] ([idfAttributeType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtBaseReferenceAttribute_trtBaseReference__idfsBaseReference] FOREIGN KEY ([idfsBaseReference]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtBaseReferenceAttribute_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtBaseReferenceAttribute_A_Update] ON [dbo].[trtBaseReferenceAttribute]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfBaseReferenceAttribute))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
