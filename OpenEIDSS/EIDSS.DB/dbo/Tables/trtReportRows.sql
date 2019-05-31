CREATE TABLE [dbo].[trtReportRows] (
    [idfsCustomReportType]                BIGINT           NOT NULL,
    [idfsDiagnosisOrReportDiagnosisGroup] BIGINT           NOT NULL,
    [intRowOrder]                         INT              CONSTRAINT [Def_0_2759] DEFAULT ((0)) NOT NULL,
    [intRowStatus]                        INT              CONSTRAINT [Def_0_2760] DEFAULT ((0)) NOT NULL,
    [rowguid]                             UNIQUEIDENTIFIER CONSTRAINT [newid__2604] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfsReportAdditionalText]            BIGINT           NULL,
    [idfsICDReportAdditionalText]         BIGINT           NULL,
    [intNullValueInsteadZero]             INT              CONSTRAINT [Def_trtReportRows_intNullValueInsteadZero] DEFAULT ((0)) NOT NULL,
    [idfReportRows]                       BIGINT           NOT NULL,
    [strMaintenanceFlag]                  NVARCHAR (20)    NULL,
    [strReservedAttribute]                NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]                  BIGINT           NULL,
    [SourceSystemKeyValue]                NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_trtReportRows] PRIMARY KEY CLUSTERED ([idfReportRows] ASC),
    CONSTRAINT [FK_trtReportRows_trtBaseReference__idfsCustomReportType_R_1867] FOREIGN KEY ([idfsCustomReportType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtReportRows_trtBaseReference__idfsDiagnosisOrReportDiagnosisGroup] FOREIGN KEY ([idfsDiagnosisOrReportDiagnosisGroup]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtReportRows_trtBaseReference__idfsICDReportAdditionalText] FOREIGN KEY ([idfsICDReportAdditionalText]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtReportRows_trtBaseReference__idfsReportAdditionalText_R_1895] FOREIGN KEY ([idfsReportAdditionalText]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtReportRows_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [UK_trtReportRows__idfsCustomReportType_idfsDiagnosisOrReportDiagnosisGroup] UNIQUE NONCLUSTERED ([idfsCustomReportType] ASC, [idfsDiagnosisOrReportDiagnosisGroup] ASC)
);


GO


CREATE TRIGGER [dbo].[TR_trtReportRows_I_Delete] on [dbo].[trtReportRows]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfReportRows]) as
		(
			SELECT [idfReportRows] FROM deleted
			EXCEPT
			SELECT [idfReportRows] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtReportRows as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfReportRows = b.idfReportRows;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtReportRows_A_Update] ON [dbo].[trtReportRows]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfReportRows))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
