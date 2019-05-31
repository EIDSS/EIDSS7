CREATE TABLE [dbo].[trtReportDiagnosisGroup] (
    [idfsReportDiagnosisGroup] BIGINT           NOT NULL,
    [strCode]                  NVARCHAR (200)   NULL,
    [intRowStatus]             INT              CONSTRAINT [Def_0_2768] DEFAULT ((0)) NOT NULL,
    [strDiagnosisGroupAlias]   VARCHAR (50)     NULL,
    [rowguid]                  UNIQUEIDENTIFIER CONSTRAINT [newid_trtReportDiagnosisGroup] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]       NVARCHAR (20)    NULL,
    [strReservedAttribute]     NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]       BIGINT           NULL,
    [SourceSystemKeyValue]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtReportDiagnosisGroup] PRIMARY KEY CLUSTERED ([idfsReportDiagnosisGroup] ASC),
    CONSTRAINT [FK_trtReportDiagnosisGroup_trtBaseReference__idfsReportDiagnosisGroup] FOREIGN KEY ([idfsReportDiagnosisGroup]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtReportDiagnosisGroup_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_trtReportDiagnosisGroup_I_Delete] on [dbo].[trtReportDiagnosisGroup]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN
		
		WITH cteOnlyDeletedRecords([idfsReportDiagnosisGroup]) as
		(
			SELECT [idfsReportDiagnosisGroup] FROM deleted
			EXCEPT
			SELECT [idfsReportDiagnosisGroup] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtReportDiagnosisGroup as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsReportDiagnosisGroup = b.idfsReportDiagnosisGroup;


		WITH cteOnlyDeletedRecords([idfsReportDiagnosisGroup]) as
		(
			SELECT [idfsReportDiagnosisGroup] FROM deleted
			EXCEPT
			SELECT [idfsReportDiagnosisGroup] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsReportDiagnosisGroup;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtReportDiagnosisGroup_A_Update] ON [dbo].[trtReportDiagnosisGroup]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsReportDiagnosisGroup))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
