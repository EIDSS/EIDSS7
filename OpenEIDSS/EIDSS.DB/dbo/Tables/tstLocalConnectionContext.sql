CREATE TABLE [dbo].[tstLocalConnectionContext] (
    [strConnectionContext] NVARCHAR (200)   NOT NULL,
    [idfUserID]            BIGINT           NULL,
    [idfDataAuditEvent]    BIGINT           NULL,
    [idfEventID]           BIGINT           NULL,
    [binChallenge]         VARBINARY (50)   NULL,
    [idfsSite]             BIGINT           NULL,
    [datLastUsed]          DATETIME         CONSTRAINT [Def_GetUTCDate_tstLocalConnectionContext] DEFAULT (getutcdate()) NOT NULL,
    [blnDiagnosisDenied]   BIT              CONSTRAINT [Def_blnDiagnosisDenied_tstLocalConnectionContext] DEFAULT ((0)) NULL,
    [blnSiteDenied]        BIT              CONSTRAINT [Def_blnSiteDenied_tstLocalConnectionContext] DEFAULT ((0)) NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstLocalConnectionContext] PRIMARY KEY CLUSTERED ([strConnectionContext] ASC),
    CONSTRAINT [FK_tstLocalConnectionContext_tauDataAuditEvent__idfDataAuditEvent_R_1043] FOREIGN KEY ([idfDataAuditEvent]) REFERENCES [dbo].[tauDataAuditEvent] ([idfDataAuditEvent]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstLocalConnectionContext_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstLocalConnectionContext_tstEvent__idfEventID_R_1044] FOREIGN KEY ([idfEventID]) REFERENCES [dbo].[tstEvent] ([idfEventID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstLocalConnectionContext_tstSite__idfsSite_R_1858] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstLocalConnectionContext_tstUserTable__idfUserID_R_1042] FOREIGN KEY ([idfUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstLocalConnectionContext_A_Update] ON [dbo].[tstLocalConnectionContext]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([strConnectionContext]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
