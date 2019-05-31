

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 03.08.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

CREATE PROCEDURE [dbo].[spLabSampleReceive_PostDetail]
	@idfMaterial bigint,
	@strBarcode nvarchar(200),
	@datAccession datetime,
	@strCondition nvarchar(200),
	@idfsAccessionCondition bigint,
	@strNote nvarchar(200),
	@idfSubdivision bigint,
	@idfDepartment bigint,
	@idfAccesionByPerson bigint,
	
	@idfsSampleType bigint=NULL,
	@strFieldBarcode nvarchar(200)=NULL,
	@idfParty bigint=NULL,
	@idfCase bigint=NULL,
	@idfMonitoringSession bigint=NULL,
	@idfVectorSurveillanceSession bigint=NULL,
	@datFieldCollectionDate datetime=NULL,
	@datFieldSentDate datetime=NULL,
	@idfFieldCollectedByOffice bigint=NULL,
	@idfFieldCollectedByPerson bigint=NULL,
	@idfMainTest bigint=NULL,
	@idfSendToOffice bigint=NULL

AS
BEGIN
	SET NOCOUNT ON;
	
	if @idfMaterial is null return -1;

	if not exists(select idfMaterial from tlbMaterial where idfMaterial = @idfMaterial)
	BEGIN
		exec spLabSample_Create
			@idfMaterial = @idfMaterial,
			@strFieldBarcode= @strFieldBarcode,
			@idfsSampleType = @idfsSampleType,
			@idfParty = @idfParty,
			@idfCase = @idfCase,
			@idfMonitoringSession = @idfMonitoringSession,
			@idfVectorSurveillanceSession = @idfVectorSurveillanceSession,
			@datFieldCollectionDate = @datFieldCollectionDate,
			@datFieldSentDate = @datFieldSentDate,
			@idfFieldCollectedByOffice = @idfFieldCollectedByOffice,
			@idfFieldCollectedByPerson = @idfFieldCollectedByPerson,
			@idfSendToOffice = @idfSendToOffice,
			@idfMainTest = @idfMainTest
			
			
		update tlbHumanCase
		set idfsYNSpecimenCollected = 10100001
		where idfHumanCase = @idfCase
	END

						
		UPDATE tlbMaterial
		SET strBarcode = @strBarcode,
			strNote = @strNote,
			idfsSampleStatus = 10015007,--'cotInRepository',
			idfSubdivision = @idfSubdivision,
			idfInDepartment = @idfDepartment
			,strCondition = @strCondition
			, idfsAccessionCondition = @idfsAccessionCondition
			, idfAccesionByPerson = @idfAccesionByPerson
			, datAccession = @datAccession
			,idfsCurrentSite = dbo.fnSiteID()
		WHERE idfMaterial = @idfMaterial

	IF @idfsAccessionCondition=10108001 or @idfsAccessionCondition=10108002 --accepted in Good Condition or accepter in Poor Condition
	BEGIN
		exec spLabSample_Store @idfSubdivision=@idfSubdivision,@idfMaterial=@idfMaterial
	END
END

