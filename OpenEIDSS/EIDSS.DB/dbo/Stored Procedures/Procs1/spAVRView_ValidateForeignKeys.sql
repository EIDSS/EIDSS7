
--##SUMMARY Checks foreign keys for View object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spAVRView_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spAVRView_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - View ID
AS
	EXEC spValidateForeignKeys 'tasView', @RootId, 'AVR View'

