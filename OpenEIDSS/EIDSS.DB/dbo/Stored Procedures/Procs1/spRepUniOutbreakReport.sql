

--##SUMMARY Select data for Outbreak report report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 11.12.2009

--##REMARKS UPDATED BY: Vorobiev E. - deleted idfFarmLocation
--##REMARKS Date: 15.04.2013

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##REMARKS UPDATED BY: Vasilyev I. --copy/pasted from [spOutbreak_SelectDetail] to reflect last requirements for v.6
--##REMARKS Date: 09.01.2014

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepUniOutbreakReport @LangID=N'en',@ObjID=51556680000000

*/

create  Procedure [dbo].[spRepUniOutbreakReport]
    (
        @LangID as nvarchar(10), 
        @ObjID	as bigint
    )
as
begin

	select		tlbOutbreak.idfOutbreak,
				tlbOutbreak.strOutbreakID, 			
				tlbOutbreak.strOutbreakID 	as strOutbreakIDBarcode,
				tlbOutbreak.datStartDate	as datOutbreakStartDate,
				tlbOutbreak.datFinishDate	as datOutbreakFinishDate,
				tlbOutbreak.strDescription	as strOutbreakDescription,
				dbo.fnAddressString(@LangID, tlbOutbreak.idfGeoLocation) as strOutbreakLocation,
				ISNULL(rfDiagnosis.[name], rfDiagnosisGroup.[name])		 as strOutbreakDiagnosis,
				
				
				cases.idfCase				as idfCaseSession,
				cases.strCaseID				as strCaseSessionID,
				cases.strCaseID				as strCaseSessionIDBarcode,
				cases.idfsCaseType			as idfsCaseSessionType,	
				rfCaseSessionType.[name]	as strCaseSessionType,
				cases.datEnteredDate		as datCaseSessionDate,
				cases.idfsSourceOfCaseSessionDate,
				cases.strCaseStatus			as strCaseSessionClassification,
				cases.blnConfirmed,
				cases.strDiagnosis			as strCaseSessionDiagnosis,
				cases.strGeoLocation		as strCaseSessionLocation,
				cases.strAddress			as strCaseSessionAddress,
				cases.strAddressDenyRightsDetailed		as strCaseSessionAddressDenyRightsDetailed,
				cases.strAddressDenyRightsSettlement	as strCaseSessionAddressDenyRightsSettlement,
				cases.strPatientName		as strPatientFarmOwner
				
	from		tlbOutbreak
	-- Get human cases union vet cases union sessions
	left join
	(
		select		tlbHumanCase.idfHumanCase as idfCase, 
					tlbHumanCase.idfOutbreak,
					tlbHumanCase.strCaseID, 
					10012001 AS idfsCaseType,
					CaseStatus.name as strCaseStatus, 
					convert(int, case when CaseStatus.idfsReference = 350000000 then 1 else 0 end) as blnConfirmed,
					Diagnosis.name as strDiagnosis, 
					isnull(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) as idfsDefaultDiagnosis,

					isnull(tlbHumanCase.datOnSetDate,
					isnull(datFirstSoughtCareDate,
					isnull(
						(
							select max(datChangedDate) from tlbChangeDiagnosisHistory
							where tlbChangeDiagnosisHistory.idfHumanCase = tlbHumanCase.idfHumanCase
						),
					isnull(tlbHumanCase.datNotificationDate, 
					tlbHumanCase.datEnteredDate)))) as datEnteredDate,

					case when tlbHumanCase.datOnSetDate is not null then 1
						 when datFirstSoughtCareDate is not null then 2
						 when
						 (
							select max(datChangedDate) from tlbChangeDiagnosisHistory
							where tlbChangeDiagnosisHistory.idfHumanCase = tlbHumanCase.idfHumanCase
						 ) is not null then 3
						 when tlbHumanCase.datNotificationDate is not null then 4 
					else 5 end as idfsSourceOfCaseSessionDate,

					tlbHumanCase.idfPointGeoLocation as idfGeoLocation, -- for personal data acceess
					tlbHuman.idfCurrentResidenceAddress as idfAddress, -- for personal data acceess
					dbo.fnGeoLocationString(@LangID,tlbHumanCase.idfPointGeoLocation,null) As strGeoLocation,
					dbo.fnAddressString(@LangID,tlbHuman.idfCurrentResidenceAddress) As strAddress,
					dbo.fnAddressStringDenyRigths(@LangID,tlbHuman.idfCurrentResidenceAddress, 1) As strAddressDenyRightsSettlement,
					dbo.fnAddressStringDenyRigths(@LangID,tlbHuman.idfCurrentResidenceAddress, 0) As strAddressDenyRightsDetailed,
					dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as strPatientName
		from		tlbHumanCase
		inner join		tlbHuman
		on				tlbHuman.idfHuman = tlbHumanCase.idfHuman
						and tlbHuman.intRowStatus = 0
		left join	dbo.fnReference(@LangID,19000019) as Diagnosis --'rftDiagnosis'
		on			COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) = Diagnosis.idfsReference
		left join	dbo.fnReference(@LangID,19000011) as CaseStatus --'rftCaseStatus'
		on			COALESCE(tlbHumanCase.idfsFinalCaseStatus, tlbHumanCase.idfsInitialCaseStatus) = CaseStatus.idfsReference

		union		All
		select		tlbVetCase.idfVetCase as idfCase, 
					tlbVetCase.idfOutbreak,
					tlbVetCase.strCaseID, 
					tlbVetCase.idfsCaseType,
					CaseStatus.name as strCaseStatus, 
					convert(int, case when CaseStatus.idfsReference = 350000000 then 1 else 0 end) as blnConfirmed,
					ISNULL(Diagnosis.strDisplayDiagnosis,   tlbVetCase.strDefaultDisplayDiagnosis) as strDiagnosis,
					tlbVetCase.idfsShowDiagnosis as idfsDefaultDiagnosis,
					 
					isnull(
						(
							select min(datStartOfSignsDate) from tlbSpecies
							inner JOIN tlbHerd ON tlbHerd.idfHerd = tlbSpecies.idfHerd and tlbHerd.intRowStatus = 0
							where tlbHerd.idfFarm = tlbVetCase.idfFarm and tlbSpecies.intRowStatus = 0
						),
					isnull(case when isnull(tlbVetCase.datReportDate,'30000101')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then tlbVetCase.datReportDate end,
					isnull(case when isnull(tlbVetCase.datAssignedDate,'30000101')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then tlbVetCase.datAssignedDate end,
					isnull(case when isnull(tlbVetCase.datInvestigationDate,'30000101')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101')
								 and isnull(tlbVetCase.datInvestigationDate,'30000101')<=isnull(tlbVetCase.datTentativeDiagnosisDate,'30000101')
								 and isnull(tlbVetCase.datInvestigationDate,'30000101')<=isnull(tlbVetCase.datTentativeDiagnosis1Date,'30000101')
								 and isnull(tlbVetCase.datInvestigationDate,'30000101')<=isnull(tlbVetCase.datTentativeDiagnosis2Date,'30000101') then tlbVetCase.datInvestigationDate end, 
					isnull(case when isnull(tlbVetCase.datTentativeDiagnosisDate,'30000101')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then tlbVetCase.datTentativeDiagnosisDate end,
					isnull(case when isnull(tlbVetCase.datTentativeDiagnosis1Date,'30000101')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then tlbVetCase.datTentativeDiagnosis1Date end,
					isnull(case when isnull(tlbVetCase.datTentativeDiagnosis2Date,'30000101')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then tlbVetCase.datTentativeDiagnosis2Date end,
					isnull(tlbVetCase.datFinalDiagnosisDate,
					tlbVetCase.datEnteredDate)))))))) as datEnteredDate,
					 
					case when
						 (
							select min(datStartOfSignsDate) from tlbSpecies
							inner JOIN tlbHerd ON tlbHerd.idfHerd = tlbSpecies.idfHerd and tlbHerd.intRowStatus = 0
							where tlbHerd.idfFarm = tlbVetCase.idfFarm and tlbSpecies.intRowStatus = 0
						 ) is not null then 6
						 when isnull(tlbVetCase.datReportDate,'30000101')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then 7
						 when isnull(tlbVetCase.datAssignedDate,'30000101')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then 8
						 when isnull(tlbVetCase.datInvestigationDate,'30000101')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101')
								 and isnull(tlbVetCase.datInvestigationDate,'30000101')<=isnull(tlbVetCase.datTentativeDiagnosisDate,'30000101')
								 and isnull(tlbVetCase.datInvestigationDate,'30000101')<=isnull(tlbVetCase.datTentativeDiagnosis1Date,'30000101')
								 and isnull(tlbVetCase.datInvestigationDate,'30000101')<=isnull(tlbVetCase.datTentativeDiagnosis2Date,'30000101') then 9 
						 when isnull(tlbVetCase.datTentativeDiagnosisDate,'30000101')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then 10
						 when isnull(tlbVetCase.datTentativeDiagnosis1Date,'30000101')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then 11
						 when isnull(tlbVetCase.datTentativeDiagnosis2Date,'30000101')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then 12
						 when tlbVetCase.datFinalDiagnosisDate is not null then 13
					else 14 end as idfsSourceOfCaseSessionDate,

					tlbFarm.idfFarmAddress as idfGeoLocation, -- for personal data acceess
					tlbFarm.idfFarmAddress as idfAddress, -- for personal data acceess
					dbo.fnGeoLocationString(@LangID,tlbFarm.idfFarmAddress,null) As strGeoLocation,
					dbo.fnAddressString(@LangID,tlbFarm.idfFarmAddress) As strAddress,
					dbo.fnAddressStringDenyRigths(@LangID,tlbFarm.idfFarmAddress, 1) As strAddressDenyRightsSettlement,
					dbo.fnAddressStringDenyRigths(@LangID,tlbFarm.idfFarmAddress, 0) As strAddressDenyRightsDetailed,
					dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as strPatientName
		  

		from		tlbVetCase
		LEFT JOIN   dbo.tlbVetCaseDisplayDiagnosis Diagnosis
			on	tlbVetCase.idfVetCase = Diagnosis.idfVetCase AND Diagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		left join	dbo.fnReference(@LangID,19000011) as CaseStatus --'rftCaseStatus'
		on			tlbVetCase.idfsCaseClassification = CaseStatus.idfsReference
		left join	tlbFarm
			on		tlbFarm.idfFarm  = tlbVetCase.idfFarm 
			and		tlbFarm.intRowStatus = 0
		left join		tlbHuman
		on				tlbHuman.idfHuman = tlbFarm.idfHuman
						and tlbHuman.intRowStatus = 0

		union		All
		select		vs.idfVectorSurveillanceSession as idfCase, 
					vs.idfOutbreak,
					vs.strSessionID as strCase, 
					10012006 as idfsCaseType,
					CONVERT(nvarchar,null) as  strCaseStatus, 
					convert(int, 1) as blnConfirmed,
					REPLACE(dbo.fn_VsSession_GetDiagnosesNames(vs.idfVectorSurveillanceSession, @LangID),';',',') as strDiagnosis,   
					null as idfsDefaultDiagnosis,
					vs.datStartDate as datEnteredDate,
					15 as idfsSourceOfCaseSessionDate,
					vs.idfLocation as idfGeoLocation, -- for personal data acceess
					vs.idfLocation as idfAddress, -- for personal data acceess
					dbo.fnGeoLocationString(@LangID,vs.idfLocation,null) As strGeoLocation,
					dbo.fnAddressString(@LangID,vs.idfLocation) As strAddress,
					dbo.fnAddressStringDenyRigths(@LangID,vs.idfLocation, 1) As strAddressDenyRightsSettlement,
					dbo.fnAddressStringDenyRigths(@LangID,vs.idfLocation, 0) As strAddressDenyRightsDetailed,
					NULL as strPatientName
		from		tlbVectorSurveillanceSession vs
	) 
	as cases
	on cases.idfOutbreak = tlbOutbreak.idfOutbreak
		-- Get Diagnosis
	left join	fnReferenceRepair(@LangID, 19000019 /*'rftDiagnosis' */)		as rfDiagnosis
	on			rfDiagnosis.idfsReference = tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
	left join	fnReferenceRepair(@LangID, 19000156 /*'rftDiagnosisGroup' */)		as rfDiagnosisGroup
	on			rfDiagnosisGroup.idfsReference = tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
		-- Get Case Type
	left join	fnReferenceRepair(@LangID, 19000012 /*'rftCaseType' */)		as rfCaseSessionType
	on			rfCaseSessionType.idfsReference = cases.idfsCaseType

	 where	tlbOutbreak.idfOutbreak = @ObjID
	   and	tlbOutbreak.intRowStatus = 0
		
end
