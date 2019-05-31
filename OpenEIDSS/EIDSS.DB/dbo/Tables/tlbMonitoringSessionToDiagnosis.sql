CREATE TABLE [dbo].[tlbMonitoringSessionToDiagnosis] (
    [idfMonitoringSessionToDiagnosis] BIGINT           NOT NULL,
    [idfsDiagnosis]                   BIGINT           NOT NULL,
    [idfMonitoringSession]            BIGINT           NOT NULL,
    [intOrder]                        INT              CONSTRAINT [Def_0_2645] DEFAULT ((0)) NOT NULL,
    [intRowStatus]                    INT              CONSTRAINT [Def_0_2646] DEFAULT ((0)) NOT NULL,
    [rowguid]                         UNIQUEIDENTIFIER CONSTRAINT [newid__2518] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfsSpeciesType]                 BIGINT           NULL,
    [strMaintenanceFlag]              NVARCHAR (20)    NULL,
    [strReservedAttribute]            NVARCHAR (MAX)   NULL,
    [idfsSampleType]                  BIGINT           NULL,
    [SourceSystemNameID]              BIGINT           NULL,
    [SourceSystemKeyValue]            NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tlbMonitoringSessionToDiagnosis] PRIMARY KEY CLUSTERED ([idfMonitoringSessionToDiagnosis] ASC),
    CONSTRAINT [FK_tlbMonitoringSessionToDiagnosis_tlbMonitoringSession__idfMonitoringSession_R_1750] FOREIGN KEY ([idfMonitoringSession]) REFERENCES [dbo].[tlbMonitoringSession] ([idfMonitoringSession]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMonitoringSessionToDiagnosis_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbMonitoringSessionToDiagnosis_trtDiagnosis__idfsDiagnosis_R_1757] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMonitoringSessionToDiagnosis_trtSampleType__idfsSampleType] FOREIGN KEY ([idfsSampleType]) REFERENCES [dbo].[trtSampleType] ([idfsSampleType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMonitoringSessionToDiagnosis_trtSpeciesType__idfsSpeciesType] FOREIGN KEY ([idfsSpeciesType]) REFERENCES [dbo].[trtSpeciesType] ([idfsSpeciesType]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tlbMonitoringSessionToDiagnosis_A_Update] ON [dbo].[tlbMonitoringSessionToDiagnosis]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfMonitoringSessionToDiagnosis))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbMonitoringSessionToDiagnosis_I_Delete] on [dbo].[tlbMonitoringSessionToDiagnosis]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfMonitoringSessionToDiagnosis]) as
		(
			SELECT [idfMonitoringSessionToDiagnosis] FROM deleted
			EXCEPT
			SELECT [idfMonitoringSessionToDiagnosis] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbMonitoringSessionToDiagnosis as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfMonitoringSessionToDiagnosis = b.idfMonitoringSessionToDiagnosis;

	END

END
