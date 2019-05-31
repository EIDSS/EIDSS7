
--##SUMMARY Find all invalid caluclated fields in the system and log invalid fields in tstInvalidObjects table

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 24.06.2015

/*
Example of procedure call:

EXEC spsysValidateCalculatedFields

*/
CREATE PROCEDURE [dbo].[spsysValidateCalculatedFields]
AS
	
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
		'Calculated Field'					AS strProblemName
		, 'AS Session'						AS strRootObjectName
		, tms.idfMonitoringSession			AS idfRootObjectID
		, tms.strMonitoringSessionID		AS strRootObjectID
		, 'tlbMaterial'						AS strInvalidTableName
		, tm.idfMaterial					AS idfInvalidObjectID
		, 'Calculated Case ID'				AS strInvalidConstraint
		, 'strCalculatedCaseID'				AS strInvalidFieldName
		, tm.strCalculatedCaseID			AS idfInvalidFieldValue
		, '
		SELECT tm.idfMaterial, tm.strFieldBarcode, tm.strBarcode, tm.strCalculatedCaseID, tms.strMonitoringSessionID FROM tlbMaterial tm
		JOIN tlbMonitoringSession tms ON tms.idfMonitoringSession = tm.idfMonitoringSession
		WHERE tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR)
											AS strSelectQuery
		, '
		UPDATE tm
		SET strCalculatedCaseID = tms.strMonitoringSessionID
		FROM tlbMaterial tm
		JOIN tlbMonitoringSession tms ON tms.idfMonitoringSession = tm.idfMonitoringSession
		WHERE tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR)
											AS strFixQueryTemplate
		, 1
	FROM tlbMaterial tm
	JOIN tlbMonitoringSession tms ON 
		tms.idfMonitoringSession = tm.idfMonitoringSession
		AND tms.intRowStatus = 0
	WHERE tm.strCalculatedCaseID <> tms.strMonitoringSessionID	
		AND tm.intRowStatus = 0

	UNION ALL

	SELECT
		'Calculated Field'					AS strProblemName
		, 'Human Case'						AS strRootObjectName
		, thc.idfHumanCase					AS idfRootObjectID
		, thc.strCaseID						AS strRootObjectID
		, 'tlbMaterial'						AS strInvalidTableName
		, tm.idfMaterial					AS idfInvalidObjectID
		, 'Calculated Case ID'				AS strInvalidConstraint
		, 'strCalculatedCaseID'				AS strInvalidFieldName
		, tm.strCalculatedCaseID			AS idfInvalidFieldValue
		, '
		SELECT tm.idfMaterial, tm.strFieldBarcode, tm.strBarcode, tm.strCalculatedCaseID, thc.strCaseID FROM tlbMaterial tm
		JOIN tlbHumanCase thc ON thc.idfHumanCase = tm.idfHumanCase
		WHERE tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR)
											AS strSelectQuery
		, '
		UPDATE tm
		SET strCalculatedCaseID = thc.strCaseID
		FROM tlbMaterial tm
		JOIN tlbHumanCase thc ON thc.idfHumanCase = tm.idfHumanCase
		WHERE tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR)
											AS strFixQueryTemplate
		, 1
	FROM tlbMaterial tm
	JOIN tlbHumanCase thc ON 
		thc.idfHumanCase = tm.idfHumanCase
		AND thc.intRowStatus = 0
	WHERE tm.strCalculatedCaseID <> thc.strCaseID	
		AND tm.intRowStatus = 0
		
	UNION ALL

	SELECT
		'Calculated Field'					AS strProblemName
		, 'VS Session'						AS strRootObjectName
		, tvss.idfVectorSurveillanceSession	AS idfRootObjectID
		, tvss.strSessionID					AS strRootObjectID
		, 'tlbMaterial'						AS strInvalidTableName
		, tm.idfMaterial					AS idfInvalidObjectID
		, 'Calculated Case ID'				AS strInvalidConstraint
		, 'strCalculatedCaseID'				AS strInvalidFieldName
		, tm.strCalculatedCaseID			AS idfInvalidFieldValue
		, '
		SELECT tm.idfMaterial, tm.strFieldBarcode, tm.strBarcode, tm.strCalculatedCaseID, tvss.strSessionID FROM tlbMaterial tm
		JOIN tlbVectorSurveillanceSession tvss ON tvss.idfVectorSurveillanceSession = tm.idfVectorSurveillanceSession
		WHERE tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR)
											AS strSelectQuery
		, '
		UPDATE tm
		SET strCalculatedCaseID = tvss.strSessionID
		FROM tlbMaterial tm
		JOIN tlbVectorSurveillanceSession tvss ON tvss.idfVectorSurveillanceSession = tm.idfVectorSurveillanceSession
		WHERE tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR)
											AS strFixQueryTemplate
		, 1
	FROM tlbMaterial tm
	JOIN tlbVectorSurveillanceSession tvss ON 
		tvss.idfVectorSurveillanceSession = tm.idfVectorSurveillanceSession
		AND tvss.intRowStatus = 0
	WHERE tm.strCalculatedCaseID <> tvss.strSessionID	
		AND tm.intRowStatus = 0
		
	UNION ALL

	SELECT
		'Calculated Field'					AS strProblemName
		, 'Avian Vet Case'					AS strRootObjectName
		, tvc.idfVetCase					AS idfRootObjectID
		, tvc.strCaseID						AS strRootObjectID
		, 'tlbMaterial'						AS strInvalidTableName
		, tm.idfMaterial					AS idfInvalidObjectID
		, 'Calculated Case ID'				AS strInvalidConstraint
		, 'strCalculatedCaseID'				AS strInvalidFieldName
		, tm.strCalculatedCaseID			AS idfInvalidFieldValue
		, '
		SELECT tm.idfMaterial, tm.strFieldBarcode, tm.strBarcode, tm.strCalculatedCaseID, tvc.strCaseID FROM tlbMaterial tm
		tlbVetCase tvc ON tvc.idfVetCase = tm.idfVetCase
		WHERE tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR)
											AS strSelectQuery
		, '
		UPDATE tm
		SET strCalculatedCaseID = tvc.strCaseID
		FROM tlbMaterial tm
		tlbVetCase tvc ON tvc.idfVetCase = tm.idfVetCase
		WHERE tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR)
											AS strFixQueryTemplate
		, 1
	FROM tlbMaterial tm
	JOIN tlbVetCase tvc ON 
		tvc.idfVetCase = tm.idfVetCase
		AND tvc.intRowStatus = 0
		AND tvc.idfsCaseType = 10012004 /*Avian*/
	WHERE tm.strCalculatedCaseID <> tvc.strCaseID	
		AND tm.intRowStatus = 0
		
	UNION ALL

	SELECT
		'Calculated Field'					AS strProblemName
		, 'Livestock Vet Case'				AS strRootObjectName
		, tvc.idfVetCase					AS idfRootObjectID
		, tvc.strCaseID						AS strRootObjectID
		, 'tlbMaterial'						AS strInvalidTableName
		, tm.idfMaterial					AS idfInvalidObjectID
		, 'Calculated Case ID'				AS strInvalidConstraint
		, 'strCalculatedCaseID'				AS strInvalidFieldName
		, tm.strCalculatedCaseID			AS idfInvalidFieldValue
		, '
		SELECT tm.idfMaterial, tm.strFieldBarcode, tm.strBarcode, tm.strCalculatedCaseID, tvc.strCaseID FROM tlbMaterial tm
		tlbVetCase tvc ON tvc.idfVetCase = tm.idfVetCase
		WHERE tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR)
											AS strSelectQuery
		, '
		UPDATE tm
		SET strCalculatedCaseID = tvc.strCaseID
		FROM tlbMaterial tm
		tlbVetCase tvc ON tvc.idfVetCase = tm.idfVetCase
		WHERE tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR)
											AS strFixQueryTemplate
		, 1
	FROM tlbMaterial tm
	JOIN tlbVetCase tvc ON 
		tvc.idfVetCase = tm.idfVetCase
		AND tvc.intRowStatus = 0
		AND tvc.idfsCaseType = 10012003 /*Livestock*/
	WHERE tm.strCalculatedCaseID <> tvc.strCaseID	
		AND tm.intRowStatus = 0
