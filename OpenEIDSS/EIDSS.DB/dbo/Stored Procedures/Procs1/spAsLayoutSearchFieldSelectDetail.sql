

--##SUMMARY select layouts for analytical module

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 03.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:
select *  from tasLayout
exec dbo.spAsLayoutSearchFieldSelectDetail @LangID=N'ru',@LayoutID=55716730000000
*/ 


 
create PROCEDURE [dbo].[spAsLayoutSearchFieldSelectDetail]
	@LangID	as nvarchar(50),
	@LayoutID	as bigint
AS

select		lsf.idfLayoutSearchField,
			lsf.idflLayout,
			lsf.idfQuerySearchField,
			lsf.idfsAggregateFunction,
			lsf.idfsGroupDate,
			lsf.blnShowMissedValue,
			lsf.datDiapasonStartDate,
			lsf.datDiapasonEndDate,
			lsf.intPrecision,
			lsf.intFieldCollectionIndex,
			lsf.intPivotGridAreaType,
			lsf.intFieldPivotGridAreaIndex,
			lsf.blnVisible,
			lsf.blnHiddenFilterField,
			lsf.intFieldColumnWidth,
			lsf.blnSortAcsending,
			lsf.strFieldFilterValues,
			isnull(cast(lsf.strReservedAttribute as bigint), 10004020) as idfsBasicCountFunction,
			
			
			fnsf.strSearchFieldAlias as strSearchFieldAlias,
			
			sf.strFieldENCaption as strOriginalFieldENCaption,
			sf.strFieldCaption as strOriginalFieldCaption,
			
			isnull(fnlfn.strEnglishName, sf.strFieldENCaption) as strNewFieldENCaption,
			isnull(fnlfn.strName, sf.strFieldCaption)  as strNewFieldCaption,
			
			lsf.idfUnitLayoutSearchField,
			lsf.idfDateLayoutSearchField,

			fnsfu.strSearchFieldAlias as strUnitSearchFieldAlias,
			fnsfdt.strSearchFieldAlias as strDateSearchFieldAlias,
			
			sf.idfsSearchField,
			sf.strLookupTable,
			sf.idfsGISReferenceType,
			sf.idfsReferenceType,
			sf.strLookupAttribute,
			sf.blnAllowMissedReferenceValues,
			sf.idfsDefaultAggregateFunction,
			sf.intHACode
			
			
from		
(			
			dbo.fnLayoutSearchFields(@LayoutID) fnsf
inner join	tasLayoutSearchField	lsf
on			fnsf.idfQuerySearchField = lsf.idfQuerySearchField
AND			lsf.idflLayout = @LayoutID
inner join	tasLayout	l
on			l.idflLayout = @LayoutID
--Query search field caption
left join
			(
				select	q.idflQuery,
						qsf.idfQuerySearchField,
						sf.idfsSearchField,
						sf.strLookupTable,
						sf.strLookupAttribute,
						sf.idfsGISReferenceType,
						sf.idfsReferenceType,
						sf.blnAllowMissedReferenceValues,
						sf.idfsDefaultAggregateFunction,
						br_sob.intHACode,
						case
							when qsf.idfsParameter is not null
								then p_ref_en.[name]
							else sf_ref_en.[name]
						end as strFieldENCaption,
						case
							when qsf.idfsParameter is not null
								then p_ref.[name]
							else sf_ref.[name]
						end as strFieldCaption
				from		tasQuerySearchField qsf
				inner join	(
							tasSearchField sf
							inner join	fnReference(@LangID, 19000080) sf_ref		-- 'rftSearchField'
							on			sf_ref.idfsReference = sf.idfsSearchField
							left join	fnReference('en', 19000080) sf_ref_en			-- 'rftSearchField'
							on			sf_ref_en.idfsReference = sf.idfsSearchField
							)
				on			sf.idfsSearchField = qsf.idfsSearchField
				and			qsf.blnShow = 1
				inner join	(
							tasQuerySearchObject qso
							inner join	tasSearchObject sob
							on			sob.idfsSearchObject = qso.idfsSearchObject
							inner join	trtBaseReference br_sob
							on			br_sob.idfsBaseReference = sob.idfsSearchObject
										and br_sob.intRowStatus = 0
							)
				on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
				inner join	tasQuery q
				on			q.idflQuery = qso.idflQuery
				left join	(
							ffParameter p
							inner join	(
								ffParameterType pt
								inner join	trtBaseReference br_pt
								on			br_pt.idfsBaseReference = pt.idfsParameterType
											and br_pt.intRowStatus = 0
										)
							on			pt.idfsParameterType = p.idfsParameterType
										and pt.intRowStatus = 0
							inner join	fnReference(@LangID, 19000066) p_ref	-- 'rftParameter'
							on			p_ref.idfsReference = p.idfsParameter
							left join	fnReference('en', 19000066) p_ref_en		-- 'rftParameter'
							on			p_ref_en.idfsReference = p.idfsParameter
							)
				on			p.idfsParameter = qsf.idfsParameter
							and p.idfsFormType = sob.idfsFormType
			)			sf
			on			fnsf.idfQuerySearchField = sf.idfQuerySearchField
						AND			l.idflQuery = sf.idflQuery
)

-- Layout search field caption
left join	
			fnLocalReference(@LangID) fnlfn -- Layout Field Name
on			fnlfn.idflBaseReference = lsf.idflLayoutSearchFieldName

-- adm unit field
left join	
(
						dbo.fnLayoutSearchFields(@LayoutID) fnsfu
			inner join	tasLayoutSearchField	lsfu
			on			fnsfu.idfQuerySearchField = lsfu.idfQuerySearchField
			AND			lsfu.idflLayout = @LayoutID
			
)
on			lsfu.idfLayoutSearchField = lsf.idfUnitLayoutSearchField


-- date field
left join	
(
			dbo.fnLayoutSearchFields(@LayoutID)	fnsfdt
			inner join	tasLayoutSearchField	lsfdt
			on			fnsfdt.idfQuerySearchField = lsfdt.idfQuerySearchField
			AND			lsfdt.idflLayout = @LayoutID
)
on			lsfdt.idfLayoutSearchField = lsf.idfDateLayoutSearchField
							
	


