

--##SUMMARY Select Avian samples list for avian investigation report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 22.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepVetSamplesCollectionAvian 1849460000822 , 'en' 
 

*/ 

create  Procedure [dbo].[spRepVetSamplesCollectionAvian] 
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10)
    )
as 

	select		
				SampleType.[name]			as strSampleType,
				Material.strFieldBarcode	as strFieldSampleId,
				Species.[name]				as strSpeciesName,
				BirdStatus.[name]			as strBirdStatus,
				Material.datFieldCollectionDate		as datCollected,
				Material.datAccession,
				Condition.[name]			as strCondition,
				Material.strCondition		as strComment,
				dbo.fnConcatFullName(Person.strFamilyName, Person.strFirstName, Person.strSecondName)	as strCollectedByPerson,
				OfficeCollectedBy.[name]			as strCollectedByOffice,
				OfficeSendTo.[name]					as strSendToOffice,
				tVetCase.strSampleNotes
				--,Material.*
							
	from		dbo.tlbVetCase	as tVetCase
		   
-- get farm
	inner join tlbFarm
	on 			tVetCase.idfFarm = tlbFarm.idfFarm and
	        tlbFarm.intRowStatus = 0
	
	inner join	tlbHerd
	on      tlbHerd.idfFarm = tlbFarm.idfFarm and
	        tlbHerd.intRowStatus = 0
	        
	inner join	(	
					tlbSpecies
					
					inner join	dbo.fnReferenceRepair(@LangID,19000086) as Species
					on			Species.idfsReference = tlbSpecies.idfsSpeciesType
				)
	on			tlbSpecies.idfHerd  = tlbHerd.idfHerd and
	        tlbSpecies.intRowStatus = 0

	inner join	tlbMaterial as Material
	on			Material.idfVetCase = tVetCase.idfVetCase
	and			Material.idfSpecies = tlbSpecies.idfSpecies
	and Material.intRowStatus = 0
	
	left join	dbo.fnReferenceRepair(@LangID,19000110) Condition
	on			Condition.idfsReference = Material.idfsAccessionCondition
	
	left join	dbo.fnReferenceRepair(@LangID,19000087) SampleType
	on			SampleType.idfsReference = Material.idfsSampleType

	left join	dbo.fnReferenceRepair(@LangID,19000006 /*rftAnimalCondition */) BirdStatus
	on			BirdStatus.idfsReference = Material.idfsBirdStatus
		
	left join	tlbPerson as Person
	on			Person.idfPerson = Material.idfFieldCollectedByPerson
	left join	dbo.fnInstitution(@LangID) as OfficeCollectedBy
	on			OfficeCollectedBy.idfOffice = Material.idfFieldCollectedByOffice
	left join	dbo.fnInstitution(@LangID) as OfficeSendTo
	on			OfficeSendTo.idfOffice = Material.idfSendToOffice

	where tVetCase.idfVetCase =@ObjID
		AND tVetCase.intRowStatus = 0
			

