

--*************************************************************
-- Name 				: USP_GLB_LOC_Address_SET
-- Description			: Insert/Update Organization data
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--      JL         05/16/2018 change to valide function FN_GBL_DATACHANGE_INFO
--
-- Testing code:
--*************************************************************

CREATE PROCEDURE [dbo].[USP_GLB_LOC_Address_SET]
	(
	@idfGeoLocation			AS BIGINT
	,@idfsCountry			AS BIGINT
	,@idfsRegion			AS BIGINT
	,@idfsRayon				AS BIGINT
	,@idfsSettlement		AS BIGINT
	,@strApartment			AS NVARCHAR(200)
	,@strBuilding			AS NVARCHAR(200)
	,@strStreetName			AS NVARCHAR(200)
	,@strHouse				AS NVARCHAR(200)
	,@strPostCode			AS NVARCHAR(200)
	,@blnForeignAddress		AS BIT = 0
	,@strForeignAddress		AS NVARCHAR(200)
	,@dblLatitude			AS FLOAT = NULL		--##PARAM dblLatitude - Latitude 
	,@dblLongitude			AS FLOAT = NULL		--##PARAM dblLongitude  - Longitude 
	,@blnGeoLocationShared	AS BIT = 0
	,@User					VARCHAR(100) = NULL		--who required data change
	,@idfGeoLocationNewID	BIGINT OUTPUT			--return id
)

