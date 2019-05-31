CREATE TABLE [dbo].[dotNetAppenderLog] (
    [dotNetAppenderLogUID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [LogDTM]               DATETIME         NULL,
    [ProcessThread]        VARCHAR (255)    NULL,
    [LogType]              VARCHAR (100)    NULL,
    [ClassName]            VARCHAR (255)    NULL,
    [ExceptionMessage]     VARCHAR (MAX)    NULL,
    [LogMessage]           VARCHAR (MAX)    NULL,
    [LogURL]               VARCHAR (255)    NULL,
    [StackTrace]           VARCHAR (MAX)    NULL,
    [AppSessionID]         VARCHAR (100)    NULL,
    [AppMethodObject]      VARCHAR (255)    NULL,
    [MethodInParms]        VARCHAR (MAX)    NULL,
    [MethodOutParms]       VARCHAR (MAX)    NULL,
    [AuditCreateUser]      VARCHAR (100)    NOT NULL,
    [AuditCreateDTM]       DATETIME         NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKdoNetAppenderLog] PRIMARY KEY CLUSTERED ([dotNetAppenderLogUID] ASC),
    CONSTRAINT [FK_dotNetAppenderLog_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_dotNetAppenderLog_A_Update] ON [dbo].[dotNetAppenderLog]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF (dbo.FN_GBL_TriggersWork()=1 AND UPDATE(dotNetAppenderLogUID))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
