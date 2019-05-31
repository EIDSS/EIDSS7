

--##SUMMARY Select data for Veterinary Data Indicators report - summary mode.

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.[spRepVetIndicatorsSummary] @LangID=N'en', @FromYear = 2015, @ToYear = 2015, @FromMonth = 1, @ToMonth = 2

*/

create PROCEDURE [dbo].[spRepVetIndicatorsSummary]
    (
          @LangID AS NVARCHAR (10)
        , @FromYear AS INT
		, @ToYear AS INT
		, @FromMonth AS INT = NULL
		, @ToMonth AS INT = NULL
		
		, @OrganizationID AS BIGINT = NULL -- note: this is not selected value from the filter. This is current organization 
		, @idfUserID AS BIGINT = NULL
    )
AS BEGIN

/*	DECLARE @LangID AS NVARCHAR (10) = N'ru'
        , @FromYear AS INT = 2015
		, @ToYear AS INT = 2015
		, @FromMonth AS INT = 1
		, @ToMonth AS INT = 12
		
		, @OrganizationID AS BIGINT = NULL -- note: this is not selected value from the filter. This is current organization 
		, @idfUserID AS BIGINT = NULL*/
		
	
	-- Drop temporary tables
	IF OBJECT_ID('tempdb..#VetCase') is not null
		DROP TABLE #VetCase
	
	IF OBJECT_ID('tempdb..#Indicators') is not null
		DROP TABLE #Indicators
	
	IF OBJECT_ID('tempdb..#SpeciesVetCase') is not null
		DROP TABLE #SpeciesVetCase
		
	IF OBJECT_ID('tempdb..#AnimalsVetCase') is not null
		DROP TABLE #AnimalsVetCase
		
	IF OBJECT_ID('tempdb..#SamplesVetCase') is not null
		DROP TABLE #SamplesVetCase
		
	IF OBJECT_ID('tempdb..#TestsVetCase') is not null
		DROP TABLE #TestsVetCase
		
	IF OBJECT_ID('tempdb..#MonitoringSession') is not null
		DROP TABLE #MonitoringSession
		
	IF OBJECT_ID('tempdb..#MonitoringSession') is not null
		DROP TABLE #MonitoringSession
		
	IF OBJECT_ID('tempdb..#MonitoringSessionToDiagnosis') is not null
		DROP TABLE #MonitoringSessionToDiagnosis
		
	IF OBJECT_ID('tempdb..#FarmMonitoringSession') is not null
		DROP TABLE #FarmMonitoringSession
		
	IF OBJECT_ID('tempdb..#AnimalsMonitoringSession') is not null
		DROP TABLE #AnimalsMonitoringSession
		
	IF OBJECT_ID('tempdb..#SamplesMonitoringSession') is not null
		DROP TABLE #SamplesMonitoringSession
		
	IF OBJECT_ID('tempdb..#IndicativeTestsMonitoringSession') is not null
		DROP TABLE #IndicativeTestsMonitoringSession
	
	
	
	
	DECLARE @FromDate DATETIME 
		, @ToDate DATETIME
		, @idfsSummaryReportType BIGINT
		, @SpecificOfficeId BIGINT
		
		, @attr_part_in_report BIGINT
		, @attr_department BIGINT
		
		, @Avian_Cases_Data_Name NVARCHAR(2000)
		, @Livestock_Cases_Data_Name NVARCHAR(2000)
		, @Active_Surveillance_Sessions_Data_Name NVARCHAR(2000)
		
		
		
	SET @FromDate = CAST(CAST(@FromYear AS VARCHAR(4)) 
						+ COALESCE(REPLICATE('0', 2 - LEN(@FromMonth)) + CAST(@FromMonth AS VARCHAR(2)), '01') 
						+ '01' AS DATETIME)
	
	SET @ToDate = DATEADD(mm, 1, CAST(CAST(@ToYear AS VARCHAR(4)) 
						+ COALESCE(REPLICATE('0', 2 - LEN(@ToMonth)) + CAST(@ToMonth AS VARCHAR(2)), '12') 
						+ '01' AS DATETIME))
	
	SET @idfsSummaryReportType = 10290052 /*Veterinary Data Indicators*/
	
	SELECT
		 @SpecificOfficeId = ts.idfOffice
	FROM tstSite ts 
	WHERE ts.intRowStatus = 0
		AND ts.intFlags = 100 /*organization with abbreviation = Baku city VO*/
		
		
	
	
	SELECT 
		@attr_part_in_report = at.idfAttributeType
	FROM trtAttributeType at
	WHERE at.strAttributeTypeName = N'attr_part_in_report'
	
	SELECT 
		@attr_department = at.idfAttributeType
	FROM trtAttributeType at
	WHERE at.strAttributeTypeName = N'attr_department'
	


	SELECT 
		@Avian_Cases_Data_Name = rat.[name]
	FROM trtBaseReferenceAttribute bra
	JOIN fnReferenceRepair(@LangID, 19000132 /*Report Additional Text*/) rat ON
		rat.idfsReference = bra.idfsBaseReference
	WHERE bra.idfAttributeType = @attr_part_in_report
		AND CAST(bra.varValue AS NVARCHAR) = CAST(@idfsSummaryReportType AS NVARCHAR(20))
		AND bra.strAttributeItem = N'Avian Cases Data'
	
	SELECT 
		@Livestock_Cases_Data_Name = rat.[name]
	FROM trtBaseReferenceAttribute bra
	JOIN fnReferenceRepair(@LangID, 19000132 /*Report Additional Text*/) rat ON
		rat.idfsReference = bra.idfsBaseReference
	WHERE bra.idfAttributeType = @attr_part_in_report
		AND CAST(bra.varValue AS NVARCHAR) = CAST(@idfsSummaryReportType AS NVARCHAR(20))
		AND bra.strAttributeItem = N'Livestock Cases Data'
		
	SELECT 
		@Active_Surveillance_Sessions_Data_Name = rat.[name]
	FROM trtBaseReferenceAttribute bra
	JOIN fnReferenceRepair(@LangID, 19000132 /*Report Additional Text*/) rat ON
		rat.idfsReference = bra.idfsBaseReference
	WHERE bra.idfAttributeType = @attr_part_in_report
		AND CAST(bra.varValue AS NVARCHAR) = CAST(@idfsSummaryReportType AS NVARCHAR(20))
		AND bra.strAttributeItem = N'Active Surveillance Sessions Data'
	
	

	CREATE TABLE #Indicators (
		Id BIGINT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
		strAttributeItem NVARCHAR(300) COLLATE database_default NOT NULL,
		idfsOrganizationId BIGINT NOT NULL,
		strOrganizationName NVARCHAR(300) COLLATE database_default NOT NULL,
		strDataSourceName NVARCHAR(300) COLLATE database_default NOT NULL,
		intDataSourceOrder INT NOT NULL,
		strIndicatorName NVARCHAR(300) COLLATE database_default NOT NULL, 		
		intOrder INT NOT NULL,
		blnGroup BIT NOT NULL,
		intTotalCases INT,
		dblIndicatorPoints FLOAT,
		dblTotalPoints FLOAT
	) 
			
	
	INSERT INTO #Indicators
	(
		-- Id -- this column value is auto-generated
		strAttributeItem,
		idfsOrganizationId,
		strOrganizationName,
		strDataSourceName,
		intDataSourceOrder,
		strIndicatorName,
		intOrder,
		blnGroup
	)
	SELECT
		bra.strAttributeItem
		, oa.idfsReference		AS idfsOrganizationId
		, oa.name				AS strOrganizationName
		--, oa.intOrder
		, CASE LEFT(bra.strAttributeItem, 1)
			WHEN 'A' THEN @Avian_Cases_Data_Name
			WHEN 'L' THEN @Livestock_Cases_Data_Name
			WHEN 'S' THEN @Active_Surveillance_Sessions_Data_Name
		END					AS strDataSourceName
		, CASE LEFT(bra.strAttributeItem, 1)
			WHEN 'A' THEN 1
			WHEN 'L' THEN 2
			WHEN 'S' THEN 3
		END					AS intDataSourceOrder
		, rat.name			AS strIndicatorName
		, rat.intOrder		AS intOrder
		, CASE LEN(bra.strAttributeItem) - LEN(REPLACE(bra.strAttributeItem, '.', ''))
			WHEN 1 THEN 1 ELSE 0 
		 END				AS blnGroup
	FROM trtBaseReferenceAttribute bra
	JOIN fnReferenceRepair(@LangID, 19000132 /*Report Additional Text*/) rat ON
		rat.idfsReference = bra.idfsBaseReference
	JOIN trtBaseReferenceAttribute tbra ON 
		tbra.idfAttributeType = @attr_department
		AND tbra.strAttributeItem = 'Veterinary Data Indicators'
	JOIN fnReferenceRepair(@LangID, 19000045 /*Organization Abbreviation*/) oa ON
		oa.idfsReference = tbra.idfsBaseReference
		--AND oa.idfsReference = @OrganizationEntered
	WHERE bra.idfAttributeType = @attr_part_in_report
		AND CAST(bra.varValue AS NVARCHAR) = CAST(@idfsSummaryReportType AS NVARCHAR(20))
		AND rat.intOrder > 0
	ORDER BY rat.intOrder
	
	
	
	CREATE TABLE #VetCase (
		CaseId BIGINT NOT NULL PRIMARY KEY
		, idfsOfficeAbbreviation BIGINT
		, idfsCaseType BIGINT
		, idfFarm BIGINT
		, strMonitoringSessionID NVARCHAR(50)
		
		, AL_Farm_Owner SMALLINT
		, AL_Farm_Name SMALLINT
		, AL_Address SMALLINT
		, AL_Initial_Report_Date SMALLINT
		, AL_Reported_By SMALLINT
		
		, AL_Species_registration SMALLINT
		, AL_Species_type_Total SMALLINT
		, AL_Species_type_SickDead SMALLINT
		, AL_Start_of_Signs SMALLINT
		, AL_Clinical_SignsControl_Measures SMALLINT
		
		, AL_Final_Diagnosis SMALLINT
		, AL_Final_Diagnosis_Date SMALLINT
		
		, AL_Sample_registration SMALLINT
		, AL_Sample_Collection_Date SMALLINT
		, AL_Sample_Organization_Sent_To SMALLINT
		
		, L_Animal_registration SMALLINT
		, L_Animal_Sex SMALLINT
		, L_Animal_Status SMALLINT
		, L_Animal_Clinical_Signs SMALLINT
		
		, AL_Test_registration SMALLINT
		, AL_Positive_result_for_Confirmed_case SMALLINT
		
		, L_Session_ID SMALLINT
	) 
	
	INSERT INTO #VetCase
	(
		CaseId
		, idfsOfficeAbbreviation
		, idfsCaseType
		, idfFarm
		, strMonitoringSessionID
	)
	SELECT
		tvc.idfVetCase
		, i.idfsOfficeAbbreviation
		, tvc.idfsCaseType
		, tvc.idfFarm
		, tms.strMonitoringSessionID
	FROM tlbVetCase tvc
	JOIN tstSite s ON 
		s.idfsSite = tvc.idfsSite
	JOIN fnInstitutionRepair(@LangID) i ON 
		i.idfOffice = CASE WHEN s.intFlags = 10 THEN @SpecificOfficeId ELSE s.idfOffice END
	JOIN trtBaseReferenceAttribute tbra ON 
		tbra.idfAttributeType = @attr_department
		AND tbra.strAttributeItem = 'Veterinary Data Indicators'
		AND tbra.idfsBaseReference = i.idfsOfficeAbbreviation
		--AND tbra.idfsBaseReference = @OrganizationEntered
	LEFT JOIN tlbMonitoringSession tms ON
		tms.idfMonitoringSession = tvc.idfParentMonitoringSession
		AND tms.intRowStatus = 0
	WHERE tvc.intRowStatus = 0
		AND tvc.idfsCaseType IN (10012004/*Avian*/, 10012003/*Livestock*/)
		AND tvc.datEnteredDate >= @FromDate
		AND tvc.datEnteredDate < @ToDate
	
	
	CREATE TABLE #SpeciesVetCase (
		SpeciesId BIGINT NOT NULL PRIMARY KEY
		, CaseId BIGINT
		, intTotalAnimalQty INT
		, intSickDeadAnimalQty INT
		, datStartOfSignsDate DATETIME
		, SpeciesCS SMALLINT
	)
	
	INSERT INTO #SpeciesVetCase
	(
		SpeciesId
		, CaseId
		, intTotalAnimalQty
		, intSickDeadAnimalQty
		, datStartOfSignsDate
		, SpeciesCS
	)
	SELECT
		ts.idfSpecies
		, vc.CaseId
		, ISNULL(ts.intTotalAnimalQty, 0)
		, ISNULL(ts.intSickAnimalQty, 0) + ISNULL(ts.intDeadAnimalQty, 0)
		, ts.datStartOfSignsDate
		, CASE WHEN varValue IS NOT NULL THEN 1 ELSE 0 END
	FROM tlbSpecies ts
	JOIN tlbHerd th ON
		th.idfHerd = ts.idfHerd
		AND th.intRowStatus = 0
	JOIN #VetCase vc ON
		vc.idfFarm = th.idfFarm
	OUTER APPLY (
					SELECT
						MAX(tap.varValue) AS varValue
					FROM tlbActivityParameters tap
					JOIN ffParameter fp ON
						fp.idfsParameter = tap.idfsParameter
						AND fp.intRowStatus = 0
						AND fp.idfsFormType = CASE vc.idfsCaseType
												WHEN 10012004/*Avian*/ THEN 10034008/*Avian Species CS*/
												WHEN 10012003/*Livestock*/ THEN 10034016/*'Livestock Species CS'*/
											END
					WHERE tap.idfObservation = ts.idfObservation
						AND tap.intRowStatus = 0	
				) varValue
	WHERE ts.intRowStatus = 0
	
	
	CREATE TABLE #AnimalsVetCase (
		AnimalId BIGINT NOT NULL PRIMARY KEY
		, CaseId BIGINT
		, idfsAnimalGender BIGINT
		, idfsAnimalCondition BIGINT
		, AnimalCS SMALLINT
	)
	
	INSERT INTO #AnimalsVetCase
	(
		AnimalId,
		CaseId,
		idfsAnimalGender,
		idfsAnimalCondition,
		AnimalCS
	)
	SELECT
		ta.idfAnimal
		, svc.CaseId
		, ta.idfsAnimalGender
		, ta.idfsAnimalCondition
		, CASE WHEN varValue IS NOT NULL THEN 1 ELSE 0 END
	FROM tlbAnimal ta
	JOIN #SpeciesVetCase svc ON
		svc.SpeciesId = ta.idfSpecies
	JOIN #VetCase vc ON
		vc.CaseId = svc.CaseId
		AND vc.idfsCaseType = 10012003/*Livestock*/
	OUTER APPLY (
					SELECT
						MAX(tap.varValue) AS varValue
					FROM tlbActivityParameters tap
					JOIN ffParameter fp ON
						fp.idfsParameter = tap.idfsParameter
						AND fp.intRowStatus = 0
						AND fp.idfsFormType = 10034013/*'Livestock Animal CS'*/
					WHERE tap.idfObservation = ta.idfObservation
						AND tap.intRowStatus = 0	
				) varValue
	WHERE ta.intRowStatus = 0
	
	
	CREATE TABLE #SamplesVetCase (
		SampleId BIGINT NOT NULL PRIMARY KEY
		, CaseId BIGINT
		, datFieldCollectionDate DATETIME
		, idfSendToOffice BIGINT
		, blnShowInCaseOrSession bit not null default (0)
	)
	
	INSERT INTO #SamplesVetCase
	(
		SampleId,
		CaseId,
		datFieldCollectionDate,
		idfSendToOffice,
		blnShowInCaseOrSession
	)
	SELECT
		tm.idfMaterial
		, svc.CaseId
		, tm.datFieldCollectionDate
		, tm.idfSendToOffice
		, isnull(tm.blnShowInCaseOrSession, 0)
	FROM tlbMaterial tm
	JOIN #SpeciesVetCase svc ON
		svc.SpeciesId = tm.idfSpecies
	WHERE tm.intRowStatus = 0
	UNION ALL
	SELECT
		tm.idfMaterial
		, avc.CaseId
		, tm.datFieldCollectionDate
		, tm.idfSendToOffice
		, isnull(tm.blnShowInCaseOrSession, 0)
	FROM tlbMaterial tm
	JOIN #AnimalsVetCase avc ON
		avc.AnimalId = tm.idfAnimal
	WHERE tm.intRowStatus = 0
	
	
	CREATE TABLE #TestsVetCase (
		TestId BIGINT NOT NULL PRIMARY KEY
		, CaseId BIGINT
		, idfsDiagnosis BIGINT
		, idfsTestStatus BIGINT
		, TestResultIndicative SMALLINT
	)
	
	INSERT INTO #TestsVetCase
	(
		TestId,
		CaseId,
		idfsDiagnosis,
		idfsTestStatus,
		TestResultIndicative
	)
	SELECT
		tt.idfTesting
		, svc.CaseId
		, tt.idfsDiagnosis
		, tt.idfsTestStatus
		, CASE 
			WHEN EXISTS (
							SELECT 1 
							FROM trtTestTypeToTestResult ttt 
							WHERE ttt.intRowStatus = 0 
								AND ttt.idfsTestResult = tt.idfsTestResult
								AND ttt.idfsTestName = tt.idfsTestName
								AND ttt.blnIndicative = 1
						) THEN 1 ELSE 0 END
	FROM tlbTesting tt
	JOIN #SamplesVetCase svc ON
		svc.SampleId = tt.idfMaterial
	WHERE tt.intRowStatus = 0
	
	
	
	UPDATE vc
	SET AL_Farm_Owner = CASE WHEN COALESCE(farm.strLastName, farm.strFirstName, '') <> '' THEN 1 ELSE 0 END
		, AL_Farm_Name = CASE WHEN COALESCE(farm.strNationalName, farm.strInternationalName, '') <> '' THEN 1 ELSE 0 END
		, AL_Address = CASE WHEN COALESCE(farm.idfsSettlement, '') <> '' THEN 1 ELSE 0 END
		, AL_Initial_Report_Date = CASE WHEN COALESCE(tvc.datReportDate, '') <> '' THEN 1 ELSE 0 END
		, AL_Reported_By = CASE WHEN COALESCE(tvc.idfPersonReportedBy, '') <> '' AND COALESCE(tvc.idfReportedByOffice, '') <> '' THEN 1 ELSE 0 END
		, AL_Species_registration = CASE WHEN EXISTS (SELECT 1 FROM #SpeciesVetCase svc WHERE svc.CaseId = vc.CaseId) THEN 1 ELSE 0 END
		, AL_Species_type_Total = CASE WHEN EXISTS (SELECT 1 FROM #SpeciesVetCase svc WHERE svc.CaseId = vc.CaseId AND intTotalAnimalQty > 0) THEN 1 ELSE 0 END
		, AL_Species_type_SickDead = CASE WHEN EXISTS (SELECT 1 FROM #SpeciesVetCase svc WHERE svc.CaseId = vc.CaseId AND intSickDeadAnimalQty > 0)
				THEN 1 ELSE 0 END
		, AL_Start_of_Signs = CASE 
								WHEN tvc.idfsCaseReportType = 4578940000002/*Passive*/
									AND EXISTS (SELECT 1 FROM #SpeciesVetCase svc WHERE svc.CaseId = vc.CaseId AND intSickDeadAnimalQty > 0)
									AND NOT EXISTS (SELECT 1 FROM #SpeciesVetCase svc WHERE svc.CaseId = vc.CaseId AND intSickDeadAnimalQty > 0 AND svc.datStartOfSignsDate IS NULL)
										THEN 1 
								WHEN tvc.idfsCaseReportType = 4578940000001/*Active*/
										THEN 1
								ELSE 0 END
		, AL_Clinical_SignsControl_Measures = CASE 
												WHEN EXISTS (SELECT 1 FROM #SpeciesVetCase svc WHERE svc.CaseId = vc.CaseId AND intSickDeadAnimalQty > 0)
													AND EXISTS (SELECT 1 FROM #SpeciesVetCase svc WHERE svc.CaseId = vc.CaseId AND intSickDeadAnimalQty > 0 AND svc.SpeciesCS > 0)
												THEN 1 ELSE 0 END
		, AL_Final_Diagnosis = CASE 
									WHEN tvc.idfsCaseClassification = 350000000/*Confirmed Case*/ AND tvc.idfsFinalDiagnosis IS NOT NULL THEN 1
									WHEN ISNULL(tvc.idfsCaseClassification, 0) <> 350000000/*Confirmed Case*/ THEN 1
								ELSE 0 END
		, AL_Final_Diagnosis_Date = CASE 
										WHEN tvc.idfsCaseClassification = 350000000/*Confirmed Case*/ AND tvc.datFinalDiagnosisDate IS NOT NULL THEN 1
										WHEN ISNULL(tvc.idfsCaseClassification, 0) <> 350000000/*Confirmed Case*/ THEN 1
									ELSE 0 END
		, AL_Sample_registration = CASE WHEN EXISTS (SELECT 1 FROM #SamplesVetCase svc WHERE svc.CaseId = vc.CaseId and svc.blnShowInCaseOrSession = 1) THEN 1 ELSE 0 END
		, AL_Sample_Collection_Date = CASE 
										WHEN EXISTS (SELECT 1 FROM #SamplesVetCase svc WHERE svc.CaseId = vc.CaseId and svc.blnShowInCaseOrSession = 1)
											AND NOT EXISTS (SELECT 1 FROM #SamplesVetCase svc WHERE svc.CaseId = vc.CaseId AND svc.datFieldCollectionDate IS NULL)
										THEN 1 ELSE 0 END
		, AL_Sample_Organization_Sent_To = CASE 
											WHEN EXISTS (SELECT 1 FROM #SamplesVetCase svc WHERE svc.CaseId = vc.CaseId and svc.blnShowInCaseOrSession = 1)
												AND NOT EXISTS (SELECT 1 FROM #SamplesVetCase svc WHERE svc.CaseId = vc.CaseId and svc.blnShowInCaseOrSession = 1 AND svc.idfSendToOffice IS NULL)
											THEN 1 ELSE 0 END
		, L_Animal_registration = CASE WHEN EXISTS (SELECT 1 FROM #AnimalsVetCase avc WHERE avc.CaseId = vc.CaseId) THEN 1 ELSE 0 END
		, L_Animal_Sex = CASE 
							WHEN EXISTS (SELECT 1 FROM #AnimalsVetCase avc WHERE avc.CaseId = vc.CaseId)
								AND NOT EXISTS (SELECT 1 FROM #AnimalsVetCase avc WHERE avc.CaseId = vc.CaseId AND avc.idfsAnimalGender IS NULL) 
							THEN 1 ELSE 0 END
		, L_Animal_Status = CASE 
								WHEN EXISTS (SELECT 1 FROM #AnimalsVetCase avc WHERE avc.CaseId = vc.CaseId)
									AND NOT EXISTS (SELECT 1 FROM #AnimalsVetCase avc WHERE avc.CaseId = vc.CaseId AND avc.idfsAnimalCondition IS NULL) 
								THEN 1 ELSE 0 END
		, L_Animal_Clinical_Signs = CASE 
									WHEN tvc.idfsCaseReportType = 4578940000002/*Passive*/
										AND EXISTS (SELECT 1 FROM #AnimalsVetCase avc WHERE avc.CaseId = vc.CaseId)
										AND EXISTS (SELECT 1 FROM #AnimalsVetCase avc WHERE avc.CaseId = vc.CaseId AND avc.AnimalCS > 0)
											THEN 1 
									WHEN tvc.idfsCaseReportType = 4578940000001/*Active*/
										AND EXISTS (SELECT 1 FROM #AnimalsVetCase avc WHERE avc.CaseId = vc.CaseId)
											THEN 1
									ELSE 0 END
		, AL_Test_registration = CASE WHEN EXISTS (SELECT 1 FROM #TestsVetCase tests WHERE tests.CaseId = vc.CaseId) THEN 1 ELSE 0 END
		, AL_Positive_result_for_Confirmed_case = CASE 
													WHEN tvc.idfsCaseClassification = 350000000/*Confirmed Case*/ 
														AND EXISTS (
																	SELECT 1 
																	FROM #TestsVetCase tests 
																	WHERE tests.CaseId = vc.CaseId 
																		AND tests.idfsDiagnosis = tvc.idfsFinalDiagnosis
																		AND tests.idfsTestStatus IN (10001001/*Final*/, 10001006/*Amended*/)
																		AND tests.TestResultIndicative = 1
														) THEN 1 
													WHEN ISNULL(tvc.idfsCaseClassification, 0) <> 350000000/*Confirmed Case*/
														AND EXISTS (SELECT 1 FROM #TestsVetCase tests WHERE tests.CaseId = vc.CaseId) THEN 1
													ELSE 0 END
		, L_Session_ID = CASE 
							WHEN tvc.idfsCaseReportType = 4578940000001/*Active*/
								AND vc.strMonitoringSessionID IS NOT NULL THEN 1
							WHEN tvc.idfsCaseReportType = 4578940000002/*Passive*/ THEN 1
						ELSE 0 END
	FROM #VetCase vc
	JOIN tlbVetCase tvc ON
		tvc.idfVetCase = vc.CaseId
	OUTER APPLY (
					SELECT 
						th.strLastName
						, th.strFirstName
						, tf.strNationalName
						, tf.strInternationalName
						, tgl.idfsSettlement
					FROM tlbFarm tf 
					JOIN tlbHuman th ON 
						th.idfHuman = tf.idfHuman
						AND th.intRowStatus = 0
					JOIN tlbGeoLocation tgl ON
						tgl.idfGeoLocation = tf.idfFarmAddress
						AND tgl.intRowStatus = 0
					WHERE tf.idfFarm = tvc.idfFarm
						AND tf.intRowStatus = 0
				) farm		
	--WHERE tvc.idfVetCase = 54404990000870
	
	
	
	UPDATE ind
	SET intTotalCases = cnt
		, dblIndicatorPoints = CASE 
									WHEN ind.strAttributeItem IN ('A1.1. Farm Owner', 'L1.1. Farm Owner') THEN AL_Farm_Owner * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A1.2. Farm Name', 'L1.2. Farm Name') THEN AL_Farm_Name * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A1.3. Address', 'L1.3. Address') THEN AL_Address * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A1.4. Initial Report Date', 'L1.4. Initial Report Date') THEN AL_Initial_Report_Date * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A1.5. Reported By', 'L1.5. Reported By') THEN AL_Reported_By * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A1. Farm Information', 'L1. Farm Information') THEN AL_Farm_Information * 1.0 / cnt
									
									WHEN ind.strAttributeItem IN ('A2.1. Species registration', 'L2.1. Species registration') THEN AL_Species_registration * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A2.2. Species type- Total', 'L2.2. Species type- Total') THEN AL_Species_type_Total * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A2.3. Species type- Sick/Dead', 'L2.3. Species type- Sick/Dead') THEN AL_Species_type_SickDead * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A2.4. Start of Signs', 'L2.4. Start of Signs') THEN AL_Start_of_Signs * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A2.5. Clinical Signs/Control Measures', 'L2.5. Clinical Signs/Control Measures') THEN AL_Clinical_SignsControl_Measures * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A2. Flock Epi/Clinical Signs', 'L2. Herd Epi/Clinical Signs') THEN AL_Flock_EpiClinical_Signs * 1.0 / cnt
									
									WHEN ind.strAttributeItem IN ('A3.1. Final Diagnosis', 'L3.1. Final Diagnosis') THEN AL_Final_Diagnosis * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A3.2. Final Diagnosis Date', 'L3.2. Final Diagnosis Date') THEN AL_Final_Diagnosis_Date * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A3. Diagnoses', 'L3. Diagnoses') THEN AL_Diagnoses * 1.0 / cnt
									
									WHEN ind.strAttributeItem IN ('A4.1. Sample registration', 'L5.1. Sample registration') THEN AL_Sample_registration * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A4.2. Sample Collection Date', 'L5.2. Sample Collection Date') THEN AL_Sample_Collection_Date * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A4.3. Sample - Organization Sent To', 'L5.3. Sample - Organization Sent To') THEN AL_Sample_Organization_Sent_To * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A4. Sample Info', 'L5. Sample Info') THEN AL_Sample_Info * 1.0 / cnt
									
									WHEN ind.strAttributeItem IN ('L4.1. Animal registration') THEN L_Animal_registration * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('L4.2. Animal-Sex') THEN L_Animal_Sex * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('L4.3. Animal-Status') THEN L_Animal_Status * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('L4.4. Animal-Clinical Signs') THEN L_Animal_Clinical_Signs * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('L4. Animal Info') THEN L_Animal_Info * 1.0 / cnt
									
									WHEN ind.strAttributeItem IN ('A5.1. Test registration', 'L6.1. Test registration') THEN AL_Test_registration * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A5.2. Positive result for Confirmed case', 'L6.2. Positive result for Confirmed cases') THEN AL_Positive_result_for_Confirmed_case * 1.0 / cnt
									WHEN ind.strAttributeItem IN ('A5. Tests', 'L6. Tests') THEN AL_Tests * 1.0 / cnt
									
									WHEN ind.strAttributeItem IN ('L7. Session ID') THEN L_Session_ID * 1.0 / cnt
									--ELSE 0
								END
	FROM (
		SELECT
			vc.idfsOfficeAbbreviation
			, vc.idfsCaseType
			, COUNT(*)											AS cnt
			, SUM(vc.AL_Farm_Owner)								AS AL_Farm_Owner
			, SUM(vc.AL_Farm_Name)								AS AL_Farm_Name
			, SUM(vc.AL_Address)								AS AL_Address
			, SUM(vc.AL_Initial_Report_Date)					AS AL_Initial_Report_Date
			, SUM(vc.AL_Reported_By)							AS AL_Reported_By
			, SUM(vc.AL_Farm_Owner) 
				+ SUM(vc.AL_Farm_Name) 
				+ SUM(vc.AL_Address) 
				+ SUM(vc.AL_Initial_Report_Date) 
				+ SUM(vc.AL_Reported_By)						AS AL_Farm_Information
				
			, SUM(vc.AL_Species_registration)					AS AL_Species_registration
			, SUM(vc.AL_Species_type_Total)						AS AL_Species_type_Total
			, SUM(vc.AL_Species_type_SickDead)					AS AL_Species_type_SickDead
			, SUM(vc.AL_Start_of_Signs)							AS AL_Start_of_Signs
			, SUM(vc.AL_Clinical_SignsControl_Measures)			AS AL_Clinical_SignsControl_Measures
			, SUM(vc.AL_Species_registration)
				+ SUM(vc.AL_Species_type_Total)
				+ SUM(vc.AL_Species_type_SickDead)
				+ SUM(vc.AL_Start_of_Signs)
				+ SUM(vc.AL_Clinical_SignsControl_Measures)		AS AL_Flock_EpiClinical_Signs
			, SUM(AL_Final_Diagnosis)							AS AL_Final_Diagnosis
			, SUM(AL_Final_Diagnosis_Date)						AS AL_Final_Diagnosis_Date
			, SUM(AL_Final_Diagnosis)
				+ SUM(AL_Final_Diagnosis_Date)					AS AL_Diagnoses
			, SUM(vc.AL_Sample_registration)					AS AL_Sample_registration
			, SUM(vc.AL_Sample_Collection_Date)					AS AL_Sample_Collection_Date
			, SUM(vc.AL_Sample_Organization_Sent_To)			AS AL_Sample_Organization_Sent_To
			, SUM(vc.AL_Sample_registration)
				+ SUM(vc.AL_Sample_Collection_Date)
				+ SUM(vc.AL_Sample_Organization_Sent_To)		AS AL_Sample_Info
			, SUM(vc.L_Animal_registration)						AS L_Animal_registration
			, SUM(vc.L_Animal_Sex)								AS L_Animal_Sex
			, SUM(vc.L_Animal_Status)							AS L_Animal_Status
			, SUM(vc.L_Animal_Clinical_Signs)					AS L_Animal_Clinical_Signs
			, SUM(vc.L_Animal_registration)
				+ SUM(vc.L_Animal_Sex)
				+ SUM(vc.L_Animal_Status)
				+ SUM(vc.L_Animal_Clinical_Signs)				AS L_Animal_Info
			, SUM(vc.AL_Test_registration)						AS AL_Test_registration
			, SUM(vc.AL_Positive_result_for_Confirmed_case)		AS AL_Positive_result_for_Confirmed_case
			, SUM(vc.AL_Test_registration)
				+ SUM(vc.AL_Positive_result_for_Confirmed_case)	AS AL_Tests
			, SUM(L_Session_ID)									AS L_Session_ID
		FROM #VetCase vc
		GROUP BY vc.idfsOfficeAbbreviation
			, vc.idfsCaseType
	) cases
	JOIN #Indicators ind ON
		ind.idfsOrganizationId = cases.idfsOfficeAbbreviation 
		AND ind.intDataSourceOrder = CASE 
				WHEN idfsCaseType = 10012004/*Avian*/ THEN 1
				WHEN idfsCaseType = 10012003/*Livestock*/ THEN 2
            END

	
	
	/*SELECT
		*
	FROM #Indicators i
	ORDER BY i.idfsOrganizationId
		, i.Id*/
		
		
		
		
	CREATE TABLE #MonitoringSession (
		MonitoringSessionId BIGINT NOT NULL PRIMARY KEY
		, idfsOfficeAbbreviation BIGINT
		
		, S_Start_Date SMALLINT
		, S_End_Date SMALLINT
		, S_Campaign_ID SMALLINT
		
		, S_Rayon SMALLINT
		, S_Settlement SMALLINT
		
		, S_Disease_and_Species_registration SMALLINT
		, S_Species SMALLINT
		, S_Sample_type SMALLINT
		
		, S_Farm_registration SMALLINT
		, S_Farm_Total SMALLINT
		, S_Farm_OwnerFarm_Name SMALLINT

		, S_Sample_registration SMALLINT
		, S_Animal_Sex SMALLINT
		, S_Sample_Collection_Date SMALLINT
		, S_Sample_Organization_Sent_To SMALLINT
		, S_Sample_Field_Sample_ID SMALLINT

		, S_Test_Interpretation SMALLINT
		, S_Case_Creation SMALLINT
	) 
	
	INSERT INTO #MonitoringSession
	(
		MonitoringSessionId
		, idfsOfficeAbbreviation
	)
	SELECT
		tms.idfMonitoringSession
		, i.idfsOfficeAbbreviation
	FROM tlbMonitoringSession tms
	JOIN tstSite s ON 
		s.idfsSite = tms.idfsSite
	JOIN fnInstitutionRepair(@LangID) i ON 
		i.idfOffice = CASE WHEN s.intFlags = 10 THEN @SpecificOfficeId ELSE s.idfOffice END
	JOIN trtBaseReferenceAttribute tbra ON 
		tbra.idfAttributeType = @attr_department
		AND tbra.strAttributeItem = 'Veterinary Data Indicators'
		AND tbra.idfsBaseReference = i.idfsOfficeAbbreviation
	WHERE tms.intRowStatus = 0
		AND tms.datEnteredDate >= @FromDate
		AND tms.datEnteredDate < @ToDate
		
	CREATE TABLE #MonitoringSessionToDiagnosis (
		MonitoringSessionToDiagnosis BIGINT NOT NULL PRIMARY KEY
		, MonitoringSessionId BIGINT
		, idfsSpeciesType BIGINT
		, idfsSampleType BIGINT
	)
		
	INSERT INTO #MonitoringSessionToDiagnosis
	(
		MonitoringSessionToDiagnosis
		, MonitoringSessionId
		, idfsSpeciesType
		, idfsSampleType
	) 
	SELECT
		tmstd.idfMonitoringSessionToDiagnosis
		, tmstd.idfMonitoringSession
		, tmstd.idfsSpeciesType
		, tmstd.idfsSampleType
	FROM tlbMonitoringSessionToDiagnosis tmstd
	JOIN #MonitoringSession ms ON
		ms.MonitoringSessionId = tmstd.idfMonitoringSession
	WHERE tmstd.intRowStatus = 0
	
	CREATE TABLE #FarmMonitoringSession (
		FarmId BIGINT NOT NULL PRIMARY KEY
		, MonitoringSessionId BIGINT
		, intLivestockTotalAnimalQty INT
		, FarmName NVARCHAR(200)
		, FarmOwnerName NVARCHAR(200)
	)
	
	INSERT INTO #FarmMonitoringSession
	(
		FarmId,
		MonitoringSessionId,
		intLivestockTotalAnimalQty,
		FarmName,
		FarmOwnerName
	)
	SELECT
		tf.idfFarm
		, tf.idfMonitoringSession
		, ISNULL(tf.intAvianTotalAnimalQty, 0)
		, COALESCE(tf.strNationalName, tf.strInternationalName, '')
		, COALESCE(th.strLastName, th.strFirstName, '')
	FROM tlbFarm tf
	JOIN tlbHuman th ON
		th.idfHuman = tf.idfHuman
		AND th.intRowStatus = 0
	JOIN #MonitoringSession ms ON
		ms.MonitoringSessionId = tf.idfMonitoringSession
	WHERE tf.intRowStatus = 0

	
	
	CREATE TABLE #SamplesMonitoringSession (
		SampleId BIGINT NOT NULL PRIMARY KEY
		, MonitoringSessionId BIGINT
		, AnimalId BIGINT
		, datFieldCollectionDate DATETIME
		, idfSendToOffice BIGINT
		, strFieldBarcode NVARCHAR(200)
		, blnShowInCaseOrSession bit not null default (0)
	)
	
	INSERT INTO #SamplesMonitoringSession
	(
		SampleId,
		MonitoringSessionId,
		AnimalId,
		datFieldCollectionDate,
		idfSendToOffice,
		strFieldBarcode,
		blnShowInCaseOrSession
	)
	SELECT
		tm.idfMaterial
		, tm.idfMonitoringSession
		, tm.idfAnimal
		, tm.datFieldCollectionDate
		, tm.idfSendToOffice
		, ISNULL(tm.strFieldBarcode, '')
		, isnull(tm.blnShowInCaseOrSession, 0)
	FROM tlbMaterial tm
	JOIN #MonitoringSession ms ON
		ms.MonitoringSessionId = tm.idfMonitoringSession
	WHERE tm.intRowStatus = 0
	
	
	CREATE TABLE #AnimalsMonitoringSession (
		AnimalId BIGINT NOT NULL PRIMARY KEY
		, FarmId BIGINT
		, MonitoringSessionId BIGINT
		, idfsAnimalGender BIGINT
		, SampleExists SMALLINT
	)
	
	INSERT INTO #AnimalsMonitoringSession
	(
		AnimalId,
		FarmId,
		MonitoringSessionId,
		idfsAnimalGender,
		SampleExists
	)
	SELECT
		ta.idfAnimal
		, fms.FarmId
		, fms.MonitoringSessionId
		, ta.idfsAnimalGender
		, CASE WHEN EXISTS (SELECT 1 FROM #SamplesMonitoringSession sms WHERE sms.MonitoringSessionId = fms.MonitoringSessionId AND sms.AnimalId = ta.idfAnimal AND sms.blnShowInCaseOrSession = 1)
				THEN 1 ELSE 0 END
	FROM tlbAnimal ta
	JOIN tlbSpecies ts ON
		ts.idfSpecies = ta.idfSpecies
		AND ts.intRowStatus = 0
	JOIN tlbHerd th ON
		th.idfHerd = ts.idfHerd
		AND th.intRowStatus = 0
	JOIN #FarmMonitoringSession fms ON
		fms.FarmId = th.idfFarm
	WHERE ta.intRowStatus = 0

	
	CREATE TABLE #IndicativeTestsMonitoringSession (
		TestId BIGINT NOT NULL PRIMARY KEY
		, SampleId BIGINT
		, AnimalId BIGINT
		, FarmId BIGINT
		, MonitoringSessionId BIGINT
		, InterpretationExists SMALLINT
		, CaseExists SMALLINT
	)


	INSERT INTO #IndicativeTestsMonitoringSession
	(
		TestId,
		SampleId,
		AnimalId,
		FarmId,
		MonitoringSessionId,
		InterpretationExists,
		CaseExists
	)
	SELECT
		tt.idfTesting
		, sms.SampleId
		, sms.AnimalId
		, fms.FarmId
		, sms.MonitoringSessionId
		, CASE 
			WHEN EXISTS (
							SELECT 1 
							FROM tlbTestValidation ttv
							WHERE ttv.intRowStatus = 0 
								AND ttv.idfTesting = tt.idfTesting
								AND ttv.idfsInterpretedStatus = 10104001	/*Rule In*/
								AND isnull(ttv.blnValidateStatus, 0) = 1	/*Validated*/
						) THEN 1 ELSE 0 END
		, CASE 
			WHEN EXISTS (
							SELECT 1 
							FROM tlbVetCase tvc
							JOIN tlbFarm tfvc ON
								tfvc.idfFarm = tvc.idfFarm
								AND tfvc.intRowStatus = 0
							WHERE tvc.intRowStatus = 0
									AND tvc.idfParentMonitoringSession = sms.MonitoringSessionId
									AND tfvc.idfFarmActual = tfa.idfFarmActual
						) THEN 1 ELSE 0 END
	FROM tlbTesting tt
	JOIN #SamplesMonitoringSession sms ON
		sms.SampleId = tt.idfMaterial
	JOIN #AnimalsMonitoringSession fms ON
		fms.AnimalId = sms.AnimalId
		AND fms.MonitoringSessionId = sms.MonitoringSessionId
	JOIN tlbFarm tf ON
		tf.idfFarm = fms.FarmId
	LEFT JOIN tlbFarmActual tfa ON
		tfa.idfFarmActual = tf.idfFarmActual
	WHERE tt.intRowStatus = 0
			AND EXISTS	(
					SELECT 1 
					FROM trtTestTypeToTestResult ttt 
					WHERE ttt.intRowStatus = 0 
						AND ttt.idfsTestResult = tt.idfsTestResult
						AND ttt.idfsTestName = tt.idfsTestName
						AND ttt.blnIndicative = 1
						)
			AND tt.idfsTestStatus IN (10001001/*Final*/, 10001006/*Amended*/)
		
	
	UPDATE ms 
	SET ms.S_Start_Date = CASE WHEN tms.datStartDate IS NOT NULL THEN 1 ELSE 0 END
		, ms.S_End_Date = CASE WHEN tms.datEndDate IS NOT NULL THEN 1 ELSE 0 END
		, ms.S_Campaign_ID = CASE WHEN tms.idfCampaign IS NOT NULL THEN 1 ELSE 0 END
		, ms.S_Rayon = CASE WHEN tms.idfsRayon IS NOT NULL THEN 1 ELSE 0 END
		, ms.S_Settlement = CASE WHEN tms.idfsSettlement IS NOT NULL THEN 1 ELSE 0 END
		, ms.S_Disease_and_Species_registration = CASE WHEN EXISTS (SELECT 1 FROM #MonitoringSessionToDiagnosis mstd WHERE mstd.MonitoringSessionId = ms.MonitoringSessionId)
														THEN 1 ELSE 0 END
		, ms.S_Species = CASE 
							WHEN EXISTS (SELECT 1 FROM #MonitoringSessionToDiagnosis mstd WHERE mstd.MonitoringSessionId = ms.MonitoringSessionId)
								AND NOT EXISTS (SELECT 1 FROM #MonitoringSessionToDiagnosis mstd WHERE mstd.MonitoringSessionId = ms.MonitoringSessionId AND mstd.idfsSpeciesType IS NULL)
							THEN 1 ELSE 0 END
		, ms.S_Sample_type = CASE 
								WHEN EXISTS (SELECT 1 FROM #MonitoringSessionToDiagnosis mstd WHERE mstd.MonitoringSessionId = ms.MonitoringSessionId)
									AND NOT EXISTS (SELECT 1 FROM #MonitoringSessionToDiagnosis mstd WHERE mstd.MonitoringSessionId = ms.MonitoringSessionId AND mstd.idfsSampleType IS NULL)
								THEN 1 ELSE 0 END
		, S_Farm_registration = CASE WHEN EXISTS (SELECT 1 FROM #FarmMonitoringSession fms WHERE fms.MonitoringSessionId = ms.MonitoringSessionId) THEN 1 ELSE 0 END
		, S_Farm_Total = CASE 
							WHEN EXISTS (SELECT 1 FROM #FarmMonitoringSession fms WHERE fms.MonitoringSessionId = ms.MonitoringSessionId)
								AND NOT EXISTS (SELECT 1 FROM #FarmMonitoringSession fms WHERE fms.MonitoringSessionId = ms.MonitoringSessionId AND fms.intLivestockTotalAnimalQty > 0)
							THEN 1 ELSE 0 END
		, S_Farm_OwnerFarm_Name = CASE
									WHEN EXISTS (SELECT 1 FROM #FarmMonitoringSession fms WHERE fms.MonitoringSessionId = ms.MonitoringSessionId)
										AND NOT EXISTS (SELECT 1 FROM #FarmMonitoringSession fms WHERE fms.MonitoringSessionId = ms.MonitoringSessionId AND fms.FarmName = '' AND fms.FarmOwnerName = '')
									THEN 1 ELSE 0 END
		, S_Sample_registration = CASE 
									WHEN EXISTS (SELECT 1 FROM #AnimalsMonitoringSession ams WHERE ams.MonitoringSessionId = ms.MonitoringSessionId)
										AND NOT EXISTS (SELECT 1 FROM #AnimalsMonitoringSession ams WHERE ams.MonitoringSessionId = ms.MonitoringSessionId AND ams.SampleExists = 0)
									THEN 1 ELSE 0 END
		, S_Animal_Sex = CASE 
							WHEN EXISTS (SELECT 1 FROM #AnimalsMonitoringSession ams WHERE ams.MonitoringSessionId = ms.MonitoringSessionId)
								AND NOT EXISTS (SELECT 1 FROM #AnimalsMonitoringSession ams WHERE ams.MonitoringSessionId = ms.MonitoringSessionId AND ams.SampleExists = 0)
								AND NOT EXISTS (SELECT 1 FROM #AnimalsMonitoringSession ams WHERE ams.MonitoringSessionId = ms.MonitoringSessionId AND ams.idfsAnimalGender IS NULL)
							THEN 1 ELSE 0 END
		, S_Sample_Collection_Date = CASE 
										WHEN EXISTS (SELECT 1 FROM #AnimalsMonitoringSession ams WHERE ams.MonitoringSessionId = ms.MonitoringSessionId)
											AND NOT EXISTS (SELECT 1 FROM #AnimalsMonitoringSession ams WHERE ams.MonitoringSessionId = ms.MonitoringSessionId AND ams.SampleExists = 0)
											AND NOT EXISTS (SELECT 1 FROM #SamplesMonitoringSession sms WHERE sms.MonitoringSessionId = ms.MonitoringSessionId AND sms.blnShowInCaseOrSession = 1 AND sms.datFieldCollectionDate IS NULL)
										THEN 1 ELSE 0 END
		, S_Sample_Organization_Sent_To = CASE 
											WHEN EXISTS (SELECT 1 FROM #AnimalsMonitoringSession ams WHERE ams.MonitoringSessionId = ms.MonitoringSessionId)
												AND NOT EXISTS (SELECT 1 FROM #AnimalsMonitoringSession ams WHERE ams.MonitoringSessionId = ms.MonitoringSessionId AND ams.SampleExists = 0)
												AND NOT EXISTS (SELECT 1 FROM #SamplesMonitoringSession sms WHERE sms.MonitoringSessionId = ms.MonitoringSessionId AND sms.blnShowInCaseOrSession = 1 AND sms.idfSendToOffice IS NULL)
											THEN 1 ELSE 0 END
		, S_Sample_Field_Sample_ID = CASE 
										WHEN EXISTS (SELECT 1 FROM #AnimalsMonitoringSession ams WHERE ams.MonitoringSessionId = ms.MonitoringSessionId)
											AND NOT EXISTS (SELECT 1 FROM #AnimalsMonitoringSession ams WHERE ams.MonitoringSessionId = ms.MonitoringSessionId AND ams.SampleExists = 0)
											AND NOT EXISTS (SELECT 1 FROM #SamplesMonitoringSession sms WHERE sms.MonitoringSessionId = ms.MonitoringSessionId AND sms.blnShowInCaseOrSession = 1 AND ltrim(rtrim(sms.strFieldBarcode)) = '')
										THEN 1 ELSE 0 END
		, S_Test_Interpretation = CASE 
										WHEN NOT EXISTS (SELECT 1 FROM #IndicativeTestsMonitoringSession itms WHERE itms.MonitoringSessionId = ms.MonitoringSessionId)
											OR	(	EXISTS (SELECT 1 FROM #IndicativeTestsMonitoringSession itms WHERE itms.MonitoringSessionId = ms.MonitoringSessionId)
													AND NOT EXISTS (
															SELECT itms.FarmId, SUM(itms.InterpretationExists)
															FROM	#IndicativeTestsMonitoringSession itms
															WHERE itms.MonitoringSessionId = ms.MonitoringSessionId
															GROUP BY itms.FarmId
															HAVING SUM(itms.InterpretationExists) = 0)
												)
										THEN 1 ELSE 0 END
		, S_Case_Creation = CASE 
										WHEN NOT EXISTS (SELECT 1 FROM #IndicativeTestsMonitoringSession itms WHERE itms.MonitoringSessionId = ms.MonitoringSessionId)
											OR	(	EXISTS (SELECT 1 FROM #IndicativeTestsMonitoringSession itms WHERE itms.MonitoringSessionId = ms.MonitoringSessionId)
													AND NOT EXISTS (
															SELECT itms.FarmId, SUM(itms.CaseExists)
															FROM	#IndicativeTestsMonitoringSession itms
															WHERE itms.MonitoringSessionId = ms.MonitoringSessionId
															GROUP BY itms.FarmId
															HAVING SUM(itms.CaseExists) = 0)
												)
										THEN 1 ELSE 0 END
	FROM #MonitoringSession ms
	JOIN tlbMonitoringSession tms ON
		tms.idfMonitoringSession = ms.MonitoringSessionId
		AND tms.intRowStatus = 0 

		/*
S6. Tests
S6.1.Test Interpretation
S6.2.Case Creation*/		
	
	UPDATE ind
	SET intTotalCases = cnt
		, dblIndicatorPoints = CASE 
									WHEN ind.strAttributeItem = 'S1.1. Start Date' THEN S_Start_Date * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S1.2. End Date' THEN S_End_Date * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S1.3. Campaign ID' THEN S_Campaign_ID * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S1. General Info' THEN S_General_Info * 1.0 / cnt
									
									WHEN ind.strAttributeItem = 'S2.1. Rayon' THEN S_Rayon * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S2.2. Settlement' THEN S_Settlement * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S2. Address' THEN S_Address * 1.0 / cnt
									
									WHEN ind.strAttributeItem = 'S3.1. Disease and Species registration' THEN S_Disease_and_Species_registration * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S3.2. Species' THEN S_Species * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S3.3. Sample type' THEN S_Sample_type * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S3. Disease and Species List' THEN S_Disease_and_Species_List * 1.0 / cnt
									
									WHEN ind.strAttributeItem = 'S4.1. Farm registration' THEN S_Farm_registration * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S4.2. Farm-Total' THEN S_Farm_Total * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S4.3. Farm Owner/Farm Name' THEN S_Farm_OwnerFarm_Name * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S4. Farms Info' THEN S_Farms_Info * 1.0 / cnt
									
									WHEN ind.strAttributeItem = 'S5.1. Sample registration' THEN S_Sample_registration * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S5.2. Animal-Sex' THEN S_Animal_Sex * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S5.3. Sample-Collection Date' THEN S_Sample_Collection_Date * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S5.4. Sample-Organization Sent To' THEN S_Sample_Organization_Sent_To * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S5.5. Sample-Field Sample ID' THEN S_Sample_Field_Sample_ID * 1.0 / cnt
									WHEN ind.strAttributeItem = 'S5. Animals/Samples' THEN S_AnimalsSamples * 1.0 / cnt
									
									WHEN ind.strAttributeItem = N'S6.1.Test Interpretation' THEN S_Test_Interpretation * 1.0 / cnt
									WHEN ind.strAttributeItem = N'S6.2.Case Creation' THEN S_Case_Creation * 1.0 / cnt
									WHEN ind.strAttributeItem = N'S6. Tests' THEN S_Tests * 1.0 / cnt
									
								END
	FROM (
		SELECT
			ms.idfsOfficeAbbreviation
			, COUNT(*)											AS cnt
			, SUM(ms.S_Start_Date)								AS S_Start_Date
			, SUM(ms.S_End_Date)								AS S_End_Date
			, SUM(ms.S_Campaign_ID)								AS S_Campaign_ID
			, SUM(ms.S_Start_Date)
				+ SUM(ms.S_End_Date)
				+ SUM(ms.S_Campaign_ID)							AS S_General_Info
			, SUM(ms.S_Rayon)									AS S_Rayon
			, SUM(ms.S_Settlement)								AS S_Settlement
			, SUM(ms.S_Rayon)
				+ SUM(ms.S_Settlement)							AS S_Address
			, SUM(S_Disease_and_Species_registration)			AS S_Disease_and_Species_registration
			, SUM(ms.S_Species)									AS S_Species
			, SUM(ms.S_Sample_type)								AS S_Sample_type
			, SUM(S_Disease_and_Species_registration)
				+ SUM(ms.S_Species)
				+ SUM(ms.S_Sample_type)							AS S_Disease_and_Species_List
			, SUM(ms.S_Farm_registration)						AS S_Farm_registration
			, SUM(ms.S_Farm_Total)								AS S_Farm_Total
			, SUM(S_Farm_OwnerFarm_Name)						AS S_Farm_OwnerFarm_Name
			, SUM(ms.S_Farm_registration)
				+ SUM(ms.S_Farm_Total)
				+ SUM(S_Farm_OwnerFarm_Name)					AS S_Farms_Info
			, SUM(ms.S_Sample_registration)						AS S_Sample_registration
			, SUM(ms.S_Animal_Sex)								AS S_Animal_Sex
			, SUM(ms.S_Sample_Collection_Date)					AS S_Sample_Collection_Date
			, SUM(ms.S_Sample_Organization_Sent_To)				AS S_Sample_Organization_Sent_To
			, SUM(ms.S_Sample_Field_Sample_ID)					AS S_Sample_Field_Sample_ID
			, SUM(ms.S_Sample_registration)
				+ SUM(ms.S_Animal_Sex)
				+ SUM(ms.S_Sample_Collection_Date)
				+ SUM(ms.S_Sample_Organization_Sent_To)
				+ SUM(ms.S_Sample_Field_Sample_ID)				AS S_AnimalsSamples
			, SUM(ms.S_Test_Interpretation)						AS S_Test_Interpretation
			, SUM(ms.S_Case_Creation)							AS S_Case_Creation
			, SUM(ms.S_Test_Interpretation)
				+ SUM(ms.S_Case_Creation)						AS S_Tests
		FROM #MonitoringSession ms
		GROUP BY ms.idfsOfficeAbbreviation
	) mon_ses
	JOIN #Indicators ind ON
		ind.idfsOrganizationId = mon_ses.idfsOfficeAbbreviation 
		AND ind.intDataSourceOrder = 3
		
	
	UPDATE i
	SET i.dblTotalPoints = i2.ss
	FROM #Indicators i
	JOIN (
		SELECT
			idfsOrganizationId
			, intDataSourceOrder
			, SUM(CASE WHEN blnGroup = 1 THEN dblIndicatorPoints ELSE 0 END) ss
		FROM #Indicators
		GROUP BY idfsOrganizationId
			, intDataSourceOrder
	) i2 ON
		i2.idfsOrganizationId = i.idfsOrganizationId
		AND i2.intDataSourceOrder = i.intDataSourceOrder
	
	
	
	
	
	
	
	
	DECLARE @ReportTable TABLE
	(	
		idfsReference BIGINT NOT NULL PRIMARY KEY,
		strOrganizationName nvarchar(300) COLLATE database_default NOT NULL,
		intAvianCases INT,
		dblAvianPoints FLOAT,
		intLivestockCases INT,
		dblLivestockPoints FLOAT,
		intASSession INT,
		dblASPoints FLOAT,
		intOrder INT
	)
	
	INSERT INTO @ReportTable
	(
		idfsReference,
		strOrganizationName,
		intAvianCases,
		dblAvianPoints,
		intLivestockCases,
		dblLivestockPoints,
		intASSession,
		dblASPoints,
		intOrder
	)
	SELECT
		idfsOrganizationId
		, strOrganizationName
		, MAX(isnull(intAvianCases, 0))
		, MAX(isnull(dblAvianPoints, 0.0))
		, MAX(isnull(intLivestockCases, 0))
		, MAX(isnull(dblLivestockPoints, 0.0))
		, MAX(isnull(intASSession, 0))
		, MAX(isnull(dblASPoints, 0.0))
		, intOrder
	FROM (
		SELECT
			ind.idfsOrganizationId
			, ind.strOrganizationName
			, ind.intDataSourceOrder
			, CASE WHEN ind.intDataSourceOrder = 1 THEN ind.intTotalCases ELSE NULL END AS intAvianCases
			, CASE WHEN ind.intDataSourceOrder = 1 THEN ind.dblTotalPoints ELSE NULL END AS dblAvianPoints
			, CASE WHEN ind.intDataSourceOrder = 2 THEN ind.intTotalCases ELSE NULL END AS intLivestockCases
			, CASE WHEN ind.intDataSourceOrder = 2 THEN ind.dblTotalPoints ELSE NULL END AS dblLivestockPoints
			, CASE WHEN ind.intDataSourceOrder = 3 THEN ind.intTotalCases ELSE NULL END AS intASSession
			, CASE WHEN ind.intDataSourceOrder = 3 THEN ind.dblTotalPoints ELSE NULL END AS dblASPoints
			, row_number () over	(
				partition by strAttributeItem, intDataSourceOrder
				order by	isnull(ind.strOrganizationName, N''), ind.idfsOrganizationId
									) as intOrder
		FROM #Indicators ind
	) x
	GROUP BY idfsOrganizationId, intOrder
		, strOrganizationName

	
	
	
	SELECT 
		idfsReference
		, strOrganizationName
		, intAvianCases
		, dblAvianPoints
		, intLivestockCases
		, dblLivestockPoints
		, intASSession
		, dblASPoints
		, dblAvianPoints + dblLivestockPoints + dblASPoints AS dblTotalPoints
		, intOrder
	FROM @ReportTable
	ORDER BY strOrganizationName
	
	-- Drop temporary tables
	IF OBJECT_ID('tempdb..#VetCase') is not null
		DROP TABLE #VetCase
	
	IF OBJECT_ID('tempdb..#Indicators') is not null
		DROP TABLE #Indicators
	
	IF OBJECT_ID('tempdb..#SpeciesVetCase') is not null
		DROP TABLE #SpeciesVetCase
		
	IF OBJECT_ID('tempdb..#AnimalsVetCase') is not null
		DROP TABLE #AnimalsVetCase
		
	IF OBJECT_ID('tempdb..#SamplesVetCase') is not null
		DROP TABLE #SamplesVetCase
		
	IF OBJECT_ID('tempdb..#TestsVetCase') is not null
		DROP TABLE #TestsVetCase
		
	IF OBJECT_ID('tempdb..#MonitoringSession') is not null
		DROP TABLE #MonitoringSession
		
	IF OBJECT_ID('tempdb..#MonitoringSession') is not null
		DROP TABLE #MonitoringSession
		
	IF OBJECT_ID('tempdb..#MonitoringSessionToDiagnosis') is not null
		DROP TABLE #MonitoringSessionToDiagnosis
		
	IF OBJECT_ID('tempdb..#FarmMonitoringSession') is not null
		DROP TABLE #FarmMonitoringSession
		
	IF OBJECT_ID('tempdb..#AnimalsMonitoringSession') is not null
		DROP TABLE #AnimalsMonitoringSession
		
	IF OBJECT_ID('tempdb..#SamplesMonitoringSession') is not null
		DROP TABLE #SamplesMonitoringSession
		
	IF OBJECT_ID('tempdb..#IndicativeTestsMonitoringSession') is not null
		DROP TABLE #IndicativeTestsMonitoringSession
	
	
	
/*	
	DECLARE @ReportTable TABLE
	(	
		idfsReference BIGINT NOT NULL PRIMARY KEY,
		strOrganizationName nvarchar(300) COLLATE database_default NOT NULL,
		intAvianCases INT,
		dblAvianPoints FLOAT,
		intLivestockCases INT,
		dblLivestockPoints FLOAT,
		intASSession INT,
		dblASPoints FLOAT,
		dblTotalPoints FLOAT,
		intOrder INT NOT NULL
	)
	
	insert into @ReportTable values
(11, 'Absheron RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 1),	
(12, 'Agdam RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 2),	
(13, 'Agdash RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 3),
(14, 'Agjabedi RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 4),
(15, 'Agstafa RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 5),
(16, 'Agsu RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 6),
(17, 'Astara RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 7),
(18, 'Baku city Veterinary Hospital', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 8),
(19, 'Baku city VO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 9),
(110, 'Balakan RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 10),
(111, 'Barda RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 11),
(112, 'Beylagan RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 12),
(113, 'Bilasuvar RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 13),
(114, 'Binagadi (Baku) RVS', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 14),	
(115, 'Dashkasan RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 15),	
(116, 'Fizuli RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 16),
(117, 'Gadabay RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 17),
(118, 'Ganja city VO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 18),
(119, 'Garadagh (Baku) RVS', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 19),
(120, 'Goranboy RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 20),
(121, 'Goychay RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 21),
(122, 'Goygel RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 22),
(123, 'Hajigabul RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 23),
(124, 'Imishli RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 24),
(125, 'Ismaili RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 25),
(126, 'Jabrayil RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 26),
(127, 'Jalilabad RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 27),	
(128, 'Kalbajar RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 28),	
(129, 'Khachmaz RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 29),
(130, 'Khazar (Baku) RVS', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 30),
(131, 'Khizi RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 31),
(132, 'Khojali RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 32),
(133, 'Khojavend RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 33),
(134, 'Kurdamir RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 34),
(135, 'Lachin RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 35),
(136, 'Lankaran RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 36),
(137, 'Lerik RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 37),
(138, 'Masally RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 38),
(139, 'Mashtaga (Baku) RVS', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 39),
(140, 'Mingachevir city VO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 40),	
(141, 'Neftchala RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 41),	
(142, 'Nizami-Khatai (Baku) RVS', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 42),
(143, 'Oguz RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 43),
(144, 'Qabala RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 44),
(145, 'Qakh RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 45),
(146, 'Qazakh RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 46),
(147, 'Qobustan RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 47),
(148, 'Quba RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 48),
(149, 'Qubadli RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 49),
(150, 'Qusar RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 50),
(151, 'Saatly RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 51),
(152, 'Sabirabad RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 52),
(153, 'Sabunchu (Baku) RVS', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 53),	
(154, 'Salyan RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 54),	
(155, 'Samukh RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 55),
(156, 'Scientific Research Veterinary Institute', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 56),
(157, 'Shabran RVO(Davachi)', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 57),
(158, 'Shaki RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 58),
(159, 'Shamakhi RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 59),
(160, 'Shamkir RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 60),
(161, 'Shirvan RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 61),
(162, 'Shusha RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 62),
(163, 'Siazan RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 63),
(164, 'Sumqayit city VO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 64),
(165, 'Surakhani (Baku) RVS', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 65),
(166, 'SVCS', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID())) , 66),	
(167, 'Terter RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 67),	
(168, 'Tovuz RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 68),
(169, 'Ujar RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 69),
(170, 'Yardimly RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 70),
(171, 'Yevlakh RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 71),
(172, 'Zangilan RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 72),
(173, 'Zaqatala RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 73),
(174, 'Zardab RVO', cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())), cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int), 2*RAND(BINARY_CHECKSUM(NEWID())),6*RAND(BINARY_CHECKSUM(NEWID()))  , 74)
	

	select * from @ReportTable
	order by intOrder

*/
end

