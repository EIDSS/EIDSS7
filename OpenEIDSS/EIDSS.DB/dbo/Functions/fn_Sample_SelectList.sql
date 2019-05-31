
create           function [dbo].[fn_Sample_SelectList](@LangID as nvarchar(50))
returns table
as
return
select
				idfMaterial,
				strFieldBarcode,
				strBarcode, 
				idfsSampleStatus,
				idfInDepartment,
				idfsSampleType,
				strSampleName,
				idfCase,
				idfMonitoringSession,
				idfVectorSurveillanceSession,
				idfsSpeciesType,
				CaseID,
				idfsCaseType,
				datFieldCollectionDate,
				idfsShowDiagnosis,
				idfsTentativeDiagnosis,
				idfsTentativeDiagnosis1,
				idfsTentativeDiagnosis2,
				idfsFinalDiagnosis,

				DiagnosisName,
				strNationalName,
				DepartmentName,
				HumanName,
				AnimalName,
				null as [Path],
				TestsCount,
				HACode,
				datAccession,
				strPatientName,
				strFarmOwner 
from		fnSampleListOptimized(@LangID) 
