CREATE TABLE [dbo].[tasglLayoutFolder] (
    [idfsLayoutFolder]       BIGINT           NOT NULL,
    [idfsParentLayoutFolder] BIGINT           NULL,
    [idfsQuery]              BIGINT           NOT NULL,
    [blnReadOnly]            BIT              CONSTRAINT [Def_0_2634_12] DEFAULT ((0)) NULL,
    [rowguid]                UNIQUEIDENTIFIER CONSTRAINT [newid__2532] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]     NVARCHAR (20)    NULL,
    [strReservedAttribute]   NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglLayoutFolder] PRIMARY KEY CLUSTERED ([idfsLayoutFolder] ASC),
    CONSTRAINT [FK_tasglLayoutFolder_tasglLayoutFolder__idfsParentLayoutFolder_R_1715_1] FOREIGN KEY ([idfsParentLayoutFolder]) REFERENCES [dbo].[tasglLayoutFolder] ([idfsLayoutFolder]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayoutFolder_tasglQuery__idfsQuery_R_1697_1] FOREIGN KEY ([idfsQuery]) REFERENCES [dbo].[tasglQuery] ([idfsQuery]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayoutFolder_trtBaseReference__idfsLayoutFolder_R_1703_1] FOREIGN KEY ([idfsLayoutFolder]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayoutFolder_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasglLayoutFolder_A_Update] ON [dbo].[tasglLayoutFolder]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsLayoutFolder))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
