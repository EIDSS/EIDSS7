
--##SUMMARY root procedure for relations validation

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 07.09.2015

--##RETURNS dataset with incorrect records

/*
Example of procedure call:

EXEC spsysValidateRelations
*/

CREATE PROCEDURE [dbo].[spsysValidateRelations]
AS

--1. tlbAggrCase
	SELECT
		'Invalid Relation'			AS strProblemName
		, 'tlbAggrCase'				AS strRootObjectName
		, tac.idfAggrCase			AS idfRootObjectID
		, tac.strCaseID				AS strRootObjectID
		, 'tlbAggrCase'				AS strInvalidTableName
		, tac.idfAggrCase			AS idfInvalidObjectID
		, 'tlbPerson_tlbOffice'		AS strInvalidConstraint
		, 'idfReceivedByPerson'		AS strInvalidFieldName
		, tac.idfReceivedByPerson	AS strInvalidFieldValue
		, 'SELECT     
			tac.idfAggrCase     
			, tac.idfReceivedByPerson
			, tac.idfReceivedByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr1.name
		FROM tlbAggrCase tac
		JOIN tlbPerson tp ON     
			tp.idfPerson = tac.idfReceivedByPerson    
		LEFT JOIN tlbOffice to1 
			JOIN dbo.fnReferenceRepair(''en'', 19000045) frr1 ON     
				frr1.idfsReference = to1.idfsOfficeAbbreviation
		ON to1.idfOffice = tac.idfReceivedByOffice
		WHERE tac.intRowStatus = 0     
			AND tac.idfAggrCase = ' + CAST(tac.idfAggrCase AS NVARCHAR(20))
									AS strSelectQuery
	FROM tlbAggrCase tac
	JOIN tlbPerson tp ON
		tp.idfPerson = tac.idfReceivedByPerson
	WHERE tac.intRowStatus = 0
		AND ISNULL(tp.idfInstitution, -1) <> ISNULL(tac.idfReceivedByOffice, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, tac.strCaseID
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, 'tlbPerson_tlbOffice'
		, 'idfSentByPerson'
		, tac.idfSentByPerson
		, 'SELECT     
			tac.idfAggrCase  
			, tac.idfSentByPerson   
			, tac.idfSentByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr1.name    
		FROM tlbAggrCase tac
		JOIN tlbPerson tp ON     
			tp.idfPerson = tac.idfSentByPerson    
		LEFT JOIN tlbOffice to1 
			JOIN dbo.fnReferenceRepair(''en'', 19000045) frr1 ON     
				frr1.idfsReference = to1.idfsOfficeAbbreviation
		ON to1.idfOffice = tac.idfSentByOffice
		WHERE tac.intRowStatus = 0     
			AND tac.idfAggrCase = ' + CAST(tac.idfAggrCase AS NVARCHAR(20))
	FROM tlbAggrCase tac
	JOIN tlbPerson tp ON
		tp.idfPerson = tac.idfSentByPerson
	WHERE tac.intRowStatus = 0
		AND ISNULL(tp.idfInstitution, -1) <> ISNULL(tac.idfSentByOffice, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, tac.strCaseID
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, 'tlbPerson_tlbOffice'
		, 'idfEnteredByPerson'
		, tac.idfEnteredByPerson
		, 'SELECT     
			tac.idfAggrCase
			, tac.idfEnteredByPerson
			, tac.idfEnteredByOffice   
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr1.name    
		FROM tlbAggrCase tac
		JOIN tlbPerson tp ON     
			tp.idfPerson = tac.idfEnteredByPerson    
		LEFT JOIN tlbOffice to1 
			JOIN dbo.fnReferenceRepair(''en'', 19000045) frr1 ON     
				frr1.idfsReference = to1.idfsOfficeAbbreviation
		ON to1.idfOffice = tac.idfEnteredByOffice
		WHERE tac.intRowStatus = 0     
			AND tac.idfAggrCase = ' + CAST(tac.idfAggrCase AS NVARCHAR(20))
	FROM tlbAggrCase tac
	JOIN tlbPerson tp ON
		tp.idfPerson = tac.idfEnteredByPerson
	WHERE tac.intRowStatus = 0
		AND ISNULL(tp.idfInstitution, -1) <> ISNULL(tac.idfEnteredByOffice, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, tac.strCaseID
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, 'tlbAggrCase_tstSite'
		, 'idfEnteredByOffice'
		, tac.idfEnteredByOffice
		, 'SELECT     
			tac.idfAggrCase    
			, tac.idfsSite 
			, tac.idfEnteredByOffice     
			, ts.strHASCsiteID
			, frr1.name    
		FROM tlbAggrCase tac
		JOIN tstSite ts ON
			ts.idfsSite = tac.idfsSite
		LEFT JOIN tlbOffice to1 
			JOIN dbo.fnReferenceRepair(''en'', 19000045) frr1 ON     
				frr1.idfsReference = to1.idfsOfficeAbbreviation
		ON to1.idfOffice = tac.idfEnteredByOffice
		WHERE tac.intRowStatus = 0     
			AND tac.idfAggrCase = ' + CAST(tac.idfAggrCase AS NVARCHAR(20))
	FROM tlbAggrCase tac
	JOIN tstSite ts ON
		ts.idfsSite = tac.idfsSite
	WHERE tac.intRowStatus = 0
		AND ISNULL(ts.idfOffice, -1) <> ISNULL(tac.idfEnteredByOffice, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, tac.strCaseID
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, 'tlbObservation_ffFormTemplate'
		, 'idfDiagnosticObservation'
		, tac.idfDiagnosticObservation
		, 'SELECT     
			tac.idfAggrCase    
			, tac.idfDiagnosticObservation
			, fft.idfsFormType
		FROM tlbAggrCase tac
		JOIN tlbObservation to1 ON
			to1.idfObservation = tac.idfDiagnosticObservation
		LEFT JOIN ffFormTemplate fft ON
			fft.idfsFormTemplate = to1.idfsFormTemplate
		WHERE tac.intRowStatus = 0     
			AND tac.idfAggrCase = ' + CAST(tac.idfAggrCase AS NVARCHAR(20))
	FROM tlbAggrCase tac
	JOIN tlbObservation to1 ON
		to1.idfObservation = tac.idfDiagnosticObservation
	LEFT JOIN ffFormTemplate fft ON
		fft.idfsFormTemplate = to1.idfsFormTemplate
	WHERE tac.intRowStatus = 0
		AND ISNULL(fft.idfsFormType, -1) <> 10034023
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, tac.strCaseID
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, 'tlbObservation_ffFormTemplate'
		, 'idfProphylacticObservation'
		, tac.idfProphylacticObservation
		, 'SELECT     
			tac.idfAggrCase    
			, tac.idfProphylacticObservation
			, fft.idfsFormType
		FROM tlbAggrCase tac
		JOIN tlbObservation to1 ON
			to1.idfObservation = tac.idfProphylacticObservation
		LEFT JOIN ffFormTemplate fft ON
			fft.idfsFormTemplate = to1.idfsFormTemplate
		WHERE tac.intRowStatus = 0     
			AND tac.idfAggrCase = ' + CAST(tac.idfAggrCase AS NVARCHAR(20))
	FROM tlbAggrCase tac
	JOIN tlbObservation to1 ON
		to1.idfObservation = tac.idfProphylacticObservation
	LEFT JOIN ffFormTemplate fft ON
		fft.idfsFormTemplate = to1.idfsFormTemplate
	WHERE tac.intRowStatus = 0
		AND ISNULL(fft.idfsFormType, -1) <> 10034024
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, tac.strCaseID
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, 'tlbObservation_ffFormTemplate'
		, 'idfSanitaryObservation'
		, tac.idfSanitaryObservation
		, 'SELECT     
			tac.idfAggrCase    
			, tac.idfSanitaryObservation
			, fft.idfsFormType
		FROM tlbAggrCase tac
		JOIN tlbObservation to1 ON
			to1.idfObservation = tac.idfSanitaryObservation
		LEFT JOIN ffFormTemplate fft ON
			fft.idfsFormTemplate = to1.idfsFormTemplate
		WHERE tac.intRowStatus = 0     
			AND tac.idfAggrCase = ' + CAST(tac.idfAggrCase AS NVARCHAR(20))
	FROM tlbAggrCase tac
	JOIN tlbObservation to1 ON
		to1.idfObservation = tac.idfSanitaryObservation
	LEFT JOIN ffFormTemplate fft ON
		fft.idfsFormTemplate = to1.idfsFormTemplate
	WHERE tac.intRowStatus = 0
		AND ISNULL(fft.idfsFormType, -1) <> 10034022
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, tac.strCaseID
		, 'tlbAggrCase'
		, tac.idfAggrCase
		, 'tlbObservation_ffFormTemplate'
		, 'idfCaseObservation'
		, tac.idfCaseObservation
		, 'SELECT     
			tac.idfAggrCase    
			, tac.idfCaseObservation
			, fft.idfsFormType
		FROM tlbAggrCase tac
		JOIN tlbObservation to1 ON
			to1.idfObservation = tac.idfCaseObservation
		LEFT JOIN ffFormTemplate fft ON
			fft.idfsFormTemplate = to1.idfsFormTemplate
		WHERE tac.intRowStatus = 0     
			AND tac.idfAggrCase = ' + CAST(tac.idfAggrCase AS NVARCHAR(20))
	FROM tlbAggrCase tac
	JOIN tlbObservation to1 ON
		to1.idfObservation = tac.idfCaseObservation
	LEFT JOIN ffFormTemplate fft ON
		fft.idfsFormTemplate = to1.idfsFormTemplate
	WHERE tac.intRowStatus = 0
		AND (
				(tac.idfsAggrCaseType = 10102001 AND ISNULL(fft.idfsFormType, -1) <> 10034012)
				OR (tac.idfsAggrCaseType = 10102002 AND ISNULL(fft.idfsFormType, -1) <> 10034021)
			)
	UNION ALL
	
--2. tlbAnimal
	SELECT
		'Invalid Relation'
		, 'tlbAnimal'
		, ta.idfAnimal
		, ta.strName
		, 'tlbAnimal'
		, ta.idfAnimal
		, 'tlbObservation_ffFormTemplate'
		, 'idfObservation'
		, ta.idfObservation
		, 'SELECT     
			ta.idfAnimal    
			, ta.idfObservation
			, fft.idfsFormType
		FROM tlbAnimal ta
		JOIN tlbObservation to1 ON
			to1.idfObservation = ta.idfObservation
		LEFT JOIN ffFormTemplate fft ON
			fft.idfsFormTemplate = to1.idfsFormTemplate
		WHERE ta.intRowStatus = 0     
			AND ta.idfAnimal = ' + CAST(ta.idfAnimal AS NVARCHAR(20))
	FROM tlbAnimal ta
	JOIN tlbObservation to1 ON
		to1.idfObservation = ta.idfObservation
	LEFT JOIN ffFormTemplate fft ON
		fft.idfsFormTemplate = to1.idfsFormTemplate
	WHERE ta.intRowStatus = 0
		AND ISNULL(fft.idfsFormType, -1) <> 10034013
	UNION ALL	
	
--3. tlbBasicSyndromicSurveillance
	SELECT
		'Invalid Relation'
		, 'tlbBasicSyndromicSurveillance'
		, tbss.idfBasicSyndromicSurveillance
		, NULL
		, 'tlbBasicSyndromicSurveillance'
		, tbss.idfBasicSyndromicSurveillance
		, 'tlbPerson_tstSite'
		, 'idfEnteredBy'
		, tbss.idfEnteredBy
		, 'SELECT
				tbss.idfBasicSyndromicSurveillance
				, tbss.idfEnteredBy
				, tbss.idfsSite
				, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
				, ts.strHASCsiteID
			FROM tlbBasicSyndromicSurveillance tbss
			JOIN tlbPerson tp ON 
				tp.idfPerson = tbss.idfEnteredBy
			LEFT JOIN tstSite ts ON 
				ts.idfsSite = tbss.idfsSite
			WHERE tbss.intRowStatus = 0
				AND tbss.idfBasicSyndromicSurveillance = ' + CAST(tbss.idfBasicSyndromicSurveillance AS NVARCHAR(20))
	FROM tlbBasicSyndromicSurveillance tbss
	JOIN tlbPerson tp ON
		tp.idfPerson = tbss.idfEnteredBy
	LEFT JOIN tstSite ts ON
		ts.idfsSite = tbss.idfsSite
	WHERE tbss.intRowStatus = 0
		AND ISNULL(ts.idfOffice, -1) <> ISNULL(tp.idfInstitution, -1)
	UNION ALL
	
--4. tlbGeoLocation
	SELECT
		'Invalid Relation'
		, 'tlbGeoLocation'
		, tgl.idfGeoLocation
		, NULL
		, 'tlbGeoLocation'
		, tgl.idfGeoLocation
		, 'tlbGeoLocation_gisSettlement'
		, 'idfsSettlement'
		, tgl.idfsSettlement
		, 'SELECT
			tgl.idfGeoLocation
			, tgl.idfsSettlement
			, tgl.idfsRayon
			, fgrr1.name
			, fgrr2.name
		FROM tlbGeoLocation tgl
		JOIN dbo.fnGisReferenceRepair(''en'', 19000004) fgrr1 ON
			fgrr1.idfsReference = tgl.idfsSettlement
		LEFT JOIN dbo.fnGisReferenceRepair(''en'', 19000002) fgrr2 ON
			fgrr2.idfsReference = tgl.idfsRayon
		WHERE tgl.intRowStatus = 0
			AND tgl.idfGeoLocation = ' + CAST(tgl.idfGeoLocation AS NVARCHAR(20))
	FROM tlbGeoLocation tgl
	JOIN gisSettlement gs ON
		gs.idfsSettlement = tgl.idfsSettlement
	WHERE tgl.intRowStatus = 0
		AND ISNULL(gs.idfsRayon, -1) <> ISNULL(tgl.idfsRayon, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbGeoLocation'
		, tgl.idfGeoLocation
		, NULL
		, 'tlbGeoLocation'
		, tgl.idfGeoLocation
		, 'tlbGeoLocation_gisRayon'
		, 'idfsRayon'
		, tgl.idfsRayon
		, 'SELECT
			tgl.idfGeoLocation
			, tgl.idfsRayon
			, tgl.idfsRegion
			, fgrr1.name
			, fgrr2.name
		FROM tlbGeoLocation tgl
		JOIN dbo.fnGisReferenceRepair(''en'', 19000002) fgrr1 ON
			fgrr1.idfsReference = tgl.idfsRayon
		LEFT JOIN dbo.fnGisReferenceRepair(''en'', 19000003) fgrr2 ON
			fgrr2.idfsReference = tgl.idfsRegion
		WHERE tgl.intRowStatus = 0
			AND tgl.idfGeoLocation = ' + CAST(tgl.idfGeoLocation AS NVARCHAR(20))
	FROM tlbGeoLocation tgl
	JOIN gisRayon gr ON
		gr.idfsRayon = tgl.idfsRayon
	WHERE tgl.intRowStatus = 0
		AND ISNULL(gr.idfsRegion, -1) <> ISNULL(tgl.idfsRegion, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbGeoLocation'
		, tgl.idfGeoLocation
		, NULL
		, 'tlbGeoLocation'
		, tgl.idfGeoLocation
		, 'tlbGeoLocation_gisRegion'
		, 'idfsRegion'
		, tgl.idfsRegion
		, 'SELECT
			tgl.idfGeoLocation
			, tgl.idfsRegion
			, tgl.idfsCountry
			, fgrr1.name
			, fgrr2.name
		FROM tlbGeoLocation tgl
		JOIN dbo.fnGisReferenceRepair(''en'', 19000003) fgrr1 ON
			fgrr1.idfsReference = tgl.idfsRegion
		LEFT JOIN dbo.fnGisReferenceRepair(''en'', 19000001) fgrr2 ON
			fgrr2.idfsReference = tgl.idfsCountry
		WHERE tgl.intRowStatus = 0
			AND tgl.idfGeoLocation = ' + CAST(tgl.idfGeoLocation AS NVARCHAR(20))
	FROM tlbGeoLocation tgl
	JOIN gisRegion gr ON
		gr.idfsRegion = tgl.idfsRegion
	WHERE tgl.intRowStatus = 0
		AND ISNULL(gr.idfsCountry, -1) <> ISNULL(tgl.idfsCountry, -1)
	UNION ALL
	
--5. tlbGeoLocationShared
	SELECT
		'Invalid Relation'
		, 'tlbGeoLocationShared'
		, tgl.idfGeoLocationShared
		, NULL
		, 'tlbGeoLocationShared'
		, tgl.idfGeoLocationShared
		, 'tlbGeoLocationShared_gisSettlement'
		, 'idfsSettlement'
		, tgl.idfsSettlement
		, 'SELECT
			tgl.idfGeoLocationShared
			, tgl.idfsSettlement
			, tgl.idfsRayon
			, fgrr1.name
			, fgrr2.name
		FROM tlbGeoLocationShared tgl
		LEFT JOIN dbo.fnGisReferenceRepair(''en'', 19000001) fgrr1 ON
			fgrr1.idfsReference = tgl.idfsSettlement
		LEFT JOIN dbo.fnGisReferenceRepair(''en'', 19000002) fgrr2 ON
			fgrr2.idfsReference = tgl.idfsRayon
		WHERE tgl.intRowStatus = 0
			AND tgl.idfGeoLocationShared = ' + CAST(tgl.idfGeoLocationShared AS NVARCHAR(20))
	FROM tlbGeoLocationShared tgl
	JOIN gisSettlement gs ON
		gs.idfsSettlement = tgl.idfsSettlement
	WHERE tgl.intRowStatus = 0
		AND ISNULL(gs.idfsRayon, -1) <> ISNULL(tgl.idfsRayon, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbGeoLocationShared'
		, tgl.idfGeoLocationShared
		, NULL
		, 'tlbGeoLocationShared'
		, tgl.idfGeoLocationShared
		, 'tlbGeoLocationShared_gisRayon'
		, 'idfsRayon'
		, tgl.idfsRayon
		, 'SELECT
			tgl.idfGeoLocationShared
			, tgl.idfsRayon
			, tgl.idfsRegion
			, fgrr1.name
			, fgrr2.name
		FROM tlbGeoLocationShared tgl
		LEFT JOIN dbo.fnGisReferenceRepair(''en'', 19000002) fgrr1 ON
			fgrr1.idfsReference = tgl.idfsRayon
		LEFT JOIN dbo.fnGisReferenceRepair(''en'', 19000003) fgrr2 ON
			fgrr2.idfsReference = tgl.idfsRegion
		WHERE tgl.intRowStatus = 0
			AND tgl.idfGeoLocationShared = ' + CAST(tgl.idfGeoLocationShared AS NVARCHAR(20))
	FROM tlbGeoLocationShared tgl
	JOIN gisRayon gr ON
		gr.idfsRayon = tgl.idfsRayon
	WHERE tgl.intRowStatus = 0
		AND ISNULL(gr.idfsRegion, -1) <> ISNULL(tgl.idfsRegion, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbGeoLocationShared'
		, tgl.idfGeoLocationShared
		, NULL
		, 'tlbGeoLocationShared'
		, tgl.idfGeoLocationShared
		, 'tlbGeoLocationShared_gisRegion'
		, 'idfsRegion'
		, tgl.idfsRegion
		, 'SELECT
			tgl.idfGeoLocationShared
			, tgl.idfsRegion
			, tgl.idfsCountry
			, fgrr1.name
			, fgrr2.name
		FROM tlbGeoLocationShared tgl
		LEFT JOIN dbo.fnGisReferenceRepair(''en'', 19000003) fgrr1 ON
			fgrr1.idfsReference = tgl.idfsRegion
		LEFT JOIN dbo.fnGisReferenceRepair(''en'', 19000001) fgrr2 ON
			fgrr2.idfsReference = tgl.idfsCountry
		WHERE tgl.intRowStatus = 0
			AND tgl.idfGeoLocationShared = ' + CAST(tgl.idfGeoLocationShared AS NVARCHAR(20))
	FROM tlbGeoLocationShared tgl
	JOIN gisRegion gr ON
		gr.idfsRegion = tgl.idfsRegion
	WHERE tgl.intRowStatus = 0
		AND ISNULL(gr.idfsCountry, -1) <> ISNULL(tgl.idfsCountry, -1)
	UNION ALL
	
--6. tlbFarm
	SELECT
		'Invalid Relation'
		, 'tlbFarm'
		, tf.idfFarm
		, tf.strFarmCode
		, 'tlbFarm'
		, tf.idfFarm
		, 'tlbObservation_ffFormTemplate'
		, 'idfObservation'
		, tf.idfObservation
		, 'SELECT     
			tf.idfFarm    
			, tf.idfObservation
			, fft.idfsFormType
		FROM tlbFarm tf
		JOIN tlbObservation to1 ON
			to1.idfObservation = tf.idfObservation
		LEFT JOIN ffFormTemplate fft ON
			fft.idfsFormTemplate = to1.idfsFormTemplate
		WHERE tf.intRowStatus = 0     
			AND tf.idfFarm = ' + CAST(tf.idfFarm AS NVARCHAR(20))
	FROM tlbFarm tf
	JOIN tlbVetCase tvc ON
		tvc.idfFarm = tf.idfFarm
	JOIN tlbObservation to1 ON
		to1.idfObservation = tf.idfObservation
	LEFT JOIN ffFormTemplate fft ON
		fft.idfsFormTemplate = to1.idfsFormTemplate
	WHERE tf.intRowStatus = 0
		AND (
				(tvc.idfsCaseType = 10012003 /*Livestock*/ AND ISNULL(fft.idfsFormType, -1) <> 10034015)
				OR (tvc.idfsCaseType = 10012004 /*Avian*/ AND ISNULL(fft.idfsFormType, -1) <> 10034007)
			)
	UNION ALL	
	
--7. tlbHumanCase
	SELECT
		'Invalid Relation'
		, 'tlbHumanCase'
		, thc.idfHumanCase
		, thc.strCaseID
		, 'tlbHumanCase'
		, thc.idfHumanCase
		, 'tlbPerson_tlbOffice'
		, 'idfReceivedByPerson'
		, thc.idfReceivedByPerson
		, 'SELECT     
			thc.idfHumanCase   
			, thc.idfReceivedByPerson
			, thc.idfReceivedByOffice   
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr1.name    
		FROM tlbHumanCase thc
		JOIN tlbPerson tp ON     
			tp.idfPerson = thc.idfReceivedByPerson    
		LEFT JOIN tlbOffice to1 
			JOIN dbo.fnReferenceRepair(''en'', 19000045) frr1 ON     
				frr1.idfsReference = to1.idfsOfficeAbbreviation
		ON to1.idfOffice = thc.idfReceivedByOffice
		WHERE thc.intRowStatus = 0     
			AND thc.idfHumanCase = ' + CAST(thc.idfHumanCase AS NVARCHAR(20))
	FROM tlbHumanCase thc
	JOIN tlbPerson tp ON
		tp.idfPerson = thc.idfReceivedByPerson
	WHERE thc.intRowStatus = 0
		AND ISNULL(tp.idfInstitution, -1) <> ISNULL(thc.idfReceivedByOffice, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbHumanCase'
		, thc.idfHumanCase
		, thc.strCaseID
		, 'tlbHumanCase'
		, thc.idfHumanCase
		, 'tlbPerson_tlbOffice'
		, 'idfSentByPerson'
		, thc.idfSentByPerson
		, 'SELECT     
			thc.idfHumanCase
			, thc.idfSentByPerson
			, thc.idfSentByOffice     
			, tp.idfInstitution     
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr1.name
		FROM tlbHumanCase thc
		LEFT JOIN tlbPerson tp ON     
			tp.idfPerson = thc.idfSentByPerson    
		LEFT JOIN tlbOffice to1 
			JOIN dbo.fnReferenceRepair(''en'', 19000045) frr1 ON     
				frr1.idfsReference = to1.idfsOfficeAbbreviation
		ON to1.idfOffice = thc.idfSentByOffice
		WHERE thc.intRowStatus = 0     
			AND thc.idfHumanCase = ' + CAST(thc.idfHumanCase AS NVARCHAR(20))
	FROM tlbHumanCase thc
	JOIN tlbPerson tp ON
		tp.idfPerson = thc.idfSentByPerson
	WHERE thc.intRowStatus = 0
		AND ISNULL(tp.idfInstitution, -1) <> ISNULL(thc.idfSentByOffice, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbHumanCase'
		, thc.idfHumanCase
		, thc.strCaseID
		, 'tlbHumanCase'
		, thc.idfHumanCase
		, 'tlbPerson_tlbOffice'
		, 'idfInvestigatedByPerson'
		, thc.idfInvestigatedByPerson
		, 'SELECT     
			thc.idfHumanCase     
			, thc.idfInvestigatedByPerson
			, thc.idfInvestigatedByOffice        
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr1.name    
		FROM tlbHumanCase thc
		LEFT JOIN tlbPerson tp ON     
			tp.idfPerson = thc.idfInvestigatedByPerson    
		LEFT JOIN tlbOffice to1 
			JOIN dbo.fnReferenceRepair(''en'', 19000045) frr1 ON     
				frr1.idfsReference = to1.idfsOfficeAbbreviation
		ON to1.idfOffice = thc.idfInvestigatedByOffice
		WHERE thc.intRowStatus = 0     
			AND thc.idfHumanCase = ' + CAST(thc.idfHumanCase AS NVARCHAR(20))
	FROM tlbHumanCase thc
	JOIN tlbPerson tp ON
		tp.idfPerson = thc.idfInvestigatedByPerson
	WHERE thc.intRowStatus = 0
		AND ISNULL(tp.idfInstitution, -1) <> ISNULL(thc.idfInvestigatedByOffice, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbHumanCase'
		, thc.idfHumanCase
		, thc.strCaseID
		, 'tlbHumanCase'
		, thc.idfHumanCase
		, 'tlbPerson_tstSite'
		, 'idfPersonEnteredBy'
		, thc.idfPersonEnteredBy
		, 'SELECT     
			thc.idfHumanCase     
			, thc.idfPersonEnteredBy
			, thc.idfsSite
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, ts.strHASCsiteID
		FROM tlbHumanCase thc
		JOIN tlbPerson tp ON 
			tp.idfPerson = thc.idfPersonEnteredBy
		LEFT JOIN tstSite ts ON 
			ts.idfsSite = thc.idfsSite
		WHERE thc.intRowStatus = 0     
			AND thc.idfHumanCase = ' + CAST(thc.idfHumanCase AS NVARCHAR(20))
	FROM tlbHumanCase thc
	JOIN tlbPerson tp ON
		tp.idfPerson = thc.idfPersonEnteredBy
	LEFT JOIN tstSite ts ON
		ts.idfsSite = thc.idfsSite
	WHERE thc.intRowStatus = 0
		AND ISNULL(ts.idfOffice, -1) <> ISNULL(tp.idfInstitution, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbHumanCase'
		, thc.idfHumanCase
		, thc.strCaseID
		, 'tlbHumanCase'
		, thc.idfHumanCase
		, 'tlbObservation_ffFormTemplate'
		, 'idfEpiObservation'
		, thc.idfEpiObservation
		, 'SELECT     
			thc.idfHumanCase    
			, thc.idfEpiObservation
			, fft.idfsFormType
		FROM tlbHumanCase thc
		JOIN tlbObservation to1 ON
			to1.idfObservation = thc.idfEpiObservation
		LEFT JOIN ffFormTemplate fft ON
			fft.idfsFormTemplate = to1.idfsFormTemplate
		WHERE thc.intRowStatus = 0     
			AND thc.idfHumanCase = ' + CAST(thc.idfHumanCase AS NVARCHAR(20))
	FROM tlbHumanCase thc
	JOIN tlbObservation to1 ON
		to1.idfObservation = thc.idfEpiObservation
	LEFT JOIN ffFormTemplate fft ON
		fft.idfsFormTemplate = to1.idfsFormTemplate
	WHERE thc.intRowStatus = 0
		AND ISNULL(fft.idfsFormType, -1) <> 10034011
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbHumanCase'
		, thc.idfHumanCase
		, thc.strCaseID
		, 'tlbHumanCase'
		, thc.idfHumanCase
		, 'tlbObservation_ffFormTemplate'
		, 'idfCSObservation'
		, thc.idfCSObservation
		, 'SELECT     
			thc.idfHumanCase    
			, thc.idfCSObservation
			, fft.idfsFormType
		FROM tlbHumanCase thc
		JOIN tlbObservation to1 ON
			to1.idfObservation = thc.idfCSObservation
		LEFT JOIN ffFormTemplate fft ON
			fft.idfsFormTemplate = to1.idfsFormTemplate
		WHERE thc.intRowStatus = 0     
			AND thc.idfHumanCase = ' + CAST(thc.idfHumanCase AS NVARCHAR(20))
	FROM tlbHumanCase thc
	JOIN tlbObservation to1 ON
		to1.idfObservation = thc.idfCSObservation
	LEFT JOIN ffFormTemplate fft ON
		fft.idfsFormTemplate = to1.idfsFormTemplate
	WHERE thc.intRowStatus = 0
		AND ISNULL(fft.idfsFormType, -1) <> 10034010
	UNION ALL
	
--8. tlbMaterial
	SELECT
		'Invalid Relation'
		, 'tlbMaterial'
		, tm.idfMaterial
		, tm.strBarcode
		, 'tlbMaterial'
		, tm.idfMaterial
		, 'tlbDepartment_tstSite'
		, 'idfInDepartment'
		, tm.idfInDepartment
		, 'SELECT     
			tm.idfMaterial     
			, tm.idfInDepartment
			, tm.idfsCurrentSite
			, frr1.name     
			, ts.strHASCsiteID
		FROM tlbMaterial tm
		JOIN tlbDepartment td
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000164) frr1 ON
				frr1.idfsReference = td.idfsDepartmentName
		ON td.idfDepartment = tm.idfInDepartment
		LEFT JOIN tstSite ts ON 
			ts.idfsSite = tm.idfsCurrentSite
		WHERE tm.intRowStatus = 0     
			AND tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR(20))
	FROM tlbMaterial tm
	JOIN tlbDepartment td ON
		td.idfDepartment = tm.idfInDepartment
	LEFT JOIN tstSite ts ON
		ts.idfsSite = tm.idfsCurrentSite
	WHERE tm.intRowStatus = 0	
		AND ISNULL(ts.idfOffice, -1) <> ISNULL(td.idfOrganization, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbMaterial'
		, tm.idfMaterial
		, tm.strBarcode
		, 'tlbMaterial'
		, tm.idfMaterial
		, 'tlbPerson_tstSite'
		, 'idfDestroyedByPerson'
		, tm.idfDestroyedByPerson
		, 'SELECT     
			tm.idfMaterial     
			, tm.idfDestroyedByPerson
			, tm.idfsCurrentSite
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, ts.strHASCsiteID
		FROM tlbMaterial tm
		JOIN tlbPerson tp ON 
			tp.idfPerson = tm.idfDestroyedByPerson
		LEFT JOIN tstSite ts ON 
			ts.idfsSite = tm.idfsCurrentSite
		WHERE tm.intRowStatus = 0     
			AND tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR(20))
	FROM tlbMaterial tm
	JOIN tlbPerson tp ON
		tp.idfPerson = tm.idfDestroyedByPerson
	LEFT JOIN tstSite ts ON
		ts.idfsSite = tm.idfsCurrentSite
	WHERE tm.intRowStatus = 0	
		AND ISNULL(ts.idfOffice, -1) <> ISNULL(tp.idfInstitution, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbMaterial'
		, tm.idfMaterial
		, tm.strBarcode
		, 'tlbMaterial'
		, tm.idfMaterial
		, 'tlbPerson_tstSite'
		, 'idfAccesionByPerson'
		, tm.idfAccesionByPerson
		, 'SELECT     
			tm.idfMaterial     
			, tm.idfAccesionByPerson
			, tm.idfsCurrentSite
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, ts.strHASCsiteID   
		FROM tlbMaterial tm
		JOIN tlbPerson tp ON 
			tp.idfPerson = tm.idfAccesionByPerson
		LEFT JOIN tstSite ts ON 
			ts.idfsSite = tm.idfsCurrentSite
		WHERE tm.intRowStatus = 0     
			AND tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR(20))
	FROM tlbMaterial tm
	JOIN tlbPerson tp ON
		tp.idfPerson = tm.idfAccesionByPerson
	LEFT JOIN tstSite ts ON
		ts.idfsSite = tm.idfsCurrentSite
	WHERE tm.intRowStatus = 0	
		AND ISNULL(ts.idfOffice, -1) <> ISNULL(tp.idfInstitution, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbMaterial'
		, tm.idfMaterial
		, tm.strBarcode
		, 'tlbMaterial'
		, tm.idfMaterial
		, 'tlbPerson_tstSite'
		, 'idfMarkedForDispositionByPerson'
		, tm.idfMarkedForDispositionByPerson
		, 'SELECT     
			tm.idfMaterial     
			, tm.idfMarkedForDispositionByPerson
			, tm.idfsCurrentSite
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, ts.strHASCsiteID
		FROM tlbMaterial tm
		JOIN tlbPerson tp ON 
			tp.idfPerson = tm.idfMarkedForDispositionByPerson
		LEFT JOIN tstSite ts ON 
			ts.idfsSite = tm.idfsCurrentSite
		WHERE tm.intRowStatus = 0     
			AND tm.idfMaterial = ' + CAST(tm.idfMaterial AS NVARCHAR(20))
	FROM tlbMaterial tm
	JOIN tlbPerson tp ON
		tp.idfPerson = tm.idfMarkedForDispositionByPerson
	LEFT JOIN tstSite ts ON
		ts.idfsSite = tm.idfsCurrentSite
	WHERE tm.intRowStatus = 0	
		AND ISNULL(ts.idfOffice, -1) <> ISNULL(tp.idfInstitution, -1)	
	UNION ALL
	
--9. tlbMonitoringSession
	SELECT
		'Invalid Relation'
		, 'tlbMonitoringSession'
		, tms.idfMonitoringSession
		, tms.strMonitoringSessionID
		, 'tlbMonitoringSession'
		, tms.idfMonitoringSession
		, 'tlbMonitoringSession_gisSettlement'
		, 'idfsSettlement'
		, tms.idfsSettlement
		, 'SELECT     
			tms.idfMonitoringSession
			, tms.idfsSettlement
			, tms.idfsRayon
			, fgrr1.name
			, fgrr2.name
		FROM tlbMonitoringSession tms
		JOIN dbo.fnGisReferenceRepair(''en'', 19000004) fgrr1 ON
				fgrr1.idfsReference = tms.idfsSettlement
		LEFT JOIN dbo.fnGisReferenceRepair(''en'', 19000002) fgrr2 ON
				fgrr2.idfsReference = tms.idfsRayon
		WHERE tms.intRowStatus = 0     
			AND tms.idfMonitoringSession = ' + CAST(tms.idfMonitoringSession AS NVARCHAR(20))
	FROM tlbMonitoringSession tms
	JOIN gisSettlement gs ON
		gs.idfsSettlement = tms.idfsSettlement
	WHERE tms.intRowStatus = 0	
		AND ISNULL(gs.idfsRayon, -1) <> ISNULL(tms.idfsRayon, -1)	
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbMonitoringSession'
		, tms.idfMonitoringSession
		, tms.strMonitoringSessionID
		, 'tlbMonitoringSession'
		, tms.idfMonitoringSession
		, 'tlbMonitoringSession_gisRayon'
		, 'idfsRegion'
		, tms.idfsRegion
		, 'SELECT     
			tms.idfMonitoringSession
			, tms.idfsRayon
			, tms.idfsRegion
			, fgrr1.name
			, fgrr2.name
		FROM tlbMonitoringSession tms
		JOIN dbo.fnGisReferenceRepair(''en'', 19000002) fgrr1 ON
			fgrr1.idfsReference = tms.idfsRayon
		LEFT JOIN dbo.fnGisReferenceRepair(''en'', 19000003) fgrr2 ON
			fgrr2.idfsReference = tms.idfsRegion
		WHERE tms.intRowStatus = 0     
			AND tms.idfMonitoringSession = ' + CAST(tms.idfMonitoringSession AS NVARCHAR(20))
	FROM tlbMonitoringSession tms
	JOIN gisRayon gr ON
		gr.idfsRayon = tms.idfsRayon
	WHERE tms.intRowStatus = 0	
		AND ISNULL(gr.idfsRegion, -1) <> ISNULL(tms.idfsRegion, -1)	
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbMonitoringSession'
		, tms.idfMonitoringSession
		, tms.strMonitoringSessionID
		, 'tlbMonitoringSession'
		, tms.idfMonitoringSession
		, 'tlbMonitoringSession_gisRegion'
		, 'idfsCountry'
		, tms.idfsCountry
		, 'SELECT     
			tms.idfMonitoringSession
			, tms.idfsRegion
			, tms.idfsCountry
			, fgrr1.name
			, fgrr2.name
		FROM tlbMonitoringSession tms
		JOIN dbo.fnGisReferenceRepair(''en'', 19000003) fgrr1 ON
			fgrr1.idfsReference = tms.idfsCountry
		LEFT JOIN dbo.fnGisReferenceRepair(''en'', 19000001) fgrr2 ON
			fgrr2.idfsReference = tms.idfsCountry
		WHERE tms.intRowStatus = 0     
			AND tms.idfMonitoringSession = ' + CAST(tms.idfMonitoringSession AS NVARCHAR(20))
	FROM tlbMonitoringSession tms
	JOIN gisRegion gr ON
		gr.idfsRegion = tms.idfsRegion
	WHERE tms.intRowStatus = 0	
		AND ISNULL(gr.idfsCountry, -1) <> ISNULL(tms.idfsCountry, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbMonitoringSession'
		, tms.idfMonitoringSession
		, tms.strMonitoringSessionID
		, 'tlbMonitoringSession'
		, tms.idfMonitoringSession
		, 'tlbPerson_tstSite'
		, 'idfPersonEnteredBy'
		, tms.idfPersonEnteredBy
		, 'SELECT
			tms.idfMonitoringSession
			, tms.idfPersonEnteredBy
			, tms.idfsSite
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, ts.strHASCsiteID
		FROM tlbMonitoringSession tms
		JOIN tlbPerson tp ON 
			tp.idfPerson = tms.idfPersonEnteredBy
		LEFT JOIN tstSite ts ON 
			ts.idfsSite = tms.idfsSite
		WHERE tms.intRowStatus = 0
			AND tms.idfMonitoringSession = ' + CAST(tms.idfMonitoringSession AS NVARCHAR(20))
	FROM tlbMonitoringSession tms
	JOIN tlbPerson tp ON
		tp.idfPerson = tms.idfPersonEnteredBy
	LEFT JOIN tstSite ts ON
		ts.idfsSite = tms.idfsSite
	WHERE tms.intRowStatus = 0
		AND ISNULL(ts.idfOffice, -1) <> ISNULL(tp.idfInstitution, -1)	
	UNION ALL	
	
--10. tlbPensideTest
	SELECT
		'Invalid Relation'
		, 'tlbPensideTest'
		, tpt.idfPensideTest
		, NULL
		, 'tlbPensideTest'
		, tpt.idfPensideTest
		, 'tlbPerson_tlbOffice'
		, 'idfTestedByPerson'
		, tpt.idfTestedByPerson
		, 'SELECT
			tpt.idfPensideTest
			, tpt.idfTestedByPerson
			, tpt.idfTestedByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbPensideTest tpt
		JOIN tlbPerson tp ON 
			tp.idfPerson = tpt.idfTestedByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tpt.idfTestedByOffice
		WHERE tpt.intRowStatus = 0
			AND tpt.idfPensideTest = ' + CAST(tpt.idfPensideTest AS NVARCHAR(20))
	FROM tlbPensideTest tpt
	JOIN tlbPerson tp ON
		tp.idfPerson = tpt.idfTestedByPerson
	WHERE tpt.intRowStatus = 0
		AND ISNULL(tpt.idfTestedByOffice, -1) <> ISNULL(tp.idfInstitution, -1)	
	UNION ALL	
	
--11. tlbPerson
	SELECT
		'Invalid Relation'
		, 'tlbPerson'
		, tp.idfPerson
		, NULL
		, 'tlbPerson'
		, tp.idfPerson
		, 'tlbPerson_tlbDepartment'
		, 'idfDepartment'
		, tp.idfDepartment
		, 'SELECT
			tp.idfPerson
			, tp.idfDepartment
			, tp.idfInstitution
			, frr1.name
			, frr2.name
		FROM tlbPerson tp
		JOIN tlbDepartment td
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000164) frr1 ON
				frr1.idfsReference = td.idfsDepartmentName
		ON td.idfDepartment = tp.idfDepartment		
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tp.idfInstitution
		WHERE tp.intRowStatus = 0
			AND tp.idfPerson = ' + CAST(tp.idfPerson AS NVARCHAR(20))
	FROM tlbPerson tp
	JOIN tlbDepartment td ON
		td.idfDepartment = tp.idfDepartment
	WHERE tp.intRowStatus = 0
		AND ISNULL(td.idfOrganization, -1) <> ISNULL(tp.idfInstitution, -1)
	UNION ALL	
	
--12. tlbTestAmendmentHistory
	SELECT
		'Invalid Relation'
		, 'tlbTestAmendmentHistory'
		, ttah.idfTestAmendmentHistory
		, NULL
		, 'tlbTestAmendmentHistory'
		, ttah.idfTestAmendmentHistory
		, 'tlbPerson_tlbOffice'
		, 'idfAmendByPerson'
		, ttah.idfAmendByPerson
		, 'SELECT
			ttah.idfTestAmendmentHistory
			, ttah.idfAmendByPerson
			, ttah.idfAmendByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbTestAmendmentHistory ttah
		JOIN tlbPerson tp ON
			tp.idfPerson = ttah.idfAmendByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = ttah.idfAmendByOffice
		WHERE ttah.intRowStatus = 0
			AND ttah.idfTestAmendmentHistory = ' + CAST(ttah.idfTestAmendmentHistory AS NVARCHAR(20))
	FROM tlbTestAmendmentHistory ttah
	JOIN tlbPerson tp ON
		tp.idfPerson = ttah.idfAmendByPerson
	WHERE ttah.intRowStatus = 0
		AND ISNULL(ttah.idfAmendByOffice, -1) <> ISNULL(tp.idfInstitution, -1)
	UNION ALL	
	
--13. tlbBatchTest
	SELECT
		'Invalid Relation'
		, 'tlbBatchTest'
		, tbt.idfBatchTest
		, tbt.strBarcode
		, 'tlbBatchTest'
		, tbt.idfBatchTest
		, 'tlbPerson_tlbOffice'
		, 'idfPerformedByPerson'
		, tbt.idfPerformedByPerson
		, 'SELECT
			tbt.idfBatchTest
			, tbt.idfPerformedByPerson
			, tbt.idfPerformedByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbBatchTest tbt
		JOIN tlbPerson tp ON
			tp.idfPerson = tbt.idfPerformedByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tbt.idfPerformedByOffice
		WHERE tbt.intRowStatus = 0
			AND tbt.idfBatchTest = ' + CAST(tbt.idfBatchTest AS NVARCHAR(20))
	FROM tlbBatchTest tbt
	JOIN tlbPerson tp ON
		tp.idfPerson = tbt.idfPerformedByPerson
	WHERE tbt.intRowStatus = 0
		AND ISNULL(tbt.idfPerformedByOffice, -1) <> ISNULL(tp.idfInstitution, -1)	
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbBatchTest'
		, tbt.idfBatchTest
		, tbt.strBarcode
		, 'tlbBatchTest'
		, tbt.idfBatchTest
		, 'tlbPerson_tlbOffice'
		, 'idfValidatedByPerson'
		, tbt.idfValidatedByPerson
		, 'SELECT
			tbt.idfBatchTest
			, tbt.idfValidatedByPerson
			, tbt.idfValidatedByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbBatchTest tbt
		JOIN tlbPerson tp ON
			tp.idfPerson = tbt.idfValidatedByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tbt.idfValidatedByOffice
		WHERE tbt.intRowStatus = 0
			AND tbt.idfBatchTest = ' + CAST(tbt.idfBatchTest AS NVARCHAR(20))
	FROM tlbBatchTest tbt
	JOIN tlbPerson tp ON
		tp.idfPerson = tbt.idfValidatedByPerson
	WHERE tbt.intRowStatus = 0
		AND ISNULL(tbt.idfValidatedByOffice, -1) <> ISNULL(tp.idfInstitution, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbBatchTest'
		, tbt.idfBatchTest
		, tbt.strBarcode
		, 'tlbBatchTest'
		, tbt.idfBatchTest
		, 'tlbPerson_tlbOffice'
		, 'idfResultEnteredByPerson'
		, tbt.idfResultEnteredByPerson
		, 'SELECT
			tbt.idfBatchTest
			, tbt.idfResultEnteredByPerson
			, tbt.idfResultEnteredByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbBatchTest tbt
		JOIN tlbPerson tp ON
			tp.idfPerson = tbt.idfResultEnteredByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tbt.idfResultEnteredByOffice
		WHERE tbt.intRowStatus = 0
			AND tbt.idfBatchTest = ' + CAST(tbt.idfBatchTest AS NVARCHAR(20))
	FROM tlbBatchTest tbt
	JOIN tlbPerson tp ON
		tp.idfPerson = tbt.idfResultEnteredByPerson
	WHERE tbt.intRowStatus = 0
		AND ISNULL(tbt.idfResultEnteredByOffice, -1) <> ISNULL(tp.idfInstitution, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbBatchTest'
		, tbt.idfBatchTest
		, tbt.strBarcode
		, 'tlbBatchTest'
		, tbt.idfBatchTest
		, 'tlbObservation_ffFormTemplate'
		, 'idfObservation'
		, tbt.idfObservation
		, 'SELECT     
			tbt.idfBatchTest    
			, tbt.idfObservation
			, fft.idfsFormType
		FROM tlbBatchTest tbt
		JOIN tlbObservation to1 ON
			to1.idfObservation = tbt.idfObservation
		LEFT JOIN ffFormTemplate fft ON
			fft.idfsFormTemplate = to1.idfsFormTemplate
		WHERE tbt.intRowStatus = 0     
			AND tbt.idfBatchTest = ' + CAST(tbt.idfBatchTest AS NVARCHAR(20))
	FROM tlbBatchTest tbt
	JOIN tlbObservation to1 ON
		to1.idfObservation = tbt.idfObservation
	LEFT JOIN ffFormTemplate fft ON
		fft.idfsFormTemplate = to1.idfsFormTemplate
	WHERE tbt.intRowStatus = 0
		AND ISNULL(fft.idfsFormType, -1) <> 10034019
	UNION ALL
	
--14. tlbTesting
	SELECT
		'Invalid Relation'
		, 'tlbTesting'
		, tt.idfTesting
		, NULL
		, 'tlbTesting'
		, tt.idfTesting
		, 'tlbPerson_tlbOffice'
		, 'idfTestedByPerson'
		, tt.idfTestedByPerson
		, 'SELECT
			tt.idfTesting
			, tt.idfTestedByPerson
			, tt.idfTestedByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbTesting tt
		JOIN tlbPerson tp ON
			tp.idfPerson = tt.idfTestedByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tt.idfTestedByOffice
		WHERE tt.intRowStatus = 0
			AND tt.idfTesting = ' + CAST(tt.idfTesting AS NVARCHAR(20))
	FROM tlbTesting tt
	JOIN tlbPerson tp ON
		tp.idfPerson = tt.idfTestedByPerson
	WHERE tt.intRowStatus = 0
		AND ISNULL(tt.idfTestedByOffice, -1) <> ISNULL(tp.idfInstitution, -1)	
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbTesting'
		, tt.idfTesting
		, NULL
		, 'tlbTesting'
		, tt.idfTesting
		, 'tlbPerson_tlbOffice'
		, 'idfResultEnteredByPerson'
		, tt.idfResultEnteredByPerson
		, 'SELECT
			tt.idfTesting
			, tt.idfResultEnteredByPerson
			, tt.idfResultEnteredByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbTesting tt
		JOIN tlbPerson tp ON
			tp.idfPerson = tt.idfResultEnteredByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tt.idfResultEnteredByOffice
		WHERE tt.intRowStatus = 0
			AND tt.idfTesting = ' + CAST(tt.idfTesting AS NVARCHAR(20))
	FROM tlbTesting tt
	JOIN tlbPerson tp ON
		tp.idfPerson = tt.idfResultEnteredByPerson
	WHERE tt.intRowStatus = 0
		AND ISNULL(tt.idfResultEnteredByOffice, -1) <> ISNULL(tp.idfInstitution, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbTesting'
		, tt.idfTesting
		, NULL
		, 'tlbTesting'
		, tt.idfTesting
		, 'tlbPerson_tlbOffice'
		, 'idfValidatedByPerson'
		, tt.idfValidatedByPerson
		, 'SELECT
			tt.idfTesting
			, tt.idfValidatedByPerson
			, tt.idfValidatedByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbTesting tt
		JOIN tlbPerson tp ON
			tp.idfPerson = tt.idfValidatedByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tt.idfValidatedByOffice
		WHERE tt.intRowStatus = 0
			AND tt.idfTesting = ' + CAST(tt.idfTesting AS NVARCHAR(20))
	FROM tlbTesting tt
	JOIN tlbPerson tp ON
		tp.idfPerson = tt.idfValidatedByPerson
	WHERE tt.intRowStatus = 0
		AND ISNULL(tt.idfValidatedByOffice, -1) <> ISNULL(tp.idfInstitution, -1)	
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbTesting'
		, tt.idfTesting
		, NULL
		, 'tlbTesting'
		, tt.idfTesting
		, 'tlbObservation_ffFormTemplate'
		, 'idfObservation'
		, tt.idfObservation
		, 'SELECT     
			tt.idfTesting    
			, tt.idfObservation
			, fft.idfsFormType
		FROM tlbTesting tt
		JOIN tlbObservation to1 ON
			to1.idfObservation = tt.idfObservation
		LEFT JOIN ffFormTemplate fft ON
			fft.idfsFormTemplate = to1.idfsFormTemplate
		WHERE tt.intRowStatus = 0     
			AND tt.idfTesting = ' + CAST(tt.idfTesting AS NVARCHAR(20))
	FROM tlbTesting tt
	JOIN tlbObservation to1 ON
		to1.idfObservation = tt.idfObservation
	LEFT JOIN ffFormTemplate fft ON
		fft.idfsFormTemplate = to1.idfsFormTemplate
	WHERE tt.intRowStatus = 0
		AND ISNULL(fft.idfsFormType, -1) <> 10034018
	UNION ALL
	
--15. tlbTestValidation
	SELECT
		'Invalid Relation'
		, 'tlbTestValidation'
		, ttv.idfTestValidation
		, NULL
		, 'tlbTestValidation'
		, ttv.idfTestValidation
		, 'tlbPerson_tlbOffice'
		, 'idfValidatedByPerson'
		, ttv.idfValidatedByPerson
		, 'SELECT
			ttv.idfTestValidation
			, ttv.idfTestedByPerson
			, ttv.idfValidatedByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbTestValidation ttv
		JOIN tlbPerson tp ON
			tp.idfPerson = ttv.idfValidatedByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = ttv.idfValidatedByOffice
		WHERE ttv.intRowStatus = 0
			AND ttv.idfTestValidation = ' + CAST(ttv.idfTestValidation AS NVARCHAR(20))
	FROM tlbTestValidation ttv
	JOIN tlbPerson tp ON
		tp.idfPerson = ttv.idfValidatedByPerson
	WHERE ttv.intRowStatus = 0
		AND ISNULL(ttv.idfValidatedByOffice, -1) <> ISNULL(tp.idfInstitution, -1)	
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbTestValidation'
		, ttv.idfTestValidation
		, NULL
		, 'tlbTestValidation'
		, ttv.idfTestValidation
		, 'tlbPerson_tlbOffice'
		, 'idfInterpretedByPerson'
		, ttv.idfInterpretedByPerson
		, 'SELECT
			ttv.idfTestValidation
			, ttv.idfInterpretedByPerson
			, ttv.idfInterpretedByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbTestValidation ttv
		JOIN tlbPerson tp ON
			tp.idfPerson = ttv.idfInterpretedByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = ttv.idfInterpretedByOffice
		WHERE ttv.intRowStatus = 0
			AND ttv.idfTestValidation = ' + CAST(ttv.idfTestValidation AS NVARCHAR(20))
	FROM tlbTestValidation ttv
	JOIN tlbPerson tp ON
		tp.idfPerson = ttv.idfInterpretedByPerson
	WHERE ttv.intRowStatus = 0
		AND ISNULL(ttv.idfInterpretedByOffice, -1) <> ISNULL(tp.idfInstitution, -1)	
	UNION ALL
	
--16. tlbTransferOUT
	SELECT
		'Invalid Relation'
		, 'tlbTransferOUT'
		, tto.idfTransferOut
		, NULL
		, 'tlbTransferOUT'
		, tto.idfTransferOut
		, 'tlbPerson_tlbOffice'
		, 'idfSendByPerson'
		, tto.idfSendByPerson
		, 'SELECT
			tto.idfTransferOut
			, tto.idfSendByPerson
			, tto.idfSendFromOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbTransferOUT tto
		JOIN tlbPerson tp ON
			tp.idfPerson = tto.idfSendByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tto.idfSendFromOffice
		WHERE tto.intRowStatus = 0
			AND tto.idfTransferOut = ' + CAST(tto.idfTransferOut AS NVARCHAR(20))
	FROM tlbTransferOUT tto
	JOIN tlbPerson tp ON
		tp.idfPerson = tto.idfSendByPerson
	WHERE tto.intRowStatus = 0
		AND ISNULL(tto.idfSendFromOffice, -1) <> ISNULL(tp.idfInstitution, -1)		
	UNION ALL
	
--17. tlbVector
	SELECT
		'Invalid Relation'
		, 'tlbVector'
		, tv.idfVector
		, tv.strVectorID
		, 'tlbVector'
		, tv.idfVector
		, 'tlbPerson_tlbOffice'
		, 'idfCollectedByPerson'
		, tv.idfCollectedByPerson
		, 'SELECT
			tv.idfVector
			, tv.idfCollectedByPerson
			, tv.idfCollectedByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbVector tv
		JOIN tlbPerson tp ON
			tp.idfPerson = tv.idfCollectedByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tv.idfCollectedByOffice
		WHERE tv.intRowStatus = 0
			AND tv.idfVector = ' + CAST(tv.idfVector AS NVARCHAR(20))
	FROM tlbVector tv
	JOIN tlbPerson tp ON
		tp.idfPerson = tv.idfCollectedByPerson
	WHERE tv.intRowStatus = 0
		AND ISNULL(tv.idfCollectedByOffice, -1) <> ISNULL(tp.idfInstitution, -1)	
	UNION ALL	
	SELECT
		'Invalid Relation'
		, 'tlbVector'
		, tv.idfVector
		, tv.strVectorID
		, 'tlbVector'
		, tv.idfVector
		, 'tlbPerson_tlbOffice'
		, 'idfIdentifiedByPerson'
		, tv.idfIdentifiedByPerson
		, 'SELECT
			tv.idfVector
			, tv.idfIdentifiedByPerson
			, tv.idfIdentifiedByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbVector tv
		JOIN tlbPerson tp ON
			tp.idfPerson = tv.idfIdentifiedByPerson
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tv.idfIdentifiedByOffice
		WHERE tv.intRowStatus = 0
			AND tv.idfVector = ' + CAST(tv.idfVector AS NVARCHAR(20))
	FROM tlbVector tv
	JOIN tlbPerson tp ON
		tp.idfPerson = tv.idfIdentifiedByPerson
	WHERE tv.intRowStatus = 0
		AND ISNULL(tv.idfIdentifiedByOffice, -1) <> ISNULL(tp.idfInstitution, -1)	
	UNION ALL	
	SELECT
		'Invalid Relation'
		, 'tlbVector'
		, tv.idfVector
		, tv.strVectorID
		, 'tlbVector'
		, tv.idfVector
		, 'trtVectorSubType_trtVectorType'
		, 'idfsVectorSubType'
		, tv.idfsVectorSubType
		, 'SELECT
			tv.idfVector
			, tv.idfsVectorSubType
			, tv.idfsVectorType
			, frr1.name
			, frr2.name
		FROM tlbVector tv
		JOIN dbo.fnReferenceRepair(''en'', 19000141) frr2 ON
			frr2.idfsReference = tv.idfsVectorSubType
		LEFT JOIN dbo.fnReferenceRepair(''en'', 19000140) frr2 ON
			frr2.idfsReference = tv.idfsVectorType
		WHERE tv.intRowStatus = 0
			AND tv.idfVector = ' + CAST(tv.idfVector AS NVARCHAR(20))
	FROM tlbVector tv
	JOIN trtVectorSubType tvst ON
		tvst.idfsVectorSubType = tv.idfsVectorSubType
	WHERE tv.intRowStatus = 0
		AND ISNULL(tv.idfsVectorType, -1) <> ISNULL(tvst.idfsVectorType, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbVector'
		, tv.idfVector
		, tv.strVectorID
		, 'tlbVector'
		, tv.idfVector
		, 'tlbObservation_ffFormTemplate'
		, 'idfObservation'
		, tv.idfObservation
		, 'SELECT     
			tv.idfVector    
			, tv.idfObservation
			, fft.idfsFormType
		FROM tlbVector tv
		JOIN tlbObservation to1 ON
			to1.idfObservation = tv.idfObservation
		LEFT JOIN ffFormTemplate fft ON
			fft.idfsFormTemplate = to1.idfsFormTemplate
		WHERE tv.intRowStatus = 0     
			AND tv.idfVector = ' + CAST(tv.idfVector AS NVARCHAR(20))
	FROM tlbVector tv
	JOIN tlbObservation to1 ON
		to1.idfObservation = tv.idfObservation
	LEFT JOIN ffFormTemplate fft ON
		fft.idfsFormTemplate = to1.idfsFormTemplate
	WHERE tv.intRowStatus = 0
		AND ISNULL(fft.idfsFormType, -1) <> 10034025
	UNION ALL
	
--18. tlbVetCase
	SELECT
		'Invalid Relation'
		, 'tlbVetCase'
		, tvc.idfVetCase
		, tvc.strCaseID
		, 'tlbVetCase'
		, tvc.idfVetCase
		, 'tlbPerson_tlbOffice'
		, 'idfPersonReportedBy'
		, tvc.idfPersonReportedBy
		, 'SELECT
			tvc.idfVetCase
			, tvc.idfPersonReportedBy
			, tvc.idfReportedByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbVetCase tvc
		JOIN tlbPerson tp ON
			tp.idfPerson = tvc.idfPersonReportedBy
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tvc.idfReportedByOffice
		WHERE tvc.intRowStatus = 0
			AND tvc.idfVetCase = ' + CAST(tvc.idfVetCase AS NVARCHAR(20))
	FROM tlbVetCase tvc
	JOIN tlbPerson tp ON
		tp.idfPerson = tvc.idfPersonReportedBy
	WHERE tvc.intRowStatus = 0
		AND ISNULL(tvc.idfReportedByOffice, -1) <> ISNULL(tp.idfInstitution, -1)		
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbVetCase'
		, tvc.idfVetCase
		, tvc.strCaseID
		, 'tlbVetCase'
		, tvc.idfVetCase
		, 'tlbPerson_tlbOffice'
		, 'idfPersonInvestigatedBy'
		, tvc.idfPersonInvestigatedBy
		, 'SELECT
			tvc.idfVetCase
			, tvc.idfPersonInvestigatedBy
			, tvc.idfInvestigatedByOffice
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, frr2.name
		FROM tlbVetCase tvc
		JOIN tlbPerson tp ON
			tp.idfPerson = tvc.idfPersonInvestigatedBy
		LEFT JOIN tlbOffice to2 
			LEFT JOIN dbo.fnReferenceRepair(''en'', 19000045) frr2 ON
				frr2.idfsReference = to2.idfsOfficeAbbreviation
		ON to2.idfOffice = tvc.idfInvestigatedByOffice
		WHERE tvc.intRowStatus = 0
			AND tvc.idfVetCase = ' + CAST(tvc.idfVetCase AS NVARCHAR(20))
	FROM tlbVetCase tvc
	JOIN tlbPerson tp ON
		tp.idfPerson = tvc.idfPersonInvestigatedBy
	WHERE tvc.intRowStatus = 0
		AND ISNULL(tvc.idfInvestigatedByOffice, -1) <> ISNULL(tp.idfInstitution, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbVetCase'
		, tvc.idfVetCase
		, tvc.strCaseID
		, 'tlbVetCase'
		, tvc.idfVetCase
		, 'tlbPerson_tstSite'
		, 'idfPersonEnteredBy'
		, tvc.idfPersonEnteredBy
		, 'SELECT
			tvc.idfVetCase
			, tvc.idfPersonEnteredBy
			, tvc.idfsSite
			, strFamilyName + '' '' + strFirstName + '' '' + strSecondName
			, ts.strHASCsiteID
		FROM tlbVetCase tvc
		JOIN tlbPerson tp ON
			tp.idfPerson = tvc.idfPersonEnteredBy
		LEFT JOIN tstSite ts ON 
			ts.idfsSite = tvc.idfsSite
		WHERE tvc.intRowStatus = 0
			AND tvc.idfVetCase = ' + CAST(tvc.idfVetCase AS NVARCHAR(20))
	FROM tlbVetCase tvc
	JOIN tlbPerson tp ON
		tp.idfPerson = tvc.idfPersonEnteredBy
	LEFT JOIN tstSite ts ON
		ts.idfsSite = tvc.idfsSite
	WHERE tvc.intRowStatus = 0
		AND ISNULL(ts.idfOffice, -1) <> ISNULL(tp.idfInstitution, -1)
	UNION ALL
	SELECT
		'Invalid Relation'
		, 'tlbVetCase'
		, tvc.idfVetCase
		, tvc.strCaseID
		, 'tlbVetCase'
		, tvc.idfVetCase
		, 'tlbObservation_ffFormTemplate'
		, 'idfObservation'
		, tvc.idfObservation
		, 'SELECT     
			tvc.idfVetCase    
			, tvc.idfObservation
			, fft.idfsFormType
		FROM tlbVetCase tvc
		JOIN tlbObservation to1 ON
			to1.idfObservation = tvc.idfObservation
		LEFT JOIN ffFormTemplate fft ON
			fft.idfsFormTemplate = to1.idfsFormTemplate
		WHERE tvc.intRowStatus = 0     
			AND tvc.idfVetCase = ' + CAST(tvc.idfVetCase AS NVARCHAR(20))
	FROM tlbVetCase tvc
	JOIN tlbObservation to1 ON
		to1.idfObservation = tvc.idfObservation
	LEFT JOIN ffFormTemplate fft ON
		fft.idfsFormTemplate = to1.idfsFormTemplate
	WHERE tvc.intRowStatus = 0
		AND ISNULL(fft.idfsFormType, -1) <> 10034014

