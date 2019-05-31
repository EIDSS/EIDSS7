--*************************************************************
-- Name 				:	USP_GBL_GEOLOCATION_COPY
-- Description			:	IF recordd with @idfGeoLocationCopy doesn't exist, new record with this ID IS created
--							IF Original location recORd doesn't exist the empty record with @idfGeoLocationCopy IS created
--          
-- AuthOR               :	Mandar Kulkarni
-- Revision HistORy
--		Name       Date       Change Detail
--     Lamont Mitchell 1/11/19 Aliased Return Columns and added Throw to Catch Block
--Example of a call of procedure:
--DECLARE @RC int
--DECLARE @idfGeoLocation bigint
--DECLARE @idfGeoLocationCopy bigint
--SET @idfGeoLocation = 123890000000
--SET @idfGeoLocationCopy = 1

--EXECUTE @RC = sUSP_GBL_GEOLOCATION_COPY
--   @idfGeoLocation
--  ,@idfGeoLocationCopy
--  ,1
  
-- delete dbo.tflGeoLocationFiltered WHERE idfGeoLocation = 1
-- delete dbo.tlbGeoLocation WHERE idfGeoLocation = 1
-- delete dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = 1
--*************************************************************
CREATE PROCEDURE [dbo].[USP_GBL_GEOLOCATION_COPY]
(
  @idfGeoLocation			AS BIGINT, --##PARAM idfGeoLocation - ID of ORiginal geolocation recORd
  @idfGeoLocationCopy		AS BIGINT, --##PARAM idfGeoLocationCopy - ID of geolocation recORd to which ORignal geolocation data will be copied
  @blnGlobalCopyAsDefault	AS BIT = 0,
  @returnCode				INT = 0 OUTPUT,
  @returnMsg				NVARCHAR(max) = 'SUCCESS' OUTPUT

)
AS
DECLARE @blnGlobaloriginal	BIT
DECLARE @blnGlobalCopy		BIT
BEGIN
	BEGIN TRY

			IF @blnGlobalCopyAsDefault = 1 
				BEGIN
					IF NOT EXISTS(SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfGeoLocationCopy)
						BEGIN
							INSERT INTO tlbGeoLocationShared  
									(idfGeoLocationShared)
							VALUES	(@idfGeoLocationCopy)
							SET @blnGlobaloriginal = 0
						END
				END
			ELSE
				BEGIN
					IF NOT EXISTS(SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfGeoLocationCopy)
						BEGIN
							INSERT INTO tlbGeoLocation  
									(idfGeoLocation)
							VALUES	(@idfGeoLocationCopy)
							SET @blnGlobaloriginal = 1
						END
				END	
			--IF EXISTS(SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfGeoLocation)
			--	SET @blnGlobaloriginal = 1
			--ELSE
			--	BEGIN
			--		IF EXISTS(SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfGeoLocation)
			--			SET @blnGlobaloriginal = 0
			--		ELSE
			--			BEGIN
			--				IF @blnGlobalCopyAsDefault = 1 
			--					BEGIN
			--						IF NOT EXISTS(SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfGeoLocationCopy)
			--							BEGIN
			--								INSERT INTO tlbGeoLocationShared  
			--										(idfGeoLocationShared)
			--								VALUES	(@idfGeoLocationCopy)
			--								SELECT @returnCode = -10
			--								SELECT @returnMsg = 'Failed to copy geolocation'
			--							END
			--					END
			--				ELSE
			--					BEGIN
			--						IF NOT EXISTS(SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfGeoLocationCopy)
			--							BEGIN
			--								INSERT INTO tlbGeoLocation  
			--										(idfGeoLocation)
			--								VALUES	(@idfGeoLocationCopy)
			--								SELECT @returnCode = -10
			--								SELECT @returnMsg = 'Failed to copy geolocation'
			--							END
			--					END	
			--			END
			--	END

			IF NOT @blnGlobaloriginal = 1
				BEGIN
					IF EXISTS(SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfGeoLocationCopy)
						UPDATE new 
						   SET 
								idfsGroundType = old.idfsGroundType
								,idfsGeoLocationType = old.idfsGeoLocationType
								,idfsCountry = old.idfsCountry
								,idfsRegion = old.idfsRegion
								,idfsRayon = old.idfsRayon
								,idfsSettlement = old.idfsSettlement
								,strDescription = old.strDescription
								,dblDistance = old.dblDistance
								,dblLatitude = old.dblLatitude
								,dblLongitude = old.dblLongitude
								,dblAccuracy = old.dblAccuracy
								,dblAlignment = old.dblAlignment
								,strApartment = old.strApartment
								,strBuilding = old.strBuilding
								,strStreetName = old.strStreetName
								,strHouse = old.strHouse
								,strPostCode = old.strPostCode
								,idfsResidentType = old.idfsResidentType
						FROM tlbGeoLocation old
						INNER JOIN tlbGeoLocation new ON
							new.idfGeoLocation = @idfGeoLocationCopy
							AND
							(
								ISNULL(new.idfsGroundType,0) != ISNULL(old.idfsGroundType,0)
								OR ISNULL(new.idfsGeoLocationType,0) != ISNULL(old.idfsGeoLocationType,0)
								OR ISNULL(new.idfsCountry,0) != ISNULL(old.idfsCountry,0)
								OR ISNULL(new.idfsRegion,0) != ISNULL(old.idfsRegion,0)
								OR ISNULL(new.idfsRayon,0) != ISNULL(old.idfsRayon,0)
								OR ISNULL(new.idfsSettlement,0) != ISNULL(old.idfsSettlement,0)
								OR ISNULL(new.strDescription,'') != ISNULL(old.strDescription,'')
								OR ISNULL(new.dblDistance,0) != ISNULL(old.dblDistance,0)
								OR ISNULL(new.dblLatitude,0) != ISNULL(old.dblLatitude,0)
								OR ISNULL(new.dblLongitude,0) != ISNULL(old.dblLongitude,0)
								OR ISNULL(new.dblAccuracy,0) != ISNULL(old.dblAccuracy,0)
								OR ISNULL(new.dblAlignment,0) != ISNULL(old.dblAlignment,0)
								OR ISNULL(new.strApartment,'') != ISNULL(old.strApartment,'')
								OR ISNULL(new.strBuilding,'') != ISNULL(old.strBuilding,'')
								OR ISNULL(new.strStreetName,'') != ISNULL(old.strStreetName,'')
								OR ISNULL(new.strHouse,'') != ISNULL(old.strHouse,'')
								OR ISNULL(new.strPostCode,'') != ISNULL(old.strPostCode,'')
								OR ISNULL(new.idfsResidentType,0) != ISNULL(old.idfsResidentType,0)
							)
						WHERE 
							old.idfGeoLocation = @idfGeoLocation
					ELSE IF EXISTS(SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfGeoLocationCopy)
						UPDATE new 
						   SET 
								idfsGroundType = old.idfsGroundType
								,idfsGeoLocationType = old.idfsGeoLocationType
								,idfsCountry = old.idfsCountry
								,idfsRegion = old.idfsRegion
								,idfsRayon = old.idfsRayon
								,idfsSettlement = old.idfsSettlement
								,strDescription = old.strDescription
								,dblDistance = old.dblDistance
								,dblLatitude = old.dblLatitude
								,dblLongitude = old.dblLongitude
								,dblAccuracy = old.dblAccuracy
								,dblAlignment = old.dblAlignment
								,strApartment = old.strApartment
								,strBuilding = old.strBuilding
								,strStreetName = old.strStreetName
								,strHouse = old.strHouse
								,strPostCode = old.strPostCode
								,idfsResidentType = old.idfsResidentType
						FROM tlbGeoLocation old
						INNER JOIN dbo.tlbGeoLocationShared new ON
							new.idfGeoLocationShared = @idfGeoLocationCopy
							AND
							(
								ISNULL(new.idfsGroundType,0) != ISNULL(old.idfsGroundType,0)
								OR ISNULL(new.idfsGeoLocationType,0) != ISNULL(old.idfsGeoLocationType,0)
								OR ISNULL(new.idfsCountry,0) != ISNULL(old.idfsCountry,0)
								OR ISNULL(new.idfsRegion,0) != ISNULL(old.idfsRegion,0)
								OR ISNULL(new.idfsRayon,0) != ISNULL(old.idfsRayon,0)
								OR ISNULL(new.idfsSettlement,0) != ISNULL(old.idfsSettlement,0)
								OR ISNULL(new.strDescription,'') != ISNULL(old.strDescription,'')
								OR ISNULL(new.dblDistance,0) != ISNULL(old.dblDistance,0)
								OR ISNULL(new.dblLatitude,0) != ISNULL(old.dblLatitude,0)
								OR ISNULL(new.dblLongitude,0) != ISNULL(old.dblLongitude,0)
								OR ISNULL(new.dblAccuracy,0) != ISNULL(old.dblAccuracy,0)
								OR ISNULL(new.dblAlignment,0) != ISNULL(old.dblAlignment,0)
								OR ISNULL(new.strApartment,'') != ISNULL(old.strApartment,'')
								OR ISNULL(new.strBuilding,'') != ISNULL(old.strBuilding,'')
								OR ISNULL(new.strStreetName,'') != ISNULL(old.strStreetName,'')
								OR ISNULL(new.strHouse,'') != ISNULL(old.strHouse,'')
								OR ISNULL(new.strPostCode,'') != ISNULL(old.strPostCode,'')
								OR ISNULL(new.idfsResidentType,0) != ISNULL(old.idfsResidentType,0)
							)
						WHERE 
							old.idfGeoLocation = @idfGeoLocation
					ELSE IF @blnGlobalCopyAsDefault = 1
						INSERT INTO dbo.tlbGeoLocationShared
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
									,strApartment
									,strBuilding
									,strStreetName
									,strHouse
									,strPostCode
									,idfsResidentType
								   )
							SELECT
									@idfGeoLocationCopy
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
									,strApartment
									,strBuilding
									,strStreetName
									,strHouse
									,strPostCode
									,idfsResidentType
							FROM tlbGeoLocation
							WHERE
								idfGeoLocation = @idfGeoLocation
					ELSE
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
									,strApartment
									,strBuilding
									,strStreetName
									,strHouse
									,strPostCode
									,idfsResidentType
								   )
							SELECT
									@idfGeoLocationCopy
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
									,strApartment
									,strBuilding
									,strStreetName
									,strHouse
									,strPostCode
									,idfsResidentType
							FROM tlbGeoLocation
							WHERE
								idfGeoLocation = @idfGeoLocation
				END
			ELSE
				BEGIN
						IF EXISTS(SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfGeoLocationCopy)
							UPDATE new 
							   SET 
									idfsGroundType = old.idfsGroundType
									,idfsGeoLocationType = old.idfsGeoLocationType
									,idfsCountry = old.idfsCountry
									,idfsRegion = old.idfsRegion
									,idfsRayon = old.idfsRayon
									,idfsSettlement = old.idfsSettlement
									,strDescription = old.strDescription
									,dblDistance = old.dblDistance
									,dblLatitude = old.dblLatitude
									,dblLongitude = old.dblLongitude
									,dblAccuracy = old.dblAccuracy
									,dblAlignment = old.dblAlignment
									,strApartment = old.strApartment
									,strBuilding = old.strBuilding
									,strStreetName = old.strStreetName
									,strHouse = old.strHouse
									,strPostCode = old.strPostCode
									,idfsResidentType = old.idfsResidentType
							FROM dbo.tlbGeoLocationShared old
							INNER JOIN tlbGeoLocation new ON
								new.idfGeoLocation = @idfGeoLocationCopy
							WHERE 
								old.idfGeoLocationShared = @idfGeoLocation
								AND
								(
									ISNULL(new.idfsGroundType,0) != ISNULL(old.idfsGroundType,0)
									OR ISNULL(new.idfsGeoLocationType,0) != ISNULL(old.idfsGeoLocationType,0)
									OR ISNULL(new.idfsCountry,0) != ISNULL(old.idfsCountry,0)
									OR ISNULL(new.idfsRegion,0) != ISNULL(old.idfsRegion,0)
									OR ISNULL(new.idfsRayon,0) != ISNULL(old.idfsRayon,0)
									OR ISNULL(new.idfsSettlement,0) != ISNULL(old.idfsSettlement,0)
									OR ISNULL(new.strDescription,'') != ISNULL(old.strDescription,'')
									OR ISNULL(new.dblDistance,0) != ISNULL(old.dblDistance,0)
									OR ISNULL(new.dblLatitude,0) != ISNULL(old.dblLatitude,0)
									OR ISNULL(new.dblLongitude,0) != ISNULL(old.dblLongitude,0)
									OR ISNULL(new.dblAccuracy,0) != ISNULL(old.dblAccuracy,0)
									OR ISNULL(new.dblAlignment,0) != ISNULL(old.dblAlignment,0)
									OR ISNULL(new.strApartment,'') != ISNULL(old.strApartment,'')
									OR ISNULL(new.strBuilding,'') != ISNULL(old.strBuilding,'')
									OR ISNULL(new.strStreetName,'') != ISNULL(old.strStreetName,'')
									OR ISNULL(new.strHouse,'') != ISNULL(old.strHouse,'')
									OR ISNULL(new.strPostCode,'') != ISNULL(old.strPostCode,'')
									OR ISNULL(new.idfsResidentType,0) != ISNULL(old.idfsResidentType,0)
								)
						ELSE IF EXISTS(SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfGeoLocationCopy)
							UPDATE new 
							   SET 
									idfsGroundType = old.idfsGroundType
									,idfsGeoLocationType = old.idfsGeoLocationType
									,idfsCountry = old.idfsCountry
									,idfsRegion = old.idfsRegion
									,idfsRayon = old.idfsRayon
									,idfsSettlement = old.idfsSettlement
									,strDescription = old.strDescription
									,dblDistance = old.dblDistance
									,dblLatitude = old.dblLatitude
									,dblLongitude = old.dblLongitude
									,dblAccuracy = old.dblAccuracy
									,dblAlignment = old.dblAlignment
									,strApartment = old.strApartment
									,strBuilding = old.strBuilding
									,strStreetName = old.strStreetName
									,strHouse = old.strHouse
									,strPostCode = old.strPostCode
									,idfsResidentType = old.idfsResidentType
							FROM tlbGeoLocationShared old
							INNER JOIN dbo.tlbGeoLocationShared new ON
								new.idfGeoLocationShared = @idfGeoLocationCopy
							WHERE 
								old.idfGeoLocationShared = @idfGeoLocation
								AND
								(
									ISNULL(new.idfsGroundType,0) != ISNULL(old.idfsGroundType,0)
									OR ISNULL(new.idfsGeoLocationType,0) != ISNULL(old.idfsGeoLocationType,0)
									OR ISNULL(new.idfsCountry,0) != ISNULL(old.idfsCountry,0)
									OR ISNULL(new.idfsRegion,0) != ISNULL(old.idfsRegion,0)
									OR ISNULL(new.idfsRayon,0) != ISNULL(old.idfsRayon,0)
									OR ISNULL(new.idfsSettlement,0) != ISNULL(old.idfsSettlement,0)
									OR ISNULL(new.strDescription,'') != ISNULL(old.strDescription,'')
									OR ISNULL(new.dblDistance,0) != ISNULL(old.dblDistance,0)
									OR ISNULL(new.dblLatitude,0) != ISNULL(old.dblLatitude,0)
									OR ISNULL(new.dblLongitude,0) != ISNULL(old.dblLongitude,0)
									OR ISNULL(new.dblAccuracy,0) != ISNULL(old.dblAccuracy,0)
									OR ISNULL(new.dblAlignment,0) != ISNULL(old.dblAlignment,0)
									OR ISNULL(new.strApartment,'') != ISNULL(old.strApartment,'')
									OR ISNULL(new.strBuilding,'') != ISNULL(old.strBuilding,'')
									OR ISNULL(new.strStreetName,'') != ISNULL(old.strStreetName,'')
									OR ISNULL(new.strHouse,'') != ISNULL(old.strHouse,'')
									OR ISNULL(new.strPostCode,'') != ISNULL(old.strPostCode,'')
									OR ISNULL(new.idfsResidentType,0) != ISNULL(old.idfsResidentType,0)
								)
						ELSE IF @blnGlobalCopyAsDefault = 1
							INSERT INTO dbo.tlbGeoLocationShared
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
										,strApartment
										,strBuilding
										,strStreetName
										,strHouse
										,strPostCode
										,idfsResidentType
									   )
								SELECT
										@idfGeoLocationCopy
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
										,strApartment
										,strBuilding
										,strStreetName
										,strHouse
										,strPostCode
										,idfsResidentType
								FROM tlbGeoLocationShared
								WHERE
									idfGeoLocationShared = @idfGeoLocation
						ELSE
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
										,strApartment
										,strBuilding
										,strStreetName
										,strHouse
										,strPostCode
										,idfsResidentType
									   )
								SELECT
										@idfGeoLocationCopy
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
										,strApartment
										,strBuilding
										,strStreetName
										,strHouse
										,strPostCode
										,idfsResidentType
								FROM tlbGeoLocationShared
								WHERE
									idfGeoLocationShared = @idfGeoLocation
					END

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'

	END TRY
	BEGIN CATCH
	THROW;

	END CATCH
END


