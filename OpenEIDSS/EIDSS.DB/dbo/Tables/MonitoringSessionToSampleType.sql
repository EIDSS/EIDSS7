CREATE TABLE [dbo].[MonitoringSessionToSampleType] (
    [MonitoringSessionToSampleType] BIGINT           NOT NULL,
    [idfMonitoringSession]          BIGINT           NOT NULL,
    [idfsSpeciesType]               BIGINT           NULL,
    [idfsSampleType]                BIGINT           NULL,
    [intOrder]                      INT              CONSTRAINT [DF__Monitorin__intOr__1D871874] DEFAULT ((0)) NOT NULL,
    [intRowStatus]                  INT              CONSTRAINT [DF__Monitorin__intRo__1E7B3CAD] DEFAULT ((0)) NOT NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [DF__Monitorin__rowgu__1F6F60E6] DEFAULT (newid()) NOT NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [strReservedAttribute]          NVARCHAR (MAX)   NULL,
    [AuditCreateUser]               VARCHAR (100)    CONSTRAINT [DF__Monitorin__Audit__2063851F] DEFAULT (user_name()) NOT NULL,
    [AuditCreateDTM]                DATETIME         CONSTRAINT [DF__Monitorin__Audit__2157A958] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]               VARCHAR (100)    CONSTRAINT [DF__Monitorin__Audit__224BCD91] DEFAULT (user_name()) NOT NULL,
    [AuditUpdateDTM]                DATETIME         CONSTRAINT [DF__Monitorin__Audit__233FF1CA] DEFAULT (getdate()) NOT NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKMonitoringSessionToSampleType] PRIMARY KEY CLUSTERED ([MonitoringSessionToSampleType] ASC),
    CONSTRAINT [FK_MonitoringSessionToSampleType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbMonitoringSessionToSampleType_tlbMonitoringSession_MonitoringSessionID] FOREIGN KEY ([idfMonitoringSession]) REFERENCES [dbo].[tlbMonitoringSession] ([idfMonitoringSession]),
    CONSTRAINT [FK_tlbMonitoringSessionToSampleType_trtSampleType_SampleType] FOREIGN KEY ([idfsSampleType]) REFERENCES [dbo].[trtSampleType] ([idfsSampleType]),
    CONSTRAINT [FK_tlbMonitoringSessionToSampleType_trtSpeciesType_SpeciesType] FOREIGN KEY ([idfsSpeciesType]) REFERENCES [dbo].[trtSpeciesType] ([idfsSpeciesType])
);


GO


CREATE TRIGGER [dbo].[TR_MonitoringSessionToSampleType_I_Delete] on [dbo].[MonitoringSessionToSampleType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([MonitoringSessionToSampleType]) as
		(
			SELECT [MonitoringSessionToSampleType] FROM deleted
			EXCEPT
			SELECT [MonitoringSessionToSampleType] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			AuditUpdateUser = SYSTEM_USER,
			AuditUpdateDTM = GETDATE()
		FROM dbo.[MonitoringSessionToSampleType] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[MonitoringSessionToSampleType] = b.[MonitoringSessionToSampleType];

	END

END

GO

CREATE TRIGGER [dbo].[TR_MonitoringSessionToSampleType_A_Update] ON [dbo].[MonitoringSessionToSampleType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(MonitoringSessionToSampleType)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
