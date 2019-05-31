

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

exec spRepVetSamplesCollectionLivestock 4330000870 , 'en' 
  
*/ 

create  Procedure [dbo].[spRepVetSamplesCollectionLivestock] 
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10)
    )
as 

	select		 Material.idfMaterial
				,SampleType.[name]					as strSampeType
				,Material.strFieldBarcode			as strFieldSampleID
				,tlbAnimal.strAnimalCode			as strAnimalID
				,SpeciesType.[name]					as strSpecies
				,Material.datFieldCollectionDate	as datCollected
				,Material.datAccession				as datAccession
				,Condition.[name]					as strCondition
				,Material.strCondition				as strComment
				,dbo.fnConcatFullName(Person.strFamilyName, Person.strFirstName, Person.strSecondName)	as strCollectedByPerson
				,OfficeCollectedBy.[name]			as strCollectedByOffice
				,OfficeSendTo.[name]				as strSendToOffice
				,tlbVetCase.strSampleNotes
		
	from		tlbVetCase	
	inner join  tlbFarm
	on 			tlbFarm.idfFarm = tlbVetCase.idfFarm and
				tlbFarm.intRowStatus = 0
	
	inner join	tlbHerd
	on			tlbHerd.idfFarm = tlbFarm.idfFarm and
				tlbHerd.intRowStatus = 0
	        
	inner join	tlbSpecies
	on			tlbSpecies.idfHerd  = tlbHerd.idfHerd and 
				tlbSpecies.intRowStatus = 0

	        
	inner join	tlbAnimal
	on			tlbAnimal.idfSpecies  = tlbSpecies.idfSpecies and
				tlbAnimal.intRowStatus = 0
	
	inner join	tlbMaterial as Material 
	on			Material.idfAnimal = tlbAnimal.idfAnimal
	and			Material.idfVetCase = tlbVetCase.idfVetCase
	and			Material.intRowStatus = 0
	
	inner join	dbo.fnReferenceRepair(@LangID,19000086) as SpeciesType
	on			SpeciesType.idfsReference = tlbSpecies.idfsSpeciesType

	inner join	dbo.fnReferenceRepair(@LangID,19000087) as SampleType
	on			SampleType.idfsReference = Material.idfsSampleType
	
	left join	dbo.fnReferenceRepair(@LangID,19000110) Condition
	on			Condition.idfsReference = Material.idfsAccessionCondition
	
	left join	tlbPerson as Person
	on			Person.idfPerson = Material.idfFieldCollectedByPerson
	left join	dbo.fnInstitution(@LangID) as OfficeCollectedBy
	on			OfficeCollectedBy.idfOffice = Material.idfFieldCollectedByOffice
	left join	dbo.fnInstitution(@LangID) as OfficeSendTo
	on			OfficeSendTo.idfOffice = Material.idfSendToOffice
	
	where		tlbVetCase.idfVetCase =@ObjID
	and			tlbVetCase.intRowStatus = 0

			

