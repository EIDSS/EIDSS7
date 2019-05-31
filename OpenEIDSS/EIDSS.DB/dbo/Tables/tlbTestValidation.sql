CREATE TABLE [dbo].[tlbTestValidation] (
    [idfTestValidation]      BIGINT           NOT NULL,
    [idfsDiagnosis]          BIGINT           NULL,
    [idfsInterpretedStatus]  BIGINT           NULL,
    [idfValidatedByOffice]   BIGINT           NULL,
    [idfValidatedByPerson]   BIGINT           NULL,
    [idfInterpretedByOffice] BIGINT           NULL,
    [idfInterpretedByPerson] BIGINT           NULL,
    [idfTesting]             BIGINT           NOT NULL,
    [blnValidateStatus]      BIT              CONSTRAINT [Def_0___2719] DEFAULT ((0)) NULL,
    [blnCaseCreated]         BIT              CONSTRAINT [Def_0___2720] DEFAULT ((0)) NULL,
    [strValidateComment]     NVARCHAR (200)   NULL,
    [strInterpretedComment]  NVARCHAR (200)   NULL,
    [datValidationDate]      DATETIME         NULL,
    [datInterpretationDate]  DATETIME         NULL,
    [intRowStatus]           INT              CONSTRAINT [Def_0_2633] DEFAULT ((0)) NOT NULL,
    [rowguid]                UNIQUEIDENTIFIER CONSTRAINT [newid__2509] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [blnReadOnly]            BIT              DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]     NVARCHAR (20)    NULL,
    [strReservedAttribute]   NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    [AuditCreateUser]        NVARCHAR (200)   NULL,
    [AuditCreateDTM]         DATETIME         CONSTRAINT [DF_tlbTestValidation_AuditCreateDTM] DEFAULT (getdate()) NULL,
    [AuditUpdateUser]        NVARCHAR (200)   NULL,
    [AuditUpdateDTM]         DATETIME         NULL,
    CONSTRAINT [XPKtlbTestValidation] PRIMARY KEY CLUSTERED ([idfTestValidation] ASC),
    CONSTRAINT [FK_tlbTestValidation_tlbOffice__idfInterpretedByOffice_R_1550] FOREIGN KEY ([idfInterpretedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTestValidation_tlbOffice__idfValidatedByOffice_R_1548] FOREIGN KEY ([idfValidatedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTestValidation_tlbPerson__idfInterpretedByPerson_R_1551] FOREIGN KEY ([idfInterpretedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTestValidation_tlbPerson__idfValidatedByPerson_R_1549] FOREIGN KEY ([idfValidatedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTestValidation_tlbTesting__idfTesting_R_1546] FOREIGN KEY ([idfTesting]) REFERENCES [dbo].[tlbTesting] ([idfTesting]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTestValidation_trtBaseReference__idfsInterpretedStatus_R_1552] FOREIGN KEY ([idfsInterpretedStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTestValidation_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbTestValidation_trtDiagnosis__idfsDiagnosis_R_1547] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_tlbTestValidation_RT]
    ON [dbo].[tlbTestValidation]([intRowStatus] ASC, [idfTesting] ASC)
    INCLUDE([idfTestValidation], [idfsDiagnosis], [idfsInterpretedStatus], [idfValidatedByPerson], [idfInterpretedByPerson], [blnValidateStatus], [strValidateComment], [strInterpretedComment], [datValidationDate], [datInterpretationDate]);


GO


CREATE TRIGGER [dbo].[TR_tlbTestValidation_I_Delete] on [dbo].[tlbTestValidation]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfTestValidation]) as
		(
			SELECT [idfTestValidation] FROM deleted
			EXCEPT
			SELECT [idfTestValidation] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbTestValidation as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfTestValidation = b.idfTestValidation;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbTestValidation_A_Update] ON [dbo].[tlbTestValidation]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfTestValidation))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
