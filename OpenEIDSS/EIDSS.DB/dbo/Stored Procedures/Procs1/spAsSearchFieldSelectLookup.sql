

--##SUMMARY Select the list of search fields.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 16.04.2010

--##REMARKS Updated by Mirnaya O.
--##REMARKS Create date: 14.12.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:
exec spAsSearchFieldSelectLookup 'en'

*/ 
 
create procedure	spAsSearchFieldSelectLookup
	@LangID	as nvarchar(50),
	@ObjectID	as bigint = null,
	@ID			as bigint = null
as

select		sf.idfsSearchField,
			sf.strSearchFieldAlias,
			sf_ref.[name] as FieldCaption,
			sf.idfsSearchObject,
			sf.idfsSearchFieldType,
			sf.idfsReferenceType,
			sf.idfsGISReferenceType,
			sf.blnGeoLocationString,
			sf.strLookupTable,
			sf.intMapDisplayOrder,
			sf.intIncidenceDisplayOrder,
			sf.strCalculatedFieldText,
			case	IsNull(sf.idfsSearchFieldType, -1)
				when	10081006	-- Integer
					then	1
				when	10081004	-- Float
					then	1
				when	10081002	-- Date
					then	7
				when	10081001	-- Bit
					then	8
				else		0		-- String
			end as TypeImageIndex,
			sf.idfsDefaultAggregateFunction,
			
			sf.strLookupFunction,
			sf.strLookupFunctionIdField,
			sf.strLookupFunctionNameField,
			sf.strLookupAttribute,
			sf.blnAllowMissedReferenceValues,
			br_sob.intHACode
			

from		tasSearchField sf
inner join	fnReference(@LangID, 19000080) sf_ref	-- 'rftSearchField'
on			sf_ref.idfsReference = sf.idfsSearchField

	
inner join	trtBaseReference br_sob
on			br_sob.idfsBaseReference = sf.idfsSearchObject
			and br_sob.intRowStatus = 0
							
							
where		sf.intRowStatus = 0
			and (@ObjectID is null or @ObjectID = sf.idfsSearchObject)
			and (@ID is null or @ID = sf.idfsSearchField)
order by	sf.idfsSearchObject, sf_ref.[name]




