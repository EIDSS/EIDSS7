
CREATE PROCEDURE [dbo].[spDiagnosisAgeGroupToDiagnosis_SelectDetail]
AS Begin
	Select 
	  d.[idfDiagnosisAgeGroupToDiagnosis]
      ,d.[idfsDiagnosis]
      ,d.[idfsDiagnosisAgeGroup]     
	From [dbo].[trtDiagnosisAgeGroupToDiagnosis] d
	inner join trtBaseReference br on br.idfsBaseReference = d.[idfsDiagnosisAgeGroup]
	Where d.intRowStatus = 0
	order by br.intOrder
End
