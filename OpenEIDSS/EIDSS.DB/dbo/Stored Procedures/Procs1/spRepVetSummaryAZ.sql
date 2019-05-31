

--##SUMMARY This procedure returns Header (Page 1) for Form N1

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepVetSummaryAZ 
'ru', 
N'2011-04-29T00:00:00',
N'2015-05-29T00:00:00',
'<ItemList><Item key="7718730000000" value=""/><Item key="49557740000000" value=""/><Item key="51739960000000" value=""/></ItemList>'



*/ 
 
create PROCEDURE [dbo].[spRepVetSummaryAZ]
(
	 @LangID		As nvarchar(50),
	 @SD			as datetime, 
	 @ED			as datetime,
	 @Diagnosis		AS XML
)
AS
	
	
	
declare	@idfsSummaryReportType	bigint
set	@idfsSummaryReportType = 10290033	-- Veterinary Report Form Vet 1A - Diagnostic

	DECLARE @SDDate AS DATETIME
	DECLARE @EDDate AS DATETIME
	DECLARE @CountryID BIGINT
	DECLARE @iDiagnosis	INT 
	
	DECLARE @idfsRegionBaku BIGINT,
		@idfsRegionOtherRayons BIGINT,
		@idfsRegionNakhichevanAR BIGINT
		
		
	DECLARE @sql AS NVARCHAR (MAX) = ''
	
	
	DECLARE @DiagnosisId BIGINT = 0
		, @SpeciesTypeId BIGINT = 0
		, @DiagnosisNum INT
		, @SpeciesTypeNum INT
		, @DiagnosisName NVARCHAR(2000)
		, @SpeciesTypeName NVARCHAR(2000)
	
	
	SET @SDDate=dbo.fn_SetMinMaxTime(CAST(@SD AS DATETIME),0)
	SET @EDDate=dbo.fn_SetMinMaxTime(CAST(@ED AS DATETIME),1)
	
	SET @CountryID = 170000000
				

	EXEC sp_xml_preparedocument @iDiagnosis OUTPUT, @Diagnosis

	DECLARE @DiagnosisTable AS TABLE
	(
		[key] NVARCHAR(300)
	)
	
	INSERT INTO @DiagnosisTable 
	(
		[key]
	)	
	SELECT 
		* 
	FROM OPENXML (@iDiagnosis, '/ItemList/Item')
	WITH ([key] BIGINT '@key')

	EXEC sp_xml_removedocument @iDiagnosis	


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
	
	
	DECLARE @vet_form_1_use_specific_gis bigint
	DECLARE @vet_form_1_specific_gis_region bigint
	DECLARE @vet_form_1_specific_gis_rayon BIGINT
	declare	@attr_part_in_report			bigint

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
	
	
	
	declare	@cmd	nvarchar(MAX)
	
	IF OBJECT_ID('tempdb..##ActiveSurveillanceSessions') IS NOT NULL
	begin
		set	@cmd = N'
			DROP TABLE ##ActiveSurveillanceSessions
		'
		execute sp_executesql @cmd 
	end
	
	set	@cmd = N'
		CREATE TABLE ##ActiveSurveillanceSessions
		(
			idfsRegion BIGINT
			, idfsRayon BIGINT
			, idfsDiagnosis BIGINT
			, idfsSpeciesType BIGINT
			, CntMaterial INT
			, CntTest INT
		)	
	'
	execute sp_executesql @cmd 
	
	
	IF OBJECT_ID('tempdb..##Diagnosis') IS NOT NULL
	begin
		set	@cmd = N'
			DROP TABLE ##Diagnosis
		'
		execute sp_executesql @cmd 
	end

	
	set	@cmd = N'
		CREATE TABLE ##Diagnosis (
			RowNumber INT IDENTITY
			, DiagnosisId BIGINT
			, DiagnosisName NVARCHAR(2000)
		)	
	'
	execute sp_executesql @cmd 
	
	
	IF OBJECT_ID('tempdb..##SpeciesToDiagnosis') IS NOT NULL
	begin
		set	@cmd = N'
			DROP TABLE ##SpeciesToDiagnosis
		'
		execute sp_executesql @cmd 
	end


	set	@cmd = N'
		CREATE TABLE ##SpeciesToDiagnosis (
			RowNumber INT
			, SpeciesTypeId BIGINT
			, DiagnosisNum INT
			, SpeciesTypeName NVARCHAR(2000)
		)	
	'
	execute sp_executesql @cmd 


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
	JOIN tlbAnimal ta ON
		ta.idfAnimal = tm.idfAnimal
		AND ta.intRowStatus = 0
	JOIN tlbSpecies ts ON
		ts.idfSpecies = ta.idfSpecies
		AND ts.intRowStatus = 0
	WHERE tt.idfsTestResult IN (7723960000000 /*Positive*/, 7723790000000 /*Agent found*/)
		AND tt.intRowStatus = 0
		-- Positive reaction
		AND EXISTS (
				SELECT 
					*
				FROM trtBaseReferenceAttribute bra
				WHERE bra.idfAttributeType = @attr_part_in_report
					AND bra.idfsBaseReference = tt.idfsTestResult
					AND bra.strAttributeItem = N'Positive reaction taken (ea)'
					AND CAST(bra.varValue AS NVARCHAR) = CAST(@idfsSummaryReportType AS NVARCHAR(20))
					)
	GROUP BY tm.idfMonitoringSession
		, ts.idfsSpeciesType


