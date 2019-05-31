-- ================================================================================================
-- Name: USP_VET_DISEASE_REPORT_GETCount
--
-- Description:	Get disease list count for the farm edit/enter and other use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     12/31/2018 Initial release.
-- Stephen Long     04/24/2019 Added advanced search parameters to sync up with use case VUC10.
-- Stephen Long     04/29/2019 Added related to veterinary disease report fields for use case VUC11 
--                             and VUC12.
-- Stephen Long     05/16/2019 Added reported by and investigated by organization name.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_DISEASE_REPORT_GETCount] (
	@LanguageID NVARCHAR(50),
	@VeterinaryDiseaseReportID BIGINT = NULL,
	@MonitoringSessionID BIGINT = NULL,
	@FarmMasterID BIGINT = NULL,
	@DiseaseID BIGINT = NULL,
	@ReportStatusTypeID BIGINT = NULL,
	@RegionID BIGINT = NULL,
	@RayonID BIGINT = NULL,
	@DateEnteredFrom DATETIME = NULL,
	@DateEnteredTo DATETIME = NULL,
	@ClassificationTypeID BIGINT = NULL,
	@EIDSSReportID NVARCHAR(200) = NULL,
	@ReportTypeID BIGINT = NULL,
	@SpeciesTypeID BIGINT = NULL,
	@OutbreakCasesIndicator BIT = 0,
	@DiagnosisDateFrom DATETIME = NULL,
	@DiagnosisDateTo DATETIME = NULL,
	@InvestigationDateFrom DATETIME = NULL,
	@InvestigationDateTo DATETIME = NULL,
	@LocalOrFieldSampleID NVARCHAR(200) = NULL,
	@TotalAnimalQuantityFrom INT = NULL,
	@TotalAnimalQuantityTo INT = NULL,
	@SiteID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT COUNT(*) AS RecordCount,
			(
				SELECT COUNT(*)
				FROM dbo.tlbVetCase
				WHERE intRowStatus = 0
				) AS TotalCount
		FROM dbo.tlbVetCase vc
		INNER JOIN dbo.tlbFarm AS f
			ON f.idfFarm = vc.idfFarm
		INNER JOIN dbo.tlbFarmActual AS fa
			ON fa.idfFarmActual = f.idfFarmActual
		LEFT JOIN dbo.tlbHumanActual AS ha
			ON ha.idfHumanActual = fa.idfHumanActual
		LEFT JOIN dbo.tlbPerson AS personInvestigatedBy
			ON personInvestigatedBy.idfPerson = vc.idfPersonInvestigatedBy
				AND personInvestigatedBy.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS personEnteredBy
			ON personEnteredBy.idfPerson = vc.idfPersonEnteredBy
				AND personEnteredBy.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS personReportedBy
			ON personReportedBy.idfPerson = vc.idfPersonReportedBy
				AND personReportedBy.intRowStatus = 0
		LEFT JOIN dbo.tlbGeoLocation AS glFarm
			ON glFarm.idfGeoLocation = f.idfFarmAddress
				AND glFarm.intRowStatus = 0
		LEFT JOIN dbo.tlbMaterial AS m
			ON m.idfVetCase = vc.idfVetCase
				AND m.intRowStatus = 0
		LEFT JOIN dbo.tlbOutbreak AS o
			ON o.idfOutbreak = vc.idfOutbreak
				AND o.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000001) AS country
			ON country.idfsReference = glFarm.idfsCountry
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000002) AS rayon
			ON rayon.idfsReference = glFarm.idfsRayon
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000003) AS region
			ON region.idfsReference = glFarm.idfsRegion
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000004) AS settlement
			ON settlement.idfsReference = glFarm.idfsSettlement
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS finalDiagnosis
			ON finalDiagnosis.idfsReference = vc.idfsFinalDiagnosis
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000011) AS caseClassification
			ON caseClassification.idfsReference = vc.idfsCaseClassification
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000111) AS reportStatus
			ON reportStatus.idfsReference = vc.idfsCaseProgressStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000144) AS reportType
			ON reportType.idfsReference = vc.idfsCaseReportType
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS reportedByOrganization
			ON reportedByOrganization.idfOffice = vc.idfReportedByOffice
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS investigatedByOrganization
			ON investigatedByOrganization.idfOffice = vc.idfInvestigatedByOffice
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000012) AS caseType
			ON caseType.idfsReference = vc.idfsCaseReportType
		WHERE (vc.intRowStatus = 0)
			AND (
				(fa.idfFarmActual = @FarmMasterID)
				OR (@FarmMasterID IS NULL)
				)
			AND (
				(vc.idfVetCase = @VeterinaryDiseaseReportID)
				OR (@VeterinaryDiseaseReportID IS NULL)
				)
			AND (
				(vc.idfParentMonitoringSession = @MonitoringSessionID)
				OR (@MonitoringSessionID IS NULL)
				)
			AND (
				(glFarm.idfsRegion = @RegionID)
				OR (@RegionID IS NULL)
				)
			AND (
				(glFarm.idfsRayon = @RayonID)
				OR (@RayonID IS NULL)
				)
			AND (
				(vc.idfsFinalDiagnosis = @DiseaseID)
				OR (@DiseaseID IS NULL)
				)
			AND (
				(vc.idfsCaseClassification = @ClassificationTypeID)
				OR (@ClassificationTypeID IS NULL)
				)
			AND (
				(vc.idfsCaseProgressStatus = @ReportStatusTypeID)
				OR (@ReportStatusTypeID IS NULL)
				)
			AND (
				(
					vc.datEnteredDate BETWEEN @DateEnteredFrom
						AND @DateEnteredTo
					)
				OR (
					@DateEnteredFrom IS NULL
					OR @DateEnteredTo IS NULL
					)
				)
			AND (
				(vc.strCaseID = @EIDSSReportID)
				OR (
					@EIDSSReportID IS NULL
					OR @EIDSSReportID = ''
					)
				)
			AND (
				(vc.idfsCaseReportType = @ReportTypeID)
				OR (@ReportTypeID IS NULL)
				)
			AND (
				(vc.idfsCaseType = @SpeciesTypeID)
				OR (@SpeciesTypeID IS NULL)
				)
			AND (
				(
					vc.datFinalDiagnosisDate BETWEEN @DiagnosisDateFrom
						AND @DiagnosisDateTo
					)
				OR (
					@DiagnosisDateFrom IS NULL
					OR @DiagnosisDateTo IS NULL
					)
				)
			AND (
				(
					vc.datInvestigationDate BETWEEN @InvestigationDateFrom
						AND @InvestigationDateTo
					)
				OR (
					@InvestigationDateFrom IS NULL
					OR @InvestigationDateTo IS NULL
					)
				)
			AND (
				(
					(
						f.intAvianTotalAnimalQty BETWEEN @TotalAnimalQuantityFrom
							AND @TotalAnimalQuantityTo
						)
					OR (
						f.intLivestockTotalAnimalQty BETWEEN @TotalAnimalQuantityFrom
							AND @TotalAnimalQuantityTo
						)
					)
				OR (
					@TotalAnimalQuantityFrom IS NULL
					OR @TotalAnimalQuantityTo IS NULL
					)
				)
			AND (
				(vc.idfsSite = @SiteID)
				OR (@SiteID IS NULL)
				)
			AND (
				(
					vc.idfOutbreak IS NULL
					AND @OutbreakCasesIndicator = 0
					)
				OR (
					vc.idfOutbreak IS NOT NULL
					AND @OutbreakCasesIndicator = 1
					)
				OR (@OutbreakCasesIndicator IS NULL)
				)
			AND (
				(m.strFieldBarcode LIKE '%' + @LocalOrFieldSampleID + '%')
				OR (@LocalOrFieldSampleID IS NULL)
				);
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END;