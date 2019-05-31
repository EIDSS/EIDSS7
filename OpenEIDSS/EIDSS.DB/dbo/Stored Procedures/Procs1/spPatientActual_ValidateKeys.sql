
--##SUMMARY Checks foreign keys for HumanActual object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spPatientActual_Validate @ID
*/

CREATE PROCEDURE [dbo].[spPatientActual_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - HumanActual ID
AS
	EXEC spValidateKeys 'tlbHumanActual', @RootId, 'Patient/Contact/Farm Owner'
