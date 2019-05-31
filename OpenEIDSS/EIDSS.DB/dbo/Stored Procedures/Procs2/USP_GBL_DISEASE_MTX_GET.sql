/*******************************************************
NAME						: [USP_CONF_AggregateCaseMatrix_GetList]		


Description					: Retreives Entries For Human Aggregate Case Matrix

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					02/04/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_GBL_DISEASE_MTX_GET]
	
@idfsBaseReference							BIGINT = NULL,
@intHACode									BIGINT = NULL,
@strLanguageID								VARCHAR(5) = NULL
AS BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		Select t.idfsBaseReference,t.strDefault, d.strIDC10 --,[dbo].[FN_GBL_HACode_ToCSV]('en',intHaCode) as HaCodeAssociations
			FROM trtBaseReference t
			 JOIN  trtDiagnosis d  
				ON  t.idfsBaseReference = d.idfsDiagnosis
				WHERE t.idfsReferenceType = @idfsBaseReference -- Disease
			AND @intHACode in  (SELECT value from String_Split([dbo].[FN_GBL_HACode_ToCSV]('en',intHaCode),','))
			ORDER BY strDefault Asc
	END TRY
	BEGIN CATCH
			THROW;
	END CATCH
END

  

