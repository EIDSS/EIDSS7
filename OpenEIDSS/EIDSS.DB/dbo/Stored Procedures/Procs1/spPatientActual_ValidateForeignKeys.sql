
--##SUMMARY Checks foreign keys for HumanActual object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spPatientActual_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spPatientActual_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - HumanActual ID
AS
	EXEC spValidateForeignKeys 'tlbHumanActual', @RootId, 'Patient/Contact/Farm Owner'
