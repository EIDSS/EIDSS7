CREATE TABLE [dbo].[tasglQuerySearchObject] (
    [idfQuerySearchObject]       BIGINT           NOT NULL,
    [idfsQuery]                  BIGINT           NOT NULL,
    [idfsSearchObject]           BIGINT           NOT NULL,
    [idfParentQuerySearchObject] BIGINT           NULL,
    [intOrder]                   INT              NOT NULL,
    [rowguid]                    UNIQUEIDENTIFIER CONSTRAINT [newid__2534] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfsReportType]             BIGINT           NULL,
    [strMaintenanceFlag]         NVARCHAR (20)    NULL,
    [strReservedAttribute]       NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglQuerySearchObject] PRIMARY KEY CLUSTERED ([idfQuerySearchObject] ASC),
    CONSTRAINT [FK_tasglQuerySearchObject_tasglQuery__idfsQueryName_R_1327_1] FOREIGN KEY ([idfsQuery]) REFERENCES [dbo].[tasglQuery] ([idfsQuery]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQuerySearchObject_tasglQuerySearchObject__idfParentQuerySearchObject_R_1329_1] FOREIGN KEY ([idfParentQuerySearchObject]) REFERENCES [dbo].[tasglQuerySearchObject] ([idfQuerySearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQuerySearchObject_tasSearchObject__idfsSearchObject_R_1328_1] FOREIGN KEY ([idfsSearchObject]) REFERENCES [dbo].[tasSearchObject] ([idfsSearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQuerySearchObject_trtBaseReference__idfsReportType] FOREIGN KEY ([idfsReportType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQuerySearchObject_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasglQuerySearchObject_A_Update] ON [dbo].[tasglQuerySearchObject]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfQuerySearchObject))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
