
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterReferenceTypes_GETDetail
-- Description: Details of Selected Prameter Reference Types
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterReferenceTypes_GETDetail] 
(
	@LangID NVARCHAR(50) = NULL
	,@idfsReferenceType BIGINT
)	
AS
BEGIN	
	SET NOCOUNT ON;

	IF (@LangID IS NULL)
		SET @LangID = 'en';

	DECLARE
		@returnCode BIGINT,
		@returnMsg NVARCHAR(MAX),
		@langid_int BIGINT       
	
	BEGIN TRY
		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);

		DECLARE @ResultTable TABLE 
		(
			[idfsBaseReference] BIGINT	
			,[idfsReferenceType] BIGINT		
			,[DefaultName] NVARCHAR(4000)
			,[NationalName]	NVARCHAR(4000)	
			,[langid] NVARCHAR(50)
		)
	
		IF (@idfsReferenceType <> 19000019)
			BEGIN
				INSERT INTO @ResultTable
				(
					[idfsBaseReference]	
					,[idfsReferenceType]		
					,[DefaultName]
					,[NationalName]
					,[langid]
				)
				SELECT R.idfsReference AS [idfsBaseReference]
					   ,R.idfsReferenceType			
					   ,R.strDefault As [DefaultName]
					   ,ISNULL(R.[name], R.strDefault) AS [NationalName]		
					   ,@LangID AS [langid]	
				FROM dbo.FN_GBL_Reference_List_GET(@LangID, @idfsReferenceType) R	
				ORDER BY R.[name]			
			END 
		ELSE
			BEGIN
				INSERT INTO @ResultTable
				(
					[idfsBaseReference]	
					,[idfsReferenceType]		
					,[DefaultName]
					,[NationalName]
					,[langid]
				)
				SELECT R.idfsReference AS [idfsBaseReference]
					   ,R.idfsReferenceType			
					   ,R.strDefault AS [DefaultName]
					   ,ISNULL(R.[name], R.strDefault) AS [NationalName]		
					   ,@LangID AS [langid]	
				FROM dbo.FN_GBL_Reference_List_GET(@LangID, @idfsReferenceType) R
				INNER JOIN dbo.trtDiagnosis D
				ON R.idfsReference = D.idfsDiagnosis 
				   AND D.intRowStatus = 0 
				   AND D.idfsUsingType = 10020001 
				ORDER BY R.[name]    	
			END
	
		SELECT [idfsBaseReference]	
			   ,[idfsReferenceType]		
			   ,[DefaultName]
			   ,[NationalName]
			   ,[langid]
		FROM @ResultTable	
	
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
