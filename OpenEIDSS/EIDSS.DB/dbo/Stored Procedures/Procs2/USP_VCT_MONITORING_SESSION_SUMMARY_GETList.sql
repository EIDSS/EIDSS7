-- ================================================================================================
-- Name: USP_VCT_MONITORING_SESSION_SUMMARY_GETList
--
-- Description:	Get monitoring session aggregate info list for the veterinary module monitoring 
-- session edit/enter use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     05/07/2018 Initial release
-- Stephen Long     05/03/2019 Modified for API; removed maintenance flag.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_MONITORING_SESSION_SUMMARY_GETList] (
	@LanguageID NVARCHAR(50),
	@MonitoringSessionID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT mss.idfMonitoringSessionSummary AS MonitoringSessionSummaryID,
			mss.idfMonitoringSession AS MonitoringSessionID,
			mss.idfFarm AS FarmID,
			f.strFarmCode AS EIDSSFarmID,
			mss.idfSpecies AS SpeciesID,
			speciesType.name AS SpeciesTypeName,
			mss.idfsAnimalSex AS AnimalGenderTypeID,
			animalGenderType.name AS AnimalGenderTypeName,
			mss.intSampledAnimalsQty AS SampledAnimalsQuantity,
			mss.intSamplesQty AS SamplesQuantity,
			mss.datCollectionDate AS CollectionDate,
			mss.intPositiveAnimalsQty AS PositiveAnimalsQuantity,
			msss.idfsSampleType AS SampleTypeID,
			sampleType.name AS SampleTypeName,
			msss.blnChecked AS SampleCheckedIndicator,
			mssd.idfsDiagnosis AS DiseaseID,
			diseaseBaseReference.name AS DiseaseName,
			mssd.blnChecked AS DiseaseCheckedIndicator,
			mss.intRowStatus AS RowStatus,
			'R' AS RowAction
		FROM dbo.tlbMonitoringSessionSummary mss
		LEFT JOIN dbo.tlbMonitoringSessionSummarySample msss
			ON msss.idfMonitoringSessionSummary = mss.idfMonitoringSessionSummary
				AND msss.intRowStatus = 0
		LEFT JOIN dbo.tlbMonitoringSessionSummaryDiagnosis mssd
			ON msss.idfMonitoringSessionSummary = mssd.idfMonitoringSessionSummary
				AND mssd.intRowStatus = 0
		LEFT JOIN dbo.tlbSpecies AS s
			ON s.idfSpecies = mss.idfSpecies
				AND s.intRowStatus = 0
		LEFT JOIN dbo.tlbFarm AS f
			ON f.idfFarm = mss.idfFarm
				AND f.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
			ON speciesType.idfsReference = s.idfsSpeciesType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000007) AS animalGenderType
			ON animalGenderType.idfsReference = mss.idfsAnimalSex
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = msss.idfsSampleType
		LEFT JOIN dbo.trtDiagnosis AS diagnosisReference
			ON diagnosisReference.idfsDiagnosis = mssd.idfsDiagnosis
				AND diagnosisReference.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS diseaseBaseReference
			ON diseaseBaseReference.idfsReference = mssd.idfsDiagnosis
		WHERE (
				(mss.idfMonitoringSession = @MonitoringSessionID)
				OR (@MonitoringSessionID IS NULL)
				)
			AND mss.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END
