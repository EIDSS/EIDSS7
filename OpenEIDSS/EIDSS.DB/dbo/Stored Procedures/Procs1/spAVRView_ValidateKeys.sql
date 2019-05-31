
--##SUMMARY Checks foreign keys for View object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spAVRView_Validate @ID
*/

CREATE PROCEDURE [dbo].[spAVRView_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - View ID
AS
	EXEC spValidateKeys 'tasView', @RootId, 'AVR View'

