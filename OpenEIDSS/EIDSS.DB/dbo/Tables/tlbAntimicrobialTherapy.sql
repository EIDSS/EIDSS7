CREATE TABLE [dbo].[tlbAntimicrobialTherapy] (
    [idfAntimicrobialTherapy]     BIGINT           NOT NULL,
    [idfHumanCase]                BIGINT           NOT NULL,
    [datFirstAdministeredDate]    DATETIME         NULL,
    [strAntimicrobialTherapyName] NVARCHAR (200)   NULL,
    [strDosage]                   NVARCHAR (200)   NULL,
    [intRowStatus]                INT              CONSTRAINT [Def_0_2490] DEFAULT ((0)) NOT NULL,
    [rowguid]                     UNIQUEIDENTIFIER CONSTRAINT [newid__2464] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]          NVARCHAR (20)    NULL,
    [strReservedAttribute]        NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]          BIGINT           NULL,
    [SourceSystemKeyValue]        NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbAntimicrobialTherapy] PRIMARY KEY CLUSTERED ([idfAntimicrobialTherapy] ASC),
    CONSTRAINT [FK_tlbAntimicrobialTherapy_tlbHumanCase__idfHumanCase_R_1422] FOREIGN KEY ([idfHumanCase]) REFERENCES [dbo].[tlbHumanCase] ([idfHumanCase]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAntimicrobialTherapy_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tlbAntimicrobialTherapy_A_Update] ON [dbo].[tlbAntimicrobialTherapy]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfAntimicrobialTherapy))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbAntimicrobialTherapy_I_Delete] on [dbo].[tlbAntimicrobialTherapy]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfAntimicrobialTherapy]) as
		(
			SELECT [idfAntimicrobialTherapy] FROM deleted
			EXCEPT
			SELECT [idfAntimicrobialTherapy] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbAntimicrobialTherapy as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfAntimicrobialTherapy = b.idfAntimicrobialTherapy;

	END

END
