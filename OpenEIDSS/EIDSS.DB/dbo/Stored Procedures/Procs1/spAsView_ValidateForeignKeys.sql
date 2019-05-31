
--##SUMMARY Checks foreign keys for AsView object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 14.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spAsView_ValidateForeignKeys @ID
*/
CREATE PROCEDURE [dbo].[spAsView_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - AsView ID
AS
	EXEC spValidateForeignKeys 'tasView', @RootId, 'AVR View'

