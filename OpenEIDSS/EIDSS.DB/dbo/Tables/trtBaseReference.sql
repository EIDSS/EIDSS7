CREATE TABLE [dbo].[trtBaseReference] (
    [idfsBaseReference]    BIGINT           NOT NULL,
    [idfsReferenceType]    BIGINT           NOT NULL,
    [strBaseReferenceCode] VARCHAR (36)     NULL,
    [strDefault]           NVARCHAR (2000)  NULL,
    [intHACode]            INT              NULL,
    [intOrder]             INT              NULL,
    [blnSystem]            BIT              CONSTRAINT [Def_0_2734] DEFAULT ((0)) NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1894] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1911] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtBaseReference] PRIMARY KEY CLUSTERED ([idfsBaseReference] ASC),
    CONSTRAINT [FK_trtBaseReference_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtBaseReference_trtReferenceType__idfsReferenceType_R_381] FOREIGN KEY ([idfsReferenceType]) REFERENCES [dbo].[trtReferenceType] ([idfsReferenceType]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_trtBaseReference_RS1]
    ON [dbo].[trtBaseReference]([idfsReferenceType] ASC, [intRowStatus] ASC)
    INCLUDE([strDefault]);


GO
CREATE NONCLUSTERED INDEX [IX_trtBaseReference_RR]
    ON [dbo].[trtBaseReference]([idfsReferenceType] ASC, [intRowStatus] ASC)
    INCLUDE([idfsBaseReference], [strBaseReferenceCode], [strDefault], [intHACode], [intOrder]);


GO


CREATE      trigger [dbo].[trtrtBaseReferenceDelete] on [dbo].[trtBaseReference]
INSTEAD OF  delete
NOT FOR REPLICATION
as

DECLARE @context VARCHAR(50)
SET @context = dbo.FN_GBL_CONTEXT_GET()

if((TRIGGER_NESTLEVEL()<2) AND (dbo.fnTriggersWork ()=1) AND (ISNULL(@context, '') <> 'DataArchiving') AND (ISNULL(@context, '') <> 'DataMigration') AND (ISNULL(@context, '') <> 'ResolveConflict'))
begin

	update a
	set  intRowStatus = 1
	from dbo.trtBaseReference as a inner join deleted as b on a.idfsBaseReference = b.idfsBaseReference


	declare @event bigint
	exec [dbo].[USP_GBL_DATAAUDITEVENT_SET] @event output

	INSERT INTO dbo.tauDataAuditDetailDelete( idfDataAuditEvent, idfObjectTable, 
		idfObject, idfObjectDetail)
	select distinct @event,75820000000,
		a.idfsBaseReference,null
	from deleted as a
end
else
delete a
from dbo.trtBaseReference as a inner join deleted as b on a.idfsBaseReference = b.idfsBaseReference


GO

CREATE TRIGGER [dbo].[TR_trtBaseReference_A_Update] ON [dbo].[trtBaseReference]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsBaseReference))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Base Reference (translatable) table ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtBaseReference';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Base reference value identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtBaseReference', @level2type = N'COLUMN', @level2name = N'idfsBaseReference';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Reference type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtBaseReference', @level2type = N'COLUMN', @level2name = N'idfsReferenceType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Base reference code (from version 2)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtBaseReference', @level2type = N'COLUMN', @level2name = N'strBaseReferenceCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Default value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtBaseReference', @level2type = N'COLUMN', @level2name = N'strDefault';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Human/Animal Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtBaseReference', @level2type = N'COLUMN', @level2name = N'intHACode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Listing order', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtBaseReference', @level2type = N'COLUMN', @level2name = N'intOrder';

