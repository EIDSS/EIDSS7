CREATE TABLE [dbo].[tstPersonalDataGroup] (
    [idfPersonalDataGroup] BIGINT           NOT NULL,
    [strGroupName]         NVARCHAR (100)   NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid_tstPersonalDataGroup] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstPersonalDataGroup] PRIMARY KEY CLUSTERED ([idfPersonalDataGroup] ASC),
    CONSTRAINT [FK_tstPersonalDataGroup_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tstPersonalDataGroup_A_Update] ON [dbo].[tstPersonalDataGroup]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfPersonalDataGroup]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
