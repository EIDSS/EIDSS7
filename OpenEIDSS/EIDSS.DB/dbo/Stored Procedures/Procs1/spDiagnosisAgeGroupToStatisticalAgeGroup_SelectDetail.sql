
CREATE PROCEDURE [dbo].[spDiagnosisAgeGroupToStatisticalAgeGroup_SelectDetail]
AS Begin
	Select 
	  [idfDiagnosisAgeGroupToStatisticalAgeGroup]
      ,[idfsDiagnosisAgeGroup]
      ,[idfsStatisticalAgeGroup]     
	From [dbo].[trtDiagnosisAgeGroupToStatisticalAgeGroup]
	Where intRowStatus = 0
End
