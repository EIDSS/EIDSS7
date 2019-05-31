CREATE TABLE [dbo].[tasglQuery] (
    [idfsQuery]               BIGINT           NOT NULL,
    [strFunctionName]         NVARCHAR (200)   NOT NULL,
    [idfsDescription]         BIGINT           NOT NULL,
    [blnReadOnly]             BIT              CONSTRAINT [Def_0___2699] DEFAULT ((0)) NOT NULL,
    [blnAddAllKeyFieldValues] BIT              CONSTRAINT [Def_0_2635_12] DEFAULT ((0)) NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid__2531] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [blnSubQuery]             BIT              CONSTRAINT [Def_0_tasglQuery__blnSubQuery] DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglQuery] PRIMARY KEY CLUSTERED ([idfsQuery] ASC),
    CONSTRAINT [FK_tasglQuery_trtBaseReference__idfsDescription_R_1718_1] FOREIGN KEY ([idfsDescription]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQuery_trtBaseReference__idfsQueryName_R_1709_1] FOREIGN KEY ([idfsQuery]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQuery_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasglQuery_A_Update] ON [dbo].[tasglQuery]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsQuery))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
