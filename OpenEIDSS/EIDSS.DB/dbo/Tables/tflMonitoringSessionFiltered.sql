CREATE TABLE [dbo].[tflMonitoringSessionFiltered] (
    [idfMonitoringSessionFiltered] BIGINT           NOT NULL,
    [idfMonitoringSession]         BIGINT           NOT NULL,
    [idfSiteGroup]                 BIGINT           NOT NULL,
    [rowguid]                      UNIQUEIDENTIFIER CONSTRAINT [newid__2566] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtflMonitoringSessionFiltered] PRIMARY KEY CLUSTERED ([idfMonitoringSessionFiltered] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tflMonitoringSessionFiltered_tflSiteGroup__idfSiteGroup] FOREIGN KEY ([idfSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflMonitoringSessionFiltered_tlbMonitoringSession__idfMonitoringSession_R_1819] FOREIGN KEY ([idfMonitoringSession]) REFERENCES [dbo].[tlbMonitoringSession] ([idfMonitoringSession]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflMonitoringSessionFiltered_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [tflMonitoringSessionFiltered_idfMonitoringSession_idfSiteGroup]
    ON [dbo].[tflMonitoringSessionFiltered]([idfMonitoringSession] ASC, [idfSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflMonitoringSessionFiltered_A_Update] ON [dbo].[tflMonitoringSessionFiltered]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfMonitoringSessionFiltered))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
