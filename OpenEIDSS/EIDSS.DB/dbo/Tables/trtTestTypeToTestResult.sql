CREATE TABLE [dbo].[trtTestTypeToTestResult] (
    [idfsTestName]         BIGINT           NOT NULL,
    [idfsTestResult]       BIGINT           NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2022] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2025] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [blnIndicative]        BIT              NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtTestTypeToTestResult] PRIMARY KEY CLUSTERED ([idfsTestName] ASC, [idfsTestResult] ASC),
    CONSTRAINT [FK_trtTestTypeToTestResult_trtBaseReference__idfsTestName] FOREIGN KEY ([idfsTestName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtTestTypeToTestResult_trtBaseReference__idfsTestResult_R_1596] FOREIGN KEY ([idfsTestResult]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtTestTypeToTestResult_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtTestTypeToTestResult_A_Update] ON [dbo].[trtTestTypeToTestResult]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsTestName) OR UPDATE(idfsTestResult)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtTestTypeToTestResult_I_Delete] on [dbo].[trtTestTypeToTestResult]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsTestName], [idfsTestResult]) as
		(
			SELECT [idfsTestName], [idfsTestResult] FROM deleted
			EXCEPT
			SELECT [idfsTestName], [idfsTestResult] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtTestTypeToTestResult as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsTestName = b.idfsTestName
			AND a.idfsTestResult = b.idfsTestResult


	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Test type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestTypeToTestResult', @level2type = N'COLUMN', @level2name = N'idfsTestName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Test Result identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestTypeToTestResult', @level2type = N'COLUMN', @level2name = N'idfsTestResult';

