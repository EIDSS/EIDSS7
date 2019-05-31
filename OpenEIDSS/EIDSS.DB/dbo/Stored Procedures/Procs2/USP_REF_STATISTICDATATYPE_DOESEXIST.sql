-- ============================================================================
-- Name: USP_REF_STATISTICDATATYPE_DOESEXIST
-- Description:	Check to see if a statistical data type currently exists by name
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss     10/30/2018 Initial release.

-- exec USP_REF_STATISTICDATATYPE_DOESEXIST 'Population'
-- exec USP_REF_STATISTICDATATYPE_DOESEXIST 'Test'
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_STATISTICDATATYPE_DOESEXIST]
(
	@strName nvarchar(50)
)as

	DECLARE @returnMsg			VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode			BIGINT = 0;
BEGIN
	BEGIN TRY
	Declare @exists bit
	Declare @idfsReferenceType bigint = (Select idfsReferenceType from trtReferenceType where strReferenceTypeName = 'Statistical Data Type')
		IF EXISTS(SELECT idfsBaseReference from trtBaseReference where strDefault = @strName AND idfsReferenceType = @idfsReferenceType)
			BEGIN
				Select @exists = 1

				Select @exists as DoesExist
			END
			ELSE
			BEGIN
				Select @exists = 0

				Select @exists as DoesExist

			END
		SELECT						@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH		
	BEGIN
			SET					@returnCode = ERROR_NUMBER();
			SET					@returnMsg = 'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
									+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
									+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
									+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
									+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE(), ''))
									+ ' ErrorMessage: ' + ERROR_MESSAGE();

			SELECT				@returnCode, @returnMsg;
		END

	END CATCH
END
