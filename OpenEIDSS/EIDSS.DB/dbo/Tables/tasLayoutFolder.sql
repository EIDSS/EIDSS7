CREATE TABLE [dbo].[tasLayoutFolder] (
    [idflLayoutFolder]       BIGINT           NOT NULL,
    [idfsGlobalLayoutFolder] BIGINT           NULL,
    [idflParentLayoutFolder] BIGINT           NULL,
    [idflQuery]              BIGINT           NOT NULL,
    [blnReadOnly]            BIT              CONSTRAINT [Def_0_2634] DEFAULT ((0)) NOT NULL,
    [strReservedAttribute]   NVARCHAR (MAX)   NULL,
    [rowguid]                UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasLayoutFolder] PRIMARY KEY CLUSTERED ([idflLayoutFolder] ASC),
    CONSTRAINT [FK_tasLayoutFolder_locBaseReference__idflLayoutFolder_R_1703] FOREIGN KEY ([idflLayoutFolder]) REFERENCES [dbo].[locBaseReference] ([idflBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutFolder_tasglLayoutFolder__idfsGlobalLayoutFolder_R_1796] FOREIGN KEY ([idfsGlobalLayoutFolder]) REFERENCES [dbo].[tasglLayoutFolder] ([idfsLayoutFolder]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutFolder_tasLayoutFolder__idflParentLayoutFolder_R_1715] FOREIGN KEY ([idflParentLayoutFolder]) REFERENCES [dbo].[tasLayoutFolder] ([idflLayoutFolder]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutFolder_tasQuery__idflQuery_R_1697] FOREIGN KEY ([idflQuery]) REFERENCES [dbo].[tasQuery] ([idflQuery]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutFolder_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasLayoutFolder_A_Update] ON [dbo].[tasLayoutFolder]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idflLayoutFolder))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
