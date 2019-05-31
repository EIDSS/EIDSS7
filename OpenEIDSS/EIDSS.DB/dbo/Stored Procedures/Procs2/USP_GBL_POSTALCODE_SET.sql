--*************************************************************
-- Name 				: USP_GBL_POSTALCODE_SET
-- Description			: SET Postal Code
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
--   @strStreetName,
--   @idfsSettlement,
--	 @idfPostalCode OUTPUT,
--	 @returnCode OUTPUT,
--   @returnMsg
--*/

CREATE PROCEDURE [dbo].[USP_GBL_POSTALCODE_SET]
(
	@strPostCode	NVARCHAR(200),
	@idfsSettlement BIGINT,
	@idfPostalCode	BIGINT = NULL OUTPUT,
	@returnCode		INT = 0 OUTPUT,
	@returnMsg		NVARCHAR(max) = 'SUCCESS' OUTPUT
)
AS
BEGIN
	BEGIN TRY
			IF (@idfsSettlement is not null) and (@strPostCode is not null) and (len(@strPostCode) > 0)
			BEGIN
				IF not exists	(	SELECT	*	
									FROM	tlbPostalCode
									WHERE	idfsSettlement = @idfsSettlement
											and strPostCode = @strPostCode
											AND intRowStatus = 0
								)
				BEGIN
		
					IF @idfPostalCode IS NULL
					BEGIN
						EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbPostalCode',  @idfPostalCode OUTPUT
					END
		
					INSERT INTO tlbPostalCode
						(
							idfPostalCode,
							idfsSettlement, 
							strPostCode 
						)
					VALUES
						(
							@idfPostalCode,
							@idfsSettlement, 
							@strPostCode 
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



