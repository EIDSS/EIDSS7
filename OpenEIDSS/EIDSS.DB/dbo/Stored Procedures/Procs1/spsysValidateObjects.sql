
--##SUMMARY Top level procedure for mass objects validation

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

/*
Example of procedure call:

EXEC spsysValidateObjects

*/

CREATE PROCEDURE [dbo].[spsysValidateObjects]
AS

TRUNCATE TABLE tstInvalidObjects

EXEC spsysValidateForeignKeys

EXEC spsysValidateCalculatedFields

EXEC spsysValidateMandatoryFields

EXEC spsysValidateChildren

INSERT INTO tstInvalidObjects
	(
		strProblemName
		, strRootObjectName
		, idfRootObjectID
		, strRootObjectID
		, strInvalidTableName
		, idfInvalidObjectID
		, strInvalidConstraint
		, strInvalidFieldName
		, strInvalidFieldValue
		, strSelectQuery
	)
EXEC spsysValidateRelations
