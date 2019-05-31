
--##SUMMARY Checks foreign keys for Office object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spOrganization_Validate @ID
*/

CREATE PROCEDURE [dbo].[spOrganization_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Office ID
AS
	EXEC spValidateKeys 'tlbOffice', @RootId, 'Organization'

