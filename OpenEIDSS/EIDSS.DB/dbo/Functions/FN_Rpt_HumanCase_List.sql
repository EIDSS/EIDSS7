


CREATE FUNCTION [dbo].[FN_Rpt_HumanCase_List]
(
	@Year		INT
	,@RegionID	BIGINT
--	,@RayonID	BIGINT -- removed to return rural data
)

RETURNS @HumanCase 
		TABLE	(idfHumanCase			BIGINT,
                 idfHuman				BIGINT,
				 datNotificationDate	DATETIME,
				 intNotificationMonth	INT,
				 intNotificationYear	INT,
				 AgeYears				INT,
				 AgeMonths				INT,
				 DOB					DATETIME,
				 idfsSite				BIGINT,
				 idfsRegion				BIGINT,
				 strRegion				NVARCHAR(300),
				 idfsRayon				BIGINT,
				 strRayon				NVARCHAR(300),
				 icd10					NVARCHAR(100),
				 idfsDiagnosis			BIGINT,
				 idfsReportDiagnosisGp	BIGINT
				)

AS

BEGIN		

		INSERT INTO @HumanCase

		SELECT 
			HC.idfHumanCase
			,HC.idfHuman
			,HC.datNotificationDate
			,DATEPART(MONTH, HC.datNotificationDate) as intNotificationMonth
			,DATEPART(YEAR, HC.datNotificationDate) as intNotificationYear
			,FLOOR(DATEDIFF(DAY, H.datDateofBirth, HC.datNotificationDate)/365.242199) as AgeYears
			,FLOOR(DATEDIFF(DAY, H.datDateofBirth, HC.datNotificationDate)*(12/365.242199)) as AgeMonths
			,H.datDateofBirth as DOB
			,HC.idfsSite
			,GL.idfsRegion
			,Region.strDefault AS strRegion
			,GL.idfsRayon
			,Rayon.strDefault AS strRayon
			,D.strIDC10 AS strICD10
			,CASE WHEN HC.idfsFinalDiagnosis IS NULL THEN HC.idfsTentativeDiagnosis ELSE HC.idfsFinalDiagnosis END AS idfsDiagnosis
			,DGRT.idfsReportDiagnosisGroup
  
		FROM dbo.tlbHumanCase HC
		LEFT JOIN dbo.tlbHuman H ON HC.idfHuman = H .idfHuman
		LEFT JOIN dbo.tlbGeoLocation GL ON H.idfCurrentResidenceAddress = GL.idfGeoLocation
		LEFT JOIN dbo.gisBaseReference Region ON GL.idfsRegion = Region.idfsGISBaseReference
		LEFT JOIN dbo.gisBaseReference Rayon ON GL.idfsRayon = Rayon.idfsGISBaseReference
		LEFT JOIN dbo.trtDiagnosisToGroupForReportType DGRT on DGRT.idfsDiagnosis = CASE WHEN HC.idfsFinalDiagnosis IS NULL 
		                                                                                  THEN HC.idfsTentativeDiagnosis 
																						  ELSE HC.idfsFinalDiagnosis END
		LEFT JOIN dbo.trtDiagnosis D ON D.idfsDiagnosis = CASE WHEN HC.idfsFinalDiagnosis IS NULL 
														   THEN HC.idfsTentativeDiagnosis 
														   ELSE HC.idfsFinalDiagnosis END

		WHERE HC.datNotificationDate IS NOT NULL
		AND YEAR(HC.datNotificationDate) = @Year -- notification happened in the year requested
		AND YEAR(H.datDateOfBirth) <= @Year
		AND (YEAR(H.datDateOfDeath) IS NULL 
		OR YEAR(H.datDateOfDeath) >= @Year) -- patient did not die prior to year
		AND GL.idfsRegion = @RegionID 

	RETURN

END


