
--##SUMMARY Copies values from one geolocation record to another one.
--##SUMMARY If record with @idfGeoLocationCopy doesn't exist, new record with this ID is created
--##SUMMARY If original location record doesn't exist the empty record with @idfGeoLocationCopy is created

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 07.11.2009

--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 17.07.2011

--##RETURNS 0 if record was successfully copied
--##RETURNS -1 if original record doesn't exist


/*
--Example of a call of procedure:
DECLARE @RC int
DECLARE @idfGeoLocation bigint
DECLARE @idfGeoLocationCopy bigint
SET @idfGeoLocation = 123890000000
SET @idfGeoLocationCopy = 1

EXECUTE @RC = spGeoLocation_CreateCopy
   @idfGeoLocation
  ,@idfGeoLocationCopy
  ,1
  
  --delete dbo.tflGeoLocationFiltered where idfGeoLocation = 1
  --delete dbo.tlbGeoLocation where idfGeoLocation = 1
  --delete dbo.tlbGeoLocationShared where idfGeoLocationShared = 1
  
*/


CREATE         PROCEDURE [dbo].[spGeoLocation_CreateCopy](
	   @idfGeoLocation as bigint --##PARAM idfGeoLocation - ID of original geolocation record
      ,@idfGeoLocationCopy as bigint --##PARAM idfGeoLocationCopy - ID of geolocation record to which orignal geolocation data will be copied
      ,@blnGlobalCopyAsDefault as bit = 0
)
AS
declare @blnGlobalOriginal bit
declare @blnGlobalCopy bit

if @idfGeoLocationCopy is null
	return -1

IF EXISTS(SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfGeoLocation)
	SET @blnGlobalOriginal = 0
ELSE
BEGIN
	IF EXISTS(SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfGeoLocation)
		SET @blnGlobalOriginal = 1
	ELSE
	BEGIN
		IF @blnGlobalCopyAsDefault = 1 
		BEGIN
			IF NOT EXISTS(SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfGeoLocationCopy)
			BEGIN
				INSERT INTO tlbGeoLocationShared  
						(idfGeoLocationShared)
				VALUES	(@idfGeoLocationCopy)
				RETURN -1
			END
		END
		ELSE
		BEGIN
			IF NOT EXISTS(SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfGeoLocationCopy)
			BEGIN
				INSERT INTO tlbGeoLocation  
						(idfGeoLocation)
				VALUES	(@idfGeoLocationCopy)
				RETURN -1
			END
		END	
	END
END

