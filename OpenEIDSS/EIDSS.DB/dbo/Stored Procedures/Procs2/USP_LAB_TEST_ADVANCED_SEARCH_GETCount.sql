
-- ================================================================================================
-- Name: USP_LAB_TEST_ADVANCED_SEARCH_GETCount
--
-- Description:	Get laboratory tests count for the various lab use cases.
--
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     02/19/2019 Initial release.
-- Stephen Long     03/01/2019 Added return code and return message.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_TEST_ADVANCED_SEARCH_GETCount] (
	@LanguageID NVARCHAR(50),
	@SiteID BIGINT,
	@ReportSessionType NVARCHAR(50) = NULL,
	@SurveillanceTypeID BIGINT = NULL,
	@SampleStatusTypeID NVARCHAR(MAX) = NULL,
	@AccessionedIndicator INT = NULL,
	@EIDSSLocalFieldSampleID NVARCHAR(200) = NULL,
	@ExactMatchEIDSSLocalFieldSampleID NVARCHAR(200) = NULL,
	@EIDSSReportCampaignSessionID NVARCHAR(200) = NULL,
	@OrganizationSentToID BIGINT = NULL,
	@OrganizationTransferredToID BIGINT = NULL,
	@EIDSSTransferID NVARCHAR(200) = NULL,
	@ResultsReceivedFromID BIGINT = NULL,
	@AccessionDateFrom DATETIME = NULL,
	@AccessionDateTo DATETIME = NULL,
	@EIDSSLaboratorySampleID NVARCHAR(200) = NULL,
	@SampleTypeID BIGINT = NULL,
	@TestNameTypeID BIGINT = NULL,
	@DiseaseID BIGINT = NULL,
	@TestStatusTypeID BIGINT = NULL,
	@TestResultTypeID BIGINT = NULL,
	@TestResultDateFrom DATETIME = NULL,
	@TestResultDateTo DATETIME = NULL,
	@PatientName NVARCHAR(200) = NULL,
	@FarmOwnerName NVARCHAR(200) = NULL,
	@SpeciesTypeID BIGINT NULL
	)
