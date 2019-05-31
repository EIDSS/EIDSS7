

CREATE FUNCTION [dbo].[FN_Rpt_List]
(
	@ReportName	NVARCHAR(4000)
	,@LangID	VARCHAR(36)
)

RETURNS @T TABLE(idfsBaseReference	BIGINT
				,idfsReferenceType	BIGINT
				,DiagnosisDesc		NVARCHAR(4000)
				,ICD10				NVARCHAR(400)
				,RowOrder			INT
				)

AS

BEGIN

	DECLARE	@idfsCustomReportType			BIGINT
			,@idfsReportDiagnosisReference	BIGINT
			,@idfsDiagnosisType				BIGINT
			,@idfsLanguage					BIGINT

	IF EXISTS(SELECT idfsBaseReference From trtBaseReference Where strDefault = @ReportName)

		BEGIN

			--Get Report Id
			SET @idfsCustomReportType = (SELECT TOP 1 idfsBaseReference From trtBaseReference Where strDefault = @ReportName )
			
			--Seed data. The ID's should not change
			SET @idfsReportDiagnosisReference = 19000130
			SET @idfsDiagnosisType = 19000019

			SET @idfsLanguage = dbo.fnGetLanguageCode(@LangID)		

			INSERT INTO @T

			--Diagnosis Group query
			SELECT
				trtBaseReference.idfsBaseReference
				,trtBaseReference.idfsReferenceType
				,CASE @LangID
					WHEN 'EN' THEN trtBaseReference.strDefault
					ELSE
						CASE ISNULL(trtStringNameTranslation.strTextString, '')
							WHEN '' THEN trtBaseReference.strDefault
							ELSE trtStringNameTranslation.strTextString
					END
				 END As [DiagnosisDesc]
				,trtReportDiagnosisGroup.strCode As [ICD10]
				,trtReportRows.intRowOrder As [RowOrder]
			FROM
				trtReportRows
				INNER JOIN trtReportDiagnosisGroup On
					trtReportRows.idfsDiagnosisOrReportDiagnosisGroup = trtReportDiagnosisGroup.idfsReportDiagnosisGroup
					AND
					ISNULL(trtReportDiagnosisGroup.intRowStatus, 0) = 0
				INNER JOIN trtBaseReference On
					trtReportDiagnosisGroup.idfsReportDiagnosisGroup = trtBaseReference.idfsBaseReference
					AND
					trtBaseReference.idfsReferenceType = @idfsReportDiagnosisReference
				LEFT JOIN trtStringNameTranslation ON 
					trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference
					AND 
					trtStringNameTranslation.idfsLanguage = @idfsLanguage
			WHERE
				trtReportRows.idfsCustomReportType = @idfsCustomReportType

			UNION ALL

			--Diagnosis query
			SELECT
				trtBaseReference.idfsBaseReference
				,trtBaseReference.idfsReferenceType
				,CASE @LangID
					WHEN 'EN' THEN trtBaseReference.strDefault
					ELSE
						CASE ISNULL(trtStringNameTranslation.strTextString, '')
							WHEN '' THEN trtBaseReference.strDefault
							ELSE trtStringNameTranslation.strTextString
					END
				 END As [DiagnosisDesc]
				,trtDiagnosis.strIDC10 As [ICD10]
				,trtReportRows.intRowOrder As [RowOrder]
			FROM
				trtReportRows
				Inner Join trtDiagnosis On
					trtReportRows.idfsDiagnosisOrReportDiagnosisGroup = trtDiagnosis.idfsDiagnosis
					And
					IsNull(trtDiagnosis.intRowStatus, 0) = 0
				Inner Join trtBaseReference On
					trtDiagnosis.idfsDiagnosis = trtBaseReference.idfsBaseReference
					And
					trtBaseReference.idfsReferenceType = @idfsDiagnosisType
				LEFT JOIN trtStringNameTranslation ON 
					trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference
					AND 
					trtStringNameTranslation.idfsLanguage = @idfsLanguage
			WHERE
				trtReportRows.idfsCustomReportType = @idfsCustomReportType

			ORDER BY
				trtReportRows.intRowOrder
		END 

	RETURN

END

