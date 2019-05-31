--*************************************************************
-- Name 				: USP_GBL_STREET_SET
-- Description			: SET Address
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--DECLARE @strStreetName NVARCHAR(200)
--DECLARE @idfsSettlement NVARCHAR(36)

--EXECUTE [dbo].[USP_GBL_STREET_SET] 
--   @strStreetName
--  ,@idfsSettlement
--*/
CREATE PROCEDURE [dbo].[USP_GBL_STREET_SET]
(
	@strStreetName			NVARCHAR(200),  --##PARAM @strStreetName - street name
	@idfsSettlement			NVARCHAR(36),  --##PARAM @idfsSettlement - ID of settlement to which stree is belongs
	@idfStreet				BIGINT = NULL OUTPUT,
	@returnCode				INT = 0 OUTPUT,
	@returnMsg				NVARCHAR(max) = 'SUCCESS' OUTPUT
)
AS 
BEGIN
	SET @returnCode = 0
	BEGIN TRY
		IF (@idfsSettlement is NOT null) and (@strStreetName is NOT null) and (LEN(@strStreetName) > 0)
			BEGIN
				IF NOT EXISTS	(	SELECT	*	
									FROM	tlbStreet
									WHERE	idfsSettlement = @idfsSettlement
											and strStreetName = @strStreetName
											AND intRowStatus = 0
								)
				BEGIN
		
					IF @idfStreet IS NULL
					BEGIN
						EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbStreet', @idfStreet OUTPUT
					END

					INSERT INTO tlbStreet
						(
							idfStreet,
							idfsSettlement, 
							strStreetName 
						)
					VALUES
						(
							@idfStreet,
							@idfsSettlement, 
							@strStreetName 
						)
				END
			END
	
			SELECT @returnCode, @returnMsg
	END TRY
	BEGIN CATCH
		  SET @returnCode = ERROR_NUMBER()
		  SET @returnMsg = ERROR_MESSAGE()

		  SELECT @returnCode, @returnMsg
	END CATCH

END



