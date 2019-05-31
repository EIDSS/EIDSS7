CREATE TABLE [dbo].[tasQuery] (
    [idflQuery]               BIGINT           NOT NULL,
    [idfsGlobalQuery]         BIGINT           NULL,
    [strFunctionName]         NVARCHAR (200)   NOT NULL,
    [idflDescription]         BIGINT           NOT NULL,
    [blnReadOnly]             BIT              CONSTRAINT [Def_0___2706] DEFAULT ((0)) NOT NULL,
    [blnAddAllKeyFieldValues] BIT              CONSTRAINT [Def_0_2635] DEFAULT ((0)) NOT NULL,
    [blnSubQuery]             BIT              CONSTRAINT [Def_0_tasQuery__blnSubQuery] DEFAULT ((0)) NOT NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [rowguid]                 UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasQuery] PRIMARY KEY CLUSTERED ([idflQuery] ASC),
    CONSTRAINT [FK_tasQuery_locBaseReference__idflDescription_R_1718] FOREIGN KEY ([idflDescription]) REFERENCES [dbo].[locBaseReference] ([idflBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasQuery_locBaseReference__idflQueryName_R_1709] FOREIGN KEY ([idflQuery]) REFERENCES [dbo].[locBaseReference] ([idflBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasQuery_tasglQuery__idfsGlobalQuery_R_1795] FOREIGN KEY ([idfsGlobalQuery]) REFERENCES [dbo].[tasglQuery] ([idfsQuery]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasQuery_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasQuery_A_Update] ON [dbo].[tasQuery]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idflQuery))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
