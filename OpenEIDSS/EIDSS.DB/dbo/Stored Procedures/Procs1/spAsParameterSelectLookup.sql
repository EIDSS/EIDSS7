

--##SUMMARY Select the list of parameters related to corresponding search fields.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 19.04.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:
exec spAsParameterSelectLookup 'en'

*/ 
 
create procedure	spAsParameterSelectLookup
	@LangID	as nvarchar(50),
	@FormType	as bigint = null,
	@ID			as bigint = null
as

select		sf.strSearchFieldAlias + '__' + 
			cast(p.idfsFormType as varchar(20)) + '__' + 
			cast(p.idfsParameter as varchar(20)) as FieldAlias,
			p.idfsFormType,
			ft_ref.[name] as FormTypeName,
			sob.idfsSearchObject,
			sf.idfsSearchField,
			sf.strSearchFieldAlias,
			p.idfsParameter,
			p_ref.[name] as ParameterName,
			p.idfsSection,
			p.idfsParameterCaption,
			p.idfsParameterType,
			pt.idfsReferenceType,
			p.idfsEditor,
			p.strNote,
			p.intOrder,
			p.intHACode,
			case	IsNull(p.idfsParameterType, -1)
				when	10071007	-- Numeric
					then	1
				when	10071061	-- Numeric Integer
					then	1
				when	10071059	-- Numeric Natural
					then	1
				when	10071060	-- Numeric Positive
					then	1
				when	10071029	-- Date
					then	7
				when	10071030	-- DateTime
					then	7
				when	10071025	-- Boolean
					then	8
				else		0		-- String
			end as TypeImageIndex,
			IsNull(
				cast(	(	select		IsNull(cast(d.idfsDiagnosis as varchar(20)), '') + ';' 
							from		ffParameterForTemplate pft
							inner join	ffFormTemplate t
								inner join	trtBaseReference br_t
								on			br_t.idfsBaseReference = t.idfsFormTemplate
											and br_t.intRowStatus = 0
							on			t.idfsFormTemplate = pft.idfsFormTemplate
										and t.intRowStatus = 0
							inner join	ffDeterminantValue dv
								inner join	trtBaseReference br_d
								on			br_d.idfsBaseReference = dv.idfsBaseReference
											and br_d.idfsReferenceType = 19000019	-- Diagnosis
											and br_d.intRowStatus = 0
								inner join	trtDiagnosis d
								on			d.idfsDiagnosis = br_d.idfsBaseReference
											and d.intRowStatus = 0
							on			dv.idfsFormTemplate = pft.idfsFormTemplate
										and dv.intRowStatus = 0

							left join	ffParameterForTemplate pft_ex
								inner join	ffFormTemplate t_ex
									inner join	trtBaseReference br_t_ex
									on			br_t_ex.idfsBaseReference = t_ex.idfsFormTemplate
												and br_t_ex.intRowStatus = 0
								on			t_ex.idfsFormTemplate = pft_ex.idfsFormTemplate
											and t_ex.intRowStatus = 0
								inner join	ffDeterminantValue dv_ex
									inner join	trtBaseReference br_d_ex
									on			br_d_ex.idfsBaseReference = dv_ex.idfsBaseReference
												and br_d_ex.idfsReferenceType = 19000019	-- Diagnosis
												and br_d_ex.intRowStatus = 0
									inner join	trtDiagnosis d_ex
									on			d_ex.idfsDiagnosis = br_d_ex.idfsBaseReference
												and d_ex.intRowStatus = 0
								on			dv_ex.idfsFormTemplate = pft_ex.idfsFormTemplate
											and dv_ex.intRowStatus = 0
							on			pft_ex.idfsParameter = p.idfsParameter
										and pft_ex.intRowStatus = 0
										and d_ex.idfsDiagnosis = d.idfsDiagnosis
										and pft_ex.idfsFormTemplate < pft.idfsFormTemplate
							where		pft.idfsParameter = p.idfsParameter
										and pft.intRowStatus = 0
										and pft_ex.idfsParameter is null
							for xml path('') 
						) as varchar(2000)
					),
				'') as DiagnosisString

from		(
	ffParameter p
	inner join	fnReference(@LangID, 19000066) p_ref		-- 'rftParameter'
	on			p_ref.idfsReference = p.idfsParameter
			)
Inner Join	ffParameterType pt 
	on			p.idfsParameterType = pt.idfsParameterType
				and pt.[intRowStatus] = 0    
inner join	(
	tasSearchObject sob
	inner join	trtBaseReference br_sob
	on			br_sob.idfsBaseReference = sob.idfsSearchObject
				and br_sob.intRowStatus = 0
	inner join	tasSearchField sf
	on			sf.idfsSearchObject = sob.idfsSearchObject
				and sf.idfsSearchFieldType = 10081003			-- FF Field
	inner join	trtBaseReference br_sf
	on			br_sf.idfsBaseReference = sf.idfsSearchField
				and br_sf.intRowStatus = 0
			)
on			sob.idfsFormType = p.idfsFormType
inner join	fnReference(@LangID, 19000034) ft_ref			-- 'rftFFType'
on			ft_ref.idfsReference = p.idfsFormType
where		p.intRowStatus = 0
			and (@FormType is null or p.idfsFormType = @FormType)
			and (@ID is null or p.idfsParameter = @ID)
order by	ft_ref.[name], p.idfsFormType, p.intOrder, p_ref.[name], p.idfsParameter