IF NOT @blnGlobalOriginal = 1
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
			and
			(
				isnull(new.idfsGroundType,0) != isnull(old.idfsGroundType,0)
				or isnull(new.idfsGeoLocationType,0) != isnull(old.idfsGeoLocationType,0)
				or isnull(new.idfsCountry,0) != isnull(old.idfsCountry,0)
				or isnull(new.idfsRegion,0) != isnull(old.idfsRegion,0)
				or isnull(new.idfsRayon,0) != isnull(old.idfsRayon,0)
				or isnull(new.idfsSettlement,0) != isnull(old.idfsSettlement,0)
				or isnull(new.strDescription,'') != isnull(old.strDescription,'')
				or isnull(new.dblDistance,0) != isnull(old.dblDistance,0)
				or isnull(new.dblLatitude,0) != isnull(old.dblLatitude,0)
				or isnull(new.dblLongitude,0) != isnull(old.dblLongitude,0)
				or isnull(new.dblAccuracy,0) != isnull(old.dblAccuracy,0)
				or isnull(new.dblAlignment,0) != isnull(old.dblAlignment,0)
				or isnull(new.strApartment,'') != isnull(old.strApartment,'')
				or isnull(new.strBuilding,'') != isnull(old.strBuilding,'')
				or isnull(new.strStreetName,'') != isnull(old.strStreetName,'')
				or isnull(new.strHouse,'') != isnull(old.strHouse,'')
				or isnull(new.strPostCode,'') != isnull(old.strPostCode,'')
				or isnull(new.idfsResidentType,0) != isnull(old.idfsResidentType,0)
			)
		Where 
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
			and
			(
				isnull(new.idfsGroundType,0) != isnull(old.idfsGroundType,0)
				or isnull(new.idfsGeoLocationType,0) != isnull(old.idfsGeoLocationType,0)
				or isnull(new.idfsCountry,0) != isnull(old.idfsCountry,0)
				or isnull(new.idfsRegion,0) != isnull(old.idfsRegion,0)
				or isnull(new.idfsRayon,0) != isnull(old.idfsRayon,0)
				or isnull(new.idfsSettlement,0) != isnull(old.idfsSettlement,0)
				or isnull(new.strDescription,'') != isnull(old.strDescription,'')
				or isnull(new.dblDistance,0) != isnull(old.dblDistance,0)
				or isnull(new.dblLatitude,0) != isnull(old.dblLatitude,0)
				or isnull(new.dblLongitude,0) != isnull(old.dblLongitude,0)
				or isnull(new.dblAccuracy,0) != isnull(old.dblAccuracy,0)
				or isnull(new.dblAlignment,0) != isnull(old.dblAlignment,0)
				or isnull(new.strApartment,'') != isnull(old.strApartment,'')
				or isnull(new.strBuilding,'') != isnull(old.strBuilding,'')
				or isnull(new.strStreetName,'') != isnull(old.strStreetName,'')
				or isnull(new.strHouse,'') != isnull(old.strHouse,'')
				or isnull(new.strPostCode,'') != isnull(old.strPostCode,'')
				or isnull(new.idfsResidentType,0) != isnull(old.idfsResidentType,0)
			)
		Where 
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
		Where 
			old.idfGeoLocationShared = @idfGeoLocation
			and
			(
				isnull(new.idfsGroundType,0) != isnull(old.idfsGroundType,0)
				or isnull(new.idfsGeoLocationType,0) != isnull(old.idfsGeoLocationType,0)
				or isnull(new.idfsCountry,0) != isnull(old.idfsCountry,0)
				or isnull(new.idfsRegion,0) != isnull(old.idfsRegion,0)
				or isnull(new.idfsRayon,0) != isnull(old.idfsRayon,0)
				or isnull(new.idfsSettlement,0) != isnull(old.idfsSettlement,0)
				or isnull(new.strDescription,'') != isnull(old.strDescription,'')
				or isnull(new.dblDistance,0) != isnull(old.dblDistance,0)
				or isnull(new.dblLatitude,0) != isnull(old.dblLatitude,0)
				or isnull(new.dblLongitude,0) != isnull(old.dblLongitude,0)
				or isnull(new.dblAccuracy,0) != isnull(old.dblAccuracy,0)
				or isnull(new.dblAlignment,0) != isnull(old.dblAlignment,0)
				or isnull(new.strApartment,'') != isnull(old.strApartment,'')
				or isnull(new.strBuilding,'') != isnull(old.strBuilding,'')
				or isnull(new.strStreetName,'') != isnull(old.strStreetName,'')
				or isnull(new.strHouse,'') != isnull(old.strHouse,'')
				or isnull(new.strPostCode,'') != isnull(old.strPostCode,'')
				or isnull(new.idfsResidentType,0) != isnull(old.idfsResidentType,0)
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
		Where 
			old.idfGeoLocationShared = @idfGeoLocation
			and
			(
				isnull(new.idfsGroundType,0) != isnull(old.idfsGroundType,0)
				or isnull(new.idfsGeoLocationType,0) != isnull(old.idfsGeoLocationType,0)
				or isnull(new.idfsCountry,0) != isnull(old.idfsCountry,0)
				or isnull(new.idfsRegion,0) != isnull(old.idfsRegion,0)
				or isnull(new.idfsRayon,0) != isnull(old.idfsRayon,0)
				or isnull(new.idfsSettlement,0) != isnull(old.idfsSettlement,0)
				or isnull(new.strDescription,'') != isnull(old.strDescription,'')
				or isnull(new.dblDistance,0) != isnull(old.dblDistance,0)
				or isnull(new.dblLatitude,0) != isnull(old.dblLatitude,0)
				or isnull(new.dblLongitude,0) != isnull(old.dblLongitude,0)
				or isnull(new.dblAccuracy,0) != isnull(old.dblAccuracy,0)
				or isnull(new.dblAlignment,0) != isnull(old.dblAlignment,0)
				or isnull(new.strApartment,'') != isnull(old.strApartment,'')
				or isnull(new.strBuilding,'') != isnull(old.strBuilding,'')
				or isnull(new.strStreetName,'') != isnull(old.strStreetName,'')
				or isnull(new.strHouse,'') != isnull(old.strHouse,'')
				or isnull(new.strPostCode,'') != isnull(old.strPostCode,'')
				or isnull(new.idfsResidentType,0) != isnull(old.idfsResidentType,0)
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



RETURN 0




