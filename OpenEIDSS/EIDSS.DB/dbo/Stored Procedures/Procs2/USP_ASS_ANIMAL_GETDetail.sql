--*************************************************************
-- Name 				: USP_ASS_ANIMAL_GETDetail
-- Description			: Selects list of animals related with specific monitoring session.
--						: This SP does not return the error is dataset. The error is raised to be caught in caller (SP) error handler
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_ASS_ANIMAL_GETDetail]
	(
	@idfMonitoringSession	AS	BIGINT		--##PARAM @@idfMonitoringSession - Active Surveillance Session ID  
	)  
AS  

BEGIN

	BEGIN TRY  	

		SELECT  	 
			tlbAnimal.idfAnimal
			,tlbAnimal.idfsAnimalAge
			,tlbAnimal.idfsAnimalGender
			,tlbAnimal.strAnimalCode
			,tlbAnimal.idfSpecies
			,tlbAnimal.strName
			,tlbAnimal.strColor
			,tlbAnimal.strDescription
			,tlbSpecies.idfsSpeciesType 
			,tlbFarm.idfMonitoringSession
			,tlbFarm.strFarmCode

		FROM 
			tlbAnimal
			INNER JOIN tlbSpecies ON 
				tlbSpecies.idfSpecies=tlbAnimal.idfSpecies 
				AND 
				tlbSpecies.intRowStatus=0 
			INNER JOIN tlbHerd ON
				tlbHerd.idfHerd = tlbSpecies.idfHerd
				AND 
				tlbHerd.intRowStatus = 0
			INNER JOIN tlbFarm ON
				tlbFarm.idfFarm = tlbHerd.idfFarm
				AND 
				tlbFarm.intRowStatus = 0
			LEFT OUTER JOIN tlbVetCase ON 
				tlbVetCase.idfFarm = tlbFarm.idfFarm
				AND 
				tlbVetCase.intRowStatus = 0
		WHERE	
			tlbFarm.idfMonitoringSession = @idfMonitoringSession 
			AND 
			tlbVetCase.idfVetCase IS NULL
			AND 
			NOT (@idfMonitoringSession IS NULL)
			AND 
			tlbAnimal.intRowStatus = 0

	END TRY  

	BEGIN CATCH 

		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;  

		SELECT   
			@ErrorMessage = ERROR_MESSAGE()
			,@ErrorSeverity = ERROR_SEVERITY()
			,@ErrorState = ERROR_STATE()

		RAISERROR 
			(
			@ErrorMessage,	-- Message text.  
			@ErrorSeverity, -- Severity.  
			@ErrorState		-- State.  
			); 
	END CATCH
END