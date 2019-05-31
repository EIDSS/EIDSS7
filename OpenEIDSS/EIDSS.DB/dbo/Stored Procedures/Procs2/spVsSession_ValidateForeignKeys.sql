
--##SUMMARY Checks foreign keys for VsSession object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spVsSession_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spVsSession_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - VsSession ID
AS
	EXEC spValidateForeignKeys 'tlbVectorSurveillanceSession', @RootId, 'VS Session'

