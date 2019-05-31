--*************************************************************
-- Name 				: USP_GBL_GEOLOCATION_SET
-- Description			: Set Address
--          
-- Author               : MANDar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:

/*
--Example of a call of procedure:
DECLARE @idfGeoLocation BIGINT
DECLARE @idfsGroundType BIGINT
DECLARE @idfsGeoLocationType BIGINT
DECLARE @idfsCountry BIGINT
DECLARE @idfsRegion BIGINT
DECLARE @idfsRayon BIGINT
DECLARE @idfsSettlement BIGINT
DECLARE @strDescription NVARCHAR(200)
DECLARE @dblDistance FLOAT
DECLARE @dblLatitude FLOAT
DECLARE @dblLongitude FLOAT
DECLARE @dblAccuracy FLOAT
DECLARE @dblAlignment FLOAT
declare @blnGeoLocationShared bit

-- TODO: Set parameter values here.

EXECUTE dbo.USP_GBL_GEOLOCATION_SET
   @idfGeoLocation
  ,@idfsGroundType
  ,@idfsGeoLocationType
  ,@idfsCountry
  ,@idfsRegion
  ,@idfsRayon
  ,@idfsSettlement
  ,@strDescription
  ,@dblDistance
  ,@dblLatitude
  ,@dblLongitude
  ,@dblAccuracy
  ,@dblAlignment
  ,@blnGeoLocationShared
*/


