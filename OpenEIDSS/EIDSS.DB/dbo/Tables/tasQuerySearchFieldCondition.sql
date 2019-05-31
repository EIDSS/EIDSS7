CREATE TABLE [dbo].[tasQuerySearchFieldCondition] (
    [idfQuerySearchFieldCondition] BIGINT           NOT NULL,
    [idfQueryConditionGroup]       BIGINT           NOT NULL,
    [idfQuerySearchField]          BIGINT           NOT NULL,
    [strOperator]                  NVARCHAR (200)   NOT NULL,
    [intOrder]                     INT              NOT NULL,
    [intOperatorType]              INT              NULL,
    [blnUseNot]                    BIT              CONSTRAINT [Def_0___2710] DEFAULT ((0)) NULL,
    [varValue]                     SQL_VARIANT      NULL,
    [strReservedAttribute]         NVARCHAR (MAX)   NULL,
    [rowguid]                      UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasQuerySearchFieldCondition] PRIMARY KEY CLUSTERED ([idfQuerySearchFieldCondition] ASC),
    CONSTRAINT [FK_tasQuerySearchFieldCondition_tasQueryConditionGroup__idfQueryConditionGroup_R_1342] FOREIGN KEY ([idfQueryConditionGroup]) REFERENCES [dbo].[tasQueryConditionGroup] ([idfQueryConditionGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasQuerySearchFieldCondition_tasQuerySearchField__idfQuerySearchField_R_1343] FOREIGN KEY ([idfQuerySearchField]) REFERENCES [dbo].[tasQuerySearchField] ([idfQuerySearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasQuerySearchFieldCondition_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasQuerySearchFieldCondition_A_Update] ON [dbo].[tasQuerySearchFieldCondition]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfQuerySearchFieldCondition))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Query Search Field Conditions', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tasQuerySearchFieldCondition';

