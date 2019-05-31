
----------------------------------------------------------------------------
-- Name 				: USP_VCTS_VecSession_SET
-- Description			: INSERT/UPDATE Vector Surveillance Session
--          
-- Author               : Maheshwar Deo
-- 
-- Revision History
-- Name				Date		Change Detail
-- Mark Wilson    10-Nov-2017   Convert EIDSS 6 to EIDSS 7 standards AND 
--                              changes calls to:
--                              
--                              USP_GBL_NEWID_GET call
--                              USP_GBL_NextNumber_GET
--                              
--                              Edited to pass 'Vector Surveillance Session' to
--                              USP_GBL_NextNumber_GET instead of hard-coded 
--                              idfs Value.
--
-- Harold Pryor  04-Apr-2018    Updated number of parameters being passed to dbo.USP_GBL_NEXTKEYID_GET from three to just two.   
-- Harold Pryor  05-Apr-2018    Updated to call dbo.USSP_GBL_ADDRESS_SET replacing dbo.USP_GBL_ADDRESS_SET.
-- Harold Pryor  08-May-2018    Updated to include @idfsGroundType,  @dblDistance, and @dblDirection input parameters
-- Harold Pryor  09-May-2018    Updated to @vectorInsstrApartment, @vectorInsstrBuildin, @vectorInsstrStreetName, 
--                               vectorInsstrHouse   vectorInsstrHouse, @vectorInsidfsPostalCode input parameters.
-- Harold Pryor  31-May-2018    Updated to return @idfVectorSurveillanceSession, @strSessionID in output
-- Harold Pryor  04-June-2018   Updated to properly save Vector Surveillance Session record for foreign location where @vectorInsidfsCountry is only location parameter
-- Harold Pryor  05-June-2018   Updated to add @idfsResidentType input parameter to pass to dbo.USSP_GBL_ADDRESS_SET for processing of exact, relative, and foreign location types
-- Harold Pryor  07-June-2018   Updated to replace @idfsResidentType with @idfsGeolocationType as input parameter to pass to dbo.USSP_GBL_ADDRESS_SET for processing of exact, relative, foreign and national location types
--
-- Testing code:
/*
--Example of procedure call:

*/
CREATE PROCEDURE [dbo].[USP_VCTS_VecSession_SET]
(
	@idfVectorSurveillanceSession	BIGINT OUTPUT,
	@strSessionID					NVARCHAR(50) OUTPUT,
	@strFieldSessionID				NVARCHAR(50),
	@idfsVectorSurveillanceStatus	BIGINT,
	@datStartDate					DATETIME,
	@datCloseDate					DATETIME = null,
	@idfOutbreak					BIGINT = null,
	@strDescription					NVARCHAR(500) = null,
	@intCollectionEffort			INT,
	@datModificationForArchiveDate	DATETIME = NULL,
	@idfGeoLocation					BIGINT OUTPUT,  -- #Params for Address SP
	@idfsGeolocationType            BIGINT = NULL,
	@vectorInsidfsCountry			BIGINT = NULL,
	@vectorInsidfsRegion			BIGINT = NULL,
	@vectorInsidfsRayon				BIGINT = NULL,
	@vectorInsidfsSettlement		BIGINT = NULL,
	@AddressType					BIT = 0,
	@ForeignAddressType				NVARCHAR(200) null,
    @vectorInsstrLatitude			FLOAT = NULL,--##PARAM dblLatitude - Latitude 
    @vectorInsstrLongitude			FLOAT = NULL,--##PARAM dblLongitude  - Longitude 
	@blnGeoLocationShared			BIT = 0,  --must be 0 if @idfGeoLocation is null
	@idfsGroundType                 BIGINT = NULL, --##PARAM idfsGroundType  - GroundType 
	@dblDistance			        FLOAT = NULL, --##PARAM dblDistance - Distance
	@dblDirection			        FLOAT = NULL  --##PARAM dblDirection - Accuracy
)
AS
DECLARE @returnCode INT = 0;
DECLARE @returnMsg  NVARCHAR(max) = 'SUCCESS'

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			-- SET the Address 
			-- Insert or Update location record only if required information is passed to the SP
			IF (@vectorInsidfsCountry IS NOT NULL) OR (@vectorInsidfsRegion IS NOT NULL) 
			BEGIN
				EXECUTE dbo.USSP_GBL_ADDRESS_SET
											@idfGeoLocation OUTPUT,
											NULL,
											@idfsGroundType,
											@idfsGeolocationType,
											@vectorInsidfsCountry,
											@vectorInsidfsRegion,
											@vectorInsidfsRayon,
											@vectorInsidfsSettlement,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											@dblDistance,
											@vectorInsstrLatitude,
											@vectorInsstrLongitude,
											@dblDirection,
											NULL,
											@AddressType,
											@ForeignAddressType,
											@blnGeoLocationShared,
											@returnCode OUTPUT,
											@returnMsg OUTPUT
			END
			IF @returnCode = 0
				IF NOT EXISTS ( SELECT idfVectorSurveillanceSession 
								FROM	dbo.tlbVectorSurveillanceSession
								WHERE  idfVectorSurveillanceSession = @idfVectorSurveillanceSession 
							 )
					BEGIN
						BEGIN
							EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbVectorSurveillanceSession', @idfVectorSurveillanceSession OUTPUT
						END

						BEGIN
							EXEC dbo.USP_GBL_NextNumber_GET 'Vector Surveillance Session', @strSessionID OUTPUT, NULL--N'AS Session'
						END
				
						BEGIN
							INSERT 
							INTO	dbo.tlbVectorSurveillanceSession
									(idfVectorSurveillanceSession, 
									strSessionID, 
									strFieldSessionID, 
									idfsVectorSurveillanceStatus, 
									datStartDate, 
									datCloseDate, 
									idfLocation, 
									idfOutbreak, 
									strDescription,
									intCollectionEffort,
									datModificationForArchiveDate
									)
							 VALUES
									(@idfVectorSurveillanceSession, 
									@strSessionID, 
									@strFieldSessionID, 
									@idfsVectorSurveillanceStatus, 
									@datStartDate, 
									@datCloseDate, 
									@idfGeoLocation, 
									@idfOutbreak, 
									@strDescription,
									@intCollectionEffort,
									GETDATE()
									)
					  END 
					END
  				ELSE IF @returnCode = 0
					  BEGIN					        
							UPDATE	dbo.tlbVectorSurveillanceSession
							SET		--strSessionID =	@strSessionID, 
									strFieldSessionID = @strFieldSessionID, 
									idfsVectorSurveillanceStatus = @idfsVectorSurveillanceStatus, 
									datStartDate = @datStartDate, 
									datCloseDate = @datCloseDate, 
									--idfLocation = @idfGeoLocation, 
									idfOutbreak = @idfOutbreak, 
									strDescription = @strDescription, 
									intCollectionEffort = @intCollectionEffort,
									datModificationForArchiveDate = GETDATE()
							WHERE	idfVectorSurveillanceSession = @idfVectorSurveillanceSession

					  END
			IF @@TRANCOUNT > 0 AND @returnCode  = 0
				COMMIT
			SELECT @idfVectorSurveillanceSession, @strSessionID
	END TRY

	BEGIN CATCH
		BEGIN 
			IF @@TRANCOUNT  > 0 
				ROLLBACK

			SET @returnCode = ERROR_NUMBER()
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SELECT @returnCode, @returnMsg
		END

	END CATCH
END -- Stored Proc END


