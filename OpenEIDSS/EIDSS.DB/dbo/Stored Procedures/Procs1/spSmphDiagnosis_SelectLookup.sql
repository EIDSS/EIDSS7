

CREATE     PROCEDURE [dbo].[spSmphDiagnosis_SelectLookup] 
AS
select idfsBaseReference as id, idfsReferenceType as tp, intHACode as ha, strDefault as df, trtBaseReference.intRowStatus as rs, isnull(intOrder,0) as rd
from trtBaseReference 
inner join trtDiagnosis
on trtDiagnosis.idfsDiagnosis = trtBaseReference.idfsBaseReference
where idfsReferenceType = 19000019 -- BaseReferenceType.rftDiagnosis
and trtDiagnosis.idfsUsingType = 10020001 --DiagnosisUsingTypeEnum.StandardCase

