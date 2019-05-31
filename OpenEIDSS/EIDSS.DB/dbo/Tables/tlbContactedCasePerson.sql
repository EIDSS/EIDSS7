CREATE TABLE [dbo].[tlbContactedCasePerson] (
    [idfContactedCasePerson] BIGINT           NOT NULL,
    [idfsPersonContactType]  BIGINT           NOT NULL,
    [idfHuman]               BIGINT           NOT NULL,
    [idfHumanCase]           BIGINT           NOT NULL,
    [datDateOfLastContact]   DATETIME         NULL,
    [strPlaceInfo]           NVARCHAR (200)   NULL,
    [intRowStatus]           INT              CONSTRAINT [Def_0_2620] DEFAULT ((0)) NOT NULL,
    [rowguid]                UNIQUEIDENTIFIER CONSTRAINT [newid__2495] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strComments]            NVARCHAR (500)   NULL,
    [strMaintenanceFlag]     NVARCHAR (20)    NULL,
    [strReservedAttribute]   NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbContactedCasePerson] PRIMARY KEY CLUSTERED ([idfContactedCasePerson] ASC),
    CONSTRAINT [FK_tlbContactedCasePerson_tlbHuman__idfHuman_R_1460] FOREIGN KEY ([idfHuman]) REFERENCES [dbo].[tlbHuman] ([idfHuman]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbContactedCasePerson_tlbHumanCase__idfHumanCase_R_1461] FOREIGN KEY ([idfHumanCase]) REFERENCES [dbo].[tlbHumanCase] ([idfHumanCase]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbContactedCasePerson_trtBaseReference__idfsPersonContactType_R_1462] FOREIGN KEY ([idfsPersonContactType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbContactedCasePerson_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_tlbContactedCasePerson_I_Delete] on [dbo].[tlbContactedCasePerson]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfContactedCasePerson]) as
		(
			SELECT [idfContactedCasePerson] FROM deleted
			EXCEPT
			SELECT [idfContactedCasePerson] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbContactedCasePerson as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfContactedCasePerson = b.idfContactedCasePerson;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbContactedCasePerson_A_Update] ON [dbo].[tlbContactedCasePerson]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfContactedCasePerson))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
