
--##SUMMARY Copies information from tlbHuman into tlbHumanActual.
--##SUMMARY If @idfHumanActual is null or record with @idfHumanActual doesn't exist in tlbHumanActual, new record is created in tlbHumanActual.

--##REMARKS Author: Zurin M.
--##REMARKS Update date: 07.07.2015

--##RETURNS 0 if information was copied
--##RETURNS -1 if source record in tlbHuman doesn't exist  
/*
 begin tran
 declare @idfHuman bigint
 declare @idfHumanActual bigint
 select Top 1 @idfHuman = idfHuman from tlbHuman
 exec spHuman_CopyToHumanActual @idfHuman, @idfHumanActual out
 select * from tlbHuman where idfHuman = @idfHuman
 select * from tlbHumanActual where idfHumanActual = @idfHumanActual
 select g.* from tlbGeoLocationShared g inner join tlbHumanActual ha on ha.idfCurrentResidenceAddress = g.idfGeoLocationShared
 where ha.idfHumanActual = @idfHumanActual
 select g.* from tlbGeoLocationShared g inner join tlbHumanActual ha on ha.idfEmployerAddress = g.idfGeoLocationShared
 where ha.idfHumanActual = @idfHumanActual
 select g.* from tlbGeoLocationShared g inner join tlbHumanActual ha on ha.idfRegistrationAddress = g.idfGeoLocationShared
 where ha.idfHumanActual = @idfHumanActual

 rollback tran
*/
   

CREATE PROCEDURE [dbo].[spHuman_CopyToHumanActual]
	 @idfHuman			bigint			    --##PARAM @idfHuman Human Id
	,@idfHumanActual	bigint = null out	--##PARAM @idfHumanActual Id of the original human (must be null for original human) (reference to tlbParty)
AS

	declare	@idfCurrentResidenceAddress	bigint	
	declare	@idfEmployerAddress			bigint
	declare	@idfRegistrationAddress		bigint

	select 
		@idfCurrentResidenceAddress= idfCurrentResidenceAddress 
		,@idfEmployerAddress = idfEmployerAddress
		,@idfRegistrationAddress = idfRegistrationAddress
	from tlbHuman where idfHuman = @idfHuman

	if @@ROWCOUNT = 0
		return -1

	if @idfHumanActual is null
		exec spsysGetNewID @idfHumanActual output

	declare	@idfRootCurrentResidenceAddress bigint
	declare	@idfRootEmployerAddress			bigint
	declare	@idfRootRegistrationAddress		bigint

	-- Get id for root idfCurrentResidenceAddress
	set	@idfRootCurrentResidenceAddress = null
	select		@idfRootCurrentResidenceAddress	= tlbHumanActual.idfCurrentResidenceAddress
	from		tlbHumanActual
	where		tlbHumanActual.idfHumanActual = @idfHumanActual

	if @idfRootCurrentResidenceAddress is null and not @idfCurrentResidenceAddress is null
		exec spsysGetNewID @idfRootCurrentResidenceAddress output

	-- Get id for root idfEmployerAddress
	set	@idfRootEmployerAddress = null
	select		@idfRootEmployerAddress	= tlbHumanActual.idfEmployerAddress
	from		tlbHumanActual
	where		tlbHumanActual.idfHumanActual = @idfHumanActual

	if @idfRootEmployerAddress is null and not @idfEmployerAddress is null
		exec spsysGetNewID @idfRootEmployerAddress output

	-- Get id for root idfRegistrationAddress
	set	@idfRootRegistrationAddress = null
	select		@idfRootRegistrationAddress	= tlbHumanActual.idfRegistrationAddress
	from		tlbHumanActual
	where		tlbHumanActual.idfHumanActual = @idfHumanActual

	if @idfRootRegistrationAddress is null and not @idfRegistrationAddress is null
		exec spsysGetNewID @idfRootRegistrationAddress output

	-- Copy addresses for root human
	exec spGeoLocation_CreateCopy	
			@idfCurrentResidenceAddress,
			@idfRootCurrentResidenceAddress,
			1

	exec spGeoLocation_CreateCopy	
			@idfEmployerAddress,
			@idfRootEmployerAddress,
			1

	exec spGeoLocation_CreateCopy	
			@idfRegistrationAddress,
			@idfRootRegistrationAddress,
			1

	if exists	(
		select	*
		from	tlbHumanActual
		where	idfHumanActual = @idfHumanActual
				)
	begin
		update	tlbHumanActual 
		set		idfsOccupationType			=	h.idfsOccupationType,
				idfsNationality				=	h.idfsNationality,
				idfsHumanGender				=	h.idfsHumanGender,
				idfCurrentResidenceAddress	=	@idfRootCurrentResidenceAddress,
				idfEmployerAddress			=	@idfRootEmployerAddress,
				idfRegistrationAddress		=	@idfRootRegistrationAddress,
				datDateofBirth				=	h.datDateofBirth,
				datDateOfDeath				=	h.datDateOfDeath,
				strLastName					=	h.strLastName,
				strSecondName				=	h.strSecondName,
				strFirstName				=	h.strFirstName,
				strRegistrationPhone		=	h.strRegistrationPhone,
				strEmployerName				=	h.strEmployerName,
				strHomePhone				=	h.strHomePhone,
				strWorkPhone				=	h.strWorkPhone,				
				idfsPersonIDType			=	h.idfsPersonIDType,
				strPersonID					=	h.strPersonID
				,datModificationDate		=	h.datModificationDate
		from tlbHumanActual ha
			inner join tlbHuman h on h.idfHumanActual = ha.idfHumanActual
		where	ha.idfHumanActual = @idfHumanActual
	end
	else 
	 begin
		insert into	tlbHumanActual
		(	idfHumanActual,
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
			strWorkPhone,
			idfsPersonIDType,
			strPersonID
			,datEnteredDate
			,datModificationDate
			
		)
	 select
			@idfHumanActual,
			idfsOccupationType,
			idfsNationality,
			idfsHumanGender,
			@idfRootCurrentResidenceAddress,
			@idfRootEmployerAddress,
			@idfRootRegistrationAddress,
			datDateofBirth,
			datDateOfDeath,
			strLastName,
			strSecondName,
			strFirstName,
			strRegistrationPhone,
			strEmployerName,
			strHomePhone,
			strWorkPhone,
			idfsPersonIDType,
			strPersonID,
			datEnteredDate,
			datModificationDate
	from tlbHuman
	where idfHuman = @idfHuman
	
	end
	
	update tlbHuman
	set idfHumanActual = @idfHumanActual
	where 
		idfHuman = @idfHuman 
		and idfHumanActual <> @idfHumanActual

RETURN 0

