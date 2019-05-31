CREATE TABLE [dbo].[trtSystemFunctionOperation] (
    [idfsSystemFunctionOperation] BIGINT           IDENTITY (1, 1) NOT NULL,
    [idfsObjectType]              BIGINT           NULL,
    [idfsObjectTypeName]          VARCHAR (200)    NULL,
    [idfsObjectOperation]         BIGINT           NULL,
    [idfsObjectOperationnName]    VARCHAR (200)    NULL,
    [idfsObjectID]                BIGINT           NULL,
    [idfsObjectIDName]            VARCHAR (200)    NULL,
    [strReservedAttribute]        NVARCHAR (MAX)   NULL,
    [intRowStatus]                INT              CONSTRAINT [DF__trtSystem__intRo__2706EE0D] DEFAULT ((0)) NOT NULL,
    [rowguid]                     UNIQUEIDENTIFIER CONSTRAINT [DF__trtSystem__rowgu__27FB1246] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]          BIGINT           NULL,
    [SourceSystemKeyValue]        NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtSystemFunctionOperation] PRIMARY KEY CLUSTERED ([idfsSystemFunctionOperation] ASC),
    CONSTRAINT [FK_trtSystemFunctionOperation_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtSystemFunctionOperation_A_Update] ON [dbo].[trtSystemFunctionOperation]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfsSystemFunctionOperation]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
