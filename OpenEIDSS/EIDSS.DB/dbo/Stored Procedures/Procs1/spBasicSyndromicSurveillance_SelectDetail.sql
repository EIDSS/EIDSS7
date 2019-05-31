
CREATE  PROCEDURE [dbo].[spBasicSyndromicSurveillance_SelectDetail](
	@idfBasicSyndromicSurveillance AS bigint
	,@LangID AS nvarchar(50)
)
AS
Begin

	Declare @dt Datetime
	Set Dateformat dmy
	Set @dt = '18990101'
	
	Select
	idfBasicSyndromicSurveillance
	,strFormID
	,datDateEntered
	,Nullif(datDateLastSaved, @dt) [datDateLastSaved]
	,idfEnteredBy
	,BSS.idfsSite
	,idfsBasicSyndromicSurveillanceType
	,Isnull(BSSType.name, BSSType.strDefault) [strBasicSyndromicSurveillanceType]
	,idfHospital
	,datReportDate
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
	
	From [dbo].[tlbBasicSyndromicSurveillance] BSS
	Inner Join dbo.fnReference(@LangID, 19000159) BSSType On BSS.idfsBasicSyndromicSurveillanceType = BSSType.idfsReference
	Left Join dbo.fnReference(@LangID, 19000160) MethodOfMeasurement On BSS.idfsMethodOfMeasurement = MethodOfMeasurement.idfsReference
	Left Join dbo.fnReference(@LangID, 19000162) TestResult On BSS.idfsTestResult = TestResult.idfsReference
	Left Join dbo.tlbHuman Human On BSS.idfHuman = Human.idfHuman
	Where
	BSS.idfBasicSyndromicSurveillance = @idfBasicSyndromicSurveillance
		and BSS.intRowStatus = 0
end
