
--##SUMMARY

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 18.08.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spASSession_ValidateChildren
*/
CREATE PROCEDURE [dbo].[spASSession_ValidateChildren]
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
	/*1. Find all herds without species related with farm session (as farm that refer session, as as farm that referred by as session summary record) */
	SELECT
		'Mandatory child'			AS ProblemName
		, 'AS Session'				AS RootObjectName
		, idfMonitoringSession		AS RootId
		, strMonitoringSessionID	AS strRootID
		, 'tlbHerd'					AS InvalidTableName
		, idfHerd					AS InvalidObjectID
		, 'Absent species'			AS ConstraintName
		, NULL						AS InvalidFieldName
		, NULL						AS InvalidFieldValue
		, '
		SELECT
			*
		FROM (	
			SELECT
				tms.idfMonitoringSession
				, tms.strMonitoringSessionID
				, tf.idfFarm	
				, th.idfHerd
				, ts.idfSpecies
			FROM tlbMonitoringSession tms
			JOIN tlbFarm tf ON
				tf.idfMonitoringSession = tms.idfMonitoringSession
				AND tf.intRowStatus = 0
			JOIN tlbHerd th ON
				th.idfFarm = tf.idfFarm
				AND th.intRowStatus = 0
			LEFT JOIN tlbSpecies ts ON
				ts.idfHerd = th.idfHerd
				AND ts.intRowStatus = 0
			WHERE tms.intRowStatus = 0
			UNION
			SELECT
				tms.idfMonitoringSession
				, tms.strMonitoringSessionID
				, tf.idfFarm	
				, th.idfHerd
				, ts.idfSpecies
			FROM tlbMonitoringSession tms
			JOIN tlbMonitoringSessionSummary tmss ON
				tmss.idfMonitoringSession = tms.idfMonitoringSession
				AND tmss.intRowStatus = 0
			JOIN tlbFarm tf ON
				tf.idfFarm = tmss.idfFarm
				AND tf.intRowStatus = 0
			JOIN tlbHerd th ON
				th.idfFarm = tf.idfFarm
				AND th.intRowStatus = 0
			LEFT JOIN tlbSpecies ts ON
				ts.idfHerd = th.idfHerd
				AND ts.intRowStatus = 0
			WHERE tms.intRowStatus = 0
		) x
		WHERE idfHerd = ' + CAST(idfHerd AS VARCHAR(36))	
									AS SelectQuery
		, 'DELETE FROM tlbHerd WHERE idfHerd = ' + CAST(idfHerd AS VARCHAR(36))							
									AS FixQueryTemplate
		, 1							AS CanAutoFix
	FROM (	
		SELECT
			idfMonitoringSession
			, strMonitoringSessionID
			, idfHerd
		FROM (		
			SELECT
				tms.idfMonitoringSession
				, tms.strMonitoringSessionID
				, tf.idfFarm	
				, th.idfHerd
				, ts.idfSpecies
			FROM tlbMonitoringSession tms
			JOIN tlbFarm tf ON
				tf.idfMonitoringSession = tms.idfMonitoringSession
				AND tf.intRowStatus = 0
			JOIN tlbHerd th ON
				th.idfFarm = tf.idfFarm
				AND th.intRowStatus = 0
			LEFT JOIN tlbSpecies ts ON
				ts.idfHerd = th.idfHerd
				AND ts.intRowStatus = 0
			WHERE tms.intRowStatus = 0
			UNION
			SELECT
				tms.idfMonitoringSession
				, tms.strMonitoringSessionID
				, tf.idfFarm	
				, th.idfHerd
				, ts.idfSpecies
			FROM tlbMonitoringSession tms
			JOIN tlbMonitoringSessionSummary tmss ON
				tmss.idfMonitoringSession = tms.idfMonitoringSession
				AND tmss.intRowStatus = 0
			JOIN tlbFarm tf ON
				tf.idfFarm = tmss.idfFarm
				AND tf.intRowStatus = 0
			JOIN tlbHerd th ON
				th.idfFarm = tf.idfFarm
				AND th.intRowStatus = 0
			LEFT JOIN tlbSpecies ts ON
				ts.idfHerd = th.idfHerd
				AND ts.intRowStatus = 0
			WHERE tms.intRowStatus = 0
		) x
		GROUP BY idfMonitoringSession
			, strMonitoringSessionID
			, idfFarm
			, idfHerd
		HAVING COUNT(DISTINCT idfSpecies) = 0
	) HerdWithoutSpecies


	UNION ALL


	/*2. Find all not deleted sessions that are related with deleted campaign*/
	SELECT
		'Deleted parent'					AS ProblemName
		, 'AS Session'						AS RootObjectName
		, idfMonitoringSession				AS RootId
		, strMonitoringSessionID			AS strRootID
		, 'tlbMonitoringSession'			AS InvalidTableName
		, idfCampaign						AS InvalidObjectID
		, 'Deleted parent AS Campaign'		AS ConstraintName
		, 'idfCampaign'						AS InvalidFieldName
		, idfCampaign						AS InvalidFieldValue
		, 'SELECT * FROM tlbMonitoringSession WHERE idfMonitoringSession = ' + CAST(idfMonitoringSession AS VARCHAR(36)) 
											AS SelectQuery
		, 'UPDATE tlbMonitoringSession SET idfCampaign = NULL WHERE idfMonitoringSession = ' + CAST(idfMonitoringSession AS VARCHAR(36))
			 								AS FixQueryTemplate
		, 0									AS CanAutoFix
	FROM (
		SELECT
			tms.idfMonitoringSession
			, tms.strMonitoringSessionID
			, tms.idfCampaign
		FROM tlbMonitoringSession tms
		JOIN tlbCampaign tc ON
			tc.idfCampaign = tms.idfCampaign
			AND tc.intRowStatus = 1
		WHERE tms.intRowStatus = 0
	) NotDeletedSessionsRelatedWithDeletedCampaign


	UNION ALL


	/*3. Find all non deleted farms related with deleted As session.*/
	SELECT
		'Deleted parent'					AS ProblemName
		, 'AS Session'						AS RootObjectName
		, tms.idfMonitoringSession			AS RootId
		, strMonitoringSessionID			AS strRootID
		, 'tlbFarm'							AS InvalidTableName
		, tf.idfFarm						AS InvalidObjectID
		, 'Deleted parent AS Session'		AS ConstraintName
		, 'idfMonitoringSession'			AS InvalidFieldName
		, tms.idfMonitoringSession			AS InvalidFieldValue
		, 'SELECT * FROM tlbFarm WHERE idfFarm = ' + CAST(tf.idfFarm AS VARCHAR(36)) 
											AS SelectQuery
		, 'EXEC spFarm_Delete ' + CAST(tf.idfFarm AS VARCHAR(36))
		 									AS FixQueryTemplate
		, 1									AS CanAutoFix
	FROM tlbFarm tf	
	JOIN tlbMonitoringSession tms ON
		tms.idfMonitoringSession = tf.idfMonitoringSession
		AND tms.intRowStatus = 1
	WHERE tf.intRowStatus = 0
	UNION ALL
	SELECT
		'Deleted parent'					AS ProblemName
		, 'AS Session'						AS RootObjectName
		, tms.idfMonitoringSession			AS RootId
		, strMonitoringSessionID			AS strRootID
		, 'tlbFarm'							AS InvalidTableName
		, tf.idfFarm						AS InvalidObjectID
		, 'Deleted parent AS Session'		AS ConstraintName
		, NULL								AS InvalidFieldName
		, tms.idfMonitoringSession			AS InvalidFieldValue
		, 'SELECT * FROM tlbFarm WHERE idfFarm = ' + CAST(tf.idfFarm AS VARCHAR(36)) 
											AS SelectQuery
		, 'EXEC spFarm_Delete ' + CAST(tf.idfFarm AS VARCHAR(36))
		 									AS FixQueryTemplate
		, 1									AS CanAutoFix
	FROM tlbFarm tf
	JOIN tlbMonitoringSessionSummary tmss ON
		tmss.idfFarm = tf.idfFarm
		AND tmss.intRowStatus = 0
	JOIN tlbMonitoringSession tms ON
		tms.idfMonitoringSession = tmss.idfMonitoringSession
		AND tf.intRowStatus = 1
	WHERE tf.intRowStatus = 0


	UNION ALL


	/*4. Find al non deleted child session records  (tlbMonitoringSessionSummary, tlbMonitoringSessionToDiagnosis
	* , tlbMonitoringSessionAction)that belongs to deleted session*/

	SELECT
		'Deleted parent'					AS ProblemName
		, 'AS Session'						AS RootObjectName
		, tms.idfMonitoringSession			AS RootId
		, strMonitoringSessionID			AS strRootID
		, 'tlbMonitoringSessionSummary'		AS InvalidTableName
		, idfMonitoringSessionSummary		AS InvalidObjectID
		, 'Deleted parent AS Session'		AS ConstraintName
		, 'idfMonitoringSession'			AS InvalidFieldName
		, tms.idfMonitoringSession			AS InvalidFieldValue
		, 'SELECT * FROM tlbMonitoringSessionSummary WHERE idfMonitoringSessionSummary = ' + CAST(idfMonitoringSessionSummary AS VARCHAR(36)) 
											AS SelectQuery
		, 'DELETE FROM tlbMonitoringSessionSummary WHERE idfMonitoringSessionSummary = ' + CAST(idfMonitoringSessionSummary AS VARCHAR(36))
		 									AS FixQueryTemplate
		, 1									AS CanAutoFix
	FROM tlbMonitoringSession tms
	JOIN tlbMonitoringSessionSummary tmss ON
		tmss.idfMonitoringSession = tms.idfMonitoringSession
		AND tmss.intRowStatus = 0
	WHERE tms.intRowStatus = 1
	UNION ALL
	SELECT
		'Deleted parent'					AS ProblemName
		, 'AS Session'						AS RootObjectName
		, tms.idfMonitoringSession			AS RootId
		, strMonitoringSessionID			AS strRootID
		, 'tlbMonitoringSessionToDiagnosis'	AS InvalidTableName
		, idfMonitoringSessionToDiagnosis	AS InvalidObjectID
		, 'Deleted parent AS Session'		AS ConstraintName
		, 'idfMonitoringSession'			AS InvalidFieldName
		, tms.idfMonitoringSession			AS InvalidFieldValue
		, 'SELECT * FROM tlbMonitoringSessionToDiagnosis WHERE idfMonitoringSessionToDiagnosis = ' + CAST(idfMonitoringSessionToDiagnosis AS VARCHAR(36)) 
											AS SelectQuery
		, 'DELETE FROM tlbMonitoringSessionToDiagnosis WHERE idfMonitoringSessionToDiagnosis = ' + CAST(idfMonitoringSessionToDiagnosis AS VARCHAR(36))
		 									AS FixQueryTemplate
		, 1									AS CanAutoFix
	FROM tlbMonitoringSession tms
	JOIN tlbMonitoringSessionToDiagnosis tmstd ON
		tmstd.idfMonitoringSession = tms.idfMonitoringSession
		AND tmstd.intRowStatus = 0
	WHERE tms.intRowStatus = 1
	UNION ALL
	SELECT
		'Deleted parent'					AS ProblemName
		, 'AS Session'						AS RootObjectName
		, tms.idfMonitoringSession			AS RootId
		, strMonitoringSessionID			AS strRootID
		, 'tlbMonitoringSessionAction'		AS InvalidTableName
		, idfMonitoringSessionAction		AS InvalidObjectID
		, 'Deleted parent AS Session'		AS ConstraintName
		, 'idfMonitoringSession'			AS InvalidFieldName
		, tms.idfMonitoringSession			AS InvalidFieldValue
		, 'SELECT * FROM tlbMonitoringSessionAction WHERE idfMonitoringSessionAction = ' + CAST(idfMonitoringSessionAction AS VARCHAR(36)) 
											AS SelectQuery
		, 'DELETE FROM tlbMonitoringSessionAction WHERE idfMonitoringSessionAction = ' + CAST(idfMonitoringSessionAction AS VARCHAR(36))
		 									AS FixQueryTemplate
		, 1									AS CanAutoFix
	FROM tlbMonitoringSession tms
	JOIN tlbMonitoringSessionAction tmsa ON
		tmsa.idfMonitoringSession = tms.idfMonitoringSession
		AND tmsa.intRowStatus = 0
	WHERE tms.intRowStatus = 1


	UNION ALL


	/*5. Find al non deleted child session summary records  (tlbMonitoringSessionSummaryDiagnosis
	* , tlbMonitoringSessionSummarySample)that belongs to deleted session summary*/
	SELECT
		'Deleted parent'							AS ProblemName
		, 'AS Session'								AS RootObjectName
		, tmss.idfMonitoringSession					AS RootId
		, strMonitoringSessionID					AS strRootID
		, 'tlbMonitoringSessionSummaryDiagnosis'	AS InvalidTableName
		, tmss.idfMonitoringSessionSummary				AS InvalidObjectID
		, 'Deleted parent AS Session summary'		AS ConstraintName
		, 'idfMonitoringSessionSummary'				AS InvalidFieldName
		, tmss.idfMonitoringSessionSummary			AS InvalidFieldValue
		, 'SELECT * FROM tlbMonitoringSessionSummaryDiagnosis WHERE idfMonitoringSessionSummary = ' + CAST(tmss.idfMonitoringSessionSummary AS VARCHAR(36)) 
													AS SelectQuery
		, 'DELETE FROM tlbMonitoringSessionSummaryDiagnosis WHERE idfMonitoringSessionSummary = ' + CAST(tmss.idfMonitoringSessionSummary AS VARCHAR(36))
		 											AS FixQueryTemplate
		, 1											AS CanAutoFix
	FROM tlbMonitoringSessionSummary tmss
	JOIN tlbMonitoringSession tms ON
		tms.idfMonitoringSession = tmss.idfMonitoringSession
	JOIN tlbMonitoringSessionSummaryDiagnosis tmssd ON
		tmssd.idfMonitoringSessionSummary = tmss.idfMonitoringSessionSummary
		AND tmssd.intRowStatus = 0
	WHERE tmss.intRowStatus = 1
	UNION ALL
	SELECT
		'Deleted parent'							AS ProblemName
		, 'AS Session'								AS RootObjectName
		, tmss.idfMonitoringSession					AS RootId
		, strMonitoringSessionID					AS strRootID
		, 'tlbMonitoringSessionSummarySample'		AS InvalidTableName
		, tmss.idfMonitoringSessionSummary			AS InvalidObjectID
		, 'Deleted parent AS Session summary'		AS ConstraintName
		, 'idfMonitoringSessionSummary'				AS InvalidFieldName
		, tmss.idfMonitoringSessionSummary			AS InvalidFieldValue
		, 'SELECT * FROM tlbMonitoringSessionSummarySample WHERE idfMonitoringSessionSummary = ' + CAST(tmss.idfMonitoringSessionSummary AS VARCHAR(36)) 
													AS SelectQuery
		, 'DELETE FROM tlbMonitoringSessionSummarySample WHERE idfMonitoringSessionSummary = ' + CAST(tmss.idfMonitoringSessionSummary AS VARCHAR(36))
		 											AS FixQueryTemplate
		, 1											AS CanAutoFix
	FROM tlbMonitoringSessionSummary tmss
	JOIN tlbMonitoringSession tms ON
		tms.idfMonitoringSession = tmss.idfMonitoringSession
	JOIN tlbMonitoringSessionSummarySample tmsss ON
		tmsss.idfMonitoringSessionSummary = tmss.idfMonitoringSessionSummary
		AND tmsss.intRowStatus = 0
	WHERE tmss.intRowStatus = 1

