

--*************************************************************
-- Name 				: FN_GBL_SESSION_CONTEXT_GET
-- Description			: Funtion to return userid 
--          
-- Author               : Mark Wilson
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
-- 
/*	
ECLARE @SESSION_CONTEXT SessionContextTable

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
--*************************************************************
CREATE FUNCTION [dbo].[FN_GBL_SESSION_CONTEXT_GET](@ContextName NVARCHAR(50))
RETURNS SQL_VARIANT
AS
BEGIN

	DECLARE @ContextValue SQL_VARIANT

	SET @ContextValue = (SELECT SESSION_CONTEXT(@ContextName));

	RETURN @ContextValue

END








