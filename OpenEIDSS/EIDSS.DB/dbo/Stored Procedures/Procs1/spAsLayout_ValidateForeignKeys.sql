
--##SUMMARY Checks foreign keys for AsLayout object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 14.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spAsLayout_ValidateForeignKeys @ID
*/
CREATE PROCEDURE [dbo].[spAsLayout_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - AsLayout ID
AS
	EXEC spValidateForeignKeys 'tasLayout', @RootId, 'AVR Layout'

