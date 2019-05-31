CREATE TABLE [dbo].[trtSampleType] (
    [idfsSampleType]       BIGINT           NOT NULL,
    [strSampleCode]        NVARCHAR (50)    NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2732] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2593] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtSampleType] PRIMARY KEY CLUSTERED ([idfsSampleType] ASC),
    CONSTRAINT [FK_trtSampleType_trtBaseReference__idfsSampleType_R_1866] FOREIGN KEY ([idfsSampleType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSampleType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_trtSampleType_I_Delete] on [dbo].[trtSampleType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsSampleType]) as
		(
			SELECT [idfsSampleType] FROM deleted
			EXCEPT
			SELECT [idfsSampleType] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtSampleType as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsSampleType = b.idfsSampleType;


		WITH cteOnlyDeletedRecords([idfsSampleType]) as
		(
			SELECT [idfsSampleType] FROM deleted
			EXCEPT
			SELECT [idfsSampleType] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsSampleType;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtSampleType_A_Update] ON [dbo].[trtSampleType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsSampleType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
