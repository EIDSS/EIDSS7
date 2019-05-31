CREATE TABLE [dbo].[trtTestTypeForCustomReport] (
    [idfTestTypeForCustomReport] BIGINT           NOT NULL,
    [idfsCustomReportType]       BIGINT           NOT NULL,
    [idfsTestName]               BIGINT           NOT NULL,
    [intRowOrder]                INT              CONSTRAINT [Def_trtTestTypeForCustomReport_intRowOrder] DEFAULT ((0)) NOT NULL,
    [intRowStatus]               INT              CONSTRAINT [Def_trtTestTypeForCustomReport_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                    UNIQUEIDENTIFIER CONSTRAINT [Def_trtTestTypeForCustomReport_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]         NVARCHAR (20)    NULL,
    [strReservedAttribute]       NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtTestTypeForCustomReport] PRIMARY KEY CLUSTERED ([idfTestTypeForCustomReport] ASC),
    CONSTRAINT [FK_trtTestTypeForCustomReport_trtBaseReference__idfsCustomReportType] FOREIGN KEY ([idfsCustomReportType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtTestTypeForCustomReport_trtBaseReference__idfsTestName] FOREIGN KEY ([idfsTestName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtTestTypeForCustomReport_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [UQ_trtTestTypeForCustomReport] UNIQUE NONCLUSTERED ([idfsCustomReportType] ASC, [idfsTestName] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_trtTestTypeForCustomReport_A_Update] ON [dbo].[trtTestTypeForCustomReport]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfTestTypeForCustomReport))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtTestTypeForCustomReport_I_Delete] on [dbo].[trtTestTypeForCustomReport]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([idfTestTypeForCustomReport]) as
		(
			SELECT [idfTestTypeForCustomReport] FROM deleted
			EXCEPT
			SELECT [idfTestTypeForCustomReport] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtTestTypeForCustomReport as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfTestTypeForCustomReport = b.idfTestTypeForCustomReport;

	END

END
