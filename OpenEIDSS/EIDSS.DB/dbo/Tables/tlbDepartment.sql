CREATE TABLE [dbo].[tlbDepartment] (
    [idfDepartment]        BIGINT           NOT NULL,
    [idfsDepartmentName]   BIGINT           NOT NULL,
    [idfOrganization]      BIGINT           NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [tlbDepartment_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [tlbDepartment_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbDepartment] PRIMARY KEY CLUSTERED ([idfDepartment] ASC),
    CONSTRAINT [FK_tlbDepartment_tlbOffice__idfOrganization] FOREIGN KEY ([idfOrganization]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbDepartment_trtBaseReference__idfsDepartmentName] FOREIGN KEY ([idfsDepartmentName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbDepartment_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_tlbDepartment_I_Delete] on [dbo].[tlbDepartment]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfDepartment]) as
		(
			SELECT [idfDepartment] FROM deleted
			EXCEPT
			SELECT [idfDepartment] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbDepartment as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfDepartment = b.idfDepartment;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbDepartment_A_Update] ON [dbo].[tlbDepartment]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDepartment))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
