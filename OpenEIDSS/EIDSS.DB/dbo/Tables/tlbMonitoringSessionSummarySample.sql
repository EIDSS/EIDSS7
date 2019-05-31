CREATE TABLE [dbo].[tlbMonitoringSessionSummarySample] (
    [idfMonitoringSessionSummary] BIGINT           NOT NULL,
    [idfsSampleType]              BIGINT           NOT NULL,
    [intRowStatus]                INT              DEFAULT ((0)) NOT NULL,
    [rowguid]                     UNIQUEIDENTIFIER CONSTRAINT [tlbMonitoringSessionSummarySample_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [blnChecked]                  BIT              DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]          NVARCHAR (20)    NULL,
    [strReservedAttribute]        NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]          BIGINT           NULL,
    [SourceSystemKeyValue]        NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tlbMonitoringSessionSummarySample] PRIMARY KEY CLUSTERED ([idfMonitoringSessionSummary] ASC, [idfsSampleType] ASC),
    CONSTRAINT [FK_tlbMonitoringSessionSummarySample_tlbMonitoringSessionSummary__idfMonitoringSessionSummary] FOREIGN KEY ([idfMonitoringSessionSummary]) REFERENCES [dbo].[tlbMonitoringSessionSummary] ([idfMonitoringSessionSummary]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMonitoringSessionSummarySample_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbMonitoringSessionSummarySample_trtSampleType__idfsSampleType] FOREIGN KEY ([idfsSampleType]) REFERENCES [dbo].[trtSampleType] ([idfsSampleType]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tlbMonitoringSessionSummarySample_A_Update] ON [dbo].[tlbMonitoringSessionSummarySample]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfMonitoringSessionSummary) OR UPDATE(idfsSampleType)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbMonitoringSessionSummarySample_I_Delete] on [dbo].[tlbMonitoringSessionSummarySample]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfMonitoringSessionSummary], [idfsSampleType]) as
		(
			SELECT [idfMonitoringSessionSummary], [idfsSampleType] FROM deleted
			EXCEPT
			SELECT [idfMonitoringSessionSummary], [idfsSampleType] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbMonitoringSessionSummarySample as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfMonitoringSessionSummary = b.idfMonitoringSessionSummary
			AND a.idfsSampleType = b.idfsSampleType;

	END

END
