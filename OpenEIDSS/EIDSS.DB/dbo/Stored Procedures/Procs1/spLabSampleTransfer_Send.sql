

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

CREATE PROCEDURE [dbo].[spLabSampleTransfer_Send]
	@idfMaterial bigint,
	@idfSendToOffice bigint,
	@datSendDate datetime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @barcode nvarchar(200)
	declare @test bigint

	select		top 1
				@test=tlbTesting.idfTesting,
				@barcode=tlbMaterial.strBarcode
	from		tlbTesting
	INNER JOIN	tlbMaterial
	ON			tlbMaterial.idfMaterial = tlbTesting.idfMaterial
				AND tlbMaterial.intRowStatus = 0
	where		tlbTesting.idfMaterial=@idfMaterial and
				tlbTesting.intRowStatus=0 and
				tlbTesting.idfsTestStatus=10001003

	if @test is not null
	begin
			    RAISERROR ('errContainerTransfer %s', 16, 1, @barcode)
	end

	UPDATE	tlbMaterial
	SET		idfsSampleStatus=10015010,--cotOutOfRepository
			datOutOfRepositoryDate = @datSendDate,
			idfSubdivision=null
	WHERE	idfMaterial=@idfMaterial

	--create unaccessioned copy of material for transfer in
	if(EXISTS (SELECT * FROM tstSite s INNER JOIN tlbOffice o ON s.idfOffice = o.idfOffice WHERE o.idfOffice = @idfSendToOffice and o.intRowStatus = 0 and s.intRowStatus = 0))
	BEGIN
		declare 	@idfMaterialNew bigint
		exec spsysGetNewID @idfMaterialNew out

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
			datEnteringDate,
			datDestructionDate,
			strBarcode,
			idfsSite,
			datAccession,
			idfsAccessionCondition,
			strCondition,
			idfsCurrentSite,
			idfsSampleKind,
			idfAccesionByPerson,
			idfSendToOffice

		)
		SELECT
			@idfMaterialNew, 
			tm.idfsSampleType, 
			tm.idfRootMaterial,
			@idfMaterial, 
			tm.idfHuman, 
			tm.idfSpecies, 
			tm.idfAnimal, 
			tm.idfHumanCase,
			tm.idfVetCase,
			tm.idfMonitoringSession, 
			tm.idfFieldCollectedByPerson,
			tm.idfFieldCollectedByOffice, 
			tm.idfMainTest, 
			tm.datFieldCollectionDate,
			tm.datFieldSentDate, 
			tm.strFieldBarcode, 
			tm.strCalculatedCaseID,
			tm.strCalculatedHumanName, 
			tm.idfVectorSurveillanceSession, 
			tm.idfVector,
			NULL, --tm.idfSubdivision, 
			NULL, 
			NULL, --idfInDepartment,
			tm.idfDestroyedByPerson, 
			tm.datEnteringDate,
			tm.datDestructionDate, 
			NULL, --strBarcode, 
			tm.idfsSite,
			NULL, --datAccession,
			NULL, --@idfsAccessionCondition,
			NULL --@strCondition
			,NULL --dbo.fnSiteID()
			,12675430000000 --TransferredIn
			,NULL--@idfReceivedByPerson
			,@idfSendToOffice
		FROM tlbMaterial tm
		WHERE tm.idfMaterial = @idfMaterial
	END
	
END

