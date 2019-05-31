

--##SUMMARY Select data for Summary of infection diseases report.
--##REMARKS SD - Start issue date
--##REMARKS ED - End issue date 
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 07.12.2009

--##RETURNS Doesn't use 

/*
--Example of a call of procedure:
exec dbo.spRepHumSummaryOfInfectionDiseases @LangID=N'en',@SD=N'2000-07-06T00:00:00',@ED=N'2012-10-10T00:00:00'

*/


create  Procedure [dbo].[spRepHumSummaryOfInfectionDiseases]
	(
		@LangID As nvarchar(50), 
		@SD as nvarchar(20),
		@ED as nvarchar(20)
	)
AS	
    declare @SDDate as datetime
    declare @EDDate as datetime

    set @SDDate=dbo.fn_SetMinMaxTime(CAST(@SD as datetime),0)
    set @EDDate=dbo.fn_SetMinMaxTime(CAST(@ED as datetime),1)

	select 
	ISNULL(		
			rfHumanCase.datTentativeDiagnosisDate,	
			ISNULL(rfHumanCase.datNotificationDate, rfHumanCase.datEnteredDate)
		  )									as ReportedDate,
	rfHumanCase.strCaseID					as CaseID,
	rfHumanCase.strPatientFullName			as PatientName,
	rfHumanCase.datDateofBirth				as DOB,
	cast(rfHumanCase.intPatientAge as nvarchar(10)) + ' ' + rfHumanCase.strPatientAgeType			as AgeType,
	rfHumanCase.intPatientAge				as Age,
	rfHumanCase.strPatientGender			as Gender,
	dbo.fnAddressString(@LangID, rfHumanCase.idfCurrentResidenceAddress) as HomeAddress,
--	rfHumanCase.strHospitalizationPlace		as RegAddress,
	dbo.fnAddressString(@LangID, rfHumanCase.idfRegistrationAddress) as RegAddress,
	dbo.fnAddressString(@LangID, rfHumanCase.idfEmployerAddress)	as PlaceofWork,
	rfHumanCase.strTentetiveDiagnosis		as TentetiveDiagnosis,
	IsNull(rfHumanCase.strFinalDiagnosis, rfHumanCase.strTentetiveDiagnosis)	as FinalDiagnosis,
	rfHumanCase.datOnSetDate				as DisOccurDate,
	rfHumanCase.datHospitalizationDate		as HospitalDate,
	rfHumanCase.strReceivedByFullName			as ReceivedBy,
	fnReceived.[name]			as SentBy,
	IsNull(rfHumanCase.datFinalDiagnosisDate, rfHumanCase.datTentativeDiagnosisDate)	as FinalDiagnDate,
	rfHumanCase.datTentativeDiagnosisDate	as TentDiagnDate,
	rfOutcome.[name]				as Outcome,
	rfHumanCase.datNotificationDate	as DateOfCompletionForm,
	rfHumanCase.strSummaryNotes				as Comments
	from	dbo.fnRepGetHumanCaseProperties(@LangID) as rfHumanCase
	-- Get is Outcome
	 left join	fnReferenceRepair(@LangID, 19000064 /*'rftOutcome'*/) as rfOutcome
			on	rfOutcome.idfsReference=rfHumanCase.idfsOutcome
	-- Filter condition
	left join	fnInstitution(@LangID) as fnReceived
	on			fnReceived.idfOffice=rfHumanCase.idfReceivedByOffice
	
	where	 ISNULL(		
					rfHumanCase.datTentativeDiagnosisDate,	
					ISNULL(rfHumanCase.datNotificationDate, rfHumanCase.datEnteredDate)
					) between @SDDate and @EDDate
	order by	ISNULL(		
					rfHumanCase.datTentativeDiagnosisDate,	
					ISNULL(rfHumanCase.datNotificationDate, rfHumanCase.datEnteredDate)
					)
	

