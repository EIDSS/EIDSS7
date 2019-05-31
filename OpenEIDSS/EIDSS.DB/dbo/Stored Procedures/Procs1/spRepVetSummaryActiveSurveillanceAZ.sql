
--##SUMMARY

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepVetSummaryActiveSurveillanceAZ 
'ru', 
N'2016-06-01T00:00:00',
 N'2016-07-14T00:00:00',
7718730000000,
'<ItemList><Item key="49558320000000" value=""/><Item key="7722710000000" value=""/></ItemList>'



*/ 

CREATE PROCEDURE [dbo].[spRepVetSummaryActiveSurveillanceAZ]
(
	 @LangID			AS NVARCHAR(50),
	 @SD				AS DATETIME, 
	 @ED				AS DATETIME,
	 @Diagnosis			AS BIGINT,
	 @SpeciesType		AS XML,
	 @InvestigationOrMeasureType BIGINT = NULL
)
AS




	DECLARE @SDDate AS DATETIME
	DECLARE @EDDate AS DATETIME
	DECLARE @CountryID BIGINT
	DECLARE @iSpeciesType INT
	
	DECLARE @idfsRegionBaku BIGINT,
		@idfsRegionOtherRayons BIGINT,
		@idfsRegionNakhichevanAR BIGINT
		
		
	DECLARE @sql AS NVARCHAR (MAX) = ''

	
	SET @SDDate=dbo.fn_SetMinMaxTime(CAST(@SD AS DATETIME),0)
	SET @EDDate=dbo.fn_SetMinMaxTime(CAST(@ED AS DATETIME),1)
	
	SET @CountryID = 170000000
				

	EXEC sp_xml_preparedocument @iSpeciesType OUTPUT, @SpeciesType

	DECLARE @SpeciesTypeTable AS TABLE
	(
		[key] NVARCHAR(300)
	)
	
	INSERT INTO @SpeciesTypeTable 
	(
		[key]
	)	
	SELECT 
		* 
	FROM OPENXML (@iSpeciesType, '/ItemList/Item')
	WITH ([key] BIGINT '@key')

	EXEC sp_xml_removedocument @iSpeciesType	


	--1344330000000 --Baku
	SELECT
		@idfsRegionBaku = fgr.idfsReference
	FROM dbo.fnGisReference('en', 19000003) fgr
	WHERE fgr.name = N'Baku'

	--1344340000000 --Other rayons
	SELECT
		@idfsRegionOtherRayons = fgr.idfsReference
	FROM dbo.fnGisReference('en', 19000003) fgr
	WHERE fgr.name = N'Other rayons'

	--1344350000000 --Nakhichevan AR
	SELECT
		@idfsRegionNakhichevanAR = fgr.idfsReference
	FROM dbo.fnGisReference('en', 19000003) fgr
	WHERE fgr.name = N'Nakhichevan AR'  
	
	
	DECLARE @vet_form_1_use_specific_gis BIGINT 
	DECLARE @vet_form_1_specific_gis_region BIGINT 
	DECLARE @vet_form_1_specific_gis_rayon BIGINT
	DECLARE @attr_part_in_report BIGINT 

	SELECT 
		@vet_form_1_use_specific_gis = at.idfAttributeType
	FROM trtAttributeType at
	WHERE at.strAttributeTypeName = N'vet_form_1_use_specific_gis'

	SELECT 
		@vet_form_1_specific_gis_region = at.idfAttributeType
	FROM trtAttributeType at
	WHERE at.strAttributeTypeName = N'vet_form_1_specific_gis_region'

	SELECT 
		@vet_form_1_specific_gis_rayon = at.idfAttributeType
	FROM trtAttributeType at
	WHERE at.strAttributeTypeName = N'vet_form_1_specific_gis_rayon'
	
	SELECT
		@attr_part_in_report = at.idfAttributeType
	FROM	trtAttributeType at
	WHERE	at.strAttributeTypeName = N'attr_part_in_report'
	
	
	
	
	

	DECLARE @MonitoringSession TABLE (
		idfMonitoringSession BIGINT
		, idfsRegion BIGINT
		, idfsRayon BIGINT
		, idfsSpeciesType BIGINT
	)
	
	;WITH NotDeletedDiagnosis AS (
		SELECT
			CAST(r_d.[name] AS NVARCHAR(2000)) AS [name]
			, ISNULL(r_d.idfsReference,d_actual.idfsDiagnosis) AS idfsDiagnosis
			, ISNULL(d_actual.idfsDiagnosis, r_d.idfsReference) AS idfsActualDiagnosis
			, ROW_NUMBER() OVER (PARTITION BY ISNULL(r_d.idfsReference,d_actual.idfsDiagnosis) ORDER BY ISNULL(d_actual.idfsDiagnosis, r_d.idfsReference)) AS rn
		FROM fnReferenceRepair(@LangID, 19000019) r_d
		LEFT JOIN trtDiagnosis d_actual
			JOIN fnReference(@LangID, 19000019) r_d_actual ON
				r_d_actual.idfsReference = d_actual.idfsDiagnosis
		ON r_d_actual.[name] = r_d.[name] COLLATE Cyrillic_General_CI_AS
			AND d_actual.idfsUsingType = 10020001	/*Case-based*/
			AND d_actual.intRowStatus = 0
	)
	, NotDeletedSpecies AS (
		SELECT
			CAST(r_sp.[name] AS NVARCHAR(2000)) AS [name]
			, ISNULL(r_sp.idfsReference, st_actual.idfsSpeciesType) AS idfsSpeciesType
			, ISNULL(st_actual.idfsSpeciesType, r_sp.idfsReference) AS idfsActualSpeciesType
			, ROW_NUMBER() OVER (PARTITION BY ISNULL(r_sp.idfsReference, st_actual.idfsSpeciesType) ORDER BY ISNULL(st_actual.idfsSpeciesType, r_sp.idfsReference)) AS rn
		FROM fnReferenceRepair(@LangID, 19000086) r_sp
		LEFT JOIN trtSpeciesType st_actual
			JOIN fnReference(@LangID, 19000086) r_sp_actual on	
				r_sp_actual.idfsReference = st_actual.idfsSpeciesType
		ON r_sp_actual.[name] = r_sp.[name] COLLATE Cyrillic_General_CI_AS
			AND st_actual.intRowStatus = 0
	)

	
	INSERT INTO @MonitoringSession
	SELECT 
		tms.idfMonitoringSession
		, ISNULL(reg_specific.idfsReference, tms.idfsRegion)
		, ISNULL(ray_specific.idfsReference, tms.idfsRayon)
		, Actual_Species_Type.idfsActualSpeciesType
	FROM tlbMonitoringSession tms
	JOIN tlbMonitoringSessionToDiagnosis tmstd ON
		tmstd.idfMonitoringSession = tms.idfMonitoringSession
		AND tmstd.intRowStatus = 0
		AND tmstd.idfsSpeciesType IS NOT NULL
		
	JOIN NotDeletedDiagnosis AS Actual_Diagnosis ON
		Actual_Diagnosis.idfsDiagnosis = tmstd.idfsDiagnosis
		AND Actual_Diagnosis.rn = 1
		AND Actual_Diagnosis.idfsActualDiagnosis = @Diagnosis
	JOIN NotDeletedSpecies AS Actual_Species_Type ON
		Actual_Species_Type.idfsSpeciesType = tmstd.idfsSpeciesType
		AND Actual_Species_Type.rn = 1
	JOIN @SpeciesTypeTable stt ON
		stt.[key] = Actual_Species_Type.idfsActualSpeciesType
	
	-- Site, Organization entered case
	JOIN tstSite s
		LEFT JOIN fnInstitutionRepair(@LangID) i ON
			i.idfOffice = s.idfOffice
	ON s.idfsSite = tms.idfsSite
	
	-- Specific Region and Rayon for the site with specific attributes (B46)
	LEFT JOIN trtBaseReferenceAttribute bra
		LEFT JOIN trtGISBaseReferenceAttribute gis_bra_region
			JOIN fnGisReferenceRepair(@LangID, 19000003) reg_specific ON
				reg_specific.idfsReference = gis_bra_region.idfsGISBaseReference
		ON CAST(gis_bra_region.varValue AS NVARCHAR) = CAST(bra.varValue AS NVARCHAR)
			AND gis_bra_region.idfAttributeType = @vet_form_1_specific_gis_region
		LEFT JOIN trtGISBaseReferenceAttribute gis_bra_rayon
			JOIN fnGisReferenceRepair(@LangID, 19000002) ray_specific ON
				ray_specific.idfsReference = gis_bra_rayon.idfsGISBaseReference 
		ON CAST(gis_bra_rayon.varValue AS NVARCHAR) = CAST(bra.varValue AS NVARCHAR)
			AND gis_bra_rayon.idfAttributeType = @vet_form_1_specific_gis_rayon
	ON bra.idfsBaseReference = i.idfsOfficeAbbreviation
		AND bra.idfAttributeType = @vet_form_1_use_specific_gis
		AND CAST(bra.varValue AS NVARCHAR) = s.strSiteID			
		
	WHERE tms.intRowStatus = 0
		AND ISNULL(tms.datEndDate, tms.datStartDate) BETWEEN @SDDate AND @EDDate
		AND EXISTS (SELECT 1 FROM tlbMaterial tm WHERE tm.idfMonitoringSession = tms.idfMonitoringSession AND tm.datFieldCollectionDate IS NOT NULL)


	DECLARE @MaterialCnt TABLE (
		idfMonitoringSession BIGINT
		, idfsSpeciesType BIGINT
		, idfAnimalCount INT
	)
	
	INSERT INTO @MaterialCnt
	SELECT
		tm.idfMonitoringSession
		, ts.idfsSpeciesType
		, COUNT(DISTINCT ta.idfAnimal) cnt
	FROM tlbMaterial tm
	JOIN @MonitoringSession ms ON
		ms.idfMonitoringSession = tm.idfMonitoringSession
	JOIN tlbAnimal ta ON
		ta.idfAnimal = tm.idfAnimal
		AND ta.intRowStatus = 0
	JOIN tlbSpecies ts ON
		ts.idfSpecies = ta.idfSpecies
		AND ts.intRowStatus = 0
	WHERE tm.intRowStatus = 0
	GROUP BY tm.idfMonitoringSession
		, ts.idfsSpeciesType


	DECLARE @TestCnt TABLE (
		idfMonitoringSession BIGINT
		, idfsSpeciesType BIGINT
		, idfAnimalCount INT
	)
	INSERT INTO @TestCnt
	SELECT
		tm.idfMonitoringSession
		, ts.idfsSpeciesType
		, COUNT(DISTINCT ta.idfAnimal) cnt
	FROM tlbTesting tt
	JOIN tlbMaterial tm ON
		tm.idfMaterial = tt.idfMaterial
		AND tm.intRowStatus = 0
	JOIN @MonitoringSession ms ON
		ms.idfMonitoringSession = tm.idfMonitoringSession
	JOIN tlbAnimal ta ON
		ta.idfAnimal = tm.idfAnimal
		AND ta.intRowStatus = 0
	JOIN tlbSpecies ts ON
		ts.idfSpecies = ta.idfSpecies
		AND ts.intRowStatus = 0
	JOIN dbo.fnReference(@LangID, 19000001) ref_teststatus ON
		ref_teststatus.idfsReference = tt.idfsTestStatus
	JOIN trtTestTypeToTestResult tttttr ON
		tttttr.idfsTestName = tt.idfsTestName
		AND tttttr.idfsTestResult = tt.idfsTestResult
		AND tttttr.intRowStatus = 0
		AND tttttr.blnIndicative = 1
	WHERE tt.idfsDiagnosis = @Diagnosis
		AND ref_teststatus.idfsReference IN (10001001, 10001006)  /*Final, Amended*/
		AND tt.intRowStatus = 0
	GROUP BY tm.idfMonitoringSession
		, ts.idfsSpeciesType
		
	
	
	DECLARE @cmd NVARCHAR(MAX)
	
	IF OBJECT_ID('tempdb..##ActiveSurveillanceSessions') IS NOT NULL
	BEGIN
		SET @cmd = N'
			DROP TABLE ##ActiveSurveillanceSessions
		'
		EXECUTE sp_executesql @cmd 
	END
	
	SET @cmd = N'
		CREATE TABLE ##ActiveSurveillanceSessions
		(
			idfsRegion BIGINT
			, idfsRayon BIGINT
			, idfsSpeciesType BIGINT
			, CntMaterial INT
			, CntTest INT
		)	
	'
	EXECUTE sp_executesql @cmd 
	
	INSERT INTO ##ActiveSurveillanceSessions
	SELECT
		ms.idfsRegion
		, ms.idfsRayon
		, ms.idfsSpeciesType
		, SUM(mc.idfAnimalCount)
		, SUM(ISNULL(tc.idfAnimalCount, 0))
	FROM @MonitoringSession ms
	JOIN @MaterialCnt mc ON
		mc.idfMonitoringSession = ms.idfMonitoringSession
		AND mc.idfsSpeciesType = ms.idfsSpeciesType
	LEFT JOIN @TestCnt tc ON
		tc.idfMonitoringSession = ms.idfMonitoringSession
		AND tc.idfsSpeciesType = ms.idfsSpeciesType
	GROUP BY ms.idfsRegion
		, ms.idfsRayon
		, ms.idfsSpeciesType
	
	
	DECLARE @SpeciesToDiagnosis AS TABLE (
			RowNumber INT
			, SpeciesTypeId BIGINT
			, SpeciesTypeName NVARCHAR(2000)
		)	
		
	INSERT INTO @SpeciesToDiagnosis (RowNumber, SpeciesTypeId, SpeciesTypeName)
	SELECT
		ROW_NUMBER() OVER (ORDER BY ref_spec.[name])
		, ref_spec.idfsReference
		, ref_spec.name
	FROM dbo.fnReference(@LangID, 19000086) ref_spec
	JOIN @SpeciesTypeTable stt ON
		stt.[key] = ref_spec.idfsReference
	/*SELECT
		ROW_NUMBER() OVER (ORDER BY ref_spec.[name])
		, ASSessions.idfsSpeciesType
		, ref_spec.name
	FROM ##ActiveSurveillanceSessions ASSessions
	JOIN dbo.fnReference(@LangID, 19000086) ref_spec ON
		ref_spec.idfsReference = ASSessions.idfsSpeciesType
	GROUP BY ASSessions.idfsSpeciesType
		, ref_spec.[name]*/

	
	DECLARE @SpeciesTypeId BIGINT = 0
		, @SpeciesTypeNum INT
		, @SpeciesTypeName NVARCHAR(2000)

	SELECT @sql = N'
		SELECT
			CASE ray.idfsRegion 
				WHEN @idfsRegionBaku THEN 1 
				WHEN @idfsRegionOtherRayons THEN 2
				WHEN @idfsRegionNakhichevanAR THEN 3
				ELSE 0
			END AS intRegionOrder
			, refReg.[name] AS strRegion
			, refRay.[name] AS strRayon'
				
			--���������� ������� ����� ��������
			DECLARE _Species CURSOR FOR
				SELECT 
					SpeciesTypeId
					, RowNumber
					, SpeciesTypeName
				FROM @SpeciesToDiagnosis
				ORDER BY RowNumber
			OPEN _Species

			FETCH NEXT FROM _Species INTO @SpeciesTypeId, @SpeciesTypeNum, @SpeciesTypeName

			WHILE @@FETCH_STATUS = 0
				BEGIN 
					SET @Sql += N'
	, MAX(N''' + replace(@SpeciesTypeName, N'''', N'''''') + N''') AS strSpecies_' + CAST(@SpeciesTypeNum AS NVARCHAR)
				
					SET @Sql += N'
	, MAX(CASE WHEN ASSessions.idfsSpeciesType =  ' + CAST(@SpeciesTypeId AS NVARCHAR) + N' THEN ASSessions.CntMaterial ELSE NULL END) AS intFirstSubcolumn_' + CAST(@SpeciesTypeNum AS NVARCHAR)
			
					SET @Sql += N'
	, MAX(CASE WHEN ASSessions.idfsSpeciesType =  ' + CAST(@SpeciesTypeId AS NVARCHAR) + N' THEN ASSessions.CntTest ELSE NULL END) AS intSecondSubcolumn_' + CAST(@SpeciesTypeNum AS NVARCHAR)
					
								
					FETCH NEXT FROM _Species INTO @SpeciesTypeId, @SpeciesTypeNum, 	@SpeciesTypeName		
				END 

			CLOSE _Species
			DEALLOCATE _Species		
				
		
			
	SELECT @sql += N'
		FROM gisRegion AS reg
		JOIN fnGisReference(@LangID, 19000003 /*rftRegion*/) AS refReg ON
			reg.idfsRegion = refReg.idfsReference			
			AND reg.idfsCountry = @CountryID
		JOIN gisRayon AS ray ON 
			ray.idfsRegion = reg.idfsRegion	
		JOIN fnGisReference(@LangID, 19000002 /*rftRayon*/) AS refRay ON
			ray.idfsRayon = refRay.idfsReference
			
		LEFT JOIN ##ActiveSurveillanceSessions AS ASSessions ON
			ASSessions.idfsRegion = ray.idfsRegion
			AND ASSessions.idfsRayon = ray.idfsRayon
			
		LEFT JOIN dbo.fnReference(@LangID, 19000086) ref_spec ON
			ref_spec.idfsReference = ASSessions.idfsSpeciesType
			
		GROUP BY CASE ray.idfsRegion 
					WHEN @idfsRegionBaku THEN 1 
					WHEN @idfsRegionOtherRayons THEN 2
					WHEN @idfsRegionNakhichevanAR THEN 3
					ELSE 0
				END
				, refReg.[name]
				, refRay.[name]

		ORDER BY intRegionOrder, strRayon
	'

	--PRINT @sql
	
	
	EXEC sp_executesql @sql
		, N'@idfsRegionBaku BIGINT
			, @idfsRegionOtherRayons BIGINT
			, @idfsRegionNakhichevanAR BIGINT
			, @LangID NVARCHAR(50)
			, @CountryID BIGINT'
		, @idfsRegionBaku = @idfsRegionBaku
		, @idfsRegionOtherRayons = @idfsRegionOtherRayons
		, @idfsRegionNakhichevanAR = @idfsRegionNakhichevanAR
		, @LangID = @LangID
		, @CountryID = @CountryID
		
		
		
