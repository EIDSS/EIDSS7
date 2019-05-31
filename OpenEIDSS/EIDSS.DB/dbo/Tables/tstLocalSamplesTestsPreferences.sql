CREATE TABLE [dbo].[tstLocalSamplesTestsPreferences] (
    [idfSamplesTestsPreferences] BIGINT           NOT NULL,
    [idfMaterial]                BIGINT           NOT NULL,
    [idfTesting]                 BIGINT           NULL,
    [idfUserID]                  BIGINT           NOT NULL,
    [rowguid]                    UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstLocalSamplesTestsPreferences] PRIMARY KEY CLUSTERED ([idfSamplesTestsPreferences] ASC),
    CONSTRAINT [FK_tstLocalSamplesTestsPreferences_tlbMaterial__idfMaterial] FOREIGN KEY ([idfMaterial]) REFERENCES [dbo].[tlbMaterial] ([idfMaterial]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstLocalSamplesTestsPreferences_tlbTesting__idfTesting] FOREIGN KEY ([idfTesting]) REFERENCES [dbo].[tlbTesting] ([idfTesting]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstLocalSamplesTestsPreferences_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstLocalSamplesTestsPreferences_tstUserTable__idfUserID] FOREIGN KEY ([idfUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstLocalSamplesTestsPreferences_A_Update] ON [dbo].[tstLocalSamplesTestsPreferences]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfSamplesTestsPreferences]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
