CREATE TABLE [dbo].[tlbPensideTest] (
    [idfPensideTest]          BIGINT           NOT NULL,
    [idfMaterial]             BIGINT           NOT NULL,
    [idfsPensideTestResult]   BIGINT           NULL,
    [idfsPensideTestName]     BIGINT           NULL,
    [intRowStatus]            INT              CONSTRAINT [Def_0_2456] DEFAULT ((0)) NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid__2423] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfTestedByPerson]       BIGINT           NULL,
    [idfTestedByOffice]       BIGINT           NULL,
    [idfsDiagnosis]           BIGINT           NULL,
    [datTestDate]             DATETIME         NULL,
    [idfsPensideTestCategory] BIGINT           NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbPensideTest] PRIMARY KEY CLUSTERED ([idfPensideTest] ASC),
    CONSTRAINT [FK_tlbPensideTest_tlbMaterial__idfMaterial_R_1664] FOREIGN KEY ([idfMaterial]) REFERENCES [dbo].[tlbMaterial] ([idfMaterial]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbPensideTest_tlbOffice_idfTestedByOffice] FOREIGN KEY ([idfTestedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbPensideTest_tlbPerson_idfTestedByPerson] FOREIGN KEY ([idfTestedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbPensideTest_trtBaseReference__idfsPensideTestCategory] FOREIGN KEY ([idfsPensideTestCategory]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbPensideTest_trtBaseReference__idfsPensideTestName] FOREIGN KEY ([idfsPensideTestName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbPensideTest_trtBaseReference__idfsPensideTestResult_R_1573] FOREIGN KEY ([idfsPensideTestResult]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbPensideTest_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbPensideTest_trtDiagnosis_idfsDiagnosis] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_tlbPensideTest_I_Delete] on [dbo].[tlbPensideTest]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfPensideTest]) as
		(
			SELECT [idfPensideTest] FROM deleted
			EXCEPT
			SELECT [idfPensideTest] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbPensideTest as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfPensideTest = b.idfPensideTest;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbPensideTest_A_Update] ON [dbo].[tlbPensideTest]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfPensideTest))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Penside tests', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPensideTest';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Penside test identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPensideTest', @level2type = N'COLUMN', @level2name = N'idfPensideTest';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Penside test result identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPensideTest', @level2type = N'COLUMN', @level2name = N'idfsPensideTestResult';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Penside test type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPensideTest', @level2type = N'COLUMN', @level2name = N'idfsPensideTestName';

