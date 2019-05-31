

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 14.09.09
-- Description:	Return list of Parameters
-- =============================================
CREATE PROCEDURE dbo.spFFGetParametersSearch 
(
	@LangID Nvarchar(50) = NULL
	,@strSearch Nvarchar(200) = NULL
	,@strSearchSection NVARCHAR(200) = NULL
)	
AS
BEGIN	
	SET NOCOUNT ON;

	IF @LangID IS NULL SET @LangID = 'en';
	DECLARE @langid_int BIGINT
	SET @langid_int = dbo.fnGetLanguageCode(@LangID);
	

	DECLARE @searchCriteria NVARCHAR(100);
	SET @searchCriteria = '%' + @strSearch + '%';	
	
	DECLARE @searchCriteriaSection NVARCHAR(100);
	SET @searchCriteriaSection = '%' + @strSearchSection + '%';
	
	
	
	SELECT
		fp.idfsParameter
		, fp.idfsSection
		, fp.idfsFormType AS idfsFFormType
		, tbr_param.strDefault AS DefaultName
		, tbr_paramcap.strDefault AS DefaultLongName
		, ISNULL(tsnt_param.strTextString, tbr_param.strDefault) AS NationalName
		, ISNULL(tsnt_paramcap.strTextString, tbr_paramcap.strDefault) AS NationalLongName	
		, ISNULL(ref_fftype.[name], ref_fftype.strDefault) 
						+ ISNULL(' > ' + fullpath.FullPathStr, '') + ' > ' 
						+ COALESCE(tsnt_param.strTextString, tbr_param.strDefault) COLLATE database_default AS FullPathStr
		, CAST(idfsFormType AS VARCHAR(20)) 
						+ ISNULL(';' + fullpath.FullPathIdfs, '') + ';' 
						+ CAST(fp.idfsParameter As Varchar(20)) AS FullPathIdfs
	FROM [dbo].[ffParameter] fp
	
	OUTER APPLY dbo.fnFFGetFullPathBySections(@LangID, fp.idfsSection) fullpath
	JOIN dbo.fnReference(@LangID,  19000034/*'rftFFType'*/) ref_fftype ON
		ref_fftype.idfsReference = fp.idfsFormType
		
	JOIN dbo.trtBaseReference tbr_param ON
		tbr_param.idfsBaseReference = fp.idfsParameter
		AND tbr_param.intRowStatus = 0
	LEFT JOIN dbo.trtStringNameTranslation tsnt_param ON
		tsnt_param.idfsBaseReference = fp.idfsParameter 
		AND tsnt_param.idfsLanguage = @langid_int 
		AND tsnt_param.intRowStatus = 0
	LEFT JOIN dbo.trtBaseReference tbr_paramcap ON
		tbr_paramcap.idfsBaseReference = fp.idfsParameterCaption 
		AND tbr_paramcap.intRowStatus = 0
	LEFT JOIN dbo.trtStringNameTranslation tsnt_paramcap ON
		tsnt_paramcap.[idfsBaseReference] = fp.idfsParameterCaption
		AND tsnt_paramcap.idfsLanguage = @langid_int 
		AND tsnt_paramcap.intRowStatus = 0
	WHERE
		fp.intRowStatus = 0
		AND
		(
			tbr_param.[strDefault] LIKE @searchCriteria
			OR tbr_paramcap.[strDefault] LIKE @searchCriteria
			OR tsnt_param.[strTextString] LIKE @searchCriteria
			OR tsnt_paramcap.[strTextString] LIKE @searchCriteria
			OR @strSearch IS NULL			
		)
		AND
		(
			@searchCriteriaSection IS NULL
			OR fullpath.FullPathStr LIKE @searchCriteriaSection
		)
	ORDER BY ISNULL(ref_fftype.[name], ref_fftype.strDefault) 
							+ ISNULL(' > ' + fullpath.FullPathStr, '') + ' > ' 
							+ COALESCE(tsnt_param.strTextString, tbr_param.strDefault) COLLATE database_default ASC
End

