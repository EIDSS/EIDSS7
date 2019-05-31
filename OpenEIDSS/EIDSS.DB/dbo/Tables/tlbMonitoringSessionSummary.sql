CREATE TABLE [dbo].[tlbMonitoringSessionSummary] (
    [idfMonitoringSessionSummary] BIGINT           NOT NULL,
    [idfMonitoringSession]        BIGINT           NOT NULL,
    [idfFarm]                     BIGINT           NOT NULL,
    [idfSpecies]                  BIGINT           NULL,
    [idfsAnimalSex]               BIGINT           NULL,
    [intSampledAnimalsQty]        INT              NULL,
    [intSamplesQty]               INT              NULL,
    [datCollectionDate]           DATETIME         NULL,
    [intPositiveAnimalsQty]       INT              NULL,
    [intRowStatus]                INT              DEFAULT ((0)) NOT NULL,
    [rowguid]                     UNIQUEIDENTIFIER CONSTRAINT [tlbMonitoringSessionSummary_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]          NVARCHAR (20)    NULL,
    [strReservedAttribute]        NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]          BIGINT           NULL,
    [SourceSystemKeyValue]        NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbMonitoringSessionSummary] PRIMARY KEY CLUSTERED ([idfMonitoringSessionSummary] ASC),
    CONSTRAINT [FK_tlbMonitoringSessionSummary_tlbFarm__idfFarm] FOREIGN KEY ([idfFarm]) REFERENCES [dbo].[tlbFarm] ([idfFarm]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMonitoringSessionSummary_tlbMonitoringSession__idfMonitoringSession] FOREIGN KEY ([idfMonitoringSession]) REFERENCES [dbo].[tlbMonitoringSession] ([idfMonitoringSession]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMonitoringSessionSummary_tlbSpecies__idfSpecies] FOREIGN KEY ([idfSpecies]) REFERENCES [dbo].[tlbSpecies] ([idfSpecies]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMonitoringSessionSummary_trtBaseReference__idfsAnimalSex] FOREIGN KEY ([idfsAnimalSex]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMonitoringSessionSummary_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tlbMonitoringSessionSummary_A_Update] ON [dbo].[tlbMonitoringSessionSummary]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfMonitoringSessionSummary))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbMonitoringSessionSummary_I_Delete] on [dbo].[tlbMonitoringSessionSummary]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfMonitoringSessionSummary]) as
		(
			SELECT [idfMonitoringSessionSummary] FROM deleted
			EXCEPT
			SELECT [idfMonitoringSessionSummary] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbMonitoringSessionSummary as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfMonitoringSessionSummary = b.idfMonitoringSessionSummary;

	END

END
