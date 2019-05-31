

--##SUMMARY Select data for Vet Vaccinatoion report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 22.12.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepVetVaccination 'en', 1849460000822 

--select * from tlbVetCase where strCaseID = 'VAZXR003140068'
*/



create  Procedure [dbo].[spRepVetVaccination]
    (
        @LangID as nvarchar(10),
        @ObjID	as bigint
    )
as

	select  	
				rfDiagnosis.[name]			as Diagnosis,
				vac.datVaccinationDate, 
				fullSpecies.strFullSpeciesName		as strSpecies,
				vac.intNumberVaccinated,
				rfType.[name]				as strType, 
				rfRoute.[name]				as strRouteAdministered,
				vac.strLotNumber,
				vac.strManufacturer,
				vac.strNote
	
		from	tlbVetCase		as vc
	inner join	dbo.tlbVaccination	as vac
			on	vc.idfVetCase = vac.idfVetCase
		   and  vac.intRowStatus = 0
		-- Get Diagnosis
	 left join	fnReferenceRepair(@LangID, 19000019 /*'rftDiagnosis' */)	as rfDiagnosis
			on	rfDiagnosis.idfsReference = vac.idfsDiagnosis
		-- Get Type
	 left join	fnReferenceRepair(@LangID, 19000099 /*'rftVaccinationType' */)	as rfType
			on	rfType.idfsReference = vac.idfsVaccinationType
		-- Get Route
	 left join	fnReferenceRepair(@LangID, 19000098 /*'rftVaccinationRoute' */)	as rfRoute
			on	rfRoute.idfsReference = vac.idfsVaccinationRoute
			-- get species + herd
	 left join ( 
				select	sp.idfSpecies,
						rfSpeciesType.[name] + ' ' +hr.strHerdCode as strFullSpeciesName
				  from	tlbSpecies sp
			 left join  tlbHerd hr
					on  sp.idfHerd = hr.idfHerd
   			 left join	fnReferenceRepair(@LangID, 19000086 /*'rftSpeciesList' */)	as rfSpeciesType
					on	rfSpeciesType.idfsReference = sp.idfsSpeciesType
				 where  sp.intRowStatus = 0
				   and  hr.intRowStatus = 0	
			) fullSpecies
			on  fullSpecies.idfSpecies = vac.idfSpecies
		 where	vc.idfVetCase = @ObjID
			AND vc.intRowStatus = 0
		 
		
		
		
