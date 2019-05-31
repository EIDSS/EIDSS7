
--*************************************************************
-- Name 				: USP_GBL_SESSION_CONTEXT_SET
-- Description			: SET Session Context for Event Auditing
--          
-- Author               : Mark Wilson
-- Revision History
--		Name       Date       Change Detail
-- Mark Wilson	31 July 2018  Updated to accept a table of name:value pairs
--
-- Testing code:
/*

DECLARE @SESSION_CONTEXT SessionContextTable

INSERT INTO @SESSION_CONTEXT

SELECT
	'AuditObject',
	'Human Case'

INSERT INTO @SESSION_CONTEXT

SELECT
	'AuditEvent',
	'Edit'

INSERT INTO @SESSION_CONTEXT

SELECT
	'AppUser',
	'demo' 
	
INSERT INTO @SESSION_CONTEXT

SELECT
	'AppSessionID',
	'Application Session 1248'

EXEC dbo.USP_GBL_SESSION_CONTEXT_SET @SESSION_CONTEXT

SELECT 
	CONVERT(BIGINT, dbo.FN_GBL_SESSION_CONTEXT_GET('AppUser')) AS idfUser,
	CONVERT(BIGINT, dbo.FN_GBL_SESSION_CONTEXT_GET('DBSessionID')) AS DBSessionID,
	CONVERT(NVARCHAR(300), dbo.FN_GBL_SESSION_CONTEXT_GET('AppSessionID')) AS AppSessionID,
	CONVERT(BIGINT, dbo.FN_GBL_SESSION_CONTEXT_GET('AuditObject')) AS AuditObjectType,
	CONVERT(BIGINT, dbo.FN_GBL_SESSION_CONTEXT_GET('AuditEvent')) AS AuditEventType
*/

CREATE PROCEDURE [dbo].[USP_GBL_SESSION_CONTEXT_SET]
(
	@ContextNameValue SessionContextTable READONLY -- EIDSS defined table for context name:value pairs
)
AS

	DECLARE 
		@ContextName NVARCHAR(150),
		@ContextValue SQL_VARIANT

	DECLARE SessionContext_Cursor CURSOR
	FOR
	SELECT
		ContextName, 
		ContextValue
	
	FROM @ContextNameValue

	OPEN SessionContext_Cursor

	FETCH NEXT FROM SessionContext_Cursor
	INTO
		@ContextName,
		@ContextValue
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC sp_set_session_context @ContextName, @ContextValue  
		FETCH NEXT FROM SessionContext_Cursor
		INTO
			@ContextName,
			@ContextValue

		IF @ContextName = 'AuditEvent'
		EXEC sp_set_session_context 'DBSessionID', @@SPID
	END

RETURN 0
