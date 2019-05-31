
--*************************************************************
-- Name: [USP_OMM_Session_Note_GetDetail]
-- Description: Insert/Update for Outbreak Session Note
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_OMM_Session_Note_GetDetail]
(    
	@LangID				nvarchar(50),
	@idfOutbreakNote	BIGINT
)
AS

BEGIN    

	DECLARE	@returnCode								INT = 0;
	DECLARE @returnMsg								NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		
		SELECT
			idfOutbreakNote,
			idfOutbreak,
			strNote,
			datNoteDate,
			obn.idfPerson,
			P.strFirstName + ' ' + P.strFamilyName AS UserName,
			B.strDefault As Organization,
			obn.intRowStatus,
			obn.strMaintenanceFlag,
			obn.strReservedAttribute,
			UpdatePriorityID,
			UpdateRecordTitle,
			UploadFileName,
			UploadFileDescription,
			UploadFileObject
		FROM		
			tlbOutbreakNote obn
		INNER JOIN tlbPerson P
		ON P.idfPerson = obn.idfPerson
		INNER JOIN tlbOffice O
		ON O.idfOffice = P.idfInstitution
		INNER JOIN trtBaseReference B
		ON B.idfsBaseReference = O.idfsOfficeAbbreviation
		where 
			idfOutbreakNote =	@idfOutbreakNote

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;
		
		SET		@returnCode = ERROR_NUMBER();
		SET		@returnMsg = 
					'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
					+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
					+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
					+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
					+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
					+ ' ErrorMessage: '+ ERROR_MESSAGE();

		
	END CATCH

	SELECT @returnCode as ReturnCode, @returnMsg as ReturnMsg
END