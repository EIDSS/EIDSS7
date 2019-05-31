
--##SUMMARY Checks foreign keys for Layout object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spAVRLayout_Validate @ID
*/

CREATE PROCEDURE [dbo].[spAVRLayout_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Layout ID
AS
	EXEC spValidateKeys 'tasLayout', @RootId, 'AVR Layout'
