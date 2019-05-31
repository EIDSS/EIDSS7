
--##SUMMARY Checks foreign keys for HumanCase object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spHumanCase_Validate @ID
*/

CREATE PROCEDURE [dbo].[spHumanCase_ValidateKeys]
@RootId BIGINT = NULL	--##PARAM @RootId - HumanCase ID
AS
	EXEC spValidateKeys 'tlbHumanCase', @RootId, 'Human Case'

