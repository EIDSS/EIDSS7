

-- exec spSmphMandatoryFields_SelectLookup 51577370000000
CREATE     PROCEDURE [dbo].[spSmphMandatoryFields_SelectLookup] 
	@idfCustomizationPackage bigint
AS
select tstMandatoryFieldsToCP.idfMandatoryField as id, tstMandatoryFields.strFieldAlias as fld
from tstMandatoryFieldsToCP
inner join tstMandatoryFields on tstMandatoryFieldsToCP.idfMandatoryField = tstMandatoryFields.idfMandatoryField
where tstMandatoryFieldsToCP.idfCustomizationPackage = @idfCustomizationPackage
--union all
--select 1000001, 'HumanCase.CaseProgressStatus'
union all
select 1000002, 'HumanCase.Diagnosis'
union all
select 1000003, 'HumanCase.Patient.LastName'
union all
select 1000004, 'HumanCase.Patient.CurrentResidenceAddress.Region'
union all
select 1000005, 'HumanCase.Patient.CurrentResidenceAddress.Rayon'
union all
select 1000006, 'VetCase.CaseReportType'
union all
select 1000007, 'VetCase.CaseProgressStatus'
union all
select 1000008, 'VetCase.Farm.Address.Region'
union all
select 1000009, 'VetCase.Farm.Address.Rayon'
union all
select 1000010, 'VetCase.TentativeDiagnosis'
union all
select 1000011, 'VetCase.Species.SpeciesType'
union all
select 1000012, 'AsSession.MonitoringSessionStatus'
union all
select 1000013, 'AsDisease.Diagnosis'
union all
select 1000014, 'Farm.Address.Region'
union all
select 1000015, 'Farm.Address.Rayon'
union all
select 1000016, 'VetCaseSample.SampleType'
union all
select 1000017, 'HumanCaseSample.SampleType'
union all
select 1000018, 'Animal.SpeciesType'
union all
select 1000019, 'HumanCaseSample.CollectionDate'
union all
select 1000020, 'AsSession.Sample.Farm'
union all
select 1000021, 'AsSession.Sample.Species'
union all
select 1000022, 'AsSession.Sample.AnimalCode'
union all
select 1000023, 'AsSession.Address.Region'


