

--##REMARKS UPDATED BY: Shatilova T.
--##REMARKS Date: 27.12.2011


CREATE         PROCEDURE [dbo].[spAddress_Post](
	@idfGeoLocation AS bigint,
	@idfsCountry AS  bigint,
	@idfsRegion AS  bigint,
	@idfsRayon AS  bigint,
	@idfsSettlement AS bigint,
	@strApartment AS NVARCHAR(200),
	@strBuilding AS NVARCHAR(200),
	@strStreetName AS NVARCHAR(200),
	@strHouse AS NVARCHAR(200),
	@strPostCode AS NVARCHAR(200),
	@blnForeignAddress AS BIT = 0,
	@strForeignAddress AS NVARCHAR(200)
    ,@dblLatitude as float = null--##PARAM dblLatitude - Latitude 
    ,@dblLongitude as float = null--##PARAM dblLongitude  - Longitude 
	,@blnGeoLocationShared AS BIT = 0
)
AS

	if @idfGeoLocation is null return -1;

EXEC spStreet_Post @strStreetName, @idfsSettlement
EXEC spPostalCode_Post @strPostCode, @idfsSettlement

IF EXISTS(SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfGeoLocation)
	UPDATE tlbGeoLocation
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
			idfGeoLocation = @idfGeoLocation
			and
			(
				isnull(idfsGeoLocationType,0) != 10036001 --'lctAddress'
				or isnull(idfsCountry,0) != isnull(@idfsCountry,0)
				or isnull(idfsRegion,0) != isnull(@idfsRegion,0)
				or isnull(idfsRayon,0) != isnull(@idfsRayon,0)
				or isnull(strApartment,'') != isnull(@strApartment,'')
				or isnull(strBuilding,'') != isnull(@strBuilding,'')
				or isnull(strStreetName,'') != isnull(@strStreetName,'')
				or isnull(strHouse,'') != isnull(@strHouse,'')
				or isnull(strPostCode,'') != isnull(@strPostCode,'')
				or isnull(idfsSettlement,0) != isnull(@idfsSettlement,0)
				or isnull(blnForeignAddress,0) != isnull(@blnForeignAddress,0)
				or isnull(strForeignAddress,'') != isnull(@strForeignAddress,'')
				or isnull(dblLatitude,0) != isnull(@dblLatitude,0)
				or isnull(dblLongitude,0) != isnull(@dblLongitude,0)
			)
ELSE
	IF EXISTS(SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfGeoLocation)
			UPDATE tlbGeoLocationShared
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
					and
					(
						isnull(idfsGeoLocationType,0) != 10036001 --'lctAddress'
						or isnull(idfsCountry,0) != isnull(@idfsCountry,0)
						or isnull(idfsRegion,0) != isnull(@idfsRegion,0)
						or isnull(idfsRayon,0) != isnull(@idfsRayon,0)
						or isnull(strApartment,'') != isnull(@strApartment,'')
						or isnull(strBuilding,'') != isnull(@strBuilding,'')
						or isnull(strStreetName,'') != isnull(@strStreetName,'')
						or isnull(strHouse,'') != isnull(@strHouse,'')
						or isnull(strPostCode,'') != isnull(@strPostCode,'')
						or isnull(idfsSettlement,0) != isnull(@idfsSettlement,0)
						or isnull(blnForeignAddress,0) != isnull(@blnForeignAddress,0)
						or isnull(strForeignAddress,'') != isnull(@strForeignAddress,'')
						or isnull(dblLatitude,0) != isnull(@dblLatitude,0)
						or isnull(dblLongitude,0) != isnull(@dblLongitude,0)
					)
ELSE
	IF ISNULL(@blnGeoLocationShared, 0) <> 1
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
ELSE	
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

IF EXISTS	(
		select	*
		from	tstSite s
		join	tlbOffice o
		on		o.idfOffice = s.idfOffice
		join	tlbGeoLocationShared gls
		on		gls.idfGeoLocationShared = o.idfLocation
		where	s.intRowStatus = 0
				and gls.idfGeoLocationShared = @idfGeoLocation
			)
