

--##SUMMARY Select data for Herd details for Avian report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 22.12.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepVetHerdDetails @ObjID=51580930000000,@LangID=N'ru'
exec dbo.spRepVetHerdDetails @ObjID=51582450000000,@LangID=N'ru'

select * from tlbVetCase

*/ 

CREATE  Procedure [dbo].[spRepVetHerdDetails]
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10)
    )
as
	select  
	tHerd.strHerdCode					as HerdCode,
	strSpeciesType						as SpeciesID,
	unSpecies.intTotalAnimalQty			as Total,
	unSpecies.intSickAnimalQty			as Sick,
	unSpecies.intDeadAnimalQty			AS Dead,
	unSpecies.strAverageAge				as AVGAge,
	unSpecies.datStartOfSignsDate		as SignsDate,
	unSpecies.strType					as [Type],
	unSpecies.strNote					as strNote,
	unSpecies.idfHerd, 
	unSpecies.idfSpecies

	from		dbo.tlbVetCase	as tVetCase
	-- Get Farm
	 inner join	dbo.tlbFarm		as tFarm
			on	tVetCase.idfFarm = tFarm.idfFarm and  
		      tFarm.intRowStatus = 0
	 inner join	dbo.tlbHerd		as tHerd
    	on	tHerd.idfFarm = tFarm.idfFarm and  
			    tHerd.intRowStatus = 0
	 left join	(
	 
				select		tInnerHerd.intSickAnimalQty,
							tInnerHerd.intTotalAnimalQty,
							tInnerHerd.intDeadAnimalQty,
							null					as strAverageAge,
							null					as datStartOfSignsDate,
							null					as strSpeciesType,
							tInnerHerd.strNote,
							tInnerHerd.idfHerd,
							'pptCaseHerd'			as strType,
							null					as idfSpecies
						
				  from		dbo.tlbHerd		as tInnerHerd
				  where tInnerHerd.intRowStatus = 0
					   
			union					   
				select		tSpecies.intSickAnimalQty,
							tSpecies.intTotalAnimalQty,
							tSpecies.intDeadAnimalQty,
							tSpecies.strAverageAge,
							tSpecies.datStartOfSignsDate,
							rfSpeciesType.[name]	as strSpeciesType,
							tSpecies.strNote,
							tSpecies.idfHerd,
							'pptCaseHerdSpecies'	as strType,
							tSpecies.idfSpecies		as idfSpecies
						
				  from		dbo.tlbSpecies		as tSpecies
				     left join	dbo.fnReferenceRepair(@LangID, 19000086 /*'rftSpeciesList'*/) as rfSpeciesType
					   on	rfSpeciesType.idfsReference = tSpecies.idfsSpeciesType
				  where tSpecies.intRowStatus = 0
				) as unSpecies
			on	unSpecies.idfHerd = tHerd.idfHerd
		 where	tVetCase.idfVetCase = @ObjID
			AND tVetCase.intRowStatus = 0
		 order by unSpecies.idfHerd, unSpecies.idfSpecies
			

