

CREATE     Function [dbo].[fn_BasicSyndromicSurveillance_SelectList]
(
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
returns table 
as
return

Select
  idfBasicSyndromicSurveillance
	,strFormID
	,datDateEntered
	,datDateLastSaved
	,idfEnteredBy
	,BSS.idfsSite
	,idfsBasicSyndromicSurveillanceType
	,Isnull(BSSType.name, BSSType.strDefault) [strBasicSyndromicSurveillanceType]
	,idfHospital
	,HospitalNames.name AS [strHospital]
	,datReportDate
	,Human.strFirstName
	,Human.strLastName
	,dbo.fnConcatFullName(Human.strLastName, Human.strFirstName, Human.strSecondName) as PatientName
	,intAgeYear
	,intAgeMonth
	,intAgeFullYear
	,intAgeFullMonth
	,strPersonalID
	,idfsYNPregnant
	,idfsYNPostpartumPeriod
	,datDateOfSymptomsOnset
	,idfsYNFever
	,idfsMethodOfMeasurement
	,Isnull(MethodOfMeasurement.name, MethodOfMeasurement.strDefault) [strMethodOfMeasurement]
	,strMethod
	,idfsYNCough
	,idfsYNShortnessOfBreath
	,idfsYNSeasonalFluVaccine
	,datDateOfCare
	,idfsYNPatientWasHospitalized
	,idfsOutcome
	,idfsYNPatientWasInER
	,idfsYNTreatment
	,idfsYNAdministratedAntiviralMedication
	,strNameOfMedication
	,datDateReceivedAntiviralMedication
	,blnRespiratorySystem
	,blnAsthma
	,blnDiabetes
	,blnCardiovascular
	,blnObesity
	,blnRenal
	,blnLiver
	,blnNeurological
	,blnImmunodeficiency
	,blnUnknownEtiology
	,datSampleCollectionDate
	,strSampleID
	,idfsTestResult
	,Isnull(TestResult.name, TestResult.strDefault) [strTestResult]
	,datTestResultDate
	,BSS.datModificationForArchiveDate
	,BSS.intRowStatus
	,Human.idfHuman
	,Human.idfsHumanGender
	,Isnull(Gender.name, Gender.strDefault) [strGender]
	,dbo.fnAddressString(@LangID,Human.idfCurrentResidenceAddress) As strAddress
	,CRA.idfsSettlement
	,CRA.idfsRegion
	,CRA.idfsRayon 
	,CRA.idfsCountry
	From [dbo].[tlbBasicSyndromicSurveillance] BSS
	Inner Join dbo.fnReference(@LangID, 19000159) BSSType On BSS.idfsBasicSyndromicSurveillanceType = BSSType.idfsReference
	Left Join dbo.fnReference(@LangID, 19000160) MethodOfMeasurement On BSS.idfsMethodOfMeasurement = MethodOfMeasurement.idfsReference
	Left Join dbo.fnReference(@LangID, 19000162) TestResult On BSS.idfsTestResult = TestResult.idfsReference
	Left Join dbo.tlbHuman Human On BSS.idfHuman = Human.idfHuman
	Left Join dbo.fnReference(@LangID, 19000043) Gender On Human.idfsHumanGender = Gender.idfsReference
	Left Join dbo.tlbGeoLocation CRA On Human.idfCurrentResidenceAddress  = CRA.idfGeoLocation
	Left Join dbo.tlbOffice Hospitals On Hospitals.idfOffice = BSS.idfHospital And Hospitals.intRowStatus = 0
	Left Join dbo.fnReference(@LangID,19000045) HospitalNames On HospitalNames.idfsReference = Hospitals.idfsOfficeAbbreviation
	Where BSS.intRowStatus = 0
