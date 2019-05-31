
--*************************************************************
-- Name 				: USP_GBL_LKUP_OutBreak_GetList
-- Description			: List filered values from tlbBaseReferene table
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
-- EXEC USP_GBL_LKUP_OutBreak_GetList 'en'
--*************************************************************

CREATE PROCEDURE [dbo].[USP_GBL_LKUP_OutBreak_GetList] 

	@LangID	NVARCHAR(50)		

AS

	DECLARE @ReturnMsg VARCHAR(MAX)
	SELECT @ReturnMsg = ''
	DECLARE @ReturnCode BIGINT

	BEGIN TRY  	

		SELECT 
			idfOutbreak
			,strOutbreakID
			,datStartDate
			,datFinishDate
			,strDiagnosisOrDiagnosisGroup
			,idfsDiagnosisOrDiagnosisGroup
			,strDiagnosisGroup
			,idfsDiagnosisGroup
			,strOutbreakStatus
			,idfsOutbreakStatus
			,idfGeoLocation
			,strGeoLocationName
			,strPatientName
			,strHumanPatientName
			,strFarmOwner
		 FROM 
			dbo.FN_GBL_LKUP_OutBreak_GetList(@LangId)

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

			SELECT @returnCode, @ReturnMsg
		END

	END CATCH; 

