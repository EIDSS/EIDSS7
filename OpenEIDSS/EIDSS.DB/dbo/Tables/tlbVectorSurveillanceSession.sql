CREATE TABLE [dbo].[tlbVectorSurveillanceSession] (
    [idfVectorSurveillanceSession]  BIGINT           NOT NULL,
    [strSessionID]                  NVARCHAR (50)    NOT NULL,
    [strFieldSessionID]             NVARCHAR (50)    NULL,
    [idfsVectorSurveillanceStatus]  BIGINT           NOT NULL,
    [datStartDate]                  DATETIME         NOT NULL,
    [datCloseDate]                  DATETIME         NULL,
    [idfLocation]                   BIGINT           NULL,
    [idfOutbreak]                   BIGINT           NULL,
    [strDescription]                NVARCHAR (500)   NULL,
    [idfsSite]                      BIGINT           CONSTRAINT [DF_tlbVectorSurveillanceSession_idfsSite] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [intRowStatus]                  INT              CONSTRAINT [DF_tlbVectorSurveillanceSession_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [DF_tlbVectorSurveillanceSession_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [datModificationForArchiveDate] DATETIME         CONSTRAINT [tlbVectorSurveillanceSession_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [intCollectionEffort]           INT              NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [strReservedAttribute]          NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tlbVectorSurveillanceSession] PRIMARY KEY CLUSTERED ([idfVectorSurveillanceSession] ASC),
    CONSTRAINT [FK_tlbVectorSurveillanceSession_tlbGeoLocation_idfLocation] FOREIGN KEY ([idfLocation]) REFERENCES [dbo].[tlbGeoLocation] ([idfGeoLocation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVectorSurveillanceSession_tlbOutbreak_idfOutbreak] FOREIGN KEY ([idfOutbreak]) REFERENCES [dbo].[tlbOutbreak] ([idfOutbreak]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVectorSurveillanceSession_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbVectorSurveillanceSession_trtBaseReference_VectorSurveillanceStatus] FOREIGN KEY ([idfsVectorSurveillanceStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVectorSurveillanceSession_tstSite_idfsSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO

CREATE  TRIGGER [dbo].[TR_tlbVectorSurveillanceSession_ChangeArchiveDate] ON [dbo].[tlbVectorSurveillanceSession]	
FOR INSERT, UPDATE, DELETE
NOT FOR REPLICATION
AS	

IF (dbo.FN_GBL_TriggersWork ()=1)
BEGIN
	
	DECLARE @dateModify DATETIME
	DECLARE @idfOutbreakOld BIGINT
	DECLARE @idfOutbreakNew BIGINT
	
	SELECT
		@idfOutbreakOld = ISNULL(idfOutbreak, 0)
	FROM DELETED
	
	SELECT
		@idfOutbreakNew = ISNULL(idfOutbreak, 0)
	FROM INSERTED
	
	SET @dateModify = GETDATE()
						
	IF @idfOutbreakOld > 0
		UPDATE tlbOutbreak
		SET datModificationForArchiveDate = @dateModify
		WHERE idfOutbreak = @idfOutbreakOld
			
	IF @idfOutbreakNew > 0
		UPDATE tlbOutbreak
		SET datModificationForArchiveDate = @dateModify
		WHERE idfOutbreak = @idfOutbreakNew
		
END

GO

-- =============================================
-- Author:		Romasheva Svetlana
-- Create date: May 19 2014  3:06PM
-- Description:	TRIGGER for correct problems 
--              with replication AND checkin in the same time
-- =============================================
CREATE TRIGGER [dbo].[trtVectorSurveillanceSessionReplicationUp] 
   ON  [dbo].[tlbVectorSurveillanceSession]
   for INSERT
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON;
	
	--DECLARE @context VARCHAR(50)
	--SET @context = dbo.FN_GBL_CONTEXT_GET()

	DELETE  nID
	FROM  dbo.tflNewID AS nID
		INNER JOIN INSERTED AS ins
		ON   ins.idfVectorSurveillanceSession = nID.idfKey1
	WHERE  nID.strTableName = 'tflVectorSurveillanceSessionFiltered'

	INSERT 
	INTO	 dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
	SELECT	'tflVectorSurveillanceSessionFiltered', 
			ins.idfVectorSurveillanceSession, 
			sg.idfSiteGroup
	FROM  INSERTED AS ins
	INNER JOIN dbo.tflSiteToSiteGroup AS stsg
		ON   stsg.idfsSite = ins.idfsSite
		
		INNER JOIN dbo.tflSiteGroup sg
		ON	sg.idfSiteGroup = stsg.idfSiteGroup
			AND sg.idfsRayon IS NULL
			AND sg.idfsCentralSite IS NULL
			AND sg.intRowStatus = 0
			
	LEFT JOIN	dbo.tflVectorSurveillanceSessionFiltered AS btf
	ON			btf.idfVectorSurveillanceSession = ins.idfVectorSurveillanceSession
	AND			btf.idfSiteGroup = sg.idfSiteGroup
	WHERE		btf.idfVectorSurveillanceSessionFiltered IS NULL

	INSERT INTO dbo.tflVectorSurveillanceSessionFiltered
			(
				idfVectorSurveillanceSessionFiltered, 
				idfVectorSurveillanceSession, 
				idfSiteGroup
			)
	SELECT 	nID.NewID, 
			ins.idfVectorSurveillanceSession, 
			nID.idfKey2
	FROM  INSERTED AS ins
	INNER JOIN	dbo.tflNewID AS nID
	ON			nID.strTableName = 'tflVectorSurveillanceSessionFiltered'
	AND			nID.idfKey1 = ins.idfVectorSurveillanceSession
	AND			nID.idfKey2 IS NOT NULL
	LEFT JOIN	dbo.tflVectorSurveillanceSessionFiltered AS btf
	ON			btf.idfVectorSurveillanceSessionFiltered = nID.NewID
	WHERE  btf.idfVectorSurveillanceSessionFiltered IS NULL

	DELETE		nID
	FROM		dbo.tflNewID AS nID
	INNER JOIN	INSERTED AS ins
	ON			ins.idfVectorSurveillanceSession = nID.idfKey1
	WHERE		nID.strTableName = 'tflVectorSurveillanceSessionFiltered'
	
	SET NOCOUNT OFF;
END



GO

CREATE TRIGGER [dbo].[TR_tlbVectorSurveillanceSession_A_Update] ON [dbo].[tlbVectorSurveillanceSession]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1)
	BEGIN
		IF UPDATE(idfVectorSurveillanceSession)
		BEGIN
			RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
			ROLLBACK TRANSACTION
		END

		ELSE
		BEGIN

			UPDATE a
			SET datModificationForArchiveDate = GETDATE()
			FROM dbo.tlbVectorSurveillanceSession AS a 
			INNER JOIN INSERTED AS b ON a.idfVectorSurveillanceSession = b.idfVectorSurveillanceSession

		END
	
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbVectorSurveillanceSession_I_Delete] ON [dbo].[tlbVectorSurveillanceSession]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfVectorSurveillanceSession]) as
		(
			SELECT [idfVectorSurveillanceSession] FROM deleted
			EXCEPT
			SELECT [idfVectorSurveillanceSession] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			datModificationForArchiveDate = GETDATE()
		FROM dbo.tlbVectorSurveillanceSession AS a 
		INNER JOIN cteOnlyDeletedRecords AS b 
			ON a.idfVectorSurveillanceSession = b.idfVectorSurveillanceSession;

	END

END
