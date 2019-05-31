
--##SUMMARY Checks foreign keys for Farm object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spFarm_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spFarm_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Farm ID
AS
	EXEC spValidateForeignKeys 'tlbFarm', @RootId, NULL

