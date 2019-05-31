

--##SUMMARY Selects data for disease -> material matrix (Material_For_DiseaseDetail form)

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.11.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
EXECUTE spMaterialForDisease_SelectDetail
*/


CREATE   PROCEDURE dbo.spMaterialForDisease_SelectDetail
AS

SELECT 	trtMaterialForDisease.idfMaterialForDisease,
	trtMaterialForDisease.idfsSampleType,
	trtMaterialForDisease.idfsDiagnosis, 
	trtMaterialForDisease.intRecommendedQty
FROM trtMaterialForDisease
inner join trtDiagnosis	on
	trtDiagnosis.idfsDiagnosis = trtMaterialForDisease.idfsDiagnosis
	and trtDiagnosis.intRowStatus = 0
inner join trtBaseReference	on
	trtBaseReference.idfsBaseReference = trtMaterialForDisease.idfsSampleType
	and trtBaseReference.intRowStatus = 0
	and trtBaseReference.idfsReferenceType = 19000087 --Sample Type
WHERE   trtMaterialForDisease.intRowStatus = 0 


--1 master Diagnosis
SELECT 
	CAST (-1 as bigint) idfsDiagnosis






