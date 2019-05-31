CREATE TABLE [dbo].[trtDiagnosisAgeGroupToStatisticalAgeGroup] (
    [idfDiagnosisAgeGroupToStatisticalAgeGroup] BIGINT           NOT NULL,
    [idfsDiagnosisAgeGroup]                     BIGINT           NOT NULL,
    [idfsStatisticalAgeGroup]                   BIGINT           NULL,
    [intRowStatus]                              INT              CONSTRAINT [Def_0_trtDiagnsosisAgeGroupToStatisticalAgeGroup] DEFAULT ((0)) NOT NULL,
    [rowguid]                                   UNIQUEIDENTIFIER CONSTRAINT [newid_trtDiagnsosisAgeGroupToStatisticalAgeGroup] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]                        NVARCHAR (20)    NULL,
    [strReservedAttribute]                      NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]                        BIGINT           NULL,
    [SourceSystemKeyValue]                      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtDiagnosisAgeGroupToStatisticalAgeGroup] PRIMARY KEY CLUSTERED ([idfDiagnosisAgeGroupToStatisticalAgeGroup] ASC),
    CONSTRAINT [FK_trtDiagnosisAgeGroupToStatisticalAgeGroup_trtBaseReference_idfsStatisticalAgeGroup] FOREIGN KEY ([idfsStatisticalAgeGroup]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDiagnosisAgeGroupToStatisticalAgeGroup_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtDiagnosisAgeGroupToStatisticalAgeGroup_trtDiagnosisAgeGroup_idfsDiagnosisAgeGroup] FOREIGN KEY ([idfsDiagnosisAgeGroup]) REFERENCES [dbo].[trtDiagnosisAgeGroup] ([idfsDiagnosisAgeGroup]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtDiagnosisAgeGroupToStatisticalAgeGroup_A_Update] ON [dbo].[trtDiagnosisAgeGroupToStatisticalAgeGroup]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDiagnosisAgeGroupToStatisticalAgeGroup))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtDiagnosisAgeGroupToStatisticalAgeGroup_I_Delete] on [dbo].[trtDiagnosisAgeGroupToStatisticalAgeGroup]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfDiagnosisAgeGroupToStatisticalAgeGroup]) as
		(
			SELECT [idfDiagnosisAgeGroupToStatisticalAgeGroup] FROM deleted
			EXCEPT
			SELECT [idfDiagnosisAgeGroupToStatisticalAgeGroup] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtDiagnosisAgeGroupToStatisticalAgeGroup as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfDiagnosisAgeGroupToStatisticalAgeGroup = b.idfDiagnosisAgeGroupToStatisticalAgeGroup;

	END

END
