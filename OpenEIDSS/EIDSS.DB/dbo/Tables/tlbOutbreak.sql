CREATE TABLE [dbo].[tlbOutbreak] (
    [idfOutbreak]                   BIGINT           NOT NULL,
    [idfsDiagnosisOrDiagnosisGroup] BIGINT           NULL,
    [idfsOutbreakStatus]            BIGINT           NULL,
    [idfGeoLocation]                BIGINT           NULL,
    [datStartDate]                  DATETIME         NULL,
    [datFinishDate]                 DATETIME         NULL,
    [strOutbreakID]                 NVARCHAR (200)   NULL,
    [strDescription]                NVARCHAR (2000)  NULL,
    [intRowStatus]                  INT              CONSTRAINT [Def_0_2504] DEFAULT ((0)) NOT NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [newid__2477] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [datModificationForArchiveDate] DATETIME         CONSTRAINT [tlbOutbreak_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [idfPrimaryCaseOrSession]       BIGINT           NULL,
    [idfsSite]                      BIGINT           CONSTRAINT [Def_fnSiteID_tlbOutbreak] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [strReservedAttribute]          NVARCHAR (MAX)   NULL,
    [OutbreakTypeID]                BIGINT           NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbOutbreak] PRIMARY KEY CLUSTERED ([idfOutbreak] ASC),
    CONSTRAINT [FK_tlbOutbreak_BaseRef_OutbreakTypeID] FOREIGN KEY ([OutbreakTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbOutbreak_tlbGeoLocation__idfGeoLocation_R_1469] FOREIGN KEY ([idfGeoLocation]) REFERENCES [dbo].[tlbGeoLocation] ([idfGeoLocation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbOutbreak_trtBaseReference__idfsDiagnosisOrDiagnosisGroup] FOREIGN KEY ([idfsDiagnosisOrDiagnosisGroup]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbOutbreak_trtBaseReference__idfsOutbreakStatus_R_1262] FOREIGN KEY ([idfsOutbreakStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbOutbreak_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbOutbreak_tstSite__idfsSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_tlbOutbreak_I_Delete] ON [dbo].[tlbOutbreak]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfOutbreak]) as
		(
			SELECT [idfOutbreak] FROM deleted
			EXCEPT
			SELECT [idfOutbreak] FROM inserted
		)
		
		UPDATE a
		SET	intRowStatus = 1, 
			datModificationForArchiveDate = getdate()
		FROM	 dbo.tlbOutbreak AS a 
		INNER JOIN cteOnlyDeletedRecords AS b 
			ON a.idfOutbreak = b.idfOutbreak;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbOutbreak_A_Update] ON [dbo].[tlbOutbreak]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1)
	BEGIN
		IF UPDATE(idfOutbreak)
		BEGIN
			RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
			ROLLBACK TRANSACTION
		END

		ELSE
		BEGIN

			UPDATE a
			SET datModificationForArchiveDate = getdate()
			FROM dbo.tlbOutbreak AS a 
			INNER JOIN INSERTED AS b ON a.idfOutbreak = b.idfOutbreak

		END
	
	END

END

GO

-- =============================================
-- Author:		Romasheva Svetlana
-- Create date: May 19 2014  2:47PM
-- Description:	Trigger FOR correct problems 
--              with replication AND checkin in the same time
-- =============================================
CREATE TRIGGER [dbo].[trtOutbreakReplicationUp] 
   ON  [dbo].[tlbOutbreak]
   FOR INSERT
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON;
	
	--DECLARE @context VARCHAR(50)
	--SET @context = dbo.FN_GBL_CONTEXT_GET()

	DELETE  nID
	FROM	dbo.tflNewID AS nID
	INNER JOIN INSERTED AS ins
	ON		ins.idfOutbreak = nID.idfKey1
	WHERE  nID.strTableName = 'tflOutbreakFiltered'

	INSERT 
	INTO	dbo.tflNewID 
		(
			strTableName, 
			idfKey1, 
			idfKey2
		)
	SELECT  
			'tflOutbreakFiltered', 
			ins.idfOutbreak, 
			sg.idfSiteGroup
	FROM  INSERTED AS ins
	INNER JOIN dbo.tflSiteToSiteGroup AS stsg
	ON		stsg.idfsSite = ins.idfsSite
		
	INNER JOIN dbo.tflSiteGroup sg
	ON		sg.idfSiteGroup = stsg.idfSiteGroup
	AND		sg.idfsRayon IS NULL
	AND		sg.idfsCentralSite IS NULL
	AND		sg.intRowStatus = 0
			
	LEFT JOIN dbo.tflOutbreakFiltered AS btf
	ON		btf.idfOutbreak = ins.idfOutbreak
	AND		btf.idfSiteGroup = sg.idfSiteGroup
	WHERE	btf.idfOutbreakFiltered IS NULL

	INSERT 
	INTO	dbo.tflOutbreakFiltered
		(
			idfOutbreakFiltered, 
			idfOutbreak, 
			idfSiteGroup
		)
	SELECT 
			nID.NewID, 
			ins.idfOutbreak, 
			nID.idfKey2
	FROM  INSERTED AS ins
	INNER JOIN dbo.tflNewID AS nID
	ON		nID.strTableName = 'tflOutbreakFiltered'
	AND		nID.idfKey1 = ins.idfOutbreak
	AND		nID.idfKey2 IS not NULL
	LEFT JOIN dbo.tflOutbreakFiltered AS btf
	ON		btf.idfOutbreakFiltered = nID.NewID
	WHERE	btf.idfOutbreakFiltered IS NULL

	DELETE  nID
	FROM	dbo.tflNewID AS nID
	INNER JOIN INSERTED AS ins
	ON		ins.idfOutbreak = nID.idfKey1
	WHERE	nID.strTableName = 'tflOutbreakFiltered'

	SET NOCOUNT OFF;
END


