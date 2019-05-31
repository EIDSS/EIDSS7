
--##SUMMARY Checks foreign keys for FarmActual object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spFarmActual_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spFarmActual_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - FarmActual ID
AS
	EXEC spValidateForeignKeys 'tlbFarmActual', @RootId, 'Farm'

