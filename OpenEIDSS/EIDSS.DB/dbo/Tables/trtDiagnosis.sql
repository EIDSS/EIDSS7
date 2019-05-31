CREATE TABLE [dbo].[trtDiagnosis] (
    [idfsDiagnosis]        BIGINT           NOT NULL,
    [idfsUsingType]        BIGINT           NOT NULL,
    [strIDC10]             NVARCHAR (200)   NULL,
    [strOIECode]           NVARCHAR (200)   NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1967] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1971] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [blnZoonotic]          BIT              DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [blnSyndrome]          BIT              NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtDiagnosis] PRIMARY KEY CLUSTERED ([idfsDiagnosis] ASC),
    CONSTRAINT [FK_trtDiagnosis_trtBaseReference__idfsDiagnosis_R_624] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDiagnosis_trtBaseReference__idfsUsingType_R_1600] FOREIGN KEY ([idfsUsingType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDiagnosis_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtDiagnosis_A_Update] ON [dbo].[trtDiagnosis]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsDiagnosis))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtDiagnosis_I_Delete] on [dbo].[trtDiagnosis]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsDiagnosis]) as
		(
			SELECT [idfsDiagnosis] FROM deleted
			EXCEPT
			SELECT [idfsDiagnosis] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtDiagnosis as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsDiagnosis = b.idfsDiagnosis;


		WITH cteOnlyDeletedRecords([idfsDiagnosis]) as
		(
			SELECT [idfsDiagnosis] FROM deleted
			EXCEPT
			SELECT [idfsDiagnosis] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsDiagnosis;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Diagnosis', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtDiagnosis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Diagnosis identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtDiagnosis', @level2type = N'COLUMN', @level2name = N'idfsDiagnosis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'IDC10 Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtDiagnosis', @level2type = N'COLUMN', @level2name = N'strIDC10';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'OIE Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtDiagnosis', @level2type = N'COLUMN', @level2name = N'strOIECode';

