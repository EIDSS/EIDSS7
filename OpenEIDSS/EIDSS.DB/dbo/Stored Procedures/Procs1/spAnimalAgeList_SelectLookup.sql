
--##SUMMARY Selects list of animal ages for lookup purposes

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use


/*
--Example of procedure call:
exec spAnimalAgeList_SelectLookup 'en', null
*/

create   PROCEDURE dbo.spAnimalAgeList_SelectLookup
	@LangID As nvarchar(50), --##PARAM @LangID - language ID
	@idfsSpecies AS VARCHAR(36)	--##PARAM @idfsSpecies - pointer to species Type. If not null only ages for specific species are selected, in other case full ages list is returned
AS
DECLARE @tmp Table
(
	idfRowNumber bigint not null PRIMARY KEY ,
	idfsSpeciesType bigint,
	idfsReference bigint not null,
	[name] nvarchar(200),
	intOrder int,
	intRowStatus int
)
insert into @tmp
SELECT 	
	ROW_NUMBER() OVER(ORDER BY idfsReference DESC) AS idfRowNumber,
	idfsSpeciesType,
	idfsReference,
	[name],
	intOrder,
	fnReferenceRepair.intRowStatus
FROM dbo.fnReferenceRepair(@LangID,19000005/*'rftAnimalAgeList'*/)
INNER JOIN trtSpeciesTypeToAnimalAge ON 
	trtSpeciesTypeToAnimalAge.idfsAnimalAge = fnReferenceRepair.idfsReference
WHERE 
	(@idfsSpecies IS NULL OR trtSpeciesTypeToAnimalAge.idfsSpeciesType=@idfsSpecies)

select * from @tmp ORDER BY intOrder




