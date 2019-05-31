/*******************************************************
NAME						: [USP_CONF_AggregateCaseMatrix_GetList]		


Description					: Retreives Entries For Human Aggregate Case Matrix

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					02/04/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_HumanAggregateCaseMatrix_GET]
	
@idfsBaseReference							BIGINT = NULL,
@intHACode									BIGINT = NULL,
@strLanguageID								VARCHAR(5) = NULL
AS BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		Select t.idfsBaseReference,t.strDefault, d.strIDC10 
			FROM trtBaseReference t
			Left JOIN  trtDiagnosis d  
				ON  t.idfsBaseReference = d.idfsDiagnosis
		WHERE t.intHACode = @intHACode AND t.idfsReferenceType = @idfsBaseReference
	
	END TRY
	BEGIN CATCH
			THROW;
	END CATCH
END

  