CREATE PROCEDURE [dbo].[USP_GBL_GEOLOCATION_SET_NEW]
(
	@idfGeoLocation			BIGINT OUTPUT--##PARAM idfGeoLocation - ID of geolocation record
    ,@idfsGroundType		BIGINT --##PARAM idfsGroundType - ID of ground Type for relative location
    ,@idfsGeoLocationType	BIGINT --##PARAM idfsGeoLocationType - ID geolocation Type (can point to ExactPoint or Relative geolocation Type
    ,@idfsCountry			BIGINT --##PARAM idfsCountry - ID of country
    ,@idfsRegion			BIGINT --##PARAM idfsRegion - ID of region
    ,@idfsRayon				BIGINT --##PARAM idfsRayon - ID rayon
    ,@idfsSettlement		BIGINT --##PARAM idfsSettlement - ID of settlement (for Relative location only)
    ,@strDescription		NVARCHAR(200) --##PARAM strDescription - free text description of reolocation record
    ,@dblLatitude			FLOAT --##PARAM dblLatitude - Latitude (for ExactPoint location only)
    ,@dblLongitude			FLOAT --##PARAM dblLongitude  - Longitude (for ExactPoint location only)
    ,@dblRelLatitude		FLOAT --##PARAM dblRelLatitude - calcualted Latitude (for RelativePoint location only)
    ,@dblRelLongitude		FLOAT --##PARAM dblRelLongitude  - calcualted Longitude (for RelativePoint location only)
    ,@dblAccuracy			FLOAT --##PARAM dblAccuracy - Accuracy of all other numeric data in the geolocation record
    ,@dblDistance			FLOAT --##PARAM dblDistance - distance (in kilometers) from settlement to relative point (for Relative location only)
    ,@dblAlignment			FLOAT --##PARAM dblAlignment - azimuth (in degrees) of direction from settlement to relative point(for Relative location only)
    ,@strForeignAddress 	NVARCHAR(200)
    ,@blnGeoLocationShared 	BIT = 0
	,@IsReturnCodesDisabled BIT = 0
)
AS
DECLARE @returnCode			INT = 0;
DECLARE @returnMsg			NVARCHAR(max) = 'SUCCESS'
DECLARE @strAddressString	NVARCHAR(max)
BEGIN
	BEGIN TRY

			IF EXISTS(SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfGeoLocation)
				BEGIN
					UPDATE [dbo].[tlbGeoLocation]
					SET [idfsGroundType] = @idfsGroundType
						,[idfsGeoLocationType] = @idfsGeoLocationType
						,[idfsCountry] = @idfsCountry
						,[idfsRegion] = @idfsRegion
						,[idfsRayon] = @idfsRayon
						,[idfsSettlement] = @idfsSettlement
						,[strDescription] = @strDescription
						,[dblDistance] = @dblDistance
						,[dblLatitude] = CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLatitude ELSE @dblRelLatitude END
						,[dblLongitude] = CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLongitude ELSE @dblRelLongitude END
						,[dblAccuracy] = @dblAccuracy
						,[dblAlignment] = @dblAlignment
						,strForeignAddress = @strForeignAddress
						,blnForeignAddress = CASE WHEN @idfsGeoLocationType = 10036001 THEN 1 ELSE 0 END
					 WHERE idfGeoLocation = @idfGeoLocation
					AND
						(
							ISNULL([idfsGroundType],0) != ISNULL(@idfsGroundType,0)
							OR ISNULL([idfsGeoLocationType],0) != ISNULL(@idfsGeoLocationType,0)
							OR ISNULL([idfsCountry],0) != ISNULL(@idfsCountry,0)
							OR ISNULL([idfsRegion],0) != ISNULL(@idfsRegion,0)
							OR ISNULL([idfsRayon],0) != ISNULL(@idfsRayon,0)
							OR ISNULL([idfsSettlement],0) != ISNULL(@idfsSettlement,0)
							OR ISNULL([strDescription],'') != ISNULL(@strDescription,'')
							OR ISNULL([dblDistance],0) != ISNULL(@dblDistance,0)
							OR ISNULL([dblLatitude],0) != ISNULL(CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLatitude ELSE @dblRelLatitude END,0)
							OR ISNULL([dblLongitude],0) != ISNULL(CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLongitude ELSE @dblRelLongitude END,0)
							OR ISNULL([dblAccuracy],0) != ISNULL(@dblAccuracy,0)
							OR ISNULL([dblAlignment],0) != ISNULL(@dblAlignment,0)
							OR ISNULL(strForeignAddress,0) != ISNULL(@strForeignAddress,0)
						)
				END
			ELSE
				IF EXISTS(SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfGeoLocation)
					BEGIN
						UPDATE [dbo].[tlbGeoLocationShared]
						SET [idfsGroundType] = @idfsGroundType
							,[idfsGeoLocationType] = @idfsGeoLocationType
							,[idfsCountry] = @idfsCountry
							,[idfsRegion] = @idfsRegion
							,[idfsRayon] = @idfsRayon
							,[idfsSettlement] = @idfsSettlement
							,[strDescription] = @strDescription
							,[dblDistance] = @dblDistance
							,[dblLatitude] = CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLatitude ELSE @dblRelLatitude END
							,[dblLongitude] = CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLongitude ELSE @dblRelLongitude END
							,[dblAccuracy] = @dblAccuracy
							,[dblAlignment] = @dblAlignment
							,strForeignAddress = @strForeignAddress
							,blnForeignAddress = CASE WHEN @idfsGeoLocationType = 10036001 THEN 1 ELSE 0 END
						 WHERE idfGeoLocationShared = @idfGeoLocation
						AND
							(
								ISNULL([idfsGroundType],0) != ISNULL(@idfsGroundType,0)
								OR ISNULL([idfsGeoLocationType],0) != ISNULL(@idfsGeoLocationType,0)
								OR ISNULL([idfsCountry],0) != ISNULL(@idfsCountry,0)
								OR ISNULL([idfsRegion],0) != ISNULL(@idfsRegion,0)
								OR ISNULL([idfsRayon],0) != ISNULL(@idfsRayon,0)
								OR ISNULL([idfsSettlement],0) != ISNULL(@idfsSettlement,0)
								OR ISNULL([strDescription],'') != ISNULL(@strDescription,'')
								OR ISNULL([dblDistance],0) != ISNULL(@dblDistance,0)
								OR ISNULL([dblLatitude],0) != ISNULL(CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLatitude ELSE @dblRelLatitude END,0)
								OR ISNULL([dblLongitude],0) != ISNULL(CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLongitude ELSE @dblRelLongitude END,0)
								OR ISNULL([dblAccuracy],0) != ISNULL(@dblAccuracy,0)
								OR ISNULL([dblAlignment],0) != ISNULL(@dblAlignment,0)
								OR ISNULL(strForeignAddress,0) != ISNULL(@strForeignAddress,0)
							)
					END
			ELSE
				IF ISNULL(@blnGeoLocationShared, 0) <> 1
					BEGIN
						EXECUTE [dbo].[USP_GBL_NEXTKEYID_GET_NEW] 'tlbGeoLocation', @idfGeoLocation OUTPUT, @IsReturnCodesDisabled

						INSERT INTO tlbGeoLocation
								   (
									   idfGeoLocation
									  ,idfsGroundType
									  ,idfsGeoLocationType
									  ,idfsCountry
									  ,idfsRegion
									  ,idfsRayon
									  ,idfsSettlement
									  ,strDescription
									  ,dblDistance
									  ,dblLatitude
									  ,dblLongitude
									  ,dblAccuracy
									  ,dblAlignment
									  ,strForeignAddress
									  ,blnForeignAddress
								   )
							 VALUES
								   (
									   @idfGeoLocation
									  ,@idfsGroundType
									  ,@idfsGeoLocationType
									  ,@idfsCountry
									  ,@idfsRegion
									  ,@idfsRayon
									  ,@idfsSettlement
									  ,@strDescription
									  ,@dblDistance
									  ,CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLatitude ELSE @dblRelLatitude END
									  ,CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLongitude ELSE @dblRelLongitude END
									  ,@dblAccuracy
									  ,@dblAlignment
									  ,@strForeignAddress
									  ,CASE WHEN @idfsGeoLocationType = 10036001 THEN 1 ELSE 0 END
									)
					END
			ELSE	
				BEGIN
					EXECUTE [dbo].[USP_GBL_NEXTKEYID_GET_NEW] 'tlbGeoLocationShared', @idfGeoLocation OUTPUT, @IsReturnCodesDisabled
					INSERT INTO tlbGeoLocationShared
							   (
								   idfGeoLocationShared
								  ,idfsGroundType
								  ,idfsGeoLocationType
								  ,idfsCountry
								  ,idfsRegion
								  ,idfsRayon
								  ,idfsSettlement
								  ,strDescription
								  ,dblDistance
								  ,dblLatitude
								  ,dblLongitude
								  ,dblAccuracy
								  ,dblAlignment
								  ,strForeignAddress
								  ,blnForeignAddress
							   )
						 VALUES
							   (
								   @idfGeoLocation
								  ,@idfsGroundType
								  ,@idfsGeoLocationType
								  ,@idfsCountry
								  ,@idfsRegion
								  ,@idfsRayon
								  ,@idfsSettlement
								  ,@strDescription
								  ,@dblDistance
								  ,CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLatitude ELSE @dblRelLatitude END
								  ,CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLongitude ELSE @dblRelLongitude END
								  ,@dblAccuracy
								  ,@dblAlignment
								  ,@strForeignAddress
								  ,CASE WHEN @idfsGeoLocationType = 10036001 THEN 1 ELSE 0 END
								)
				END

				if @IsReturnCodesDisabled = 0
				SELECT @returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		  SET @returnCode = ERROR_NUMBER()
		  SET @returnMsg = ERROR_MESSAGE()

		  if @IsReturnCodesDisabled = 0
		  SELECT @returnCode,	 @returnMsg;
	END CATCH
END








