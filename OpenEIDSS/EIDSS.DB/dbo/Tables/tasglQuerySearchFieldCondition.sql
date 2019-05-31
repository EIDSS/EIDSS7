CREATE TABLE [dbo].[tasglQuerySearchFieldCondition] (
    [idfQuerySearchFieldCondition] BIGINT           NOT NULL,
    [idfQueryConditionGroup]       BIGINT           NOT NULL,
    [idfQuerySearchField]          BIGINT           NOT NULL,
    [strOperator]                  NVARCHAR (200)   NOT NULL,
    [intOrder]                     INT              NOT NULL,
    [intOperatorType]              INT              NULL,
    [blnUseNot]                    BIT              CONSTRAINT [Def_0___2703] DEFAULT ((0)) NULL,
    [varValue]                     SQL_VARIANT      NULL,
    [rowguid]                      UNIQUEIDENTIFIER CONSTRAINT [newid__2538] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]           NVARCHAR (20)    NULL,
    [strReservedAttribute]         NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglQuerySearchFieldCondition] PRIMARY KEY CLUSTERED ([idfQuerySearchFieldCondition] ASC),
    CONSTRAINT [FK_tasglQuerySearchFieldCondition_tasglQueryConditionGroup__idfQueryConditionGroup_R_1342_1] FOREIGN KEY ([idfQueryConditionGroup]) REFERENCES [dbo].[tasglQueryConditionGroup] ([idfQueryConditionGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQuerySearchFieldCondition_tasglQuerySearchField__idfQuerySearchField_R_1343_1] FOREIGN KEY ([idfQuerySearchField]) REFERENCES [dbo].[tasglQuerySearchField] ([idfQuerySearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglQuerySearchFieldCondition_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasglQuerySearchFieldCondition_A_Update] ON [dbo].[tasglQuerySearchFieldCondition]
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
