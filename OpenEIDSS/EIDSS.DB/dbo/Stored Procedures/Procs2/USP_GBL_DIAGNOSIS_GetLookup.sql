
--=====================================================================================================
-- Author:					Joan Li
-- Description:				06/20/2017: Created based on V6 spDiagnosis_SelectLookup :  V7 USP68
--							Get lookup data from tables: trtDiagnosis;trtDiagnosisToDiagnosisGroup.
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Joan Li			06/20/2017 Initial release.
-- Stephen Long     05/22/2018 Renamed and re-factored to standard.
-- 
-- Test Code:
-- exec usp_GBL_Diagnosis_GetLookup 'en', 32, 10020001 -- 'dutStandardCase' (10020001, 10020002)
-- Related Fact Data From:
-- select distinct idfsusingtype  from trtDiagnosis  
-- select * from trtDiagnosisToDiagnosisGroup
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_DIAGNOSIS_GetLookup] 
(
	@LangID					NVARCHAR(50),
	@HACode					INT = NULL,  --Bit mask that defines area where diagnosis are used (human, livestock or avian)
	@DiagnosisUsingType		BIGINT = NULL --standard or aggregate
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @returnMsg		VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode		BIGINT = 0;

	BEGIN TRY
		SELECT				trtDiagnosis.idfsDiagnosis, 
							d.name,
							trtDiagnosis.strIDC10,
							trtDiagnosis.strOIECode, 
							d.intHACode,
							d.intRowStatus,
							blnZoonotic,
							CASE WHEN blnZoonotic = 1 THEN stYes.name ELSE stNo.name END AS strZoonotic,
							diagnosesGroup.idfsDiagnosisGroup,
							diagnosesGroup.strDiagnosesGroupName
	FROM					dbo.fnReferenceRepair(@LangID, 19000019) d
	INNER JOIN				dbo.trtDiagnosis
	ON						trtDiagnosis.idfsDiagnosis = d.idfsReference
	LEFT JOIN				dbo.fnReference(@LangID, 19000100) stYes
	ON						stYes.idfsReference = 10100001
	LEFT JOIN				dbo.fnReference(@LangID, 19000100) stNo
	ON						stNo.idfsReference = 10100002
	OUTER APPLY 
	( 
		SELECT TOP			1 
							d_to_dg.idfsDiagnosisGroup, dg.[name] AS strDiagnosesGroupName
		FROM				dbo.trtDiagnosisToDiagnosisGroup d_to_dg
		INNER JOIN			dbo.fnReferenceRepair('en', 19000156) dg
		ON					dg.idfsReference = d_to_dg.idfsDiagnosisGroup
		WHERE				d_to_dg.intRowStatus = 0
		AND					d_to_dg.idfsDiagnosis = trtDiagnosis.idfsDiagnosis
		ORDER BY			d_to_dg.idfDiagnosisToDiagnosisGroup ASC 
	) AS diagnosesGroup
	WHERE
							(@HACode = 0 OR @HACode IS NULL OR d.intHACode IS NULL OR (d.intHACode & @HACode) > 0)
	AND						(@DiagnosisUsingType IS NULL OR trtDiagnosis.idfsDiagnosis IS NULL OR trtDiagnosis.idfsUsingType = @DiagnosisUsingType)
	ORDER BY				d.intOrder, d.name;

	SELECT					@returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		BEGIN
			SET				@returnCode = ERROR_NUMBER();
			SET				@returnMsg = 'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
								+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
								+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
								+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
								+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
								+ ' ErrorMessage: ' + ERROR_MESSAGE();

			SELECT			@returnCode, @returnMsg;
		END
	END CATCH;
END

