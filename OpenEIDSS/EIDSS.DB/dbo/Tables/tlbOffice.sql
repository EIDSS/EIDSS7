CREATE TABLE [dbo].[tlbOffice] (
    [idfOffice]               BIGINT           NOT NULL,
    [idfsOfficeName]          BIGINT           NULL,
    [idfsOfficeAbbreviation]  BIGINT           NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [idfLocation]             BIGINT           NULL,
    [idfsSite]                BIGINT           CONSTRAINT [Def_fnSiteID_tlbOffice] DEFAULT ([dbo].[fnSiteID]()) NULL,
    [strContactPhone]         NVARCHAR (200)   NULL,
    [intRowStatus]            INT              CONSTRAINT [Def_0_2057] DEFAULT ((0)) NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid__2059] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intHACode]               INT              NULL,
    [strOrganizationID]       NVARCHAR (100)   NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [OrganizationTypeID]      BIGINT           NULL,
    [OwnershipFormID]         BIGINT           NULL,
    [LegalFormID]             BIGINT           NULL,
    [MainFormOfActivityID]    BIGINT           NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbOffice] PRIMARY KEY CLUSTERED ([idfOffice] ASC),
    CONSTRAINT [FK_tlbOffice_BaseRef_] FOREIGN KEY ([OrganizationTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbOffice_tlbGeoLocationShared] FOREIGN KEY ([idfLocation]) REFERENCES [dbo].[tlbGeoLocationShared] ([idfGeoLocationShared]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbOffice_trtBaseReference__idfsOfficeAbbreviation_R_704] FOREIGN KEY ([idfsOfficeAbbreviation]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbOffice_trtBaseReference__idfsOfficeName_R_703] FOREIGN KEY ([idfsOfficeName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbOffice_trtBaseReference_LegalFormID] FOREIGN KEY ([LegalFormID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbOffice_trtBaseReference_MainFormOfActivityID] FOREIGN KEY ([MainFormOfActivityID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbOffice_trtBaseReference_OwnershipFormID] FOREIGN KEY ([OwnershipFormID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbOffice_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbOffice_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbOffice_tstSite__idfsSite_R_1030] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO
ALTER TABLE [dbo].[tlbOffice] NOCHECK CONSTRAINT [FK_tlbOffice_tlbGeoLocationShared];


GO
CREATE NONCLUSTERED INDEX [IX_tlbOffice_idfLocation]
    ON [dbo].[tlbOffice]([idfLocation] ASC)
    INCLUDE([idfOffice]);


GO


CREATE TRIGGER [dbo].[TR_tlbOffice_I_Delete] on [dbo].[tlbOffice]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfOffice]) as
		(
			SELECT [idfOffice] FROM deleted
			EXCEPT
			SELECT [idfOffice] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbOffice as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfOffice = b.idfOffice;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbOffice_A_Update] ON [dbo].[tlbOffice]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfOffice))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Offices', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbOffice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Office identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbOffice', @level2type = N'COLUMN', @level2name = N'idfOffice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Office name identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbOffice', @level2type = N'COLUMN', @level2name = N'idfsOfficeName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Office abbreviation identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbOffice', @level2type = N'COLUMN', @level2name = N'idfsOfficeAbbreviation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbOffice', @level2type = N'COLUMN', @level2name = N'idfCustomizationPackage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbOffice', @level2type = N'COLUMN', @level2name = N'idfsSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Office Contact phone number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbOffice', @level2type = N'COLUMN', @level2name = N'strContactPhone';