BEGIN
	declare	@idfSiteGroup			bigint
	declare	@idfSiteToSiteGroup		bigint
	declare	@idfsSite				bigint
	declare	@strSiteID				nvarchar(50)
	declare	@idfSiteGroupNew		bigint
	declare	@idfsSiteGroupRayon		bigint
	declare	@strSiteGroupRayon		nvarchar(2000)

	select		@idfSiteGroup = sg.idfSiteGroup,
				@idfsSiteGroupRayon = sg.idfsRayon,
				@strSiteGroupRayon = r_ray.[name],
				@idfsSite = s.idfsSite,
				@strSiteID = s.strSiteID
	from		tstSite s
	join		tlbOffice o
	on			o.idfOffice = s.idfOffice
	join		tlbGeoLocationShared gls
	on			gls.idfGeoLocationShared = o.idfLocation
	left join	tflSiteToSiteGroup s_to_sg
		join	tflSiteGroup sg
		on			sg.idfSiteGroup = s_to_sg.idfSiteGroup
					and sg.idfsRayon is not null
					and sg.intRowStatus = 0
		join	fnGisReference('en', 19000002)	r_ray	-- Rayon
		on		r_ray.idfsReference = sg.idfsRayon
	on			s_to_sg.idfsSite = s.idfsSite
	where	s.intRowStatus = 0
			and gls.idfGeoLocationShared = @idfGeoLocation

	IF @idfSiteGroup is not null and @idfsSiteGroupRayon <> isnull(@idfsRayon, -1)
	BEGIN
	
		-- Groups of sites that belong to the same rayon
		declare	@RayonSiteGroup	table
		(	idfID				int not null identity (1, 1) primary key,
			idfSiteGroup		bigint null,
			idfsRayon			bigint null,
			strRayon			nvarchar(2000) collate database_default not null,
			idfSiteToSiteGroup	bigint null,
			idfsSite			bigint null,
			strSiteID			nvarchar(50) collate database_default not null
		)
		
		insert into	@RayonSiteGroup
		(	idfsRayon,
			strRayon,
			idfsSite,
			strSiteID
		)
		select	@idfsSiteGroupRayon,
				@strSiteGroupRayon,
				s_others.idfsSite,
				s_others.strSiteID
		from	tflSiteToSiteGroup s_to_sg_others
		join	tstSite s_others
		on		s_others.idfsSite = s_to_sg_others.idfsSite
				and s_others.intRowStatus = 0
		where	s_to_sg_others.idfSiteGroup = @idfSiteGroup


		update	tflSiteGroup
		set		intRowStatus = 1
		where	idfSiteGroup = @idfSiteGroup
				and intRowStatus <> 1


		execute spsysGetNewID @idfSiteGroupNew output
		
		update	@RayonSiteGroup
		set		idfSiteGroup = @idfSiteGroupNew
		
		
		delete from	tflNewID where	strTableName = N'tflSiteToSiteGroup'
					
		insert into	tflNewID
		(	strTableName,
			idfKey1,
			idfKey2
		)
		select		N'tflSiteToSiteGroup',
					rsg.idfID,
					null
		from		@RayonSiteGroup rsg
		where		rsg.idfsSite is not null	-- Only for existing sites
					and rsg.idfSiteGroup is not null
					and rsg.idfsRayon is not null
					and rsg.idfSiteToSiteGroup is null


		update		rsg
		set			rsg.idfSiteToSiteGroup = nID.[NewID]
		from		@RayonSiteGroup rsg
		inner join	tflNewID nID
		on			nID.strTableName = N'tflSiteToSiteGroup'
					and nID.idfKey1 = rsg.idfID
					and nID.idfKey2 is null
		where		rsg.idfsSite is not null	-- Only for existing sites
					and rsg.idfSiteGroup is not null
					and rsg.idfSiteToSiteGroup is null
					and rsg.idfsRayon is not null

		delete from	tflNewID where	strTableName = N'tflSiteToSiteGroup'

		insert into	tflSiteGroup
		(	idfSiteGroup,
			strSiteGroupName,
			idfsCentralSite,
			idfsRayon,
			intRowStatus
		)
		select		rsg.idfSiteGroup,
					N'Rayon [' + replace(rsg.strRayon, N'''', N'''''') + N']',
					null,
					rsg.idfsRayon,
					0
		from		@RayonSiteGroup rsg
		inner join	gisRayon ray
		on			ray.idfsRayon = rsg.idfsRayon
		left join	@RayonSiteGroup rsg_min
		on			rsg_min.idfsRayon = rsg.idfsRayon
					and rsg_min.idfsSite is not null	-- Only for existing sites
					and rsg_min.idfSiteGroup is not null
					and rsg_min.idfID < rsg.idfID
		left join	tflSiteGroup sg_ex
		on			sg_ex.idfSiteGroup = rsg.idfSiteGroup
		left join	tflSiteGroup sg_ray_ex
		on			sg_ray_ex.idfsRayon = ray.idfsRayon
					and sg_ray_ex.intRowStatus = 0
		where		rsg.idfsSite is not null	-- Only for existing sites
					and rsg.idfSiteGroup is not null
					and rsg_min.idfID is null
					and sg_ex.idfSiteGroup is null
					and sg_ray_ex.idfSiteGroup is null

		insert into	tflSiteToSiteGroup
		(	idfSiteToSiteGroup,
			idfSiteGroup,
			idfsSite,
			strSiteID
		)
		select		rsg.idfSiteToSiteGroup,
					sg.idfSiteGroup,
					s.idfsSite,
					s.strSiteID
		from		@RayonSiteGroup rsg
		inner join	gisRayon ray
		on			ray.idfsRayon = rsg.idfsRayon
		inner join	tflSiteGroup sg
		on			sg.idfSiteGroup = rsg.idfSiteGroup
					and sg.intRowStatus = 0
		inner join	tstSite s
		on			s.idfsSite = rsg.idfsSite
					and s.intRowStatus = 0
		left join	tflSiteToSiteGroup s_to_sg_ex
		on			s_to_sg_ex.idfSiteToSiteGroup = rsg.idfSiteToSiteGroup
		left join	tflSiteToSiteGroup s_to_sg_unique_key_ex
		on			s_to_sg_unique_key_ex.idfSiteGroup = sg.idfSiteGroup
					and s_to_sg_unique_key_ex.strSiteID = s.strSiteID
		where		s_to_sg_ex.idfSiteToSiteGroup is null
					and s_to_sg_unique_key_ex.idfSiteToSiteGroup is null
		
	END

	select	@idfSiteGroup = null,
			@idfsSiteGroupRayon = @idfsRayon,
			@strSiteGroupRayon = null

	select	@strSiteGroupRayon = r_ray.[name]
	from	fnGisReference('en', 19000002)	r_ray	-- Rayon
	where	r_ray.idfsReference = @idfsRayon

	select		@idfSiteGroup = sg.idfSiteGroup,
				@idfSiteToSiteGroup = s_to_sg.idfSiteToSiteGroup
	from		tflSiteGroup sg
	left join	tflSiteToSiteGroup s_to_sg
	on			s_to_sg.idfSiteGroup = sg.idfSiteGroup
				and s_to_sg.idfsSite = @idfsSite
	where		sg.intRowStatus = 0
				and sg.idfsRayon is not null
				and sg.idfsRayon = @idfsRayon


	IF @idfsRayon is not null and @idfSiteToSiteGroup is null
	BEGIN
		IF	@idfSiteGroup is null
		BEGIN
			execute	spsysGetNewID @idfSiteGroup output
			
			insert into	tflSiteGroup
			(	idfSiteGroup,
				strSiteGroupName,
				idfsCentralSite,
				idfsRayon,
				intRowStatus
			)
			select	@idfSiteGroup,
					N'Rayon [' + replace(@strSiteGroupRayon, N'''', N'''''') + N']',
					null,
					@idfsSiteGroupRayon,
					0
		END

		execute	spsysGetNewID @idfSiteToSiteGroup output
		
		insert into	tflSiteToSiteGroup
		(	idfSiteToSiteGroup,
			idfSiteGroup,
			idfsSite,
			strSiteID
		)
		select		@idfSiteToSiteGroup,
					@idfSiteGroup,
					@idfsSite,
					@strSiteID

	END

END

