
-- ============================================================================
-- Name: USSP_GBL_MATERIAL_SET
-- Description:	Inserts or updates material records for various use cases.
--
-- Author: Stephen Long
-- Revision History:
-- Name  Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/02/2018 Initial release.
-- Harold Pryor     12/06/2018 Removed updating Primary Key column for tlbMaterial update.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_GBL_MATERIAL_SET]
(
	@LangID								NVARCHAR(50), 
	@idfMaterial						BIGINT , 
	@idfsSampleType						BIGINT = NULL, 
	@idfRootMaterial					BIGINT = NULL, 
	@idfParentMaterial					BIGINT = NULL, 
	@idfHuman							BIGINT = NULL, 
	@idfSpecies							BIGINT = NULL, 
	@idfAnimal							BIGINT = NULL, 
	@idfMonitoringSession				BIGINT = NULL, 
	@idfFieldCollectedByPerson			BIGINT = NULL, 
	@idfFieldCollectedByOffice			BIGINT = NULL, 
	@idfMainTest						BIGINT = NULL, 
	@datFieldCollectionDate				DATETIME = NULL, 
	@datFieldSentDate					DATETIME = NULL, 
	@strFieldBarcode					NVARCHAR(200) = NULL, 
	@strCalculatedCaseID				NVARCHAR(200) = NULL, 
	@strCalculatedHumanName				NVARCHAR(700) = NULL, 
	@idfVectorSurveillanceSession       BIGINT = NULL, 
	@idfVector							BIGINT = NULL, 
	@idfSubdivision						BIGINT = NULL, 
	@idfsSampleStatus					BIGINT = NULL, 
	@idfInDepartment					BIGINT = NULL, 
	@idfDestroyedByPerson				BIGINT = NULL, 
	@datEnteringDate					DATETIME = NULL, 
	@datDestructionDate					DATETIME = NULL, 
	@strBarcode							NVARCHAR(200) = NULL, 
	@strNote							NVARCHAR(500) = NULL, 
	@idfsSite							BIGINT = NULL, 
	@intRowStatus						INT, 
	@idfSendToOffice					BIGINT = NULL, 
	@blnReadOnly						BIT = NULL, 
	@idfsBirdStatus						BIGINT = NULL, 
	@idfHumanCase						BIGINT = NULL, 
	@idfVetCase							BIGINT = NULL, 
	@datAccession						DATETIME = NULL, 
	@idfsAccessionCondition				BIGINT = NULL, 
	@strCondition						NVARCHAR(200) = NULL, 
	@idfAccesionByPerson				BIGINT = NULL, 
	@idfsDestructionMethod				BIGINT = NULL, 
	@idfsCurrentSite					BIGINT = NULL, 
	@idfsSampleKind						BIGINT = NULL, 
	@idfMarkedForDispositionByPerson	BIGINT = NULL, 
	@datOutOfRepositoryDate				DATETIME = NULL, 
	@strMaintenanceFlag					NVARCHAR(20) = NULL, 
	@RecordAction						NCHAR(1) 
)
AS

