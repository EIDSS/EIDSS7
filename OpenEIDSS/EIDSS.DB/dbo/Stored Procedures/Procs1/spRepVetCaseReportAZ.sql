

--##SUMMARY Select data for Avian Test report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 20.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepVetCaseReportAZ @LangID=N'en', @FromYear = 2012, @ToYear = 2013
exec dbo.spRepVetCaseReportAZ 'ru',2012,2013

*/

create  Procedure [dbo].[spRepVetCaseReportAZ]
    (
        @LangID as nvarchar(10)
        , @FromYear AS INT
		, @ToYear AS INT
		, @FromMonth AS INT = NULL
		, @ToMonth AS INT = NULL
		, @RegionID AS BIGINT = NULL
		, @RayonID AS BIGINT = NULL
		, @OrganizationEntered AS BIGINT = NULL
    )
as
begin

DECLARE @Result AS TABLE
(
	strDiagnosisSpeciesKey	NVARCHAR(200) NOT NULL PRIMARY KEY,
	idfsDiagnosis			BIGINT NOT NULL,
	strDiagnosisName		NVARCHAR(200),
	strOIECode				NVARCHAR(200),
	intNumberCases			INT,
	intNumberSamples		INT,
	strSpecies				NVARCHAR(200),
	intNumberSpecies		INT,
	SpeciesOrderColumn		INT,
	DiagnosisOrderColumn	INT
)



DECLARE @FromDate DATETIME 
	, @ToDate DATETIME
	
IF @FromMonth IS NULL OR @ToMonth IS NULL
BEGIN
	SET @FromDate = (CAST(@FromYear AS VARCHAR(4)) + '01' + '01')
	SET @ToDate = (CAST(@ToYear AS VARCHAR(4)) + '01' + '01')
	SET @ToDate = DATEADD(yy, 1, @ToDate)
END
ELSE
	BEGIN
		SET @FromDate = (CAST(@FromYear AS VARCHAR(4)) + REPLICATE('0', 2 - LEN(CAST(@FromMonth AS VARCHAR(4)))) + CAST(@FromMonth AS VARCHAR(2)) + '01')
		SET @ToDate =(CAST(@ToYear AS VARCHAR(4)) + REPLICATE('0', 2 - LEN(CAST(@ToMonth AS VARCHAR(4)))) +CAST(@ToMonth AS VARCHAR(2)) + '01')
		SET @ToDate = DATEADD(mm, 1, @ToDate)

	END


DECLARE @Country BIGINT = 170000000 /*AZ*/

DECLARE @FilteredRayons AS TABLE (idfsRayon BIGINT PRIMARY KEY)

INSERT INTO @FilteredRayons (idfsRayon)
SELECT 
	gr.idfsRayon
FROM gisRayon gr 
WHERE gr.idfsRegion = ISNULL(@RegionID, idfsRegion)
	AND gr.idfsRayon = ISNULL(@RayonID, idfsRayon)
	AND gr.idfsCountry = @Country



DECLARE @idfsSummaryReportType BIGINT
	, @SubtotalName NVARCHAR(500)
	
SET @idfsSummaryReportType = 10290025 /*AZ RepVetCaseReportAZ*/
	
SELECT
	@SubtotalName = fr.name
FROM dbo.fnReference(@LangID, 19000132) fr
WHERE fr.idfsReference = 10300057



;
WITH VetCase AS ( /*собираем все кейсы, подпадающие под условия*/
	SELECT 
		tvc.idfVetCase
		, COALESCE(tvc.idfsFinalDiagnosis, tvc.idfsTentativeDiagnosis2, tvc.idfsTentativeDiagnosis1, tvc.idfsTentativeDiagnosis) AS Diagnosis
		, COALESCE(tvc.datFinalDiagnosisDate, tvc.datTentativeDiagnosis2Date, tvc.datTentativeDiagnosis1Date, tvc.datTentativeDiagnosisDate) AS DiagnosisDate
		, ts.idfSpecies
		, ts.idfsSpeciesType
		, ISNULL(ts.intSickAnimalQty, 0) + ISNULL(ts.intDeadAnimalQty, 0) AS intTotalAnimalQty
		, tm.idfMaterial
	FROM tlbVetCase tvc
	JOIN tstSite tsite ON
		tsite.idfsSite = tvc.idfsSite
		AND tsite.idfOffice = ISNULL(@OrganizationEntered, tsite.idfOffice)
		AND tsite.intRowStatus = 0
	JOIN tlbFarm tf ON
		tf.idfFarm = tvc.idfFarm
		AND tf.intRowStatus = 0
	JOIN tlbGeoLocation tgl ON
		tgl.idfGeoLocation = tf.idfFarmAddress
		AND tgl.intRowStatus = 0
	JOIN @FilteredRayons fr ON
		fr.idfsRayon = tgl.idfsRayon
	JOIN tlbHerd th ON
		th.idfFarm = tf.idfFarm
		AND th.intRowStatus = 0
	JOIN tlbSpecies ts ON
		ts.idfHerd = th.idfHerd
		AND ts.intRowStatus = 0
	LEFT JOIN tlbMaterial tm ON
		tm.idfVetCase = tvc.idfVetCase
		AND tm.intRowStatus = 0
		--AND tm.idfRootMaterial = tm.idfMaterial
		AND tm.idfParentMaterial IS NULL
		AND tm.idfsSampleType <> 10320001 /*Unknown*/
	WHERE tvc.intRowStatus = 0
		AND tvc.idfsCaseClassification = 350000000 /*Confirmed Case*/
)
, VetCase3 AS ( /*суммируем сэмплы и энималов по парам кейс-спишес и отсекаем кейсы по дате*/
	SELECT
		vc.idfVetCase
		, vc.Diagnosis
		, vc.idfsSpeciesType
		, vc.intTotalAnimalQty
		, COUNT(vc.idfMaterial) AS intNumberSamples
	FROM VetCase vc
	WHERE vc.DiagnosisDate >= @FromDate 
		AND vc.DiagnosisDate < @ToDate
	GROUP BY vc.idfVetCase
		, vc.Diagnosis
		, vc.idfsSpeciesType
		, vc.intTotalAnimalQty
)
, VetCase4 AS ( /*подсчитываем количество кейсов, сэмплов, энималов по каждой паре диагноз-спишес*/
	SELECT
		CAST(vc3.Diagnosis AS NVARCHAR(50)) + '_' + CAST(vc3.idfsSpeciesType AS NVARCHAR(50))		AS strDiagnosisSpeciesKey
		, vc3.Diagnosis																				AS idfsDiagnosis
		, COUNT(DISTINCT vc3.idfVetCase)															AS intNumberCases
		, SUM(intNumberSamples)																		AS intNumberSamples
		, frr.name																					AS strSpecies
		, SUM(vc3.intTotalAnimalQty)																AS intNumberSpecies
		, IsNull(frr.intOrder, 0)																	AS SpeciesOrderColumn
	FROM VetCase3 vc3
	JOIN dbo.fnReferenceRepair(@LangID, 19000086) frr ON	/*Species List*/
		frr.idfsReference = vc3.idfsSpeciesType
	GROUP BY vc3.Diagnosis
		, vc3.idfsSpeciesType
		, frr.name
		, IsNull(frr.intOrder, 0)
)

