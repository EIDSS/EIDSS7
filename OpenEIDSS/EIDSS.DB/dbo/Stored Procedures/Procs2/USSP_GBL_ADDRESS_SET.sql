
--*************************************************************
-- Name 				: USSP_GBL_ADDRESS_SET
-- Description			: SET Address
--          
-- Author               : Harold Pryor
--                       Secondary stored proc with throw exception in catch block
--                        for proper handling by calling primary stored procedure 
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
CREATE PROCEDURE [dbo].[USSP_GBL_ADDRESS_SET]
(
	@idfGeoLocation			BIGINT OUTPUT,
	@idfsResidentType		BIGINT	= NULL,--
	@idfsGroundType			BIGINT = NULL,--
	@idfsGeolocationType	BIGINT = 10036001,
	@idfsCountry			BIGINT = NULL,
	@idfsRegion				BIGINT = NULL,
	@idfsRayon				BIGINT = NULL,
	@idfsSettlement			BIGINT = NULL,
	@strApartment			NVARCHAR(200) = NULL,
	@strBuilding			NVARCHAR(200) = NULL,
	@strStreetName			NVARCHAR(200) = NULL,
	@strHouse				NVARCHAR(200) = NULL,
	@strPostCode			NVARCHAR(200) = NULL,
	@strDescription			NVARCHAR(200) = NULL,
	@dblDistance			FLOAT = NULL, --
    @dblLatitude			FLOAT = NULL,--##PARAM dblLatitude - Latitude 
    @dblLongitude			FLOAT = NULL,--##PARAM dblLongitude  - Longitude 
	@dblAccuracy			FLOAT = NULL, --
	@dblAlignment			FLOAT = NULL, --
	@blnForeignAddress		BIT = 0,
	@strForeignAddress		NVARCHAR(200) = NULL,
	@blnGeoLocationShared	BIT = 0,
	@returnCode				INT = 0 OUTPUT,
	@returnMsg				NVARCHAR(max) = 'SUCCESS' OUTPUT
)
AS
DECLARE @strAddressString	NVARCHAR(max)
DECLARE @idfPostalCode		BIGINT
DECLARE @idfStreet			BIGINT

BEGIN
	BEGIN TRY
