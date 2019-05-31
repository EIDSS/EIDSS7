
--##SUMMARY Select data for spRepRBEAnimalsTestedReportGG report.
--##REMARKS Author: Vorobiev E.V.
--##REMARKS Create date: 30.06.2014


--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepRBEAnimalsTestedReportGG 
@LangID=N'en',
@StartDate='2014-07-01 00:00:00',
@EndDate='2014-12-31 00:00:00',
@Regions=N'<ItemList></ItemList>',
@Rayons=N'<ItemList></ItemList>'
*/


CREATE PROCEDURE [dbo].[spRepRBEAnimalsTestedReportGG]
    (
          @LangID AS NVARCHAR(10)
        , @StartDate AS DATETIME
 		, @EndDate AS DATETIME
 		, @StartDate2 AS DATETIME = NULL
 		, @EndDate2 AS DATETIME = NULL
		, @Regions AS XML = NULL
		, @Rayons AS XML = NULL
    )
    
    
AS
BEGIN
	DECLARE @Country BIGINT = 780000000 /*Georgia*/	
	
	-----------------------------------------------------	
	DECLARE @iRegions INT
	DECLARE @RegionsTable TABLE ([key] NVARCHAR(300))

	EXEC sp_xml_preparedocument @iRegions OUTPUT, @Regions

	INSERT INTO @RegionsTable ([key]) 
	SELECT * 
	FROM OPENXML (@iRegions, '/ItemList/Item')
	WITH ([key] BIGINT '@key')

	EXEC sp_xml_removedocument @iRegions
	
	IF (SELECT COUNT(*) FROM @RegionsTable) = 0
	INSERT INTO @RegionsTable
	SELECT DISTINCT
		gr.idfsRegion
	FROM gisRayon gr
	WHERE gr.idfsCountry = @Country
	------------------------------------------------------
	
	------------------------------------------------------
	DECLARE @iRayons INT
	DECLARE @RayonsTable TABLE ([key] NVARCHAR(300))

	EXEC sp_xml_preparedocument @iRayons OUTPUT, @Rayons

	INSERT INTO @RayonsTable ([key]) 
	SELECT * 
	FROM OPENXML (@iRayons, '/ItemList/Item')
	WITH ([key] BIGINT '@key')

	EXEC sp_xml_removedocument @iRayons
	
	INSERT INTO @RayonsTable
	SELECT DISTINCT
		gr.idfsRayon
	FROM gisRayon gr
	JOIN @RegionsTable regt ON
		regt.[key] = gr.idfsRegion
	WHERE gr.idfsCountry = @Country
		AND NOT EXISTS (
						SELECT 
							*
						FROM gisRayon gr2
						JOIN @RayonsTable rt ON
							rt.[key] = gr2.idfsRayon
						WHERE gr2.idfsRegion = gr.idfsRegion
						)
	-------------------------------------------------------
	
	DECLARE @FilteredRayons AS TABLE (idfsRayon BIGINT PRIMARY KEY)
	INSERT INTO @FilteredRayons (idfsRayon)
	SELECT 
		gr.idfsRayon
	FROM gisRayon gr
	JOIN @RegionsTable r1 ON 
		r1.[key] = gr.idfsRegion
	JOIN @RayonsTable r2 ON 
		r2.[key] = gr.idfsRayon
	WHERE gr.idfsCountry = @Country


		
	DECLARE @FromDate DATETIME 
		, @ToDate DATETIME
		, @FromDate2 DATETIME = NULL
		, @ToDate2 DATETIME = NULL
	
	SET @FromDate = dbo.fn_SetMinMaxTime(@StartDate ,0)
	SET @ToDate = dbo.fn_SetMinMaxTime(@EndDate,1)
	
	SET @FromDate2 = dbo.fn_SetMinMaxTime(@StartDate2,0)
	SET @ToDate2 = dbo.fn_SetMinMaxTime(@EndDate2,1)
	
	DECLARE @idfsSummaryReportType BIGINT		
	SET @idfsSummaryReportType = 10290028 /*RBE - Quarterly Surveillance Sheet*/
	
	DECLARE @idfsReportDiagnosisGroup BIGINT		
	SELECT 
		@idfsReportDiagnosisGroup = trdg.idfsReportDiagnosisGroup
	FROM trtReportDiagnosisGroup trdg
	WHERE trdg.strDiagnosisGroupAlias = N'Rabies Group'
		
	
	DECLARE @Result AS TABLE
	(
		strAreaKey						NVARCHAR(200) NOT NULL PRIMARY KEY,
		strArea							NVARCHAR(200) NOT NULL,
		intDomesticDog					INT NULL,
		intDomesticCat					INT NULL,
		intDomesticCattle				INT NULL,
		intDomesticEquine				INT NULL,
		intDomesticSheep				INT NULL,
		intDomesticGoat					INT NULL,
		intDomesticPig					INT NULL,
		intDomesticStrayDog				INT NULL,
		intDomesticOther				INT NULL,
		intDomesticUnspecified			INT NULL,
		intWildlifeFox					INT NULL,
		intWildlifeRaccoonDog			INT NULL,
		intWildlifeRaccoon				INT NULL,
		intWildlifeWolf					INT NULL,
		intWildlifeBadger				INT NULL,
		intWildlifeMarten				INT NULL,
		intWildlifeOtherMustelides		INT NULL,
		intWildlifeOtherCarnivores		INT NULL,
		intWildlifeWildBoar				INT NULL,
		intWildlifeRoeDeer				INT NULL,
		intWildlifeRedDeer				INT NULL,
		intWildlifeFallowDeer			INT NULL,
		intWildlifeOther				INT NULL,
		intWildlifeBat					INT NULL,
		intWildlifeUnspecified			INT NULL
	)
	
	
