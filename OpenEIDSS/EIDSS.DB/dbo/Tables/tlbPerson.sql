CREATE TABLE [dbo].[tlbPerson] (
    [idfPerson]            BIGINT           NOT NULL,
    [idfsStaffPosition]    BIGINT           NULL,
    [idfInstitution]       BIGINT           NULL,
    [idfDepartment]        BIGINT           NULL,
    [strFamilyName]        NVARCHAR (200)   NULL,
    [strFirstName]         NVARCHAR (200)   NULL,
    [strSecondName]        NVARCHAR (200)   NULL,
    [strContactPhone]      NVARCHAR (200)   NULL,
    [strBarcode]           NVARCHAR (200)   NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1949] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [PersonalIDValue]      NVARCHAR (100)   NULL,
    [PersonalIDTypeID]     BIGINT           NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbPerson] PRIMARY KEY CLUSTERED ([idfPerson] ASC),
    CONSTRAINT [FK_tlbPerson_tlbDepartment__idfDepartment] FOREIGN KEY ([idfDepartment]) REFERENCES [dbo].[tlbDepartment] ([idfDepartment]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbPerson_tlbEmployee__idfPerson_R_1498] FOREIGN KEY ([idfPerson]) REFERENCES [dbo].[tlbEmployee] ([idfEmployee]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbPerson_tlbOffice__idfInstitution_R_1509] FOREIGN KEY ([idfInstitution]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbPerson_trtBaseReference__idfsStaffPosition_R_1511] FOREIGN KEY ([idfsStaffPosition]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbPerson_trtBaseReference_PersonalIDTypeID] FOREIGN KEY ([PersonalIDTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbPerson_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tlbPerson_A_Update] ON [dbo].[tlbPerson]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfPerson))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbPerson_I_Delete] on [dbo].[tlbPerson]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfPerson]) as
		(
			SELECT [idfPerson] FROM deleted
			EXCEPT
			SELECT [idfPerson] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbPerson as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfPerson = b.idfPerson;


		WITH cteOnlyDeletedRecords([idfPerson]) as
		(
			SELECT [idfPerson] FROM deleted
			EXCEPT
			SELECT [idfPerson] FROM inserted
		)
		
		DELETE a
		FROM dbo.tlbEmployee as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfEmployee = b.idfPerson;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Staff Persons (Officers)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPerson';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Officer identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPerson', @level2type = N'COLUMN', @level2name = N'idfPerson';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Staff position identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPerson', @level2type = N'COLUMN', @level2name = N'idfsStaffPosition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Institution identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPerson', @level2type = N'COLUMN', @level2name = N'idfInstitution';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Department identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPerson', @level2type = N'COLUMN', @level2name = N'idfDepartment';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Officer Last name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPerson', @level2type = N'COLUMN', @level2name = N'strFamilyName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Officer First name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPerson', @level2type = N'COLUMN', @level2name = N'strFirstName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Officer Middle name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPerson', @level2type = N'COLUMN', @level2name = N'strSecondName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Officer contact phone number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPerson', @level2type = N'COLUMN', @level2name = N'strContactPhone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Barcode (alphanumeric badge code)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbPerson', @level2type = N'COLUMN', @level2name = N'strBarcode';