AS

	DECLARE @LogErrMsg VARCHAR(MAX)
	SELECT @LogErrMsg = ''

	BEGIN TRY  	

	IF (@idfGeoLocation IS NULL)

		BEGIN
			SELECT @idfGeoLocationNewID = -1
			SET @LogErrMsg = 'Error: Geo Locaton ID is not valid.' 
			SELECT @LogErrMsg 
				
			RETURN
		END

	ELSE

		BEGIN
		 
			/*
			MD: Should we be using XACT_STATE() 
				We can check this in the CATCH block
			*/
			BEGIN TRANSACTION

			----get data change date and user info: before app send final user 
			DECLARE @DataChageInfo AS NVARCHAR(MAX)

			/*
			MD: fnzDBdatachageDatePerson uses date format for US
				Do we need to localize it for country?
			*/

			SELECT @DataChageInfo = dbo.FN_GBL_DATACHANGE_INFO (@User)

			DECLARE @idfStreet BIGINT
			EXEC USP_GLB_LKUP_STREET_SET @strStreetName, @idfsSettlement, @User, @idfStreet OUTPUT

			DECLARE @idfPostalCode BIGINT
			EXEC USP_GLB_LKUP_POSTALCODE_SET @strPostCode, @idfsSettlement, @User, @idfPostalCode OUTPUT

			IF EXISTS(SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfGeoLocation)
				BEGIN
					UPDATE 
						tlbGeoLocation
					SET 
						idfsGeoLocationType = 10036001 --'lctAddress'
						,idfsCountry = CASE ISNULL(@idfsCountry, 0) WHEN 0 THEN idfsCountry ELSE @idfsCountry END
						,idfsRegion = CASE ISNULL(@idfsRegion, 0) WHEN 0 THEN idfsRegion ELSE @idfsRegion END
						,idfsRayon = CASE ISNULL(@idfsRayon, 0) WHEN 0 THEN idfsRayon ELSE @idfsRayon END
						,strApartment = CASE ISNULL(@strApartment, '') WHEN '' THEN strApartment ELSE @strApartment END
						,strBuilding = CASE ISNULL(@strBuilding, '') WHEN '' THEN strBuilding ELSE @strBuilding END
						,strStreetName = CASE ISNULL(@strStreetName, '') WHEN '' THEN strStreetName ELSE @strStreetName END
						,strHouse = CASE ISNULL(@strHouse, '') WHEN '' THEN strHouse ELSE @strHouse END
						,strPostCode = CASE ISNULL(@strPostCode, '') WHEN '' THEN strPostCode ELSE @strPostCode END
						,idfsSettlement = CASE ISNULL(@idfsSettlement, 0) WHEN 0 THEN idfsSettlement ELSE @idfsSettlement END
						,blnForeignAddress = CASE ISNULL(@blnForeignAddress, 0) WHEN 0 THEN blnForeignAddress ELSE @blnForeignAddress END
						,strForeignAddress = CASE ISNULL(@strForeignAddress, '') WHEN '' THEN strForeignAddress ELSE @strForeignAddress END
						,dblLatitude = CASE ISNULL(@dblLatitude, 0) WHEN 0 THEN dblLatitude ELSE @dblLatitude END
						,dblLongitude = CASE ISNULL(@dblLongitude, 0) WHEN 0 THEN dblLongitude ELSE @dblLongitude END
					WHERE 
						idfGeoLocation = @idfGeoLocation
				END
			ELSE
				BEGIN
					IF EXISTS(SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfGeoLocation)
						BEGIN
							UPDATE 
								tlbGeoLocationShared
							SET 
								idfsGeoLocationType = 10036001 --'lctAddress'
								,idfsCountry = @idfsCountry
								,idfsRegion = @idfsRegion
								,idfsRayon = @idfsRayon
								,strApartment = @strApartment
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
						END
					ELSE
						BEGIN
							IF ISNULL(@blnGeoLocationShared, 0) <> 1
								BEGIN
									INSERT INTO tlbGeoLocation
										(
										idfGeoLocation
										,idfsGeoLocationType
										,idfsCountry
										,idfsRegion
										,idfsRayon
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
											,10036001 --'lctAddress'
											,@idfsCountry
											,@idfsRegion
											,@idfsRayon
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
									INSERT INTO tlbGeoLocationShared
										(
										idfGeoLocationShared
										,idfsGeoLocationType
										,idfsCountry
										,idfsRegion
										,idfsRayon
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
										,10036001 --'lctAddress'
										,@idfsCountry
										,@idfsRegion
										,@idfsRayon
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
						END
				END

			IF EXISTS	(
						SELECT	
							*
						FROM
							tstSite
							JOIN tlbOffice ON
								tlbOffice.idfOffice = tstSite.idfOffice
							JOIN tlbGeoLocationShared ON
								tlbGeoLocationShared.idfGeoLocationShared = tlbOffice.idfLocation
						WHERE	
							tstSite.intRowStatus = 0
							AND
							tlbGeoLocationShared.idfGeoLocationShared = @idfGeoLocation
						)
				BEGIN

					DECLARE	@idfSiteGroup			bigint
					DECLARE	@idfSiteToSiteGroup		bigint
					DECLARE	@idfsSite				bigint
					DECLARE	@strSiteID				nvarchar(50)
					DECLARE	@idfSiteGroupNew		bigint
					DECLARE	@idfsSiteGroupRayon		bigint
					DECLARE	@strSiteGroupRayon		nvarchar(2000)

					SELECT
						@idfSiteGroup = tflSiteGroup.idfSiteGroup,
						@idfsSiteGroupRayon = tflSiteGroup.idfsRayon,
						@strSiteGroupRayon = Rayon.[name],
						@idfsSite = tstSite.idfsSite,
						@strSiteID = tstSite.strSiteID
					FROM
						tstSite
						JOIN tlbOffice ON
							tlbOffice.idfOffice = tstSite.idfOffice
						JOIN tlbGeoLocationShared ON
							tlbGeoLocationShared.idfGeoLocationShared = tlbOffice.idfLocation
						LEFT JOIN tflSiteToSiteGroup ON
							tflSiteToSiteGroup.idfsSite = tstSite.idfsSite
						JOIN tflSiteGroup ON
							tflSiteGroup.idfSiteGroup = tflSiteToSiteGroup.idfSiteGroup
							AND 
							tflSiteGroup.idfsRayon IS NOT NULL
							AND 
							tflSiteGroup.intRowStatus = 0
						JOIN fnGisReference('en', 19000002)	Rayon ON
							Rayon.idfsReference = tflSiteGroup.idfsRayon
					WHERE
						tstSite.intRowStatus = 0
						AND
						tlbGeoLocationShared.idfGeoLocationShared = @idfGeoLocation

					IF @idfSiteGroup IS NOT NULL AND @idfsSiteGroupRayon <> ISNULL(@idfsRayon, -1)
						BEGIN
	
							-- Groups of sites that belong to the same rayon
							DECLARE	@RayonSiteGroup	TABLE
							(	idfID				INT NOT NULL IDENTITY (1, 1) PRIMARY KEY
								,idfSiteGroup		BIGINT null
								,idfsRayon			BIGINT null
								,strRayon			NVARCHAR(2000) COLLATE DATABASE_DEFAULT NOT NULL
								,idfSiteToSiteGroup	BIGINT NULL
								,idfsSite			BIGINT NULL
								,strSiteID			NVARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL
							)
		
							INSERT INTO	@RayonSiteGroup
								(	
								idfsRayon
								,strRayon
								,idfsSite
								,strSiteID
								)
								SELECT	
									@idfsSiteGroupRayon,
									@strSiteGroupRayon,
									tstSite.idfsSite,
									tstSite.strSiteID
								FROM
									tflSiteToSiteGroup
									JOIN tstSite ON
										tstSite.idfsSite = tflSiteToSiteGroup.idfsSite
										AND 
										tstSite.intRowStatus = 0
								WHERE
									tflSiteToSiteGroup.idfSiteGroup = @idfSiteGroup


							UPDATE
								tflSiteGroup
							SET		
								intRowStatus = 1
							WHERE
								idfSiteGroup = @idfSiteGroup
								AND
								intRowStatus <> 1

							EXEC usp_sysGetNewID @idfSiteGroupNew OUTPUT
	
							UPDATE
								@RayonSiteGroup
							SET
								idfSiteGroup = @idfSiteGroupNew
		
							DELETE 
							FROM
								tflNewID 
							WHERE
								strTableName = N'tflSiteToSiteGroup'
					
							INSERT INTO	tflNewID
								(	
								strTableName
								,idfKey1
								,idfKey2
								)
								SELECT 
									N'tflSiteToSiteGroup',
									rsg.idfID,
									null
								FROM 
									@RayonSiteGroup rsg
								WHERE
									rsg.idfsSite IS NOT NULL	-- Only for existing sites
									AND
									rsg.idfSiteGroup IS NOT NULL
									AND
									rsg.idfsRayon IS NOT NULL
									AND
									rsg.idfSiteToSiteGroup IS NULL

							UPDATE
								rsg
							SET
								rsg.idfSiteToSiteGroup = nID.[NewID]
							FROM
								@RayonSiteGroup rsg
								INNER JOIN tflNewID nID ON
									nID.strTableName = N'tflSiteToSiteGroup'
									AND
									nID.idfKey1 = rsg.idfID
									AND
									nID.idfKey2 IS NULL
							WHERE
								rsg.idfsSite IS NOT NULL	-- Only for existing sites
								AND 
								rsg.idfSiteGroup IS NOT NULL
								AND 
								rsg.idfSiteToSiteGroup IS NULL
								AND 
								rsg.idfsRayon IS NOT NULL

							DELETE 
							FROM	
								tflNewID 
							WHERE 
								strTableName = N'tflSiteToSiteGroup'

							INSERT INTO
								tflSiteGroup
									(	
									idfSiteGroup
									,strSiteGroupName
									,idfsCentralSite
									,idfsRayon
									,intRowStatus
									)
									SELECT		
										rsg.idfSiteGroup
										,N'Rayon [' + replace(rsg.strRayon, N'''', N'''''') + N']'
										,null
										,rsg.idfsRayon
										,0
									FROM
										@RayonSiteGroup rsg
										INNER JOIN gisRayon ray ON
											ray.idfsRayon = rsg.idfsRayon
										LEFT JOIN @RayonSiteGroup rsg_min ON
											rsg_min.idfsRayon = rsg.idfsRayon
											AND 
											rsg_min.idfsSite IS NOT NULL	-- Only for existing sites
											AND 
											rsg_min.idfSiteGroup IS NOT NULL
											AND 
											rsg_min.idfID < rsg.idfID
										LEFT JOIN tflSiteGroup sg_ex ON
											sg_ex.idfSiteGroup = rsg.idfSiteGroup
										LEFT JOIN tflSiteGroup sg_ray_ex ON
											sg_ray_ex.idfsRayon = ray.idfsRayon
											AND 
											sg_ray_ex.intRowStatus = 0
									WHERE
										rsg.idfsSite IS NOT NULL	-- Only for existing sites
										AND
										rsg.idfSiteGroup IS NOT NULL
										AND 
										rsg_min.idfID IS NULL
										AND 
										sg_ex.idfSiteGroup IS NULL
										AND 
										sg_ray_ex.idfSiteGroup IS NULL

							INSERT INTO	
								tflSiteToSiteGroup
									(	
									idfSiteToSiteGroup
									,idfSiteGroup
									,idfsSite
									,strSiteID
									)
									SELECT
										rsg.idfSiteToSiteGroup,
										sg.idfSiteGroup,
										s.idfsSite,
										s.strSiteID
									FROM
										@RayonSiteGroup rsg
										INNER JOIN gisRayon ray ON
											ray.idfsRayon = rsg.idfsRayon
										INNER JOIN tflSiteGroup sg ON
											sg.idfSiteGroup = rsg.idfSiteGroup
											AND 
											sg.intRowStatus = 0
										INNER JOIN	tstSite s ON
											s.idfsSite = rsg.idfsSite
											AND 
											s.intRowStatus = 0
										LEFT JOIN tflSiteToSiteGroup s_to_sg_ex ON
											s_to_sg_ex.idfSiteToSiteGroup = rsg.idfSiteToSiteGroup
										LEFT JOIN tflSiteToSiteGroup s_to_sg_unique_key_ex ON
											s_to_sg_unique_key_ex.idfSiteGroup = sg.idfSiteGroup
											AND
											s_to_sg_unique_key_ex.strSiteID = s.strSiteID
									WHERE
										s_to_sg_ex.idfSiteToSiteGroup IS NULL
										AND 
										s_to_sg_unique_key_ex.idfSiteToSiteGroup IS NULL
						END

					SELECT
						@idfSiteGroup = null
						,@idfsSiteGroupRayon = @idfsRayon
						,@strSiteGroupRayon = null

					SELECT
						@strSiteGroupRayon = r_ray.[name]
					FROM
						fnGisReference('en', 19000002)	r_ray	-- Rayon
					WHERE
						r_ray.idfsReference = @idfsRayon

					SELECT
						@idfSiteGroup = sg.idfSiteGroup
						,@idfSiteToSiteGroup = s_to_sg.idfSiteToSiteGroup
					FROM
						tflSiteGroup sg
						LEFT JOIN tflSiteToSiteGroup s_to_sg ON
							s_to_sg.idfSiteGroup = sg.idfSiteGroup
							AND 
							s_to_sg.idfsSite = @idfsSite
					WHERE
						sg.intRowStatus = 0
						AND
						sg.idfsRayon IS NOT NULL
						AND 
						sg.idfsRayon = @idfsRayon


					IF @idfsRayon IS NOT NULL AND @idfSiteToSiteGroup IS NULL
						BEGIN
							IF	@idfSiteGroup IS NULL
								BEGIN
									EXEC usp_sysGetNewID @idfSiteGroup OUTPUT

									INSERT INTO	
										tflSiteGroup
										(	
										idfSiteGroup
										,strSiteGroupName
										,idfsCentralSite
										,idfsRayon
										,intRowStatus
										)
										SELECT	
											@idfSiteGroup
											,N'Rayon [' + REPLACE(@strSiteGroupRayon, N'''', N'''''') + N']'
											,NULL
											,@idfsSiteGroupRayon
											,0
								END

							EXEC usp_sysGetNewID @idfSiteToSiteGroup OUTPUT
		
							INSERT INTO	
								tflSiteToSiteGroup
								(	
								idfSiteToSiteGroup
								,idfSiteGroup
								,idfsSite
								,strSiteID
								)
								SELECT
									@idfSiteToSiteGroup
									,@idfSiteGroup
									,@idfsSite
									,@strSiteID

						END
				END

			COMMIT  

			--Return the Location ID
			SELECT @idfGeoLocationNewID = @idfGeoLocation

			SET @LogErrMsg='Success' 
			SELECT @LogErrMsg 
		END

	END TRY  

	BEGIN CATCH 

		-- Execute error retrieval routine. 
		IF @@TRANCOUNT = 0

			--MD: Not sure what to return. But we need a result set to be returned
			BEGIN
				
				SELECT @idfGeoLocationNewID = -1
				SET @LogErrMsg = '' 
				SELECT @LogErrMsg 
				
				RETURN
			END

		IF @@TRANCOUNT > 0

			BEGIN
				ROLLBACK

				SELECT @idfGeoLocationNewID = -1
				SET @LogErrMsg = 
					'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
					+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
					+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
					+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
					+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
					+ ' ErrorMessage: '+ ERROR_MESSAGE()

				SELECT @LogErrMsg
			END

	END CATCH; 


