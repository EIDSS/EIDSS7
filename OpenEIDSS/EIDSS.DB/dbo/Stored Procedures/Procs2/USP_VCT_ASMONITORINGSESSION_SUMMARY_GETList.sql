
-- ============================================================================
-- Name: USP_VCT_ASMONITORINGSESSION_SUMMARY_GETList
-- Description:	Get active surveillance monitoring session aggregate info list 
-- for the veterinary module active surveillance edit/enter use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/07/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_VCT_ASMONITORINGSESSION_SUMMARY_GETList] 
(
	@LangID							NVARCHAR(50), 
	@idfMonitoringSession			BIGINT = NULL
)
AS
BEGIN
	DECLARE @returnMsg				VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode				BIGINT = 0;

	BEGIN TRY  	
		SELECT						mss.idfMonitoringSessionSummary, 
									mss.idfMonitoringSession, 
									mss.idfFarm,
									f.strFarmCode, 
									mss.idfSpecies,
									speciesType.name AS SpeciesTypeName, 
									mss.idfsAnimalSex,
									animalGender.name AS AnimalGenderTypeName, 
									mss.intSampledAnimalsQty,
									mss.intSamplesQty,
									mss.datCollectionDate, 
									mss.intPositiveAnimalsQty, 
									mss.intRowStatus,
									mss.strMaintenanceFlag, 
									msss.idfsSampleType, 
									sampleType.name AS SampleTypeName, 
									msss.blnChecked AS SampleChecked, 
									mssd.idfsDiagnosis, 
									diagnosisBaseReference.name AS DiagnosisName,
									mssd.blnChecked AS DiagnosisChecked, 
									'R' AS RecordAction 
		FROM						dbo.tlbMonitoringSessionSummary mss 
		LEFT JOIN					dbo.tlbMonitoringSessionSummarySample msss 
		ON							msss.idfMonitoringSessionSummary = mss.idfMonitoringSessionSummary AND msss.intRowStatus = 0
		LEFT JOIN					dbo.tlbMonitoringSessionSummaryDiagnosis mssd 
		ON							msss.idfMonitoringSessionSummary = mssd.idfMonitoringSessionSummary AND mssd.intRowStatus = 0
		LEFT JOIN					dbo.tlbSpecies AS s
		ON							s.idfSpecies = mss.idfSpecies AND s.intRowStatus = 0 
		LEFT JOIN					dbo.tlbFarm AS f
		ON							f.idfFarm = mss.idfFarm AND f.intRowStatus = 0 
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangID, 19000086) AS speciesType
		ON							speciesType.idfsReference = s.idfsSpeciesType 
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangID, 19000007) AS animalGender
		ON							animalGender.idfsReference = mss.idfsAnimalSex 
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangID, 19000087) AS sampleType
		ON							sampleType.idfsReference = msss.idfsSampleType 
		LEFT JOIN					dbo.trtDiagnosis AS diagnosisReference 
		ON							diagnosisReference.idfsDiagnosis = mssd.idfsDiagnosis AND diagnosisReference.intRowStatus = 0 
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangID, 19000019) AS diagnosisBaseReference
		ON							diagnosisBaseReference.idfsReference = mssd.idfsDiagnosis
		WHERE						mss.idfMonitoringSession = CASE ISNULL(@idfMonitoringSession, '') WHEN '' THEN mss.idfMonitoringSession ELSE @idfMonitoringSession END
		AND							mss.intRowStatus = 0;

		SELECT						@returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		BEGIN
			SET						@returnCode = ERROR_NUMBER();
			SET						@returnMsg = 'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
									+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
									+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
									+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
									+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE(), ''))
									+ ' ErrorMessage: ' + ERROR_MESSAGE();

			SELECT					@returnCode, @returnMsg;
		END
	END CATCH;
END
