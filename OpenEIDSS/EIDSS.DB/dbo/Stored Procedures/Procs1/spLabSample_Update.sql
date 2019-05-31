

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

CREATE PROCEDURE [dbo].[spLabSample_Update]
(
	@idfMaterial bigint,
	@strFieldBarcode nvarchar(200),
	@idfsSampleType bigint,
	@idfParty bigint,
	@datFieldCollectionDate datetime=NULL,
	@datFieldSentDate datetime=NULL,
	@idfFieldCollectedByOffice bigint=NULL,
	@idfFieldCollectedByPerson bigint=NULL,
	@idfSendToOffice bigint=NULL,
	@idfMainTest bigint=NULL,
	@strNote NVarchar(1000) = Null,
	@idfsBirdStatus bigint = null,
	@uidOfflineCaseID uniqueidentifier = NULL

)
AS
BEGIN

declare @status as int

select @status = intRowStatus from tlbMaterial
				 where idfMaterial=@idfMaterial
   
if @status = 1
   set @status = 0

DECLARE @idfVector bigint
SELECT @idfVector = idfVector FROM tlbVector WHERE idfVector =  @idfParty
DECLARE @idfAnimal bigint
SELECT @idfAnimal = idfAnimal FROM tlbAnimal WHERE idfAnimal =  @idfParty
DECLARE @idfSpecies bigint
SELECT @idfSpecies = idfSpecies FROM tlbSpecies WHERE idfSpecies =  @idfParty
DECLARE @idfHuman bigint
SELECT @idfHuman = idfHuman FROM tlbHuman WHERE idfHuman =  @idfParty

--There is possible the situation when cross refernece exists - @idfMainTest refer to the test that is not created yet
--In this case idfMainTest update should be done during test posting by passing @blnIsMainSampleTest = 1 to spCaseTest_Post procedure
IF NOT @idfMainTest IS NULL
BEGIN
	IF NOT EXISTS(SELECT idfTesting from tlbTesting WHERE idfTesting= @idfMainTest and intRowStatus = 0)
		SET @idfMainTest = NULL
END
UPDATE	tlbMaterial
set
		strFieldBarcode=@strFieldBarcode,
		idfsSampleType=@idfsSampleType,
		idfAnimal = ISNULL(@idfAnimal, idfAnimal),
		idfHuman = ISNULL(@idfHuman, idfHuman),
		idfSpecies = ISNULL(@idfSpecies, idfSpecies),
		[idfVector] = Isnull(@idfVector, [idfVector]),
		idfFieldCollectedByOffice=@idfFieldCollectedByOffice,
		idfFieldCollectedByPerson=@idfFieldCollectedByPerson,
		idfSendToOffice = @idfSendToOffice,
		datFieldCollectionDate=@datFieldCollectionDate,
		datFieldSentDate=@datFieldSentDate,
		idfMainTest=@idfMainTest,
		intRowStatus=@status,
		strNote = @strNote,
		idfsBirdStatus = @idfsBirdStatus,
   		strReservedAttribute = convert(nvarchar(max),@uidOfflineCaseID)

where	idfMaterial=@idfMaterial

END


