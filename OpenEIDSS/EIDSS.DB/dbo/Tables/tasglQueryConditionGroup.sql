CREATE TABLE [dbo].[tasglQueryConditionGroup] (
    [idfQueryConditionGroup]       BIGINT           NOT NULL,
    [idfQuerySearchObject]         BIGINT           NOT NULL,
    [idfParentQueryConditionGroup] BIGINT           NULL,
    [intOrder]                     INT              NOT NULL,
    [blnJoinByOr]                  BIT              CONSTRAINT [Def_0___2700] DEFAULT ((0)) NULL,
    [blnUseNot]                    BIT              CONSTRAINT [Def_0___2701] DEFAULT ((0)) NULL,
    [rowguid]                      UNIQUEIDENTIFIER CONSTRAINT [newid__2537] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfSubQuerySearchObject]      BIGINT           NULL,
    [strMaintenanceFlag]           NVARCHAR (20)    NULL,
    [strReservedAttribute]         NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglQueryConditionGroup] PRIMARY KEY CLUSTERED ([idfQueryConditionGroup] ASC),
    CONSTRAINT [FK_tasglQueryConditionGroup_tasglQueryConditionGroup__idfParentQueryConditionGroup_R_1345_1] FOREIGN KEY ([idfParentQueryConditionGroup]) REFERENCES [dbo].[tasglQueryConditionGroup] ([idfQueryConditionGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQueryConditionGroup_tasglQuerySearchObject__idfQuerySearchObject_R_1344_1] FOREIGN KEY ([idfQuerySearchObject]) REFERENCES [dbo].[tasglQuerySearchObject] ([idfQuerySearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQueryConditionGroup_tasglQuerySearchObject__idfSubQuerySearchObject] FOREIGN KEY ([idfSubQuerySearchObject]) REFERENCES [dbo].[tasglQuerySearchObject] ([idfQuerySearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQueryConditionGroup_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasglQueryConditionGroup_A_Update] ON [dbo].[tasglQueryConditionGroup]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfQueryConditionGroup))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
