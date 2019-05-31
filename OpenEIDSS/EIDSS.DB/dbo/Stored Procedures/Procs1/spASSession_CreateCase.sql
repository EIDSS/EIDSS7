


 

--##SUMMARY Creates case for specified farm in monitoring session
--##SUMMARY During case creation it 
--##SUMMARY 1. Creates case itslef
--##SUMMARY 2. Links farm (including farm structure tree) to the case
--##SUMMARY 3. Links Animals/samples/tests with positive result to the case
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 02.08.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 28.07.2011


--##RETURNS 0 - if case is created successfully
--##RETURNS 1 - source farm doesn't exists
--##RETURNS 2 - case is already created for this farm and monitoring session
/*
--Example of a call of procedure:
DECLARE @idfFarm bigint

EXECUTE spASSession_CreateCase 
	@idfFarm
	,@idfCase OUTPUT
Print @idfCase
*/

CREATE            Proc	[dbo].[spASSession_CreateCase]
		@idfFarm bigint
		,@idfPersonEnteredBy bigint
		,@CasesList varchar(4000) OUTPUT
As
DECLARE @idfMonitoringSession bigint
SELECT @idfMonitoringSession = idfMonitoringSession from tlbFarm 
		WHERE idfFarm = @idfFarm and intRowStatus = 0
IF @@ROWCOUNT=0
	return 1 --Farm doesn't exist
IF @idfMonitoringSession IS NULL
	return 2 -- farm is not related with monitoring session

IF NOT EXISTS (SELECT Top 1 tlbAnimal.idfAnimal From tlbAnimal
				Inner Join tlbMaterial ON 
					tlbMaterial.idfAnimal = tlbAnimal.idfAnimal and tlbMaterial.intRowStatus=0
				Inner Join tlbTesting ON
					tlbTesting.idfMaterial = tlbMaterial.idfMaterial and tlbTesting.intRowStatus=0
				Inner Join tlbTestValidation on 
					tlbTestValidation.idfTesting = tlbTesting.idfTesting and tlbTestValidation.intRowStatus=0
				INNER JOIN tlbSpecies ON 
					tlbSpecies.idfSpecies = tlbAnimal.idfSpecies and
					tlbSpecies.intRowStatus=0
				Inner join tlbHerd on 
					tlbSpecies.idfHerd = tlbHerd.idfHerd and
					tlbHerd.intRowStatus=0
				WHERE tlbHerd.idfFarm = @idfFarm 
					and tlbTestValidation.idfsInterpretedStatus = 10104001
					and ISNULL(tlbTestValidation.blnCaseCreated,0) <>1
					and tlbAnimal.intRowStatus=0
				)
	return 3 --farm has no positive test results

DECLARE @idfCase AS bigint
DECLARE @currentDiagnosis AS BIGINT
DECLARE @idfAnimal AS BIGINT
DECLARE @idfTestValidation AS BIGINT
DECLARE @blnCaseCreated AS BIT
DECLARE @idfsDiagnosis AS BIGINT
DECLARE @idfsCountry AS BIGINT
DECLARE @idfsAnimalCSTemplate AS BIGINT
DECLARE @idfsContolMeasureTemplate AS BIGINT
DECLARE @idfsFarmEPITemplate AS BIGINT
DECLARE @idfsSpeciesCSTemplate AS BIGINT
SET @currentDiagnosis = -1

