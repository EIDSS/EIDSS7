
--##SUMMARY Checks foreign keys for LabSample object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spLabSample_Validate @ID
*/

CREATE PROCEDURE [dbo].[spLabSample_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - LabSample ID
AS
	EXEC spValidateKeys 'tlbMaterial', @RootId, 'Sample'
