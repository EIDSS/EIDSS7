
--*************************************************************
-- Name 				: fnDiagnosisString
-- Description			: Returns text representation of geolocation record.
-- Author               : Joan Li
-- Revision History
--		Name			Date			Change Detail
--		Joan Li			10/24/2017		convert from v6: fnDiagnosisString
--
-- Testing code:
-- DECLARE @GeoLocation BIGINT
-- SELECT @GeoLocation=52578540000000
-- SELECT dbo.fnDiagnosisString ( 'en',@GeoLocation )
--*************************************************************
CREATE FUNCTION [dbo].[fnDiagnosisString] 
(
	@LangID  NVARCHAR(50), 
	@VetCase BIGINT
) 
RETURNS NVARCHAR(500)
AS 
BEGIN 

SET QUOTED_IDENTIFIER ON;

DECLARE @TempStr NVARCHAR(500)
        ,@l_refTypeID BIGINT

	-----JL: replace hard coded ReferencetypeID: 19000019
	SELECT @l_refTypeID=(SELECT idfsReferenceType  FROM dbo.trtReferenceType WHERE strReferenceTypeName IN ('diagnosis'))

;
WITH AllDiag AS (
	SELECT
		tvc.datTentativeDiagnosisDate
		, tvc.datTentativeDiagnosis1Date
		, tvc.datTentativeDiagnosis2Date
		, tvc.idfsTentativeDiagnosis
		, tvc.idfsTentativeDiagnosis1
		, tvc.idfsTentativeDiagnosis2
		, vcls_td.name AS TentativeDiagnosisName
		, vcls_td1.name AS TentativeDiagnosis1Name
		, vcls_td2.name AS TentativeDiagnosis2Name
	FROM tlbVetCase tvc
	LEFT JOIN dbo.fnReferenceRepair(@LangID,@l_refTypeID) vcls_td ON
		vcls_td.idfsReference = tvc.idfsTentativeDiagnosis
	LEFT JOIN dbo.fnReferenceRepair(@LangID,@l_refTypeID) vcls_td1 ON
		vcls_td1.idfsReference = tvc.idfsTentativeDiagnosis1
	LEFT JOIN dbo.fnReferenceRepair(@LangID,@l_refTypeID) vcls_td2 ON
		vcls_td2.idfsReference = tvc.idfsTentativeDiagnosis2
	WHERE tvc.idfVetCase = @VetCase
	)

SELECT @TempStr =
	STUFF(
			(
				SELECT
					', ' + DiagnosisName
				FROM (
					SELECT
						3						AS SortOrder
						, CONVERT(NVARCHAR(8),datTentativeDiagnosisDate,112)	AS DiagnosisDate
						, idfsTentativeDiagnosis	AS DiagnosisId
						, TentativeDiagnosisName	AS DiagnosisName
					FROM AllDiag
					UNION ALL
					SELECT
						2
						, CONVERT(NVARCHAR(8),datTentativeDiagnosis1Date,112)
						, idfsTentativeDiagnosis1
						, TentativeDiagnosis1Name
					FROM AllDiag
					UNION ALL
					SELECT
						1
						, CONVERT(NVARCHAR(8),datTentativeDiagnosis2Date,112)
						, idfsTentativeDiagnosis2
						, TentativeDiagnosis2Name
					FROM AllDiag
				) a
				WHERE DiagnosisId IS NOT NULL
				ORDER BY DiagnosisDate DESC
					, SortOrder
				FOR XML PATH(''), TYPE
			).value('.', 'nvarchar(max)')
          ,1,2,'')
      
RETURN @TempStr

END

