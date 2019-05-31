
--##SUMMARY Checks foreign keys for LabSample object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spLabSample_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spLabSample_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - LabSample ID
AS
	EXEC spValidateForeignKeys 'tlbMaterial', @RootId, 'Sample'
