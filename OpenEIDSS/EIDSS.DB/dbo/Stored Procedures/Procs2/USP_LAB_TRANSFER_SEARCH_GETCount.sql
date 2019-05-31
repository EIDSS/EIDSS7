

-- ================================================================================================
-- Name: USP_LAB_TRANSFER_SEARCH_GETCount
--
-- Description:	Get laboratory transfer count for the various laboratory use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     02/21/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_TRANSFER_SEARCH_GETCount] (
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

		SELECT DISTINCT COUNT(*) AS RecordCount
		FROM dbo.tlbMaterial m
		LEFT JOIN dbo.tlbTesting AS t
			ON t.idfMaterial = m.idfMaterial
		LEFT JOIN dbo.tlbBatchTest AS bt
			ON bt.idfBatchTest = t.idfBatchTest
		LEFT JOIN dbo.tlbMaterial AS parentSample
			ON parentSample.idfMaterial = m.idfParentMaterial
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
		LEFT JOIN dbo.tlbTransferOUT AS tr
			ON tr.idfTransferOut = tom.idfTransferOut
		LEFT JOIN dbo.tlbFreezerSubdivision AS fs
			ON fs.idfSubdivision = m.idfSubdivision
		LEFT JOIN dbo.tlbPerson AS fieldCollectedByPerson
			ON fieldCollectedByPerson.idfPerson = m.idfFieldCollectedByPerson
		LEFT JOIN dbo.tlbOffice AS fieldCollectedByOffice
			ON fieldCollectedByOffice.idfOffice = m.idfFieldCollectedByOffice
		LEFT JOIN dbo.tstSite AS fieldCollectedByOfficeSite
			ON fieldCollectedByOfficeSite.idfsSite = fieldCollectedByOffice.idfsSite
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS transferredToOrganization
			ON transferredToOrganization.idfOffice = tr.idfSendToOffice
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS transferredFromOrganization
			ON transferredFromOrganization.idfOffice = tr.idfSendFromOffice
		LEFT JOIN dbo.tlbPerson AS sentByPerson
			ON sentByPerson.idfPerson = tr.idfSendByPerson
		LEFT JOIN dbo.tstSite AS currentSite
			ON currentSite.idfsSite = m.idfsCurrentSite
		LEFT JOIN dbo.tlbDepartment AS d
			ON d.idfDepartment = m.idfInDepartment
		LEFT JOIN dbo.tstSite AS materialSite
			ON materialSite.idfsSite = m.idfsSite
		LEFT JOIN dbo.tlbPerson AS destroyedByPerson
			ON destroyedByPerson.idfPerson = m.idfDestroyedByPerson
		LEFT JOIN dbo.tlbPerson AS accessionByPerson
			ON accessionByPerson.idfPerson = m.idfAccesionByPerson
		LEFT JOIN dbo.tlbPerson AS markedForDispositionByPerson
			ON markedForDispositionByPerson.idfPerson = m.idfMarkedForDispositionByPerson
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000164) AS functionalArea
			ON functionalArea.idfsReference = d.idfsDepartmentName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = m.idfsSampleType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000015) AS sampleStatusType
			ON sampleStatusType.idfsReference = m.idfsSampleStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000110) AS accessionConditionType
			ON accessionConditionType.idfsReference = m.idfsAccessionCondition
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000097) AS testNameType
			ON testNameType.idfsReference = t.idfsTestName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000096) AS testResultType
			ON testResultType.idfsReference = t.idfsTestResult
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000157) AS destructionMethodType
			ON destructionMethodType.idfsReference = m.idfsDestructionMethod
		LEFT JOIN dbo.tlbFarm AS farm
			ON farm.idfFarm = vc.idfFarm
		LEFT JOIN dbo.tlbHerd AS herd
			ON herd.idfFarm = farm.idfFarm
		LEFT JOIN dbo.tlbSpecies AS species
			ON species.idfHerd = herd.idfHerd
		WHERE (m.intRowStatus = 0)
			AND ((m.idfSendToOffice = @OrganizationID OR tr.idfSendFromOffice = @OrganizationID OR tr.idfSendToOffice = @OrganizationID) OR (@OrganizationID IS NULL))
			AND (m.idfsSampleType <> 10320001)
			AND (m.strBarcode LIKE '%' + @SearchString + '%'
			OR m.strFieldBarcode LIKE '%' + @SearchString + '%'
			OR m.strCalculatedCaseID LIKE '%' + @SearchString + '%'
			OR m.strCalculatedHumanName LIKE '%' + @SearchString + '%'
			OR m.strNote LIKE '%' + @SearchString + '%'
			OR tr.strBarcode LIKE '%' + @SearchString + '%');
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END;