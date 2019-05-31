CREATE TABLE [dbo].[tasglQuerySearchField] (
    [idfQuerySearchField]  BIGINT           NOT NULL,
    [idfQuerySearchObject] BIGINT           NOT NULL,
    [blnShow]              BIT              CONSTRAINT [Def_0___2702] DEFAULT ((0)) NULL,
    [idfsSearchField]      BIGINT           NOT NULL,
    [idfsParameter]        BIGINT           NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2535] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglQuerySearchField] PRIMARY KEY CLUSTERED ([idfQuerySearchField] ASC),
    CONSTRAINT [FK_tasglQuerySearchField_ffParameter__idfsParameter_R_1353_1] FOREIGN KEY ([idfsParameter]) REFERENCES [dbo].[ffParameter] ([idfsParameter]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQuerySearchField_tasglQuerySearchObject__idfQuerySearchObject_R_1351_1] FOREIGN KEY ([idfQuerySearchObject]) REFERENCES [dbo].[tasglQuerySearchObject] ([idfQuerySearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQuerySearchField_tasglSearchFieldList__idfsSearchField_R_1352_1] FOREIGN KEY ([idfsSearchField]) REFERENCES [dbo].[tasSearchField] ([idfsSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQuerySearchField_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasglQuerySearchField_A_Update] ON [dbo].[tasglQuerySearchField]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfQuerySearchField))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
