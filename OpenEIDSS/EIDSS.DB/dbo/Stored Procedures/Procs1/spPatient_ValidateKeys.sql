
--##SUMMARY Checks foreign keys for Human object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spPatient_Validate @ID
*/

CREATE PROCEDURE [dbo].[spPatient_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Human ID
AS
	EXEC spValidateKeys 'tlbHuman', @RootId, NULL

