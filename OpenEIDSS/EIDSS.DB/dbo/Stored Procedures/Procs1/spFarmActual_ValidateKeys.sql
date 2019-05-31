
--##SUMMARY Checks foreign keys for FarmActual object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spFarmActual_Validate @ID
*/

CREATE PROCEDURE [dbo].[spFarmActual_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - FarmActual ID
AS
	EXEC spValidateKeys 'tlbFarmActual', @RootId, 'Farm'

