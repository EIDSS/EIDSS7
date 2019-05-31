
--##SUMMARY Checks foreign keys for ASSession object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spASSession_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spASSession_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - ASSession ID
AS
	EXEC spValidateForeignKeys 'tlbMonitoringSession', @RootId, 'AS Session'

