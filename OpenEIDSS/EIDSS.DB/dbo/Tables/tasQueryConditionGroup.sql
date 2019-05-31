CREATE TABLE [dbo].[tasQueryConditionGroup] (
    [idfQueryConditionGroup]       BIGINT           NOT NULL,
    [idfQuerySearchObject]         BIGINT           NOT NULL,
    [idfParentQueryConditionGroup] BIGINT           NULL,
    [intOrder]                     INT              NOT NULL,
    [blnJoinByOr]                  BIT              CONSTRAINT [Def_0___2707] DEFAULT ((0)) NULL,
    [blnUseNot]                    BIT              CONSTRAINT [Def_0___2708] DEFAULT ((0)) NULL,
    [idfSubQuerySearchObject]      BIGINT           NULL,
    [strReservedAttribute]         NVARCHAR (MAX)   NULL,
    [rowguid]                      UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasQueryConditionGroup] PRIMARY KEY CLUSTERED ([idfQueryConditionGroup] ASC),
    CONSTRAINT [FK_tasQueryConditionGroup_tasQueryConditionGroup__idfParentQueryConditionGroup_R_1345] FOREIGN KEY ([idfParentQueryConditionGroup]) REFERENCES [dbo].[tasQueryConditionGroup] ([idfQueryConditionGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasQueryConditionGroup_tasQuerySearchObject__idfQuerySearchObject_R_1344] FOREIGN KEY ([idfQuerySearchObject]) REFERENCES [dbo].[tasQuerySearchObject] ([idfQuerySearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasQueryConditionGroup_tasQuerySearchObject__idfSubQuerySearchObject] FOREIGN KEY ([idfSubQuerySearchObject]) REFERENCES [dbo].[tasQuerySearchObject] ([idfQuerySearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasQueryConditionGroup_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasQueryConditionGroup_A_Update] ON [dbo].[tasQueryConditionGroup]
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

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Query Condition Groups', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tasQueryConditionGroup';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Order in group', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tasQueryConditionGroup', @level2type = N'COLUMN', @level2name = N'intOrder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Flag - Is join by Or (true - Or, false - And)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tasQueryConditionGroup', @level2type = N'COLUMN', @level2name = N'blnJoinByOr';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Flag - Is Not (true - Not, false - no Not)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tasQueryConditionGroup', @level2type = N'COLUMN', @level2name = N'blnUseNot';

