CREATE TABLE [dbo].[tlbVetCaseLog] (
    [idfVetCaseLog]        BIGINT           NOT NULL,
    [idfsCaseLogStatus]    BIGINT           NULL,
    [idfVetCase]           BIGINT           NULL,
    [idfPerson]            BIGINT           NULL,
    [datCaseLogDate]       DATETIME         NULL,
    [strActionRequired]    NVARCHAR (200)   NULL,
    [strNote]              NVARCHAR (1000)  NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2008] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2011] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbVetCaseLog] PRIMARY KEY CLUSTERED ([idfVetCaseLog] ASC),
    CONSTRAINT [FK_tlbVetCaseLog_tlbPerson__idfPerson_R_1501] FOREIGN KEY ([idfPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCaseLog_tlbVetCase__idfVetCase_R_1489] FOREIGN KEY ([idfVetCase]) REFERENCES [dbo].[tlbVetCase] ([idfVetCase]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCaseLog_trtBaseReference__idfsCaseLogStatus_R_1490] FOREIGN KEY ([idfsCaseLogStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCaseLog_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tlbVetCaseLog_A_Update] ON [dbo].[tlbVetCaseLog]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfVetCaseLog))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbVetCaseLog_I_Delete] on [dbo].[tlbVetCaseLog]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfVetCaseLog]) as
		(
			SELECT [idfVetCaseLog] FROM deleted
			EXCEPT
			SELECT [idfVetCaseLog] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbVetCaseLog as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfVetCaseLog = b.idfVetCaseLog;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Veterinary Case log', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCaseLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Officer identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCaseLog', @level2type = N'COLUMN', @level2name = N'idfPerson';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCaseLog', @level2type = N'COLUMN', @level2name = N'datCaseLogDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Notes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCaseLog', @level2type = N'COLUMN', @level2name = N'strNote';

