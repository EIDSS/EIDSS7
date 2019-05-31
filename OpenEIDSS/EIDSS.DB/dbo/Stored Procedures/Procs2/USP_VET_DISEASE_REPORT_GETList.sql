-- ================================================================================================
-- Name: USP_VET_DISEASE_REPORT_GETList
--
-- Description:	Get disease list for the farm edit/enter and other use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     03/25/2018 Initial release.
-- Stephen Long     11/09/2018 Added FarmOwnerID and FarmOwnerName for lab use case 10.
-- Stephen Long     11/25/2018 Updated for the new API.
-- Stephen Long     12/31/2018 Added pagination logic.
-- Stephen Long     04/24/2019 Added advanced search parameters to sync up with use case VUC10.
-- Stephen Long     04/29/2019 Added related to veterinary disease report fields for use case VUC11 
--                             and VUC12.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_DISEASE_REPORT_GETList] (
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
	@SiteID BIGINT = NULL,
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT vc.idfVetCase AS VeterinaryDiseaseReportID,
			vc.datReportDate AS ReportDate,
			vc.datInvestigationDate AS InvestigationDate,
			vc.datEnteredDate AS EnteredDate,
			vc.idfsFinalDiagnosis AS DiseaseID,
			finalDiagnosis.name AS DiseaseName,
			vc.datFinalDiagnosisDate AS FinalDiagnosisDate,
			vc.idfsCaseProgressStatus AS ReportStatusTypeID,
			reportStatus.name AS ReportStatusTypeName,
			vc.idfsCaseReportType AS ReportTypeID,
			reportType.name AS ReportTypeName,
			vc.idfsCaseType AS SpeciesTypeID,
			caseType.name AS SpeciesTypeName,
			region.idfsReference AS RegionID,
			region.name AS RegionName,
			rayon.idfsReference AS RayonID,
			rayon.name AS RayonName,
			vc.idfsCaseClassification AS ClassificationTypeID,
			caseClassification.name AS ClassificationTypeName,
			vc.idfPersonInvestigatedBy AS PersonInvestigatedByID,
			ISNULL(personInvestigatedBy.strFamilyName, N'') + ISNULL(', ' + personInvestigatedBy.strFirstName, '') + ISNULL(' ' + personInvestigatedBy.strSecondName, '') AS PersonInvestigatedByName,
			vc.idfPersonEnteredBy AS PersonEnteredByID,
			ISNULL(personEnteredBy.strFamilyName, N'') + ISNULL(', ' + personEnteredBy.strFirstName, '') + ISNULL(' ' + personEnteredBy.strSecondName, '') AS PersonEnteredByName,
			vc.idfPersonReportedBy AS PersonReportedByID,
			ISNULL(personReportedBy.strFamilyName, N'') + ISNULL(', ' + personReportedBy.strFirstName, '') + ISNULL(' ' + personReportedBy.strSecondName, '') AS PersonReportedByName,
			vc.strCaseID AS EIDSSReportID,
			f.idfFarmActual AS FarmMasterID,
			f.idfFarm AS FarmID,
			f.strNationalName AS FarmName,
			(
				IIF(glFarm.strForeignAddress IS NULL, (
						(
							CASE 
								WHEN glFarm.strStreetName IS NULL
									THEN ''
								WHEN glFarm.strStreetName = ''
									THEN ''
								ELSE glFarm.strStreetName
								END
							) + IIF(glFarm.strBuilding = '', '', ', Bld ' + glFarm.strBuilding) + IIF(glFarm.strApartment = '', '', ', Apt ' + glFarm.strApartment) + IIF(glFarm.strHouse = '', '', ', ' + glFarm.strHouse) + IIF(glFarm.idfsSettlement IS NULL, '', ', ' + settlement.name) + (
							CASE 
								WHEN glFarm.strPostCode IS NULL
									THEN ''
								WHEN glFarm.strPostCode = ''
									THEN ''
								ELSE ', ' + glFarm.strPostCode
								END
							) + IIF(glFarm.idfsRayon IS NULL, '', ', ' + rayon.name) + IIF(glFarm.idfsRegion IS NULL, '', ', ' + region.name) + IIF(glFarm.idfsCountry IS NULL, '', ', ' + country.name)
						), glFarm.strForeignAddress)
				) AS FormattedFarmAddressString,
			(
				CASE 
					WHEN vc.idfsCaseType = '10012003'
						THEN IIF(f.intLivestockSickAnimalQty IS NULL, '0', f.intLivestockSickAnimalQty)
					ELSE IIF(f.intAvianSickAnimalQty IS NULL, '0', f.intAvianSickAnimalQty)
					END
				) AS TotalSickAnimalQuantity,
			(
				CASE 
					WHEN vc.idfsCaseType = '10012003'
						THEN IIF(f.intLivestockTotalAnimalQty IS NULL, '0', f.intLivestockTotalAnimalQty)
					ELSE IIF(f.intAvianTotalAnimalQty IS NULL, '0', f.intAvianTotalAnimalQty)
					END
				) AS TotalAnimalQuantity,
			(
				CASE 
					WHEN vc.idfsCaseType = '10012003'
						THEN IIF(f.intLivestockDeadAnimalQty IS NULL, '0', f.intLivestockDeadAnimalQty)
					ELSE IIF(f.intAvianDeadAnimalQty IS NULL, '0', f.intAvianDeadAnimalQty)
					END
				) AS TotalDeadAnimalQuantity,
			SpeciesList = STUFF((
					SELECT ', ' + speciesType.name
					FROM dbo.tlbSpecies s
					INNER JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
						ON speciesType.idfsReference = s.idfsSpeciesType
					INNER JOIN dbo.tlbHerd AS h
						ON h.idfHerd = s.idfHerd
					INNER JOIN dbo.tlbFarm AS f2
						ON h.idfFarm = f2.idfFarm
					WHERE f2.idfFarm = f.idfFarm
					GROUP BY speciesType.name
					FOR XML PATH(''),
						TYPE
					).value('.[1]', 'NVARCHAR(MAX)'), 1, 2, ''),
			h.idfHumanActual AS FarmOwnerID,
			ISNULL(h.strLastName, N'') + ISNULL(', ' + h.strFirstName, '') + ISNULL(' ' + h.strSecondName, '') AS FarmOwnerName,
			vc.idfOutbreak AS OutbreakID,
			o.strOutbreakID AS EIDSSOutbreakID
		FROM dbo.tlbVetCase vc
		INNER JOIN dbo.tlbFarm AS f
			ON f.idfFarm = vc.idfFarm
		INNER JOIN dbo.tlbFarmActual AS fa
			ON fa.idfFarmActual = f.idfFarmActual
		LEFT JOIN dbo.tlbHuman AS h
			ON h.idfHuman = f.idfHuman
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
				(vc.strCaseID LIKE '%' + @EIDSSReportID + '%')
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
				)
		ORDER BY vc.strCaseID, DiseaseName, EnteredDate, ReportStatusTypeName OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

		FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END;
