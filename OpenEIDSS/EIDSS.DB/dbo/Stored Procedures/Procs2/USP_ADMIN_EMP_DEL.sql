
--=====================================================================================================
-- Created by:				Mandar Kulkarni
-- Description:				04/19/2017: Created based on V6 spPerson_Post: V7 USP

/*
----testing code:
DECLARE @idfPerson bigint
EXECUTE SP_ADMIN_EMP_DEL
  @idfPerson
*/

--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_EMP_DEL]
( 

	@idfPerson			BIGINT =NULL--##PARAM @idfPerson person ID
)
AS

DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0 
BEGIN
	BEGIN TRY  	
	BEGIN TRANSACTION
		BEGIN
			DELETE 
			FROM	tstObjectAccess 
			WHERE	idfActor = @idfPerson
		END

		BEGIN
			DELETE 
			FROM	tlbEmployeeGroupMember 
			WHERE	idfEmployee = @idfPerson
		END

		BEGIN
			DELETE 
			FROM	tlbPerson 
			WHERE	idfPerson = @idfPerson
		END
	
		BEGIN
			DELETE 
			FROM	tlbEmployee 
			WHERE	idfEmployee = @idfPerson
		END


		IF @@TRANCOUNT > 0 
			COMMIT  

		SELECT @returnCode, @returnMsg
	END TRY  

	BEGIN CATCH  

		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK

				SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()
				SELECT @returnCode, @returnMsg
			END

	END CATCH; 
END





