CREATE TABLE [dbo].[trtMaterialForDisease] (
    [idfMaterialForDisease] BIGINT           NOT NULL,
    [idfsSampleType]        BIGINT           NULL,
    [idfsDiagnosis]         BIGINT           NOT NULL,
    [intRecommendedQty]     INT              NULL,
    [intRowStatus]          INT              CONSTRAINT [Def_0_2013] DEFAULT ((0)) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__2016] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtMaterialForDisease] PRIMARY KEY CLUSTERED ([idfMaterialForDisease] ASC),
    CONSTRAINT [FK_trtMaterialForDisease_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtMaterialForDisease_trtDiagnosis__idfsDiagnosis_R_891] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtMaterialForDisease_trtSampleType__idfsSampleType] FOREIGN KEY ([idfsSampleType]) REFERENCES [dbo].[trtSampleType] ([idfsSampleType]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtMaterialForDisease_A_Update] ON [dbo].[trtMaterialForDisease]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfMaterialForDisease))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtMaterialForDisease_I_Delete] on [dbo].[trtMaterialForDisease]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfMaterialForDisease]) as
		(
			SELECT [idfMaterialForDisease] FROM deleted
			EXCEPT
			SELECT [idfMaterialForDisease] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtMaterialForDisease as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfMaterialForDisease = b.idfMaterialForDisease;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Samples recommended for collection in case of a certain diagnosis', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtMaterialForDisease';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Specimen type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtMaterialForDisease', @level2type = N'COLUMN', @level2name = N'idfsSampleType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Diagnosis identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtMaterialForDisease', @level2type = N'COLUMN', @level2name = N'idfsDiagnosis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Recommended Quantity', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtMaterialForDisease', @level2type = N'COLUMN', @level2name = N'intRecommendedQty';

