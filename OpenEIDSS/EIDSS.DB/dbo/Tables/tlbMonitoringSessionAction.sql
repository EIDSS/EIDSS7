CREATE TABLE [dbo].[tlbMonitoringSessionAction] (
    [idfMonitoringSessionAction]        BIGINT           NOT NULL,
    [idfMonitoringSession]              BIGINT           NOT NULL,
    [idfPersonEnteredBy]                BIGINT           NOT NULL,
    [idfsMonitoringSessionActionType]   BIGINT           NOT NULL,
    [idfsMonitoringSessionActionStatus] BIGINT           NOT NULL,
    [datActionDate]                     DATETIME         NULL,
    [strComments]                       NVARCHAR (500)   NULL,
    [intRowStatus]                      INT              CONSTRAINT [Def_0_2668] DEFAULT ((0)) NOT NULL,
    [rowguid]                           UNIQUEIDENTIFIER CONSTRAINT [newid__2558] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]                NVARCHAR (20)    NULL,
    [strReservedAttribute]              NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]                BIGINT           NULL,
    [SourceSystemKeyValue]              NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbMonitoringSessionAction] PRIMARY KEY CLUSTERED ([idfMonitoringSessionAction] ASC),
    CONSTRAINT [FK_tlbMonitoringSessionAction_tlbMonitoringSession__idfMonitoringSession_R_1833] FOREIGN KEY ([idfMonitoringSession]) REFERENCES [dbo].[tlbMonitoringSession] ([idfMonitoringSession]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMonitoringSessionAction_tlbPerson__idfPersonEnteredBy_R_1836] FOREIGN KEY ([idfPersonEnteredBy]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMonitoringSessionAction_trtBaseReference__idfsMonitoringSessionActionStatus_R_1835] FOREIGN KEY ([idfsMonitoringSessionActionStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMonitoringSessionAction_trtBaseReference__idfsMonitoringSessionActionType_R_1834] FOREIGN KEY ([idfsMonitoringSessionActionType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMonitoringSessionAction_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tlbMonitoringSessionAction_A_Update] ON [dbo].[tlbMonitoringSessionAction]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfMonitoringSessionAction))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbMonitoringSessionAction_I_Delete] on [dbo].[tlbMonitoringSessionAction]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfMonitoringSessionAction]) as
		(
			SELECT [idfMonitoringSessionAction] FROM deleted
			EXCEPT
			SELECT [idfMonitoringSessionAction] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbMonitoringSessionAction as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfMonitoringSessionAction = b.idfMonitoringSessionAction;

	END

END