;
WITH NotDeletedDiagnosis AS (
	SELECT
		cast(r_d.[name] as nvarchar(2000)) as [name]
		, ISNULL(r_d.idfsReference,d_actual.idfsDiagnosis) AS idfsDiagnosis
		, ISNULL(d_actual.idfsDiagnosis, r_d.idfsReference) AS idfsActualDiagnosis
		--, r_d_actual.intOrder
		, ROW_NUMBER() OVER (PARTITION BY ISNULL(r_d.idfsReference,d_actual.idfsDiagnosis) ORDER BY ISNULL(d_actual.idfsDiagnosis, r_d.idfsReference)) AS rn
	FROM fnReferenceRepair(@LangID, 19000019) r_d
	LEFT JOIN trtDiagnosis d_actual
		JOIN fnReference(@LangID, 19000019) r_d_actual ON
			r_d_actual.idfsReference = d_actual.idfsDiagnosis
	ON r_d_actual.[name] = r_d.[name] collate Cyrillic_General_CI_AS
		AND d_actual.idfsUsingType = 10020001	/*Case-based*/
		AND d_actual.intRowStatus = 0
)
, NotDeletedSpecies AS (
	SELECT
		cast(r_sp.[name] as nvarchar(2000)) as [name]
		, ISNULL(r_sp.idfsReference, st_actual.idfsSpeciesType) AS idfsSpeciesType
		, ISNULL(st_actual.idfsSpeciesType, r_sp.idfsReference) AS idfsActualSpeciesType
		--, r_sp_actual.intOrder
		, ROW_NUMBER() OVER (PARTITION BY ISNULL(r_sp.idfsReference, st_actual.idfsSpeciesType) ORDER BY ISNULL(st_actual.idfsSpeciesType, r_sp.idfsReference)) AS rn
	FROM fnReferenceRepair(@LangID, 19000086) r_sp
	LEFT JOIN trtSpeciesType st_actual
	JOIN fnReference(@LangID, 19000086) r_sp_actual on	
		r_sp_actual.idfsReference = st_actual.idfsSpeciesType
	ON r_sp_actual.[name] = r_sp.[name] collate Cyrillic_General_CI_AS
		AND st_actual.intRowStatus = 0
)


	INSERT INTO ##ActiveSurveillanceSessions
	SELECT
		ISNULL(reg_specific.idfsReference, tms.idfsRegion)
		, ISNULL(ray_specific.idfsReference, tms.idfsRayon)
		, Actual_Diagnosis.idfsActualDiagnosis
		, Actual_Species_Type.idfsActualSpeciesType
		, SUM(tm.idfAnimalCount) CntMaterial
		, SUM(ISNULL(tt.idfAnimalCount, 0)) CntTest
	FROM tlbMonitoringSession tms
	JOIN tlbMonitoringSessionToDiagnosis tmstd ON
		tmstd.idfMonitoringSession = tms.idfMonitoringSession
		AND tmstd.intRowStatus = 0
		AND tmstd.idfsSpeciesType IS NOT NULL
	JOIN @MaterialCnt tm ON
		tm.idfMonitoringSession = tms.idfMonitoringSession
		AND tm.idfsSpeciesType = tmstd.idfsSpeciesType
	LEFT JOIN @TestCnt tt ON
		tt.idfMonitoringSession = tms.idfMonitoringSession
		AND tt.idfsSpeciesType = tmstd.idfsSpeciesType
		
	JOIN NotDeletedDiagnosis AS Actual_Diagnosis ON
		Actual_Diagnosis.idfsDiagnosis = tmstd.idfsDiagnosis
		AND Actual_Diagnosis.rn = 1
		
	JOIN NotDeletedSpecies AS Actual_Species_Type ON
		Actual_Species_Type.idfsSpeciesType = tmstd.idfsSpeciesType
		AND Actual_Species_Type.rn = 1
		
	JOIN @DiagnosisTable dt ON
		dt.[key] = Actual_Diagnosis.idfsActualDiagnosis
		
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
	GROUP BY ISNULL(reg_specific.idfsReference, tms.idfsRegion)
		, ISNULL(ray_specific.idfsReference, tms.idfsRayon)
		, Actual_Diagnosis.idfsActualDiagnosis
		, Actual_Species_Type.idfsActualSpeciesType



	INSERT INTO ##Diagnosis (DiagnosisId, DiagnosisName)
	SELECT
		ASSessions.idfsDiagnosis
		, ref_diag.name
	FROM ##ActiveSurveillanceSessions ASSessions
	JOIN dbo.fnReference(@LangID, 19000019) ref_diag ON
		ref_diag.idfsReference = ASSessions.idfsDiagnosis
	GROUP BY ASSessions.idfsDiagnosis
		, ref_diag.[name]/*intOrder*/
	ORDER BY ref_diag.[name]/*intOrder*/
	
	INSERT INTO ##SpeciesToDiagnosis (RowNumber, SpeciesTypeId, DiagnosisNum, SpeciesTypeName)
	SELECT
		ROW_NUMBER() OVER (PARTITION BY d.RowNumber ORDER BY ref_spec.[name]/*intOrder*/)
		, ASSessions.idfsSpeciesType
		, d.RowNumber
		, ref_spec.name
	FROM ##ActiveSurveillanceSessions ASSessions
	JOIN ##Diagnosis d ON
		d.DiagnosisId = ASSessions.idfsDiagnosis
	JOIN dbo.fnReference(@LangID, 19000086) ref_spec ON
		ref_spec.idfsReference = ASSessions.idfsSpeciesType
	GROUP BY ASSessions.idfsSpeciesType
		, ref_spec.[name]/*intOrder*/
		, d.RowNumber
	

