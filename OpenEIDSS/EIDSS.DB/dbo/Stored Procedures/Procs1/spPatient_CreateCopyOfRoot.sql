

--##SUMMARY Creates a copy of the original human.
--##SUMMARY If the original human does not exist, no new entries will not be added.
--##SUMMARY If the human-copy does not exist, a new record will be created.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 26.01.2010

--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 08.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
declare	@idfHuman		bigint
declare	@idfRootHuman	bigint
declare	@idfCase		bigint

exec spPatient_CreateCopyOfRoot 
	 @idfHuman output
	,@idfRootHuman
*/


CREATE	procedure	[dbo].[spPatient_CreateCopyOfRoot]
(	 @idfHuman						bigint	output		--##PARAM @idfHuman Human Id
	,@idfRootHuman					bigint			--##PARAM @idfRootHuman Id of the original human (must be not null) (reference to tlbPartyActual)
	,@idfCase						bigint	= null	--##PARAM @idfCase Id of the case, for which this human is a patient (reference to tlbCase); this parameter could be not specified
)
as

if	exists	(
		select		*
		from		tlbHumanActual
		where		tlbHumanActual.idfHumanActual = @idfRootHuman
					and tlbHumanActual.intRowStatus = 0
			)
	and @idfHuman is not null
begin
	
	-- Update reference parameters related to tlbHuman
	declare	@idfsOccupationType				bigint
	declare	@idfsNationality				bigint
	declare	@idfsHumanGender				bigint
	declare	@idfRootCurrentResidenceAddress	bigint
	declare	@idfRootEmployerAddress			bigint
	declare	@idfRootRegistrationAddress		bigint
	declare	@datDateofBirth					datetime
	declare	@datDateOfDeath					datetime
	declare	@strLastName					nvarchar(200)
	declare	@strSecondName					nvarchar(200)
	declare	@strFirstName					nvarchar(200)
	declare	@strRegistrationPhone			nvarchar(200)
	declare	@strEmployerName				nvarchar(200)
	declare	@strHomePhone					nvarchar(200)
	declare	@strWorkPhone					nvarchar(200)

	declare	@idfCurrentResidenceAddress		bigint
	declare	@idfEmployerAddress				bigint
	declare	@idfRegistrationAddress			bigint

	select	@idfsOccupationType				= tlbHumanActual.idfsOccupationType,
			@idfsNationality				= tlbHumanActual.idfsNationality,
			@idfsHumanGender				= tlbHumanActual.idfsHumanGender,
			@idfRootCurrentResidenceAddress	= tlbHumanActual.idfCurrentResidenceAddress,
			@idfRootEmployerAddress			= tlbHumanActual.idfEmployerAddress,
			@idfRootRegistrationAddress		= tlbHumanActual.idfRegistrationAddress,
			@datDateofBirth					= tlbHumanActual.datDateofBirth,	
			@datDateOfDeath					= tlbHumanActual.datDateOfDeath,
			@strLastName					= tlbHumanActual.strLastName,
			@strSecondName					= tlbHumanActual.strSecondName,
			@strFirstName					= tlbHumanActual.strFirstName,
			@strRegistrationPhone			= tlbHumanActual.strRegistrationPhone,
			@strEmployerName				= tlbHumanActual.strEmployerName,
			@strHomePhone					= tlbHumanActual.strHomePhone,
			@strWorkPhone					= tlbHumanActual.strWorkPhone
	from	tlbHumanActual
	where	tlbHumanActual.idfHumanActual = @idfRootHuman

	if not exists	(
			select	*
			from	trtBaseReference OccupationType
			where	OccupationType.idfsBaseReference = @idfsOccupationType
					and OccupationType.idfsReferenceType = 19000061	-- rftOccupationType
					and OccupationType.intRowStatus = 0
					)
	begin
		set	@idfsOccupationType = null
	end

	if not exists	(
			select	*
			from	trtBaseReference Nationality
			where	Nationality.idfsBaseReference = @idfsNationality
					and Nationality.idfsReferenceType = 19000054	-- rftNationality
					and Nationality.intRowStatus = 0
					)
	begin
		set	@idfsNationality = null
	end

	if not exists	(
			select	*
			from	trtBaseReference HumanGender
			where	HumanGender.idfsBaseReference = @idfsHumanGender
					and HumanGender.idfsReferenceType = 19000043	-- rftHumanGender
					and HumanGender.intRowStatus = 0
					)
	begin
		set	@idfsHumanGender = null
	end

	-- Get id for idfCurrentResidenceAddress
	set	@idfCurrentResidenceAddress = null
	select		@idfCurrentResidenceAddress	= tlbGeoLocation.idfGeoLocation
	from		tlbHuman
	inner join	tlbGeoLocation
	on			tlbGeoLocation.idfGeoLocation = tlbHuman.idfCurrentResidenceAddress
				and tlbGeoLocation.intRowStatus = 0
	where		tlbHuman.idfHuman = @idfHuman

	if @idfRootCurrentResidenceAddress is null
		set	@idfCurrentResidenceAddress = null
	else if @idfCurrentResidenceAddress is null
		exec spsysGetNewID @idfCurrentResidenceAddress output

	-- Get id for idfEmployerAddress
	set	@idfEmployerAddress = null
	select		@idfEmployerAddress	= tlbGeoLocation.idfGeoLocation
	from		tlbHuman
	inner join	tlbGeoLocation
	on			tlbGeoLocation.idfGeoLocation = tlbHuman.idfEmployerAddress
				and tlbGeoLocation.intRowStatus = 0
	where		tlbHuman.idfHuman = @idfHuman

	if @idfRootEmployerAddress is null
		set	@idfEmployerAddress = null
	else if @idfEmployerAddress is null
		exec spsysGetNewID @idfEmployerAddress output

	-- Get id for idfRegistrationAddress
	set	@idfRegistrationAddress = null
	select		@idfRegistrationAddress	= tlbGeoLocation.idfGeoLocation
	from		tlbHuman
	inner join	tlbGeoLocation
	on			tlbGeoLocation.idfGeoLocation = tlbHuman.idfRegistrationAddress
				and tlbGeoLocation.intRowStatus = 0
	where		tlbHuman.idfHuman = @idfHuman

	if @idfRootRegistrationAddress is null
		set	@idfRegistrationAddress = null
	else if @idfRegistrationAddress is null
		exec spsysGetNewID @idfRegistrationAddress output

	-- Copy addresses for the copy of the root human
	if @idfCurrentResidenceAddress is not null
		exec spGeoLocation_CreateCopy	
				@idfRootCurrentResidenceAddress,
				@idfCurrentResidenceAddress

	if @idfEmployerAddress is not null
		exec spGeoLocation_CreateCopy	
				@idfRootEmployerAddress,
				@idfEmployerAddress

	if @idfRegistrationAddress is not null
		exec spGeoLocation_CreateCopy	
				@idfRootRegistrationAddress,
				@idfRegistrationAddress

	-- Post tlbHuman
	if exists	(
		select	*
		from	tlbHuman
		where	idfHuman = @idfHuman
				)
	begin
		update	tlbHuman
		set		idfHumanActual				=	@idfRootHuman,
				idfsOccupationType			=	@idfsOccupationType,
				idfsNationality				=	@idfsNationality,
				idfsHumanGender				=	@idfsHumanGender,
				idfCurrentResidenceAddress	=	@idfCurrentResidenceAddress,
				idfEmployerAddress			=	@idfEmployerAddress,
				idfRegistrationAddress		=	@idfRegistrationAddress,
				datDateofBirth				=	@datDateofBirth,
				datDateOfDeath				=	@datDateOfDeath,
				strLastName					=	@strLastName,
				strSecondName				=	@strSecondName,
				strFirstName				=	@strFirstName,
				strRegistrationPhone		=	@strRegistrationPhone,
				strEmployerName				=	@strEmployerName,
				strHomePhone				=	@strHomePhone,
				strWorkPhone				=	@strWorkPhone				

		where	idfHuman = @idfHuman
	end
	else begin
		insert into	tlbHuman
		(	idfHuman,
			idfHumanActual,
			idfsOccupationType,
			idfsNationality,
			idfsHumanGender,
			idfCurrentResidenceAddress,
			idfEmployerAddress,
			idfRegistrationAddress,
			datDateofBirth,
			datDateOfDeath,
			strLastName,
			strSecondName,
			strFirstName,
			strRegistrationPhone,
			strEmployerName,
			strHomePhone,
			strWorkPhone
			
		)
		values
		(	@idfHuman,
			@idfRootHuman,
			@idfsOccupationType,
			@idfsNationality,
			@idfsHumanGender,
			@idfCurrentResidenceAddress,
			@idfEmployerAddress,
			@idfRegistrationAddress,
			@datDateofBirth,
			@datDateOfDeath,
			@strLastName,
			@strSecondName,
			@strFirstName,
			@strRegistrationPhone,
			@strEmployerName,
			@strHomePhone,
			@strWorkPhone
		)
	end
	
	---- Update case
	update		tlbHumanCase
	set			tlbHumanCase.idfHuman = @idfHuman
	from		tlbHumanCase 
	where		tlbHumanCase.idfHumanCase = @idfCase
				and tlbHumanCase.intRowStatus = 0

end


