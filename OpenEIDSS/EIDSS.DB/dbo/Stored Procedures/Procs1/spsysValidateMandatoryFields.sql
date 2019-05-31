
--##SUMMARY Checks mandatory fields for all object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 09.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spsysValidateMandatoryFields
*/

CREATE PROCEDURE [dbo].[spsysValidateMandatoryFields]
AS

DECLARE @datCreationDateStart DATETIME = NULL
	, @datCreationDateEnd DATETIME = NULL
	, @datModificationDateStart DATETIME = NULL
	, @datModificationDateEnd DATETIME = NULL

SELECT
	@datCreationDateStart = strValue
FROM tstGlobalSiteOptions
WHERE strName = 'MandatoryValidationCreationtDate'

SET @datCreationDateStart = ISNULL(@datCreationDateStart, '20141201')

SELECT
	@datModificationDateStart = strValue
FROM tstGlobalSiteOptions
WHERE strName = 'MandatoryValidationModificationDate'

SET @datModificationDateStart = ISNULL(@datModificationDateStart, '20141201')



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
	[Query] VARCHAR(MAX),
	[FixQueryTemplate] VARCHAR(MAX),
	CanAutoFix BIT
)

INSERT INTO @ValidateTable
EXEC spHumanCase_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spVetCase_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spASSession_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spASCampaign_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spFarmActual_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spHumanActual_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spHumanAggregateCase_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spVetAggregateCase_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spVetAggregateAction_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spBasicSyndromicSurveillance_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spOrganization_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spPerson_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spOutbreak_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spLabSample_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd

INSERT INTO @ValidateTable
EXEC spLabTest_ValidateMandatoryFields @datCreationDateStart, @datCreationDateEnd, @datModificationDateStart, @datModificationDateEnd



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
	, strFixQueryTemplate
	, blnCanAutoFix
)
SELECT 
	'Mandatory Field'
	, RootObjectName
	, RootId
	, strRootID
	, TableName
	, Id
	, ConstraintName
	, InvalidFieldName
	, InvalidFieldValue
	, [Query]
	, FixQueryTemplate
	, CanAutoFix 
FROM @ValidateTable vt

