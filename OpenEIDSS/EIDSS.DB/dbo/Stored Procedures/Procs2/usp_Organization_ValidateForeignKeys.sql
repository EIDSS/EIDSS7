




--##SUMMARY Checks foreign keys for Office object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

-- Renamed to usp_ from sp by MCW

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spOrganization_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[usp_Organization_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Office ID
AS
    -- renamed sp to usp_
	EXEC usp_ValidateForeignKeys 'tlbOffice', @RootId, 'Organization'