DECLARE @returnCode						INT = 0;
DECLARE	@returnMsg						NVARCHAR(MAX) = 'SUCCESS';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
		IF @RecordAction = 'I' 
			BEGIN
			EXEC						dbo.USP_GBL_NEXTKEYID_GET 'tlbMaterial', @idfMaterial OUTPUT;

			--Local/field sample ID.  Only system assign when user leaves blank.
			IF							@strFieldBarcode IS NULL 
			BEGIN
				EXEC					dbo.USP_GBL_NextNumber_GET 10057019, @strFieldBarcode OUTPUT, NULL 
			END 

			INSERT INTO					dbo.tlbMaterial
			(						
										idfMaterial, 
										idfsSampleType, 
										idfRootMaterial, 
										idfParentMaterial, 
										idfHuman, 
										idfSpecies, 
										idfAnimal, 
										idfMonitoringSession, 
										idfFieldCollectedByPerson, 
										idfFieldCollectedByOffice, 
										idfMainTest, 
										datFieldCollectionDate, 
										datFieldSentDate, 
										strFieldBarcode, 
										strCalculatedCaseID, 
										strCalculatedHumanName, 
										idfVectorSurveillanceSession, 
										idfVector, 
										idfSubdivision, 
										idfsSampleStatus, 
										idfInDepartment, 
										idfDestroyedByPerson, 
										datEnteringDate, 
										datDestructionDate, 
										strBarcode, 
										strNote, 
										idfsSite, 
										intRowStatus, 
										idfSendToOffice, 
										blnReadOnly, 
										idfsBirdStatus, 
										idfHumanCase, 
										idfVetCase, 
										datAccession, 
										idfsAccessionCondition, 
										strCondition, 
										idfAccesionByPerson, 
										idfsDestructionMethod, 
										idfsCurrentSite, 
										idfsSampleKind, 
										idfMarkedForDispositionByPerson, 
										datOutOfRepositoryDate, 
										strMaintenanceFlag 
			)
			VALUES
			(
										@idfMaterial, 
										@idfsSampleType, 
										@idfRootMaterial, 
										@idfParentMaterial, 
										@idfHuman, 
										@idfSpecies, 
										@idfAnimal, 
										@idfMonitoringSession, 
										@idfFieldCollectedByPerson, 
										@idfFieldCollectedByOffice, 
										@idfMainTest, 
										@datFieldCollectionDate, 
										@datFieldSentDate, 
										@strFieldBarcode, 
										@strCalculatedCaseID, 
										@strCalculatedHumanName, 
										@idfVectorSurveillanceSession, 
										@idfVector, 
										@idfSubdivision, 
										@idfsSampleStatus, 
										@idfInDepartment, 
										@idfDestroyedByPerson, 
										@datEnteringDate, 
										@datDestructionDate, 
										@strBarcode, 
										@strNote, 
										@idfsSite, 
										@intRowStatus, 
										@idfSendToOffice, 
										@blnReadOnly, 
										@idfsBirdStatus, 
										@idfHumanCase, 
										@idfVetCase, 
										@datAccession, 
										@idfsAccessionCondition, 
										@strCondition, 
										@idfAccesionByPerson, 
										@idfsDestructionMethod, 
										@idfsCurrentSite, 
										@idfsSampleKind, 
										@idfMarkedForDispositionByPerson, 
										@datOutOfRepositoryDate, 
										@strMaintenanceFlag 
			);
			END
		ELSE
			BEGIN

			--Sample is being accessioned, so get the next lab barcode allowing the user the option to print the barcode.
			IF @RecordAction = 'A'
			BEGIN
				EXEC					dbo.USP_GBL_NextNumber_GET 10057020, @strBarcode OUTPUT, NULL
			END

			UPDATE						dbo.tlbMaterial
			SET 										
										idfsSampleType = @idfsSampleType, 
										idfRootMaterial = @idfRootMaterial, 
										idfParentMaterial = @idfParentMaterial, 
										idfHuman = @idfHuman, 
										idfSpecies = @idfSpecies, 
										idfAnimal = @idfAnimal, 
										idfMonitoringSession = @idfMonitoringSession, 
										idfFieldCollectedByPerson = @idfFieldCollectedByPerson, 
										idfFieldCollectedByOffice = @idfFieldCollectedByOffice, 
										idfMainTest = @idfMainTest, 
										datFieldCollectionDate = @datFieldCollectionDate, 
										datFieldSentDate = @datFieldSentDate, 
										strFieldBarcode = @strFieldBarcode, 
										strCalculatedCaseID = @strCalculatedCaseID, 
										strCalculatedHumanName = @strCalculatedHumanName,
										idfVectorSurveillanceSession = @idfVectorSurveillanceSession, 
										idfVector = @idfVector, 
										idfSubdivision = @idfSubdivision, 
										idfsSampleStatus = @idfsSampleStatus, 
										idfInDepartment = @idfInDepartment, 
										idfDestroyedByPerson = @idfDestroyedByPerson, 
										datEnteringDate = @datEnteringDate, 
										datDestructionDate = @datDestructionDate, 
										strBarcode = @strBarcode, 
										strNote = @strNote,
										idfsSite = @idfsSite, 
										intRowStatus = @intRowStatus,
										idfSendToOffice = @idfSendToOffice, 
										blnReadOnly = @blnReadOnly,
										idfsBirdStatus = @idfsBirdStatus, 
										idfHumanCase = @idfHumanCase, 
										idfVetCase = @idfVetCase, 
										datAccession = @datAccession, 
										idfsAccessionCondition = @idfsAccessionCondition, 
										strCondition = @strCondition, 
										idfAccesionByPerson = @idfAccesionByPerson, 
										idfsDestructionMethod = @idfsDestructionMethod, 
										idfsCurrentSite = @idfsCurrentSite, 
										idfsSampleKind = @idfsSampleKind, 
										idfMarkedForDispositionByPerson = @idfMarkedForDispositionByPerson, 
										datOutOfRepositoryDate = @datOutOfRepositoryDate, 
										strMaintenanceFlag = @strMaintenanceFlag 
			WHERE						idfMaterial = @idfMaterial;
			END

		SELECT							@returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfMaterial 'idfMaterial',@strBarcode 'strBarcode'
	END TRY
	BEGIN CATCH
		THROW;

	END CATCH
END
