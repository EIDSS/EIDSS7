CREATE TABLE [dbo].[tlbTestAmendmentHistory] (
    [idfTestAmendmentHistory] BIGINT           NOT NULL,
    [idfTesting]              BIGINT           NOT NULL,
    [idfAmendByOffice]        BIGINT           NULL,
    [idfAmendByPerson]        BIGINT           NULL,
    [datAmendmentDate]        DATETIME         NOT NULL,
    [idfsOldTestResult]       BIGINT           NULL,
    [idfsNewTestResult]       BIGINT           NULL,
    [strOldNote]              NVARCHAR (500)   NULL,
    [strNewNote]              NVARCHAR (500)   NULL,
    [strReason]               NVARCHAR (500)   NOT NULL,
    [intRowStatus]            INT              CONSTRAINT [tlbTestAmendmentHistory_Def_0] DEFAULT ((0)) NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [tlbTestAmendmentHistory_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    [AuditCreateUser]         NVARCHAR (200)   NULL,
    [AuditCreateDTM]          DATETIME         CONSTRAINT [DF_tlbTestAmendmentHistory_CreateDTM] DEFAULT (getdate()) NULL,
    [AuditUpdateUser]         NVARCHAR (200)   NULL,
    [AuditUpdateDTM]          DATETIME         NULL,
    CONSTRAINT [XPKtlbTestAmendmentHistory] PRIMARY KEY CLUSTERED ([idfTestAmendmentHistory] ASC),
    CONSTRAINT [FK_tlbTestAmendmentHistory_tlbOffice__idfAmendByOffice] FOREIGN KEY ([idfAmendByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTestAmendmentHistory_tlbPerson__idfAmendByPerson] FOREIGN KEY ([idfAmendByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTestAmendmentHistory_tlbTesting__idfTesting] FOREIGN KEY ([idfTesting]) REFERENCES [dbo].[tlbTesting] ([idfTesting]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTestAmendmentHistory_trtBaseReference__idfsNewTestResult] FOREIGN KEY ([idfsNewTestResult]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTestAmendmentHistory_trtBaseReference__idfsOldTestResult] FOREIGN KEY ([idfsOldTestResult]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTestAmendmentHistory_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tlbTestAmendmentHistory_A_Update] ON [dbo].[tlbTestAmendmentHistory]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfTestAmendmentHistory))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbTestAmendmentHistory_I_Delete] on [dbo].[tlbTestAmendmentHistory]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfTestAmendmentHistory]) as
		(
			SELECT [idfTestAmendmentHistory] FROM deleted
			EXCEPT
			SELECT [idfTestAmendmentHistory] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbTestAmendmentHistory as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfTestAmendmentHistory = b.idfTestAmendmentHistory;

	END

END