;
WITH TestRabiesFluorescence AS (
	SELECT
		tt.idfMaterial
		, MIN(tt.datConcludedDate) AS TestResultDate
	FROM tlbTesting tt
	JOIN trtTestTypeForCustomReport tttfcr ON
		tttfcr.idfsTestName = tt.idfsTestName
		AND tttfcr.intRowOrder = 1 /*Rabies fluorescence*/
		AND tttfcr.idfsCustomReportType = @idfsSummaryReportType
	JOIN trtBaseReference tbr_testresult ON
		tbr_testresult.idfsBaseReference = tt.idfsTestResult
		AND tbr_testresult.idfsReferenceType = 19000096
		AND tbr_testresult.strDefault <> 'Positive'
	
	JOIN trtDiagnosisToGroupForReportType tdtgfrt ON
		tdtgfrt.idfsCustomReportType = @idfsSummaryReportType
		AND tdtgfrt.idfsReportDiagnosisGroup = @idfsReportDiagnosisGroup
		AND tdtgfrt.idfsDiagnosis = tt.idfsDiagnosis
	
	WHERE tt.idfsTestStatus IN (10001001/*Final*/, 10001006/*Amended*/)	
	GROUP BY tt.idfMaterial
)
, TestBioassays AS (
	SELECT
		tt.idfMaterial
		, MIN(tt.datConcludedDate) AS TestResultDate
	FROM tlbTesting tt
	JOIN trtTestTypeForCustomReport tttfcr ON
		tttfcr.idfsTestName = tt.idfsTestName
		AND tttfcr.intRowOrder = 2 /*Bioassays*/
		AND tttfcr.idfsCustomReportType = @idfsSummaryReportType
	JOIN trtBaseReference tbr_testresult ON
		tbr_testresult.idfsBaseReference = tt.idfsTestResult
		AND tbr_testresult.idfsReferenceType = 19000096
		AND tbr_testresult.strDefault <> 'Positive'
		
	JOIN trtDiagnosisToGroupForReportType tdtgfrt ON
		tdtgfrt.idfsCustomReportType = @idfsSummaryReportType
		AND tdtgfrt.idfsReportDiagnosisGroup = @idfsReportDiagnosisGroup
		AND tdtgfrt.idfsDiagnosis = tt.idfsDiagnosis
		
	WHERE tt.idfsTestStatus IN (10001001/*Final*/, 10001006/*Amended*/)	
	GROUP BY tt.idfMaterial
)
, TestBioassaysAnyResult AS (
	SELECT
		tt.idfMaterial
		, MIN(tt.datConcludedDate) AS TestResultDate
	FROM tlbTesting tt
	JOIN trtTestTypeForCustomReport tttfcr ON
		tttfcr.idfsTestName = tt.idfsTestName
		AND tttfcr.intRowOrder = 2 /*Bioassays*/
		AND tttfcr.idfsCustomReportType = @idfsSummaryReportType
		
	JOIN trtDiagnosisToGroupForReportType tdtgfrt ON
		tdtgfrt.idfsCustomReportType = @idfsSummaryReportType
		AND tdtgfrt.idfsReportDiagnosisGroup = @idfsReportDiagnosisGroup
		AND tdtgfrt.idfsDiagnosis = tt.idfsDiagnosis
		
	WHERE tt.idfsTestStatus IN (10001001/*Final*/, 10001006/*Amended*/)	
	GROUP BY tt.idfMaterial
)
, TestRabiesFluorescenceConfirmed AS (
	SELECT
		tt.idfMaterial
		, MIN(tt.datConcludedDate) AS TestResultDate
	FROM tlbTesting tt
	JOIN trtTestTypeForCustomReport tttfcr ON
		tttfcr.idfsTestName = tt.idfsTestName
		AND tttfcr.intRowOrder = 1 /*Rabies fluorescence*/
		AND tttfcr.idfsCustomReportType = @idfsSummaryReportType
	JOIN trtBaseReference tbr_testresult ON
		tbr_testresult.idfsBaseReference = tt.idfsTestResult
		AND tbr_testresult.idfsReferenceType = 19000096
		AND tbr_testresult.strDefault = 'Positive'
	
	JOIN trtDiagnosisToGroupForReportType tdtgfrt ON
		tdtgfrt.idfsCustomReportType = @idfsSummaryReportType
		AND tdtgfrt.idfsReportDiagnosisGroup = @idfsReportDiagnosisGroup
		AND tdtgfrt.idfsDiagnosis = tt.idfsDiagnosis
	
	WHERE tt.idfsTestStatus IN (10001001/*Final*/, 10001006/*Amended*/)	
	GROUP BY tt.idfMaterial
)
, TestBioassaysConfirmed AS (
	SELECT
		tt.idfMaterial
		, MIN(tt.datConcludedDate) AS TestResultDate
	FROM tlbTesting tt
	JOIN trtTestTypeForCustomReport tttfcr ON
		tttfcr.idfsTestName = tt.idfsTestName
		AND tttfcr.intRowOrder = 2 /*Bioassays*/
		AND tttfcr.idfsCustomReportType = @idfsSummaryReportType
	JOIN trtBaseReference tbr_testresult ON
		tbr_testresult.idfsBaseReference = tt.idfsTestResult
		AND tbr_testresult.idfsReferenceType = 19000096
		AND tbr_testresult.strDefault = 'Positive'
		
	JOIN trtDiagnosisToGroupForReportType tdtgfrt ON
		tdtgfrt.idfsCustomReportType = @idfsSummaryReportType
		AND tdtgfrt.idfsReportDiagnosisGroup = @idfsReportDiagnosisGroup
		AND tdtgfrt.idfsDiagnosis = tt.idfsDiagnosis
		
	WHERE tt.idfsTestStatus IN (10001001/*Final*/, 10001006/*Amended*/)	
	GROUP BY tt.idfMaterial
)
, SpeciesAndGroups AS (
	SELECT 
		ISNULL(tstgfcr.idfsSpeciesGroup, 0) AS SpeciesGroupId
		, ISNULL(tbr_specname.idfsBaseReference, 0) AS SpeciesTypeId
		, tscicr.intItemOrder AS ColumnNumber
	FROM trtSpeciesContentInCustomReport tscicr
	LEFT JOIN trtSpeciesGroup tsg 
		JOIN trtSpeciesToGroupForCustomReport tstgfcr ON
			tstgfcr.idfsSpeciesGroup = tsg.idfsSpeciesGroup
			AND tstgfcr.idfsCustomReportType = @idfsSummaryReportType
			AND tstgfcr.intRowStatus = 0
	ON tsg.idfsSpeciesGroup = tscicr.idfsSpeciesOrSpeciesGroup
		AND tsg.intRowStatus = 0
		
	JOIN trtBaseReference tbr_specname ON
		tbr_specname.idfsBaseReference = ISNULL(tstgfcr.idfsSpeciesType, tscicr.idfsSpeciesOrSpeciesGroup)
		AND tbr_specname.idfsReferenceType = 19000086
		AND tbr_specname.intRowStatus = 0
		
	WHERE (tscicr.intRowStatus = 0 OR tscicr.intRowStatus IS NULL)
		AND (tscicr.idfsCustomReportType = @idfsSummaryReportType OR tscicr.idfsCustomReportType IS NULL)
)
, VetCases AS (
	SELECT DISTINCT
		sag.ColumnNumber
		, CAST(ref_Region.idfsReference AS NVARCHAR(100)) + '_' + CAST(ref_Rayon.idfsReference AS NVARCHAR(100))	AS strAreaKey
		, ref_Region.name + '/' + ref_Rayon.name					AS strArea
		, CASE 
			WHEN ts_a.idfsSpeciesType = sag.SpeciesTypeId 
				THEN 1
			ELSE NULL 
		  END														AS SpeciesColumn
		, ta.idfAnimal												AS AnimalSpecies
	FROM tlbVetCase tvc
	LEFT JOIN trtDiagnosisToGroupForReportType tt ON
		tt.idfsCustomReportType = @idfsSummaryReportType
		AND tt.idfsReportDiagnosisGroup = @idfsReportDiagnosisGroup
		AND tt.idfsDiagnosis = tvc.idfsShowDiagnosis
	JOIN tlbFarm tf ON
		tf.idfFarm = tvc.idfFarm
		AND tf.intRowStatus = 0
	JOIN tlbGeoLocation tgl ON
		tgl.idfGeoLocation = tf.idfFarmAddress
		AND tgl.intRowStatus = 0
	JOIN @FilteredRayons fr ON
		fr.idfsRayon = tgl.idfsRayon
	JOIN fnGisReferenceRepair(@LangID, 19000003) AS ref_Region ON
		ref_Region.idfsReference = tgl.idfsRegion
	JOIN fnGisReferenceRepair(@LangID, 19000002) AS ref_Rayon ON
		ref_Rayon.idfsReference = tgl.idfsRayon	
	JOIN tlbMaterial tm ON
		tm.idfVetCase = tvc.idfVetCase
		AND tm.intRowStatus = 0
			
	JOIN tlbAnimal ta 
		JOIN tlbSpecies ts_a ON
			ts_a.idfSpecies = ta.idfSpecies
			AND ts_a.intRowStatus = 0
	ON ta.idfAnimal = tm.idfAnimal
		AND ta.intRowStatus = 0
		
	LEFT JOIN TestBioassays tb ON
		tb.idfMaterial = tm.idfMaterial
	
	LEFT JOIN TestBioassaysAnyResult tbar ON
		tbar.idfMaterial = tm.idfMaterial		
	LEFT JOIN TestRabiesFluorescence trf ON
		trf.idfMaterial = tm.idfMaterial
			
	LEFT JOIN TestRabiesFluorescenceConfirmed trfc ON
		trfc.idfMaterial = tm.idfMaterial
	LEFT JOIN TestBioassaysConfirmed tbc ON
		tbc.idfMaterial = tm.idfMaterial
		
	CROSS JOIN SpeciesAndGroups sag
	
	WHERE tvc.intRowStatus = 0
		AND tvc.idfsCaseType = 10012003 /*Livestock*/ 
		
		AND (
				(
					tb.TestResultDate IS NOT NULL 
					AND (
							tb.TestResultDate BETWEEN @FromDate AND @EndDate 
								OR (@FromDate2 IS NOT NULL AND @EndDate2 IS NOT NULL AND tb.TestResultDate BETWEEN @FromDate2 AND @EndDate2)
						)
				)
				OR (
						(
							tbar.idfMaterial IS NULL
								--OR (
								--		tbar.TestResultDate NOT BETWEEN @FromDate AND @EndDate
								--		OR (@FromDate2 IS NOT NULL AND @EndDate2 IS NOT NULL AND tbar.TestResultDate NOT BETWEEN @FromDate2 AND @EndDate2)
								--	)
						
						)
					AND (
							trf.TestResultDate IS NOT NULL
							AND (
									trf.TestResultDate BETWEEN @FromDate AND @EndDate 
										OR (@FromDate2 IS NOT NULL AND @EndDate2 IS NOT NULL AND trf.TestResultDate BETWEEN @FromDate2 AND @EndDate2)
								)
						)
					)
			)
		
		AND (
				(tvc.idfsShowDiagnosis IS NOT NULL AND tt.idfDiagnosisToGroupForReportType IS NULL)
				OR (tt.idfDiagnosisToGroupForReportType IS NOT NULL AND tvc.idfsCaseClassification <> 350000000 /*Confirmed Case*/)
				OR (
						tt.idfDiagnosisToGroupForReportType IS NOT NULL 
						AND tvc.idfsCaseClassification = 350000000 /*Confirmed Case*/
						AND (
								COALESCE(trfc.TestResultDate, tbc.TestResultDate, 0) <> 0
								AND (
										COALESCE(trfc.TestResultDate, tbc.TestResultDate) BETWEEN @FromDate AND @EndDate
										OR (@FromDate2 IS NOT NULL AND @EndDate2 IS NOT NULL 
											AND COALESCE(trfc.TestResultDate, tbc.TestResultDate) BETWEEN @FromDate2 AND @EndDate2)
									)
							)
					)
			)

)
, GroupVetCases AS (
	SELECT
		ColumnNumber
		, strAreaKey
		, strArea				AS strArea
		, SUM(SpeciesColumn)	AS SpeciesColumn
	FROM VetCases
	GROUP BY ColumnNumber, strArea, strAreaKey
)

	
	INSERT INTO @Result
	(
		strAreaKey,
		strArea,
		intDomesticDog,
		intDomesticCat,
		intDomesticCattle,
		intDomesticEquine,
		intDomesticSheep,
		intDomesticGoat,
		intDomesticPig,
		intDomesticStrayDog,
		intDomesticOther,
		intDomesticUnspecified,
		intWildlifeFox,
		intWildlifeRaccoonDog,
		intWildlifeRaccoon,
		intWildlifeWolf,
		intWildlifeBadger,
		intWildlifeMarten,
		intWildlifeOtherMustelides,
		intWildlifeOtherCarnivores,
		intWildlifeWildBoar,
		intWildlifeRoeDeer,
		intWildlifeRedDeer,
		intWildlifeFallowDeer,
		intWildlifeOther,
		intWildlifeBat,
		intWildlifeUnspecified
	)
	
	SELECT
		strAreaKey,
		strArea,
		[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25]
	FROM GroupVetCases
	PIVOT (MAX(SpeciesColumn) for ColumnNumber IN (
		[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25])) AS pvt


	SELECT 
		* 
	FROM @Result r
	ORDER BY r.strArea
	
END
