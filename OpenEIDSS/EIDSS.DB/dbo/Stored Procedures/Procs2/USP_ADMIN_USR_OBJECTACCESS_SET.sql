
--*************************************************************
-- Name 				: USP_ADMIN_USR_OBJECTACCESS_SET
-- Description			: SET object access
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_ADMIN_USR_OBJECTACCESS_SET]
(
	@idfObjectAccess		BIGINT OUTPUT,
	@idfsObjectOperation	AS BIGINT = NULL,
	@idfsObjectType			BIGINT 	= NULL,
	@idfsObjectID			BIGINT	= NULL,	
	@idfEmployee			BIGINT,
	@isAllow				BIT = 0,
	@isDeny					BIT = 0
)
AS 

DECLARE @returnCode		INT = 0 
DECLARE	@returnMsg		NVARCHAR(MAX) = 'SUCCESS' 
DECLARE @intPermission int
BEGIN

	IF (@isDeny = 0) AND (@isAllow = 0) SET @intPermission = 0;
	IF (@isDeny = 1) AND (@isAllow = 0) SET @intPermission = 1;
	IF (@isDeny = 0) AND (@isAllow = 1) SET @intPermission = 2;

	IF (ISNULL(@idfsObjectOperation,0)=0)
	BEGIN
	    RAISERROR('parameter @idfsObjectOperation is required for add/modify',18,0)
	    RETURN
	END

	IF (ISNULL(@idfsObjectType,0)=0)
	BEGIN
     	RAISERROR('parameter @idfsObjectType is required for add/modify',18,0)
	    RETURN
  	END

	IF (ISNULL(@idfsObjectID,0)=0)
	BEGIN
	    RAISERROR('parameter @idfsObjectID is required for add/modify',18,0)
	    RETURN
	END
	
	BEGIN TRY
	BEGIN TRANSACTION
		-- @idfObjectAccess > 0 for real records in tstObjectAccess for current actor AND site.
		-- if @idfObjectAccess < 0 record is virtual (created from default access permission record) 
		-- AND new record (with newly generated idfObjectAccess) shall be inserted.

		IF @idfObjectAccess > 0 AND NOT EXISTS(SELECT Top 1 1 From dbo.tstObjectAccess WHERE idfObjectAccess = @idfObjectAccess AND intRowStatus = 0)
			BEGIN --Insert
    			BEGIN
					EXEC dbo.USP_GBL_NEXTKEYID_GET 'tstObjectAccess', @idfObjectAccess OUTPUT
				END

				BEGIN			
					  INSERT 
					  INTO	tstObjectAccess
						  (
							idfObjectAccess,
							idfsObjectType,
							idfsObjectID,
							idfsObjectOperation,
							idfActor,
							intPermission,
							idfsOnSite
						  )
					  VALUES
						  (
							 @idfObjectAccess,
							 @idfsObjectType,
							 @idfsObjectID,
							 @idfsObjectOperation,
							 @idfEmployee,
							 @intPermission,			
							 dbo.FN_GBL_PERMISSIONSITE()
						   )
				END
			END 
		ELSE
			BEGIN
				UPDATE	tstObjectAccess
				SET		intPermission = @intPermission
				WHERE	 idfObjectAccess = @idfObjectAccess AND intRowStatus = 0
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
