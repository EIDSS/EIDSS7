

--##SUMMARY Selects list of penside tests related with specific case.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 22.11.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
DECLARE @ID BIGINT 
SET @ID = 4581470000000
exec spPensideTests_SelectDetail 
	@ID,
	'en'
*/

CREATE       PROCEDURE [dbo].[spPensideTests_SelectDetail]
	@idfCase AS BIGINT --##PARAM @idfCase - case ID for wich the penside tests are selected
	,@LangID AS NVARCHAR(50) --##PARAM @LangID - language ID
AS

SELECT idfPensideTest
      ,Material.idfVetCase
      ,COALESCE(Material.idfSpecies, Material.idfAnimal, Material.idfVector) AS idfParty
      --,idfSpecies
      ,Test.idfMaterial
	  ,Material.strBarcode
      ,Material.strFieldBarcode
      --,idfsSampleType
	  ,Test.idfsPensideTestResult
	  ,ISNULL(TestResult.name, TestResult.strDefault) as [strPensideTestResultName]
      ,Test.idfsPensideTestName
	  ,ISNULL(TestType.name, TestType.strDefault) as [strPensideTestName]
      --,strFieldSampleID
	  ,ISNULL(SampleType.name, SampleType.strDefault) as [strSampleName]
	  ,Material.idfVectorSurveillanceSession
	  ,Material.idfVector 
	  ,Test.datTestDate	  
	  ,Material.datFieldCollectionDate
	  ,Animal.strAnimalCode as strAnimal
	  ,ISNULL(SpeciesType.name, SpeciesType.strDefault) as Species,
	  '' as strDummy
  From dbo.tlbPensideTest Test
  Inner Join dbo.tlbMaterial Material On
	Material.idfMaterial = Test.idfMaterial
	AND ((Material.idfVetCase = @idfCase) or (Material.idfVectorSurveillanceSession = @idfCase))
	AND Material.intRowStatus = 0
  Left Outer Join dbo.tlbAnimal Animal On
	Animal.idfAnimal = Material.idfAnimal
	AND Animal.intRowStatus = 0
  Left Outer Join dbo.tlbSpecies Species On
	Species.idfSpecies = isnull(Material.idfSpecies, Animal.idfSpecies)
	AND Species.intRowStatus = 0
  Left Outer Join dbo.fnReferenceRepair(@LangID,19000087) SampleType ON SampleType.idfsReference = Material.idfsSampleType
  Left Outer Join dbo.fnReferenceRepair(@LangID,19000105) TestResult ON TestResult.idfsReference = Test.idfsPensideTestResult
  Left Outer Join dbo.fnReferenceRepair(@LangID,19000104) TestType ON TestType.idfsReference = Test.idfsPensideTestName
  Left Outer Join dbo.fnReferenceRepair(@LangID,19000086) SpeciesType ON SpeciesType.idfsReference = Species.idfsSpeciesType

  WHERE Test.intRowStatus = 0