, AllCase2 AS ( /*суммируем числовые показатели отобранных кейсов по диагнозам и спишес-тайпам*/
	SELECT
		strDiagnosisSpeciesKey
		, AllCase.idfsDiagnosis
		, SUM(intNumberCases) AS intNumberCases
		, SUM(intNumberSamples) AS intNumberSamples
		, strSpecies
		, SUM(intNumberSpecies) AS intNumberSpecies
		, SpeciesOrderColumn
	FROM VetCase4 AS AllCase
	JOIN dbo.fnDiagnosisRepair(@LangID, 96, NULL) fdr ON
		fdr.idfsDiagnosis = AllCase.idfsDiagnosis
	GROUP BY strDiagnosisSpeciesKey
		, AllCase.idfsDiagnosis
		, strSpecies
		, SpeciesOrderColumn
)
, NotDeletedDiagnosis AS (
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
, AllCase3 AS ( /*добавляем к информации, полученной из кейсов пустые дигнозы, которые не попали в выборку по кейсам
					и суммируем количество кейсов и количество сэмплов по диагнозам*/
	SELECT
		td.idfsActualDiagnosis AS idfsDiagnosis
		, ISNULL(SUM(intNumberCases), 0)		AS intNumberCases
		, ISNULL(SUM(intNumberSamples), 0)		AS intNumberSamples
		, ISNULL(SUM(ac2.intNumberSpecies), 0)	AS intNumberSpecies
	FROM NotDeletedDiagnosis td
	LEFT JOIN AllCase2 ac2 ON
		ac2.idfsDiagnosis = td.idfsDiagnosis
	LEFT JOIN fnReference(@LangID, 19000019) r_d_actual ON
		r_d_actual.idfsReference = td.idfsActualDiagnosis
	WHERE td.rn = 1
		AND (ac2.idfsDiagnosis IS NOT NULL OR r_d_actual.idfsReference IS NOT NULL)
	GROUP BY td.idfsActualDiagnosis
)

INSERT INTO @Result
SELECT
	x.strDiagnosisSpeciesKey
	, x.idfsDiagnosis
	, fdr.name						AS strDiagnosisName
	, td.strOIECode					AS strOIECode
	, ac3.intNumberCases
	, ac3.intNumberSamples
	, x.strSpecies
	, x.intNumberSpecies
	, x.SpeciesOrderColumn	--ROW_NUMBER() OVER (PARTITION BY x.idfsDiagnosis ORDER BY CASE WHEN x.strSpecies = ISNULL(@SubtotalName, 'Subtotal of sick species') THEN 2 ELSE 1 END) AS SpeciesOrderColumn
	, fdr.intOrder as DiagnosisOrderColumn
FROM (
	SELECT
		strDiagnosisSpeciesKey
		, idfsDiagnosis
		, strSpecies
		, intNumberSpecies
		, SpeciesOrderColumn
	FROM AllCase2
	UNION ALL
	SELECT
		CAST(idfsDiagnosis AS NVARCHAR(255))
		, idfsDiagnosis
		, ISNULL(@SubtotalName, 'Subtotal of sick and dead')
		, intNumberSpecies
		,	IsNull	(	(	select	max(IsNull(r_st.intOrder, 0))
							from	fnReferenceRepair('en', 19000086) r_st /*Species List*/
						), 0
					) + 1
					
	FROM AllCase3
) x
JOIN dbo.fnReferenceRepair(@LangID, 19000019) fdr ON	/*Diagnosis*/
	fdr.idfsReference = x.idfsDiagnosis
	AND (fdr.intHACode & 32 = 32 /*Livestock*/ OR fdr.intHACode & 64 = 64 /*Avian*/)
JOIN	trtDiagnosis td ON
	td.idfsDiagnosis = fdr.idfsReference
JOIN AllCase3 ac3 ON
	ac3.idfsDiagnosis = x.idfsDiagnosis

	     
SELECT * FROM @result ORDER BY DiagnosisOrderColumn, strDiagnosisName, idfsDiagnosis, SpeciesOrderColumn
	     
end
