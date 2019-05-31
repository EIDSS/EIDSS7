CREATE TABLE [dbo].[trtFFObjectForCustomReport] (
    [idfFFObjectForCustomReport] BIGINT           NOT NULL,
    [idfsCustomReportType]       BIGINT           NOT NULL,
    [strFFObjectAlias]           VARCHAR (50)     NOT NULL,
    [idfsFFObject]               BIGINT           NOT NULL,
    [intRowStatus]               INT              CONSTRAINT [DF__trtFFPara__intRo__3F7E063D] DEFAULT ((0)) NOT NULL,
    [rowguid]                    UNIQUEIDENTIFIER CONSTRAINT [DF__trtFFPara__rowgu__40722A76] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]         NVARCHAR (20)    NULL,
    [strReservedAttribute]       NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_trtFFObjectForCustomReport] PRIMARY KEY CLUSTERED ([idfFFObjectForCustomReport] ASC),
    CONSTRAINT [FK_trtFFObjectForCustomReport_trtBaseReference] FOREIGN KEY ([idfsCustomReportType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtFFObjectForCustomReport_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [UQ_trtFFObjectForCustomReport] UNIQUE NONCLUSTERED ([idfsCustomReportType] ASC, [strFFObjectAlias] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_trtFFObjectForCustomReport_A_Update] ON [dbo].[trtFFObjectForCustomReport]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfFFObjectForCustomReport))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtFFObjectForCustomReport_I_Delete] on [dbo].[trtFFObjectForCustomReport]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfFFObjectForCustomReport]) as
		(
			SELECT [idfFFObjectForCustomReport] FROM deleted
			EXCEPT
			SELECT [idfFFObjectForCustomReport] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtFFObjectForCustomReport as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfFFObjectForCustomReport = b.idfFFObjectForCustomReport;

	END

END
