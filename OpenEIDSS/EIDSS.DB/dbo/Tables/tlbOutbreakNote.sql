CREATE TABLE [dbo].[tlbOutbreakNote] (
    [idfOutbreakNote]       BIGINT           NOT NULL,
    [idfOutbreak]           BIGINT           NOT NULL,
    [strNote]               NVARCHAR (2000)  NULL,
    [datNoteDate]           DATETIME         NULL,
    [idfPerson]             BIGINT           NOT NULL,
    [intRowStatus]          INT              CONSTRAINT [Def_tlbOutbreakNote_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__2478] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [NoteRecordUID]         BIGINT           IDENTITY (10000, 1) NOT NULL,
    [UpdatePriorityID]      BIGINT           NULL,
    [UpdateRecordTitle]     VARCHAR (200)    NULL,
    [UploadFileName]        VARCHAR (200)    NULL,
    [UploadFileDescription] VARCHAR (200)    NULL,
    [UploadFileObject]      VARBINARY (MAX)  NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbOutbreakNote] PRIMARY KEY CLUSTERED ([idfOutbreakNote] ASC),
    CONSTRAINT [FK_tlbOutbreakNote_BaseRef_UpdatePriorityID] FOREIGN KEY ([UpdatePriorityID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbOutbreakNote_tlbOutbreak__idfOutbreak] FOREIGN KEY ([idfOutbreak]) REFERENCES [dbo].[tlbOutbreak] ([idfOutbreak]),
    CONSTRAINT [FK_tlbOutbreakNote_tlbPerson__idfPerson] FOREIGN KEY ([idfPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]),
    CONSTRAINT [FK_tlbOutbreakNote_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tlbOutbreakNote_A_Update] ON [dbo].[tlbOutbreakNote]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfOutbreakNote))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbOutbreakNote_I_Delete] on [dbo].[tlbOutbreakNote]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([idfOutbreakNote]) as
		(
			SELECT [idfOutbreakNote] FROM deleted
			EXCEPT
			SELECT [idfOutbreakNote] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.[tlbOutbreakNote] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[idfOutbreakNote] = b.[idfOutbreakNote];

	END

END