--		IF  @idfGeoLocation IS NULL RETURN-1;
		SET @returnCode =0
		SET @returnMsg = 'SUCCESS'

		
		IF @blnForeignAddress <> 0 AND @strStreetName IS NOT NULL
			BEGIN
				EXECUTE dbo.USP_GBL_STREET_SET @strStreetName, @idfsSettlement, @idfStreet OUTPUT , @returnCode OUTPUT, @returnMsg OUTPUT
			END
		IF @blnForeignAddress <> 0 AND @strPostCode IS NOT NULL
			BEGIN
				EXECUTE dbo.USP_GBL_POSTALCODE_SET @strPostCode, @idfsSettlement, @idfPostalCode OUTPUT ,@returnCode OUTPUT, @returnMsg OUTPUT
			END
		IF EXISTS(SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfGeoLocation)
			BEGIN
				UPDATE tlbGeoLocation
					SET 
						idfsResidentType = @idfsResidentType,
						idfsGroundType = @idfsGroundType,
						idfsGeoLocationType = @idfsGeolocationType --'lctAddress'
						,idfsCountry = @idfsCountry
						,idfsRegion = @idfsRegion
						,idfsRayon = @idfsRayon
						,strApartment = @strApartment
						,strDescription = @strDescription
						,dblDistance = @dblDistance
						,dblAccuracy = @dblAccuracy
						,dblAlignment = @dblAlignment 
						,strBuilding = @strBuilding
						,strStreetName = @strStreetName
						,strHouse = @strHouse
						,strPostCode = @strPostCode
						,idfsSettlement = @idfsSettlement
						,blnForeignAddress = ISNULL(@blnForeignAddress, 0)
						,strForeignAddress = @strForeignAddress
						,dblLatitude = @dblLatitude
						,dblLongitude = @dblLongitude
					WHERE 
						idfGeoLocation = @idfGeoLocation
						AND
						(
							ISNULL(idfsGeoLocationType,0) != 10036001 --'lctAddress'
							OR ISNULL(idfsCountry,0) != ISNULL(@idfsCountry,0)
							OR ISNULL(idfsRegion,0) != ISNULL(@idfsRegion,0)
							OR ISNULL(idfsRayon,0) != ISNULL(@idfsRayon,0)
							OR ISNULL(strApartment,'') != ISNULL(@strApartment,'')
							OR ISNULL(strBuilding,'') != ISNULL(@strBuilding,'')
							OR ISNULL(strStreetName,'') != ISNULL(@strStreetName,'')
							OR ISNULL(strHouse,'') != ISNULL(@strHouse,'')
							OR ISNULL(strPostCode,'') != ISNULL(@strPostCode,'')
							OR ISNULL(idfsSettlement,0) != ISNULL(@idfsSettlement,0)
							OR ISNULL(blnForeignAddress,0) != ISNULL(@blnForeignAddress,0)
							OR ISNULL(strForeignAddress,'') != ISNULL(@strForeignAddress,'')
							OR ISNULL(dblLatitude,0) != ISNULL(@dblLatitude,0)
							OR ISNULL(dblLongitude,0) != ISNULL(@dblLongitude,0)
						)
			END
		ELSE
			IF EXISTS(SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfGeoLocation)
				BEGIN
					UPDATE tlbGeoLocationShared
						SET 
							idfsResidentType = @idfsResidentType,
							idfsGroundType = @idfsGroundType,
							idfsGeoLocationType = 10036001 --'lctAddress'
							,idfsCountry = @idfsCountry
							,idfsRegion = @idfsRegion
							,idfsRayon = @idfsRayon
							,strApartment = @strApartment
							,strDescription = @strDescription
							,dblDistance = @dblDistance
							,dblAccuracy = @dblAccuracy
							,dblAlignment = @dblAlignment 
							,strBuilding = @strBuilding
							,strStreetName = @strStreetName
							,strHouse = @strHouse
							,strPostCode = @strPostCode
							,idfsSettlement = @idfsSettlement
							,blnForeignAddress = ISNULL(@blnForeignAddress, 0)
							,strForeignAddress = @strForeignAddress
							,dblLatitude = @dblLatitude
							,dblLongitude = @dblLongitude
						WHERE 
							idfGeoLocationShared = @idfGeoLocation
							AND
							(
								ISNULL(idfsGeoLocationType,0) != 10036001 --'lctAddress'
								OR ISNULL(idfsCountry,0) != ISNULL(@idfsCountry,0)
								OR ISNULL(idfsRegion,0) != ISNULL(@idfsRegion,0)
								OR ISNULL(idfsRayon,0) != ISNULL(@idfsRayon,0)
								OR ISNULL(strApartment,'') != ISNULL(@strApartment,'')
								OR ISNULL(strBuilding,'') != ISNULL(@strBuilding,'')
								OR ISNULL(strStreetName,'') != ISNULL(@strStreetName,'')
								OR ISNULL(strHouse,'') != ISNULL(@strHouse,'')
								OR ISNULL(strPostCode,'') != ISNULL(@strPostCode,'')
								OR ISNULL(idfsSettlement,0) != ISNULL(@idfsSettlement,0)
								OR ISNULL(blnForeignAddress,0) != ISNULL(@blnForeignAddress,0)
								OR ISNULL(strForeignAddress,'') != ISNULL(@strForeignAddress,'')
								OR ISNULL(dblLatitude,0) != ISNULL(@dblLatitude,0)
								OR ISNULL(dblLongitude,0) != ISNULL(@dblLongitude,0)
							)
				END
		ELSE
			IF ISNULL(@blnGeoLocationShared, 0) <> 1
				BEGIN
					EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbGeolocation', @idfGeoLocation OUTPUT
					INSERT INTO tlbGeoLocation
								(
								idfGeoLocation
								,idfsResidentType		
								,idfsGroundType
								,idfsGeoLocationType
								,idfsCountry
								,idfsRegion
								,idfsRayon
								,strDescription 
								,dblDistance 
								,dblAccuracy 
								,dblAlignment 
								,strApartment
								,strBuilding
								,strStreetName
								,strHouse
								,strPostCode
								,idfsSettlement					
								,blnForeignAddress
								,strForeignAddress
								,dblLatitude
								,dblLongitude
								)
							VALUES
								(
								@idfGeoLocation
								,@idfsResidentType		
								,@idfsGroundType
								,@idfsGeolocationType
								,@idfsCountry
								,@idfsRegion
								,@idfsRayon
								,@strDescription 
								,@dblDistance 
								,@dblAccuracy 
								,@dblAlignment 
								,@strApartment
								,@strBuilding
								,@strStreetName
								,@strHouse
								,@strPostCode
								,@idfsSettlement
								,ISNULL(@blnForeignAddress, 0)
								,@strForeignAddress
								,@dblLatitude
								,@dblLongitude
								)
				END
		ELSE	
			BEGIN
				EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbGeolocationShared', @idfGeoLocation OUTPUT
				INSERT INTO tlbGeoLocationShared
							(
							idfGeoLocationShared
							,idfsResidentType		
							,idfsGroundType
							,idfsGeoLocationType
							,idfsCountry
							,idfsRegion
							,idfsRayon
							,strDescription 
							,dblDistance 
							,dblAccuracy 
							,dblAlignment 
							,strApartment
							,strBuilding
							,strStreetName
							,strHouse
							,strPostCode
							,idfsSettlement
							,blnForeignAddress
							,strForeignAddress
							,dblLatitude
							,dblLongitude
							)
						VALUES
							(
							@idfGeoLocation
							,@idfsResidentType		
							,@idfsGroundType
							,@idfsGeolocationType
							,@idfsCountry
							,@idfsRegion
							,@idfsRayon
							,@strDescription 
							,@dblDistance 
							,@dblAccuracy 
							,@dblAlignment 
							,@strApartment
							,@strBuilding
							,@strStreetName
							,@strHouse
							,@strPostCode
							,@idfsSettlement
							,ISNULL(@blnForeignAddress, 0)
							,@strForeignAddress
							,@dblLatitude
							,@dblLongitude
							)
			END

			IF EXISTS	(
							SELECT	*
							FROM	tstSite s
							JOIN	tlbOffice o
							ON		o.idfOffice = s.idfOffice
							JOIN	tlbGeoLocationShared gls
							ON		gls.idfGeoLocationShared = o.idfLocation
							WHERE	s.intRowStatus = 0
									AND gls.idfGeoLocationShared = @idfGeoLocation
						)
			BEGIN
				DECLARE	@idfSiteGroup			BIGINT
				DECLARE	@idfSiteToSiteGroup		BIGINT
				DECLARE	@idfsSite				BIGINT
				DECLARE	@strSiteID				NVARCHAR(50)
				DECLARE	@idfSiteGroupNew		BIGINT
				DECLARE	@idfsSiteGroupRayon		BIGINT
				DECLARE	@strSiteGroupRayon		NVARCHAR(2000)

				SELECT		@idfSiteGroup = sg.idfSiteGroup,
							@idfsSiteGroupRayon = sg.idfsRayon,
							@strSiteGroupRayon = r_ray.[name],
							@idfsSite = s.idfsSite,
							@strSiteID = s.strSiteID
				FROM		tstSite s
				JOIN		tlbOffice o
				ON			o.idfOffice = s.idfOffice
				JOIN		tlbGeoLocationShared gls
				ON			gls.idfGeoLocationShared = o.idfLocation
				LEFT JOIN	tflSiteToSiteGroup s_to_sg
				JOIN		tflSiteGroup sg
				ON			sg.idfSiteGroup = s_to_sg.idfSiteGroup
				AND			sg.idfsRayon IS NOT NULL
				AND			sg.intRowStatus = 0
				JOIN		fnGisReference('en', 19000002)	r_ray	-- Rayon
				ON			r_ray.idfsReference = sg.idfsRayon
				ON			s_to_sg.idfsSite = s.idfsSite
				WHERE		s.intRowStatus = 0
				AND			gls.idfGeoLocationShared = @idfGeoLocation

				IF @idfSiteGroup IS NOT NULL AND @idfsSiteGroupRayon <> ISNULL(@idfsRayon, -1)
					BEGIN
	
						-- Groups of sites that belong to the same rayon
						DECLARE	@RayonSiteGroup	table
						(	idfID				int NOT NULL identity (1, 1) primary key,
							idfSiteGroup		BIGINT NULL,
							idfsRayon			BIGINT NULL,
							strRayon			NVARCHAR(2000) collate database_default NOT NULL,
							idfSiteToSiteGroup	BIGINT NULL,
							idfsSite			BIGINT NULL,
							strSiteID			NVARCHAR(50) collate database_default NOT NULL
						)
		
						INSERT INTO	@RayonSiteGroup
						(	idfsRayon,
							strRayon,
							idfsSite,
							strSiteID
						)
						SELECT	@idfsSiteGroupRayon,
								@strSiteGroupRayon,
								s_others.idfsSite,
								s_others.strSiteID
						FROM	tflSiteToSiteGroup s_to_sg_others
						JOIN	tstSite s_others
						ON		s_others.idfsSite = s_to_sg_others.idfsSite
								AND s_others.intRowStatus = 0
						WHERE	s_to_sg_others.idfSiteGroup = @idfSiteGroup


						UPDATE	tflSiteGroup
						SET		intRowStatus = 1
						WHERE	idfSiteGroup = @idfSiteGroup
								AND intRowStatus <> 1


						--EXECUTE dbo.USP_GBL_NEWID_GET @idfSiteGroupNew output
		
						SELECT @idfSiteGroupNew  = SCOPE_IDENTITY()

						UPDATE	@RayonSiteGroup
						SET		idfSiteGroup = @idfSiteGroupNew
		
		
						DELETE FROM	tflNewID WHERE	strTableName = N'tflSiteToSiteGroup'
					
						INSERT INTO	tflNewID
						(	strTableName,
							idfKey1,
							idfKey2
						)
						SELECT		N'tflSiteToSiteGroup',
									rsg.idfID,
									NULL
						FROM		@RayonSiteGroup rsg
						WHERE		rsg.idfsSite IS NOT NULL	-- Only for existing sites
									AND rsg.idfSiteGroup IS NOT NULL
									AND rsg.idfsRayon IS NOT NULL
									AND rsg.idfSiteToSiteGroup IS NULL


						UPDATE		rsg
						SET			rsg.idfSiteToSiteGroup = nID.[NewID]
						FROM		@RayonSiteGroup rsg
						INNER JOIN	tflNewID nID
						ON			nID.strTableName = N'tflSiteToSiteGroup'
									AND nID.idfKey1 = rsg.idfID
									AND nID.idfKey2 IS NULL
						WHERE		rsg.idfsSite IS NOT NULL	-- Only for existing sites
									AND rsg.idfSiteGroup IS NOT NULL
									AND rsg.idfSiteToSiteGroup IS NULL
									AND rsg.idfsRayon IS NOT NULL

						DELETE FROM	tflNewID WHERE	strTableName = N'tflSiteToSiteGroup'

						INSERT INTO	tflSiteGroup
						(	idfSiteGroup,
							strSiteGroupName,
							idfsCentralSite,
							idfsRayon,
							intRowStatus
						)
						SELECT		rsg.idfSiteGroup,
									N'Rayon [' + replace(rsg.strRayon, N'''', N'''''') + N']',
									NULL,
									rsg.idfsRayon,
									0
						FROM		@RayonSiteGroup rsg
						INNER JOIN	gisRayon ray
						ON			ray.idfsRayon = rsg.idfsRayon
						LEFT JOIN	@RayonSiteGroup rsg_min
						ON			rsg_min.idfsRayon = rsg.idfsRayon
									AND rsg_min.idfsSite IS NOT NULL	-- Only for existing sites
									AND rsg_min.idfSiteGroup IS NOT NULL
									AND rsg_min.idfID < rsg.idfID
						LEFT JOIN	tflSiteGroup sg_ex
						ON			sg_ex.idfSiteGroup = rsg.idfSiteGroup
						LEFT JOIN	tflSiteGroup sg_ray_ex
						ON			sg_ray_ex.idfsRayon = ray.idfsRayon
									AND sg_ray_ex.intRowStatus = 0
						WHERE		rsg.idfsSite IS NOT NULL	-- Only for existing sites
									AND rsg.idfSiteGroup IS NOT NULL
									AND rsg_min.idfID IS NULL
									AND sg_ex.idfSiteGroup IS NULL
									AND sg_ray_ex.idfSiteGroup IS NULL

						INSERT INTO	tflSiteToSiteGroup
						(	idfSiteToSiteGroup,
							idfSiteGroup,
							idfsSite,
							strSiteID
						)
						SELECT		rsg.idfSiteToSiteGroup,
									sg.idfSiteGroup,
									s.idfsSite,
									s.strSiteID
						FROM		@RayonSiteGroup rsg
						INNER JOIN	gisRayon ray
						ON			ray.idfsRayon = rsg.idfsRayon
						INNER JOIN	tflSiteGroup sg
						ON			sg.idfSiteGroup = rsg.idfSiteGroup
									AND sg.intRowStatus = 0
						INNER JOIN	tstSite s
						ON			s.idfsSite = rsg.idfsSite
									AND s.intRowStatus = 0
						LEFT JOIN	tflSiteToSiteGroup s_to_sg_ex
						ON			s_to_sg_ex.idfSiteToSiteGroup = rsg.idfSiteToSiteGroup
						LEFT JOIN	tflSiteToSiteGroup s_to_sg_unique_key_ex
						ON			s_to_sg_unique_key_ex.idfSiteGroup = sg.idfSiteGroup
									AND s_to_sg_unique_key_ex.strSiteID = s.strSiteID
						WHERE		s_to_sg_ex.idfSiteToSiteGroup IS NULL
									AND s_to_sg_unique_key_ex.idfSiteToSiteGroup IS NULL
				END

				SELECT	@idfSiteGroup = NULL,
						@idfsSiteGroupRayon = @idfsRayon,
						@strSiteGroupRayon = NULL

				SELECT	@strSiteGroupRayon = r_ray.[name]
				FROM	fnGisReference('en', 19000002)	r_ray	-- Rayon
				WHERE	r_ray.idfsReference = @idfsRayon

				SELECT		@idfSiteGroup = sg.idfSiteGroup,
							@idfSiteToSiteGroup = s_to_sg.idfSiteToSiteGroup
				FROM		tflSiteGroup sg
				LEFT JOIN	tflSiteToSiteGroup s_to_sg
				ON			s_to_sg.idfSiteGroup = sg.idfSiteGroup
							AND s_to_sg.idfsSite = @idfsSite
				WHERE		sg.intRowStatus = 0
							AND sg.idfsRayon IS NOT NULL
							AND sg.idfsRayon = @idfsRayon


				IF @idfsRayon IS NOT NULL AND @idfSiteToSiteGroup IS NULL
					BEGIN
						IF	@idfSiteGroup IS NULL
							BEGIN
								EXECUTE	dbo.USP_GBL_NEXTKEYID_GET 'tflSiteGroup', @idfSiteGroup output
			
								INSERT INTO	tflSiteGroup
								(	idfSiteGroup,
									strSiteGroupName,
									idfsCentralSite,
									idfsRayon,
									intRowStatus
								)
								SELECT	@idfSiteGroup,
										N'Rayon [' + replace(@strSiteGroupRayon, N'''', N'''''') + N']',
										NULL,
										@idfsSiteGroupRayon,
										0
							END

						EXECUTE	dbo.USP_GBL_NEXTKEYID_GET 'tflSiteToSiteGroup', @idfSiteToSiteGroup output
		
						INSERT INTO	tflSiteToSiteGroup
						(	idfSiteToSiteGroup,
							idfSiteGroup,
							idfsSite,
							strSiteID
						)
						SELECT		@idfSiteToSiteGroup,
									@idfSiteGroup,
									@idfsSite,
									@strSiteID

					END

		END

		SELECT @returnCode, @returnMsg
	END TRY
	BEGIN CATCH	         
			  THROW

			  SELECT @returnCode, @returnMsg
	END CATCH
END
