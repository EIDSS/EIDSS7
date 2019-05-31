CREATE TABLE [dbo].[tstInvalidObjects] (
    [idfKey]               INT              IDENTITY (1, 1) NOT NULL,
    [strProblemName]       VARCHAR (200)    NOT NULL,
    [strRootObjectName]    VARCHAR (200)    NOT NULL,
    [idfRootObjectID]      BIGINT           NOT NULL,
    [strRootObjectID]      VARCHAR (500)    NULL,
    [strInvalidTableName]  VARCHAR (200)    NOT NULL,
    [idfInvalidObjectID]   BIGINT           NOT NULL,
    [strInvalidConstraint] VARCHAR (500)    NULL,
    [strInvalidFieldName]  VARCHAR (200)    NULL,
    [strInvalidFieldValue] VARCHAR (500)    NULL,
    [strSelectQuery]       VARCHAR (MAX)    NULL,
    [strFixQueryTemplate]  VARCHAR (MAX)    NULL,
    [blnCanAutoFix]        BIT              NULL,
    [blnFixed]             BIT              NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstInvalidObjects] PRIMARY KEY CLUSTERED ([idfKey] ASC),
    CONSTRAINT [FK_tstInvalidObjects_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tstInvalidObjects_A_Update] ON [dbo].[tstInvalidObjects]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfKey]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
