CREATE TABLE [dbo].[tstCheckConstraints] (
    [idfCheckConstraints]    BIGINT           IDENTITY (1, 1) NOT NULL,
    [idfCheckTable]          BIGINT           NULL,
    [strConstraintName]      NVARCHAR (500)   NOT NULL,
    [strTableName1]          NVARCHAR (500)   NOT NULL,
    [strColumnName1]         NVARCHAR (500)   NOT NULL,
    [strTableName2]          NVARCHAR (500)   NULL,
    [strColumnName2]         NVARCHAR (500)   NULL,
    [strAdditionalParameter] NVARCHAR (500)   NULL,
    [strAdditionalJoin]      NVARCHAR (2000)  NULL,
    [strMandatoryFieldAlias] NVARCHAR (500)   NULL,
    [strFixQueryTemplate]    NVARCHAR (MAX)   NULL,
    [blnCanAutoFix]          BIT              NULL,
    [rowguid]                UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstCheckConstraints] PRIMARY KEY CLUSTERED ([idfCheckConstraints] ASC),
    CONSTRAINT [FK_tstCheckConstraints_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstCheckConstraints_tstCheckTables__idfCheckTable] FOREIGN KEY ([idfCheckTable]) REFERENCES [dbo].[tstCheckTables] ([idfCheckTable]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstCheckConstraints_A_Update] ON [dbo].[tstCheckConstraints]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfCheckConstraints]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
