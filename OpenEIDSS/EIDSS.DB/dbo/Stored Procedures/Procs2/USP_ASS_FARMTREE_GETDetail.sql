--*************************************************************
-- Name 				: USP_ASS_FARMTREE_GETDetail
-- Description			: Selects farm tree data. These data includes info about farm and its child herds/species
--						: These data are accessible only for farms related with monitoring session  
--						: This SP does not return the error is dataset. The error is raised to be caught in caller (SP) error handler
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_ASS_FARMTREE_GETDetail]
	(
	@idfMonitoringSession	AS	BIGINT		--##PARAM @@idfMonitoringSession - Active Surveillance Session ID  
	)  
AS  

BEGIN

	BEGIN TRY  	

		SELECT
			tlbFarm.idfFarm as idfParty
			,tlbFarm.idfMonitoringSession
			,CAST(10072005 AS bigint) as idfsPartyType
			,tlbFarm.strFarmCode As strName
			,CAST(NULL AS BIGINT) AS idfParentParty
			,tlbFarm.intLivestockTotalAnimalQty AS intTotalAnimalQty
			,tlbFarm.strNote
			,idfFarm AS idfFarm
		FROM 
			tlbFarm 
		WHERE  
			tlbFarm.idfMonitoringSession = @idfMonitoringSession
			AND 
			tlbFarm.intRowStatus = 0
			AND 
			NOT (@idfMonitoringSession IS NULL)

		UNION

		SELECT
			tlbHerd.idfHerd AS idfParty
			,tlbFarm.idfMonitoringSession
			,CAST(10072003 AS BIGINT) AS idfsPartyType
			,tlbHerd.strHerdCode AS strName
			,tlbHerd.idfFarm AS idfParentParty
			,tlbHerd.intTotalAnimalQty
			,tlbHerd.strNote
			,tlbHerd.idfFarm AS idfFarm
		FROM
			tlbFarm
			INNER JOIN tlbHerd ON
				tlbHerd.idfFarm = tlbFarm.idfFarm 
				AND
				tlbHerd.intRowStatus = 0	
			INNER JOIN tlbSpecies ON
				tlbHerd.idfHerd = tlbSpecies.idfHerd
				AND 
				tlbSpecies.intRowStatus = 0
			INNER JOIN trtBaseReference ON
				tlbSpecies.idfsSpeciesType = trtBaseReference.idfsBaseReference
				AND
				(ISNULL(trtBaseReference.intHACode,32) & 32) <> 0
		WHERE
			tlbFarm.idfMonitoringSession = @idfMonitoringSession
			AND 
			tlbFarm.intRowStatus = 0
			AND 
			NOT (@idfMonitoringSession IS NULL)


		UNION

		--SELECT Herds spieces info related with case/case herd
		SELECT
			tlbSpecies.idfSpecies as idfParty,
			tlbFarm.idfMonitoringSession,  
			CAST(10072004 AS BIGINT) AS idfsPartyType,
			CAST(tlbSpecies.idfsSpeciesType AS NVARCHAR) AS strName,
			tlbHerd.idfHerd AS idfParentParty,
			tlbSpecies.intTotalAnimalQty,
			tlbSpecies.strNote,
			tlbHerd.idfFarm AS idfFarm
		FROM
			tlbFarm
			INNER JOIN tlbHerd ON
				tlbHerd.idfFarm = tlbFarm.idfFarm 
				AND
				tlbHerd.intRowStatus = 0	
			INNER JOIN tlbSpecies ON
				tlbHerd.idfHerd = tlbSpecies.idfHerd 
				AND 
				tlbSpecies.intRowStatus = 0
			INNER JOIN trtBaseReference ON
				tlbSpecies.idfsSpeciesType = trtBaseReference.idfsBaseReference
				AND 
				(ISNULL(trtBaseReference.intHACode,32) & 32) <> 0
		WHERE
			tlbFarm.idfMonitoringSession = @idfMonitoringSession
			AND 
			tlbFarm.intRowStatus = 0
			AND 
			NOT (@idfMonitoringSession IS NULL)
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