SELECT @sql = N'
	SELECT
		CASE ray.idfsRegion 
			WHEN @idfsRegionBaku THEN 1 
			WHEN @idfsRegionOtherRayons THEN 2
			WHEN @idfsRegionNakhichevanAR THEN 3
			ELSE 0
		END AS intRegionOrder
		, refReg.[name] AS strRegion
		, refRay.[name] AS strRayon
		, ' + (SELECT CASE WHEN COUNT(*) > 0 THEN CAST(COUNT(*) AS NVARCHAR(1)) ELSE '1' END FROM ##Diagnosis) + 'AS intDiagnosisCount'

IF (SELECT COUNT(*) FROM ##Diagnosis) > 0
BEGIN
--перебираем диагнозы
	DECLARE _Diagnosis CURSOR FOR
		SELECT 
			DiagnosisId
			, RowNumber
			, DiagnosisName
		FROM ##Diagnosis
		ORDER BY RowNumber
	OPEN _Diagnosis

	FETCH NEXT FROM _Diagnosis INTO @DiagnosisId, @DiagnosisNum, @DiagnosisName

	WHILE @@FETCH_STATUS = 0
		BEGIN 
			SET @Sql += N'
		, MAX(N''' + replace(@DiagnosisName, N'''', N'''''') + N''') AS strDiagnosis_' + CAST(@DiagnosisNum AS NVARCHAR)
		
				SET @Sql += N'
		, MAX(' + CAST((SELECT COUNT(*) FROM ##SpeciesToDiagnosis WHERE DiagnosisNum = @DiagnosisNum) AS NVARCHAR) + ') AS intSpeciesCount_' + CAST(@DiagnosisNum AS NVARCHAR)
	
			
				--перебираем спишесы этого диагноза
				DECLARE _Species CURSOR FOR
					SELECT 
						SpeciesTypeId
						, RowNumber
						, SpeciesTypeName
					FROM ##SpeciesToDiagnosis
					WHERE DiagnosisNum = @DiagnosisNum
					ORDER BY RowNumber
				OPEN _Species

				FETCH NEXT FROM _Species INTO @SpeciesTypeId, @SpeciesTypeNum, @SpeciesTypeName

				WHILE @@FETCH_STATUS = 0
					BEGIN 
						SET @Sql += N'
		, MAX(N''' + replace(@SpeciesTypeName, N'''', N'''''') + N''') AS strSpecies_' + CAST(@DiagnosisNum AS NVARCHAR) + '_' +  + CAST(@SpeciesTypeNum AS NVARCHAR)
					
						SET @Sql += N'
		, MAX(CASE WHEN ASSessions.idfsDiagnosis = ' + CAST(@DiagnosisId AS NVARCHAR) + N' AND ASSessions.idfsSpeciesType =  ' + CAST(@SpeciesTypeId AS NVARCHAR) + N' THEN ASSessions.CntMaterial ELSE NULL END) AS intFirstSubcolumn_' + CAST(@DiagnosisNum AS NVARCHAR) + '_' +  + CAST(@SpeciesTypeNum AS NVARCHAR)
				
						SET @Sql += N'
		, MAX(CASE WHEN ASSessions.idfsDiagnosis = ' + CAST(@DiagnosisId AS NVARCHAR) + N' AND ASSessions.idfsSpeciesType =  ' + CAST(@SpeciesTypeId AS NVARCHAR) + N' THEN ASSessions.CntTest ELSE NULL END) AS intSecondSubcolumn_' + CAST(@DiagnosisNum AS NVARCHAR) + '_' +  + CAST(@SpeciesTypeNum AS NVARCHAR)
						
									
						FETCH NEXT FROM _Species INTO @SpeciesTypeId, @SpeciesTypeNum, 	@SpeciesTypeName		
					END 

				CLOSE _Species
				DEALLOCATE _Species		
			
						
			FETCH NEXT FROM _Diagnosis INTO @DiagnosisId, @DiagnosisNum, @DiagnosisName	
		END 

	CLOSE _Diagnosis
	DEALLOCATE _Diagnosis
END
ELSE
	BEGIN
		SET @Sql += N'
		, MAX(N'' '') AS strDiagnosis_1'
		SET @Sql += N'
		, MAX(''1'') AS intSpeciesCount_1'
		SET @Sql += N'
		, MAX(N''Species Type'') AS strSpecies_1'
		SET @Sql += N'
		, MAX(''NULL'') AS intFirstSubcolumn_1'
		SET @Sql += N'
		, MAX(''NULL'') AS intSecondSubcolumn_1'
	END
	
		
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
		
	LEFT JOIN dbo.fnReference(@LangID, 19000019) ref_diag ON
		ref_diag.idfsReference = ASSessions.idfsDiagnosis
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

	PRINT @sql
	
	
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

