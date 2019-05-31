

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 14.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 02.08.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013

CREATE PROCEDURE [dbo].[spLabSampleDerivative_Create]
	@idfMaterial bigint,
	@idfParentMaterial bigint,
	@idfsSampleType bigint,
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
		, @idfsSampleType
		, idfRootMaterial
		, idfMaterial
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
		, 10015007--inRepository
		, idfInDepartment
		, idfDestroyedByPerson
		, GETUTCDATE()
		, datEnteringDate
		, datDestructionDate
		, @strBarcode
		, strNote
		, dbo.fnSiteID()
		, dbo.fnSiteID()
		,12675420000000 --Derivative
		,10108001 -- Good condition
	FROM tlbMaterial
	WHERE idfMaterial = @idfParentMaterial
	
END

