CREATE TABLE [dbo].[trtCaseClassification] (
    [idfsCaseClassification]            BIGINT           NOT NULL,
    [blnInitialHumanCaseClassification] BIT              NULL,
    [rowguid]                           UNIQUEIDENTIFIER CONSTRAINT [trtCaseClassification_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]                      INT              CONSTRAINT [trtCaseClassification_intRowStatus] DEFAULT ((0)) NOT NULL,
    [blnFinalHumanCaseClassification]   BIT              NULL,
    [strMaintenanceFlag]                NVARCHAR (20)    NULL,
    [strReservedAttribute]              NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]                BIGINT           NULL,
    [SourceSystemKeyValue]              NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtCaseClassification] PRIMARY KEY CLUSTERED ([idfsCaseClassification] ASC),
    CONSTRAINT [FK_trtCaseClassification_trtBaseReference__idfsCaseClassification] FOREIGN KEY ([idfsCaseClassification]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtCaseClassification_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtCaseClassification_A_Update] ON [dbo].[trtCaseClassification]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsCaseClassification))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
