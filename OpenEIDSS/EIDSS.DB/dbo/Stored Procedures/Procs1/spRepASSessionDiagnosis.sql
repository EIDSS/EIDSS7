

--##SUMMARY Selects monitoring session details for report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 20.07.2010

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
exec [spRepASSessionDiagnosis]  5410000870, 'en'
*/

create  Procedure [dbo].[spRepASSessionDiagnosis]
	(
		@idfCase bigint,
		@LangID nvarchar(20)
	)
AS	


/*
select   779090000000	as	idfsKey,
		 'Brucellosis'	as	strDiagnosis,
		 'Cat'			as	strSpecies
union 
*/


select   tmstd.idfMonitoringSessionToDiagnosis	as	idfsKey,
		 diag.name								as	strDiagnosis,
		 species.name							as	strSpecies

from tlbMonitoringSessionToDiagnosis tmstd
	left join	fnReferenceRepair(@LangID, 19000019) diag
	on			diag.idfsReference = tmstd.idfsDiagnosis

	left join	fnReferenceRepair(@LangID, 19000086) species
	on			species.idfsReference = tmstd.idfsSpeciesType
where tmstd.idfMonitoringSession = @idfCase
and tmstd.intRowStatus = 0		 

