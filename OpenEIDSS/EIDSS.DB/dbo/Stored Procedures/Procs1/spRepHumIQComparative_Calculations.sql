

--##SUMMARY This procedure returns data for IQ - Comparative Report 

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 13.01.2015


--##RETURNS Don't use 

 
create PROCEDURE [dbo].[spRepHumIQComparative_Calculations]
    @StartDate DATETIME,
    @FinishDate DATETIME,
    @RegionID BIGINT,
    @RayonID BIGINT
AS
BEGIN

exec dbo.spSetFirstDay

DECLARE 	  
  	@idfsSummaryReportType BIGINT

	SET @idfsSummaryReportType = 10290024 /*IQ Comparative Report*/
	
	
	
	DECLARE @ReportCaseTable table
	(	
		idfsDiagnosis BIGINT NOT NULL,
		idfCase BIGINT NOT NULL PRIMARY KEY,
		idfsRegion BIGINT,
		idfsRayon BIGINT
	)
	
	INSERT INTO @ReportCaseTable
	(	
		idfsDiagnosis,
		idfCase,
		idfsRegion,
		idfsRayon
	)
	SELECT DISTINCT
		fdt.idfsDiagnosis
		, hc.idfHumanCase AS idfCase
		, gl.idfsRegion  /*region CR*/
		, gl.idfsRayon  /*rayon CR*/				
	FROM tlbHumanCase hc
		
	JOIN #ReportDiagnosisTable fdt ON
		fdt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
	JOIN tlbHuman h
			LEFT OUTER JOIN tlbGeoLocation gl ON
				h.idfCurrentResidenceAddress = gl.idfGeoLocation AND gl.intRowStatus = 0
	ON hc.idfHuman = h.idfHuman 
		AND	h.intRowStatus = 0					
	WHERE @StartDate <= COALESCE(hc.datOnSetDate, hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate, hc.datNotificationDate, hc.datEnteredDate)
		AND COALESCE(hc.datOnSetDate, hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate, hc.datNotificationDate, hc.datEnteredDate) < @FinishDate
				
		AND (gl.idfsRegion = @RegionID OR @RegionID IS NULL) 
		AND	(gl.idfsRayon = @RayonID OR @RayonID IS NULL)
		
		AND hc.intRowStatus = 0
		AND COALESCE(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus) <> 370000000 /*casRefused*/


	--Total
	DECLARE @ReportCaseDiagnosisTotalValuesTable table
	(	
		idfsDiagnosis	BIGINT NOT NULL PRIMARY KEY,
		intTotal		INT NOT NULL 
	)

	INSERT INTO @ReportCaseDiagnosisTotalValuesTable
	(	
		idfsDiagnosis,
		intTotal
	)
	SELECT 
		fct.idfsDiagnosis
		, COUNT(fct.idfCase)
	FROM @ReportCaseTable fct
	GROUP BY fct.idfsDiagnosis

	--standard cases
	UPDATE fdt
	SET fdt.intTotal = isnull(fdt.intTotal, 0) + isnull(fcdvt.intTotal, 0)
	FROM #ReportDiagnosisTable fdt
	JOIN @ReportCaseDiagnosisTotalValuesTable fcdvt	ON
		fcdvt.idfsDiagnosis = fdt.idfsDiagnosis



end

