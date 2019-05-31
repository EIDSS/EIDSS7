

--##SUMMARY Selects list of farms, heards, species amd animals related with specific monitoring session for report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 08.07.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepASSessionFarm  5410000870, 'en'

*/

create  Procedure [dbo].[spRepASSessionFarm]
	(
		@idfCase bigint,
		@LangID nvarchar(20)
	)
AS	
declare @intTotalSamples int
declare @intTotalAnimalSampled int

select @intTotalSamples = count(mat.idfMaterial), @intTotalAnimalSampled = count(distinct tlbAnimal.idfAnimal)
from		tlbMonitoringSession sess
-- get farm
inner join	tlbFarm
on 			tlbFarm.idfMonitoringSession = sess.idfMonitoringSession and
			tlbFarm.intRowStatus = 0
        
inner join	tlbHerd
on			tlbHerd.idfFarm = tlbFarm.idfFarm and	
			tlbHerd.intRowStatus = 0

inner join	tlbSpecies
on			tlbSpecies.idfHerd  = tlbHerd.idfHerd and
			tlbSpecies.intRowStatus = 0
        
inner join	tlbAnimal
on			tlbAnimal.idfSpecies  = tlbSpecies.idfSpecies
and			tlbAnimal.intRowStatus = 0

inner join	tlbMaterial as  mat
on			mat.idfAnimal = tlbAnimal.idfAnimal
and			mat.idfMonitoringSession = sess.idfMonitoringSession
and			mat.intRowStatus = 0

where		sess.idfMonitoringSession = @idfCase
and			sess.intRowStatus = 0
	
	


select   
			--farm
			 tlbAnimal.idfAnimal		as idfKey
			,tlbFarm.idfFarm			as idfFarm
			,tlbFarm.strFarmCode		as strFarmCode
			,dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) 
										as strOwnerName
			,dbo.fnGeoLocationString(@LangID,tlbFarm.idfFarmAddress,null) 
										as strFarmAddress
			
			,tlbAnimal.strAnimalCode	as strAnimalID	
			,spt.[name]					as strSpecies
			,fnAnimalAge.[name]			as strAge
			,tlbAnimal.strColor			as strColor	
			,tlbAnimal.strName			as strName	
			,fnAnimalGender.[name]		as strSex
			--  todo: implement
			,mat.datFieldCollectionDate	as datCollectionDate				
			,mat.strFieldBarcode		as strSampleID
			,samt.name					as strSampleType
			
			,@intTotalSamples			as intTotalSamples
			,@intTotalAnimalSampled		as intTotalAnimalSampled
			
	
from		tlbMonitoringSession sess
-- get farm
inner join
			(	tlbFarm
				
				left join	tlbHuman 
				on			tlbFarm.idfHuman = tlbHuman.idfHuman 
				and tlbHuman.intRowStatus = 0
			)
on 			tlbFarm.idfMonitoringSession = sess.idfMonitoringSession and
			tlbFarm.intRowStatus = 0
        
inner join	tlbHerd
on			tlbHerd.idfFarm = tlbFarm.idfFarm and	
			tlbHerd.intRowStatus = 0

inner join	(	
				tlbSpecies
				inner join	dbo.fnReferenceRepair(@LangID,19000086) as spt
				on			spt.idfsReference = tlbSpecies.idfsSpeciesType
			)
on			tlbSpecies.idfHerd  = tlbHerd.idfHerd and
			tlbSpecies.intRowStatus = 0
        
inner join	(
				tlbAnimal
				left join	dbo.fnReferenceRepair(@LangID,19000007) as fnAnimalGender
				on			fnAnimalGender.idfsReference = tlbAnimal.idfsAnimalGender
				left join	dbo.fnReferenceRepair(@LangID,19000005) as fnAnimalAge
				on			fnAnimalAge.idfsReference = tlbAnimal.idfsAnimalAge
			)
on			tlbAnimal.idfSpecies  = tlbSpecies.idfSpecies
and			tlbAnimal.intRowStatus = 0

left join	tlbMaterial as  mat
on			mat.idfAnimal = tlbAnimal.idfAnimal
and			mat.idfMonitoringSession = sess.idfMonitoringSession
and			mat.intRowStatus = 0

left join	dbo.fnReferenceRepair(@LangID,19000087) samt
on			samt.idfsReference = mat.idfsSampleType




where		sess.idfMonitoringSession = @idfCase
and			sess.intRowStatus = 0
	
	

