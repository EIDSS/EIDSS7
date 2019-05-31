
--*************************************************************
-- Name 				: USP_VCT_ASSESSION_FARM_GETList
-- Description			: Get Settlement details
--          
-- Author               : Rima G. 
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
/*  
--Example of procedure call:  
DECLARE @idfMonitoringSession bigint  
SET @idfMonitoringSession=4581480000000  
EXECUTE USP_VCT_ASSESSION_FARM_GETList   
 @idfMonitoringSession  
 ,'en' 
*/  
--*************************************************************
  
  
  
Create PROCEDURE [dbo].[USP_VCT_ASSESSION_FARM_GETList]
(  
 @idfMonitoringSession	AS BIGINT--##PARAM @iidfMonitoringSession - AS session ID  
 ,@LangID				AS NVARCHAR(50)--##PARAM @LangID - language ID  
)  
AS  
BEGIN
	BEGIN TRY

		DECLARE @returnCode		INT = 0
				,@returnMsg		NVARCHAR(MAX) = 'SUCCESS'

		SELECT DISTINCT 
				ISNULL(f.idfFarm + 1,0) as id
				,s.idfMonitoringSession
				,f.idfFarm  as frmAnimalFarmID
				,f.strFarmCode
				,f.idfFarmActual
				,NULL AS idfsSpeciesType
				,NULL AS idfHerd
				,NULL AS strHerdCode
				,NULL AS idfAnimal  
				,NULL AS idfsAnimalAge
				,NULL AS idfsAnimalGender 
				,NULL AS strAnimalCode 
				,NULL AS idfSpecies
				,NULL AS strName
				,NULL AS strColor
				,NULL as strDescription
				,NULL AS idfMaterial
				,NULL AS idfsSampleType
				,NULL AS strSampleTypeName
				,NULL AS idfParty
				,NULL AS datFieldCollectionDate
				,NULL AS strFieldBarcode
				,NULL AS strBarcode
				,CAST (0 AS BIT) AS blnNewFarm 
				,NULL AS  SpeciesName
				,CAST (0 AS BIT) as Used
				,NULL as AnimalName
				,NULL AS idfSendToOffice
				, NULL AS OrganizationSentTo
		FROM	tlbMonitoringSession s
		INNER JOIN tlbFarm f ON
				f.idfMonitoringSession = s.idfMonitoringSession AND s.idfMonitoringSession = @idfMonitoringSession 
				AND f.intRowStatus = 0
		WHERE	f.idfFarm NOT IN (
									SELECT	tlbFarm.idfFarm 
									FROM	tlbFarm
									INNER JOIN tlbHerd h ON
											h.idfFarm = f.idfFarm
									AND		h.intRowStatus = 0
									INNER JOIN tlbSpecies sp ON
											h.idfHerd = sp.idfHerd
									AND		sp.intRowStatus = 0
									INNER JOIN tlbAnimal a ON
											sp.idfSpecies=a.idfSpecies 
									AND		a.intRowStatus=0 
									WHERE	f.idfMonitoringSession = @idfMonitoringSession
									AND		f.intRowStatus = 0
								)

		UNION ALL

		SELECT
				a.idfAnimal AS id
				,s.idfMonitoringSession
				,f.idfFarm
				,f.strFarmCode
				,f.idfFarmActual
				,sp.idfsSpeciesType
				,h.idfHerd
				,h.strHerdCode
				,a.idfAnimal  
				,a.idfsAnimalAge
				,a.idfsAnimalGender 
				,a.strAnimalCode 
				,a.idfSpecies
				,a.strName
				,a.strColor
				,a.strDescription
				,NULL AS idfMaterial
				,NULL AS idfsSampleType
				,NULL AS strSampleTypeName
				,NULL AS idfParty
				,NULL AS datFieldCollectionDate
				,NULL AS strFieldBarcode
				,NULL AS strBarcode
				,CAST (0 AS BIT) AS blnNewFarm 
				,SpeciesName.name AS SpeciesName
				,CAST (0 AS BIT) as Used
				,a.strAnimalCode as AnimalName
				,NULL AS idfSendToOffice
				, NULL AS OrganizationSentTo
		 FROM	tlbMonitoringSession s
		INNER JOIN tlbFarm f ON
				f.idfMonitoringSession = s.idfMonitoringSession
		AND		f.intRowStatus = 0
		INNER JOIN tlbHerd h ON
				h.idfFarm = f.idfFarm
		AND		h.intRowStatus = 0
		INNER JOIN tlbSpecies sp ON
				h.idfHerd = sp.idfHerd
		AND		sp.intRowStatus = 0
		INNER JOIN tlbAnimal a ON
				sp.idfSpecies=a.idfSpecies 
		AND		a.intRowStatus=0 
		LEFT JOIN tlbMaterial Material ON
				Material.idfAnimal = a.idfAnimal AND Material.intRowStatus = 0
		LEFT JOIN	FN_GBL_REFERENCEREPAIR(@LangID,19000086) SpeciesName ON --rftSpeciesList
					SpeciesName.idfsReference=sp.idfsSpeciesType

		WHERE	s.idfMonitoringSession = @idfMonitoringSession
		AND		s.intRowStatus = 0
		AND		Material.idfMaterial IS NULL
		
		UNION ALL

		SELECT
				Material.idfMaterial AS id
				,s.idfMonitoringSession
				,f.idfFarm
				,f.strFarmCode
				,f.idfFarmActual
				,sp.idfsSpeciesType
				,h.idfHerd
				,h.strHerdCode
				,a.idfAnimal  
				,a.idfsAnimalAge
				,a.idfsAnimalGender 
				,a.strAnimalCode 
				,a.idfSpecies
				,a.strName
				,a.strColor
				,a.strDescription
				,Material.idfMaterial
				,Material.idfsSampleType
				,SampleType.name as strSampleTypeName
				,Material.idfAnimal as idfParty
				,Material.datFieldCollectionDate
				,Material.strFieldBarcode
				,Material.strBarcode
				,CAST (0 AS BIT) AS blnNewFarm 
				,SpeciesName.name AS SpeciesName
				,CAST(Material.blnAccessioned as BIT) as Used
				,a.strAnimalCode as AnimalName
				,Material.idfSendToOffice
				,FR.strDefault as OrganizationSentTo
		FROM	tlbMonitoringSession s
		INNER JOIN tlbFarm f ON
				f.idfMonitoringSession = s.idfMonitoringSession
		AND		f.intRowStatus = 0
		INNER JOIN tlbHerd h ON
				h.idfFarm = f.idfFarm
		AND		h.intRowStatus = 0
		INNER JOIN tlbSpecies sp ON
				h.idfHerd = sp.idfHerd
		AND		sp.intRowStatus = 0
		INNER JOIN tlbAnimal a ON
				sp.idfSpecies=a.idfSpecies 
		AND		a.intRowStatus=0 
		INNER JOIN tlbMaterial Material ON
				Material.idfAnimal = a.idfAnimal AND Material.intRowStatus = 0
		INNER JOIN tlbOffice Office ON
				Office.idfsOfficeName = Material.idfSendToOffice
		INNER JOIN trtbasereference TB on
				TB.idfsBaseReference=Office.idfsOfficeName
		INNER JOIN FN_GBL_REFERENCEREPAIR(@LangID,19000046) FR ON
				FR.idfsReference=TB.idfsReferenceType
		LEFT JOIN	dbo.FN_GBL_REFERENCEREPAIR(@LangID,19000087) SampleType ON
				SampleType.idfsReference = Material.idfsSampleType	
		LEFT JOIN	FN_GBL_REFERENCEREPAIR(@LangID,19000086) SpeciesName ON --rftSpeciesList
				SpeciesName.idfsReference=sp.idfsSpeciesType
		WHERE	s.idfMonitoringSession = @idfMonitoringSession
		AND		s.intRowStatus = 0
		AND		Material.blnShowInCaseOrSession = 1
		AND NOT (ISNULL(Material.idfsSampleKind,0) = 12675420000000/*derivative*/ AND (ISNULL(Material.idfsSampleStatus,0) = 10015002 or ISNULL(Material.idfsSampleStatus,0) = 10015008)/*deleted in lab module*/)
		

	SELECT  @returnCode, @returnMsg

	END TRY

	BEGIN CATCH
			IF @@TRANCOUNT > 0 
				ROLLBACK

			SET @returnCode = ERROR_NUMBER()
			SET @returnMsg	= ERROR_MESSAGE()
			
			SELECT @returnCode, @returnMsg
			
	END CATCH
	
END
