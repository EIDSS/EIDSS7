



--##SUMMARY Selects lookup list of specific Type
--##SUMMARY Used by Lookup Cache for populating base reference lookups
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use


/*
--Example of procedure call:

EXECUTE spVectorSubType_SelectLookup
   'en'
  ,6963040000000
  ,NULL
*/


CREATE     PROCEDURE spVectorSubType_SelectLookup 
	@LangID	nvarchar(50),  --##PARAM @LangID - language ID
	@VectorTypeID bigint = null,  --##PARAM @@VectorTypeID - ID of specific vector type to be filter populated records. If NULL entire lookup list is populated
	@ID bigint = null  --##PARAM @ID - ID of specific record in trtBaseReference to be populated. If NULL entire lookup list is populated
AS
select
			IsNull(ROW_NUMBER() OVER (ORDER BY br.idfsBaseReference,vst.idfsVectorType),0)   as id,
			br.idfsBaseReference, 
			IsNull(snt.strTextString, br.strDefault) as [name],
			br.strDefault, 
			br.intOrder,
			vst.idfsVectorType,
			vst.intRowStatus,
			IsNull(snt_vt.strTextString, br_vt.strDefault) as strVectorType

from		trtVectorSubType vst
inner join	trtBaseReference br
on			br.idfsBaseReference = vst.idfsVectorSubType
			and br.idfsReferenceType = 19000141	-- Vector Sub Type
			and br.intRowStatus = 0
inner join	trtVectorType vt
	inner join	trtBaseReference br_vt
	on			br_vt.idfsBaseReference = vt.idfsVectorType
				and br_vt.idfsReferenceType = 19000140	-- Vector Type
				and br_vt.intRowStatus = 0
on			vt.idfsVectorType = vst.idfsVectorType
			and vt.intRowStatus = 0
left join	dbo.trtStringNameTranslation snt 
on			snt.idfsBaseReference = br.idfsBaseReference 
			and snt.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
left join	dbo.trtStringNameTranslation snt_vt 
on			snt_vt.idfsBaseReference = vt.idfsVectorType
			and snt_vt.idfsLanguage = dbo.fnGetLanguageCode(@LangID)

where		vst.intRowStatus = 0 
			and (@VectorTypeID IS NULL OR vst.idfsVectorType = @VectorTypeID)
			and (@ID IS NULL OR vst.idfsVectorSubType = @ID)
order by	IsNull(br.intOrder, 0), [name]




