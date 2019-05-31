
--##SUMMARY Checks foreign keys for Layout object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spAVRLayout_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spAVRLayout_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Layout ID
AS
	EXEC spValidateForeignKeys 'tasLayout', @RootId, 'AVR Layout'
