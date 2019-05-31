
--##SUMMARY Saves geolocation data for ExactPoint and RelativePoint geolocation types.
--##SUMMARY It doesn't delete geolocation record because it is assumed that it should be deleted with parent object only
--##SUMMARY Used by LocationLookup and ExactGeolocationLookup controls to post data
--##SUMMARY All parameter names in this procedure must coincide with column names returned by spGeoLocation_SelectLookup procedure
--##SUMMARY for automatic posting from bv framework

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 07.11.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 15.08.2011

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
DECLARE @idfGeoLocation bigint
DECLARE @idfsGroundType bigint
DECLARE @idfsGeoLocationType bigint
DECLARE @idfsCountry bigint
DECLARE @idfsRegion bigint
DECLARE @idfsRayon bigint
DECLARE @idfsSettlement bigint
DECLARE @strDescription nvarchar(200)
DECLARE @dblDistance float
DECLARE @dblLatitude float
DECLARE @dblLongitude float
DECLARE @dblAccuracy float
DECLARE @dblAlignment float
declare @blnGeoLocationShared bit

-- TODO: Set parameter values here.

EXECUTE dbo.spGeoLocation_Post
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


CREATE         PROCEDURE [dbo].[spGeoLocation_Post](
	   @idfGeoLocation as bigint --##PARAM idfGeoLocation - ID of geolocation record
      ,@idfsGroundType as bigint --##PARAM idfsGroundType - ID of ground Type for relative location
      ,@idfsGeoLocationType as bigint --##PARAM idfsGeoLocationType - ID geolocation Type (can point to ExactPoint or Relative geolocation Type
      ,@idfsCountry as bigint --##PARAM idfsCountry - ID of country
      ,@idfsRegion as bigint --##PARAM idfsRegion - ID of region
      ,@idfsRayon as bigint --##PARAM idfsRayon - ID rayon
      ,@idfsSettlement as bigint --##PARAM idfsSettlement - ID of settlement (for Relative location only)
      ,@strDescription as nvarchar(200) --##PARAM strDescription - free text description of reolocation record
      ,@dblLatitude as float --##PARAM dblLatitude - Latitude (for ExactPoint location only)
      ,@dblLongitude as float --##PARAM dblLongitude  - Longitude (for ExactPoint location only)
      ,@dblRelLatitude as float --##PARAM dblRelLatitude - calcualted Latitude (for RelativePoint location only)
      ,@dblRelLongitude as float --##PARAM dblRelLongitude  - calcualted Longitude (for RelativePoint location only)
      ,@dblAccuracy as float --##PARAM dblAccuracy - Accuracy of all other numeric data in the geolocation record
      ,@dblDistance as float --##PARAM dblDistance - distance (in kilometers) from settlement to relative point (for Relative location only)
      ,@dblAlignment as float --##PARAM dblAlignment - azimuth (in degrees) of direction from settlement to relative point(for Relative location only)
      ,@strForeignAddress as nvarchar(200)
      ,@blnGeoLocationShared AS BIT = 0
)
AS

	if @idfGeoLocation is null return -1;

IF EXISTS(SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfGeoLocation)
	UPDATE [dbo].[tlbGeoLocation]
	SET 
		[idfsGroundType] = @idfsGroundType
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
	 WHERE 
		idfGeoLocation = @idfGeoLocation
		and
		(
			isnull([idfsGroundType],0) != isnull(@idfsGroundType,0)
			or isnull([idfsGeoLocationType],0) != isnull(@idfsGeoLocationType,0)
			or isnull([idfsCountry],0) != isnull(@idfsCountry,0)
			or isnull([idfsRegion],0) != isnull(@idfsRegion,0)
			or isnull([idfsRayon],0) != isnull(@idfsRayon,0)
			or isnull([idfsSettlement],0) != isnull(@idfsSettlement,0)
			or isnull([strDescription],'') != isnull(@strDescription,'')
			or isnull([dblDistance],0) != isnull(@dblDistance,0)
			or isnull([dblLatitude],0) != isnull(CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLatitude ELSE @dblRelLatitude END,0)
			or isnull([dblLongitude],0) != isnull(CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLongitude ELSE @dblRelLongitude END,0)
			or isnull([dblAccuracy],0) != isnull(@dblAccuracy,0)
			or isnull([dblAlignment],0) != isnull(@dblAlignment,0)
			or isnull(strForeignAddress,0) != isnull(@strForeignAddress,0)
		)
ELSE
	IF EXISTS(SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfGeoLocation)
		UPDATE [dbo].[tlbGeoLocationShared]
		SET 
			[idfsGroundType] = @idfsGroundType
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
		 WHERE 
			idfGeoLocationShared = @idfGeoLocation
			and
			(
				isnull([idfsGroundType],0) != isnull(@idfsGroundType,0)
				or isnull([idfsGeoLocationType],0) != isnull(@idfsGeoLocationType,0)
				or isnull([idfsCountry],0) != isnull(@idfsCountry,0)
				or isnull([idfsRegion],0) != isnull(@idfsRegion,0)
				or isnull([idfsRayon],0) != isnull(@idfsRayon,0)
				or isnull([idfsSettlement],0) != isnull(@idfsSettlement,0)
				or isnull([strDescription],'') != isnull(@strDescription,'')
				or isnull([dblDistance],0) != isnull(@dblDistance,0)
				or isnull([dblLatitude],0) != isnull(CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLatitude ELSE @dblRelLatitude END,0)
				or isnull([dblLongitude],0) != isnull(CASE WHEN @idfsGeoLocationType = 10036003 THEN @dblLongitude ELSE @dblRelLongitude END,0)
				or isnull([dblAccuracy],0) != isnull(@dblAccuracy,0)
				or isnull([dblAlignment],0) != isnull(@dblAlignment,0)
				or isnull(strForeignAddress,0) != isnull(@strForeignAddress,0)
			)
ELSE
	IF ISNULL(@blnGeoLocationShared, 0) <> 1
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
ELSE	
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








