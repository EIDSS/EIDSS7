CREATE TABLE [dbo].[trtTestForDisease] (
    [idfTestForDisease]    BIGINT           NOT NULL,
    [idfsTestCategory]     BIGINT           NULL,
    [idfsTestName]         BIGINT           NULL,
    [idfsSampleType]       BIGINT           NULL,
    [idfsDiagnosis]        BIGINT           NOT NULL,
    [intRecommendedQty]    INT              NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2021] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2024] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtTestForDisease] PRIMARY KEY CLUSTERED ([idfTestForDisease] ASC),
    CONSTRAINT [FK_trtTestForDisease_trtBaseReference__idfsTestCategory] FOREIGN KEY ([idfsTestCategory]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtTestForDisease_trtBaseReference__idfsTestName] FOREIGN KEY ([idfsTestName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtTestForDisease_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtTestForDisease_trtDiagnosis__idfsDiagnosis_R_892] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtTestForDisease_trtSampleType__idfsSampleType] FOREIGN KEY ([idfsSampleType]) REFERENCES [dbo].[trtSampleType] ([idfsSampleType]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_trtTestForDisease_I_Delete] on [dbo].[trtTestForDisease]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([idfTestForDisease]) as
		(
			SELECT [idfTestForDisease] FROM deleted
			EXCEPT
			SELECT [idfTestForDisease] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtTestForDisease as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfTestForDisease = b.idfTestForDisease;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtTestForDisease_A_Update] ON [dbo].[trtTestForDisease]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfTestForDisease))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Tests recommended for a certain diagnosis', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestForDisease';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Test for disease identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestForDisease', @level2type = N'COLUMN', @level2name = N'idfTestForDisease';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Test for disease type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestForDisease', @level2type = N'COLUMN', @level2name = N'idfsTestCategory';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Test type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestForDisease', @level2type = N'COLUMN', @level2name = N'idfsTestName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Specimen type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestForDisease', @level2type = N'COLUMN', @level2name = N'idfsSampleType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Diagnosis identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestForDisease', @level2type = N'COLUMN', @level2name = N'idfsDiagnosis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Recommended Quantity', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestForDisease', @level2type = N'COLUMN', @level2name = N'intRecommendedQty';