DECLARE crAnimal CURSOR  LOCAL FORWARD_ONLY STATIC FOR
SELECT DISTINCT tlbAnimal.idfAnimal, tlbTestValidation.idfsDiagnosis,tlbTestValidation.idfTestValidation 
FROM tlbAnimal
	Inner Join tlbMaterial ON 
		tlbMaterial.idfAnimal = tlbAnimal.idfAnimal and tlbMaterial.intRowStatus=0
	Inner Join tlbTesting ON
		tlbTesting.idfMaterial = tlbMaterial.idfMaterial and tlbTesting.intRowStatus=0
	Inner Join tlbTestValidation on 
		tlbTestValidation.idfTesting = tlbTesting.idfTesting and tlbTestValidation.intRowStatus=0
	INNER JOIN tlbSpecies ON 
		tlbSpecies.idfSpecies = tlbAnimal.idfSpecies and
		tlbSpecies.intRowStatus=0
	Inner join tlbHerd on 
		tlbSpecies.idfHerd = tlbHerd.idfHerd and
		tlbHerd.intRowStatus=0
	WHERE tlbHerd.idfFarm = @idfFarm 
		and dbo.tlbTestValidation.idfsInterpretedStatus = 10104001
		and ISNULL(tlbTestValidation.blnCaseCreated,0) <>1
		and tlbAnimal.intRowStatus=0
	ORDER BY tlbTestValidation.idfsDiagnosis,  tlbAnimal.idfAnimal, tlbTestValidation.idfTestValidation 

OPEN crAnimal
FETCH NEXT FROM crAnimal into @idfAnimal, @idfsDiagnosis, @idfTestValidation

WHILE @@FETCH_STATUS = 0 
BEGIN
	IF @currentDiagnosis = -1 OR @currentDiagnosis<>@idfsDiagnosis
	BEGIN
		SET @idfCase = NULL
		SET @currentDiagnosis = @idfsDiagnosis

		--Get Animal CS Template
		EXECUTE spFFGetFormTemplate 
		  @idfsDiagnosis
		  ,10034013 --Animal CS
		  ,@idfsAnimalCSTemplate OUTPUT
		IF @idfsAnimalCSTemplate = -1
			SET @idfsAnimalCSTemplate = NULL

		--Get Control measures	template
		EXECUTE spFFGetFormTemplate 
		  @idfsDiagnosis
		  ,10034014 --Control measures
		  ,@idfsContolMeasureTemplate OUTPUT
		IF @idfsContolMeasureTemplate = -1
			SET @idfsContolMeasureTemplate = NULL

		--Get Farm EPI	template
		EXECUTE spFFGetFormTemplate 
		  @idfsDiagnosis
		  ,10034015 --Farm EPI
		  ,@idfsFarmEPITemplate OUTPUT
		IF @idfsFarmEPITemplate = -1
			SET @idfsFarmEPITemplate = NULL
		--Get Farm EPI	template
		EXECUTE spFFGetFormTemplate 
		  @idfsDiagnosis
		  ,10034016 --Species CS
		  ,@idfsSpeciesCSTemplate OUTPUT
		IF @idfsSpeciesCSTemplate = -1
			SET @idfsSpeciesCSTemplate = NULL

		EXEC spASSession_CreateCaseForDiagnosis @idfFarm, @idfsDiagnosis, @idfMonitoringSession, 
					@idfsContolMeasureTemplate, @idfsFarmEPITemplate, 
					@idfsSpeciesCSTemplate, @idfsAnimalCSTemplate, @idfPersonEnteredBy, @idfTestValidation, @idfCase OUTPUT
		if (NOT @idfCase IS NULL)
		BEGIN
			IF ISNULL(@CasesList,'') = ''
				SET @CasesList = CAST(@idfCase as varchar)
			ELSE
				SET @CasesList = ISNULL(@CasesList,'') + ','+ CAST(@idfCase as varchar)
				
		END
	END
	--EXEC spASSession_AddAnimalToCase @idfCase, @idfAnimal, @idfsAnimalCSTemplate
	UPDATE tlbTestValidation
	SET 
		blnCaseCreated = 1
	WHERE
		idfTestValidation = @idfTestValidation
	FETCH NEXT FROM crAnimal INTO  @idfAnimal, @idfsDiagnosis, @idfTestValidation
END --crAnimal cursor end

CLOSE crAnimal
DEALLOCATE crAnimal



return 0



