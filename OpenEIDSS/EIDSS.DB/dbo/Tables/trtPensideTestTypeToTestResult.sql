CREATE TABLE [dbo].[trtPensideTestTypeToTestResult] (
    [idfsPensideTestName]   BIGINT           NOT NULL,
    [idfsPensideTestResult] BIGINT           NOT NULL,
    [intRowStatus]          INT              CONSTRAINT [Def_0_2457] DEFAULT ((0)) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__2424] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [blnIndicative]         BIT              NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtPensideTestTypeToTestResult] PRIMARY KEY CLUSTERED ([idfsPensideTestName] ASC, [idfsPensideTestResult] ASC),
    CONSTRAINT [FK_trtPensideTestTypeToTestResult_trtBaseReference__idfsPensideTestName] FOREIGN KEY ([idfsPensideTestName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtPensideTestTypeToTestResult_trtBaseReference__idfsPensideTestResult_R_1663] FOREIGN KEY ([idfsPensideTestResult]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtPensideTestTypeToTestResult_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_trtPensideTestTypeToTestResult_I_Delete] on [dbo].[trtPensideTestTypeToTestResult]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsPensideTestName], [idfsPensideTestResult]) as
		(
			SELECT [idfsPensideTestName], [idfsPensideTestResult] FROM deleted
			EXCEPT
			SELECT [idfsPensideTestName], [idfsPensideTestResult] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtPensideTestTypeToTestResult as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsPensideTestName = b.idfsPensideTestName
			AND a.idfsPensideTestResult = b.idfsPensideTestResult;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtPensideTestTypeToTestResult_A_Update] ON [dbo].[trtPensideTestTypeToTestResult]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsPensideTestName) OR UPDATE(idfsPensideTestResult)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
