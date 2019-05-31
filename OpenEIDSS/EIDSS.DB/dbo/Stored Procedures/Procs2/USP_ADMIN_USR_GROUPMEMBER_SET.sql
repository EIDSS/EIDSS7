

--*************************************************************
-- Name 				: USP_ADMIN_USR_GROUPMEMBER_SET
-- Description			: Get list of employees
--          
-- Author               : Maheshwar Deo
-- Revision History
--	Name				Date			Change Detail
--	Steven Verner		04.09.2019		Ensure Role membership is updated in ASPNetUserRoles table.
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_ADMIN_USR_GROUPMEMBER_SET]
(
	 @idfEmployeeGroup BIGINT = NULL, -- required for delete, update
	 @idfEmployee BIGINT = NULL -- required for insert
)
AS

DECLARE 
	 @returnCode INT = 0 
	,@returnMsg	NVARCHAR(MAX) = 'SUCCESS' 
	,@idfUserID BIGINT
	,@aspNetUserID NVARCHAR(128)
	,@aspNetRoleID NVARCHAR(128)

BEGIN

	BEGIN TRY
	BEGIN TRANSACTION

	IF NOT EXISTS ( SELECT * FROM dbo.tlbEmployeeGroupMember WHERE idfEmployeeGroup = @idfEmployeeGroup AND idfEmployee = @idfEmployee)
		BEGIN
			INSERT 
			INTO	dbo.tlbEmployeeGroupMember
					(
						idfEmployeeGroup,
						idfEmployee
					)
			VALUES
					(
						@idfEmployeeGroup,
						@idfEmployee
					)
		END
	ELSE
	   BEGIN
			UPDATE	tlbEmployeeGroupMember
			SET		intRowStatus = 0
			WHERE	idfEmployeeGroup = @idfEmployeeGroup 
			AND		idfEmployee = @idfEmployee
		END

		IF @@TRANCOUNT > 0 
		  COMMIT

		SELECT @returnCode, @returnMsg

	END TRY  

	BEGIN CATCH 

		SET @returnMsg = 
			'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
			+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
			+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()

		SET @returnCode = ERROR_NUMBER()

		SELECT @returnCode, @returnMsg

	END CATCH
END