AS
BEGIN
	DECLARE @returnCode INT = 0;
	DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @CampaignID AS NVARCHAR(200);

		SET @CampaignID = NULL;

		--Campaign ID entered
		IF NOT @EIDSSReportCampaignSessionID IS NULL
			AND @EIDSSReportCampaignSessionID <> ''
		BEGIN
			IF (
					LEFT(@EIDSSReportCampaignSessionID, 1) = 'D'
					OR LEFT(@EIDSSReportCampaignSessionID, 3) = 'HSC'
					)
			BEGIN
				SET @CampaignID = @EIDSSReportCampaignSessionID;
				SET @EIDSSReportCampaignSessionID = NULL;
			END;
		END;

		SELECT COUNT(*) AS RecordCount
		FROM dbo.tlbMaterial m
		INNER JOIN dbo.tlbTesting AS t
			ON t.idfMaterial = m.idfMaterial
				AND t.intRowStatus = 0
		LEFT JOIN dbo.tlbMaterial AS originalLabSample
			ON originalLabSample.idfMaterial = m.idfParentMaterial
		LEFT JOIN dbo.tlbAnimal AS a
			ON a.idfAnimal = m.idfAnimal
		LEFT JOIN dbo.tlbHumanCase AS hc
			ON hc.idfHumanCase = m.idfHumanCase
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS hdrDisease
			ON hdrDisease.idfsReference = hc.idfsFinalDiagnosis
		LEFT JOIN dbo.tlbVetCase AS vc
			ON vc.idfVetCase = m.idfVetCase
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS vdrDisease
			ON vdrDisease.idfsReference = vc.idfsFinalDiagnosis
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS sampleDisease
			ON sampleDisease.idfsReference = m.DiseaseID
		LEFT JOIN dbo.tlbMonitoringSession AS ms
			ON ms.idfMonitoringSession = m.idfMonitoringSession
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS msDisease
			ON msDisease.idfsReference = ms.idfsDiagnosis
		LEFT JOIN dbo.tlbCampaign AS c
			ON c.idfCampaign = ms.idfCampaign
		LEFT JOIN dbo.tlbTransferOutMaterial AS tom
			ON tom.idfMaterial = m.idfMaterial
		LEFT JOIN dbo.tlbTransferOUT AS tro
			ON tro.idfTransferOut = tom.idfTransferOut
		LEFT JOIN dbo.tlbDepartment AS d
			ON d.idfDepartment = m.idfInDepartment
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000164) AS functionalArea
			ON functionalArea.idfsReference = d.idfsDepartmentName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = m.idfsSampleType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000015) AS sampleStatusType
			ON sampleStatusType.idfsReference = m.idfsSampleStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000110) AS accessionConditionType
			ON accessionConditionType.idfsReference = m.idfsAccessionCondition
		LEFT JOIN dbo.tlbFarm AS farm
			ON farm.idfFarm = vc.idfFarm
		LEFT JOIN dbo.tlbHerd AS herd
			ON herd.idfFarm = farm.idfFarm
		LEFT JOIN dbo.tlbSpecies AS species
			ON species.idfHerd = herd.idfHerd
		WHERE (
				(m.idfsSite = @SiteID)
				OR (@SiteID IS NULL)
				)
			AND (m.idfsSampleType <> 10320001)
			AND (
				(
					@ReportSessionType = 10012001
					AND m.idfHuman IS NOT NULL
					)
				OR (
					@ReportSessionType = 10012006
					AND m.idfVectorSurveillanceSession IS NOT NULL
					)
				OR (
					@ReportSessionType = 10012005
					AND m.idfVetCase IS NOT NULL
					)
				OR (@ReportSessionType IS NULL)
				)
			AND (
				(
					(@SurveillanceTypeID = 4578940000001)
					AND (
						m.idfMonitoringSession IS NOT NULL
						OR m.idfVectorSurveillanceSession IS NOT NULL
						)
					)
				OR (
					(@SurveillanceTypeID = 50815490000000)
					AND (
						m.idfHumanCase IS NOT NULL
						OR m.idfVetCase IS NOT NULL
						OR m.idfMonitoringSession IS NOT NULL
						OR m.idfVectorSurveillanceSession IS NOT NULL
						)
					)
				OR (
					(@SurveillanceTypeID = 4578940000002)
					AND (
						m.idfHumanCase IS NOT NULL
						OR m.idfVetCase IS NOT NULL
						)
					)
				OR (@SurveillanceTypeID IS NULL)
				)
			AND (
				(m.blnAccessioned = @AccessionedIndicator)
				OR (@AccessionedIndicator IS NULL)
				)
			AND (
				(m.idfsSampleStatus IN (@SampleStatusTypeID))
				OR (@SampleStatusTypeID IS NULL)
				)
			AND (
				(m.idfSendToOffice = @OrganizationSentToID)
				OR (@OrganizationSentToID IS NULL)
				)
			AND (
				(tro.idfSendToOffice = @OrganizationTransferredToID)
				OR (@OrganizationTransferredToID IS NULL)
				)
			AND (
				(t.idfTestedByOffice = @ResultsReceivedFromID)
				OR (@ResultsReceivedFromID IS NULL)
				)
			AND (
				(
					m.datAccession BETWEEN @AccessionDateFrom
						AND @AccessionDateTo
					)
				OR (
					@AccessionDateFrom IS NULL
					OR @AccessionDateTo IS NULL
					)
				)
			AND (
				(m.idfsSampleType = @SampleTypeID)
				OR (@SampleTypeID IS NULL)
				)
			AND (
				(t.idfsTestName = @TestNameTypeID)
				OR (@TestNameTypeID IS NULL)
				)
			AND (
				(hc.idfsFinalDiagnosis = @DiseaseID)
				OR (vc.idfsFinalDiagnosis = @DiseaseID)
				OR (m.DiseaseID = @DiseaseID)
				OR (ms.idfsDiagnosis = @DiseaseID)
				OR (@DiseaseID IS NULL)
				)
			AND (
				(t.idfsTestStatus = @TestStatusTypeID)
				OR (@TestStatusTypeID IS NULL)
				)
			AND (
				(t.idfsTestResult = @TestResultTypeID)
				OR (@TestResultTypeID IS NULL)
				)
			AND (
				(species.idfsSpeciesType = @SpeciesTypeID)
				OR (@SpeciesTypeID IS NULL)
				)
			AND (
				(m.strFieldBarcode = @ExactMatchEIDSSLocalFieldSampleID)
				OR (@ExactMatchEIDSSLocalFieldSampleID IS NULL)
				)
			AND (
				(
					t.datConcludedDate BETWEEN @TestResultDateFrom
						AND @TestResultDateTo
					)
				OR (
					@TestResultDateFrom IS NULL
					OR @TestResultDateTo IS NULL
					)
				)
			AND (
				(m.strCalculatedCaseID LIKE '%' + @EIDSSReportCampaignSessionID + '%')
				OR (@EIDSSReportCampaignSessionID IS NULL)
				)
			AND (
				(m.strCalculatedHumanName LIKE '%' + @PatientName + '%')
				OR (@PatientName IS NULL)
				)
			AND (
				(m.strCalculatedHumanName LIKE '%' + @FarmOwnerName + '%')
				OR (@FarmOwnerName IS NULL)
				)
			AND (
				(c.strCampaignID LIKE '%' + @CampaignID + '%')
				OR (@CampaignID IS NULL)
				)
			AND (
				(t.idfsTestStatus = @TestStatusTypeID)
				OR (@TestStatusTypeID IS NULL)
				)
			AND (m.intRowStatus = 0)
			AND (
				(m.strFieldBarcode LIKE '%' + @EIDSSLocalFieldSampleID + '%')
				OR (
					@EIDSSLocalFieldSampleID IS NULL
					OR @EIDSSLocalFieldSampleID = ''
					)
				)
			AND (
				(tro.strBarcode LIKE '%' + @EIDSSTransferID + '%')
				OR (
					@EIDSSTransferID IS NULL
					OR @EIDSSTransferID = ''
					)
				)
			AND (
				(m.strBarcode LIKE '%' + @EIDSSLaboratorySampleID + '%')
				OR (
					@EIDSSLaboratorySampleID IS NULL
					OR @EIDSSLaboratorySampleID = ''
					)
				);
	END TRY

	BEGIN CATCH
			;

		THROW;
	END CATCH;

	SELECT @returnCode,
		@returnMsg;
END;
