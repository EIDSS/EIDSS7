

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 14.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013


CREATE PROCEDURE [dbo].[spLabSample_Create]
(
	@idfMaterial bigint OUTPUT,
	@strFieldBarcode nvarchar(200),
	@idfsSampleType bigint,
	@idfParty bigint,
	@idfCase bigint = null,	
	@idfMonitoringSession bigint=NULL,
	@idfVectorSurveillanceSession bigint=NULL,	
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

if @idfsSampleType is null return -1

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

DECLARE @datRegistrationDate as datetime
SET @datRegistrationDate =GETDATE()
DECLARE @idfHuman bigint
DECLARE @idfSpecies bigint
DECLARE @idfAnimal bigint
DECLARE @idfVector bigint
SELECT @idfHuman = idfHuman FROM tlbHuman WHERE idfHuman =  @idfParty
SELECT @idfSpecies = idfSpecies FROM tlbSpecies WHERE idfSpecies =  @idfParty
SELECT @idfAnimal = idfAnimal FROM tlbAnimal WHERE idfAnimal =  @idfParty
SELECT @idfVector = idfVector FROM tlbVector WHERE idfVector =  @idfParty

--DECLARE @NextNumberValue nvarchar(200)
--exec spGetNextNumber 'nbtSampleNumber', @NextNumberValue OUTPUT, NULL
IF (@idfMaterial IS NULL) OR @idfMaterial <=0 OR EXISTS (SELECT idfMaterial FROM tlbMaterial WHERE idfMaterial = @idfMaterial)
BEGIN
	EXEC spsysGetNewID @idfMaterial OUTPUT
END	
--There is possible the situation when cross refernece exists - @idfMainTest refer to the test that is not created yet
--In this case idfMainTest update should be done during test posting by passing @blnIsMainSampleTest = 1 to spCaseTest_Post procedure
IF NOT @idfMainTest IS NULL
BEGIN
	IF NOT EXISTS(SELECT idfTesting from tlbTesting WHERE idfTesting= @idfMainTest and intRowStatus = 0)
		SET @idfMainTest = NULL
END

DECLARE @idfHumanCase BIGINT 
DECLARE @idfVetCase BIGINT 

SELECT @idfHumanCase = idfHumanCase FROM tlbHumanCase WHERE idfHumanCase = @idfCase
SELECT @idfVetCase = idfVetCase FROM tlbVetCase WHERE idfVetCase = @idfCase

-- insert Material
INSERT INTO	tlbMaterial(
				idfMaterial,
				idfParentMaterial,
				idfRootMaterial,
				strFieldBarcode,
				idfsSampleType,
				idfHumanCase,
				idfVetCase,
				idfMonitoringSession,
				idfVectorSurveillanceSession,
				idfHuman,
				idfSpecies,
				idfAnimal,
				idfVector,
				idfFieldCollectedByOffice,
				idfFieldCollectedByPerson,
				idfSendToOffice,
				datFieldCollectionDate,
				datFieldSentDate,
				idfMainTest,
				strNote,
				idfsBirdStatus,
				strReservedAttribute)
VALUES		(
				@idfMaterial,
				null,
				@idfMaterial,
				@strFieldBarcode,
				@idfsSampleType,
				@idfHumanCase,
				@idfVetCase,
				@idfMonitoringSession,
				@idfVectorSurveillanceSession,
				@idfHuman,
				@idfSpecies,
				@idfAnimal,
				@idfVector,
				@idfFieldCollectedByOffice,
				@idfFieldCollectedByPerson,
				@idfSendToOffice,
				@datFieldCollectionDate,
				@datFieldSentDate,
				@idfMainTest,
				@strNote,
				@idfsBirdStatus,
				convert(nvarchar(max),@uidOfflineCaseID)
)

END


