CREATE TABLE [dbo].[trtSpeciesContentInCustomReport] (
    [idfSpeciesContentInCustomReport] BIGINT           NOT NULL,
    [idfsCustomReportType]            BIGINT           NOT NULL,
    [idfsSpeciesOrSpeciesGroup]       BIGINT           NOT NULL,
    [idfsReportAdditionalText]        BIGINT           NULL,
    [intItemOrder]                    INT              CONSTRAINT [intItemOrder_trtSpeciesContentInCustomReport] DEFAULT ((0)) NOT NULL,
    [intNullValueInsteadZero]         INT              CONSTRAINT [intNullValueInsteadZero_trtSpeciesContentInCustomReport] DEFAULT ((0)) NOT NULL,
    [intRowStatus]                    INT              CONSTRAINT [Def_0_trtSpeciesContentInCustomReport] DEFAULT ((0)) NOT NULL,
    [rowguid]                         UNIQUEIDENTIFIER CONSTRAINT [newid_trtSpeciesContentInCustomReport] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]              NVARCHAR (20)    NULL,
    [strReservedAttribute]            NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]              BIGINT           NULL,
    [SourceSystemKeyValue]            NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtSpeciesContentInCustomReport] PRIMARY KEY CLUSTERED ([idfSpeciesContentInCustomReport] ASC),
    CONSTRAINT [FK_trtSpeciesContentInCustomReport_trtBaseReference_idfsCustomReportType] FOREIGN KEY ([idfsCustomReportType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSpeciesContentInCustomReport_trtBaseReference_idfsReportAdditionalText] FOREIGN KEY ([idfsReportAdditionalText]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSpeciesContentInCustomReport_trtBaseReference_idfsSpeciesOrSpeciesGroup] FOREIGN KEY ([idfsSpeciesOrSpeciesGroup]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSpeciesContentInCustomReport_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtSpeciesContentInCustomReport_A_Update] ON [dbo].[trtSpeciesContentInCustomReport]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSpeciesContentInCustomReport))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtSpeciesContentInCustomReport_I_Delete] on [dbo].[trtSpeciesContentInCustomReport]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfSpeciesContentInCustomReport]) as
		(
			SELECT [idfSpeciesContentInCustomReport] FROM deleted
			EXCEPT
			SELECT [idfSpeciesContentInCustomReport] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtSpeciesContentInCustomReport as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfSpeciesContentInCustomReport = b.idfSpeciesContentInCustomReport;

	END

END
