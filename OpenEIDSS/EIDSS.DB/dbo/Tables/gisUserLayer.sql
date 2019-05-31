CREATE TABLE [dbo].[gisUserLayer] (
    [guidLayer]            UNIQUEIDENTIFIER CONSTRAINT [DF_gisUserLayer_guidLayer] DEFAULT (newid()) NOT NULL,
    [strName]              NVARCHAR (250)   NOT NULL,
    [idfUser]              BIGINT           NOT NULL,
    [CreationDate]         DATETIME         CONSTRAINT [DF_gisUserLayer_CreationDate] DEFAULT (getutcdate()) NOT NULL,
    [LastModifiedDate]     DATETIME         CONSTRAINT [DF_gisUserLayer_LastModifyedDate] DEFAULT (getutcdate()) NOT NULL,
    [intType]              INT              NOT NULL,
    [xmlStyle]             XML              NULL,
    [xmlTheme]             XML              NULL,
    [strDescription]       NVARCHAR (350)   NULL,
    [intPivotalLayer]      INT              NULL,
    [intDeleted]           INT              DEFAULT ((0)) NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_gisUserLayer] PRIMARY KEY CLUSTERED ([guidLayer] ASC),
    CONSTRAINT [FK_gisUserLayer_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_gisUserLayer_tstUserTable] FOREIGN KEY ([idfUser]) REFERENCES [dbo].[tstUserTable] ([idfUserID]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_gisUserLayer_A_Update] ON [dbo].[gisUserLayer]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(guidLayer))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
