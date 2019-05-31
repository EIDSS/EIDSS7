
--*************************************************************
-- Name: [USP_OMM_Session_GetList]
-- Description: Insert/Update for Campaign Monitoring Session
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_OMM_Session_Note_GetList]
(    
	@LangID			nvarchar(50),
	@idfOutbreak	BIGINT
)
AS

BEGIN    

	DECLARE	@returnCode								INT = 0;
	DECLARE @returnMsg								NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		
		SELECT 
			idfOutbreakNote,
			idfOutbreak,
			NoteRecordUID,
			strNote,
			datNoteDate,
			OBN.idfPerson,
			P.strFirstName + ' ' + P.strFamilyName AS UserName,
			B.strDefault AS Organization,
			OBN.intRowStatus,
			OBN.rowguid,
			OBN.strMaintenanceFlag,
			OBN.strReservedAttribute,
			UpdatePriorityID,
			UP.strDefault AS UpdatePriority,
			UpdateRecordTitle,
			Coalesce(UploadFileName,'') AS UploadFileName,
			UploadFileDescription,
			CASE UploadFileName WHEN Coalesce(UploadFileName,'') THEN 'View' ELSE '' END AS FileView
		FROM
			tlbOutbreakNote OBN
		INNER JOIN		tlbPerson P
		ON P.idfPerson = OBN.idfPerson
		INNER JOIN		tlbOffice O
		ON O.idfOffice = P.idfInstitution
		INNER JOIN		trtBaseReference B
		ON B.idfsBaseReference = O.idfsOfficeAbbreviation
		INNER JOIN		trtBaseReference UP
		ON UP.idfsBaseReference = OBN.UpdatePriorityID
		WHERE
			idfOutbreak = @idfOutbreak AND
			OBN.intRowStatus = 0

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;
		
		--SET		@returnCode = ERROR_NUMBER();
		--SET		@returnMsg = 
		--			'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
		--			+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
		--			+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
		--			+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
		--			+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
		--			+ ' ErrorMessage: '+ ERROR_MESSAGE();

		throw;
	END CATCH

	SELECT @returnCode as ReturnCode, @returnMsg as ReturnMsg

END