--**********************/*************************************************
-- Name 				: USP_GBL_LKUP_FFPARAMETERFIXEDPRESETVALUE_GETList
-- Description			: Set the Vector Sessions Summary
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
-- EXEC USP_GBL_LKUP_FFPARAMETERFIXEDPRESETVALUE_GETList idfsParameterType, 'en'
-- To get feeding status  EXEC USP_GBL_LKUP_FFPARAMETERFIXEDPRESETVALUE_GETList 6707190000000, 'en'
-- To get life stages	  EXEC USP_GBL_LKUP_FFPARAMETERFIXEDPRESETVALUE_GETList 6707200000000, 'en'
--***********************************************************************
CREATE PROCEDURE [dbo].[USP_GBL_LKUP_FFPARAMETERFIXEDPRESETVALUE_GETList]
(	
	@idfsParameterType Bigint = Null
	,@LangID Nvarchar(50) = Null
)	
AS
BEGIN	
	SET NOCOUNT ON;
	DECLARE @ReturnMsg VARCHAR(MAX)  = 'SUCCESS'
	DECLARE @ReturnCode BIGINT = 0

	BEGIN TRY  	

		IF (@LangID IS NULL) 
			SET @LangID = 'en'
	
		SELECT 
				FPV.idfsParameterFixedPresetValue 
				,FPV.idfsParameterType
				,FR.strDefault AS [DefaultName]
				,ISNULL(FR.LongName, FR.strDefault) AS [NationalName]
				,@LangID AS [langid]
				,FR.intOrder
		FROM	dbo.ffParameterFixedPresetValue FPV
		INNER JOIN dbo.fnReference(@LangID, 19000069 /*'rftParametersFixedPresetValue'*/) FR 
		ON		 FPV.idfsParameterFixedPresetValue = FR.idfsReference
		WHERE	 (FPV.idfsParameterType = @idfsParameterType OR @idfsParameterType IS NULL) 
		AND		 FPV.intRowStatus = 0
		ORDER BY [intOrder],[NationalName]

		SELECT @returnCode, @ReturnMsg

	END TRY  

	BEGIN CATCH 

		BEGIN
			SET @ReturnCode = ERROR_NUMBER()
			SET @ReturnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

		END

	END CATCH;
END

