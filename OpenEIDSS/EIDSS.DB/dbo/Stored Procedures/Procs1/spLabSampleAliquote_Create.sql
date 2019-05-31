

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 02.08.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013

CREATE PROCEDURE [dbo].[spLabSampleAliquote_Create] 
	@idfMaterial bigint,
	@idfParentMaterial bigint,
	@strBarcode nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
	
	INSERT INTO tlbMaterial
	(
		idfMaterial,
		idfsSampleType,
		idfRootMaterial,
		idfParentMaterial,
		idfHuman,
		idfSpecies,
		idfAnimal,
		idfHumanCase,
		idfVetCase,
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
		datAccession,
		datEnteringDate,
		datDestructionDate,
		strBarcode,
		strNote,
		idfsSite,
		idfsCurrentSite,
		idfsSampleKind,
		idfsAccessionCondition
	)	
	SELECT
		@idfMaterial
		, idfsSampleType
		, idfRootMaterial
		, @idfParentMaterial
		, idfHuman
		, idfSpecies
		, idfAnimal
		, idfHumanCase
		, idfVetCase
		, idfMonitoringSession
		, idfFieldCollectedByPerson
		, idfFieldCollectedByOffice
		, idfMainTest
		, datFieldCollectionDate
		, datFieldSentDate
		, strFieldBarcode
		, strCalculatedCaseID
		, strCalculatedHumanName
		, idfVectorSurveillanceSession
		, idfVector
		, idfSubdivision
		, 10015007/*'cotInRepository'*/
		, idfInDepartment
		, idfDestroyedByPerson
		, GETUTCDATE()
		, datEnteringDate
		, datDestructionDate
		, @strBarcode
		, strNote
		, dbo.fnSiteID()
		, dbo.fnSiteID()
		,12675410000000 -- Aliquot
		,10108001 -- Good condition
	FROM tlbMaterial
	WHERE idfMaterial = @idfParentMaterial
	
END

