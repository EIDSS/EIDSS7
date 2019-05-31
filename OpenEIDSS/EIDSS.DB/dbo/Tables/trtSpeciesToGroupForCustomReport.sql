CREATE TABLE [dbo].[trtSpeciesToGroupForCustomReport] (
    [idfSpeciesToGroupForCustomReport] BIGINT           NOT NULL,
    [idfsCustomReportType]             BIGINT           NOT NULL,
    [idfsSpeciesGroup]                 BIGINT           NOT NULL,
    [idfsSpeciesType]                  BIGINT           NOT NULL,
    [intRowStatus]                     INT              CONSTRAINT [Def_0_trtSpeciesToGroupForCustomReport] DEFAULT ((0)) NOT NULL,
    [rowguid]                          UNIQUEIDENTIFIER CONSTRAINT [newid_trtSpeciesToGroupForCustomReport] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]               NVARCHAR (20)    NULL,
    [strReservedAttribute]             NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]               BIGINT           NULL,
    [SourceSystemKeyValue]             NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtSpeciesToGroupForCustomReport] PRIMARY KEY CLUSTERED ([idfSpeciesToGroupForCustomReport] ASC),
    CONSTRAINT [FK_trtSpeciesToGroupForCustomReport_trtBaseReference_idfsCustomReportType] FOREIGN KEY ([idfsCustomReportType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSpeciesToGroupForCustomReport_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtSpeciesToGroupForCustomReport_trtSpeciesGroup_idfsSpeciesGroup] FOREIGN KEY ([idfsSpeciesGroup]) REFERENCES [dbo].[trtSpeciesGroup] ([idfsSpeciesGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSpeciesToGroupForCustomReport_trtSpeciesType_idfsSpeciesType] FOREIGN KEY ([idfsSpeciesType]) REFERENCES [dbo].[trtSpeciesType] ([idfsSpeciesType]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_trtSpeciesToGroupForCustomReport_I_Delete] on [dbo].[trtSpeciesToGroupForCustomReport]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([idfSpeciesToGroupForCustomReport]) as
		(
			SELECT [idfSpeciesToGroupForCustomReport] FROM deleted
			EXCEPT
			SELECT [idfSpeciesToGroupForCustomReport] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtSpeciesToGroupForCustomReport as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfSpeciesToGroupForCustomReport = b.idfSpeciesToGroupForCustomReport;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtSpeciesToGroupForCustomReport_A_Update] ON [dbo].[trtSpeciesToGroupForCustomReport]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSpeciesToGroupForCustomReport))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
