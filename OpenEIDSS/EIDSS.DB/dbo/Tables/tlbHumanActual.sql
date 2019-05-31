CREATE TABLE [dbo].[tlbHumanActual] (
    [idfHumanActual]             BIGINT           NOT NULL,
    [idfsOccupationType]         BIGINT           NULL,
    [idfsNationality]            BIGINT           NULL,
    [idfsHumanGender]            BIGINT           NULL,
    [idfCurrentResidenceAddress] BIGINT           NULL,
    [idfEmployerAddress]         BIGINT           NULL,
    [idfRegistrationAddress]     BIGINT           NULL,
    [datDateofBirth]             DATETIME         NULL,
    [datDateOfDeath]             DATETIME         NULL,
    [strLastName]                NVARCHAR (200)   NOT NULL,
    [strSecondName]              NVARCHAR (200)   NULL,
    [strFirstName]               NVARCHAR (200)   NULL,
    [strRegistrationPhone]       NVARCHAR (200)   NULL,
    [strEmployerName]            NVARCHAR (200)   NULL,
    [strHomePhone]               NVARCHAR (200)   NULL,
    [strWorkPhone]               NVARCHAR (200)   NULL,
    [rowguid]                    UNIQUEIDENTIFIER CONSTRAINT [newid__19892] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]               INT              CONSTRAINT [tlbHumanActual_intRowStatus] DEFAULT ((0)) NOT NULL,
    [idfsPersonIDType]           BIGINT           NULL,
    [strPersonID]                NVARCHAR (100)   NULL,
    [datEnteredDate]             DATETIME         CONSTRAINT [tlbHumanActual_datEnteredDate] DEFAULT (getdate()) NULL,
    [datModificationDate]        DATETIME         CONSTRAINT [tlbHumanActual_datModificationDate] DEFAULT (getdate()) NULL,
    [strMaintenanceFlag]         NVARCHAR (20)    NULL,
    [strReservedAttribute]       NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbHumanActual] PRIMARY KEY CLUSTERED ([idfHumanActual] ASC),
    CONSTRAINT [FK_tlbHumanActual_tlbGeoLocation__idfCurrentResidenceAddress_R_1424] FOREIGN KEY ([idfCurrentResidenceAddress]) REFERENCES [dbo].[tlbGeoLocationShared] ([idfGeoLocationShared]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanActual_tlbGeoLocation__idfEmployerAddress_R_1425] FOREIGN KEY ([idfEmployerAddress]) REFERENCES [dbo].[tlbGeoLocationShared] ([idfGeoLocationShared]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanActual_tlbGeoLocation__idfRegistrationAddress_R_1426] FOREIGN KEY ([idfRegistrationAddress]) REFERENCES [dbo].[tlbGeoLocationShared] ([idfGeoLocationShared]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanActual_trtBaseReference__idfsHumanGender_R_1232] FOREIGN KEY ([idfsHumanGender]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanActual_trtBaseReference__idfsNationality_R_1278] FOREIGN KEY ([idfsNationality]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanActual_trtBaseReference__idfsOccupationType_R_1233] FOREIGN KEY ([idfsOccupationType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanActual_trtBaseReference_idfsPersonIDType] FOREIGN KEY ([idfsPersonIDType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanActual_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tlbHumanActual_A_Update] ON [dbo].[tlbHumanActual]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfHumanActual))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbHumanActual_I_Delete] on [dbo].[tlbHumanActual]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfHumanActual]) as
		(
			SELECT [idfHumanActual] FROM deleted
			EXCEPT
			SELECT [idfHumanActual] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbHumanActual as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfHumanActual = b.idfHumanActual;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Human/Patient', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'HumanActual identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'idfHumanActual';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Occupation type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'idfsOccupationType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nationality identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'idfsNationality';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Human gender identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'idfsHumanGender';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Current residence address identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'idfCurrentResidenceAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Employer address identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'idfEmployerAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Registration address identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'idfRegistrationAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date of birth', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'datDateofBirth';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date of death', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'datDateOfDeath';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Last name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'strLastName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Middle name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'strSecondName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'First name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'strFirstName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Registration phone number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'strRegistrationPhone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Employer''s Name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'strEmployerName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Home phone number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'strHomePhone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Work phone number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanActual', @level2type = N'COLUMN', @level2name = N'strWorkPhone';

