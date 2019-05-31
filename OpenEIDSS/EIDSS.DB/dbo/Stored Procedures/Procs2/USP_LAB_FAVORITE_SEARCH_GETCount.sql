

-- ================================================================================================
-- Name: USP_LAB_FAVORITE_SEARCH_GETCount
--
-- Description:	Get laboratory favorites count for the various laboratory use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     02/20/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_FAVORITE_SEARCH_GETCount] (
	@LanguageID NVARCHAR(50),
	@OrganizationID BIGINT = NULL, 
	@SearchString NVARCHAR(2000) = NULL
	)
AS
BEGIN
    DECLARE @returnCode				INT = 0;
    DECLARE @returnMsg				NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		SELECT COUNT(*) AS RecordCount
		FROM dbo.tlbMaterial m
		LEFT JOIN dbo.tlbTesting AS t
			ON t.idfMaterial = m.idfMaterial
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
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000015) AS sampleStatus
			ON sampleStatus.idfsReference = m.idfsSampleStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000110) AS accessionCondition
			ON accessionCondition.idfsReference = m.idfsAccessionCondition
		LEFT JOIN dbo.tlbFarm AS farm
			ON farm.idfFarm = vc.idfFarm
		LEFT JOIN dbo.tlbHerd AS herd
			ON herd.idfFarm = farm.idfFarm
		LEFT JOIN dbo.tlbSpecies AS species
			ON species.idfHerd = herd.idfHerd
		WHERE (m.intRowStatus = 0) 
			AND ((m.idfSendToOffice = @OrganizationID OR tro.idfSendFromOffice = @OrganizationID OR tro.idfSendToOffice = @OrganizationID) OR (@OrganizationID IS NULL))
			AND (m.idfsSampleType <> 10320001)
			AND m.strBarcode LIKE @SearchString + '%'
			OR m.strFieldBarcode LIKE @SearchString + '%'
			OR m.strCalculatedCaseID LIKE @SearchString + '%'
			OR m.strCalculatedHumanName LIKE @SearchString + '%'
			OR m.strNote LIKE @SearchString + '%'
			OR tro.strBarcode LIKE @SearchString + '%'
			OR hdrDisease.name LIKE @SearchString + '%'
			OR vdrDisease.name LIKE @SearchString + '%'
			OR sampleDisease.name LIKE @SearchString + '%'
			OR msDisease.name LIKE @SearchString + '%'
			OR sampleType.name LIKE @SearchString + '%'
			OR accessionCondition.name LIKE @SearchString + '%'
			OR sampleStatus.name LIKE @SearchString + '%'
			OR functionalArea.name LIKE @SearchString + '%';
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END