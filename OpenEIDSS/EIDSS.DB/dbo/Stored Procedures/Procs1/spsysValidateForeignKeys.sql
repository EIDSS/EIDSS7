
--##SUMMARY Checks foreign keys for all object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spsysValidateForeignKeys
*/

CREATE PROCEDURE [dbo].[spsysValidateForeignKeys]
AS

DECLARE @ValidateTable TABLE (
	TableName VARCHAR(200),
	RootObjectName VARCHAR(200),
	ConstraintName VARCHAR(500),
	[Where] VARCHAR(500),
	Id BIGINT,
	RootTableName VARCHAR(200),
	RootId BIGINT,
	StrRootId VARCHAR(200),
	InvalidFieldName VARCHAR(200),
	InvalidFieldValue VARCHAR(500),
	[Query] VARCHAR(MAX)
)

INSERT INTO @ValidateTable
EXEC spHumanAggregateCase_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spVetAggregateCase_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spVetAggregateAction_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spASCampaign_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spASSession_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spASSession_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spBasicSyndromicSurveillance_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spBasicSyndromicSurveillanceAggregate_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spFarmActual_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spHumanCase_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spLabBatch_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spLabSample_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spLabTest_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spOrganization_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spOutbreak_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spPatientActual_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spPerson_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spVsSession_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spAvianVetCase_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spLivestockVetCase_ValidateKeys

INSERT INTO @ValidateTable
EXEC spAsLayout_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spAsQuery_ValidateForeignKeys

INSERT INTO @ValidateTable
EXEC spAsView_ValidateForeignKeys

INSERT INTO tstInvalidObjects
(strProblemName, strRootObjectName, idfRootObjectID, strRootObjectID, strInvalidTableName, idfInvalidObjectID, strInvalidConstraint, strInvalidFieldName, strInvalidFieldValue, strSelectQuery)
SELECT 'Foreign Key', RootObjectName, RootId, strRootID, TableName, Id, ConstraintName, InvalidFieldName, InvalidFieldValue, [Query] FROM @ValidateTable vt


