

--##SUMMARY Select data for LiveStock Test report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 20.12.2009

--##RETURNS Doesn't use

/*

--select top 1 *  from tlbVetCase order by datEnteredDate desc
--Example of a call of procedure:

exec dbo.spRepVetLivestockCase @LangID=N'en',@ObjID=4330000870


*/



create  Procedure [dbo].[spRepVetLivestockCase]
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10)
    )
as

	declare @DiagnosisTable as Table	(		
				strTentativeDiagnosis  nvarchar(max)
				,strTentativeDiagnosis1  nvarchar(max)
				,strTentativeDiagnosis2  nvarchar(max)
				,strFinalDiagnosis  nvarchar(max)
				,datTentativeDiagnosisDate datetime
				,datTentativeDiagnosis1Date datetime
				,datTentativeDiagnosis2Date datetime
				,datFinalDiagnosisDate datetime
				,strTentativeDiagnosisCode  nvarchar(max)
				,strTentativeDiagnosis1Code  nvarchar(max)
				,strTentativeDiagnosis2Code  nvarchar(max)
				,strFinalDiagnosisCode   nvarchar(max)
				)
				
	insert into @DiagnosisTable exec [spRepVetDiagnosis] @ObjID, @LangID
							
	declare @AllDiagnoses 	nvarchar(max)
	select @AllDiagnoses =  (case when (strFinalDiagnosis is null) then '' else strFinalDiagnosis + ', ' end) + 
							(case when (strTentativeDiagnosis2 is null) then '' else strTentativeDiagnosis2 +', ' end) + 
							(case when (strTentativeDiagnosis1 is null) then '' else strTentativeDiagnosis1 + ', ' end) + 
							(case when (strTentativeDiagnosis is null) then '' else strTentativeDiagnosis  end) 
	from @DiagnosisTable
	
	select  
		vc.strCaseID			as CaseIdentifier,
		vc.strFieldAccessionID	as FieldAccessionID,
		vc.datInvestigationDate	as DateOfInvestigation,
		vc.datEnteredDate		as DataEntryDate,
		vc.datReportDate		as ReportedDate,
		vc.datAssignedDate		as AssignedDate,
		vc.idfSiteID			as SiteID,
		vc.strEnteredName		as EnteredName,
		vc.strInvestigationName	as InvestigationName,
		vc.strReportedName		as ReportedName,
		vc.strFarmCode			as FarmCode,
		vc.strNationalName		as FarmName,
		vc.strFarmerName		as FarmerName,
		vc.strContactPhone		as FarmPhone,
		vc.strFax				as FarmFax,
		vc.strEmail				as FarmEMail,
		vc.dblLongitude			as FarmLongitude,
		vc.dblLatitude			as FarmLatitude,
		vc.idfsCountry			as FarmCountryId,
		vc.idfsRegion			as FarmRegionId,
		vc.idfsRayon			as FarmRayonId,
		vc.idfsSettlement		as FarmSettlementId,
		vc.strFarmLocation		as FarmLocation,
		vc.strFarmRegion		as FarmRegion,
		vc.strFarmRayon			as FarmRayon,
		vc.strSettlement		as Settlement,
		vc.strFarmAddress		as FarmAddress,
		rfClassification.[name]	as CaseClassification,
		rfCaseStatus.[name]		as CaseType,
		rfReportType.[name]		as ReportType,
		tlbOutbreak.strOutbreakID	as OutbreakID,
		sess.strMonitoringSessionID as SessionID ,
		
		@AllDiagnoses			as AllDiagnoses,
		dbo.fnAddressStringDenyRigths(@LangID, vc.idfFatmGeoLocation,1) as FarmAddressDenyRightsSettlement,
		dbo.fnAddressStringDenyRigths(@LangID, vc.idfFatmGeoLocation,0) as FarmAddressDenyRightsDetailed,
		
		vc.strNote				as Comments,
		
		null						as ProductionStructure,
		rfOwnershipTypeName.[name]	as OwnershipType,
		null						as GrazingPattern,
		null						as movementPattern

	from		dbo.fnRepGetVetCaseProperties(@LangID) as vc
	 left join	fnReferenceRepair(@LangID, 19000011 /*'rftCaseClassification'*/)as rfClassification 
			on	rfClassification.idfsReference = vc.idfsCaseClassification

	 left join	fnReferenceRepair(@LangID, 19000144 /*'rftCaseReportType'*/)	as rfReportType 
			on	rfReportType.idfsReference = vc.idfsCaseReportType

	 left join	fnReferenceRepair(@LangID, 19000111 /*'rftCaseProgressStatus'*/)	as rfCaseStatus 
			on	rfCaseStatus.idfsReference = vc.idfsCaseProgressStatus

	 left join  tlbOutbreak 
			on	tlbOutbreak.idfOutbreak = vc.idfOutbreak
		    and tlbOutbreak.intRowStatus = 0
		    
	 left join  tlbMonitoringSession sess
			on	sess.idfMonitoringSession = vc.idfParentMonitoringSession
		    and sess.intRowStatus = 0
		    
		    
	-- Get Farm
	 left join	dbo.tlbFarm		as tFarm
			on	vc.idfFarm = tFarm.idfFarm
		   
	 --left join	fnReferenceRepair(@LangID, 19000051 /*'rftLivestockProductionType'*/)	as rfProductionStructureName 
		--	on	rfProductionStructureName.idfsReference = tFarm.idfsLivestockProductionType
	 left join	fnReferenceRepair(@LangID, 19000065 /*'rftOwnershipType'*/)			as rfOwnershipTypeName
			on	rfOwnershipTypeName.idfsReference = tFarm.idfsOwnershipStructure
	 --left join	fnReferenceRepair(@LangID, 19000037 /*'rftGrazingPattern'*/)			as rfGrazingPatternName 
		--	on	rfGrazingPatternName.idfsReference = tFarm.idfsGrazingPattern
	 --left join	fnReferenceRepair(@LangID, 19000053 /*'rftMovementPattern'*/)			as rfMovementPatternName
		--	on	rfMovementPatternName.idfsReference = tFarm.idfsMovementPattern
		 where  vc.idfCase = @ObjID

			

