CREATE TABLE [dbo].[tasSearchTable] (
    [idfSearchTable]        BIGINT           NOT NULL,
    [strTableName]          NVARCHAR (200)   NOT NULL,
    [strFrom]               NVARCHAR (MAX)   NULL,
    [intTableCount]         INT              NULL,
    [blnPrimary]            BIT              CONSTRAINT [Def_0___2712] DEFAULT ((0)) NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__2484] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strPKField]            VARCHAR (200)    NOT NULL,
    [strExistenceCondition] VARCHAR (200)    NOT NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasSearchTable] PRIMARY KEY CLUSTERED ([idfSearchTable] ASC),
    CONSTRAINT [FK_tasSearchTable_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasSearchTable_A_Update] ON [dbo].[tasSearchTable]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSearchTable))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
