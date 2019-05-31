

--##SUMMARY Returns name of EIDSS cache lookup table and attribute for input alias of AVR search field 
--##SUMMARY and the list of AVR search fields depended on it.

--##SUMMARY Stored procedure have one input parameter: FieldAlias (nvarchar(200)) 
--##SUMMARY and two output parameters: LookupTableName (nvarchar(200)) and LookupAttribute (nvarchar(200)).
--##SUMMARY In addition, stored procedure returns table with the following columns:
--##SUMMARY idfSearchFieldsWithRelatedValues bigint not null PK
--##SUMMARY idfsSearchField bigint not null
--##SUMMARY strFieldAlias bigint not null
--##SUMMARY strLookupTable nvarchar(200) null
--##SUMMARY strLookupAttribute nvarchar(200) null
--##SUMMARY idfsRelatedSearchField bigint not null
--##SUMMARY strRelatedFieldAlias nvarchar(200) not null
--##SUMMARY strRelatedLookupAttribute nvarchar(200) null


--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 24.02.2014

--##RETURNS Don't use

/*
--Example of a call of procedure:

declare	@FieldAlias					nvarchar(200)
declare	@LookupTableName			nvarchar(200)
declare	@LookupAttribute			nvarchar(2000)

set @FieldAlias = 'sflHC_Diagnosis'

execute	spAsSearchFieldLookupInfoSelectLookup
		 @FieldAlias
		,@LookupTableName output
		,@LookupAttribute output

select	@LookupTableName
		,@LookupAttribute


*/ 

CREATE PROCEDURE [dbo].[spAsSearchFieldLookupInfoSelectLookup]
	@FieldAlias			as nvarchar(200),
	@LookupTableName	as nvarchar(200) = null output,
	@LookupAttribute	as nvarchar(200) = null output
AS
BEGIN

select		@LookupTableName = sf.strLookupTable,
			@LookupAttribute = sf.strLookupAttribute
from		tasSearchField sf
inner join	trtBaseReference br
on			br.idfsBaseReference = sf.idfsSearchField
			and br.intRowStatus = 0
where		(@FieldAlias is not null and @FieldAlias = sf.strSearchFieldAlias collate Cyrillic_General_CI_AS)
			and sf.intRowStatus = 0

select		sfrv.idfSearchFieldsWithRelatedValues,
			sf.idfsSearchField,
			sf.strSearchFieldAlias as strFieldAlias,
			sf.strLookupTable,
			sf.strLookupAttribute,
			sfrv.idfsRelatedSearchField,
			sf_related.strSearchFieldAlias as strRelatedFieldAlias,
			sfrv.strLookupAttribute as strRelatedLookupAttribute,
			case
				when	(	sf_related.idfsReferenceType is not null
							or sf_related.idfsGISReferenceType is not null
						)
					then	cast(1 as bit)
				else	cast(0 as bit)
			end as blnReferenceRelatedField,
			case
				when	(	sf_related.idfsGISReferenceType is not null	-- GIS Reference
							or	(	sf.idfsReferenceType = 19000141	-- Vector Species
									and sf_related.idfsReferenceType = 19000140	-- Vector Type
								)
						)
					then	cast(1 as bit)
				else	cast(0 as bit)
			end as blnUpperLevelRelatedField
from		tasSearchField sf
inner join	trtBaseReference br
on			br.idfsBaseReference = sf.idfsSearchField
			and br.intRowStatus = 0
inner join	tasSearchFieldsWithRelatedValues sfrv
	inner join	tasSearchField sf_related
	on			sf_related.idfsSearchField = sfrv.idfsRelatedSearchField
				and sf_related.intRowStatus = 0
	inner join	trtBaseReference br_related
	on			br_related.idfsBaseReference = sf_related.idfsSearchField
				and br_related.intRowStatus = 0
on			sfrv.idfsSearchField = sf.idfsSearchField
where		(@FieldAlias is null or @FieldAlias = sf.strSearchFieldAlias collate Cyrillic_General_CI_AS)
			and sf.intRowStatus = 0
order by	sf.idfsSearchField, sfrv.idfsRelatedSearchField, sfrv.idfSearchFieldsWithRelatedValues

END
