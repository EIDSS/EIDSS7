CREATE TABLE [dbo].[trtDiagnosisAgeGroup] (
    [idfsDiagnosisAgeGroup] BIGINT           NOT NULL,
    [intLowerBoundary]      INT              NOT NULL,
    [intUpperBoundary]      INT              NULL,
    [idfsAgeType]           BIGINT           NOT NULL,
    [intRowStatus]          INT              CONSTRAINT [Def_0_trtDiagnosisAgeGroup] DEFAULT ((0)) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid_trtDiagnosisAgeGroup] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtDiagnosisAgeGroup] PRIMARY KEY CLUSTERED ([idfsDiagnosisAgeGroup] ASC),
    CONSTRAINT [FK_trtDiagnosisAgeGroup_trtBaseReference_idfsAgeType] FOREIGN KEY ([idfsAgeType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDiagnosisAgeGroup_trtBaseReference_idfsDiagnosisAgeGroup] FOREIGN KEY ([idfsDiagnosisAgeGroup]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDiagnosisAgeGroup_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_trtDiagnosisAgeGroup_I_Delete] on [dbo].[trtDiagnosisAgeGroup]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsDiagnosisAgeGroup]) as
		(
			SELECT [idfsDiagnosisAgeGroup] FROM deleted
			EXCEPT
			SELECT [idfsDiagnosisAgeGroup] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtDiagnosisAgeGroup as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsDiagnosisAgeGroup = b.idfsDiagnosisAgeGroup;


		WITH cteOnlyDeletedRecords([idfsDiagnosisAgeGroup]) as
		(
			SELECT [idfsDiagnosisAgeGroup] FROM deleted
			EXCEPT
			SELECT [idfsDiagnosisAgeGroup] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsDiagnosisAgeGroup;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtDiagnosisAgeGroup_A_Update] ON [dbo].[trtDiagnosisAgeGroup]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsDiagnosisAgeGroup))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
